using System;
using System.IO;
using System.Linq;
using System.Net;
using System.Runtime.InteropServices;

namespace Bahmni
{
    public static class internetConnection
    {
        [DllImport("wininet.dll")]
        private extern static bool InternetGetConnectedState(out int description, int reservedValue);
        public static bool IsInternetAvailable()
        {
            try
            {
                int description;

                if (InternetGetConnectedState(out description, 0)) //Only log if an internet connection is found
                {
                    if (networkConnectionStateChanged(true))
                    {
                        appHelper.WriteLog("Internet connection detected!"
                           + Environment.NewLine + "Connection speed: " + verifyInternetConnectionSpeed() + "KB/s"
                           );

                        return true;
                    }
                }
                else
                {
                    if (networkConnectionStateChanged(false))
                    {
                        appHelper.WriteLog("No internet connection detected!");
                    }
                }
            }
            catch (Exception error)
            {
                appHelper.WriteLog("Unable to verify the state of the internet connection: " + error.Message);
            }

            return false;
        }

        private static bool networkConnectionStateChanged(bool internetIsDetected)
        {
            const string SECTION_NAME = "NetworkConnection";
            const string FILE_NAME = "connectionState.ini";
            const string INTERNET_ENABLED_SECTION_KEY = "InternetEnabled";

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
                    if (File.Exists(sc.executionDirectory + @"\" + FILE_NAME))
                    {
                        var parser = new IniFile(sc.executionDirectory + @"\" + FILE_NAME);
                        var keyAlreadyApplied = false;

                        var networkConnectionKeys = parser.EnumSection(SECTION_NAME);

                        if (networkConnectionKeys != null)
                        {
                            foreach (string key in networkConnectionKeys)
                            {
                                if (key == INTERNET_ENABLED_SECTION_KEY)
                                {
                                    if (parser.Read(key, SECTION_NAME) != "Unspecified")
                                    {
                                        keyAlreadyApplied = true;
                                    }
                                }
                            }
                        }

                        if(!keyAlreadyApplied)
                        {
                            parser.Write(INTERNET_ENABLED_SECTION_KEY, internetIsDetected.ToString(), SECTION_NAME);

                            return true;
                        }
                        else
                        {
                            if (parser.Read(INTERNET_ENABLED_SECTION_KEY, SECTION_NAME) != internetIsDetected.ToString())
                            {
                                parser.Write(INTERNET_ENABLED_SECTION_KEY, internetIsDetected.ToString(), SECTION_NAME);

                                return true;
                            }
                        }
                    }
                    else
                    {
                        appHelper.WriteLog("Unable to update the " + INTERNET_ENABLED_SECTION_KEY + " value in " + FILE_NAME + ": File not found!");
                    }
                }
                catch(Exception error)
                {
                    appHelper.WriteLog("Unable to update the " + INTERNET_ENABLED_SECTION_KEY + " value in " + FILE_NAME + ": " + error.Message);
                }
            }

            return false;
        }

        private static double verifyInternetConnectionSpeed()
        {
            var sc = new serviceConfig();

            sc.getServiceSettingsXml();

            if (sc.errorMsg != null)
            {
                appHelper.WriteLog(sc.errorMsg);
            }
            else
            {
                var speeds = new double[5];

                for (int i = 0; i < 5; i++) // Do the test 5 times
                {
                    int jQueryFileSize = 261; //Size of File to be downloaded in KB.

                    using (var client = new WebClient())
                    {
                        DateTime startTime = DateTime.Now; //Start of test

                        client.DownloadFile("http://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.js", sc.executionDirectory + @"/jQuery.js"); //The file to be downloaded to test the connection speed

                        DateTime endTime = DateTime.Now; //End of test

                        speeds[i] = Math.Round((jQueryFileSize / (endTime - startTime).TotalSeconds)); //Total time taken to download the file
                    }
                }

                //Delete the file when done with the speed test
                if (File.Exists(sc.executionDirectory + @"/jQuery.js"))
                {
                    File.Delete(sc.executionDirectory + @"/jQuery.js");
                }

                return speeds.Average(); //Get average result only
            }

            return 0;
        }
    }
}
