[//]: <> (This is how to do a comment in Markdown that will not be visible in HTML.)  

# Quick Install
The core.autocrlf setting is to prevent any CR/LF line-ending errors.  
Note that there is no need to `chmod` the scripts, they should only be run dot-sourced so do not require to be executable.  
```
git config --global core.autocrlf input
git clone https://github.com/roysubs/custom_bash
cd custom_bash
. ./custom_loader.sh
```

# Bash custom configuration & WSL Integration  
Auto-configure common settings to be cross-platform for most Linux distros (CentOS/Ubuntu/Debian etc). Specific tools for WSL are included but that only load if WSL is detected. By sourcing a single script `custom_loader.sh`, this sets everything up and puts the `.custom` script into `~` which is then invoked by `~/.bashrc` at shell startup.  

Goal was to keep all modifications outside of main bash configuration files, so that the changes do not pollute main configuration files to create a hard to maintain environment. Removal is then as simple as removing the two lines added at the end of `~/.bashrc` where it calls `~/.custom`.  

The goal is to setup a usable / comfortable environment with essential settings in `~/.vimrc`, `~/.inputrc` and useful tools without requiring the time it normally takes to setup a sensible environment. Run `git clone` to take a copy and then customise by adding other settings as required. For fixes / additional tools that would be useful in the main project would benefit from, email **roysubs@hotmail.com** and we can add into the main project.  

Default setups: Installation of various small packages that are a useful baseline to have on any new system. Setup of colour syntax highlighting on all `cat` output (by using the `bat` tool). Functions to help with various system tasks. Some simple banner setups that are cosmetic but can be nice to have. Many aliases and functions to make for a more consistent cross-platform setup.

# Install the Linux custom tools  
  
Note that `sudo apt install curl git -y` is a useful first step as new installations are often missing these.  
  
**Option 1: Download full git project, then run `. custom_loader.sh`**:  
  
You *must* change the `core.autocrlf` settings when cloning on another WSL system or else all scripts will be broken
`git config --global core.autocrlf input`
`git clone https://github.com/roysubs/custom_bash`  
`git clone https://git.io/Jt0f6`   # git.io shortened url  
This is useful as the `curl xxx | bash` method runs everything immediately without prompting. After cloning the repo, run the loader with: `. custom_loader.sh` (it is best to dotsource like this as it has no execute permissions after cloning, and to allow it to dotsource `.custom` into the currect session when running). There is no need to use `sudo` to run this as require elevated tasks will invoke `sudo` inside the script.  

**Option 2: Download only the required files**:  
The project only requires the following two files, so this can be done instead of cloning the project.
`curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/custom_loader.sh > custom_loader.sh`  
`curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > .custom`  
Then run `. custom_loader.sh` from the current directory.  

**Option 3: Install the custom tools immediately**  
`curl https://raw.githubusercontent.com/roysubs/custom_bash/master/custom_loader.sh | bash`  
We can use **git.io** to shorten github utl's, but this does not work for `curl xxx | bash`, so using long form here. This method is least resilient, but works fine in most situations.  
  
**Note:** It is not possible to invoke a script *with switches* via `curl` (Option 3 above), which is why downloading first then running is a better approach (could instead have the script look for flag files on disk, e.g. `.custom_install_system_wide` then delete that file after running `custom_loader.sh` from Github, or maybe a specific variable). **ToDo:** Optionally make all of the above load system-wide, i.e. create `/etc/.custom` and make changes to `/etc/bashrc`, `/etc/vimrc`, `/etc/inputrc` instead of `~`. If doing this, must also clean up `~` to remove the details there.  
  
**`custom_loader.sh`** configures the environment. This simply adds a single line to `.bashrc` to dotsource `~/.custom` for all new shell instances (whether console or terminal inside a GUI environment as there is a distinction!). It also installs / updates some small core tools that are generically useful (`vim, openssh, curl, wget, dpkg, net-tools, git, zip, p7zip, figlet, cowsay, fortune-mod` etc), then adjust some generic settings for `~/.vimrc`, and `~/.inputrc`. and describes the correct way to update localisation settings. `~/.custom` will then be dotsourced into the currently running session to be immediately available without a new login. To install the latest version on any WSL distro, use the above `curl` command from inside the WSL instance.  
  
**`.custom`** is called from `~/.bashrc` using two lines that ensure that the changes only apply to *interactive* shells (i.e. will load equally in either `ssh login` shells or `terminal` windows inside a Linux Gnome/KDE UI, and will *not* load during non-interactive shells such as when a script is invoked, as discussed [here](https://askubuntu.com/questions/1293474/which-bash-profile-file-should-i-use-for-each-scenario/1293679#1293679)).  

**How to uninstall**  
This is very easily done as the only main change are the lines in `~/.bashrc` to call `~/.custom` so that the main profile scripts are modified as little as possible, so will not mess up any system, just delete the two lines in `~/.bashrc` that call `.custom` to remove everything. `custom_loader.sh` is also a template for how to easily extend for other preferred settings; simply clone the project and adjust to add remove your own settings as required.  

# WSL Setup Steps

The following is the full syntax for all steps for an Ubuntu distro (Ubuntu partnered with Microsoft for the WSL project so their images are probably the most stable). Note that each distro is an independent VM (running on Hyper-V), but they are completely managed by the OS and so have almost instant start times. WSL VM folders (before making changes and installing software) are usually around 1 GB per instance. [WSL1 vs WSL2](https://docs.microsoft.com/en-us/windows/wsl/compare-versions#understanding-wsl-2-uses-a-vhd-and-what-to-do-if-you-reach-its-max-size), [Docker with WSL2 Backend](https://docs.docker.com/desktop/windows/wsl/)  
  
# Install WSL using DISM  
Note: As of Wind 10 (2004 or later), WSL can now be setup with a single command:  
`wsl --install              # Just installs WSL`  
`wsl --install -d Ubuntu    # Install WSL and a named distribution (-d = --distribution)`  
`wsl --install -d Debian    # Install WSL and a named distribution (-d = --distribution)`  
`wsl --list --online        # Show compact and friendly names for available distributions`  
`Current wsl --install -d: Ubuntu, Debian, kali-linux, openSUSE-42, SLES-12, Ubuntu-16.04, Ubuntu-18.04, Ubuntu-20.04`
`# Deprecated: dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart`  
`# Deprecated: dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`  
`# Deprecated: iwr -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu.appx -UseBasicParsing`  
`# Deprecated: Add-AppxPackage .\Ubuntu.appx`  
`# Install Location: C:\Program Files\WindowsApps\CanonicalGroupLimited.Ubuntu20.04onWindows_2004.2020.812.0_x64__79rhkp1fndgsc`  
`wsl --set-default-version 2`  
\# Note that `C:\Program Files\WindowsApps` is quite security-restricted, cannot enter easily even as Admin.  
\# Also, this all bloats the system drive, so I normally move WSL distros to `D:\WSL\<distro-name>` (and can port distros to other systems in this way also):  
`md D:\WSL\Ubuntu`  
`wsl -l -v`
`wsl --export Ubuntu D:\WSL\Ubuntu.tar`  
`wsl --unregister Ubuntu    # unregister the WSL image`  
`wsl --list                 # verify the distribution has been removed.`  
`wsl --import Ubuntu D:\WSL\Ubuntu D:\WSL\Ubuntu.tar`  
\# Unfortunately, Ubuntu will now use root as the default user. To go back to your own account:  
`ubuntu config --default-user <yourname>`  
\# where `<yourname>` is the username you defined during installation of that distro.  
[How to setup multiple instances of the same Linux distro in WSL (using --import and --export)](https://medium.com/swlh/why-you-should-use-multiple-instances-of-same-linux-distro-on-wsl-windows-10-f6f140f8ed88)  
It is often useful to have multiple copies of a distro available. With the above exported distro this can be done easily:  
`md D:\WSL\Ubuntu1`  
`md D:\WSL\Ubuntu2`  
`wsl --import Ubuntu D:\WSL\Ubuntu1 D:\WSL\Ubuntu.tar`  
`wsl --import Ubuntu D:\WSL\Ubuntu2 D:\WSL\Ubuntu.tar`  

# Other Distributions [Awesome-WSL](https://github.com/sirredbeard/Awesome-WSL) information, distributions, and tools.
\# Optionally, can install alpine, arch, or fedoraremix from the Chocolatey repository:  
`choco install wsl-alpine       # Use Chocolatey to get Alpine (not offered by Microsoft)`  
`choco install wsl-archlinux    # Use Chocolatey to get Arch (not offered by Microsoft)`  
`choco install wsl-fedoraremix  # Use Chocolatey to get Fedora (not offered by Microsoft)`  
[wsl-fedoraremix](https://chocolatey.org/packages/wsl-fedoraremix), [wsl-alpine](https://chocolatey.org/packages/wsl-alpine), [wsl-archlinux](https://community.chocolatey.org/packages/wsl-archlinux)  

\# CentOS 8 Stream installer https://github.com/mishamosher/CentOS-WSL/releases/tag/8-stream-20210603  
After extracting the zip into a folder, inside it you will see two files: `rootfs.tar.gz`, `CentOS.exe`.  
Run `CentOS.exe` in order to extract the vhd (Hyper-V virtual hard-disk), and register it on WSL.  
Now, right-click `CentOS.exe` again, and run as Administrator, and this time it will start CentOS.  
Note: You will be `root` after this and need to create a user and run as that:  
\# `useradd <user>`, then `passwd <user>`, if you can want a simple password, CentOS will complain, ignore that.  
\# `usermod -a -G wheel <user>` # CentOS/Fedora use the `wheel` group (would be `usermod -a -G sudo <user>` on Debian/Ubuntu as uses `sudo` group)  
You must do the above before closing the `root` console or you will have no `sudo`.  
\# `.\CentOS8-stream.exe config --default-user <user>` to default to the new user.  
To uninstall CentOS: `.\CentOS.exe clean` (from PowerShell).  
If accidentally delete the CentOS folder, when unzipping it again, also should clean it again: `.\CentOS.exe clean`.
\# CentOS 8 installer https://github.com/mishamosher/CentOS-WSL/releases/tag/8.4-2105  
\# CentOS 7 installer https://github.com/mishamosher/CentOS-WSL/releases/tag/7.9-2009  
\# CentOS 6 installer https://github.com/mishamosher/CentOS-WSL/releases/tag/6.10-1907  
Working only on WSL2 with vsyscall=emulate. More info: [microsoft/WSL#5465](https://github.com/microsoft/WSL/issues/5465)  
Detailed instructions:  
Install via wsl `--import` or running `CentOS6.exe`  
Make sure you use WSL2: `wsl --set-version <Distro> 2`  
Configure WSL2 to use vsyscall=emulate: [microsoft/WSL#4694 (comment)](https://github.com/microsoft/WSL/issues/4694#issuecomment-556095344)  
You have to restart the Windows service LxssManager for the step above to take effect.  
\# Must reboot before using a distro, but first set all defaults to use WSL v2.  
\# [Fedora Remix for WSL](https://www.whitewaterfoundry.com/fedora-remix-for-wsl/)  
\# [Fedora Remix 34.5 for WSL with Windows Terminal Theme](https://www.whitewaterfoundry.com/blog/2021/5/21/pengwin-2105-released-see-whats-new-y89n3)
LXRunOffline.exe install -n Fedora29 -f .\fedoraremix.exe -d D:\WSL\Fedora29  
LXRunOffline.exe install help  
LXRunOffline.exe config-uid -n Fedora -v <user_uid>  
Set default user for Fedora as above in the command prompt. (You can get the user id by running the id command in Fedora Terminal)  

# WSL Startup  

On first startup, you will be prompted to create a username and password. Note that each WSL instance will have it's own useraname and password that are not synced with the Windows user.  
You can start the distro from the Ubuntu icon on the Start Menu, or by running `wsl` or `bash` from a PowerShell or CMD console. You can go into fullscreen on WSL/CMD/PowerShell (native consoles or also in Windows Terminal sessions) with `Alt-Enter`. Registered distros are automatically added to Windows Terminal (how to add a new Windows Terminal console type?).
[Remove scrollbar in fullscreen](https://github.com/Microsoft/WSL/issues/407#issuecomment-295761589)  

You can also execute a number of Linux commands without having to first launch into the dedicated shell. This is handy for quick processes, for example running an update.  
To do this you would use the template wsl `<argument> <options> <commandline>`  
To run commands in your *default* Linux distro, you don't need to specify an argument at all.  
e.g. To update Ubuntu if it's your default you would simply enter `wsl sudo apt update`  
`wsl --distribution debian sudo apt update`
`wsl -d debian sudo apt install youtube-dl -y`
*What about creating a user/pass on a new instance?*

# WSL VMs, how to terminate (shutdowns/reboot), and how to reset  

It is important to understand that there is no systemd in WSL, so distros cannot use standard shutdown/reboot or any other actions dependent upon systemd. Closing a WSL window will *not* shutdown the WSL engine. The WSL instance (and any services, websites, containers) continue to run in the background. Only terminating the WSL distro will stop those services. More on that [here](https://stackoverflow.com/questions/66375364shutdown-or-reboot-a-wsl-session-from-inside-the-wsl-session/67090137#67090137).  

**Shutdown and Reboot:** There are times when it is important to shutdown or reboot the full WSL instance for configuration changes, hence the following commands have been added to WSL section of `.custom` (i.e. this section is only run if a distro is detected to be WSL) to replace the built-in (systemd) `shutdown` and `reboot`:
`alias shutdown='cmd.exe /c "wsl.exe -t $WSL_DISTRO_NAME"'`  
`alias reboot='cd /mnt/c/ && cmd.exe /c start "Rebooting WSL ..." cmd /c "timeout 5 && title "$WSL_DISTRO_NAME" wsl -d $WSL_DISTRO_NAME" && wsl.exe --terminate $WSL_DISTRO_NAME'`  
  
**Reset a WSL distro back to an initial state**  
`Settings > Apps > Apps & features > select the Linux Distro Name`  
In the Advanced Options link, select the "Reset" button to restore back to initial install state (note that everything will be deleted in that distro!) which is very useful for testing distros.  

WSL images run in Hyper-V images via the `LxssManager` service. Therefore, to restart all WSL instances, just restart the service `Get-Service LxssManager | Restart-Service`.  

Upgrade a WSL distro from WSL 1 to WSL 2 with `wsl --set-version Ubuntu 2` (cannot be undone after upgrade)
Set the default distro with `wsl --setdefault Ubuntu` (it will now start when `wsl` or `bash` are invoked from DOS/PowerShell).  
e.g. if you now run a command that uses `wsl.exe` it will use the default distro: `Get-Process | wsl grep -i Win`
  
From PowerShell, list current images with `wsl -l -v` ( --list --verbose ):  

```
  NAME            STATE           VERSION
* fedoraremix     Running         1
* Debian          Running         1  
  Ubuntu-20.04    Running         2
```  



# WSL Windows Integration (Windows Explorer and VS Code)
  
[Good overview of WSL 2](https://www.sitepoint.com/wsl2/)  

WSL gives seamless access between WSL and the Windows filesystem, including opening/editing files in WSL with Windows tools (like Notepad++ or VS Code), and opening/editing files in Windows with Linux tools.  

**VS Code:** The WSL VS Code extension loads a VS Code server inside WSL that handles seamless integration (`~/.vscode-server`) which can be around 100 MB. If the 
Alternatively, it is possible to just navigate to `\\wsl$\Ubuntu\home\<user>` even when the WSL window is closed (but NOT if the session is terminated).

**Setup 'Quick access' link to the WSL distro's home folder:** Open Windows Explorer, then navigate to `\\wsl$\Ubuntu\home\<user>`. Drag this folder into 'Quick access' for eacy access from Windows Explorer to see files in the distro home folder.  

If `choco install lxrunoffline` is installed, from Windows Explorer, note the "LxRunOffline" right-click item to let you open a bash shell at that folder location with the chosen distro.  
From inside a WSL shell, to [open the current folder in Windows Explorer](https://superuser.com/questions/1338991/how-to-open-windows-explorer-from-current-working-directory-of-wsl-shell#1385493), use `explorer.exe .`  

**Running any Windows Executable from WSL Linux**  
Some aliases can make working with WSL in Windows easier (some templates have been added to `.custom`):  
```
alias start=explorer.exe   # "start ." will now open Explorer at current folder, same as "start ." in DOS/PowerShell
alias chrome="\"/mnt/c/Program Files/Google/Chrome/Application/chrome.exe\""   # Chrome. Can use with URL:       chrome www.google.com
alias notepad++="\"/mnt/c/Program Files/Notepad++/notepad++.exe\""             # Notepad++. Can use with files:  notepad++ ~/.bashrc
```  

Opening a file with a Windows tool as above uses the `\\wsl$` share, e.g. `.bashrc` in Linux will displays as `\\wsl$\Ubuntu-20.04\home\boss\.bashrc` in Windows Explorer. The Linux home folder `~` maps to `\\wsl$\Ubuntu-20.04\home\boss` (or `\\wsl$\Ubuntu-20.04\root` for root) and not to `%userprofile%`. `\\wsl$` does not display in `net share` and you cannot run `cd \\wsl$` or `dir \\wsl$` but you can use the distro name, `cd \\wsl$\Ubuntu-20.04` or `dir \\wsl$\Ubuntu-20.04\home\boss` etc. You *can* navigate to `\\wsl$` in Windows Explorer however, and pin it or any subfolder to 'Quick access'.  

**VS Code Remote WSL Extension**  

WSL integration enables you to store your project files on the Linux file system using Linux command line tools, but also edit, debug, run projects directly in VS Code on Windows (or in a Chrome browser one Windows, or Notepad++ etc) generally without any performance issues associated with running across Linux and Windows file systems.  
  
**WSL Console Notes**  
To use **Ctrl+Shift+C / Ctrl+Shift+V** for Copy/Paste operations in the console, you need to enable the "Use Ctrl+Shift+C/V as Copy/Paste" option in the Console “Options” properties page (done this way to ensure not breaking any existing behaviors).

# Using WSL with PowerShell, or Windows Apps in WSL  

**[WSL Command References: wsl.exe / wslconfig.exe / bash.exe](https://docs.microsoft.com/en-us/windows/wsl/reference)**
Run `bash.exe` (or `wsl.exe`) from a cmd prompt to launch linux from the current working directory and using the default distro. Run `bash ~` (or `wsl ~`) would launch in the user's home directory. Can start in any folder in this way, so `wsl /mnt/c/Users/John` would start in the Windows home folder of John. `wsl -d Fedoraremix ~` would open in a specific distro version.  
  
Keep in mind that:  
• PowerShell is case-insensitive and uses objects by default.  
• Linux is case-sensitive and passes strings by default.  
  
Examples from a PowerShell prompt. As above, not that these are case-insensitive by default.  
Get processes with "win" in the name (the following fails due to requiring to convert to a string first):  
`PS C:\> Get-Process | Select-String win`  
Fixing this by converting the object to a string first.  
As `Select-String` will try to use objects from the pipe, `Out-String -Stream` is required to flatten that to a string.  
`PS C:\> Get-Process | Out-String -Stream | Select-String win`   
Using `Get-Alias -Definition <cmdlet>` to find the aliases for each Cmdlet:  
`PS C:\> ps | Out-String -Stream | sls win`  

Now do the same but using `grep` and `sed` from WSL to manipulate the output.
Note that when piping to a non-PowerShell command (not just WSL, but anything non-PowerShell), PowerShell automatically flattens that output to a string so `Out-String -Stream` is not required. Also note that `ps` here is `Get-Process` from PowerShell, and not `ps` from the WSL Linux distro.
`PS C:\> ps | grep -i win | wsl sed 's/win/xxx/g'`  
We can change the default distro using `-s`, so could use multiple different WSL instances on a single line:  
`PS C:\> Write-Output "Hello``nLinux" | wsl -d Ubuntu grep -i linux | wsl -d Debian cowsay`  
  
Remember that the PowerShell is case-insensitive but that the Linux is case-sensitive so get different output without the `-i`.  
`PS C:\> ps | wsl grep win`  
Making this case-insensitive, so will be equivalent to `ps | out-string -stream | sls win`
`PS C:\> ps | wsl grep -i win`  

A more complex example, to access the Windows filesystem (a more complex example). `winhome` in this example searches for and stores the case-sensitive User folder name from the Windows filesystem (due to case-sensitivity in Linux, this folder could have different case than the Linux user name. e.g. "C:\Users\John" in Windows might be "/home/john" in WSL):
`$ winhome=$(find /mnt/c/Users -maxdepth 1 -type d -regextype posix-extended -iregex /mnt/c/users/$USER)`

[Here are some notes](https://github.com/microsoft/WSL/issues/87#issuecomment-214567251) on differences between `/mnt/` host (Windows) drive mountpoints and the Linux filesystem.  

# LxRunOffline.exe

Non-Microsoft open source tool to manage WSL (there was a now deprecated tool called `lxrun.exe` that was previously part of WSL that this tool is named after). [Home page](https://awesomeopensource.com/project/DDoSolitary/LxRunOffline)), [Git Project](https://github.com/DDoSolitary/LxRunOffline).  
"A full-featured utility for managing Windows Subsystem for Linux (WSL)"  
Chocolatey: `choco install lxrunoffline`  
Scoop: `scoop bucket add extras`, `scoop install lxrunoffline`  
  
Shell extension: The right-click menu feature requires the shell extension DLL to be properly registered. This is automatically done if you used Chocolatey to install this project. However, if you downloaded the binaries directly, you need to run regsvr32 LxRunOfflineShellExt.dll manually to register the DLL file.  
  
```
PS C:\> LxRunOffline.exe

Supported actions are:
    l, list            List all installed distributions.
    gd, get-default    Get the default distribution, which is used by bash.exe.
    sd, set-default    Set the default distribution, which is used by bash.exe.
    i, install         Install a new distribution.
    ui, uninstall      Uninstall a distribution.
    rg, register       Register an existing installation directory.
    ur, unregister     Unregister a distribution but not delete the installation directory.
    m, move            Move a distribution to a new directory.
    d, duplicate       Duplicate an existing distribution in a new directory.
    e, export          Export a distribution's filesystem to a .tar.gz file, which can be imported by the "install" command.
    r, run             Run a command in a distribution.
    di, get-dir        Get the installation directory of a distribution.
    gv, get-version    Get the filesystem version of a distribution.
    ge, get-env        Get the default environment variables of a distribution.
    se, set-env        Set the default environment variables of a distribution.
    ae, add-env        Add to the default environment variables of a distribution.
    re, remove-env     Remove from the default environment variables of a distribution.
    gu, get-uid        Get the UID of the default user of a distribution.
    su, set-uid        Set the UID of the default user of a distribution.
    gk, get-kernelcmd  Get the default kernel command line of a distribution.
    sk, set-kernelcmd  Set the default kernel command line of a distribution.
    gf, get-flags      Get some flags of a distribution. See https://docs.microsoft.com/en-us/previous-versions/windows/desktop/api/wslapi/ne-wslapi-wsl_distribution_flags for details.
    sf, set-flags      Set some flags of a distribution. See https://docs.microsoft.com/en-us/previous-versions/windows/desktop/api/wslapi/ne-wslapi-wsl_distribution_flags for details.
    s, shortcut        Create a shortcut to launch a distribution.
    ec, export-config  Export configuration of a distribution to an XML file.
    ic, import-config  Import configuration of a distribution from an XML file.
    sm, summary        Get general information of a distribution.
    version            Get version information about this LxRunOffline.exe.
```

https://stackoverflow.com/questions/38779801/move-wsl-bash-on-windows-root-filesystem-to-another-hard-drive
In any Windows 10 version, you can move the distribution to another drive using lxRunOffline.

**Default locations for WSL Distros**

`C:\Program Files\WindowsApps\CanonicalGroupLimited.Ubuntu20.04onWindows_2004.2020.812.0_x64__79rhkp1fndgsc`

[How to move a WSL distro](https://github.com/pxlrbt/move-wsl)
1. Set permissions to the target folder. First, I think you must set some permissions to the folder where the distribution will be moved. Use `icacls` to set the proper permissions.  
    `C:\> whoami`  
    test\john  
    `C:\> icacls D:\wsl /grant "john:(OI)(CI)(F)"`  
    NOTE: In addition to the above permissions, I have activated the long path names in Windows.  

2. Move the distribution with `lxrunoffline move`.  
    `C:\wsl> lxrunoffline move -n Ubuntu-18.04 -d d:\wsl\installed\Ubuntu-18.04`  
    You may check the installation folder using  
    `C:\wsl> lxrunoffline get-dir -n Ubuntu-18.04`  
    d:\wsl\installed\Ubuntu-18.04  

3. Run the distribution. after moving the distribution, you can run the distribution using `wsl` or the same `lxrunoffline`  
    `C:\wsl> lxrunoffline run -n Ubuntu-18.04 -w`  
    `user@test:~$ exit`  
    `logout`  
    `C:\wsl> wsl`  
    `user@test:/mnt/c/wsl$ exit`  
    `logout`  



# Git with WSL and Windows

Git direct passwords were deprecated on 21st August 2021, so need to move over to tokens.

[WSL-Git](https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-git)  
[Use WSL Git instead of Git for Windows (StackOverflow)](https://stackoverflow.com/questions/44441830/vscode-use-wsl-git-instead-of-git-for-windows)
  
**Git**  
Set your email as follows command (setting name and email you use on your Git account):  
`git config --global user.name "username"`  
`git config --global user.email "youremail@domain.com"`  
  
**Git Credential Manager setup**  
Git Credential Manager enables you to authenticate a remote Git server, even if you have a complex authentication pattern like two-factor authentication, Azure Active Directory, or using SSH remote URLs that require an SSH key password for every git push. Git Credential Manager integrates into the authentication flow for services like GitHub and, once you're authenticated to your hosting provider, requests a new authentication token. It then stores the token securely in the Windows Credential Manager. After the first time, you can use git to talk to your hosting provider without needing to re-authenticate. It will just access the token in the Windows Credential Manager.  

I have had some failures getting `/usr/bin/git` to work. A quick way that always works, if you don't need more than the `git` command on its own, is to just alias `git.exe` from Git for Windows from WSL and just use that for managing repos.  
`alias git="'/mnt/c/Program Files/Git/bin/git.exe'"` (note that `"'` / `'"` are required for this alias). Also make sure that the following section is in `~/.gitconfig`:  
`[credential]`  
`helper = manager`  
With the above setup, you do not need `git` installed in WSL at all.  

If you want git in WSL (`/usr/bin/git`) to use the Git for Windows Credential Manager however, [this guide](https://blog.anaisbetts.org/using-github-credentials-in-wsl2/) explains the steps:  
• Install Git for Windows.  
• In Windows-land, clone any single private repo to generate the token. This will open a GitHub dialog allowing you to log in, and this will also handle 2FA (two-factor authentication) correctly.  
• In your WSL distro, run `sudo vi /usr/bin/git-credential-manager`, then add the following lines:  
`#!/bin/sh`  
`exec "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager.exe" $@`  
Alternatively to the above, the following command should achieve the same thing:  
`git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager.exe"`  
• Run `sudo chmod +x /usr/bin/git-credential-manager`  
Now, open up `~/.gitconfig` and add the following section:  
`[credential]`  
`helper = manager`  
• Make sure you clone all your repos with **https://** URLs. You do not need `www.`, just `github.com`, and you do not need to put `.git` at the end of a project URL, just use the URL for the project page) or re-configure them via git remote set-url.  

This is done as WSL has no GUI, so can't run the credential manager inside the WSL Linux VM. Now any git operation you perform within your WSL distribution should use the credential manager token from Windows seamlessly. If you already have credentials cached for a host, it will access them from the credential manager. If not, you'll receive a dialog response requesting your credentials, even if you're in a Linux console. If you are using a GPG key for code signing security, you may need to associate your GPG key with your GitHub email.

**Git Ignore file**  
It is usually important to add `.gitignore` files to most projects (must be in the root folder of a project) to exclude certain files. GitHub offers a collection of useful `.gitignore` templates with recommended `.gitignore` file setups organized according to your use-case. For example, here are [GitHub's default `.gitignore` templates](https://github.com/github/gitignore). If you choose to create a new repo using the GitHub website, there are check boxes available to initialize your repo with a README file, .gitignore file set up for your specific project type, and options to add a license if you need one.  
Add one line per exclude mask (can use wildcards). If a file is already in the project, it must be removed:  
`git rm --cached <filename>`  
To create a global ignore file (e.g. could put `*.tmp` to exclude all files like that in all projects):  
`git config --global core.excludesfile ~/.gitignore_global`  
To exclude without using `.gitignore`, put exclude masks into `.git/info/exclude`.  

# Docker
  
[Info on both Git and Docker with WSL](https://quotidian-ennui.github.io/blog/2019/09/04/wsl-wingit-bash/)  
*Note that the above contains the following comment "Apparently WSL has kinda crappy IO performance". This comment relates to WSL 1 only. WSL 2 is about 15x to 20x faster for IO operations due to the native Linux kernel build into the OS for WSL 2 etc.*  

**(Should I use docker or Docker-Desktop or both??)**  

# WSL Backup/Restore and moving to other drives

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

# Managing WSL Distros
Note that doing this will break all connections to open sessions, e.g. open VS Code editor sessions to scripts inside WSL.
When you restart the instance, VS Code sessions will not reconnect, but just close VS Code (it will cache the scripts). When you restart  
VS Code (e.g. `code .`) against the same files, VS Code will reopen with a connection to the scripts and you can continue.  
  


# More on systemd incompatibility

You can terminate a single WSL instance from PowerShell as follows (will terminate the Hyper-V VN immediately):  
`wsl -t <distro-name>   # or --terminate`   

You can also terminate a WSL session from its own console as WSL imports the whole Windows PATH so that you can run all Windows binaries, but you have to fully specify the name of a binary (so must use `wsl.exe` and not just `wsl`), so to terminate a WSL session, use:  
`wsl.exe -t <distro-name>`  
  
Note that `sudo reboot` does not work (as it is part of systemd which does not exist on *any* WSL distro). It will generate the following error:  
`   System has not been booted with systemd as init system (PID 1). Can't operate.`  
`   Failed to connect to bus: Host is down`  
`   Failed to talk to init daemon.`  
All systemd actions will fail, e.g. `systemctl start` etc. More on this [here](https://linuxhandbook.com/system-has-not-been-booted-with-systemd/).  
Also look at `echo $PATH` to see that all Windows paths are imported (this happens at session startup).

Kill all WSL instances: `Get-Service LxssManager | Stop-Service`   (then same again but with ` | Start-Service` to start again)  
Restart all instances:  `Get-Service LxssManager | Restart-Service`  

**[WSL2-Hacks](https://github.com/shayne/wsl2-hacks)**
https://stackoverflow.com/questions/55579342/why-systemd-is-disabled-in-wsl

To make all new distros install as v2:  
`wsl --set-default-version 2`  

To upgrade an existing distro to v2:  
`wsl --set-version <distro-name> 2`  
`   Conversion in progress, this may take a few minutes...`  
`   For information on key differences with WSL 2 please visit https://aka.ms/wsl2`  
  
You cannot use `sudo reboot` or any similar systemd command:  

```  
Systemd command                 Sysvinit command  
systemctl start service_name    service service_name start  
systemctl stop service_name     service service_name stop  
systemctl restart service_name  service service_name restart  
systemctl status service_name   service service_name status  
systemctl enable service_name   chkconfig service_name on  
systemctl disable service_name  chkconfig service_name off  
```  

[Why you probably don't need systemd on WSL](https://dev.to/bowmanjd/you-probably-don-t-need-systemd-on-wsl-windows-subsystem-for-linux-49gn)  
Most popular Linux distributions use systemd as the init system for startup, shutdown, service monitoring, etc, but WSL has it's own initialization system, and so no WSL distros use systemd, and do not generally employ a traditional init system.  
  
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

[Connect to WSL via SSH](https://superuser.com/questions/1123552/how-to-ssh-into-wsl)
[SSH into a WSL2 host remotely and reliably](https://medium.com/@gilad215/ssh-into-a-wsl2-host-remotely-and-reliabley-578a12c91a2)
`sudo apt install openssh-server # Install SSH server`  
`/etc/ssh/sshd_config` # Change `Port 22` to `Port 2222` as Windows uses port 22  
`sudo visudo`  # We setup `service ssh` to not require a password
```
# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL
%sudo   ALL=NOPASSWD: /usr/sbin/service ssh *
```
`sudo service ssh --full-restart` # Restart ssh service  `sudo /etc/init.d/ssh start` 
You might see: `sshd: no hostkeys available -- exiting`  
If so, you need to run: `sudo ssh-keygen -A` to generate in `/etc/ssh/`  
Now restart the server: `sudo /etc/init.d/ssh start`  
You might see the following error on connecting: "No supported authentication methods available (server sent: publickey)"  
To fix this, `sudo vi /etc/ssh/sshd_config`. Change as follows to allow username/password authentication:  
`PasswordAuthentication = yes`  
`ChallengeResponseAuthentication = yes`  
Restart ssh `sudo /etc/init.d/ssh restart` (or `sudo service sshd restart`).  
Note: If you set PasswordAuthentication to yes and ChallengeResponseAuthentication to no you are able to connect automatically with a key, and those that don't have a key will connwct with a password - very useful

# Using PuttyGen, keygen-ssh and authorized_keys
PuttyGen will create a public key file that looks like:  
```
---- BEGIN SSH2 PUBLIC KEY ----  
Comment: "rsa-key-20121022"  
AAAAB3NzaC1yc2EAAAABJQAAAIEAhGF6GIuMY8FJ1+CNApnSY1N2YSlkYz72Yvwu  
a6N1nFpBklz1+dsIMg4rcTLcF34M/tW5Yz+NUDAw2AEbxQ32FPgw7sAOIXktkYOH  
tr7mmimiTjkoSCrJh1kqalPSpi8rglT/Bp67Ql2SZwvUFfMzHISryR0EZC4rXP/u  
vObrJe8=  
---- END SSH2 PUBLIC KEY ----  
```
However, this will not work, so what you need to do is to open the key in PuttyGen, and then copy it from there (this results in the key being in the right format and in 1 line):  
```
ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEAhGF6GIuMY8FJ1+CNApnSY1N2YSlkYz72Yvwua6N1nFpBklz1+dsIMg4rcTLcF34M/tW5Yz+NUDAw2AEbxQ32FPgw7sAOIXktkYOHtr7mmimiTjkoSCrJh1kqalPSpi8rglT/Bp67Ql2SZwvUFfMzHISryR0EZC4rXP/uvObrJe8= rsa-key-20121022
```
Paste this into `authorized_keys` then it should work.

I also try use it as a remote gdb server for visual studio by VisualGDB,it not works well. VisualGDB will support it in the next version as the offical website shows.The link is https://sysprogs.com/w/forums/topic/visualgdb-with-windows-10-anniversary-update-linux-support/#post-9274



# SSH Server Setup (openssh-server)  
  
**Enable ability to connect to WSL locally on 127.0.0.1 (port 2222) or remotely from any system in the network**  
  
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

Can now connect LOCALLY via putty or other ssh client at 127.0.0.1 on port 2222 (remember that Windows now has a built in ssh.exe and ssh-keygen.exe etc).  
  
To connect from a REMOTE system to this instance of WSL, follow this [guide](https://medium.com/@gilad215/ssh-into-a-wsl2-host-remotely-and-reliabley-578a12c91a2):  
```
edit /etc/ssh/sshd_config with the following three changes
Port 2222
ListenAddress 0.0.0.0
PasswordAuthentication yes
```

We also need to edit /etc/sudoers.d/ in order to remove the requirement of a password for starting the ssh service, this will come handy later on in the automation section of the article, so add the following line:  
`%sudo ALL=NOPASSWD: /usr/sbin/service ssh *`  
After all this we can start the service:  
`service ssh start`  
  
# Other WSL Notes  
  
**Starting WSL with keyboard shortcut ...**
  
**How to install Fedora Remix 33 for WSL 2 ...**  
  
**[Guide to using Linux GUI apps + ZSH + Docker on WSL 2](https://scottspence.com/2020/12/09/gui-with-wsl/#video-detailing-the-process)**  
[Nicky Meuleman’s guide on Using Graphical User Interfaces like Cypress’ in WSL2](https://nickymeuleman.netlify.app/blog/gui-on-wsl2-cypress)  
[Nicky Meuleman’s guide on Linux on Windows WSL 2 + ZSH + Docker](https://nickymeuleman.netlify.app/blog/linux-on-windows-wsl2-zsh-docker)  
[Notes on Zsh and Oh My Zsh](https://scottspence.com/2020/12/08/zsh-and-oh-my-zsh/)  
[Nicky Meuleman’s guide on setting up ZSH](https://nickymeuleman.netlify.app/blog/linux-on-windows-wsl2-zsh-docker#zsh)  
There is talk of the WSL team Adding Linux GUI app support to WSL but this is slated for an update around December 2020, but this will only be in the Insider's Build and probably not in the main release of Windows 10 until the Spring/Summer 2021 release.  
  
**Support for Wayland GUI Apps in WSL 2**
  
With the latest updates to WSL2, Linux GUI apps integrate with Windows 10 using Wayland display server protocol running inside of WSL. Wayland communicates with a Remote Desktop Protocol (RDP) client on the Windows host to run the GUI app.  
  
Microsoft is also bringing GPU hardware acceleration for Linux applications running in WSL2. It has pushed the first draft of the brand new GPU driver ‘Dxgkrnl’ for the Linux kernel.  
  
**Run Windows commands from WSL and vice-versa**  
In the Windows 10 Creators Update (build 1703, April 2017), this is natively supported. So you can now run Windows binaries from Linux...  
`alias putty="/mnt/c/ProgramData/chocolatey/bin/PUTTY.EXE"  # Run Windows commands form Linux`  
`bash -c "fortune | cowsay"                                 # Run Linux commands from Windows PowerShell`  
  
**Quick summary**  
Reboot: do not use `sudo reboot`, use `wsl -t <distro>` (or from inside the session itself, use `wsl.exe -t <distro>`)  
To shutdown all distros immediately (i.e. to close the WSL VM manager): `wsl -shutdown` (or from inside the session itself, use `wsl.exe -shutdown`)  



# Using the Remote extension in VS Code

This is very important for seamless integration between WSL sessions and Windows, so that you can open any script on the WSL session using VS Code. Install this extension from within VS Code to be able to run `code ~/.bashrc` directly inside a WSL session and have that open in VS Code.
*... add more notes here ...*  

# Useful Links and One-Liner Bash Functions etc

**WSL Links**  
[WSL: The Ultimate Guide](https://adamtheautomator.com/windows-subsystem-for-linux/)  
[Linux Graphical Apps coming to WSL](https://www.zdnet.com/article/linux-graphical-apps-coming-to-windows-subsystem-for-linux/)  
[Target WSL from Visual Studio](https://devblogs.microsoft.com/cppblog/targeting-windows-subsystem-for-linux-from-visual-studio/)  
[Fun with WSL (older page, some info is out of date)](https://blogs.windows.com/windowsdeveloper/2016/07/22/fun-with-the-windows-subsystem-for-linux/)  

**Custom Functions for Profiles**  
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
Above command will give a sorted list of IP’s with number of connections to port 80.

`https://aka.ms/wsl`  
`https://docs.microsoft.com/en-us/windows/wsl/wsl-config#list-distributions`  

https://ubuntu.com/wsl

# [Compare WSL 1 and WSL 2](https://docs.microsoft.com/en-gb/windows/wsl/compare-versions)
**WSL 2 architecture**  
Traditional VMs are slow to boot up, isolated, and consume a lot of resources. WSL 2 does not have these attributes, and requires no VM configuration or management While WSL 2 does use a VM, it is managed and run behind the scenes, leaving you with the same user experience as WSL 1.  

**Full Linux kernel**  
The Linux kernel in WSL 2 is built by Microsoft from the latest stable branch, based on the source available at kernel.org. This kernel has been specially tuned for WSL 2, optimizing for size and performance, and will be serviced by Windows updates for latest security fixes and kernel improvements.  

**Increased file IO performance**  
File intensive operations like git clone, npm install, apt update, apt upgrade, and more are all noticeably faster with WSL 2. Initial versions of WSL 2 run up to 20x faster compared to WSL 1 when unpacking a zipped tarball, and around 2-5x faster when using git clone, npm install and cmake on various projects.  

**Full system call compatibility**  
Linux binaries use system calls to perform functions such as accessing files, requesting memory, creating processes, and more. Whereas WSL 1 used a translation layer that was built by the WSL team, WSL 2 includes its own Linux kernel with full system call compatibility. Benefits include:  
• A whole new set of apps that you can run inside of WSL, such as Docker and more.
• Updates to the Linux kernel are immediately ready for use (You don't have to wait for the WSL team to implement updates and add the changes).

**Accessing network applications**  
Accessing Linux networking apps from Windows (localhost)  
If you are building a networking app (for example an app running on a NodeJS or SQL server) in your Linux distribution, you can access it from a Windows app (like your Edge or Chrome internet browser) using localhost (just like you normally would).  

To find the IP address of the virtual machine powering your Linux distribution:

From your WSL distribution (ie Ubuntu), run the command: ip addr
Find and copy the address under the inet value of the eth0 interface.
If you have the grep tool installed, find this more easily by filtering the output with the command: ip addr | grep eth0
Connect to your Linux server using this IP address.
The picture below shows an example of this by connecting to a Node.js server using the Edge browser.

Connect to NodeJS server with Edge

Accessing Windows networking apps from Linux (host IP)
If you want to access a networking app running on Windows (for example an app running on a NodeJS or SQL server) from your Linux distribution (ie Ubuntu), then you need to use the IP address of your host machine. While this is not a common scenario, you can follow these steps to make it work.

Obtain the IP address of your host machine by running this command from your Linux distribution: cat /etc/resolv.conf
Copy the IP address following the term: nameserver.
Connect to any Windows server using the copied IP address.
The picture below shows an example of this by connecting to a Node.js server running in Windows via curl.

Connect to NodeJS server in Windows via Curl

Additional networking considerations
Connecting via remote IP addresses
When using remote IP addresses to connect to your applications, they will be treated as connections from the Local Area Network (LAN). This means that you will need to make sure your application can accept LAN connections.

For example, you may need to bind your application to 0.0.0.0 instead of 127.0.0.1. In the example of a Python app using Flask, this can be done with the command: app.run(host='0.0.0.0'). Please keep security in mind when making these changes as this will allow connections from your LAN.

Accessing a WSL 2 distribution from your local area network (LAN)
When using a WSL 1 distribution, if your computer was set up to be accessed by your LAN, then applications run in WSL could be accessed on your LAN as well.

This isn't the default case in WSL 2. WSL 2 has a virtualized ethernet adapter with its own unique IP address. Currently, to enable this workflow you will need to go through the same steps as you would for a regular virtual machine. (We are looking into ways to improve this experience.)

Here's an example PowerShell command to add a port proxy that listens on port 4000 on the host and connects it to port 4000 to the WSL 2 VM with IP address 192.168.101.100.

PowerShell

Copy
netsh interface portproxy add v4tov4 listenport=4000 listenaddress=0.0.0.0 connectport=4000 connectaddress=192.168.101.100
IPv6 access
WSL 2 distributions currently cannot reach IPv6-only addresses. We are working on adding this feature.

Expanding the size of your WSL 2 Virtual Hard Disk
WSL 2 uses a Virtual Hard Disk (VHD) to store your Linux files. In WSL 2, a VHD is represented on your Windows hard drive as a .vhdx file.

The WSL 2 VHD uses the ext4 file system. This VHD automatically resizes to meet your storage needs and has an initial maximum size of 256GB. If the storage space required by your Linux files exceeds this size you may need to expand it. If your distribution grows in size to be greater than 256GB, you will see errors stating that you've run out of disk space. You can fix this error by expanding the VHD size.

To expand your maximum VHD size beyond 256GB:

Terminate all WSL instances using the command: wsl --shutdown

Find your distribution installation package name ('PackageFamilyName')

Using PowerShell (where 'distro' is your distribution name) enter the command:
Get-AppxPackage -Name "*<distro>*" | Select PackageFamilyName
Locate the VHD file fullpath used by your WSL 2 installation, this will be your pathToVHD:

%LOCALAPPDATA%\Packages\<PackageFamilyName>\LocalState\<disk>.vhdx
Resize your WSL 2 VHD by completing the following commands:

Open Windows Command Prompt with admin privileges and enter:

PowerShell

Copy
diskpart
DISKPART> Select vdisk file="<pathToVHD>"
DISKPART> detail vdisk
Examine the output of the detail command. The output will include a value for Virtual size. This is the current maximum. Convert this value to megabytes. The new value after resizing must be greater than this value. For example, if the detail output shows Virtual size: 256 GB, then you must specify a value greater than 256000. Once you have your new size in megabytes, enter the following command in diskpart:

PowerShell

Copy
DISKPART> expand vdisk maximum=<sizeInMegaBytes>
Exit diskpart

PowerShell

Copy
DISKPART> exit
Launch your WSL distribution (Ubuntu, for example).

Make WSL aware that it can expand its file system's size by running these commands from your Linux distribution command line.

 Note

You may see this message in response to the first mount command: /dev: none already mounted on /dev. This message can safely be ignored.

PowerShell

Copy
   sudo mount -t devtmpfs none /dev
   mount | grep ext4
Copy the name of this entry, which will look like: /dev/sdX (with the X representing any other character). In the following example the value of X is b:

PowerShell

Copy
   sudo resize2fs /dev/sdb <sizeInMegabytes>M
 Note

You may need to install resize2fs. If so, you can use this command to install it: sudo apt install resize2fs.

The output will look similar to the following:

Bash

Copy
   resize2fs 1.44.1 (24-Mar-2018)
   Filesystem at /dev/sdb is mounted on /; on-line resizing required
   old_desc_blocks = 32, new_desc_blocks = 38
   The filesystem on /dev/sdb is now 78643200 (4k) blocks long.
 Note

In general do not modify, move, or access the WSL related files located inside of your AppData folder using Windows tools or editors. Doing so could cause your Linux distribution to become corrupted.




**Enable root user in various distros**  
• For Ubuntu:  
`ubuntu config --default-user <user_name>`  
• For openSuse:  
`opensuse-42 config --default-user <user_name>`  
• For SUSE Linux Enterprise Server:  
`sles-12 config --default-user <user_name>`

Use root for a spcific task:
`sudo -i`
To enable the root account:
`sudo -i passwd root`
`su -`   (or `su - root`)
To disable the root account:
`sudo passwd -dl root`

To enable the root account login through the graphical user interface, we need to edit the next two files:

/etc/gdm3/custom.conf
AllowRoot=true

/etc/pam.d/gdm-password
Comment out the line `auth   reuireqd   pam_succeed_if.so user != root quiet_access`


# VS Code Remove Extesion and WSL

https://code.visualstudio.com/docs/remote/wsl  
https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-vscode  
https://ajeet.dev/developing-in-wsl-using-visual-studio-code/  

**Install a distro from App Store or Chocolatey or manually with iwr/curl**  
• App Store: [Distros https://aka.ms/wslstore](https://aka.ms/wslstore)  
• Chocolatey [wsl-ubuntu-2004](https://chocolatey.org/packages/wsl-ubuntu-2004), [wsl-fedoraremix](https://chocolatey.org/packages/wsl-fedoraremix), [wsl-alpine](https://chocolatey.org/packages/wsl-alpine)  
`choco install wsl-ubuntu-2004`  
This chocolatey package can set the default user as root (default is false):  
`choco install wsl-ubuntu-2004 --params "/InstallRoot:true"`  
• Using [iwr/curl](https://docs.microsoft.com/en-us/windows/wsl/install-manual) (Invoke-WebRequest):  
`iwr -Uri https://aka.ms/wslubuntu2004 -OutFile Ubuntu.appx -UseBasicParsing`  
`curl.exe -L -o Ubuntu.appx https://aka.ms/wslubuntu2004            # curl.exe`  
Finally, install and register with: `Add-AppxPackage .\Ubuntu.appx  # To install the AppX package`  
After doing this, `wsl -l -v` will show the registered distro.

# custom_loader.sh and .custom tools

To inject into the configurations files (`.bashrc`, `.vimrc`, `.intputrc`, `sudoers`), `custom_loader.sh` uses a few `grep`, `sed`, and `tee` techniques to selectively remove only specific lines and then replace them. For `.bashrc`, the goal is to make sure that the `.custom` lines are always positioned at the end of file so that this only loads after `.bashrc` so that this project makes sure to alter core files as little as possible.  
**Using `grep` to prune lines**  
First define the exact line to be pruned (I could use a smaller subset like `[ ! -f ~/.custom ]` as that would be enough, since it relates to .custom so can only be relating to this project, but in this case, we prune the entire line).  
`GETCUSTOM='[ ! -f ~/.custom ] && [[ $- == *"i"* ]] && curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > ~/.custom'`  
Then search only for this specific line (-q silent show no output, -x full line match, -F fixed string / no regexp), and then appends directly onto the file (have to use `tee` here as you cannot `>` directly onto the file as that operation will happen while the grep is happening; by using `tee` the entire `grep` will finish then append to the file).  
`grep -qxF "$GETCUSTOM" ~/.bashrc || echo $HEADERCUSTOM | tee --append ~/.bashrc`  
Note: if doing this with a system file (like `/etc/bashrc`), you have to *also* sudo the `tee` command:
`grep -qxF "$GETCUSTOM" /etc/bashrc || echo $HEADERCUSTOM | sudo tee --append ~/.bashrc`  
This is because even though you might be able to read `/etc/bashrc`, writing to it must be elevated, and note that putting `sudo` before the `grep` command will not do that (elevates only the `grep` process and not the `tee` process).

**Removing empty lines but only from the end of a file**
This is to make sure no empty lines at end of file, except for one required before our lines.  
`sed -i -e :a -e '/^\n*$/{$d;N;};/\n$/ba' ~/.bashrc`   # Removes also any empty lines from the end of a file. https://unix.stackexchange.com/questions/81685/how-to-remove-multiple-newlines-at-eof/81687#81687  
`echo "" | tee --append ~/.bashrc`   # Add an empty line back in as a separator before our the lines to call .custom  

**.inputrc changes**.  
`set completion-ignore-case On`   really useful to prevent case-sensitivity taking over when trying to tab complete into folders

**`.vimrc`**  

**`sudoers`**  
Notes on changes to sudoers here ...

**The Ultimate Guide to Windows Subsystem for Linux (Windows WSL)**   2021-02-02
https://adamtheautomator.com/windows-subsystem-for-linux/ (END)
