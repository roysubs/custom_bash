# Automated Bash Customisation & WSL Usage

**Quick Setup for WSL (focus on Ubuntu 2004 LTS)**  
  
Enable the Windows Optional Feature for WSL from an Admin PowerShell console:  
`dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart`  
`dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`  
*Must reboot at this point before using a distro.*  
Note: the above is the old way to do this. Microsoft are making `wsl.exe` a core component of Windows in newer releases, so you can ignore the above commands and instead just run `wsl --install` and it will go ahead and do the above steps (a reboot is still required afterwards however).
  
**Install a distro from App Store or Chocolatey or manually with iwr/curl**  
• App Store: [Distros https://aka.ms/wslstore](https://aka.ms/wslstore)  
• Chocolatey [wsl-ubuntu-2004](https://chocolatey.org/packages/wsl-ubuntu-2004), [wsl-fedoraremix](https://chocolatey.org/packages/wsl-fedoraremix), [wsl-alpine](https://chocolatey.org/packages/wsl-alpine)  
`choco install choco install wsl-ubuntu-2004`  
Following optionally sets default user as root (default is false)  
`choco install wsl-ubuntu-2004 --params "/InstallRoot:true"`  
• Using [iwr/curl](https://docs.microsoft.com/en-us/windows/wsl/install-manual) (Invoke-WebRequest):  
`iwr -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu.appx -UseBasicParsing`  
`curl.exe -L -o Ubuntu.appx https://aka.ms/wslubuntu2004                       # curl.exe`  
Finally, install and register with: `Add-AppxPackage .\Ubuntu.appx             # To install the AppX package`  

Start distro from Start Menu or from `wsl.exe` or `bash.exe`  
Setup Bash Customisations: `curl https://raw.githubusercontent.com/roysubs/custom_bash/master/custom_loader.sh | bash`  
Setup 'Quick access' link to Linux home folder: Open explorer, navigate to `\\wsl$\Ubuntu\home\<user>` and drag into 'Quick access'.  
Other setup for WSL, see `~/.custom`  

**Bash CustomisationQuick Setup for WSL (focus on Ubuntu 2004 LTS)**  
Working across different distros has awkward rules on priority for `.bash_profile` or `.bashrc` and interactive / non-interactive sessions. This project aims to create a maintainable bash environment that is compatible across as many distro's as possible. A focus is on WSL distros and includes specific tools for that (which only load if WSL is detected, so this setup works perfectly on WSL or non-WSL environments). All Debian and Redhat variants (i.e. includes Ubuntu/Fedora/CentOS/LinuxMint/Peppermint etc) are supported. These tools can be uninstalled immediately simply by removing the calling lines in `~/.bashrc`.

The toolkit configures a set of standard modifications (aliases, functions, .vimrc, .inputrc, sudoers) but with minimal alteration of core files. This is done by running the setup script `custom_loader.sh` from github which configures base tools and adds two lines to `~/.bashrc` to point at `~/.custom` so that these changes only apply to interactive shells (so will load equally in `ssh login` shells or `terminal` windows from a Linux Gnome/KDE UI, and will not load during non-interactive shells such as when a script is invoked, as discussed [here](https://askubuntu.com/questions/1293474/which-bash-profile-file-should-i-use-for-each-scenario/1293679#1293679)).

**`custom_loader.sh`**. This script can be run directly from github. It will download the latest `~/.custom` and then add two lines into `~/.bashrc` to dotsource `~/.custom` for all new shell instances. This script also updates selected very small core tools (`vim, openssh, curl, wget, dpkg, net-tools for ifconfig, git, figlet, cowsay, fortune-mod etc`) and some generic settings for `~/.vimrc`, `~/.inputrc`, `sudoers` and offers to update localisation settings as required. It will then dotsource `~/.custom` into the currently running session to make the tools immediately available without a new login. To run `custom_loader.sh` on any system with an internet connection with (removed `-i` to suppress HTTP header information):
`curl https://raw.githubusercontent.com/roysubs/custom_bash/master/custom_loader.sh | bash`

Alternatively, clone the repository with: `git clone https://github.com/roysubs/custom_bash`, then `cd` into that folder and run: `. custom_loader.sh` (use dotsource here to run when the script has no permissions set, and no need for `sudo` as built into the script as required).

**Notes** To inject into the configurations files (`.bashrc`, `.vimrc`, `.intputrc`, `sudoers`), `custom_loader.sh` uses `sed` to find matching lines to remove them, and then replace them. e.g. For `.bashrc`, it looks for `[ -f ~/.custom ]`, removes it, then appends `[ -f ~/.custom ] && [[ $- == *"i"* ]] && . ~/.custom; else curl ...` at the end of `.bashrc` so that `.custom` will always load as the last step of  `~/.bashrc`.

# WSL Notes
A focus of this project was to get a repeatable WSL and easy to maintain WSL setup and to be able to fully use all of the WSL capabilities within Windows.  
Once up and running with WSL, everything can be completely seamless in accessing Windows filesystem from WSL and vice-versa, and for example, opening/editing files in WSL with Windows tools (like Notepad++ or VS Code) can be as simple as `notepad++ ~/.bashrc` etc.
[Very good overview of WSL2](https://www.sitepoint.com/wsl2/)

**WSL Basics**  
Setup WSL with:  
`dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart`  
`dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`  
You must reboot after this, then set defaults to WSL2: `wsl --set-default-version 2`  
Show current images with `wsl -l -v` (`wsl --list --verbose`)  
WSL images run in Hyper-V images via the `LxssManager` service. Therefore, to restart all WSL instances, just restart the service `Get-Service LxssManager | Restart-Service` from PowerShell.  
Switch a WSL distro image from WSL 1 to use WSL 2 with `wsl --set-version Ubuntu 2`
Set default distro with `wsl --setdefault Ubuntu` (it will now start when `wsl` or `bash` are invoked from DOS/PowerShell).  
  
To [open the current folder in Windows Explorer](https://superuser.com/questions/1338991/how-to-open-windows-explorer-from-current-working-directory-of-wsl-shell#1385493), use `explorer.exe .`  
Some aliases can make working with WSL in Windows easier (some templates have been added to `.custom`):  
```
alias start=explorer.exe   # "start ." will now open Explorer at current folder, same as "start ." in DOS/PowerShell
alias chrome="\"/mnt/c/Program Files/Google/Chrome/Application/chrome.exe\""   # Chrome. Can use with URL:       chrome www.google.com
alias notepad++="\"/mnt/c/Program Files/Notepad++/notepad++.exe\""             # Notepad++. Can use with files:  notepad++ ~/.bashrc
```  
  
Opening a file with a Windows tool as above uses a share called `\\wsl$`, e.g. in the above example, it displays as `\\wsl$\Ubuntu-20.04\home\boss\.bashrc`  
The `~` directory maps to `%localappdata%\lxss\home` (or `%localappdata%\lxss\root` for root) and not to `%userprofile%`  
`\\wsl$` does not display in `net share` but you can type it into explorer and navigate there, and pin to 'Quick access'  
Typing `dir \\wsl$` from DOS/PowerShell fails; you have to use the distro name, e.g. `dir \\wsl$\Ubuntu-20.04`  

Run `bash.exe` from a cmd prompt to launch in current working directory. `bash.exe ~` will launch in the user's home directory.  
A [write-up](https://github.com/microsoft/WSL/issues/87#issuecomment-214567251) on differences between the /mnt/ drive mounts and the Linux filesystem.  
```  
wsl -l -v
  NAME            STATE           VERSION
* fedoraremix     Running         1
  Ubuntu-20.04    Running         1
```
To change the default distro, `wsl -s Ubuntu-20.04`. The default distro will be what is used when piping ( ` | wsl grep '123'` ) and will be what started by default with `wsl` or `bash`.  e.g.  
    `dir | wsl grep -i win | wsl sed 's/win/xxx/g'   # will use the default distro on each wsl`  
However, you could use multiple different WSL instances on a single command:  
    `Write-Output "Hello``nLinux!" | wsl -d Ubuntu grep -i linux | wsl -d Debian cowsay   # if Ubuntu/Debian distros are present`  
 
To reset a WSL distro back to an initial state: Settings > Apps > Apps & features > select the Linux Distro Name
In the Advanced Options link, select the "Reset" button to restroe to the initial install state (everything will be deleted).

**WSL Backup/Restore and moving to other drives**  
Linux disk images install by default to the C: drive.  
In Windows Powershell, run `wsl --list` to view Linux distros.  
Export current distro: `wsl --export Ubuntu D:\Backups\Ubuntu.tar`  
Unregister this distro: `wsl --unregister Ubuntu`  
Run `wsl --list` to verify the distribution has been removed.  
Import backup to new WSL distro at new location: `wsl --import Ubuntu D:\WSL\ D:\Backups\Ubuntu.tar`  
Run `wsl --list` to verify that it has been created and registered.  
Launch the distro as normal from the Start menu.  
Unfortunately, Ubuntu will now use root as the default user. To go back to your own account `ubuntu config --default-user <yourname>` where `<yourname>` is the username you defined during installation.  

[Multiple instances of same Linux distro in WSL](https://medium.com/swlh/why-you-should-use-multiple-instances-of-same-linux-distro-on-wsl-windows-10-f6f140f8ed88)  
To use Ctrl+Shift+C/V for Copy/Paste operations in the console, need to enable the "Use Ctrl+Shift+C/V as Copy/Paste" option in the Console “Options” properties page (done this way to ensure not breaking any existing behaviors).

**WSL Links**  
[WSL: The Ultimate Guide](https://adamtheautomator.com/windows-subsystem-for-linux/)  
[Linux Graphical Apps coming to WSL](https://www.zdnet.com/article/linux-graphical-apps-coming-to-windows-subsystem-for-linux/)  
[Target WSL from Visual Studio](https://devblogs.microsoft.com/cppblog/targeting-windows-subsystem-for-linux-from-visual-studio/)  
[Fun with WSL (older page, some info is out of date)](https://blogs.windows.com/windowsdeveloper/2016/07/22/fun-with-the-windows-subsystem-for-linux/)  

**ToDo** Looks like it is not possible to invoke a script *with switches* via `curl`, so could use a local file to check if specific changes need to be made. e.g. overwriting `.custom`, or to load everything to `/etc` instead of `/home` maybe have a `.custom_install_system_wide` flag then delete that file after the change. Make all of the above load system-wide, i.e. create `/etc/.custom` and make changes to `/etc/bashrc`, `/etc/vimrc`, `/etc/inputrc` instead of `~`. If doing this, must also clean up `~` to remove the details there.

**ToDo** If exist `.custom_install_coreapps`): Install various various core apps. e.g.
`sudo apt install git vim curl openssh-server`
`sudo apt install libsecret-1-0 libsecret-1-dev`
`sudo apt <xrdp core configuration for debian/red-hat variants>`

# Useful One-Liners etc
[Large list](https://onceupon.github.io/Bash-Oneliner/)  
[6 useful one-liners](https://www.thegeekstuff.com/2010/09/linux-one-liners/)  
[10 useful one-liners for system](https://www.reddit.com/r/sysadmin/comments/31oucc/10_useful_linux_oneliners_for_system/)  
[Large list of lesser known commands](https://www.tecmint.com/51-useful-lesser-known-commands-for-linux-users/)  
[Linux Complex Bash One-Liner Examples](https://linuxconfig.org/linux-complex-bash-one-liner-examples)  
[Random](https://angrysysadmins.tech/index.php/2019/04/bailey/useful-bash-one-liners/)  
[Random](https://colinpaice.blog/2021/01/21/useful-linux-commands/)  
[Interesting Vim & Terminal colour notes](https://medium.com/@gillicarmon/create-color-scheme-for-vim-335e842e29ea)  

[Uses of the ! command](https://www.tecmint.com/mysterious-uses-of-symbol-or-operator-in-linux-commands/)  
[Fun Stuff 1](https://www.tecmint.com/cool-linux-commandline-tools-for-terminal/)  
[Fun Commands I](https://www.tecmint.com/20-funny-commands-of-linux-or-linux-is-fun-in-terminal/)  
[Fun Commands II](https://www.tecmint.com/linux-funny-commands/)  
[Fun with Character Counts](https://www.tecmint.com/play-with-word-and-character-counts-in-linux/)  
https://stackoverflow.com/questions/36585496/error-when-using-git-credential-helper-with-gnome-keyring-as-sudo/40312117#40312117  

`netstat -plan | grep :80  | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nk1`  
Above command will give the sorted list of IP’s with number of connections to the port 80.

`https://aka.ms/wsl`  
`https://docs.microsoft.com/en-us/windows/wsl/wsl-config#list-distributions`  

https://ubuntu.com/wsl

**Managing WSL Distros**  
Note that doing this will break all connections to open sessions, e.g. open VS Code editor sessions to scripts inside WSL.
When you restart the instance, VS Code sessions will not reconnect, but just close VS Code (it will cache the scripts). When you restart  
VS Code (e.g. `code .`) against the same files, VS Code will reopen with a connection to the scripts and you can continue.  
Terminate all WSL instances (optionally Start / Restart the service): `Get-Service LxssManager | Stop-Service    # | Start-Service   # | Restart-Service`  
Terminate a WSL instance: `wsl -t <distro-name>   # --terminate`   

You can upgrade distros from v1 to v2 easily:  
`wsl --set-default-version 2`  

After this, new distros will install as v2:  
To upgrade existing distros to v2:  
`wsl --set-version <distro-name> 2`  
`Conversion in progress, this may take a few minutes...`  
`For information on key differences with WSL 2 please visit https://aka.ms/wsl2`  

**Restarting a WSL instance (or all WSL instances)**  
`sudo reboot`  does not work and generates the following error:  
`System has not been booted with systemd as init system (PID 1). Can't operate.`  
`Failed to connect to bus: Host is down`  
`Failed to talk to init daemon.`  
This is because WSL does not use systemd, and so this also applies to all systemd actions such as `systemctl start` etc. More on this [here](https://linuxhandbook.com/system-has-not-been-booted-with-systemd/).  
  
`Systemd command                 Sysvinit command`  
`systemctl start service_name    service service_name start`  
`systemctl stop service_name     service service_name stop`  
`systemctl restart service_name  service service_name restart`  
`systemctl status service_name   service service_name status`  
`systemctl enable service_name   chkconfig service_name on`  
`systemctl disable service_name  chkconfig service_name off`  
  
[You probably don't need systemd on WSL](https://dev.to/bowmanjd/you-probably-don-t-need-systemd-on-wsl-windows-subsystem-for-linux-49gn)  
Most popular Linux distributions use systemd as the init system for startup, shutdown, service monitoring, etc.  

WSL has it's own initialization system, and so no WSL distros use systemd, and do not generally employ a traditional init system.  
  
Two skills in particular will yield more satisfaction with WSL:  
  
• A good understanding of how to launch services directly (unmanaged by an init system).  
• Familiarity with running containers. Without docker. (If you use WSL version 2).  


[How to install systemd snap packages on WSL 2](https://snapcraft.ninja/2020/07/29/systemd-snap-packages-wsl2/)
```
sudo apt update
sudo apt install -yqq git
git clone https://github.com/DamionGans/ubuntu-wsl2-systemd-script.git $HOME/ubuntu-wsl2-systemd-script
$HOME/ubuntu-wsl2-systemd-script/ubuntu-wsl2-systemd-script.sh
```
```
cd $HOME/ubuntu-wsl2-systemd-script
git pull
./ubuntu-wsl2-systemd-script.sh --force
```

How to install Fedora Remix 33 for WSL 2 ...  

[Connect to WSL via SSH](https://superuser.com/questions/1123552/how-to-ssh-into-wsl)
Change the 22 port to a other one,such as 2222,in the file /etc/ssh/sshd_config,then restart the ssh service by the commond sudo service ssh --full-restart,you will successfully login.But I don't know the reason.

I also try use it as a remote gdb server for visual studio by VisualGDB,it not works well. VisualGDB will support it in the next version as the offical website shows.The link is https://sysprogs.com/w/forums/topic/visualgdb-with-windows-10-anniversary-update-linux-support/#post-9274


**SSH Server Setup (openssh-server)**  

We need to make sure that OpenSSH Server is installed and a few settings are changed in the `/etc/ssh/sshd_config` file.  
`sudo apt install openssh-server      # But it is probably already installed`  

Now run `sudo vi /etc/ssh/sshd_config` :  

```
Port 2222                          # Default is '22', must change for WSL
PermitRootLogin prohibit-password  # Change?
PasswordAuthentication yes         # Default is 'no'
AllowAgentForwarding yes
X11Forwarding yes
```

We must make sure that key-pairs are generated (for root, these generate in `/etc/ssh` and for the current user, they generate in `/home/<username>/.ssh` by default):  

`sudo ssh-keygen -A                   # Generate root keys`  
`ssh-keygen -t rsa -b 4096            # Generate a 4096 bits SSH key pair for current user`  
  
Now, we need to restart the ssh service, but need to remember that WSL does *not* use systemd, so `sudo systemctl restart sshd.service` will not work (neither will `sudo reboot` etc for the same reason):  

`sudo service --status-all    # Show all init.d service names (look for "ssh")`  
`sudo /etc/init.d/ssh stop    # Stop/Start the ssh service after every change`  
`sudo service ssh start       # This will fail if keys are not generated`  
`sudo service --status-all    # Can now see that the serice is running`  

Now, can connect via putty or other ssh client at 127.0.0.1 on port 2222 (remember that Windows now has a built in ssh.exe and ssh-keygen.exe etc).  
 


**Run Windows commands from WSL and vice-versa**  
In the Windows 10 Creators Update (build 1703, April 2017), this is natively supported. So you can now run Windows binaries from Linux...  
`alias putty="/mnt/c/ProgramData/chocolatey/bin/PUTTY.EXE"  # Run Windows commands form Linux`  
`bash -c "fortune | cowsay"                                 # Run Linux commands from Windows PowerShell`  


**Quick summary**  
`Reboot: 
