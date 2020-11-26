Try to automate a set of bash shell environment essentials.
Consists of two scripts.

1. `.custom`. The set of common tools to apply to all working environments
2. `custom_loader.sh`. Loader script that prepares the environment and checks requirements.

When `custom_loader.sh` is on a new system, a single line is injected into .bashrc that will download `~/.custom` if it is not present and then run `.custom` (but only if this is an interactive shell i.e. will not be loaded when a script is invoked separately):
[[ $- == *"i"* ]] && [ -f ~/.custom ] && . ~/.custom

Additionally, `custom_loader.sh` will check and apply some generically useful custom changes to `~/.vimrc`, `~/.inputrc`. 

Optionally (using a switch?), make all of the above load system-wide, i.e. into /etc/bashrc, /etc/vimrc, /etc/inputrc

Optionally (using a switch?), install various various core apps. e.g.
`sudo apt install git vim openssh-server`
`sudo apt install libsecret-1-0 libsecret-1-dev`
`sudo apt <xrdp core configuration>`

https://stackoverflow.com/questions/36585496/error-when-using-git-credential-helper-with-gnome-keyring-as-sudo/40312117#40312117

https://askubuntu.com/questions/1293474/which-bash-profile-file-should-i-use-for-each-scenario/1293679#1293679
