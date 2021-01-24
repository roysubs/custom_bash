# Automated Bash Customisation

Project to create a consistent and maintainable bash environment with simple standard aliases and functions even for minimal text-based Linux setups. Does this by only modifying 2 lines in `~/.bashrc` to specifically only apply to interactive shells (i.e. an `ssh login` shell or a `terminal` windows from a Linux Gnome/KDE environment) and will not load during non-interactive shells (such as when a script is invoked, as discussed [here](https://askubuntu.com/questions/1293474/which-bash-profile-file-should-i-use-for-each-scenario/1293679#1293679). The changes are designed to be fully cross-platform, so should run correctly on all Debian/RedHat variants (so, Ubuntu/Fedora/CentOS also). The cusomisation also updates simple changes to `.vimrc` and `.inputrc` to make life easier on new or existing setups. Changes can be completely removed by simply removing `~\.custom`.

**`custom_loader.sh`**. This script downloads `~/.custom` (if not already there and then adds two lines into `~/.bashrc` to dotsource `~/.custom` for new shell instances. This script also updates selected core tools (`vim, openssh, curl, wget, dpkg, net-tools, git, figlet, cowsay, fortune-mod`) and generic settings for `~/.vimrc` and `~/.inputrc` and offers to update the localisation settings. Finally, this will dotsource `~/.custom` into the currently running session to be immediately available. To run `custom_loader.sh` on any system with an internet connection with (removed `-i` to suppress HTTP header information):
`curl https://raw.githubusercontent.com/roysubs/custom_bash/master/custom_loader.sh | bash`

Alternatively, to clone the entire repository, use: `git clone https://github.com/roysubs/custom_bash`, then cd into that folder and run: `. ./custom_loader.sh` (the dotsource is required to load into the current session).

`custom_loader.sh` setup uses `sed` to find and remove all lines that start `[ -f ~/.custom ]` from `.bashrc`and then appends `[ -f ~/.custom ] && [[ $- == *"i"* ]] && . ~/.custom; else curl` so that `.bashrc` will then always load `~/.custom` correctly.

**WSL Notes** A big focus was to get all of this working seamlessly with WSL so have compiled some notes relating to that. This project works with Debian/RedHat based WSL images. WSL images run in Hyper-V images controlled by the `LxssManager` service. Restart all WSL instances with `Get-Service LxssManager | Restart-Service`. To [open the current folder in Windows Explorer](https://superuser.com/questions/1338991/how-to-open-windows-explorer-from-current-working-directory-of-wsl-shell#1385493), `explorer.exe .`
Some aliases to make WSL `<=>` Windows usage easier
`alias start=explorer.exe                                                          # "start ." to open Explorer at current folder`
`alias xchrome="\"/mnt/c/Program Files/Google/Chrome/Application/chrome.exe\""     # Open Chrome from WSL`
`alias xnotepad++="\"/mnt/c/Program Files/Notepad++/notepad++.exe\""               # Open Notepad++. To edit .bashrc, use:  xnotepad++ ~/.bashrc`
Note that opening this way will use the hidden `*\\wsl$` share, so opens `*\\wsl$\Ubuntu-20.04\home\boss\.bashrc`
The `~` directory maps to `%localappdata%\lxss\home` (or `%localappdata%\lxss\root` for root) and not to `%userprofile%`.
Run `bash.exe` from a cmd prompt to launch in current working directory. `bash.exe ~` will launch in the user's home directory.
Write up on differences between the /mnt/ drive mounts and the Linux filesystem [here](https://github.com/microsoft/WSL/issues/87#issuecomment-214567251).
`wsl -l -v`
`  NAME            STATE           VERSION`
`* fedoraremix     Running         1`
`  Ubuntu-20.04    Running         1`
In the above, change default distro with: `wsl -s Ubuntu-20.04`
How to reset a WSL distro to initial state: Settings > Apps > Apps & features > select the Linux Distro Name
In the Advanced Options link, select the "Reset" button to restroe to the initial install state (everything will be deleted).
[Multiple instances of same Linux distro in WSL](https://medium.com/swlh/why-you-should-use-multiple-instances-of-same-linux-distro-on-wsl-windows-10-f6f140f8ed88)

**ToDo** Looks like it is not possible to invoke a script *with switches* via `curl`, so could use a local file to check if specific changes need to be made. e.g. overwriting `.custom`, or to load everything to `/etc` instead of `/home` maybe have a `.custom_install_system_wide` flag then delete that file after the change. Make all of the above load system-wide, i.e. create `/etc/.custom` and make changes to `/etc/bashrc`, `/etc/vimrc`, `/etc/inputrc` instead of `~`. If doing this, must also clean up `~` to remove the details there.

**ToDo** If exist `.custom_install_coreapps`): Install various various core apps. e.g.
`sudo apt install git vim curl openssh-server`
`sudo apt install libsecret-1-0 libsecret-1-dev`
`sudo apt <xrdp core configuration for debian/red-hat variants>`

https://stackoverflow.com/questions/36585496/error-when-using-git-credential-helper-with-gnome-keyring-as-sudo/40312117#40312117
[Interesting Vim & Terminal colour notes](https://medium.com/@gillicarmon/create-color-scheme-for-vim-335e842e29ea)
