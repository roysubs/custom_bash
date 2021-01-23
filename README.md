# Automated Bash Customisation

Project to create a consistent and maintainable bash environment with simple standard aliases and functions even for minimal text-based Linux setups. Does this by only modifying 2 lines in `~/.bashrc` to specifically only apply to interactive shells (i.e. an `ssh login` shell or a `terminal` windows from a Linux Gnome/KDE environment) and will not load during non-interactive shells (such as when a script is invoked, as discussed here: https://askubuntu.com/questions/1293474/which-bash-profile-file-should-i-use-for-each-scenario/1293679#1293679. The changes are designed to be fully cross-platform, so should run correctly on all Debian/RedHat variants (so, Ubuntu/Fedora/CentOS also). The cusomisation also updates simple changes to `.vimrc` and `.inputrc` to make life easier on new or existing setups. Changes can be completely removed by simply removing `~\.custom`.

**`custom_loader.sh`**. This script adds two lines to `~/.bashrc` to dotsource `~/.custom` into environment (which is where the additional bash configuration is) whenever a new shell starts. Installs selected core tools (`vim, openssh, curl, wget, dpkg, net-tools, git, figlet, cowsay, fortune-mod`). Enable generic settings in `~/.vimrc` and `~/.inputrc`. Finally, dotsource `~/.custom` into the currently running session. Can run `custom_loader.sh` on any system with an internet connection with (removed `-i` to suppress HTTP header information):
`curl https://raw.githubusercontent.com/roysubs/custom_bash/master/custom_loader.sh | bash`

Alternatively, to clone the entire repository, use: `git clone https://github.com/roysubs/custom_bash`, then cd into that folder and run: `. ./custom_loader.sh` (the dotsource is required to load into the current session).

`custom_loader.sh` setup uses `sed` to find and remove all lines that start `[ -f ~/.custom ]` from `.bashrc`and then appends `[ -f ~/.custom ] && [[ $- == *"i"* ]] && . ~/.custom; else curl` so that `.bashrc` will then always load `~/.custom` correctly.

**ToDo** (possibly by switch?, however, it might not be possible to invoke a script *with switches* via `curl`, so could use the existence of a local file to check if the change should be made. i.e. if `.custom_load_system_wide` exists then do the changes and delete that file): Make all of the above load system-wide, i.e. create `/etc/.custom` and make changes to `/etc/bashrc`, `/etc/vimrc`, `/etc/inputrc` instead of `~`. If doing this, must also clean up `~` to remove the details there.

**ToDo** (also possibly by switch, or by a flag file, `.custom_load_coreapps`): Install various various core apps. e.g.
`sudo apt install git vim curl openssh-server`
`sudo apt install libsecret-1-0 libsecret-1-dev`
`sudo apt <xrdp core configuration for debian/red-hat variants>`

https://stackoverflow.com/questions/36585496/error-when-using-git-credential-helper-with-gnome-keyring-as-sudo/40312117#40312117

