#!/bin/bash
####################
#
# Configure consistent bash environemtn
# curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > ~/.custom
#
# It is not in general obvious which file to put profile configuration into to only make that
# availabel to *interactive* sessions (i.e. user invoked consoles, be that from opening a 
# Terminal, or from logging in remotely with SSH. We use [[ $- == *"i"* ]] in .bashrc to test
# if the shell is interactive, and call .custom only if that condition is met.
#
####################

# Some random points:
# To paste into a Terminal (in Linux, not via Putty), use Ctrl+Shift+V. In Putty, use  Shift+Insert.
# Also can use the middle mouse button to paste selected text onto a Linux Terminal.
# https://askubuntu.com/questions/734647/right-click-to-paste-in-terminal?newreg=00145d6f91de4cc781cd0f4b76fccd2e

# Check that a script has root priveleges
# if [ "$(id -u)" -ne 0 ]; then
#     echo 'This script must be run with root privileges' >&2
#     return
# fi

####################
#
# print_header() and exe() functions
#
####################
# Used to display a command and then run it
# https://stackoverflow.com/questions/2853803/how-to-echo-shell-commands-as-they-are-executed
# By default, the following 'exe' will run unattended
# If "y" is chosen, 'exe' is altered to display the command before running it
# https://stackoverflow.com/questions/29436275/how-to-prompt-for-yes-or-no-in-bash
exe() { printf "\n\n"; echo "\$ ${@/eval/}"; "$@"; }
printf "\n"
[[ "$(read -e -p 'Confirm each configutation step? [y/N]> '; echo $REPLY)" == [Yy]* ]] && exe() { printf "\n\n"; echo "\$ ${@/eval/}"; read -e -p "Any key to continue..."; "$@"; } || echo Stopping

print_header() {
    printf "\n\n####################\n"
    printf "#\n"
    printf "# $1\n"
    printf "#\n"
    printf "####################\n\n"
}



####################
#
print_header "Get package manager and run update / upgrade"
#
####################

MANAGER=
which apt &> /dev/null && MANAGER=apt && DISTRO="Debian/Ubuntu"
which dnf &> /dev/null && MANAGER=dnf && DISTRO="RHEL/Fedora/CentOS"
which yum &> /dev/null && MANAGER=yum && DISTRO="RHEL/Fedora/CentOS"
which zypper &> /dev/null && MANAGER=zypper && DISTRO="SLES"

if [ -z $MANAGER ]; then
    echo "No manager available"
    return
else
    echo -e "\n\n>>>>>   A variant of '$DISTRO' was found."
    echo -e ">>>>>   Will use the '$MANAGER' package manager for setup.\n\n"
fi

### Check for and fix any outstanding broken installs
if [ "$MANAGER" == "apt" ]; then exe sudo apt --fix-broken install; fi

# Need to reboot script if pending
exe sudo $MANAGER update -y
exe sudo $MANAGER upgrade -y
exe sudo $MANAGER install ca-certificates -y   # to allow SSL-based applications to check for the authenticity of SSL connections
exe sudo $MANAGER autoremove -y

### Check for and fix any outstanding broken installs
if [ "$MANAGER" == "apt" ]; then exe sudo apt --fix-broken install; fi   # Do 'fix-broken' check before and after update/upgrade/autoremove

if [ -f /var/run/reboot-required ]; then
    echo "A reboot is required in order to proceed with the install." >&2
    echo "Please reboot and re-run this script to finish the install." >&2
    return
fi



####################
#
print_header "Check and install basic/small packages"
#
####################

### Console Tools ### Only install each if not already installed
which git &> /dev/null || exe sudo $MANAGER install git -y
which vim &> /dev/null || exe sudo $MANAGER install vim -y
which curl &> /dev/null || exe sudo $MANAGER install curl -y
which wget &> /dev/null || exe sudo $MANAGER install wget -y
which dpkg &> /dev/null || exe sudo $MANAGER install dpkg -y
which unzip &> /dev/null || exe sudo $MANAGER install unzip -y
which ifconfig &> /dev/null || exe sudo $MANAGER install net-tools -y
which mount.cifs &> /dev/null || exe sudo $MANAGER install cifs-utils -y
which neofetch &> /dev/null || exe sudo $MANAGER install neofetch -y
which fortune &> /dev/null || exe sudo $MANAGER install fortune-mod -y
which cowsay &> /dev/null || exe sudo $MANAGER install cowsay -y
which figlet &> /dev/null || exe sudo $MANAGER install figlet -y

# https://www.tecmint.com/cool-linux-commandline-tools-for-terminal/
# exe sudo $MANAGER install lolcat -y     # pipe text or figlet/cowsay for rainbow
# exe sudo $MANAGER install toilet -y     # pipe text or figlet/cowsay for coloured output
# exe sudo $MANAGER install boxes -y      # ascii boxes around text (cowsay variant)
# exe sudo $MANAGER install lolcat -y     # pipe figlet/cowsay for rainbow
# exe sudo $MANAGER install nms -y        # no more secrets
# exe sudo $MANAGER install chafa -y      # chafa
# exe sudo $MANAGER install cmatrix -y    # cmatrix
# exe sudo $MANAGER install trash-cli -y  # trash-cli
# exe sudo $MANAGER install wikit-cli -y  # wikit
# exe sudo $MANAGER install googler -y    # googler
# exe sudo $MANAGER install browsh -y     # browsh
# toilet -f mono9 -F metal $(date)
# while true; do echo "$(date '+%D %T' | toilet -f term -F border --gay)"; sleep 1; done
# Fork Bomb (do not ever run)   :   :(){ :|:& }:

####################
#
print_header "Setup figlet and bat"
#
####################

# Download and setup extended figlet fonts to /usr/share/figlet (requires elevation)
# http://www.jave.de/figlet/fonts.html
# http://www.figlet.org/examples.html
# Note that some of these fonts cannot show parts of the time output
# exe sudo bash -c '
# wget -P /usr/share/figlet/ "http://www.jave.de/figlet/figletfonts40.zip"
# unzip -d /usr/share/figlet/ /usr/share/figlet/figletfonts40.zip   # unzip to -d destination
# mv -f /usr/share/figlet/fonts/* /usr/share/figlet/   # move all fonts back into the main folder (force)
# rmdir /usr/share/figlet/fonts'
echo "# Download and setup figlet extended fonts"
[ ! -f /tmp/figletfonts40.zip ] && exe sudo wget -P /tmp/ "http://www.jave.de/figlet/figletfonts40.zip"
[ ! -f /usr/share/figlet/univers.flf ] && exe sudo unzip -od /usr/share/figlet/ /tmp/figletfonts40.zip   # unzip to destination -d, with overwrite -o
[ -d /usr/share/figlet/fonts ] && exe sudo mv -f /usr/share/figlet/fonts/* /usr/share/figlet/   # move all fonts back into the main folder (force)
[ -d /usr/share/figlet/fonts ] && exe sudo rmdir /usr/share/figlet/fonts

echo "# Download and setup 'bat' as a better replacement for 'cat'"
BAT=bat_0.15.4_amd64.deb
[ ! -f /tmp/$BAT ] && exe wget -P /tmp/ https://github.com/sharkdp/bat/releases/download/v0.15.4/$BAT   # 64-bit version
which bat &> /dev/null || exe sudo dpkg -i /tmp/$BAT   # if true, do nothing, else if false use dpkg
# sudo dpkg -r bat   # to remove after install
# Also installs as part of 'bacula-console-qt' but that is 48 MB for the entire backup tool



### Deprecate this, should go to more advanced installers
# Check if Peppermint
# https://launchpad.net/ubuntu/+source/brightside
# https://launchpad.net/ubuntu/+source/brightside/1.4.0-4.1ubuntu3/+build/11903300/
# BRIGHTSIDE=brightside_1.4.0-4.1ubuntu3_amd64.deb
# [ ! -f /tmp/$BRIGHTSIDE ] && exe wget -P /tmp/ https://launchpad.net/ubuntu/+source/brightside/1.4.0-4.1ubuntu3/+build/11903300/+files/$BRIGHTSIDE   # 64-bit version
# which brightside &> /dev/null || exe sudo dpkg -i /tmp/$BRIGHTSIDE   # if true, do nothing, else if false use dpkg



####################
#
print_header "Update .bashrc to load .custom in every interactive login session"
#
####################

# Note: have to be careful with this as if ".bash_profile" is ever created, it will take precedence  and .bashrc will
# *never* load. # Just one of the many crazy "features" of bash. To avoid this need to have logic to check.
# Check for .bash_profile => if it is zero-length, remove it. [[ ! - ~/.bash_profile ]]
# If .bash_profile is not zero length, load a line to dotsource .bashrc

if [ -z ~/.bash_profile ]; then   # or could use "! -s", -s "size greater than zero"
    echo "Deleting zero-size ~/.bash_profile"
    rm ~/.bash_profile &> /dev/null
else
    FIXBASHPROFILE='[ -f ~/.bashrc ] && . ~/.bashrc'
    grep -qxF '$FIXBASHPROFLIE' ~/.bash_profile || echo '$FIXBASHPROFILE' | sudo tee --append ~/.bash_profile
fi

# grep -qxF 'include "/configs/projectname.conf"' foo.bar || echo 'include "/configs/projectname.conf"' | sudo tee --append foo.bar
# -q be quiet, -x match the whole line, -F pattern is a plain string
# use "tee" instead of ">>", as ">>" will not permit updating protected files
# https://linux.die.net/man/1/grep
# https://stackoverflow.com/questions/3557037/appending-a-line-to-a-file-only-if-it-does-not-already-exist

# Remove any loader lines from .bashrc
cp ~/.bashrc /tmp/.bashrc_$(date +"%H_%M_%S")   # Backup .bashrc in case of issues
GETCUSTOM='[ ! -f ~/.custom ] && [[ $- == *"i"* ]] && curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > ~/.custom'
RUNCUSTOM='[ -f ~/.custom ] && [[ $- == *"i"* ]] && . ~/.custom'
grep -qxF '$GETCUSTOM' ~/.bashrc || echo $GETCUSTOM | sudo tee --append ~/.bashrc
grep -qxF '$RUNCUSTOM' ~/.bashrc || echo $RUNCUSTOM | sudo tee --append ~/.bashrc

# grep -v '^\[ \! -f ~\/.custom \] && \[\[.*$' ~/.bashrc >> ~/.bashrc.tmp1     # remove the curl loader line, error if try to output to same file
# grep -v '^\[ -f ~\/.custom \] && \[\[.*$' ~/.bashrc.tmp1 >> ~/.bashrc.tmp2   # remove the dotsource .custom line, error if try to output to same file
# sed 's/^\[ ! -f ~\/.custom \] && \[\[.*$//g' ~/.bashrc1 > ~/.bashrc1   # remove the curl loader line
# sed 's/^\[ -f ~\/.custom \] && \[\[.*$//g' ~/.bashrc2 > ~/.bashrc2   # remove the dotsource .custom line

# Then append loader lines to end of .bashrc (remove then re-add to ensure that they are at end of file)
exe mv ~/.custom ~/.custom.$(date +"%Y-%m-%d__%H-%M-%S")   # Need to 'mv' this to make way for the new downloaded file
exe curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > ~/.custom



####################
#
print_header "Common changes to .vimrc"
#
####################

# First, check if the item is already in the /etc/xxx file
# If there, do nothing, then check the ~ version, only add if not there

# update .vimrc
VIMLINE='color industry'
grep -qxF '$VIMLINE' ~/.vimrc || echo $VIMLINE | sudo tee --append ~/.vimrc
VIMLINE='" Disable tabs (to get a tab, Ctrl-V<Tab>), tab stops are 4 chars, indents are 4 chars'
grep -qxF '$VIMLINE' ~/.vimrc || echo $VIMLINE | sudo tee --append ~/.vimrc
VIMLINE='set expandtab tabstop=4 shiftwidth=4'
grep -qxF '$VIMLINE' ~/.vimrc || echo $VIMLINE | sudo tee --append ~/.vimrc
VIMLINE='" Allow saving of files as sudo when I forgot to start vim using sudo.'   # Variant for elevating Vim, not using for now
VIMLINE='" command W w !sudo tee % >/dev/nullset expandtab tabstop=4 shiftwidth=4'
grep -qxF '$VIMLINE' ~/.vimrc || echo $VIMLINE | sudo tee --append ~/.vimrc
VIMLINE="cnoremap w!! execute \'silent! write !sudo tee % >/dev/null\' <bar> edit"
grep -qxF '$VIMLINE' ~/.vimrc || echo $VIMLINE | sudo tee --append ~/.vimrc
VIMLINE='" Set F3 to toggle line numbers on/off'
grep -qxF '$VIMLINE' ~/.vimrc || echo $VIMLINE | sudo tee --append ~/.vimrc
VIMLINE='noremap <F3> :set invnumber<CR>'
grep -qxF '$VIMLINE' ~/.vimrc || echo $VIMLINE | sudo tee --append ~/.vimrc
VIMLINE='inoremap <F3> <C-O>:set invnumber<CR>'
grep -qxF '$VIMLINE' ~/.vimrc || echo $VIMLINE | sudo tee --append ~/.vimrc

# " To control the number of space characters that will be inserted when the tab key is pressed, set the 'tabstop' option. For example, to insert 4 spaces for a tab, use:
# set tabstop=4
# [boss@hp2: ~]$ cat .inputrc
# "\e[A": history-search-backward
# "\e[B": history-search-forward
# "\eOD": backward-word
# "\eOC": forward-word
# "\e[1~": beginning-of-line
# "\e[4~": end-of-line
# 
# "\C-i": menu-complete
# set show-all-if-ambiguous on



####################
#
print_header "Common changes to /etc/samba/smb.conf"
#
####################

# update /etc/samba/smb.conf
# Add an entry for the home folder on this environment so that is always available
# Restart the samba service



####################
#
print_header "Common changes to .inputrc"
#
####################

if [ ! -a ~/.inputrc ]; then echo '$include /etc/inputrc' > ~/.inputrc; fi
# Add shell-option to ~/.inputrc to enable case-insensitive tab completion, add this then start a new shell
echo 'set completion-ignore-case On' >> ~/.inputrc

# To Make the changes systemwide:
# add option to /etc/inputrc to enable case-insensitive tab completion for all users
# echo 'set completion-ignore-case On' >> /etc/inputrc
# you may have to use this instead if you are not a superuser:
# echo 'set completion-ignore-case On' | sudo tee -a /etc/inputrc

# testforline() { cat $1; cat $2; }
# testforline /etc/inputrc ~/.inputrc "\"\\e\[1\~\": beginning-of-line"
# check for the line in $1 and $2, and only add to $2 if not present in either

# update .inputrc
# allow the use of the Home/End keys
# "\e[1~": beginning-of-line
# "\e[4~": end-of-line
# allow the use of the Delete/Insert keys
# "\e[3~": delete-char
# "\e[2~": quoted-insert
# mappings for "page up" and "page down" to step to the beginning/end
# of the history
# "\e[5~": beginning-of-history
# "\e[6~": end-of-history
# alternate mappings for "page up" and "page down" to search the history
# "\e[5~": history-search-backward
# "\e[6~": history-search-forward
# mappings for Ctrl-left-arrow and Ctrl-right-arrow for word moving
# "\e[1;5C": forward-word
# "\e[1;5D": backward-word
# "\e[5C": forward-word
# "\e[5D": backward-word
# "\e\e[C": forward-word
# "\e\e[D": backward-word



####################
#
print_header "Common changes to /etc/sudoers"
#
####################

# update visudo (have to be very careful with this one, can break system)
# Test if system admin account is active, if not display warning
exe sudo cp /etc/sudoers /tmp/sudoers.$(date +"%Y-%m-%d__%H-%M-%S")   # save in /tmp so can edit
exe sudo sed 's/env_reset$/env_reset, timestamp_timeout=600/g' /etc/sudoers > /etc/sudoers.1
echo "In case editing of the sodoers file goes wrong, run:   pkexec visudo"
echo "Then, add the contents of the copy of /etc/sodoers backed up in /tmp in here and save"  
# On a modern Ubuntu system (and many other GNU/Linux distributions), fixing a corrupted sudoers file is actually quite easy, and doesn't require rebooting, using a live CD, or physical access to the machine. To do this via SSH, log in to the machine and run the command pkexec visudo. If you have physical access to the machine, SSH is unnecessary; just open a Terminal window and run that pkexec command. Assuming you (or some other user) are authorized to run programs as root with PolicyKit, you can enter your password, and then it will run visudo as root, and you can fix your /etc/sudoers:
#   pkexec visudo
# If you need to edit one of the configuration files in /etc/sudoers.d (which is uncommon in this situation, but possible), use:
#   pkexec visudo -f /etc/sudoers.d/filename.
# If you have a related situation where you have to perform additional system administration commands as root to fix the problem (also uncommon in this circumstance, but common in others), you can start an interactive root shell with pkexec bash. Generally speaking, any non-graphical command you'd run with sudo can be run with pkexec instead.
# (If there is more than one user account on the system authorized to run programs as root with PolicyKit, then for any of those actions, you'll be asked to select which one you want to use, before being asked for your password.)


####################
#
print_header "Update Locale"
#
####################

exe locale
# LANG=en_US.UTF-8
# LANGUAGE=
# LC_CTYPE="en_US.UTF-8"
# LC_NUMERIC=nl_NL.UTF-8
# LC_TIME=nl_NL.UTF-8
# LC_COLLATE="en_US.UTF-8"
# LC_MONETARY=nl_NL.UTF-8
# LC_MESSAGES="en_US.UTF-8"
# LC_PAPER=nl_NL.UTF-8
# LC_NAME=nl_NL.UTF-8
# LC_ADDRESS=nl_NL.UTF-8
# LC_TELEPHONE=nl_NL.UTF-8
# LC_MEASUREMENT=nl_NL.UTF-8
# LC_IDENTIFICATION=nl_NL.UTF-8
# LC_ALL=
echo ""
echo "Has to set LANG, LANGUAGE, and all LC variables (via LC_ALL)."
echo "# sudo update-locale LANG=en_GB.UTF-8"
echo "# sudo update-locale LANGUAGE=en_GB.UTF-8"
echo "# sudo localectl set-locale LANG=en_GB.UTF-8"
echo "# sudo update-locale LC_ALL=en_GB.UTF-8 LANGUAGE"
echo ""
COLUMNS=12;
printf "Select new Locale:\n\n";
select x in en_GB.UTF-8 en_US.UTF-8 nl_NL.UTF-8 "Do not change";
do
    if [ "$x" == "Do not change" ]; then break; fi
    exe sudo update-locale LANG=$x;
    exe sudo update-locale LANGUAGE=$x;
    exe sudo update-locale LC_ALL=$x;
    echo ""
    echo "New locale environment settings:"
    exe locale
    break;
done
echo ""
echo "If locale has changed, it will be applied only after a new login session starts."
echo ""

# Changing the default locale is a little different on Ubuntu compared to most Linux distros, these are the steps we needed to go through to get it changed:
# Add the locale to the list of 'supported locales', by editing /var/lib/locales/supported.d/local and add the following line:
# en_GB ISO-8859-1
# The above does not work for me on current Ubuntu
echo "Note en_GB.UTF-8 vs en_GB.ISO-8859-1, though this might be old/fixed now"
echo "https://blog.andrewbeacock.com/2007/01/how-to-change-your-default-locale-on.html"
echo "https://askubuntu.com/questions/89976/how-do-i-change-the-default-locale-in-ubuntu-server#89983"
echo "For Ubuntu, easiest option is to reconfigure locale, select en_GB.UTF-8 (or other):"
echo ""
echo "# sudo dpkg-reconfigure locales"
echo ""
echo "The new locale will not be applied until a new shell is started"
echo ""
read -e -p "Any key to continue ..."; "$@"



####################
#
print_header "Download and dotsource new .custom"
#
####################
read -e -p "Any key to continue ..."; "$@"

mv ~/.custom /tmp/.custom_$(date +"%H_%M_%S")   # Backup old .custom
if [ -f ./.custom ] && [[ $- == *"i"* ]]
then
    cp ./.custom ~/.custom   # If .custom is in current directory, use it and copy over
elseif [ ! -f ~/.custom ] && [[ $- == *"i"* ]]
then
    curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > ~/.custom   # Download new .custom
fi

[ -f ~/.custom ] && [[ $- == *"i"* ]] && . ~/.custom   # Dotsource new .custom

# [ -f ./.custom ] && [[ $- == *"i"* ]] && cp ./.custom ~/.custom   # If .custom is in current directory, use it and copy over
# [ ! -f ~/.custom ] && [[ $- == *"i"* ]] && curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > ~/.custom   # Download new .custom
# [ -f ~/.custom ] && [[ $- == *"i"* ]] && . ~/.custom   # Dotsource new .custom






# Test code: update getting new file if it is older than 3 days
# if [[ $(find "~/.custom" -mtime +3 -print) ]]; then
#     echo "File ~/.custom exists and is older than 3 days"
#     echo "Backing up old .custom then downloading and dot sourcing new version"
#     mv ~/.custom ~/.cutom.$(date +"%Y-%m-%d__%H-%M-%S")
#     curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > ~/.custom
#         . ~/.custom
#     else
#         . ~/.custom
#     fi
# else
#     echo "No .custom was present: downloading and dot sourcing a new .custom file"
#     curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > ~/.custom
#     . ~/.custom
# fi

# Alternative: Find if file is older than 3 days ...
# if [[ $(find "~/.custom" -mtime +100 -print) ]]; then
#   echo "File ~/.custom exists and is older than 3 days"
# fi

# Alternative: Find if file is older than 3 days using date to do the math ...
# Collect both times in seconds-since-the-epoch
#    hundred_days_ago=$(date -d 'now - 100 days' +%s)
#    file_time=$(date -r "$filename" +%s)

# Find using integer math:
# if (( file_time <= hundred_days_ago )); then
#   echo "$filename is older than 100 days"
# fi

