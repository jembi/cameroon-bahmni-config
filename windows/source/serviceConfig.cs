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
        public string VM_NAME { get; set; }
        public string LOGS_PATH { get; set; }
        public int TIMER_INTERVAL_MINS { get; set; }
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
                                    TIMER_INTERVAL_MINS = Convert.ToInt32(n.Element("TIMER_INTERVAL_MINS").Value)
                                });

                foreach (var setting in settings)
                {
                    VM_NAME = setting.VM_NAME;
                    LOGS_PATH = setting.LOGS_PATH;
                    TIMER_INTERVAL_MINS = setting.TIMER_INTERVAL_MINS;
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
            VM_NAME = null;
            LOGS_PATH = null;
            TIMER_INTERVAL_MINS = 0;
            errorMsg = null;
        }
    }
}
