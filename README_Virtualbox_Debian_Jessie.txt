Installation of Debian Jessie in a virtual machine under Windows

Last successfull verified installation: 2015-06-27

1. Installation of VirtualBox

Download http://download.virtualbox.org/virtualbox/4.3.28/VirtualBox-4.3.28-100309-Win.exe
Install VirtualBox-4.3.28

2. Creation of Debian Wheezy virtual machine on Virtual Box

Download http://cdimage.debian.org/debian-cd/8.1.0/amd64/iso-cd/debian-8.1.0-amd64-netinst.iso
Start VirtualBox
Create new Virtual Machine
Name: DebPsopt
Type: Linux
Version: Debian (64 bit)
Memory size: 2048MB (optional 4096 if available)
Create virtual hard drive
VDI
Fixed Size
6,00 GB
In VirtualBox: select DepPsopt and click on "Settings"
General->Advanced->Shared Clipboard: Bidirectional
System->Processor: 2 CPUs
System->Processor: + Enable PAE/NX
Display->Video: + Enable 3D Acceleration
Storage: Controller: IDE->Empty:Chose a virtual CD/DVD disk file: debian-8.1.0-amd64-netinst.iso
Network->Adapter 1: Attached to: Bridged Adapter
Network->Adapter 1: Name: <select your network interface>
Click "OK" at the bottom of the window to save the configuration

3. Installation of Debian Wheezy

In VirtualBox: select DepPsopt and click on "Start"
Start Menu: <select Install>
Language: English
Country: <your choice>
Locale Settings: <your choice>
Keymap: <your choice>
<at this point it is assumed that the network configuration is done via DHCP>
Hostname: debpsopt
Domain name: <your choice, not important, I used "localdomain">
Root password: <your choice, do not forget it>
Reenter Root Password: <repeat>
new user name: <your choice>
Username for your account: <your choice, for this installation we assume USER>
Password for new user: <your choice>
Reenter Password: <repeat>
time zone: <your choice>
Partitioning method: Guided - use entire disk and set up LVM
Select disk to partition: <there should be only one choice: chose it>
Partitioning scheme: All files in one partition
Write changes to disks and configure LVM: <Yes>
Finish partitioning and write changes to disk: <accept>
Write the changes to disks? Yes
Installing the base system <wait ...>
Debian archive mirror country: <select one near you>
Debian archive mirror: <select one>
HTTP proxy information: <leave blank or select your HTTP proxy>
Configuring apt: <wait ...>
Select and install software: <wait ...>
Participate in the package usage survey: <your choice>
Chose software to install: Mark "Standard system utilities" & "Xfce" and leave everything else unselected <Continue>
Select and install software: <wait ...>
Install the GRUB boot loader to the master boot record: Yes
Device for boot loader: <chose /dev/sda>
Installation complete: Continue
<now an automatic reboot happens>

4. Basic Configuration

Login: <enter "root" and Root-Password>
Chose "Use default config"
Click on "Applications Menu"->"Terminal Emulator"
root@debpsopt:~# apt-get update
root@debpsopt:~# apt-get install sudo build-essential linux-headers-amd64
Do you want to continue? <y>
<wait during installation ...>
root@debpsopt:~# addgroup USER sudo
root@debpsopt:~# addgroup USER staff
<close the terminal window (the "X" in the top right)>

5. Install Virtual Box Guest Additions

VirtualBox Menu->Devices->Insert Guest Additions CD Image
Doubleclick on DVD-Icon "VBOXADDITIONS..."
click on the green up-arrow at the top of the window
Drag and drop the folder "cdrom0" to the desktop
Close the window.
Rightclick on Desktopicon "VBOXADDITIONS..."->Eject Volume
Doubleclick on "cdrom0" on the desktop
Doubleclick on "autorun.sh"
"Press Return to close this window...": <press return>
Close the File Manager Window
Rightclick on Desktopicon "cdrom0"->Delete
Applications Menu->Log Out -> Restart

<sytem gets restarted>

7. Installation of PSOPT

Login: USER, Password: <your password>
Chose "Use default config"
Applications Menu->Terminal Emulator
USER@debpsopt:~$ wget https://raw.github.com/Sauermann/psopt-installer/master/debian-jessie-psopt-installer.sh
USER@debpsopt:~$ chmod a+x debian-jessie-psopt-installer.sh
USER@debpsopt:~$ ./debian-jessie-psopt-installer.sh
<follow the instructions during the installation and enter user-password for sudo when asked>
