# Automated Bash Customisation
Working across different distros can be awkward and the rules on priority for `.bash_profile` or `.bashrc` varies between distros so it's hard to have a consistent setup. This project aims to to create a maintainable bash environment that is consistent across as many core distro's as possible (including specific support for WSL distros by only including those parts if WSL is detected), so all Debian/Redhat variants (i.e. includes Ubuntu/Fedora/CentOS/LinuxMint/Peppermint etc). These tools can be uninstalled immediately simply by removing the calling lines in `~/.bashrc`.

The toolkit configures a set of standard modifications (aliases, functions, .vimrc, .inputrc, sudoers) but with minimal alteration of core files. This is done by running the setup script `custom_loader.sh` from github which configures base tools and adds two lines to `~/.bashrc` to point at `~/.custom` so that these changes only apply to interactive shells (so will load equally in `ssh login` shells or `terminal` windows from a Linux Gnome/KDE UI, and will not load during non-interactive shells such as when a script is invoked, as discussed [here](https://askubuntu.com/questions/1293474/which-bash-profile-file-should-i-use-for-each-scenario/1293679#1293679)).

**`custom_loader.sh`**. This script can be run directly from github. It will download the latest `~/.custom` and then add two lines into `~/.bashrc` to dotsource `~/.custom` for all new shell instances. This script also updates selected very small core tools (`vim, openssh, curl, wget, dpkg, net-tools for ifconfig, git, figlet, cowsay, fortune-mod etc`) and some generic settings for `~/.vimrc`, `~/.inputrc`, `sudoers` and offers to update localisation settings as required. It will then dotsource `~/.custom` into the currently running session to make the tools immediately available without a new login. To run `custom_loader.sh` on any system with an internet connection with (removed `-i` to suppress HTTP header information):
`curl https://raw.githubusercontent.com/roysubs/custom_bash/master/custom_loader.sh | bash`

Alternatively, clone the repository with: `git clone https://github.com/roysubs/custom_bash`, then cd into that folder and run: `. ./custom_loader.sh` (use dotsource to run when the script has no permissions set).

**Notes** To inject into the configurations files (`.bashrc`, `.vimrc`, `.intputrc`, `sudoers`), `custom_loader.sh` uses `sed` to find matching lines to remove them, and then replace them. e.g. For `.bashrc`, it looks for `[ -f ~/.custom ]`, removes it, then appends `[ -f ~/.custom ] && [[ $- == *"i"* ]] && . ~/.custom; else curl ...` at the end of `.bashrc` so that `.custom` will always load as the last step of  `~/.bashrc`.

# WSL Notes
A focus of this project was to get a repeatable WSL setup and to be able to fully use all of the WSL capabilities within Windows.

**WSL Basics**. Setup WSL with:  
`dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart`  
`dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`  
You must reboot after this, then set defaults to WSL2: `wsl --set-default-version 2`  
Show current images with `wsl -l -v` (`wsl --list --verbose`)  
WSL images run in Hyper-V images via the `LxssManager` service. Therefore, restart all WSL instances by restarting the service `Get-Service LxssManager | Restart-Service` from PowerShell.  
You can switch WSL VMs from version 1 to version 2 with `wsl --set-version Ubuntu 2`
Set default distro with `wsl --setdefault Ubuntu` (it will now start when `wsl` is invoked from DOS/PowerShell).  
  
To [open the current folder in Windows Explorer](https://superuser.com/questions/1338991/how-to-open-windows-explorer-from-current-working-directory-of-wsl-shell#1385493), use `explorer.exe .`  
Some aliases can make working with WSL in Windows easier (some templates have been added to `.custom`):  
```
alias start=explorer.exe   # "start ." will now open Explorer at current folder, same as "start ." in DOS/PowerShell
alias chrome="\"/mnt/c/Program Files/Google/Chrome/Application/chrome.exe\""   # Chrome. Can use with URL:       chrome www.google.com
alias notepad++="\"/mnt/c/Program Files/Notepad++/notepad++.exe\""             # Notepad++. Can use with files:  notepad++ ~/.bashrc
```  
  
Opening a file with a Windows tool as above uses a share called `\\wsl$`, e.g. in the above example, it displays as `\\wsl$\Ubuntu-20.04\home\boss\.bashrc`  
The `~` directory maps to `%localappdata%\lxss\home` (or `%localappdata%\lxss\root` for root) and not to `%userprofile%`.  
Therefore, `\\wsl$` maps to `%localappdata%\lxss\home`
Run `bash.exe` from a cmd prompt to launch in current working directory. `bash.exe ~` will launch in the user's home directory.  
A [write-up](https://github.com/microsoft/WSL/issues/87#issuecomment-214567251) on differences between the /mnt/ drive mounts and the Linux filesystem.  
```  
wsl -l -v
  NAME            STATE           VERSION
* fedoraremix     Running         1
  Ubuntu-20.04    Running         1
```
To change the default distro that starts with `wsl.exe`, use: `wsl -s Ubuntu-20.04`
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

**WSL Usage Examples**  
From PowerShell, pipe to use tools from multiple different WSL instances:  
    `Write-Output "Hello`nLinux!" | wsl -d Ubuntu grep -i linux | wsl -d Debian cowsay`  

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

https://stackoverflow.com/questions/36585496/error-when-using-git-credential-helper-with-gnome-keyring-as-sudo/40312117#40312117
[Interesting Vim & Terminal colour notes](https://medium.com/@gillicarmon/create-color-scheme-for-vim-335e842e29ea)
