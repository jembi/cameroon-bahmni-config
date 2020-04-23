using System;
using System.Diagnostics;
using System.IO;
using System.ServiceProcess;
using System.Timers;

namespace Bahmni
{
    public partial class Service1 : ServiceBase
    {
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
                WriteLog("Checking VM status every " + sc.timerIntervalMins + "min");

                var timer = new Timer();
                timer.Interval = ConvertMinutesToMilliseconds(sc.timerIntervalMins);
                timer.Elapsed += getVmStatus;
                timer.Enabled = true;
                timer.Start();
            }
        }

        protected override void OnStop()
        {
            base.RequestAdditionalTime(1000 * 60 * 2); //give service extra 1min to halt VM

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
                        initialiseCmdProcess(process, "vagrantHalt.bat", sc);

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

        private void initialiseCmdProcess(Process proc, string command, serviceConfig conf)
        {
            var info = new ProcessStartInfo("cmd.exe", @"/k ""cd /d " + conf.executionDirectory + @"""");

            info.RedirectStandardOutput = true;
            info.RedirectStandardError = true;
            info.UseShellExecute = false;
            info.RedirectStandardInput = true;
            info.CreateNoWindow = true;
           
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
                if (!Directory.Exists(sc.logsPath))
                {
                    Directory.CreateDirectory(sc.logsPath);
                }

                var filepath = sc.logsPath + @"\" + LOG_FILENAME + "_" + DateTime.Now.Date.ToShortDateString().Replace('/', '_') + ".txt";

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
                        initialiseCmdProcess(process, "vagrantStatus.bat", sc);

                        using (process.StandardOutput)
                        {
                            var standardOutput = process.StandardOutput.ReadToEnd().ToLower();

                            if (!standardOutput.Contains("running"))
                            {
                                if (standardOutput.Contains("poweroff"))
                                {
                                    vmMustStart = true;
                                    WriteLog("VM is powered off! : " + DateTime.Now);
                                }
                                else if (standardOutput.Contains("not created (virtualbox)"))
                                {
                                    WriteLog("VM has not been created! Contact the system administrator : " + DateTime.Now);
                                }
                                else
                                {
                                    WriteLog("Unable to verify the status of the VM! : " + DateTime.Now);
                                }
                            }
                            else
                            {
                                WriteLog("VM is running! : " + DateTime.Now);
                            }

                            standardOutput = null;
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
                        initialiseCmdProcess(process, "vagrantUp.bat", sc);

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