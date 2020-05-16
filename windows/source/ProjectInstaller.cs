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
            registry.fastStartUp(true);

            registry.criticalBatteryNotificationAction(true);

            registry.criticalBatteryNotificationLevel(true);

            registry.systemSleepTimeout(true, 0);
            registry.systemSleepTimeout(true, 1);

            registry.turnOffHardDisk(true, 0);
            registry.turnOffHardDisk(true, 1);

            registry.hibernateTimeout(true, 0);
            registry.hibernateTimeout(true, 1);
               

            var conf = new serviceConfig();

            conf.getServiceSettingsXml();

            if (conf.errorMsg != null)
            {
                appHelper.WriteLog(conf.errorMsg);
            }

            appHelper.shutdownPowerShellScript(true, conf);

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

            deleteOldAppInfoFileIfExists(conf);
        }

        private void serviceProcessInstaller1_AfterInstall(object sender, InstallEventArgs e)
        {

        }

        private void serviceInstaller1_AfterInstall(object sender, InstallEventArgs e)
        {
            var serviceInstaller = (ServiceInstaller)sender;

            var rootVagrantInstallPath = Context.Parameters["rootVagrantInstallPath"];
            var logsPath = Context.Parameters["logsPath"];
            var facilityName = Context.Parameters["facilityName"];

            var conf = new serviceConfig();

            bool checkVagrantSettingsDone = conf.installerSetServiceSettingsXml(rootVagrantInstallPath, logsPath, facilityName);

            if (conf.errorMsg != null)
            {
                appHelper.WriteLog(conf.errorMsg);
            }

            if (!checkVagrantSettingsDone)
                throw new System.Exception("Unable to update the serviceConfig.xml file");

            if (!registry.fastStartUp(false))
                throw new System.Exception("Unable to turn off windows fast boot!");

            if (!registry.criticalBatteryNotificationAction(false))
                throw new System.Exception("Unable to turn on critical battery notification action!");

            if (!registry.criticalBatteryNotificationLevel(false))
                throw new System.Exception("Unable to turn on critical battery notification level!");

            if (!registry.systemSleepTimeout(false, 0))
                throw new System.Exception("Unable to set system sleep timeout to never for when on battery!");

            if (!registry.systemSleepTimeout(false, 1))
                throw new System.Exception("Unable to set system sleep timeout to never for when plugged in!");

            if (!registry.turnOffHardDisk(false, 0))
                throw new System.Exception("Unable to set when Windows can turn off the hard disk for when on battery!");

            if (!registry.turnOffHardDisk(false, 1))
                throw new System.Exception("Unable to set when Windows can turn off the hard disk for when plugged in!");

            if (!registry.hibernateTimeout(false, 0))
                throw new System.Exception("Unable to set hibernate timeout to never for when on battery!");

            if (!registry.hibernateTimeout(false, 1))
                throw new System.Exception("Unable to set hibernate timeout to never for when plugged in!");

            if (!appHelper.processFiles(rootVagrantInstallPath))
                throw new System.Exception("Unable to copy one or more Vagrant script files from the source directory to the Vagrant root directory!");

            conf.getServiceSettingsXml();

            if (!appHelper.shutdownPowerShellScript(false, conf))
                throw new System.Exception("Unable to add the shutdown script!");

            deleteOldAppInfoFileIfExists(conf);

            appHelper.encryptSecret();

            using (var sc = new ServiceController(serviceInstaller.ServiceName))
            {
                sc.Start();
            }
        }

        private void deleteOldAppInfoFileIfExists(serviceConfig sc)
        {
            var filepath = sc.executionDirectory + @"\" + appHelper.APP_INFO + ".txt";

            if (File.Exists(filepath))
            {
                File.Delete(filepath);
            }
        }
    }
}
