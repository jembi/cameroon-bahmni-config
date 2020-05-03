using System;
using System.IO;
using System.Collections;
using System.ComponentModel;
using System.Configuration.Install;
using System.ServiceProcess;

namespace Bahmni
{
    [RunInstaller(true)]
    public partial class ProjectInstaller : System.Configuration.Install.Installer
    {
        public ProjectInstaller()
        {
            InitializeComponent();
        }

        public override void Install(IDictionary stateSaver)
        {
            base.Install(stateSaver);
        }

        protected override void OnBeforeUninstall(IDictionary savedState)
        {
            registry.fastStartUp(false);

            registry.criticalBatteryNotificationAction(true);

            registry.criticalBatteryNotificationLevel(true);

            var conf = new serviceConfig();

            conf.getServiceSettingsXml();

            if (conf.errorMsg != null)
            {
                appHelper.WriteLog(conf.errorMsg);
            }

            registry.shutdownPowerShellScript(true, conf);

            try
            {
                using (var sv = new ServiceController(serviceInstaller1.ServiceName))
                {
                    if (sv.Status != ServiceControllerStatus.Stopped)
                    {
                        sv.Stop();
                        sv.WaitForStatus(ServiceControllerStatus.Stopped);
                    }
                }

                appHelper.WriteLog("The Bahmni service has been uninstalled. Please power on Vagrant using \"vagrant up\"");
            }
            catch (Exception error)
            {
                appHelper.WriteLog("The Bahmni service failed to gracefully stop during the uninstallation! " + error.Message);
            }
            finally
            {
                base.OnBeforeUninstall(savedState);
            }
        }

        private void serviceProcessInstaller1_AfterInstall(object sender, InstallEventArgs e)
        {

        }

        private void serviceInstaller1_AfterInstall(object sender, InstallEventArgs e)
        {
            var serviceInstaller = (ServiceInstaller)sender;

            var rootVagrantInstallPath = Context.Parameters["rootVagrantInstallPath"];
            var logsPath = Context.Parameters["logsPath"];

            var conf = new serviceConfig();

            bool checkVagrantSettingsDone = conf.installerSetServiceSettingsXml(rootVagrantInstallPath, logsPath);

            if (conf.errorMsg != null)
            {
                appHelper.WriteLog(conf.errorMsg);
            }

            if (!checkVagrantSettingsDone)
                throw new System.Exception("Unable to update the serviceConfig.xml file");

            if (!registry.fastStartUp(true))
                throw new System.Exception("Unable to turn off windows fast boot!");

            if (!registry.criticalBatteryNotificationAction(false))
                throw new System.Exception("Unable to turn on critical battery notification action!");

            if (!registry.criticalBatteryNotificationLevel(false))
                throw new System.Exception("Unable to turn on critical battery notification level!");

            if (!appHelper.processFiles(rootVagrantInstallPath))
                throw new System.Exception("Unable to copy one or more Vagrant script files from the source directory to the Vagrant root directory!");

            conf.getServiceSettingsXml();

            if (!registry.shutdownPowerShellScript(false, conf))
                throw new System.Exception("Unable to add the shutdown script!");

            using (var sc = new ServiceController(serviceInstaller.ServiceName))
            {
                sc.Start();
            }
        }
    }
}
