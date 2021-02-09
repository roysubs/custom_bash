# Standardised 'ls' output. Adding colour, grouping directories first, -F append indicator (one of */=>@|) to entries, suppress ./ and ../
# ls shows all files including .*, l is the same but without .*, ll is as ls but -l long format, l. and ll. are for .* files only, lss shows both security views (drwxr-xr-x / 755)
if [[ $(type ls) == *"aliased"* ]]; then unalias ls; fi    # Remove any alias from .bashrc / .bash_profile etc, note "\ls" for "l", this ignores the alias "ls" to run raw to remove "A"
alias ls='ls -FAh --color=auto --group-directories-first'  # A (almost all, ignores ./ and ../, but show all ".*" files, putting this to 'ls' as almost always wnat to see .* files)
alias l='\ls --color=auto --group-directories-first'       # Do not show hidden (.*) (this is the more normal 'ls' alias output, but putting to 'l' as usually always want "A" flag
alias ll='ls -l'       # A (almost all, ignores ./ and ../ but show all .* files), long format
alias l.='ls -d .*'    # Explicitly list just .* files, so ./ and ../ are shown, overriding the A flag
alias ll.='ls -dl .*'  # Explicitly list just .* files, so ./ and ../ are shown, overriding the A flag, long format
alias lss='stat --printf="%A\t%a\t%h\t%U\t%G\t%s\t%.19y\t%n\n"' # ls+security (shows the octal code as well as normal ls security flags) using stat

# git: g, gst, ga, gcm, gcl, gstash, glog
# gc, gcg, gcname, gadu, gall, git-push
alias g='git'; alias gst='git status'; alias ga='git add .'; alias gcm='git commit -m'; alias gcl='git clone'; alias gstash='git stash'; alias glog='git log'
alias gc='git config'; alias gcg='git config --global'; alias gcname='git config --global user.name; git config --global user.email'
alias gadu='git add -u'; alias gall='git add .'   # Git shortcuts (see link in profile notes) 
git-push() { if [ ! -d .git ]; then echo "Current folder is not a git repository (no .git folder is present)"; else printf "\nWill run the following if choose to continue:\n\n=>  git status   =>  git add .  [add all files]    =>  git status  [pause to check]\n=>  git commit -m \"Update\"     =>  git status      =>  git push -u origin master \n\n"; read -p "Ctrl-C to quit or press any key to continue ..."; printf "\n"; "git status before adding files:"; git status; git add .; echo "git status after 'git add .'"; git status; git commit -m "Update"; read -p "About to upload repository to github\nCtrl-C to quit, or any key to push local project up to remote repository ..."; git push -u origin master; fi; }

# Tired of typing out 'sudo apt install' a lot so abbreviated these. Just have to be careful to avoid standard commands like 'du'
# di, dr, ds, dh, dnfup  |  yi, yr, ys, yh, yumup  |  ai, ar, as, ah, aptup  |  i(install), r(emove), s(search), h(istory), aptup = update + upgrade + dist-update
# ToDo: Generic functions. pki(install), pkr(remove), pkh(history), pks(search), find OS (/etc/issue), use default tool for that OS.
#    or a function patch() to patch correctly per OS. 'update' + 'upgrade' + 'remove obsolete packages' + 'autoremove', + 'dist-upgrade' etc
#    or a function 'pk' with arguments i, r, h, s, gi(groupinstall), gl(grouplist), etc uses default tool depending on OS it is on (or specify with another variable d, y, a, z, d, s, f, ai)
if which apt &> /dev/null; then alias ai='sudo apt install'; alias ar='sudo apt remove'; alias as='apt search'; alias ah='apt history'; alias aptup='sudo apt update && sudo apt upgrade'; alias ax='apt show $1 2>/dev/null | egrep --color=never -i "Origin:|Download-Size:|Installed-Size:|Description:|^  *"'; fi   # apt
# sudo apt list --upgradable
if which dnf &> /dev/null; then alias di='sudo dnf install'; alias dr='sudo dnf remove'; alias ds='dnf search'; alias dh='dnf history'; alias dnfup='sudo dnf update && sudo dnf upgrade'; fi   # dnf
if which yum &> /dev/null; then alias yi='sudo yum install'; alias yr='sudo yum remove'; alias ys='yum search'; alias yh='yum history'; alias yumup='sudo yum update && sudo yum upgrade'; fi   # yum
if which zypper &> /dev/null; then alias zi='sudo zypper install';  alias zr='sudo zypper remove';  alias zs='zypper search';  alias zh='zypper history'; fi  # SLES
if which dpkg &> /dev/null; then alias dpi='sudo dpkg install'; alias dpr='sudo dpkg remove'; alias dps='dpkg search'; alias dph='dpkg history'; fi   # dpkg
if which snap &> /dev/null; then alias sni='sudo snap install'; alias snr='sudo snap remove'; alias sns='snap search'; alias snh='snap history'; fi   # snap
if which flatpak &> /dev/null; then alias fli='sudo flatpak install';  alias flr='sudo flatpak remove';  alias fls='flatpak search';  alias flh='flatpak history'; fi  # flatpak
if which appimage &> /dev/null; then alias api='sudo appimage install'; alias apr='sudo appimage remove'; alias aps='appimage search'; alias aph='appimage history'; fi   # appimage
# An issue that I would 
# 

# Replace 'cat' by 'bat'. Only do this if 'bat' is present. 'unalias cat' to revert to normal 'cat' if wanted.
[ -f /usr/bin/bat ] && alias cat='bat -pp' && alias cats='sudo cat' && c='cat' && alias b='bat' # alias if 'bat' installed
[ ! -f /usr/bin/bat ] && unalias cat 2>/dev/null && unalias cats 2>/dev/null && unalias c 2>/dev/null && unalias b 2>/dev/null # remove if uninstalled

# Color for LESS/MAN pages, as some distros do not provide this by default (e.g. CentOS).
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
export GROFF_NO_SGR=1                  # not for putty (konsole and gnome-terminal)

[ ${BASH_VERSINFO[0]} -ge 4 ] && shopt -s autocd    # if bash ver 4+, then autocd. i.e. if type a directory name to cd into it, without needing to type 'cd'

# Some basic/useful functions (and to use as templates to demonstrate some function syntax)
md() { [ $# = 1 ] && mkdir -p "$@" && cd "$@" || echo "Error - no directory passed!"; }  # 'mkdir' and then 'cd' into that directory
psmemory() { ps aux | awk '{if ($5 != 0 ) print $2,$5,$6,$11}' | sort -k2n; }
dufix() { local dotglob=$(shopt -p dotglob); shopt -s dotglob; printf ""; du -hsc */ | sort -h; eval $dotglob; printf "\n$(ls -alc | grep ^total) = size of all files in current directory only\n\n"; } # Fixes du for current folder, as it normally skips .* files/folders. To find only folders bigger than 1 GB, add   | grep -E ^[0-9]+?\.?[0-9]+G
dufixsu() { local dotglob=$(shopt -p dotglob); shopt -s dotglob; sudo du -hsc */ | sort -h; eval $dotglob; printf "\n$(sudo ls -alc | grep ^total) (size of files in current directory only)\n\n"; }    # As for dufix(), but includes also inaccessible folders, so requiring 'sudo'
viconf() { COLUMNS=12; printf -v PS3 '\n%s ' 'Select option: '; printf "Edit config file:\n\n"; select x in ~/.bashrc ~/.bash_profile ~/.bash_login ~/.profile ~/.custom ~/.inputrc ~/.vimrc; do vim $x; break; done; }
viconfsu() { COLUMNS=12; printf -v PS3 '\n%s ' 'Select option: '; printf "Edit config file (with sudo):\n\n"; select x in vim\ /etc/profile vim\ /etc/bashrc vim\ /etc/inputrc vim\ /etc/vimrc vim\ /etc/hosts vim\ /etc/samba/smb.conf visudo; do sudo $x; break; done; }
runfromurl() { curl -s $2 > $1; chmod a+x $1; ls -l $1; if [ $3 = "print" ]; then cat "./$1"; fi; if [ $3 = "run" ]; then exec "./$1"; fi; }
exe() { printf "\n\n"; echo "\$ ${@/eval/}"; "$@"; }   # Show the command to be run before running, useful for scripting
ver() { [ -f /etc/redhat-release ] && RELEASE=$(cat /etc/redhat-release); [ -f /etc/lsb-release ] && RELEASE="$(cat /etc/lsb-release | grep DESCRIPTION | sed 's/^.*=//g' | sed 's/\"//g') "; printf "$RELEASE: $(uname -msr)\n"; }
sys() { awk -F": " '/^model name/ { mod=$2 } /^cpu MHz/ { mhz=$2 } /^cpu core/ {core=$2} /^flags/ { virt="No Virtualisation";match($0,"svm");if (RSTART!=0) { virt="SVM-Virtualisation" };match($0,"vmx");if (RSTART!=0) { virt="VMX-Virtualisation" } } /^Mem:/ {split($2,arr," ");tot=arr[1];free=arr[2]} END { printf "%s, %dMHz, %s core(s), %s, %sB Memory (%sB Used)\n",mod,mhz,core,virt,tot,free }' /proc/cpuinfo <(free -mh); printf "$(hostname -I),$(uptime)\n"; }
color256() { curl -s 0- https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/ | bash; }   # Run script from url
cowall() { for f in /usr/share/cowsay/cows/*.cow; do printf "\n\n\n\n\n$f\n\n"; fortune | cowsay -f $f; done; }
figclock() { while [ 1 ]; do clear; printf "\e[33m"; df -kh; printf "\e[31m\n"; top -n 1 -b | head -13 | tail -11; printf "\e[33m$(figlet -w -t -f small $(date +"%b %d, week %V"))\n"; printf "\e[94m$(figrnd $(date +"%H:%M:%S"))\e[00m\n"; printf "\e[35m5 second intervals, Ctrl-C to quit.\e[00m"; sleep 5; done; }
# figclock() { while [ 1 ]; do clear; printf "\e[33m"; df -kh; printf "\e[31m\n"; top -n 1 -b | head -13 | tail -11; printf "\e[33m$(figlet -w -t -f small $(date +"%b %d, week %V"))\n"; [ -f /usr/share/figlet/univers.flf ] && local opts="-f univers" || local opts="-f big"; printf "\e[94m$(figlet -k -t $opts $(date +"%H:%M:%S"))\e[00m\n"; printf "\e[35m5 second intervals, Ctrl-C to quit.\e[00m"; sleep 5; done; }
# figclock() { while [ 1 ]; do clear; printf "\e[33m"; df -kh; printf "\e[31m\n"; top -n 1 -b | head -13 | tail -11; printf "\e[33m$(figrnd $(date +"%b %d, week %V"))\n"; printf "\e[94m$(figrnd $(date +"%H:%M:%S"))\e[00m\n"; printf "\e[35mRefreshes every 5 seconds (Ctrl-C to quit).\e[00m"; sleep 5; done; }
figall() { for f in /usr/share/figlet/*.flf; do fs=$(basename $f); fname=${fs%%}; echo "$fname"; figlet -f $fname $fname; done; }
figrnd() { rand=$(ls /usr/share/figlet/*.flf | sort -R | tail -1); printf "$rand\n\n"; figlet -w $(tput cols) -f $rand "$1"; }   # 'sort -R' is random, also note 'shuf'
fignow() { printf "\e[33m$(figlet -w -t -f small $(date +"%b %d, week %V"))\n"; [ -f /usr/share/figlet/univers.flf ] && local opts="-f univers" || local opts="-f big"; printf "\e[94m$(figlet -t $opts $(date +"%H:%M"))\e[00m\n"; }

login_banner() { printf "\n##########\n$(ver)\n##########\n$(sys)\n##########\n"; [ -f /usr/bin/figlet ] && fignow; }
if [ -z "$TMUX" ]; then login_banner; fi   # Only display the login banner if this is not a new tmux session
# [ -z $TMUX ] && export TERM=xterm-256color && exec tmux   # Always start tmux at login, but skip when running a new tmux session

# Aliases for Windows apps (only runs if inside WSL, i.e. if /proc/version contains "Microsoft" or "WSL").   https://stackoverflow.com/q/38086185/   https://meta.stackexchange.com/q/164194/
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    # winhome always find case-sensitive User folder in the Windows filesystem (due to case-sensitivity in Linux, this folder could have different case than the Linux user name. e.g. "C:\Users\John" in Windows might be "/home/john" in WSL.
    winhome=$(find /mnt/c/Users -maxdepth 1 -type d -regextype posix-extended -iregex /mnt/c/users/$USER)
    [ ! -d $winhome ] && mkdir "$winhome"
    # $1 is name of the alias and $2 is the (escaped, i.e. spaces should be escaped) path to the target file
    # winalias() { [ -f $2 ] && alias $1="$2" }   # Default Portable Edition location with Chocolatey package
    # winalias chrome /mnt/c/Program\ Files/Google/Chrome/Application/chrome.exe
    alias chrome="\"/mnt/c/Program Files/Google/Chrome/Application/chrome.exe\""  # Chrome, can use with URLs:       chrome www.google.com
    alias notepad++="\"/mnt/c/Program Files/Notepad++/notepad++.exe\""            # Notepad++, can use with files:   notepad++ C:\Temp\Test.txt
    alias n='notepad++'                                                           # n C:\Temp\Test.txt
    # Don't use code.exe from a full installation or the chocolatey shim at /mnt/c/ProgramData/chocolatey/bin/code.exe. Both of these generate errors.
    # Microsoft already provides the "code" shell script for this purpose. Try three main locations to create an alias for the VS Code "code" shell script.
    [ -f /mnt/c/tools/vscode/bin/code ] && alias code="\"/mnt/c/tools/vscode/bin/code\""   # Default Portable Edition location with Chocolatey package
    [ -f /mnt/c/Program\ Files/Microsoft\ VS\ Code/bin/code ] && alias code="\"/mnt/c/Program Files/Microsoft VS Code/bin/code\""   # Default System Install location
    [ -f $winhome/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code ] && alias code="\"$winhome/AppData/Local/Programs/Microsoft\ VS\ Code/bin/code\""   # Default User Install location
    alias c='code'
    alias clip_ip='hostname -I | clip.exe'
fi

# https://tldp.org/LDP/abs/html/testconstructs.html#DBLBRACKETS
# The [[ ]] construct is the more versatile Bash version of [ ]. This is the extended test command, adopted from ksh88.
# Using the [[ ... ]] test construct, rather than [ ... ] can prevent many logic errors in scripts. For example, the &&, ||, <, and > operators work within a [[ ]] test, despite giving an error within a [ ] construct.
# Ctrl-R : (reverse-i-search)`':  Press once and type part of a command in history, Ctrl-R again to go back in the list