using System;
using System.IO;
using System.Reflection;
using System.Diagnostics;
using System.Configuration;

namespace Bahmni
{
    public class appHelper
    {
        const string LOG_FILENAME = "Bahmni_Service_Log";
        public const string APP_INFO = "Bahmni_Service_Info";
        const string VAGRANT_BACKUP_CMD = "sudo /home/bahmni/cameroon-backups.sh";

        const string CONNECTION_STATE_INI_SECTION_NAME = "NetworkConnection";
        const string CONNECTION_STATE_INI_FILE_NAME = "connectionState.ini";
        const string LAST_DATE_LOGS_COMPRESSED_KEY = "LastDateLogsCompressed";
        const string LAST_DATE_LOGS_UPLOADED_KEY = "LastDateLogsUploaded";

        const string PSSCRIPTS_INI_PATH = @"C:\Windows\System32\GroupPolicy\Machine\Scripts\psscripts.ini";
        const string PSSCRIPTS_INI_ROOT_PATH = @"C:\Windows\System32\GroupPolicy\Machine\Scripts\";
        const string SHUTDOWN_SCRIPT_NAME = "stopBahmni.ps1";

        public static bool shutdownPowerShellScript(bool isUninstalling, serviceConfig sc)
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

                if (isUninstalling)
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

        public static string getLastDateLogsCompressed()
        {
            var sc = new serviceConfig();

            sc.getServiceSettingsXml();

            if (sc.errorMsg != null)
            {
                appHelper.WriteLog(sc.errorMsg);
            }
            else
            {
                try
                {
                    if (File.Exists(sc.executionDirectory + @"\" + CONNECTION_STATE_INI_FILE_NAME))
                    {
                        var parser = new IniFile(sc.executionDirectory + @"\" + CONNECTION_STATE_INI_FILE_NAME);

                        var keyAlreadyApplied = false;
                        var networkConnectionKeys = parser.EnumSection(CONNECTION_STATE_INI_SECTION_NAME);

                        if (networkConnectionKeys != null)
                        {
                            foreach (string key in networkConnectionKeys)
                            {
                                if (key == LAST_DATE_LOGS_COMPRESSED_KEY)
                                {
                                    if (parser.Read(key, CONNECTION_STATE_INI_SECTION_NAME) != "Unspecified")
                                    {
                                        keyAlreadyApplied = true;
                                    }
                                }
                            }
                        }

                        if (!keyAlreadyApplied)
                        {
                            parser.Write(LAST_DATE_LOGS_COMPRESSED_KEY, DateTime.Now.Date.ToString("dd-MMM-yyyy"), CONNECTION_STATE_INI_SECTION_NAME);

                            return DateTime.Now.AddDays(-1).ToString("dd-MMM-yyyy"); //Becuase this is the first entry, return yesterdays date so that today is seen as a new day
                        }
                        else
                        {
                            return parser.Read(LAST_DATE_LOGS_COMPRESSED_KEY, CONNECTION_STATE_INI_SECTION_NAME);
                        }
                    }
                    else
                    {
                        appHelper.WriteLog("Get last date logs compressed error: File not found!");
                    }
                }
                catch (Exception error)
                {
                    appHelper.WriteLog("Get last date logs compressed error: " + error.Message);
                }
            }

            return null;
        }

        public static void setLastDateLogsCompressed()
        {
            var sc = new serviceConfig();

            sc.getServiceSettingsXml();

            if (sc.errorMsg != null)
            {
                appHelper.WriteLog(sc.errorMsg);
            }
            else
            {
                try
                {
                    if (File.Exists(sc.executionDirectory + @"\" + CONNECTION_STATE_INI_FILE_NAME))
                    {
                        var parser = new IniFile(sc.executionDirectory + @"\" + CONNECTION_STATE_INI_FILE_NAME);

                        parser.Write(LAST_DATE_LOGS_COMPRESSED_KEY, DateTime.Now.Date.ToString("dd-MMM-yyyy"), CONNECTION_STATE_INI_SECTION_NAME);
                    }
                    else
                    {
                        appHelper.WriteLog("Set last date logs compressed error: File not found!");
                    }
                }
                catch (Exception error)
                {
                    appHelper.WriteLog("Set last date logs compressed error: " + error.Message);
                }
            }
        }

        public static string getLastDateLogsUploaded()
        {
            var sc = new serviceConfig();

            sc.getServiceSettingsXml();

            if (sc.errorMsg != null)
            {
                appHelper.WriteLog(sc.errorMsg);
            }
            else
            {
                try
                {
                    if (File.Exists(sc.executionDirectory + @"\" + CONNECTION_STATE_INI_FILE_NAME))
                    {
                        var parser = new IniFile(sc.executionDirectory + @"\" + CONNECTION_STATE_INI_FILE_NAME);

                        var keyAlreadyApplied = false;
                        var networkConnectionKeys = parser.EnumSection(CONNECTION_STATE_INI_SECTION_NAME);

                        if (networkConnectionKeys != null)
                        {
                            foreach (string key in networkConnectionKeys)
                            {
                                if (key == LAST_DATE_LOGS_UPLOADED_KEY)
                                {
                                    if (parser.Read(key, CONNECTION_STATE_INI_SECTION_NAME) != "Unspecified")
                                    {
                                        keyAlreadyApplied = true;
                                    }
                                }
                            }
                        }

                        if (!keyAlreadyApplied)
                        {
                            return "Unspecified";
                        }
                        else
                        {
                            return parser.Read(LAST_DATE_LOGS_UPLOADED_KEY, CONNECTION_STATE_INI_SECTION_NAME);
                        }
                    }
                    else
                    {
                        appHelper.WriteLog("Get last date logs uploaded error: File not found!");
                    }
                }
                catch (Exception error)
                {
                    appHelper.WriteLog("Get last date logs uploaded error: " + error.Message);
                }
            }

            return null;
        }

        public static void setLastDateLogsUploaded()
        {
            var sc = new serviceConfig();

            sc.getServiceSettingsXml();

            if (sc.errorMsg != null)
            {
                appHelper.WriteLog(sc.errorMsg);
            }
            else
            {
                try
                {
                    if (File.Exists(sc.executionDirectory + @"\" + CONNECTION_STATE_INI_FILE_NAME))
                    {
                        var parser = new IniFile(sc.executionDirectory + @"\" + CONNECTION_STATE_INI_FILE_NAME);

                        parser.Write(LAST_DATE_LOGS_UPLOADED_KEY, DateTime.Now.Date.ToString("dd-MMM-yyyy"), CONNECTION_STATE_INI_SECTION_NAME);
                    }
                    else
                    {
                        appHelper.WriteLog("Set last date logs uploaded error: File not found!");
                    }
                }
                catch (Exception error)
                {
                    appHelper.WriteLog("Set last date logs uploaded error: " + error.Message);
                }
            }
        }

        public static void encryptSecret()
        {
            try
            {
                Configuration config = ConfigurationManager.OpenExeConfiguration(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + @"\Bahmni.exe.config");
                ConfigurationSection section = config.GetSection("appSettings");

                if (!section.SectionInformation.IsProtected)
                {
                    section.SectionInformation.ProtectSection("DataProtectionConfigurationProvider");
                    config.Save();
                }
            }
            catch (Exception error)
            {
                WriteLog("Failed to encrypt the secret app setting! " + error.Message);
            }
        }

        public static void deleteCompressedFileFromFacilityServer(string filePath)
        {
            try
            {
                if (File.Exists(filePath))
                {
                    File.Delete(filePath);
                }
            }
            catch (Exception error)
            {
                appHelper.WriteLog("Unable to delete the compressed file! " + error.Message);
            }
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

        public static void WriteAppInfoToFile(serviceConfig config)
        {
            var filepath = config.executionDirectory + @"\" + APP_INFO + ".txt";

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

        private static void createStartupCommandsFile(serviceConfig conf)
        {
            if (!File.Exists(conf.executionDirectory + @"\startupCommands.txt"))
            {
                using (var sw = File.CreateText(conf.executionDirectory + @"\startupCommands.txt"))
                {
                    sw.WriteLine("Date");
                    sw.WriteLine(VAGRANT_BACKUP_CMD);
                }
            }
        }

        public static void WriteLog(string logText)
        {
            try
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
                        createStartupCommandsFile(sc);

                        if (!Directory.Exists(sc.logsPath))
                        {
                            Directory.CreateDirectory(sc.logsPath);
                        }

                        if (!Directory.Exists(sc.logsPath + @"\" + DateTime.Now.Date.ToString("MMM")))
                        {
                            Directory.CreateDirectory(sc.logsPath + @"\" + DateTime.Now.Date.ToString("MMM"));
                        }

                        var filepath = sc.logsPath + @"\" + DateTime.Now.Date.ToString("MMM") + @"\" + LOG_FILENAME + "_" + DateTime.Now.Date.ToString("dd-MMM-yyyy") + ".txt";

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
            catch (Exception error)
            {
                var source = Assembly.GetExecutingAssembly().GetName().Name;
                const string LOG_NAME = "Application";

                var systemEventLog = new EventLog(LOG_NAME);

                if (!EventLog.SourceExists(source))
                {
                    EventLog.CreateEventSource(source, LOG_NAME);
                }

                systemEventLog.Source = source;
                systemEventLog.WriteEntry("Unable to write to the log file with error: " + error.Message, EventLogEntryType.Warning);
            }
        }
    }
}
