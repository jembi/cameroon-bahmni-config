using System;
using System.IO;
using System.Linq;
using System.Xml.Linq;
using System.Reflection;

namespace Bahmni
{
    class serviceConfig
    {
        public string vmName { get; set; }
        public string logsPath { get; set; }
        public int timerIntervalMins { get; set; }
        public string executionDirectory { get; set; }
        public string errorMsg { get; set; }

        public void getServiceSettingsXml()
        {
            try
            {
                var xml = XDocument.Load(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + @"\serviceConfig.xml");

                var settings = (from n in xml.Descendants("serviceSettings")
                                select new
                                {
                                    VM_NAME = (string)n.Element("VM_NAME").Value,
                                    LOGS_PATH = (string)n.Element("LOGS_PATH").Value,
                                    TIMER_INTERVAL_MINS = Convert.ToInt32(n.Element("TIMER_INTERVAL_MINS").Value),
                                    EXECUTION_DIRECTORY = n.Element("EXECUTION_DIRECTORY").Value
                                });

                foreach (var setting in settings)
                {
                    vmName = setting.VM_NAME;
                    logsPath = setting.LOGS_PATH;
                    timerIntervalMins = setting.TIMER_INTERVAL_MINS;
                    executionDirectory = setting.EXECUTION_DIRECTORY;
                }
            }
            catch (Exception error)
            {
                errorMsg = "Error while retrieving service settings. " + error.Message;
            }
        }

        public bool installerSetServiceSettingsXml(string vagrantRooDir, string vmName, string logsDirectory)
        {
            try
            {
                var xmlPath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + @"\serviceConfig.xml";

                var xml = XDocument.Load(xmlPath);

                var settings = (from n in xml.Descendants("serviceSettings") select n);

                foreach (var setting in settings)
                {
                    setting.SetElementValue("EXECUTION_DIRECTORY", vagrantRooDir);
                    setting.SetElementValue("VM_NAME", vmName);
                    setting.SetElementValue("LOGS_PATH", logsDirectory);
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
            vmName = null;
            logsPath = null;
            timerIntervalMins = 0;
            executionDirectory = null;
            errorMsg = null;
        }
    }
}
