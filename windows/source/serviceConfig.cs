using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;
using System.Reflection;
using System.IO;

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

                settings = null;
                xml = null;
            }
            catch (Exception error)
            {
                errorMsg = "Error while retrieving service settings. " + error.Message + " : " + DateTime.Now;
            }
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
