Will automate a consistent customised bash environment and make that available in any interactive shell (without affecting non-interactive shells, i.e. will not bloat the load times for scripts invoked to run non-interactively). This is done using two scripts:

**1. `.custom`**. This is the set of custom tools to only apply within interactive shells. Note also that this should apply in both login shells (i.e. an ssh session directly onto the host) *and* to terminal shells inside window manager sessions, as discussed here: https://askubuntu.com/questions/1293474/which-bash-profile-file-should-i-use-for-each-scenario/1293679#1293679

**2. `custom_loader.sh`**. This loader script prepares the environment and checks requirements.

When `custom_loader.sh` is run on a new system, the following single line is injected into `~/.bashrc` that will download `~/.custom` if it is not present and then dotsource `.custom` into the environment.
[ -f ~/.custom ] && [[ $- == *"i"* ]] && . ~/.custom; else curl

In every future interactive shell, `.custom` will be checked for and then dotsourced at the end of `~/.bashrc`. If `custom_loader.sh` is invoked again, it will simply update `.custom` from GitHub, then dotsource it.

Running `custom_loader.sh` should also check and apply some generically useful basic custom changes for `~/.vimrc`, `~/.inputrc` (and possibly other core settings?).

**ToDo** (possibly by switch?, however, it might not be possible to invoke a script *with switches* via `curl`, so could use the existence of a local file to check if the change should be made. i.e. if `.custom_load_system_wide` exists then do the changes and delete that file): Make all of the above load system-wide, i.e. create `/etc/.custom` and make changes to `/etc/bashrc`, `/etc/vimrc`, `/etc/inputrc` instead of `~`. If doing this, must also clean up `~` to remove the details there.

**ToDo** (also possibly by switch, or by a flag file, `.custom_load_coreapps`): Install various various core apps. e.g.
`sudo apt install git vim openssh-server`
`sudo apt install libsecret-1-0 libsecret-1-dev`
`sudo apt <xrdp core configuration for debian/red-hat variants>`

https://stackoverflow.com/questions/36585496/error-when-using-git-credential-helper-with-gnome-keyring-as-sudo/40312117#40312117
