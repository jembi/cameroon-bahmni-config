using System;
using System.IO;
using System.Reflection;
using System.Diagnostics;
using Microsoft.Win32;
using System.Linq;

namespace Bahmni
{
    public class appHelper
    {
        const string LOG_FILENAME = "Bahmni_Service_Log";
        const string APP_INFO = "Bahmni_Service_Info";
        public static string ServiceName = null;
        
        public static bool disableFastStartUp(bool mustDisable)
        {
            const string HKLM = "HKEY_LOCAL_MACHINE";
            const string HKLM_SUBKEY = @"SYSTEM\CurrentControlSet\Control\Session Manager\Power";
            const string HKLM_HIBERBOOT_KEY_PATH = HKLM + @"\" + HKLM_SUBKEY;

            try
            {
                if (mustDisable) //0 = fast boot turned off, 1 = turned on
                    Registry.SetValue(HKLM_HIBERBOOT_KEY_PATH, "HiberbootEnabled", 0, RegistryValueKind.DWord); 
                else
                    Registry.SetValue(HKLM_HIBERBOOT_KEY_PATH, "HiberbootEnabled", 1, RegistryValueKind.DWord);

                return true;
            }
            catch (Exception error)
            {
                WriteLog("An error occurred while attempting to update registry! " + error.Message);
            }

            return false;
        }

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

        private static string getMSIProductVersion()
        {
            try
            {
                using (var key = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"))
                {
                    if (key != null)
                    {
                        foreach (RegistryKey subkey in key.GetSubKeyNames().Select(keyName => key.OpenSubKey(keyName)))
                        {
                            var displayName = subkey.GetValue("DisplayName") as string;
                            if (displayName != null && displayName.ToLower().Contains("bahmni service"))
                            {
                                return (string)subkey.GetValue("DisplayVersion");
                            }
                        }
                    }

                    key.Close();
                }
            }
            catch (Exception error)
            {
                WriteLog("An error occurred while attempting to get the product version number from registry for the Bahmni Service MSI: " + error.Message);
            }
            finally
            {
                ServiceName = null;
            }

            return null;
        }

        private static void WriteAppInfoToLog(serviceConfig conf)
        {
            var filepath = conf.executionDirectory + @"\" + APP_INFO + ".txt";

            if (!File.Exists(filepath))
            {
                using (var sw = File.CreateText(filepath))
                {
                    var assembly = System.Reflection.Assembly.GetExecutingAssembly();
                    var fvi = FileVersionInfo.GetVersionInfo(assembly.Location);

                    sw.WriteLine("Bahmni service installed on " + DateTime.Now);
                    sw.WriteLine("Bahmni assembly file version: " + fvi.FileVersion);
                    sw.WriteLine("Bahmni MSI product version: " + getMSIProductVersion());
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

                WriteAppInfoToLog(sc);
            }
        }
    }
}
