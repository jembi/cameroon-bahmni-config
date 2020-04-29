using System;
using System.ServiceProcess;
using System.Threading.Tasks;
using System.Diagnostics;

namespace Bahmni
{
    public partial class Service1 : ServiceBase
    {
        public Service1()
        {
            InitializeComponent();

            this.CanStop = true;
        }

        protected override void OnStart(string[] args)
        {
            var sc = new serviceConfig();

            sc.getServiceSettingsXml();

            if (sc.errorMsg != null)
            {
                appHelper.WriteLog(sc.errorMsg);
            }
            else
            {
                appHelper.WriteLog("Bahmni service started...Checking VM status every " + sc.timerIntervalMins + "min");

                var vmStatusCheckTimer = new System.Timers.Timer();
                vmStatusCheckTimer.Interval = TimeSpan.FromMinutes(sc.timerIntervalMins).TotalMilliseconds;
                vmStatusCheckTimer.Elapsed += getVmStatus;
                vmStatusCheckTimer.Enabled = true;
                vmStatusCheckTimer.Start();

                //Start VM immediately after a shutdown if its not running. First wait 2min before calling the function to check the VM status
                callWithDelay(startVm, 2 * 60 * 1000);
            }

            base.OnStart(args);
        }

        private static void callWithDelay(Action method, int delay)
        {
            System.Threading.Timer timer = null;

            var callback = new System.Threading.TimerCallback((state) => { method(); timer.Dispose(); });

            timer = new System.Threading.Timer(callback, null, delay, System.Threading.Timeout.Infinite);
        }

        private void haltVM()
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
                    using (var process = new Process())
                    {
                        appHelper.WriteLog("Bahmni service stopping and halting Bahmni VM...");
                       
                        initialiseCmdProcess(process, "vagrantHalt.bat", sc);
                      
                        using (process.StandardOutput)
                        {
                            appHelper.WriteLog(process.StandardOutput.ReadToEnd());
                        }

                        using (process.StandardError)
                        {
                            appHelper.WriteLog(process.StandardError.ReadToEnd());
                        }

                        process.WaitForExit();
                    }

                    using (var process = new Process())
                    {
                        appHelper.WriteLog("Verifying whether Bamni was halted...");

                        initialiseCmdProcess(process, "vagrantStatus.bat", sc);

                        using (process.StandardOutput)
                        {
                            appHelper.WriteLog(process.StandardOutput.ReadToEnd());
                        }

                        using (process.StandardError)
                        {
                            appHelper.WriteLog(process.StandardError.ReadToEnd());
                        }

                        process.WaitForExit();
                    }
                }
                catch (Exception error)
                {
                    appHelper.WriteLog("An error occurred while halting the VM! " + error.Message);
                }
            }
        }

        protected override void OnStop()
        {
            var timeout = 10000;
            var task = Task.Factory.StartNew(() => haltVM());

            while (!task.Wait(timeout))
            {
                RequestAdditionalTime(timeout); //Keep adding an additional 10 seconds until the task has completed
            }

            base.OnStop();
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

        private void vmStatus()
        {
            var sc = new serviceConfig();

            sc.getServiceSettingsXml();

            if (sc.errorMsg != null)
            {
                appHelper.WriteLog(sc.errorMsg);
            }
            else
            {
                bool vmMustStart = false;

                appHelper.WriteLog("Checking Bahmni VM status...");

                try
                {
                    using (var process = new Process())
                    {
                        initialiseCmdProcess(process, "vagrantStatus.bat", sc);

                        using (process.StandardOutput)
                        {
                            var standardOutput = process.StandardOutput.ReadToEnd().ToLower();

                            if (!standardOutput.Contains("running (virtualbox)"))
                            {
                                if (standardOutput.Contains("poweroff (virtualbox)"))
                                {
                                    vmMustStart = true;
                                    appHelper.WriteLog("VM is powered off!");
                                }
                                else if (standardOutput.Contains("not created (virtualbox)"))
                                {
                                    appHelper.WriteLog("VM has not been created! Contact the system administrator");
                                }
                                else if (standardOutput.Contains("aborted (virtualbox)"))
                                {
                                    vmMustStart = true;
                                    appHelper.WriteLog("VM is in an aborted state due to the session being closed too quickly without gracefully shutting down!");
                                }
                                else if (standardOutput.Contains("saved (virtualbox)"))
                                {
                                    vmMustStart = true;
                                    appHelper.WriteLog("VM is in a saved state!");
                                }
                                else
                                {
                                    appHelper.WriteLog("Unable to verify the status of the VM!");
                                }
                            }
                            else
                            {
                                appHelper.WriteLog("VM is running!");
                            }

                            standardOutput = null;
                        }

                        using (process.StandardError)
                        {
                            appHelper.WriteLog(process.StandardError.ReadToEnd());
                        }

                        process.WaitForExit();
                    }
                }
                catch (Exception error)
                {
                    appHelper.WriteLog("An error occurred while verifying the VM status! " + error.Message);
                }

                //Only call startVM() when the parent process has exited
                if (vmMustStart)
                    startVm();
            }
        }

        private void getVmStatus(object sender, System.Timers.ElapsedEventArgs e)
        {
            vmStatus();
        }

        private void startVm()
        {
            var sc = new serviceConfig();

            sc.getServiceSettingsXml();

            if (sc.errorMsg != null)
            {
                appHelper.WriteLog(sc.errorMsg);
            }
            else
            {
                appHelper.WriteLog("Starting Bahmni VM...");

                try
                {
                    using (var process = new Process())
                    {
                        initialiseCmdProcess(process, "vagrantUp.bat", sc);

                        using (process.StandardOutput)
                        {
                            appHelper.WriteLog(process.StandardOutput.ReadToEnd());
                        }

                        using (process.StandardError)
                        {
                            appHelper.WriteLog(process.StandardError.ReadToEnd());
                        }

                        process.WaitForExit();
                    }
                }
                catch (Exception error)
                {
                    appHelper.WriteLog("An error occurred while starting the VM! " + error.Message);
                }
            }
        }
    }
}