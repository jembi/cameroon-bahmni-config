## Bahmni Windows Service
=============================

### Background
The purpose of the Bahmni Service is to automatically start and gracefully halt a Vagrant Virtual Machine (VM) in a Windows environment. 

The service operates as follows:

1. At configured intervals, checks to see if the VM is running
1. If the VM is not running, start the VM
    * Once the VM has started, the service will automatically SSH into the VM and execute a backup using command __*sudo /home/bahmni/cameroon-backups.sh*__ For more info, see section __Startup Commands__.
1. If the VM is running and the service is stopped (user action or when the hosting windows machine has been shutdown), the service will gracefully shutdown the VM before allowing the hosting machine to complete its shutdown cycle. In summary, when the hosting machine begins its shutdown, a signal is sent to the service's OnStop() function so that it can execute a process that begins and waits for a Vagrant VM to be gracefully shutdown. The service will automatically add 10sec after every elapsed 10secs to ensure that the service completes the vagrant halt and is able to verify that the machine is powered off.

The windows service is configured to automatically start (__*after 1min*__) whenever the windows server is booted up. The default interval for checking the status of the VM is 10mins. __Note__: The service __does not__ require a user to logon in order for the VM to start. 

### MSI Configuration Steps
__Note__: Once you have installed the service, you must download and use [Putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) to SSH into the VM going forward. 

Assuming that VirtualBox is already installed on a 64bit Windows Professional machine together with the Bahmni Vagrant CentOS instance, please follow these steps to install and configure the Bahmni Windows Service:

1. Make sure that the system date and time is correct. Please see sectipn [Internet Time](#Internet-Time)
1. Open the vagrant root directory and permanently delete the temporary vagrant-start.bat script as it will no longer be used and may cause conflict.
1. Open a CMD terminal in Windows and navigate to the vagrant root directory and then execute command __*vagrant halt*__
1. Download and install the [Bahmni Service MSI](https://github.com/jembi/cameroon-openmrs-module-bahmniapps/releases/download/v1.5.0/Bahmni.Service.msi) on your windows server.
      *  During installation you will be prompted to confirm the following:
         1. The Vagrant root directory on the windows server (This is the directory where the Vagrantfile file is stored). __IT IS ESSENTIAL THAT YOU ENSURE THAT THE DIRECTORY IS CORRECT!__
            *  __Note__: If the directory changes after installation of the service, you must navigate to the path C:\Program Files\Jembi Health Systems\Bahmni\ and update the element __EXECUTION_DIRECTORY__ in serviceConfig.xml with the new directory name. __Do not add a \ after the directory path!__* You will then need to copy all of the files from the scripts folder to the new directory that you specified in the EXECUTION_DIRECTORY element.
            *  __Note__: The files vagrantUp.bat, vagrantHalt.bat, vagrantStatus.bat, stopBahmni.ps1 and startupCommands.txt will be copied to the vagrant root directory as __hidden files__.
         1. The logs directory on the windows server where the Bahmni service will log all events
         1. Service Login - This is the administrative account that was used at the time of installing the VM. 
             * *__Note__: When specifying the Username, make sure to enter the prefix .\ in front of the username. For example, .\MyUserName*
5. Once the installation has completed, the service will automatically start the VM. This can take up to around 5mins. Keep an eye on the logs found in path __*C:\EMR\bahmni\bahmni-service-logs*__

### Group Policy (GPO) Editor Configuration Steps
__*Note*__: *The Bahmni service automatically handles the following group policy requirements.*

To verify or manually add the group policy requirements, open the local group policy on the Windows machine by opening a CMD window and typing __*gpedit.msc*__ (__Note__: If there is no local group policy available in your version of Windows then it is not guaranteed that your VM will receive a graceful shutdown when the Windows Server is Restarted or Shutdown).

#### Configure Shutdown Script
1. Navigate to the following path in the GPO editor: __*Computer Configuration/Windows Settings/Scripts (Startup/Shutdown)*__
1. Double click on Shutdown and click on the tab called PowerShell Scripts
1. Click on Add button and navigate to the Vagrant root path where the file __stopBahmni.ps1__ is saved, select the file and click on Open
1. Leave the Script Parameters box blank and click on OK button
1. At the bottom of the Window there is a dropdown that allows you to specify the running order of the scripts. Click on the dropdown and select __*Run Windows PowerShell scripts first*__
1. Click on Apply button then OK button

#### Configure Power Management
This section describes how to leverage the local GPO on the Windows Server to automatically and gracefully shutdown the server when the battery level reaches a capacity of 15%. This is critical step to ensure that the Windows machine can shutdown both the VM and itself before running out of battery power. This also reduces the risk of facing corrupted files in both systems. __Note__: It is recommended that the battery level of 15% is not changed as the VM could need up to 2min to gracefully shutdown. Also, this section indicates the GPO settings that prevent the hard disk from turning off, prevent the system from going to sleep after a period of inactivity and to prevent the system from hibernating.

##### Critical battery notification action
1.  Navigate to the following path in the GPO editor: __*Computer Configuration/Administrative Templates/System/Power Management/Notification Settings*__
1.  Double click on Critical battery notification action:
    *  Click on the __*Enable*__ radio button
    *  In the Critical Battery Notification Action dropdown, select Shut down
3.  Click on Apply button then OK button

##### Critical battery notification level
1.  Navigate to the following path in the GPO editor: __*Computer Configuration/Administrative Templates/System/Power Management/Notification Settings*__
1.  Double click on Critical battery notification level:
    *  Click on the __*Enable*__ radio button
    *  In the Critical Battery Notification Level listbox, enter 15
3.  Click on Apply button then OK button

##### Hard Disk Settings
1.  Navigate to the following path in the GPO editor: __*Computer Configuration/Administrative Templates/System/Power Management/Hard Disk Settings*__
1.  Double click on Turn Off the hard disk (plugged in):
    *  Click on the __*Enable*__ radio button
    *  In the Turn Off the Hard Disk (seconds) listbox, enter 0
3.  Click on Apply button then OK button
1.  Double click on Turn Off the hard disk (on battery):
    *  Click on the __*Enable*__ radio button
    *  In the Turn Off the Hard Disk (seconds) listbox, enter 0
1.  Click on Apply button then OK button

##### Sleep Settings
1.  Navigate to the following path in the GPO editor: __*Computer Configuration/Administrative Templates/System/Power Management/Sleep Settings*__
1.  Double click on Specify the system sleep timeout (plugged in):
    *  Click on the __*Enable*__ radio button
    *  In the System Sleep Timeout (seconds) listbox, enter 0
3.  Click on Apply button then OK button
1.  Double click on Specify the system sleep timeout (on battery):
    *  Click on the __*Enable*__ radio button
    *  In the System Sleep Timeout (seconds) listbox, enter 0
1.  Click on Apply button then OK button

##### Hibernate Settings
1.  Navigate to the following path in the GPO editor: __*Computer Configuration/Administrative Templates/System/Power Management/Sleep Settings*__
1.  Double click on Specify the system hibernate timeout (plugged in):
    *  Click on the __*Enable*__ radio button
    *  In the System Hibernate Timeout (seconds) listbox, enter 0
3.  Click on Apply button then OK button
1.  Double click on Specify the system hibernate timeout (on battery):
    *  Click on the __*Enable*__ radio button
    *  In the System Hibernate Timeout (seconds) listbox, enter 0
1.  Click on Apply button then OK button

##### Button Settings
1.  Navigate to the following path in the GPO editor: __*Computer Configuration/Administrative Templates/System/Power Management/Button Settings*__
1.  Double click on Select the lid switch action (plugged in):
    *  Click on the __*Enable*__ radio button
    *  In the List Switch Action listbox, select Shutdown
3.  Click on Apply button then OK button
1.  Double click on Select the lid switch action (on battery):
    *  Click on the __*Enable*__ radio button
    *  In the List Switch Action listbox, select Shutdown
1.  Click on Apply button then OK button

### Configure Fast Startup (Hiberboot)
This section describes how to leverage the local GPO on the Windows Server to disable hiberboot so that the service can request a graceful shutdown of the VM before allowing windows to terminate the service and shutdown.

1.  Navigate to the following path in the registry editor: __*HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power*__
1.  Add/Set HiberbootEnabled as a DWORD key and set the value to 0.

### Startup Commands
After the installation has taken place, a file called startupCommands.txt will be create in the vagrant root directory (the directory you specified at the time of installation). This file will allow the service to execute one or more commands by passing the commands as an argument to the vagrant command __*vagrant ssh --command [My Commands]*__. __Note__: When using more than one command, vagrant requires that the first command executes properly without any errors before allowing other commands to be executed. Multiple commands can be executed using the operator && between commands. For example, vagrant ssh --command "Command 1 && Command2". Command2 will only execute if Command1 is valid and can be executed by CentOS with no errors thrown.

### Bahmni Service Logs
This section describes the key mechanisms of the service to monitor the Windows server for internet connectivity, to detect a change in the connection state and if internet connectivity has been detected, compress the current month's folder for the logs and if compression was successful, upload the compressed file to the facility folder in the Google drive repo. The compressed file is automatically deleted from the Windows server.

#### Google Drive
The Bahmni service will automatically compress all of the __*Bahmni service*__ logs for the current month and upload to the shared Google Drive [Bahmni Service Logs](https://drive.google.com/drive/folders/1a-tFW2Kn_8On39pbipl09UreJBtQglQS). The service will automatically create each facility folder in the Google Drive repo so that logs can be grouped together in the appropriate facility folder. The service also ensures that there is only one compressed file per month in the Google Drive repo by deleting the existing file before uploading the more current file for the month.  

##### Connection State Monitoring
The service has been designed to work with frequent internet connection outages. In other words, the service will continue to try and compress the current month's logs and upload the file to Google Drive and will continue to do so until the file has been uploaded. Once the file has been uploaded, the service __*will not*__ upload another compressed log file for the same day. The service will only log the __*first occurrence*__ for each internet connection detected or connection dropped state whenever the internet has been connected or disconnected. When internet connectivity has been detected, the service also performs an internet connection speed test by downloading a 261KB file 5 times and the average speed recorded in the service log. The downloaded files are automatically deleted. The service records when a successful compression took place as well as when the compressed file has been successfully uploaded to Google Drive. The below triggers help describe how the service handles this process.

###### Triggers
Whenever there is a change in the connection state, the current state of the internet connection is recorded in the connectionState.ini file, together with the last known dates for compressed logs and logs upload events. The logs file appears as follows. The value of unspecified is simply a default value to tell the service that no attempts have been made to compress and upload the logs file.

\[NetworkConnection\]\
InternetEnabled=Unspecified - Uses True of False values\
LastDateLogsUploaded=Unspecified - The last known successful upload date\
LastDateLogsCompressed=Unspecified - The last known successful compression date

The service uses the above file for the following:
1. Check to see if the Windows server has an active internet connection
1. If internet has been detected, __*only then*__ check:
   *  The last compressed date - if the value is Unspecified or if the date is the previous day, only then perform a compression of the logs
   *  The last upload date - if the value is Unspecified or if the date is the previous day, only then request an upload of the logs to Google Drive.

## Internet Time
It is essential that the Windows server has the correct date and time applied otherwise the service will not be able to autheticate with the Google Drive API for compressed log file uploads. Also, if the date and/or time is incorrect, the daily log files will be split across a range of new log files depending on how far out the server time is.

The following steps explains how to synchronize the server time with an NTP server (internet time) (__*Note*__: Once this step is done, you will not need to do it again, even if there is no internet connectivity):
1. Open Control Panel.
1. Click on Clock, Language, and Region.
1. Click on Date and Time.
1. Click on the Internet Time tab.
1. Click the Change settings button.
1. Check that the Synchronize with an internet time server option is selected.
1. Keep the default server select
1. Click the Update now button to synchronize the time with the new server.
1. Click on Apply button then click on OK button.

__*Note*__: Depending on the internet connection speed, this could take up to 1min before the correct date/time is displayed.
