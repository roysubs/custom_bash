#!/bin/bash

# Must remember tools:
# Ctrl-V is paste, but not in a Terminal, must use Ctrl-Shift-V for that (or in Putty, Shift-Insert)
# https://askubuntu.com/questions/734647/right-click-to-paste-in-terminal?newreg=00145d6f91de4cc781cd0f4b76fccd2e

# To test if the shell is 'interactive' 
#    [[ $- == *"i"* ]] && [ -f ~/.custom ] && . ~/.custom 
# To manually copy .custom from the repository
#    curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > ~/.custom

# exe() function to display a command and then run it
# https://stackoverflow.com/questions/2853803/how-to-echo-shell-commands-as-they-are-executed
# By default, 'exe' will work unattended
exe() { printf "\n\n"; echo "\$ ${@/eval/}"; "$@"; }
# https://stackoverflow.com/questions/29436275/how-to-prompt-for-yes-or-no-in-bash
# If "y" is chosen, each 'exe' use will display the command before running it
[[ "$(read -e -p 'Step through each setup option? [y/N]> '; echo $REPLY)" == [Yy]* ]] && exe() { printf "\n\n"; echo "\$ ${@/eval/}"; read -p "Any key to continue..."; "$@"; }


####################
#
# Check and install basic packages
#
####################
# Define the package manager to use:
# CentOS/RHEL : yum / dnf
# Debian based: apt / snap
# if distro => sudo yum install else sudo apt install

### Console Tools ###
exe which git &> /dev/null || sudo apt install git -y
exe which vim &> /dev/null || sudo apt install vim -y
exe which curl &> /dev/null || sudo apt install curl -y
exe which wget &> /dev/null || sudo apt install wget -y
exe which dpkg &> /dev/null || sudo apt install dpkg -y
exe which ifconfig &> /dev/null || sudo apt install net-tools -y
exe which cifs &> /dev/null || sudo apt install cifs-utils -y
exe which neofetch &> /dev/null || sudo apt install neofetch -y
exe which fortune &> /dev/null || sudo apt install fortune-mod -y
exe which cowsay &> /dev/null || sudo apt install figlet -y
exe which figlet &> /dev/null || sudo apt install figlet -y
# exe sudo apt install curl wget dpkg net-tools git vim -y
# exe sudo apt install figlet cowsay fortune-mod -y   # All tiny so no big deal

# Download and setup figlet fonts to /usr/share/figlet (so requires sudo)
# http://www.jave.de/figlet/fonts.html
# http://www.figlet.org/examples.html
# Note that some of these fonts cannot show parts of the time output
exe sudo bash -c '
wget -P /usr/share/figlet/ "http://www.jave.de/figlet/figletfonts40.zip"
unzip -d /usr/share/figlet/ /usr/share/figlet/figletfonts40.zip   # unzip to -d destination
mv -f /usr/share/figlet/fonts/* /usr/share/figlet/   # move all fonts back into the main folder (force)
rmdir /usr/share/figlet/fonts'

# Download and setup 'bat' to replace 'cat'
[ ! -f /tmp/bat_0.15.4_amd64.deb ] && exe wget -P /tmp/ https://github.com/sharkdp/bat/releases/download/v0.15.4/bat_0.15.4_amd64.deb   # 64-bit version
exe sudo dpkg -i /tmp/bat_0.15.4_amd64.deb   # extracts 'bat' to /usr/bin
# sudo dpkg -r bat   # to remove after install
# Also installs as part of 'bacula-console-qt' but that is 48 MB for the entire backup tool

# Upgrade
exe sudo apt update -y
exe sudo apt upgrade -y
exe sudo apt autoremove -y



####################
#
# Update .bashrc to load .custom in every interactive login session
#
####################
# First remove any loader lines from .bashrc
cp ~/.bashrc ~/.bashrc_$(date +"%H_%M_%S")   # Backup .bashrc while testing
grep -v '^\[ \! -f ~\/.custom \] && \[\[.*$' ~/.bashrc >> ~/.bashrc.tmp1     # remove the curl loader line, error if try to output to same file
grep -v '^\[ -f ~\/.custom \] && \[\[.*$' ~/.bashrc.tmp1 >> ~/.bashrc.tmp2   # remove the dotsource .custom line, error if try to output to same file
mv .bashrc.tmp2 .bashrc
rm .bashrc.tmp1
# sed 's/^\[ ! -f ~\/.custom \] && \[\[.*$//g' ~/.bashrc1 > ~/.bashrc1   # remove the curl loader line
# sed 's/^\[ -f ~\/.custom \] && \[\[.*$//g' ~/.bashrc2 > ~/.bashrc2   # remove the dotsource .custom line

# Then append loader lines to end of .bashrc (remove then re-add to ensure that they are at end of file)
# echo '[ ! -f /usr/bin/curl ] && [[ $- == *"i"* ]] && sudo apt install curl -y' >> ~/.bashrc
echo '[ ! -f ~/.custom ] && [[ $- == *"i"* ]] && curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > ~/.custom' >> ~/.bashrc
echo '[ -f ~/.custom ] && [[ $- == *"i"* ]] && . ~/.custom' >> ~/.bashrc

exe mv ~/.custom ~/.custom.$(date +"%Y-%m-%d__%H-%M-%S")
exe curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > ~/.custom



####################
#
# Common changes to .vimrc, .inputrc, and /etc/sudoers (this is dangerous)
#
####################

# update .vimrc
echo "\" No tabs (Ctrl-V<Tab> to get a tab), tab stops are 4 chars, indents are 4 chars" >> ~/.vimrc
echo "set expandtab tabstop=4 shiftwidth=4" >> ~/.vimrc

# update .inputrc

# update visudo (very careful with this one, can break system)
exe sudo cp /etc/sudoers /etc/sudoers.$(date +"%Y-%m-%d__%H-%M-%S")
exe sudo sed 's/env_reset$/env_reset, timestamp_timeout=600/g' /etc/sudoers > /etc/sudoers.1
# On a modern Ubuntu system (and many other GNU/Linux distributions), fixing a corrupted sudoers file is actually quite easy, and doesn't require rebooting, using a live CD, or physical access to the machine. To do this via SSH, log in to the machine and run the command pkexec visudo. If you have physical access to the machine, SSH is unnecessary; just open a Terminal window and run that pkexec command. Assuming you (or some other user) are authorized to run programs as root with PolicyKit, you can enter your password, and then it will run visudo as root, and you can fix your /etc/sudoers:
#   pkexec visudo
# If you need to edit one of the configuration files in /etc/sudoers.d (which is uncommon in this situation, but possible), use:
#   pkexec visudo -f /etc/sudoers.d/filename.
# If you have a related situation where you have to perform additional system administration commands as root to fix the problem (also uncommon in this circumstance, but common in others), you can start an interactive root shell with pkexec bash. Generally speaking, any non-graphical command you'd run with sudo can be run with pkexec instead.
# (If there is more than one user account on the system authorized to run programs as root with PolicyKit, then for any of those actions, you'll be asked to select which one you want to use, before being asked for your password.)

# Test code on downloading file if older than 3 days
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

# Find if file is older than 3 days ...
# if [[ $(find "~/.custom" -mtime +100 -print) ]]; then
#   echo "File ~/.custom exists and is older than 3 days"
#
# fi

# Find if file is older than 3 days using date to do the math ...
# Collect both times in seconds-since-the-epoch
#    hundred_days_ago=$(date -d 'now - 100 days' +%s)
#    file_time=$(date -r "$filename" +%s)

# Find using integer math:
# if (( file_time <= hundred_days_ago )); then
#   echo "$filename is older than 100 days"
# fi



####################
#
# Update Locale
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
select x in en_GB.UTF-8 nl_NL.UTF-8 "Do not change";
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

####################
#
# Load .custom, download if required
#
####################
# Get the file from GitHub if not present (using curl)   # sudo apt install curl -y
# [ ! -f /usr/bin/curl ] && [[ $- == *"i"* ]] && sudo apt install curl -y   # Don't need this line, as must have curl already to do initial run

# MYPATH="`dirname \"$0\"`"
# [ -f $MYPATH/.custom ] %% cp $MYPATH/.custom ~/.custom


[ ! -f ~/.custom ] && [[ $- == *"i"* ]] && curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > ~/.custom
[ -f ~/.custom ] && [[ $- == *"i"* ]] && . ~/.custom

