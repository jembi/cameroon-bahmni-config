using System;
using System.IO;
using Google.Apis.Drive.v3;
using Google.Apis.Auth.OAuth2;
using Google.Apis.Services;
using System.Reflection;
using System.Security.Cryptography.X509Certificates;
using System.Collections.Generic;
using System.Linq;
using System.Configuration;

namespace Bahmni
{
    public class googleDrive
    {
        readonly string[] scopes = { DriveService.Scope.Drive };

        const string BAHMNI_SERVICE_LOGS_GOOGLE_DRIVE_REPO_ID = "1a-tFW2Kn_8On39pbipl09UreJBtQglQS";
        const string SERVICE_ACCOUNT_EMAIL_ADDRESS = "bahmniservice@bahmniservice.iam.gserviceaccount.com";
        const string APPLICATION_NAME = "BahmniService";

        public void uploadCompressedFile(string facilityName, string filePath)
        {
            var service = getDriveService();

            if (service != null)
            {
                ListEntities(service, facilityName, filePath);
            }
        }

        private Google.Apis.Drive.v3.DriveService getDriveService()
        {
            try
            {
                var p12FilePath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + @"\bahmniservice.p12";

                if (File.Exists(p12FilePath))
                {
                    var certificate = new X509Certificate2(p12FilePath, Properties.Settings.Default.secret, X509KeyStorageFlags.Exportable);

                    var credential = new ServiceAccountCredential(
                        new ServiceAccountCredential.Initializer(SERVICE_ACCOUNT_EMAIL_ADDRESS)
                        {

                            Scopes = scopes
                        }.FromCertificate(certificate));

                    var service = new Google.Apis.Drive.v3.DriveService(new BaseClientService.Initializer()
                    {
                        HttpClientInitializer = credential,
                        ApplicationName = APPLICATION_NAME
                    });

                 
                    return service;
                }
            }
            catch (Exception error)
            {
                appHelper.WriteLog("Get DriveService failed: " + error.Message);
            }

            return null;
        }

        private void ListEntities(Google.Apis.Drive.v3.DriveService drvService, string facility, string facilityFile)
        {
            try
            {
                var folderID = String.Empty;

                var facilityFolderIdIfExists = CheckFolder(drvService, facility);

                if (facilityFolderIdIfExists == null)
                {
                    folderID = CreateFolderInFolder(drvService, facility);
                }
                else
                {
                    folderID = facilityFolderIdIfExists;
                }

                var listRequest = drvService.Files.List();

                listRequest.PageSize = 100;
                listRequest.Fields = "nextPageToken, files(id, name, parents, createdTime, modifiedTime, mimeType)";
                listRequest.Q = $"'{folderID}' in parents";

                // List files.
                var files = listRequest.Execute().Files;

                if (files != null && files.Count > 0)
                {
                    foreach (var file in files)
                    {
                        if (file.Name.ToLower().Contains(facility.ToLower()))
                        {
                            permanentlyRemove(file.Id, file.Name, drvService);
                        }
                    }
                }

                UploadFile(drvService, facility, facilityFile, folderID);
            }
            catch (Exception error)
            {
                appHelper.WriteLog("Something went wrong while checking for the existence of facility logs" + error.Message);
            }
        }

        private void permanentlyRemove(string id, string name, Google.Apis.Drive.v3.DriveService service)
        {
            try
            {
                service.Files.Delete(id).Execute();
            }
            catch (Exception error)
            {
                appHelper.WriteLog("Unable to delete the log file " + name + "! " + error.Message);
            }
        }

        private void UploadFile(Google.Apis.Drive.v3.DriveService service, string facilityName, string fileForUpload, string folderID)
        {
            try
            {
                var fileMetaData = new Google.Apis.Drive.v3.Data.File()
                {
                    Name = Path.GetFileName(fileForUpload),
                    Parents = new List<string>
                    {
                        folderID
                    }
                };

                FilesResource.CreateMediaUpload request;

                using (var stream = new System.IO.FileStream(fileForUpload, System.IO.FileMode.Open))
                {
                    request = service.Files.Create(fileMetaData, stream, "application/zip");
                    request.Fields = "id";
                    request.Upload();
                }

                if (request.ResponseBody.Id != null)
                {
                    appHelper.setLastDateLogsUploaded();

                    appHelper.deleteCompressedFileFromFacilityServer(fileForUpload);

                    appHelper.WriteLog("Compressed log file successfully uploaded for facility " + facilityName);
                }
                else
                {
                    appHelper.WriteLog("Failed to upload the compressed log file for facility " + facilityName);
                }
            }
            catch (Exception error)
            {
                appHelper.WriteLog("Unable to upload the log file for facility " + facilityName + "! " + error.Message);
            }
        }

        private string CreateFolderInFolder(Google.Apis.Drive.v3.DriveService service, string facilityName)
        {
            try
            {
                var fileMetaData = new Google.Apis.Drive.v3.Data.File()
                {
                    Name = Path.GetFileName(facilityName),
                    MimeType = "application/vnd.google-apps.folder",
                    Parents = new List<string>
                   {
                       BAHMNI_SERVICE_LOGS_GOOGLE_DRIVE_REPO_ID
                   }
                };

                Google.Apis.Drive.v3.FilesResource.CreateRequest request;

                request = service.Files.Create(fileMetaData);

                request.Fields = "id";

                return request.Execute().Id;
            }
            catch (Exception error)
            {
                appHelper.WriteLog("Unable to create a folder for facility " + facilityName + "! " + error.Message);
            }

            return null;
        }

        private string CheckFolder(Google.Apis.Drive.v3.DriveService service, string facility)
        {
            try
            {
                // Define the parameters of the request.    
                var FileListRequest = service.Files.List();
                FileListRequest.Fields = "nextPageToken, files(*)";

                // List files.    
                var files = FileListRequest.Execute().Files;

                //For getting only folders    
                files = files.Where(x => x.MimeType == "application/vnd.google-apps.folder" && x.Name.ToLower() == facility.ToLower()).ToList();

                if (files != null)
                {
                    foreach (var n in files)
                    {
                        return n.Id;
                    }
                }
            }
            catch (Exception error)
            {
                appHelper.WriteLog("Unable to check for the existence of the facility folder " + facility + "! " + error.Message);
            }

            return null;
        }
    }
}
