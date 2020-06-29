using System;
using System.IO;
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

        private void initializeVmStatusTimer(serviceConfig conf)
        {
            appHelper.WriteLog("Bahmni service started..."
                 + Environment.NewLine + "Checking VM status every: " + conf.timerIntervalMins + "min"
                 + Environment.NewLine + "Facility name: " + conf.facilityName
                 + Environment.NewLine + "Backup wait time: " + conf.backupWait + "min");

            var vmStatusCheckTimer = new System.Timers.Timer();
            vmStatusCheckTimer.Interval = TimeSpan.FromMinutes(conf.timerIntervalMins).TotalMilliseconds;
            vmStatusCheckTimer.Elapsed += getVmStatus;
            vmStatusCheckTimer.Enabled = true;
            vmStatusCheckTimer.Start();
        }

        private void initializeInternetConnectionCheckTimer()
        {
            var internetCheckTimer = new System.Timers.Timer();
            internetCheckTimer.Interval = 1 * 10 * 1000; //Check every 10sec
            internetCheckTimer.Elapsed += checkConnection;
            internetCheckTimer.Enabled = true;
            internetCheckTimer.Start();
        }

        private void handleLogCompressionAndRequestUpload(serviceConfig conf, string fileName)
        {
            if (logsCompress.doCompression())
            {
                appHelper.WriteLog("The logs file has been successfully compressed!");

                googleDrive gd = new googleDrive();
                gd.uploadCompressedFile(conf.facilityName, fileName);
            }
        }

        private void checkConnection(object sender, System.Timers.ElapsedEventArgs e)
        {
            if (internetConnection.IsInternetAvailable())
            {
                var sc = new serviceConfig();

                sc.getServiceSettingsXml();

                var file = sc.logsPath + @"\" + sc.facilityName + "_" + DateTime.Now.Date.ToString("dd-MMM-yyyy") + ".zip";

                if (sc.errorMsg != null)
                {
                    appHelper.WriteLog(sc.errorMsg);
                }
                else
                {
                    var lastDateLogsCompressed = appHelper.getLastDateLogsCompressed();

                    if (lastDateLogsCompressed != null)
                    {
                        DateTime dateLastCompressedValue;

                        if (DateTime.TryParse(lastDateLogsCompressed, out dateLastCompressedValue))
                        {
                            if (dateLastCompressedValue.ToString("dd-MMM-yyyy") != DateTime.Now.Date.ToString("dd-MMM-yyyy"))
                            {
                                handleLogCompressionAndRequestUpload(sc, file);
                            }
                            else
                            {
                                if (!File.Exists(file))
                                {
                                    var lastDateUploaded = appHelper.getLastDateLogsUploaded();

                                    if (lastDateUploaded != null)
                                    {
                                        if (lastDateUploaded == "Unspecified")
                                        {
                                            handleLogCompressionAndRequestUpload(sc, file);
                                        }
                                        else
                                        {
                                            DateTime dateLastUploadedValue;

                                            if (DateTime.TryParse(lastDateUploaded, out dateLastUploadedValue))
                                            {
                                                if (dateLastUploadedValue.ToString("dd-MMM-yyyy") != DateTime.Now.Date.ToString("dd-MMM-yyyy"))
                                                {
                                                    handleLogCompressionAndRequestUpload(sc, file);
                                                }
                                            }
                                        }
                                    }
                                    else
                                    {
                                        appHelper.WriteLog("Unable to verify a null last upload date for the logs...Logs not uploaded!");
                                    }
                                }
                            }
                        }
                        else
                        {
                            appHelper.WriteLog("Unable to convert the last date logs compressed value to DateTime...Logs not compresssed!");
                        }
                    }
                    else
                    {
                        appHelper.WriteLog("Unable to verify a null last compressed date for the logs...Logs not compressed!");
                    }
                }
            }
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
                //First wait 30seconds before starting the timer for vm status checks
                Action vmStatusTimer = () => initializeVmStatusTimer(sc);
                callWithDelay(vmStatusTimer, 1 * 30 * 1000);

                //Start VM immediately after a shutdown if its not running. First wait 1min before calling the function to check the VM status
                Action checkVmStatus = () => vmStatus();
                callWithDelay(checkVmStatus, 1 * 60 * 1000);

                //First wait 1min before starting the timer for checking the network for internet connectivity
                Action internetCheckTimer = () => initializeInternetConnectionCheckTimer();
                callWithDelay(internetCheckTimer, 1 * 60 * 1000);
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
                        process.Close();
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
                        process.Close();
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

        private void vmStatus(bool isCheckToVerifyVmIsRunningAfterCallingVmStart = false, int vmStartAttemptLimit = 0)
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
                bool vmIsRunning = false;

                if (!isCheckToVerifyVmIsRunningAfterCallingVmStart)
                    appHelper.WriteLog("Checking Bahmni VM status...");
                else
                    appHelper.WriteLog("Verifying whether the VM was started...");

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
                                vmIsRunning = true;

                                appHelper.WriteLog("VM is running!");
                            }

                            standardOutput = null;
                        }

                        using (process.StandardError)
                        {
                            appHelper.WriteLog(process.StandardError.ReadToEnd());
                        }

                        process.WaitForExit();
                        process.Close();
                    }
                }
                catch (Exception error)
                {
                    appHelper.WriteLog("An error occurred while verifying the VM status! " + error.Message);
                }

                //Only call startVM() when the parent process has exited            
                if (!isCheckToVerifyVmIsRunningAfterCallingVmStart && vmMustStart)
                {
                    startVm();
                }

                //After starting the VM perform a VM backup
                if (isCheckToVerifyVmIsRunningAfterCallingVmStart)
                {
                    if (vmIsRunning) //Make sure that the VM is running
                    {
                        //Wait before calling the backupVM() function to ensure that the VM has had enough time to start all services, default = 2min
                        Action backupVM = () => backupVm();
                        callWithDelay(backupVM, Convert.ToInt32(TimeSpan.FromMinutes(sc.backupWait).TotalMilliseconds));
                    }
                    else
                    {
                        if (vmStartAttemptLimit == 0)
                        {
                            appHelper.WriteLog("First attempt to start VM failed! Retrying one more time...");

                            startVm(1); //Allow service to try one more time and if the VM is stil not running then wait for the configured interval to try again, default = 15min
                        }
                    }
                }
            }
        }

        private void getVmStatus(object sender, System.Timers.ElapsedEventArgs e)
        {
            vmStatus();
        }

        private string readStartupCommands(serviceConfig conf)
        {
            var vagrantCommands = string.Empty;
            var lineCount = 0;

            try
            {
                using (var reader = File.OpenText(conf.executionDirectory + @"\startupCommands.txt"))
                {
                    var line = string.Empty;

                    while ((line = reader.ReadLine()) != null)
                    {
                        if (lineCount > 0)
                        {
                            vagrantCommands += " && ";
                        }

                        vagrantCommands += line;

                        lineCount++;
                    }

                    line = null;
                }

                return vagrantCommands;
            }
            catch (Exception error)
            {
                appHelper.WriteLog("Unable to access or read the startupCommands.txt file! " + error.Message);
            }
            finally
            {
                vagrantCommands = null;
                lineCount = 0;
            }

            return null;
        }

        private void backupVm()
        {     
            var sc = new serviceConfig();

            sc.getServiceSettingsXml();

            if (sc.errorMsg != null)
            {
                appHelper.WriteLog(sc.errorMsg);
            }
            else
            {
                appHelper.WriteLog("Backing up Bahmni VM...");

                try
                {
                    using (var process = new Process())
                    {
                        var commands = "\"" + readStartupCommands(sc) + "\"";

                        appHelper.WriteLog("Executing command(s): " + commands);

                        initialiseCmdProcess(process, "vagrant ssh --command " + commands, sc);

                        using (process.StandardOutput)
                        {
                            appHelper.WriteLog(process.StandardOutput.ReadToEnd());
                        }

                        using (process.StandardError)
                        {
                            appHelper.WriteLog(process.StandardError.ReadToEnd());
                        }

                        process.WaitForExit();
                        process.Close();
                    }
                }
                catch (Exception error)
                {
                    appHelper.WriteLog("An error occurred while backing up the VM! " + error.Message);
                }
            }
        }

        private void startVm(int limit = 0)
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
                        process.Close();
                    }

                    //Verify whether the VM started successfully
                    //First wait 1min before calling the function to check the VM status
                    Action checkVmStatus = () => vmStatus(true, limit);
                    callWithDelay(checkVmStatus, 1 * 60 * 1000);
                }
                catch (Exception error)
                {
                    appHelper.WriteLog("An error occurred while starting the VM! " + error.Message);
                }
            }
        }
    }
}