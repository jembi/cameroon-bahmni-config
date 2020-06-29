using System;
using System.IO;
using System.Linq;
using Microsoft.Win32;

namespace Bahmni
{
    public static class registry
    {
        const string HKLM = "HKEY_LOCAL_MACHINE";
      
        public static bool fastStartUp(bool isUninstalling)
        {
            const string HKLM_SUBKEY = @"SYSTEM\CurrentControlSet\Control\Session Manager\Power";
            const string KEY_PATH = HKLM + @"\" + HKLM_SUBKEY;

            try
            {
                if (isUninstalling) //0 = fast boot turned off, 1 = turned on
                    Registry.SetValue(KEY_PATH, "HiberbootEnabled", 1, RegistryValueKind.DWord);
                else
                    Registry.SetValue(KEY_PATH, "HiberbootEnabled", 0, RegistryValueKind.DWord);

                return true;
            }
            catch (Exception error)
            {
                appHelper.WriteLog("An error occurred while attempting to update Hiberboot in registry! " + error.Message);
            }

            return false;
        }

        public static bool lidSwitchAction(bool isUninstalling, int state) // 0 state = on battery, 1 = plugged in
        {
            const string HKLM_SUBKEY = @"Software\Policies\Microsoft\Power\PowerSettings\5CA83367-6E45-459F-A27B-476B1D01C936";
            const string KEY_PATH = HKLM + @"\" + HKLM_SUBKEY;

            try
            {
                if (isUninstalling)
                    ComputerGroupPolicyObject.SetPolicySetting(KEY_PATH + (state == 0 ? "!DCSettingIndex" : "!ACSettingIndex"), null, RegistryValueKind.Unknown);
                else
                    ComputerGroupPolicyObject.SetPolicySetting(KEY_PATH + (state == 0 ? "!DCSettingIndex" : "!ACSettingIndex"), "3", RegistryValueKind.DWord); //0 = take no action, 1 = sleep, 2 = hibernate, 3 = shutdown

                return true;
            }
            catch (Exception error)
            {
                appHelper.WriteLog("An error occurred while attempting to update the Lid Switch Action in registry! " + error.Message);
            }

            return false;
        }

        public static bool systemSleepTimeout(bool isUninstalling, int state) // 0 state = on battery, 1 = plugged in
        {
            const string HKLM_SUBKEY = @"Software\Policies\Microsoft\Power\PowerSettings\29F6C1DB-86DA-48C5-9FDB-F2B67B1F44DA";
            const string KEY_PATH = HKLM + @"\" + HKLM_SUBKEY;

            try
            {
                if (isUninstalling)
                    ComputerGroupPolicyObject.SetPolicySetting(KEY_PATH + (state == 0 ? "!DCSettingIndex" : "!ACSettingIndex"), null, RegistryValueKind.Unknown);
                else
                    ComputerGroupPolicyObject.SetPolicySetting(KEY_PATH + (state == 0 ? "!DCSettingIndex" : "!ACSettingIndex"), "0", RegistryValueKind.DWord); //0 seconds means Windows does not automatically transition to sleep.

                return true;
            }
            catch (Exception error)
            {
                appHelper.WriteLog("An error occurred while attempting to update the System Sleep Timeout in registry! " + error.Message);
            }

            return false;
        }

        public static bool turnOffHardDisk(bool isUninstalling, int state) // 0 state = on battery, 1 = plugged in
        {
            const string HKLM_SUBKEY = @"Software\Policies\Microsoft\Power\PowerSettings\6738E2C4-E8A5-4A42-B16A-E040E769756E";
            const string KEY_PATH = HKLM + @"\" + HKLM_SUBKEY;

            try
            {
                if (isUninstalling)
                    ComputerGroupPolicyObject.SetPolicySetting(KEY_PATH + (state == 0 ? "!DCSettingIndex" : "!ACSettingIndex"), null, RegistryValueKind.Unknown);
                else
                    ComputerGroupPolicyObject.SetPolicySetting(KEY_PATH + (state == 0 ? "!DCSettingIndex" : "!ACSettingIndex"), "0", RegistryValueKind.DWord); //0 seconds means do not turn off hard disk

                return true;
            }
            catch (Exception error)
            {
                appHelper.WriteLog("An error occurred while attempting to update the period in registry for when Windows tuns off the hard disk! " + error.Message);
            }

            return false;
        }

        public static bool hibernateTimeout(bool isUninstalling, int state) // 0 state = on battery, 1 = plugged in
        {
            const string HKLM_SUBKEY = @"Software\Policies\Microsoft\Power\PowerSettings\9D7815A6-7EE4-497E-8888-515A05F02364";
            const string KEY_PATH = HKLM + @"\" + HKLM_SUBKEY;

            try
            {
                if (isUninstalling)
                    ComputerGroupPolicyObject.SetPolicySetting(KEY_PATH + (state == 0 ? "!DCSettingIndex" : "!ACSettingIndex"), null, RegistryValueKind.Unknown);
                else
                    ComputerGroupPolicyObject.SetPolicySetting(KEY_PATH + (state == 0 ? "!DCSettingIndex" : "!ACSettingIndex"), "0", RegistryValueKind.DWord); //0 seconds means Windows want be able to traansition to Hibernate after a period of inactivity

                return true;
            }
            catch (Exception error)
            {
                appHelper.WriteLog("An error occurred while attempting to update the Hibernate Timeout in registry! " + error.Message);
            }

            return false;
        }

        public static bool criticalBatteryNotificationAction(bool isUninstalling)
        {
            const string HKLM_SUBKEY = @"SOFTWARE\Policies\Microsoft\Power\PowerSettings\637EA02F-BBCB-4015-8E2C-A1C7B9C0B546";
            const string KEY_PATH = HKLM + @"\" + HKLM_SUBKEY;

            try
            {
                if (isUninstalling)
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

        public static bool criticalBatteryNotificationLevel(bool isUninstalling)
        {
            const string HKLM_SUBKEY = @"SOFTWARE\Policies\Microsoft\Power\PowerSettings\9A66D8D7-4FF7-4EF9-B5A2-5A326CA2A469";
            const string KEY_PATH = HKLM + @"\" + HKLM_SUBKEY;

            try
            {
                if (isUninstalling)
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
