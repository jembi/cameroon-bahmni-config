using System;
using System.Diagnostics;
using System.IO;
using System.ServiceProcess;
using System.Timers;

namespace Bahmni
{
    public partial class Service1 : ServiceBase
    {
        const string VIRTUALBOX_VBOXMANAGE_EXE_DIRECTORY = @"C:\Program Files\Oracle\VirtualBox";
        const string LOG_FILENAME = "Bahmni_Service_Log";
       
        public Service1()
        {
            InitializeComponent();
        }

        public static double ConvertMinutesToMilliseconds(double minutes)
        {
            return TimeSpan.FromMinutes(minutes).TotalMilliseconds;
        }

        protected override void OnStart(string[] args)
        {
            var sc = new serviceConfig();

            sc.getServiceSettingsXml();

            if (sc.errorMsg != null)
            {
                WriteLog(sc.errorMsg);
            }
            else
            {
                WriteLog("Bahmni service started : " + DateTime.Now);
                WriteLog("Checking VM status every " + sc.TIMER_INTERVAL_MINS + "min");

                var timer = new Timer();
                timer.Interval = ConvertMinutesToMilliseconds(sc.TIMER_INTERVAL_MINS);
                timer.Elapsed += getVmStatus;
                timer.Enabled = true;
                timer.Start();
            }
        }

        protected override void OnStop()
        {
            var sc = new serviceConfig();

            sc.getServiceSettingsXml();

            if (sc.errorMsg != null)
            {
                WriteLog(sc.errorMsg);
            }
            else
            {
                WriteLog("Bahmni service stopped : " + DateTime.Now);
                WriteLog("Halting Bahmni VM...");

                try
                {
                    using (var process = new Process())
                    {
                        initialiseCmdProcess(process, "VBoxManage.exe controlvm " + sc.VM_NAME + " acpipowerbutton");

                        using (process.StandardOutput)
                        {
                            WriteLog(process.StandardOutput.ReadToEnd());
                        }

                        using (process.StandardError)
                        {
                            WriteLog(process.StandardError.ReadToEnd());
                        }

                        process.WaitForExit();
                    }
                }
                catch (Exception error)
                {
                    WriteLog(error.Message + " : " + DateTime.Now);
                }
            }
        }

        private void initialiseCmdProcess(Process proc, string command)
        {
            var info = new ProcessStartInfo("cmd.exe", @"/k ""cd /d " + VIRTUALBOX_VBOXMANAGE_EXE_DIRECTORY + @"""");

            info.RedirectStandardOutput = true;
            info.RedirectStandardError = true;
            info.UseShellExecute = false;
            info.RedirectStandardInput = true;

            proc.StartInfo = info;
            proc.Start();

            proc.StandardInput.WriteLine(command);
            proc.StandardInput.Close();
        }

        private void WriteLog(string Message)
        {
            var sc = new serviceConfig();

            sc.getServiceSettingsXml();

            if (sc.errorMsg != null)
            {
                WriteLog(sc.errorMsg);
            }
            else
            {
                if (!Directory.Exists(sc.LOGS_PATH))
                {
                    Directory.CreateDirectory(sc.LOGS_PATH);
                }

                var filepath = sc.LOGS_PATH + @"\" + LOG_FILENAME + "_" + DateTime.Now.Date.ToShortDateString().Replace('/', '_') + ".txt";

                if (!File.Exists(filepath))
                {
                    using (var sw = File.CreateText(filepath))
                    {
                        sw.WriteLine(Message);
                    }
                }
                else
                {
                    using (var sw = File.AppendText(filepath))
                    {
                        sw.WriteLine(Message);
                    }
                }

                filepath = null;
            }
        }

        private void getVmStatus(object sender, System.Timers.ElapsedEventArgs e)
        {
            var sc = new serviceConfig();

            sc.getServiceSettingsXml();

            if (sc.errorMsg != null)
            {
                WriteLog(sc.errorMsg);
            }
            else
            {
                bool vmMustStart = false;

                WriteLog("Checking Bahmni VM status : " + DateTime.Now);

                try
                {
                    using (var process = new Process())
                    {
                        initialiseCmdProcess(process, "VBoxManage.exe list runningvms");

                        using (process.StandardOutput)
                        {
                            if (!process.StandardOutput.ReadToEnd().ToLower().Contains(sc.VM_NAME.ToLower()))
                            {
                                vmMustStart = true;
                                WriteLog("VM not running! : " + DateTime.Now);
                            }
                            else
                            {
                                WriteLog("VM is running! : " + DateTime.Now);
                            }
                        }

                        using (process.StandardError)
                        {
                            WriteLog(process.StandardError.ReadToEnd());
                        }

                        process.WaitForExit();
                    }
                }
                catch (Exception error)
                {
                    WriteLog(error.Message + " : " + DateTime.Now);
                }

                //Only call startVM() when the parent process has exited
                if (vmMustStart)
                    startVm();
            }
        }

        private void startVm()
        {
            var sc = new serviceConfig();

            sc.getServiceSettingsXml();

            if (sc.errorMsg != null)
            {
                WriteLog(sc.errorMsg);
            }
            else
            {
                WriteLog("Starting Bahmni VM... : " + DateTime.Now);

                try
                {
                    using (var process = new Process())
                    {
                        initialiseCmdProcess(process, "VBoxManage.exe startvm " + sc.VM_NAME + " --type headless");

                        using (process.StandardOutput)
                        {
                            WriteLog(process.StandardOutput.ReadToEnd());
                        }

                        using (process.StandardError)
                        {
                            WriteLog(process.StandardError.ReadToEnd());
                        }

                        process.WaitForExit();
                    }
                }
                catch (Exception error)
                {
                    WriteLog(error.Message + " : " + DateTime.Now);
                }
            }
        }
    }
}