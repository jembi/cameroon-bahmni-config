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

            if (!appHelper.disableFastStartUp(false))
                throw new System.Exception("Unable to turn on windows fast boot!");
        }

        private void serviceProcessInstaller1_AfterInstall(object sender, InstallEventArgs e)
        {

        }

        private void serviceInstaller1_AfterInstall(object sender, InstallEventArgs e)
        {
            var rootVagrantInstallPath = Context.Parameters["rootVagrantInstallPath"];
            var vagrantVmName = Context.Parameters["vmName"];
            var logsPath = Context.Parameters["logsPath"];

            var conf = new serviceConfig();

            bool checkVagrantSettingsDone = conf.installerSetServiceSettingsXml(rootVagrantInstallPath, vagrantVmName, logsPath);

            if (conf.errorMsg != null)
            {
                appHelper.WriteLog(conf.errorMsg);
            }

            if (!checkVagrantSettingsDone)
                throw new System.Exception("Unable to update the serviceConfig.xml file");

            if (!appHelper.disableFastStartUp(true))
                throw new System.Exception("Unable to turn off windows fast boot!");

            if (!appHelper.processFiles(rootVagrantInstallPath))
                throw new System.Exception("Unable to copy one or more Vagrant script files from the source directory to the Vagrant root directory!");

            var serviceInstaller = (ServiceInstaller)sender;

            using (var sc = new ServiceController(serviceInstaller.ServiceName))
            {
                sc.Start();
            }
        }
    }
}
