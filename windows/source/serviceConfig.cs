using System;
using System.IO;
using System.Linq;
using System.Xml.Linq;
using System.Reflection;

namespace Bahmni
{
    public class serviceConfig
    {
        public string logsPath { get; set; }
        public int timerIntervalMins { get; set; }
        public string executionDirectory { get; set; }
        public string facilityName { get; set; }
        public int backupWait { get; set; }
        public string errorMsg { get; set; }

        public void getServiceSettingsXml()
        {
            try
            {
                var xml = XDocument.Load(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + @"\serviceConfig.xml");

                var settings = (from n in xml.Descendants("serviceSettings")
                                select new
                                {
                                    LOGS_PATH = n.Element("LOGS_PATH").Value,
                                    TIMER_INTERVAL_MINS = Convert.ToInt32(n.Element("TIMER_INTERVAL_MINS").Value),
                                    EXECUTION_DIRECTORY = n.Element("EXECUTION_DIRECTORY").Value,
                                    FACILITY_NAME = n.Element("FACILITY_NAME").Value,
                                    BACKUP_WAIT_MINS = Convert.ToInt32(n.Element("BACKUP_WAIT_MINS").Value)
                                });

                foreach (var setting in settings)
                {
                    logsPath = setting.LOGS_PATH;
                    timerIntervalMins = setting.TIMER_INTERVAL_MINS;
                    executionDirectory = setting.EXECUTION_DIRECTORY;
                    facilityName = setting.FACILITY_NAME;
                    backupWait = setting.BACKUP_WAIT_MINS;
                }
            }
            catch (Exception error)
            {
                errorMsg = "Error while retrieving service settings. " + error.Message;
            }
        }

        public bool installerSetServiceSettingsXml(string vagrantRooDir, string logsDirectory, string facility)
        {
            try
            {
                var xmlPath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + @"\serviceConfig.xml";

                var xml = XDocument.Load(xmlPath);

                var settings = (from n in xml.Descendants("serviceSettings") select n);

                foreach (var setting in settings)
                {
                    setting.SetElementValue("EXECUTION_DIRECTORY", vagrantRooDir);
                    setting.SetElementValue("LOGS_PATH", logsDirectory);
                    setting.SetElementValue("FACILITY_NAME", facility);
                }

                xml.Save(xmlPath);

                return true;
            }
            catch (Exception error)
            {
                errorMsg = "Error while opening or updating the settings in serviceConfig.xml:  " + error.Message;
            }

            return false;
        }

        ~serviceConfig()
        {
            logsPath = null;
            timerIntervalMins = 0;
            executionDirectory = null;
            facilityName = null;
            backupWait = 0;
            errorMsg = null;
        }
    }
}
