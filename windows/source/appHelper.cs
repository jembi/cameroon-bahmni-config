﻿using System;
using System.IO;
using System.Reflection;
using System.Diagnostics;
using System.Linq;

namespace Bahmni
{
    public class appHelper
    {
        const string LOG_FILENAME = "Bahmni_Service_Log";
        public const string APP_INFO = "Bahmni_Service_Info";
      
        public static bool processFiles(string vagrantRooDir)
        {
            try
            {
                var sourcePath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + @"\scripts";

                if (!Directory.Exists(vagrantRooDir))
                {
                    Directory.CreateDirectory(vagrantRooDir);
                }

                foreach (var srcPath in Directory.GetFiles(sourcePath))
                {
                    //Copy the file from sourcepath and place into mentioned target path, 
                    //Overwrite the file if same file is exist in target path
                    File.Copy(srcPath, srcPath.Replace(sourcePath, vagrantRooDir), true);
                }

                return true;
            }
            catch (Exception error)
            {
                WriteLog("Error occurred while copying the scripts from the Bahmni service install directory to the Vagrant root directory:  " + error.Message);
            }

            return false;
        }

        public static void WriteAppInfoToFile(serviceConfig conf)
        {
            var filepath = conf.executionDirectory + @"\" + APP_INFO + ".txt";

            if (!File.Exists(filepath))
            {
                using (var sw = File.CreateText(filepath))
                {
                    var assembly = System.Reflection.Assembly.GetExecutingAssembly();
                    var fvi = FileVersionInfo.GetVersionInfo(assembly.Location);
                    var regValues = registry.getMSIProductVersion();

                    sw.WriteLine("Bahmni service installed on " + regValues[1]);
                    sw.WriteLine("Bahmni assembly file version: " + fvi.FileVersion);
                    sw.WriteLine("Bahmni MSI product version: " + regValues[0]);

                    regValues = null;
                    assembly = null;
                    fvi = null;
                }
            }

            filepath = null;
        }

        public static void WriteLog(string logText)
        {
            if (!String.IsNullOrWhiteSpace(logText))
            {
                var sc = new serviceConfig();

                sc.getServiceSettingsXml();

                if (sc.errorMsg != null)
                {
                    WriteLog(sc.errorMsg);
                }
                else
                {
                    WriteAppInfoToFile(sc);

                    if (!Directory.Exists(sc.logsPath))
                    {
                        Directory.CreateDirectory(sc.logsPath);
                    }

                    var filepath = sc.logsPath + @"\" + LOG_FILENAME + "_" + DateTime.Now.Date.ToString("dd-MMM-yyyy") + ".txt";

                    if (!File.Exists(filepath))
                    {
                        using (var sw = File.CreateText(filepath))
                        {
                            sw.WriteLine("Logged at [" + DateTime.Now + "]");
                            sw.WriteLine(logText);
                        }
                    }
                    else
                    {
                        using (var sw = File.AppendText(filepath))
                        {
                            sw.WriteLine("Logged at [" + DateTime.Now + "]");
                            sw.WriteLine(logText);
                        }
                    }

                    filepath = null;
                }
            }
        }
    }
}
