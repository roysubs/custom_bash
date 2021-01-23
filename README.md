# Automated Bash Customisation

Create a consistent bash environment with various standard changes. Called from `~/.bashrc` but in such a way as to apply *only* to interactive shells (ssh login or a terminal windows) and will not load during non-interactive shells (such as when a script is invoked.

**`custom_loader.sh`**. Adds lines to `~/.bashrc` to dotsource `~/.custom` into environment (which is where the additional bash configuration is) whenever a new shell starts. Installs selected core tools (`vim, openssh, curl, wget, dpkg, net-tools, git, figlet, cowsay, fortune-mod`). Enable generic settings in `~/.vimrc` and `~/.inputrc`. Finally, dotsource `~/.custom` into the currently running session. Can run `custom_loader.sh` on any system with an internet connection with (removed `-i` to suppress HTTP header information):
`curl https://raw.githubusercontent.com/roysubs/custom_bash/master/custom_loader.sh | bash`
Alternatively, to clone the entire repository, use:
`git clone https://github.com/roysubs/custom_bash`
Then cd into that folder and run:
`. ./custom_loader.sh   # The dotsource is required to load into the current session`

**`.custom`**. Common configuration and compatible with Debian/Ubuntu/RHEL/Fedora/CentOS variants, but only for interactive shells, as discussed here: https://askubuntu.com/questions/1293474/which-bash-profile-file-should-i-use-for-each-scenario/1293679#1293679

`custom_loader.sh` achieves this by using `sed` to find and remove any lines that start `[ -f ~/.custom ]`, remove *all* lines like that (as `.custom` is only for this function so that test is enough), then append `>>` the latest test line to the end of `~/.bashrc`. The line that `custom_loader.sh` injects into `~/.bashrc` is:

`[ -f ~/.custom ] && [[ $- == *"i"* ]] && . ~/.custom; else curl`

Running `custom_loader.sh` should also check and apply some generically useful basic custom changes for `~/.vimrc`, `~/.inputrc` (and possibly other core settings?).

**ToDo** (possibly by switch?, however, it might not be possible to invoke a script *with switches* via `curl`, so could use the existence of a local file to check if the change should be made. i.e. if `.custom_load_system_wide` exists then do the changes and delete that file): Make all of the above load system-wide, i.e. create `/etc/.custom` and make changes to `/etc/bashrc`, `/etc/vimrc`, `/etc/inputrc` instead of `~`. If doing this, must also clean up `~` to remove the details there.

**ToDo** (also possibly by switch, or by a flag file, `.custom_load_coreapps`): Install various various core apps. e.g.
`sudo apt install git vim curl openssh-server`
`sudo apt install libsecret-1-0 libsecret-1-dev`
`sudo apt <xrdp core configuration for debian/red-hat variants>`

https://stackoverflow.com/questions/36585496/error-when-using-git-credential-helper-with-gnome-keyring-as-sudo/40312117#40312117

