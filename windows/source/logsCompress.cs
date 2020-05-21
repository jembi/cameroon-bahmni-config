using System;
using System.IO;

namespace Bahmni
{
    public static class logsCompress
    {
        public static bool doCompression()
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
                    var compressedFilePath = sc.logsPath + @"\" + sc.facilityName + "_" + DateTime.Now.Date.ToString("dd-MMM-yyyy") + ".zip";

                    appHelper.deleteCompressedFileFromFacilityServer(compressedFilePath);// First delete compressed file if it already exists

                    if (!Directory.Exists(sc.logsPath + @"\" + DateTime.Now.Date.ToString("MMM")))
                    {
                        Directory.CreateDirectory(sc.logsPath + @"\" + DateTime.Now.Date.ToString("MMM"));
                    }

                    System.IO.Compression.ZipFile.CreateFromDirectory(sc.logsPath + @"\" + DateTime.Now.Date.ToString("MMM"), compressedFilePath);

                    appHelper.setLastDateLogsCompressed();

                    return true;
                }
                catch (Exception error)
                {
                    appHelper.WriteLog("Unable to compress the log files: " + error.Message);
                }
            }

            return false;
        }
    }
}
