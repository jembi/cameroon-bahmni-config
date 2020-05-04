using System;
using System.IO;
using System.Linq;
using Microsoft.Win32;

namespace Bahmni
{ 
    public static class registry
    {
        const string HKLM = "HKEY_LOCAL_MACHINE";
        const string PSSCRIPTS_INI_PATH = @"C:\Windows\System32\GroupPolicy\Machine\Scripts\psscripts.ini";
        const string PSSCRIPTS_INI_ROOT_PATH = @"C:\Windows\System32\GroupPolicy\Machine\Scripts\";
        const string SHUTDOWN_SCRIPT_NAME = "stopBahmni.ps1";

        public static bool fastStartUp(bool mustDisable)
        {
            const string HKLM_SUBKEY = @"SYSTEM\CurrentControlSet\Control\Session Manager\Power";
            const string KEY_PATH = HKLM + @"\" + HKLM_SUBKEY;

            try
            {
                if (mustDisable) //0 = fast boot turned off, 1 = turned on
                    Registry.SetValue(KEY_PATH, "HiberbootEnabled", 0, RegistryValueKind.DWord);
                else
                    Registry.SetValue(KEY_PATH, "HiberbootEnabled", 1, RegistryValueKind.DWord);

                return true;
            }
            catch (Exception error)
            {
                appHelper.WriteLog("An error occurred while attempting to update Hiberboot in registry! " + error.Message);
            }

            return false;
        }

        public static bool criticalBatteryNotificationAction(bool mustDisable)
        {
            const string HKLM_SUBKEY = @"SOFTWARE\Policies\Microsoft\Power\PowerSettings\637EA02F-BBCB-4015-8E2C-A1C7B9C0B546";
            const string KEY_PATH = HKLM + @"\" + HKLM_SUBKEY;

            try
            {
                if (mustDisable)
                    ComputerGroupPolicyObject.SetPolicySetting(KEY_PATH + "!DCSettingIndex", null, RegistryValueKind.Unknown);
                else
                    ComputerGroupPolicyObject.SetPolicySetting(KEY_PATH + "!DCSettingIndex", "3", RegistryValueKind.DWord); //item: decimal: 0 => Take no action, item: decimal: 1 => Sleep,  decimal: 2 => Hibernate, item: decimal: 3 => Shut down

                return true;
            }
            catch (Exception error)
            {
                appHelper.WriteLog("An error occurred while attempting to update Critical Battery Notification Action in registry! " + error.Message);
            }

            return false;
        }

        public static bool criticalBatteryNotificationLevel(bool mustDisable)
        {
            const string HKLM_SUBKEY = @"SOFTWARE\Policies\Microsoft\Power\PowerSettings\9A66D8D7-4FF7-4EF9-B5A2-5A326CA2A469";
            const string KEY_PATH = HKLM + @"\" + HKLM_SUBKEY;

            try
            {
                if (mustDisable)
                    ComputerGroupPolicyObject.SetPolicySetting(KEY_PATH + "!DCSettingIndex", null, RegistryValueKind.Unknown);
                else
                    ComputerGroupPolicyObject.SetPolicySetting(KEY_PATH + "!DCSettingIndex", "15", RegistryValueKind.DWord); //15% battery level

                return true;
            }
            catch (Exception error)
            {
                appHelper.WriteLog("An error occurred while attempting to update Critical Battery Notification Level in registry! " + error.Message);
            }

            return false;
        }

        public static bool shutdownPowerShellScript(bool mustDisable, serviceConfig sc)
        {
            try
            {
                if (!Directory.Exists(PSSCRIPTS_INI_ROOT_PATH + "Startup"))
                    Directory.CreateDirectory(PSSCRIPTS_INI_ROOT_PATH + "Startup");

                if (!Directory.Exists(PSSCRIPTS_INI_ROOT_PATH + "Shutdown"))
                    Directory.CreateDirectory(PSSCRIPTS_INI_ROOT_PATH + "Shutdown");

                if (!File.Exists(PSSCRIPTS_INI_PATH))
                {
                    using (File.Create(PSSCRIPTS_INI_PATH))
                    {
                        var f = new FileInfo(PSSCRIPTS_INI_PATH);
                        f.Attributes = FileAttributes.Hidden;

                        f = null;
                    }

                    var parser = new IniFile(PSSCRIPTS_INI_PATH);

                    parser.Write(null, null, "ScriptsConfig");
                }

                const string SHUTDOWN_SECTION_NAME = "Shutdown";

                if (mustDisable)
                {
                    var parser = new IniFile(PSSCRIPTS_INI_PATH);

                    var shutDownSectionKeys = parser.EnumSection(SHUTDOWN_SECTION_NAME);

                    foreach (string key in shutDownSectionKeys)
                    {
                        if (parser.Read(key, SHUTDOWN_SECTION_NAME).Contains(SHUTDOWN_SCRIPT_NAME))
                        {
                            parser.DeleteKey(key, SHUTDOWN_SECTION_NAME);

                            var parameterKeyStartingIndex = key.Substring(0, 1);

                            parser.DeleteKey(parameterKeyStartingIndex + "Parameters", SHUTDOWN_SECTION_NAME);
                        }
                    }

                    parser = new IniFile(PSSCRIPTS_INI_PATH);
                    var shutDownSectionKeysCountAfterDeletion = parser.EnumSection(SHUTDOWN_SECTION_NAME).Length;

                    if (shutDownSectionKeysCountAfterDeletion == 0)
                    {
                        parser.DeleteSection(SHUTDOWN_SECTION_NAME);
                    }
                }
                else
                {
                    var parser = new IniFile(PSSCRIPTS_INI_PATH);

                    var shutDownScriptAlreadyApplied = false;
                    var shutDownSectionKeys = parser.EnumSection(SHUTDOWN_SECTION_NAME);
                    var cmdLineCounts = 0; //0 indicates first CmdLine key

                    if (shutDownSectionKeys != null)
                    {
                        var cmdLineIndexPrefix = 0;

                        foreach (string key in shutDownSectionKeys)
                        {
                            if (parser.Read(key, SHUTDOWN_SECTION_NAME).Contains(SHUTDOWN_SCRIPT_NAME))
                            {
                                shutDownScriptAlreadyApplied = true;
                            }

                            if (parser.KeyExists(cmdLineIndexPrefix + "CmdLine", SHUTDOWN_SECTION_NAME))
                            {
                                cmdLineCounts++;
                            }

                            cmdLineIndexPrefix++;
                        }
                    }

                    if (!shutDownScriptAlreadyApplied)
                    {
                        parser.Write("EndExecutePSFirst", "true", "ScriptsConfig");

                        var shutDownSectionKeysCount = shutDownSectionKeys.Length;

                        if (shutDownSectionKeysCount == 0)
                        {
                            parser = new IniFile(PSSCRIPTS_INI_PATH);
                            parser.Write("0CmdLine", sc.executionDirectory + @"\" + SHUTDOWN_SCRIPT_NAME, SHUTDOWN_SECTION_NAME);

                            parser = new IniFile(PSSCRIPTS_INI_PATH);
                            parser.Write("0Parameters", "", SHUTDOWN_SECTION_NAME);
                        }
                        else
                        {
                            parser = new IniFile(PSSCRIPTS_INI_PATH);
                            parser.Write(cmdLineCounts + "CmdLine", sc.executionDirectory + @"\" + SHUTDOWN_SCRIPT_NAME, SHUTDOWN_SECTION_NAME);

                            parser = new IniFile(PSSCRIPTS_INI_PATH);
                            parser.Write(cmdLineCounts + "Parameters", "", SHUTDOWN_SECTION_NAME);
                        }
                    }
                }

                return true;
            }
            catch (Exception error)
            {
                appHelper.WriteLog("An error occurred while attempting to add or remove the shutdown script in registry! " + error.Message);
            }

            return false;
        }

        public static string[] getMSIProductVersion()
        {
            var regValues = new string[2];

            try
            {
                using (var key = Registry.LocalMachine.OpenSubKey(@"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"))
                {
                    if (key != null)
                    {
                        foreach (var subkey in key.GetSubKeyNames().Select(keyName => key.OpenSubKey(keyName)))
                        {
                            var displayName = subkey.GetValue("DisplayName") as string;
                            if (displayName != null && displayName.ToLower().Contains("bahmni service"))
                            {
                                regValues[0] = (string)subkey.GetValue("DisplayVersion");
                                regValues[1] = (string)subkey.GetValue("InstallDate");
                            }
                        }
                    }

                    key.Close();
                }

                return regValues;
            }
            catch (Exception error)
            {
                appHelper.WriteLog("An error occurred while attempting to get the product version number from registry for the Bahmni Service MSI: " + error.Message);
            }
            finally
            {
                regValues = null;
            }

            return null;
        }
    }
}
