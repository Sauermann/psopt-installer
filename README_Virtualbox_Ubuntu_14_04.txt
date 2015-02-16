Installation of Ubuntu in a virtual machine under Windows
Last tested 2015-02-16

1. Installation of VirtualBox

Download http://download.virtualbox.org/virtualbox/4.3.6/VirtualBox-4.3.6-91406-Win.exe
Install VirtualBox-4.3.6

2. Creation of Ubuntu virtual machine on Virtual Box

Download http://releases.ubuntu.com/14.04/ubuntu-14.04.1-desktop-amd64.iso
Start VirtualBox
Create new Virtual Machine
Name: UbuPsopt
Type: Linux
Version: Ubuntu (64 bit)
Memory size: 2048MB (optionally more if available)
Create virtual hard drive
VDI
Dynamically allocated
8,00 GB or more
In VirtualBox: select UbuPsopt and click on "Settings"
General->Advanced->Shared Clipboard: Bidirectional
System->Processor: 2 CPUs
System->Processor: + Enable PAE/NX
Display->Video: + Enable 3D Acceleration
Storage->Controller->IDE->Empty:Chose a virtual CD/DVD disk file: ubuntu-12.04.5-desktop-amd64.iso
Network->Adapter 1->Attached to: Bridged Adapter
Network->Adapter 1->Name: <select your network interface>
Click "OK" at the bottom of the window to save the configuration

3. Installation of Ubuntu Trusty Tahr 14.04.5

In VirtualBox: select DepPsopt and click on "Start"
<click on Install Ubuntu>
Preparing to install Ubuntu -> Continue
Erase disk and install Ubuntu -> Continue
-> Install Now
Where are you? <your choice>
Keyboard layout <your choice>
Who are you?
Your name: <your choice>
computers name: ubupsopt
username: <your choice for this document we assume USER>
<the other options on this page are up to you> -> <continue>
Installing system: <wait ...>
<click on Restart Now>
<press ENTER>

4. Update
You might need to enter your password for some of these commands
If a browser window pops up, close it.

Login Screen: <enter password>
<press Ctrl-Alt-T to open a terminal>

USER@ubupsopt:~$ sudo apt-get update
USER@ubupsopt:~$ sudo apt-get dist-upgrade
<if asked to continue, answer 'y'es>
USER@ubupsopt:~$ sudo apt-get autoremove
<if asked to continue, answer 'y'es>
Reboot the machine (click on the rightmost icon on the menubar)->Shut down->Restart
<a reboot happens>

5. VirtalBox Integration

Login Screen: <enter password>
VirtualBox Menu->Devices->Insert Guest Additions CD Image
<click on Run>
Password: <enter your password>
Press Return to close this window...: <press return>
Rightclick on CD-Icon in the left toolbar->Eject
Reboot the machine (click on the rightmost icon on the menubar)->Shut down->Restart
<a reboot happens>

5. Status

At this point the system is configured and the installation of PSOPT can begin

6. Installation of PSOPT

Login Screen: <enter password>
press Ctrl-Alt-T to open a terminal


USER@ubupsopt:~$ wget https://raw.github.com/Sauermann/psopt-installer/master/uppis.sh
USER@ubupsopt:~$ chmod a+x uppis.sh
USER@ubupsopt:~$ ./uppis.sh
<wait during installation and enter user-password for sudo twice>
