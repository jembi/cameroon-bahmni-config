## Bahmni Windows Service
=============================

### Background
The purpose of the Bahmni Service is to automatically start and gracefully halt a Vagrant Virtual Machine (VM). 

The service operates as follows:

1. At configured intervals, checks to see if the VM is running
1. If the VM is not running, start the VM
    * Once the VM has started, the service will automatically SSH into the VM and execute a backup using command __*sudo /home/bahmni/cameroon-backups.sh*__ For more info, see section __Startup Commands__.
1. If the VM is running and the service is stopped (user action or when the hosting windows machine has been shutdown), the service will gracefully shutdown the VM before allowing the hosting machine to complete its shutdown cycle. In summary, when the hosting machine begins its shutdown, a signal is sent to the service's OnStop() function so that it can execute a process that begins and waits for a Vagrant VM to be gracefully shutdown. The service will automatically add 10sec after every elapsed 10secs to ensure that the service completes the vagrant halt and is able to verify that the machine is powered off.

The windows service is configured to automatically start (__*after 1min*__) whenever the windows server is booted up. The deafult interval for checking the status of the VM is 10mins. __Note__: The service __does not__ require a user to logon in order for the VM to start. 

### MSI Configuration Steps
Assuming that VirtualBox is already installed on a 64bit Windows Professional machine together with the Bahmni Vagrant CentOS instance, please follow these steps to install and configure the Bahmni Windows Service:

1. Download and install the [Bahmni Service MSI](https://github.com/jembi/cameroon-openmrs-module-bahmniapps/releases/download/v1.5.0/Bahmni.Service.msi) on your windows server.
   **  During installation you will be prompted to confirm the following:
      1. The Vagrant root directory on the windows server (This is the directory where the Vagrantfile file is stored). __IT IS ESSENTIAL THAT YOU ENSURE THAT THE DIRECTORY IS CORRECT!__
         * *__Note__: If the directory changes after installation of the service, you must navigate to the path C:\Program Files\Jembi Health Systems\Bahmni\ and update the element __EXECUTION_DIRECTORY__ in serviceConfig.xml with the new directory name. __Do not add a \ after the directory path!__* You will then need to copy all of the files from the scripts folder to the new directory that you specified in the EXECUTION_DIRECTORY element.
      1. The logs directory on the windows server where the Bahmni service will log all events
      1. Service Login - This is the administrative account that was used at the time of installing the VM. 
          * *__Note__: When specifying the Username, make sure to enter the prefix .\ in front of the username. For example, .\MyUserName*

### Group Policy (GPO) Editor Configuration Steps
__*Note*__: *The Bahmni service automatically handles the following group policy requirements.*

To verify or manually add the group policy requirements, open the local group policy on the Windows machine by opening a CMD window and typing __*gpedit.msc*__ (__Note__: If there is no local group policy available in your version of Windows then it is not gauranteed that your VM will receive a gracefull shutdown when the Windows Server is Restarted or Shutdown).

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

### Configure Fast Startup (Hiberboot)
This section describes how to leverage the local GPO on the Windows Server to disable hiberboot so that the service can request a gracefull shutdown of the VM before allowing windows to terminate the service and shutdown.

1.  Navigate to the following path in the registry editor: __*HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Power*__
1.  Add/Set HiberbootEnabled as a DWORD key and set the value to 0.

### Startup Commands
After the installation has taken place, a file called startupCommands.txt will be create in the vagrant root directory (the directory you specified at the time of installation). This file will allow the service to execute one or more commands by passing the commands as an argument to the vagrant command __*vagrant ssh --command [My Commands]*__. __Note__: When using more than one command, vagrant requires that the first command executes properly without any errors before allowing other commands to be executed. Multiple commands can be executed using the operator && between commands. For example, vagrant ssh --command "Command 1 && Command2". Command2 will only execute if Command1 is valid and can be executed by CentOS with no errors thrown.
