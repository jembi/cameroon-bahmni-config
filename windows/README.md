## Bahmni Windows Service
===================================

#### Background
The purpose of the Bahmni Service is to automatically start and shutdown a VirtualBox Virtual Machine (VM). 
The service operate as follows:
1. At configured intervals, checks to see if the Bahmni CentOS VM is running by querying the list of running VMs using command _VBoxManage.exe list runningvms_
2. If the VM is not running, start the VM using the command _VBoxManage.exe startvm Bahmni --type headless_ 
* The parameter --type headless means that the VM must be started in VirtualBox without opening a window.
3. If the VM is running and the service is stopped (user or when the hosting windows machine has been shutdown), the service will use the command _VBoxManage.exe controlvm Bahmni acpipowerbutton_ to gracefully shutdown the VM

The winows service is configured to automatically start whenever the windows server is booted up.

#### Configuration Steps
Assuming that VirtualBox is already installed on the windows server together with the Bahmni Vagrant CentOS instance, please follow these steps to install and configure the Bahmni Windows Service:
1. Login to the Bahmni VM and install ACPID (required for gracefull shutdown of VM):
* yum install acpid
* chkconfig acpid on
* service acpid start
2. Download and install the MSI: https://github.com/jembi/cameroon-bahmni-config/tree/COM-823/windows/Setup
3. Open up a CMD window on windows machine and run command _services.msc_
* look for the service name _Bahmni_, right click on the service then go to properties. 
* In the Log On tab, click on _This Account_ radio button and specify the windows credentials for the user profile under which the Bahmni VM was installed. For example, if the user _Administrator_ was used when installing the Bhamni VM, then you must specify the Administrator credentials.
* Restart the Bahmni windows service by right clicking on the service and selecting _restart_
4. Open the file _serviceConfig.xml_ in path _C:\Program Files\Jembi Health Systems\Bahmni Service_ and specify the appropriate values for:
* VM Name (The name of the Bahmni VM)
* Logs Path (The path on the windows server where the Bahmni Service will log events)
* Timer Interval (How often do you want the service to check and make sure that the bahmni VM is running)
5. Restart the Bahmni windows service by opening CMD window on windows machine and run command _services.msc_, look for _Bahmni_ service, right click on the service and select restart
