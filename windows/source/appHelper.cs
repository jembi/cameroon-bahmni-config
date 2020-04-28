using System;
using System.IO;
using System.Reflection;
using System.Diagnostics;
using Microsoft.Win32;

namespace Bahmni
{
    public class appHelper
    {
        const string LOG_FILENAME = "Bahmni_Service_Log";

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
                WriteLog("An eror occurred while attempting to update registry! " + error.Message);
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

        public static void WriteLog(string Message)
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

                var filepath = sc.logsPath + @"\" + LOG_FILENAME + "_" + DateTime.Now.Date.ToShortDateString().Replace('/', '_') + ".txt";

                if (!File.Exists(filepath))
                {
                    using (var sw = File.CreateText(filepath))
                    {
                        sw.WriteLine("Logged at [" + DateTime.Now + "]");
                        sw.WriteLine(Message);
                    }
                }
                else
                {
                    using (var sw = File.AppendText(filepath))
                    {
                        sw.WriteLine("Logged at [" + DateTime.Now + "]");
                        sw.WriteLine(Message);
                    }
                }

                filepath = null;
            }
        }
    }
}
