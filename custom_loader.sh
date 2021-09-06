#!/bin/bash
####################
#
# Configure consistent bash environemt
#    https://github.com/roysubs/custom_bash/
#    https://raw.githubusercontent.com/roysubs/custom_bash/master/custom_loader.sh  =>  https://git.io/Jt0fZ  (using git.io)
#
# Can download custom_loader.sh before running with:
#    curl -L https://git.io/Jt0fZ > ~/custom_loader.sh
# To run unattended (all read -e -p will be ignored, script will run in full):
#    curl -L https://git.io/Jt0fZ | bash
# To run attended (prompts like read -e -p will be respected):
#    curl -L https://git.io/Jt0fZ > custom_loader.sh ; bash custom_loader.sh
#
####################

# Some WSL / Putty / Linux editing:
# To paste into a Terminal (in Linux, not via Putty), use Ctrl+Shift+V. In Putty, use  Shift+Insert.
# Also can use the middle mouse button to paste selected text in a Linux Terminal (i.e. if in a Hyper-V Ubuntu session)
# https://askubuntu.com/questions/734647/right-click-to-paste-in-terminal?newreg=00145d6f91de4cc781cd0f4b76fccd2e

# Useful Toolkits to look through:
# Nam Nguyen : https://github.com/gdbtek/ubuntu-cookbooks/blob/master/libraries/util.bash referenced from https://serverfault.com/questions/20747/find-last-time-update-was-performed-with-apt-get
# SSH keys setup : https://github.com/creynoldsaccenture/bash-toolkit

# Easiest comment structure using printf that I've found is:
# VARNAME="
# line1
#
# line3
# "
# printf "$VARNAME\n"
# Also note on echo: https://www.shellscript.sh/tips/echo/

####################
#
# Setup the print_header() and exe() functions
#
####################

TMP="/tmp/custom_bash"
mkdir $TMP &> /dev/null

### print_header() is used to create a simple section banner to output during execution
print_header() {
    printf "\n\n\n####################\n"
    printf "#\n"
    if [ "$1" != "" ]; then printf "# $1\n"; fi
    if [ "$2" != "" ]; then printf "# $2\n"; fi
    if [ "$3" != "" ]; then printf "# $3\n"; fi
    printf "#\n"
    printf "####################\n\n"
}

### exe() is used to display a command and then run that same command, so you can see what the script is about to run
# https://stackoverflow.com/questions/2853803/how-to-echo-shell-commands-as-they-are-executed
# By default, the following exe() will run run unattended, i.e. will show the command and then execute immediately
# Howeve, if "y" is chosen, the exe() function is altered to display the command, then display a pause before running
# the command so the user can control what runs and what does not.
# ToDo: modify this so that it displays a y/n after each command so can skip some and continue on to other commands.
# https://stackoverflow.com/questions/29436275/how-to-prompt-for-yes-or-no-in-bash
exe() { printf "\n"; echo "\$ ${@/eval/}"; "$@"; }



####################
#
print_header "Start common cross-distro configuration steps" "and setup common tools (.custom / .vimrc / .inputrc)" "without creating complex changes in .bashrc etc"
#
####################

[ -f /etc/lsb-release ] && RELEASE="$(cat /etc/lsb-release | grep DESCRIPTION | sed 's/^.*=//g' | sed 's/\"//g')"   # Debian / Ubuntu and variants
[ -f /etc/redhat-release ] && RELEASE=$(cat /etc/redhat-release);   # RedHat / Fedora / CentOS, contains "generic release" information
[ -f /etc/os-release ] && RELEASE="$(cat /etc/os-release | grep ^NAME= | sed 's/^.*=//g' | sed 's/\"//g')"   # This now contains the release name
printf "OS : $RELEASE"
if grep -qEi "WSL2" /proc/version &> /dev/null ; then printf " (Running in WSL2)"   # Ubuntu now lists WSL version in /proc/version
elif grep -qEi "Microsoft" /proc/version &> /dev/null ; then printf " (Running in WSL)"   # Other distros don't list WSL version but do have "Microsoft" in the string
fi
printf "\n\n"
# Dotsourcing custom_loader.sh is required to update the running environment, but causes
# problems with exiting scripts, since exit 0 / exit 1 will quit the bash shell since that
# is what you are running when you are dotsourcing. e.g. This will close the whole shell:
# if [ $(pwd) == $HOME ]; then echo "custom_loader.sh should not be run from \$HOME"; exit 0; fi 
# So, instead, we'll just notify the user and let them take action:
# echo "\$BASH_SOURCE = $BASH_SOURCE"   # $BASH_SOURCE gets the source being used, always use this when dotsourcing
if [ $(pwd) == $HOME ]; then echo "It is not advised to run custom_loader.sh from \$HOME"; read -e -p "Press 'Ctrl-C' to exit script..."; fi
if [ -f "$HOME/custom_loader.sh" ]; then read -e -p "A copy of custom_loader.sh cannot be in \$HOME = $HOME"; read -e -p "Press 'Ctrl-C' to exit script..."; fi
if [ ! -f "./custom_loader.sh" ]; then read -e -p "Script should only be run when currently in same folder as custom_loader.sh location. 'cd' to the correct folder and rerun."; read -e -p "Press 'Ctrl-C' to exit script..."; fi
# if the path starts "/" then it is absolute
# if the path starts with "~/" or "./" or just the name of the subfolder then it is not absolute
# if the path is not absolute, add $(pwd) to get the full path

### Note that read -e -p will be ignored when running via curl, so this is actually ok since it is ok to
### run from internet even when in $HOME

# Array example, splitting a path:
# pwd_arr=($(dirname \"$0\" | tr "/", "\n"))     # split path script is running from into array
# for i in "${pwd_arr[@]}"; do echo $i; done   # loop through elements of the array
# pwd_last= ${pwd_arr[-1]}                       # get the last element of the array

echo "Default is to skip confirmation, but may require a sudo password"
[[ "$(read -e -p 'Confirm each configutation step? [y/N]> '; echo $REPLY)" == [Yy]* ]] && exe() { printf "\n\n"; echo "\$ ${@/eval/}"; read -e -p "Press 'Enter' to continue..."; "$@"; } 



####################
#
print_header "Find package manager and run package/distro updates"
#
####################

MANAGER=
which apt    &> /dev/null && MANAGER=apt    && DISTRO="Debian/Ubuntu"
which dnf    &> /dev/null && MANAGER=dnf    && DISTRO="RHEL/Fedora/CentOS"
which yum    &> /dev/null && MANAGER=yum    && DISTRO="RHEL/Fedora/CentOS"   # $MANAGER=yum if both dnf and yum are present
which zypper &> /dev/null && MANAGER=zypper && DISTRO="SLES"
which apk    &> /dev/null && MANAGER=apk    && DISTRO="Alpine"
echo -e "\n\n>>>>>   A variant of '$DISTRO' was found."
echo -e ">>>>>   Therefore, will use the '$MANAGER' package manager for setup tasks."
printf "> sudo $MANAGER update -y\n> sudo $MANAGER upgrade -y\n> sudo $MANAGER dist-upgrade -y\n> sudo $MANAGER install ca-certificates -y\n> sudo $MANAGER autoremove -y\n"
if [ "$MANAGER" == "apt" ]; then exe sudo apt --fix-broken install; fi   # Check and fix any broken installs, do before and after updates
# Note 'install ca-certificates' to allow SSL-based applications to check for the authenticity of SSL connections

function getLastAptGetUpdate()
{
    local aptDate="$(stat -c %Y '/var/cache/apt')"
    local nowDate="$(date +'%s')"
    echo $((nowDate - aptDate))
}

function runAptGetUpdate()
{
    local updateInterval="${1}"
    local lastAptGetUpdate="$(getLastAptGetUpdate)"

    if [[ "$(isEmptyString "${updateInterval}")" = 'true' ]]
    then
        # Default To 24 hours
        updateInterval="$((24 * 60 * 60))"
    fi

    if [[ "${lastAptGetUpdate}" -gt "${updateInterval}" ]]
    then
        echo -e "apt-get update"
        exe sudo $MANAGER update -y
        exe sudo $MANAGER upgrade -y
        exe sudo $MANAGER dist-upgrade -y
        exe sudo $MANAGER install ca-certificates -y
        exe sudo $MANAGER autoremove -y
        which apt-file &> /dev/null && sudo apt-file update   # update apt-file cache but only if apt-file is installed
        if [ "$MANAGER" == "apt" ]; then exe sudo apt --fix-broken install; fi   # Check and fix any broken installs, do before and after updates
        apt-get update -m
    else
        local lastUpdate="$(date -u -d @"${lastAptGetUpdate}" +'%-Hh %-Mm %-Ss')"

        echo -e "\nSkip apt-get update because its last run was '${lastUpdate}' ago"
    fi
}

if [ -f /var/run/reboot-required ]; then
    echo "" >&2
    echo "A reboot is required (/var/run/reboot-required is present)." >&2
    echo "If running in WSL, can shutdown with:   wsl.exe --terminate \$WSL_DISTRO_NAME" >&2
    echo "Re-run this script after reboot to finish the install." >&2
    return
fi



####################
#
print_header "Check and install small/essential packages"
#
####################

# 
$INSTALL="sudo $MANAGER install"
if [ "$MANAGER" = "apk" ]; then $INSTALL="$MANAGER add"; fi
# Only install each if not already installed
check_and_install() { which $1 &> /dev/null && printf "\n$1 is already installed" || exe $INSTALL $2 -y; }
# which dos2unix &> /dev/null || exe sudo $MANAGER install dos2unix -y

check_and_install dpkg dpkg     # 'Debian package' is the low level package management from Debian ('apt' is a higher level tool)
check_and_install apt apt-file  # find which package includes a specific file, or to list all files included in a package on remote repositories.
check_and_install git git
check_and_install vim vim
check_and_install curl curl
check_and_install wget wget
check_and_install dos2unix dos2unix
check_and_install mount.cifs mount.cifs
check_and_install neofetch neofetch
# check_and_install screenfetch screenfetch   # Same as neofetch
check_and_install fortune fortune
check_and_install cowsay cowsay
check_and_install tree tree
check_and_install byobu byobu    # Also installs 'tmux' as a dependency
check_and_install zip zip
check_and_install unzip unzip
check_and_install lr lr          # lr (list recursively), all files under current location, also: tree . -fail / tree . -dfail
# check_and_install bat bat      # 'cat' clone with syntax highlighting and git integration, but downloads old version, so install manually
check_and_install ifconfig net-tools   # Package name is different from the 'ifconfig' tool that is wanted
check_and_install 7z p7zip-full        # Package name is different from the '7z' tool that is wanted
# which ifconfig &> /dev/null && printf "\np7zip-full is already installed" || exe sudo $MANAGER install net-tools -y
# which 7z &> /dev/null && printf "\np7zip-full is already installed" || exe sudo $MANAGER install p7zip-full -y

check_and_install figlet figlet
# This was odd, Ubuntu 20.04 only had this as a snap package out of the box, only after full update could it see the normal package
which figlet &> /dev/null || exe sudo snap install figlet -y

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
# bashtop 
# bpytop : https://www.osradar.com/install-bpytop-on-ubuntu-debian-a-terminal-monitoring-tool/
# Very good guide of random tips for Linux to review
# https://www.tecmint.com/51-useful-lesser-known-commands-for-linux-users/
# sudo apt install python3-pip ; # pip3 install bpytop

### AsciiAquarium
#apt-get install libcurses-perl
# cd /tmp 
# wget http://search.cpan.org/CPAN/authors/id/K/KB/KBAUCOM/Term-Animation-2.4.tar.gz
# tar -zxvf Term-Animation-2.4.tar.gz
# cd Term-Animation-2.4/
# perl Makefile.PL &&  make &&   make test
# make install
# Now Download and Install ASCIIquarium.
# cd /tmp
# wget http://www.robobunny.com/projects/asciiquarium/asciiquarium.tar.gz
# tar -zxvf asciiquarium.tar.gz
# cd asciiquarium_1.1/
# cp asciiquarium /usr/local/bin
# chmod 0755 /usr/local/bin/asciiquarium

# Removed this installer, it's for Peppermint UI to havve hot corners.
# This should not be here - move to advanced installers
# Check if Peppermint
# https://launchpad.net/ubuntu/+source/brightside
# https://launchpad.net/ubuntu/+source/brightside/1.4.0-4.1ubuntu3/+build/11903300/
# BRIGHTSIDE=brightside_1.4.0-4.1ubuntu3_amd64.deb
# [ ! -f /tmp/$BRIGHTSIDE ] && exe wget -P /tmp/ https://launchpad.net/ubuntu/+source/brightside/1.4.0-4.1ubuntu3/+build/11903300/+files/$BRIGHTSIDE   # 64-bit version
# which brightside &> /dev/null || exe sudo dpkg -i /tmp/$BRIGHTSIDE   # if true, do nothing, else if false use dpkg


####################
#
print_header "Download extended fonts for 'figlet'"
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
# [ ! -f /tmp/figletfonts40.zip ] && exe sudo wget -P /tmp/ "http://www.jave.de/figlet/figletfonts40.zip"
# [ ! -f /usr/share/figlet/univers.flf ] && exe sudo unzip -od /usr/share/figlet/ /tmp/figletfonts40.zip   # unzip to destination -d, with overwrite -o
# [ -d /usr/share/figlet/fonts ] && exe sudo mv -f /usr/share/figlet/fonts/* /usr/share/figlet/   # move all fonts back into the main folder (force)
# [ -d /usr/share/figlet/fonts ] && exe sudo rmdir /usr/share/figlet/fonts

if [ ! -f /usr/share/figlet/univers.flf ]; then   # Use existence of this one font file to decide
    sudo mkdir -p /usr/share/figlet/fonts
    [ ! -f /tmp/figletfonts40.zip ] && exe sudo wget -P /tmp/ "http://www.jave.de/figlet/figletfonts40.zip"
    [ -f /tmp/figletfonts40.zip ]   && exe sudo unzip -od /usr/share/figlet/ /tmp/figletfonts40.zip  # unzip to destination -d, with overwrite -o
    [ -d /usr/share/figlet/fonts ]  && exe sudo mv -f /usr/share/figlet/fonts/* /usr/share/figlet/   # move all fonts back into the main folder (force)
    [ -d /usr/share/figlet/fonts ]  && exe sudo rmdir /usr/share/figlet/fonts
    [ -f /tmp/figletfonts40.zip ]   && exe sudo rm /tmp/figletfonts40.zip                            # cleanup
fi


# [ ! $(which bat) ]   will resolve 'which bat' and if empty will trigger the 'if-fi' condition
if [ ! $(which bat) ]; then
    ####################
    #
    print_header "Download 'bat' (syntax highlighted replacement for 'cat') manually to a known working version"
    #
    ####################
    echo "# Download and setup 'bat' and alias 'cat' to use 'bat' instead (same as 'cat' but with syntax highlighting)"
    echo "# Check here for latest updates: https://github.com/sharkdp/bat/releases"
    REL=v0.18.0
    BAT=bat_0.18.0_amd64.deb
    [ ! -f /tmp/$BAT ] && exe wget -P /tmp/ https://github.com/sharkdp/bat/releases/download/$REL/$BAT   # 64-bit version
    which bat &> /dev/null || exe sudo dpkg -i /tmp/$BAT   # if true, do nothing, else if false use dpkg
    # sudo dpkg -r bat   # to remove after install
    # Also installs as part of 'bacula-console-qt' but that is 48 MB for the entire backup tool  
fi



####################
#
print_header "Update .bashrc so that it will load .custom during any interactive login sessions"
#
####################

# Note how the grep line logically resolves below as it is not always obvious: (( grep for $thing in $file )) OR (( echo $thing | tee --append $thing ))
# i.e. $expression1 || $expression2    where    $expression2 = echo $thing | tee --append $thing
# "tee --append" is better than ">>" in general as it also permits updating protected files.
# e.g. echo "thing" >> ~/.bashrc      # fails as cannot update protected file.
#      sudo echo "thing" >> ~/.bashrc # also fails as the 'echo' is elevated, but '>>' is not(!)
# But: echo "thing" | sudo tee --append /etc/bashrc   # works as the 'tee' operation is elevated correctly.
# https://linux.die.net/man/1/grep
# https://stackoverflow.com/questions/3557037/appending-a-line-to-a-file-only-if-it-does-not-already-exist
# Could alternatively use sed for everything:
# https://unix.stackexchange.com/questions/295274/grep-to-find-the-correct-line-sed-to-change-the-contents-then-putting-it-back

# Backup ~/.custom
if [ -f ~/.custom ]; then
    echo "Create Backup : $TMP/.custom_$(date +"%Y-%m-%d__%H-%M-%S").sh"
    cp ~/.custom $TMP/.custom_$(date +"%Y-%m-%d__%H-%M-%S").sh   # Need to rename this to make way for the new downloaded file
fi
if [ -f ~/.bashrc ]; then
    echo "Create Backup : $TMP/.bashrc_$(date +"%Y-%m-%d__%H_%M_%S").sh"
    exe cp ~/.bashrc $TMP/.bashrc_$(date +"%Y-%m-%d__%H_%M_%S").sh   # Backup .bashrc in case of issues
fi
HEADERCUSTOM='# Dotsource .custom (download from GitHub if required)'
GETCUSTOM='[ ! -f ~/.custom ] && [[ $- == *"i"* ]] && curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > ~/.custom'
RUNCUSTOM='[ -f ~/.custom ] && [[ $- == *"i"* ]] && source ~/.custom'

# Remove lines to trigger .custom from end of .bashrc (-v show everything except, -x full line match, -F fixed string / no regexp)
# https://stackoverflow.com/questions/28647088/grep-for-a-line-in-a-file-then-remove-the-line

# Remove our .custom from the end of .bashrc (-v show everything except our match, -q silent show no output, -x full line match, -F fixed string / no regexp)
rc=~/.bashrc
rctmp=$TMP/.bashrc_$(date +"%Y-%m-%d__%H-%M-%S").tmp
grep -vxF "$HEADERCUSTOM" $rc > $rctmp.1 && cp $rctmp.1 $rc   # grep to a .tmp file, then copy it back to the original
grep -vxF "$GETCUSTOM" $rc > $rctmp.2 && cp $rctmp.2 $rc
grep -vxF "$RUNCUSTOM" $rc > $rctmp.3 && cp $rctmp.3 $rc
# If doing this with a system file (e.g. /etc/bashrc), just sudo the 'cp' part. i.e. grep <> /etc/bashrc > $rctmp && sudo cp /etc/bashrc

# After removing our lines, make sure no empty lines at end of file, except for one required before our lines
# Remove trailing whitepsace: https://stackoverflow.com/questions/4438306/how-to-remove-trailing-whitespaces-with-sed
sed -i 's/[ \t]*$//' ~/.bashrc     # -i is in place, [ \t] applies to any number of spaces and tabs before the end of the file "*$"
# Removes also any empty lines from the end of a file. https://unix.stackexchange.com/questions/81685/how-to-remove-multiple-newlines-at-eof/81687#81687
sed -i -e :a -e '/^\n*$/{$d;N;};/\n$/ba' ~/.bashrc
echo "" | tee --append ~/.bashrc   # Finally, add an empty line back in as a separator before our .custom call lines

# Add lines to trigger .custom to end of .bashrc (-q silent show no output, -x full line match, -F fixed string / no regexp)
echo $HEADERCUSTOM | tee --append ~/.bashrc
echo $GETCUSTOM | tee --append ~/.bashrc
echo $RUNCUSTOM | tee --append ~/.bashrc

### .bash_profile checks ###
# In practice, the usage of the .bash_profile file is the same as the usage for the .bashrc file.
# Most .bash_profile files call the .bashrc file for the user by default. Then why do we have two
# different configuration files? Why can’t we do everything using a single file?
# Well, the short answer is freedom and convenience. The longer answer is as follows: Suppose, you
# wish to run a system diagnostic every time you log in to your Linux system. You can edit the
# configuration file to print the results or save it in a file. But you only wish to see it at
# startup and not every time you open your terminal. This is when you need to use the .bash_profile
# file instead of .bashrc
# Also: https://www.golinuxcloud.com/bashrc-vs-bash-profile/
# If ".bash_profile" is ever created, it takes precedence over .bashrc, *even* if it is empty, and
# so .bashrc will NOT load in this case (just one of the crazy bash rules).
# To avoid this need to check for its existence and whether it has contents.
# - If .bash_profile exists and is zero-length, simply remove it.
# - If .bash_profile exists is not zero length, then create a line to dotsource .bashrc so that the above .custom will also be called.
# - If .bash_profile exists and .bashrc does NOT exist, then add .custom lines to .bash_profile

if [ ! -s ~/.bash_profile ]; then   # This is specifically only if .bash_profile is zero-length (-z for zero-length is not available on some OS)
    echo "Deleting zero-size ~/.bash_profile to prevent overriding .bashrc"
    rm ~/.bash_profile &> /dev/null
fi

if [ -s ~/.bash_profile ]; then   # Only do this if a greater than zero size file exists
    echo "Existing ~/.bash_profile is not empty, so ensure line in ~/.bash_profile loads ~/.bashrc (and so then runs ~/.custom)"
    FIXBASHPROFILE='[ -f ~/.bashrc ] && . ~/.bashrc'
    grep -qxF "$FIXBASHPROFLIE" ~/.bash_profile || echo "$FIXBASHPROFILE" | tee --append ~/.bash_profile
fi

if [ -s ~/.bash_profile ] && [ ! ~/.bashrc ]; then   # Only do this if a greater than zero size file exists
    echo "Existing ~/.bash_profile is not empty, but ~/.bashrc does not exist. Ensure lines are in ~/.bash_profile to load ~/.custom"
    grep -qxF "$HEADERCUSTOM" ~/.bash_profile || echo "$HEADERCUSTOM" | tee --append ~/.bash_profile
    grep -qxF "$GETCUSTOM" ~/.bash_profile || echo "$GETCUSTOM" | tee --append ~/.bash_profile
    grep -qxF "$RUNCUSTOM" ~/.bash_profile || echo "$RUNCUSTOM" | tee --append ~/.bash_profile
fi



####################
#
print_header "Copy ./.custom (if present) to ~/.custom, *or* download latest .custom to ~/.custom"
#
####################

echo "If ./.custom exists here and this session is an interactive login and pwd is not "\$HOME", then copy it to the home directory"
if [ -f ./.custom ] && [[ $- == *"i"* ]] && [[ ! $(pwd) == $HOME ]]; then
    echo "[ -f ./.custom ] && [[ \$- == *"i"* ]] && [[ ! $(pwd) == \$HOME ]] = TRUE"
    cp ./.custom ~/.custom   # This will overwrite the copy in $HOME
fi

echo "If ~/.custom still does not exist, then get it from Github"
if [ ! -f ~/.custom ] && [[ $- == *"i"* ]]; then
    echo "[ ! -f ~/.custom ] && [[ $- == *"i"* ]] = TRUE"
    curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > ~/.custom   # Download new .custom
fi

# read -e -p "Press 'Enter' to continue ..."; "$@"


####################
#
print_header "Common changes to .vimrc"
#
####################
# read -e -p "Press 'Enter' to continue ..."; "$@"

# https://topic.alibabacloud.com/article/ubuntu-system-vimrc-configuration-file_3_12_513382.html
# https://linuxhint.com/vimrc_tutorial/

# grep -qxF "$VIMLINE" ~/.vimrc || echo $VIMLINE | sudo tee --append ~/.vimrc
#    -q, --quiet, --silent   Quiet; do not write anything to standard output.  Exit immediately with zero status if any match is found, even if an error was  detected. Also see the -s or --no-messages option.
#    -x, --line-regexp   Select  only  those  matches that exactly match the whole line (i.e. like parenthesizing the pattern and then surrounding it with ^ and $ for regex).
#    -F, --fixed-strings   Interpret PATTERNS as fixed strings, not regular expressions).
#
# First, check if the full line is already in the file. If there, do nothing, then check the ~ version, only add if not there
# ToDo: extend this to check both /etc/vimrc and then ~/.vimrc, possibly a function with parameteres $1=(line to check or add), $2=(/etc/xxx admin file), $3=(~/.vimrc user file)
#
# Note that cannot >> back to the same file being read, so use "| sudo tee --append ~/.vimrc"

ADDLINE='" Set simple syntax highlighting that is more readable than the default (also   :set koehler)'
grep -qxF "$ADDLINE" ~/.vimrc || echo $ADDLINE | tee --append ~/.vimrc
ADDLINE='color industry'
grep -qxF "$ADDLINE" ~/.vimrc || echo $ADDLINE | tee --append ~/.vimrc
ADDLINE='" Disable tabs (to get a tab, Ctrl-V<Tab>), tab stops are 4 chars, indents are 4 chars'
grep -qxF "$ADDLINE" ~/.vimrc || echo $ADDLINE | tee --append ~/.vimrc
ADDLINE='set expandtab tabstop=4 shiftwidth=4'
grep -qxF "$ADDLINE" ~/.vimrc || echo $ADDLINE | tee --append ~/.vimrc
ADDLINE='" Allow saving of files as sudo when I forgot to start vim using sudo.'
grep -qxF "$ADDLINE" ~/.vimrc || echo $ADDLINE | tee --append ~/.vimrc
ADDLINE="cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit"
grep -qxF "$ADDLINE" ~/.vimrc || echo $ADDLINE | tee --append ~/.vimrc
ADDLINE='" Set F3 to toggle line numbers on/off'
grep -qxF "$ADDLINE" ~/.vimrc || echo $ADDLINE | tee --append ~/.vimrc
ADDLINE='noremap <F3> :set invnumber<CR>'
grep -qxF "$ADDLINE" ~/.vimrc || echo $ADDLINE | tee --append ~/.vimrc
ADDLINE='inoremap <F3> <C-O>:set invnumber<CR>'
grep -qxF "$ADDLINE" ~/.vimrc || echo $ADDLINE | tee --append ~/.vimrc

# Alternative auto-elevate vim
# ADDLINE='" command W w !sudo tee % >/dev/nullset expandtab tabstop=4 shiftwidth=4'




####################
#
print_header "Common changes to /etc/samba/smb.conf"
#
####################

# ToDo: add generic changes to make sure that Samba will work, including some default sharing
# Add an entry for the home folder on this environment so that is always available
# Restart the samba service



####################
#
print_header "Common changes to .inputrc"
#
####################

# if [ ! -a ~/.inputrc ]; then echo '$include /etc/inputrc' > ~/.inputrc; fi
if [ ! -f ~/.inputrc ]; then touch ~/.inputrc; fi
# Add shell-option to ~/.inputrc to enable case-insensitive tab completion, add this then start a new shell
# echo  >> ~/.inputrc

INPUTRC='$include /etc/inputrc'   # Set Tab completion to be non-case sensitive
grep -qxF "$INPUTRC" ~/.inputrc || echo $INPUTRC | sudo tee --append ~/.inputrc
INPUTRC='# Set tab completion for 'cd' to be non-case sensitive'
grep -qxF "$INPUTRC" ~/.inputrc || echo $INPUTRC | sudo tee --append ~/.inputrc
INPUTRC='set completion-ignore-case On'
grep -qxF "$INPUTRC" ~/.inputrc || echo $INPUTRC | sudo tee --append ~/.inputrc

# https://superuser.com/questions/241187/how-do-i-reload-inputrc
# https://relentlesscoding.com/posts/readline-transformation/
# https://www.topbug.net/blog/2017/07/31/inputrc-for-humans/
#
# $include /etc/inputrc
# "\C-p":history-search-backward
# "\C-n":history-search-forward
# 
# set colored-stats On
# set completion-ignore-case On
# set completion-prefix-display-length 3
# set mark-symlinked-directories On
# set show-all-if-ambiguous On
# set show-all-if-unmodified On
# set visible-stats On

# "\e[A": history-search-backward
# "\e[B": history-search-forward
# "\eOD": backward-word
# "\eOC": forward-word
# "\e[1~": beginning-of-line
# "\e[4~": end-of-line
# 
# "\C-i": menu-complete
# set show-all-if-ambiguous on

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

# Rough working:
# Seems that /etc/inputrc is not loaded by default, so have to use "$include /etc/inputrc"
# testforline() { cat $1; cat $2; }
# testforline /etc/inputrc ~/.inputrc "\"\\e\[1\~\": beginning-of-line"
# check for the line in $1 and $2, and only add to $2 if not present in either



####################
#
print_header "Common changes to /etc/sudoers"
#
####################

echo "ToDo: This part is tricky to automate as mistakes in /etc/sudoers can make a system unbootable."
echo "There is a fix for this in some distros, you can run:   pkexec visudo"
echo "Then, fix any issues, or add contents from a backed up /etc/sudoers"
echo ""
echo "The goal is to add a 10 hr timeout for sudo passwords to be re-entered as it gets annoying to"
echo "have to continually retype this on a home system (i.e. not advised on a production system)."
echo "See all options with 'man sudoers'. To manually make this change:"
echo ""
echo "sudo visudo   # To open /etc/sudoers safely (will not permit saving unless syntax is correct)"
echo "Add ',timestamp_timeout=600' to the 'Defaults env_reset' line, or just ad an extra Defaults line:"
echo "Defaults    timestamp_timeout=600   # For 600 minutes, or set to whatever you prefer"
echo ""
echo "Automating this change will look something like the following, but do not do this as it will"
echo "break /etc/sudoers in this format (so don't do this!):"
echo "   # sed 's/env_reset$/env_reset,timestamp_timeout=600/g' /etc/sudoers \| sudo tee /etc/sudoers"
echo ""

echo "Create Backup : $TMP/sudoers_$(date +"%Y-%m-%d__%H-%M-%S").sh"
sudo cp /etc/sudoers $TMP/sudoers_$(date +"%Y-%m-%d__%H-%M-%S").sh

# timestamp_timeout
#     Number of minutes that can elapse before sudo will ask for a passwd again.  The timeout may include a fractional component if
#     minute granularity is insufficient, for example 2.5.  The default is 15.  Set this to 0 to always prompt for a password.  If set to
#     a value less than 0 the user's time stamp will not expire until the system is rebooted.  This can be used to allow users to create
#     or delete their own time stamps via “sudo -v” and “sudo -k” respectively.
# A note on the use of env_reset (Ubuntu and CentOS both use it, but CentOS restricts it with env_keep from what I can see)
# https://unixhealthcheck.com/blog?id=363

# Programmatically automate changes to sudoers. There are guides for this.

# Nornally, should only use visudo to update /etc/sudoers, so have to be very careful with this one, as can break system
# However, on Ubuntu and many modern distros, fixing a corrupted sudoers file is actually quite easy, and doesn't require
# rebooting or a live CD. To do this via SSH, log in to the machine and run the command pkexec visudo. If you have physical
# access to the machine, SSH is unnecessary; just open a Terminal window and run that pkexec command. Assuming you (or some
# other user) are authorized to run programs as root with PolicyKit, you can enter your password, and then it will run
# visudo as root, and you can fix your /etc/sudoers by running:   pkexec visudo
# If you need to edit one of the configuration files in /etc/sudoers.d (which is uncommon in this situation, but possible), use:
#     pkexec visudo -f /etc/sudoers.d/filename.
# If you have a related situation where you have to perform additional system administration commands as root to fix the problem
# (also uncommon in this circumstance, but common in others), you can start an interactive root shell with pkexec bash. Generally
# speaking, any non-graphical command you'd run with sudo can be run with pkexec instead.
# (If there is more than one user account on the system authorized to run programs as root with PolicyKit, then for any of those
# actions, you'll be asked to select which one you want to use, before being asked for your password.)

# First, check if this system has a line ending "env_reset" (seems to normally be there in all Ubuntu / CentOs systems)
# SUDOTMP="/tmp/sudoers.$(date +"%Y-%m-%d__%H-%M-%S")"
# sudo cp /etc/sudoers $SUDOTMP

# Require "sudo tee" as /etc/sudoers does not even have 'read' permissiong so "> sudoers.1" would not work
# Can also use "--append" to tee, useful to adding to end of a file, but in this case we do not need
# Add option to view the sudoers file in case it is broken to offer to copy the backup back in



####################
#
print_header "Configure Locale"
#
####################

# exe locale
# Following are usual defaults
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
echo "To change locale for language and keyboard settings (e.g. GB, FR, NL, etc)"
echo "we have to set LANG, LANGUAGE, and all LC variables (via LC_ALL):"
echo '   # sudo update-locale LANG="en_GB.UTF-8" LANGUAGE="en_GB"   # for GB'
echo '   # sudo update-locale LANG="nl_NL.UTF-8" LANGUAGE="nl_NL"   # for NL'
echo '   # sudo update-locale LANG="fr_FR.UTF-8" LANGUAGE="fr_FR"   # for FR'
echo "   # sudo localectl set-locale LANG=en_GB.UTF-8"
echo "   # sudo update-locale LC_ALL=en_GB.UTF-8 LANGUAGE"
echo ""
echo "For Ubuntu, just need to run the folloing and choose the UTF-8 option:"
echo "   # sudo dpkg-reconfigure locales"
echo ""
echo "Run 'locale' to view the current settings before changing."

# Commenting this section out since will be ignored when downloading from github with: curl <script> | bash
#
# COLUMNS=12;
# printf "Select new Locale:\n\n";
# select x in en_GB.UTF-8 en_US.UTF-8 nl_NL.UTF-8 "Do not change";
# do
#     if [ "$x" == "Do not change" ]; then break; fi
#     exe sudo update-locale LANG=$x;
#     exe sudo update-locale LANGUAGE=$x;
#     exe sudo update-locale LC_ALL=$x;
#     echo ""
#     echo "New locale environment settings:"
#     exe locale
#     break;
# done
# echo ""
# echo "If locale has changed, it will be applied only after a new login session starts."
# echo ""

# Changing the default locale is a little different on Ubuntu compared to most Linux distros, these are the steps we needed to go through to get it changed:
# Add the locale to the list of 'supported locales', by editing /var/lib/locales/supported.d/local and add the following line:
# en_GB ISO-8859-1
# The above does not work for me on current Ubuntu
# echo "Note en_GB.UTF-8 vs en_GB.ISO-8859-1, though this might be old/fixed now"
# echo "https://blog.andrewbeacock.com/2007/01/how-to-change-your-default-locale-on.html"
# echo "https://askubuntu.com/questions/89976/how-do-i-change-the-default-locale-in-ubuntu-server#89983"
# echo "For Ubuntu, easiest option is to reconfigure locale, select en_GB.UTF-8 (or other):"
# echo ""
# echo "# sudo dpkg-reconfigure locales"
# echo ""
# echo "The new locale will not be applied until a new shell is started"
# echo ""
# read -e -p "Press 'Enter' to continue ..."; "$@"
# echo "Try regenerating the supported locale list by running:"
# echo "sudo dpkg-reconfigure locales"
# echo ""
# echo "And update/change the current default locale:"
# echo "sudo update-locale LANG=fr_FR.UTF-8"
# echo "Update"
# echo ""
# echo "Generate the locales for your language (e.g. British English):"
# echo "   sudo locale-gen fr_FR"
# echo "   sudo locale-gen fr_FR.UTF-8"
# echo ""
# echo "Extra steps to try:"
# echo ""
# echo "Try:"
# echo ""
# echo "sudo update-locale LANG="fr_FR.UTF-8" LANGUAGE="fr_FR""
# echo "sudo dpkg-reconfigure locales"
# echo "Perhaps adding LANG and LANGUAGE in /etc/environment could force a change. Try logout/login or rebooting."
# echo ""
# echo "locale will show your current locale for the current user. Perhaps it's worth checking out these files just to be sure no local language variables are set: ~/.profile ~/.bashrc ~/.bash_profile"



####################
#
print_header "For Hyper-V VMs: How to run full-screen and disable sleep"
#
####################

echo "Step 1: 'dmesg | grep virtual' to check, then 'sudo vi /etc/default/grub'"
echo '   Change: GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"'
echo '   To:     GRUB_CMDLINE_LINUX_DEFAULT="quiet splash video=hyperv_fb:1920x1080"'
echo "Adjust 1920x1080 to your current monitor resolution."
echo "Step 2: 'sudo reboot', then 'sudo update-grub', then 'sudo reboot' again."
echo ""
echo "From Hyper-V Manager dashboard, find the VM, and open Settings."
echo "Go to Integration Services tab > Make sure Guest services section is checked."
echo ""
echo "systemctl status sleep.target   # Show current sleep settings"
echo "sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target   # Disable sleep settings"
echo "sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target   # Enable sleep settings again"

####################
#
print_header "Notes for byobu (which uses tmux) terminal multiplexer (also note screen)"
#
####################

BYOBUNOTES="
Just makes all work on Linux easier to get comfortable with terminal multiplexers. byobu makes using tmux
nice and simple with convenient shortcuts and simpler customised defualts.
byobu cheat sheet / keybindings: https://cheatography.com/mikemikk/cheat-sheets/byobu-keybindings/
Learn byobu (enhancement for tmux) while listening to Mozart: https://www.youtube.com/watch?v=NawuGmcvKus
Tutorial Part 1: https://www.youtube.com/watch?v=R0upAE692fY
Tutorial Part 2: https://www.youtube.com/watch?v=2sD5zlW8a5E&list=PLJGDHERh23x8SAVC4uFyuR6dmauAXQBoF&index=2&t=2554s , His .dotfiles: https://github.com/agilesteel/.dotfiles
Byobu: https://byobu.org/​ tmux: https://tmux.github.io/​ Screen: https://www.gnu.org/software/screen/​

F1: Interactive help, Shift-F1: Quick help, 'q' to exit.
F2: New session on top of current
Shift-F2: Horizontoal Split, Ctrl-F2: Vertical split
Ctrl-S­hift-F2: Create new session. '0:-*'
F3/F4  *or*  Alt-Le­ft/­Right: Move focus among windows.
  Shift-­F3/F4: Move focus among splits.
  Ctrl-F3/F4: Move a split.   Ctrl-S­hif­t-F3/F4: Move a window.
  Alt-Up­/Down: Move focus among sessions.
  Shift-­Lef­t/R­igh­t/U­p/Down: Move focus among splits.
Shift-­Alt­-Le­ft/­Rig­ht/­Up/Down: Resize a split.
F5, Alt-F5: Toggle UTF-8 support, refresh status
  Shift-F5: Toggle status lines.
  Ctrl-F5: Reconnect ssh/gp­g/dbus sockets.
  Ctrl-S­hift-F5: Change status bar's color randomly (if on tmux)
F6 / Shift-F6: Detach session and do not logout. Alt-F6: Detach all clients but yourself. Ctrl-F6: Kill split in focus.
F7 / Alt-Pa­geU­p/P­ageDown: Enter and move through scroll­back.
Shift-F7: Save history to $BYOBU­_RU­N_D­IR/­pri­nts­creen.
F8 / Ctrl-F8: Rename the current session, Shift-F8: Toggle through split arrang­ements.
Alt-Sh­ift-F8: Restore a split-pane layout, Ctrl-S­hift-F8: Save the current split-pane layout.
F9 / Ctrl-F9: Enter command and run in all windows.
Shift-F9: Enter command and run in all splits.
Alt-F9: Toggle sending keyboard input to all splits.
F10: ?
F11 / Alt-F11: Expand split to a full window.
Shift-F11: Zoom into a split, zoom out of a split.
Ctrl-F11: Join window into a vertical split.
F12 / Shift-F12: Toggle on/off keybin­dings.
Alt-F12: Toggle on/off mouse support.
Ctrl-S­hif­t-F12: Mondrian squares.

byobu will connect to already open sessions by default
tmux will just open a new session by default

Quick refresher:
   alias b='byobu' , then type b to start byobu , then press x to make a vertical split then x to make a horizontal split
   Press x to jump to the first terminal , press x to rename the terminal , run 'htop' to start that , now just close the bash shell
   All sessions will continue to run, so restart bash and then type b to start byobu

$ byobu ls   |   $ byobu list-session   |   $ byobu list-sessions   # Note this is using tmux by default, not screen
no server running on /tmp/tmux-1000/default
# On starting byobu:
 u  20.04 0:-*                11d12h 0.00 4x3.4GHz 12.4G3% 251G2% 2021-04-27 08:41:50
u = Ubuntu, 20.04 = version, 0:~* is the session
11d12h = uptime, 0.00 = ?, 4x3.40GHz = 3.4GHz Core i5 with 4 cores
12.4G3% = 12.4 G free memory, 3% CPU usage,   251G2% = 251 G free space, 2% used
2021-04-27 08:41:50 = date/time
"
printf "$BYOBUNOTES\n"


####################
#
print_header "To disable annoying/loud Windows Event sounds if running in WSL or Putty"
#
####################

echo "Run the following lines in a PowerShell console on Windows to soften the Windows Event sounds:"
echo ""
echo '$toChange = @(".Default","SystemAsterisk","SystemExclamation","Notification.Default","SystemNotification","WindowsUAC","SystemHand")'
echo 'foreach ($c in $toChange) { Set-ItemProperty -Path "HKCU:\AppEvents\Schemes\Apps\.Default\$c\.Current\" -Name "(Default)" -Value "C:\WINDOWS\media\ding.wav" }'



####################
#
print_header "Run 'source ~/.custom' into this currently running session"
#
####################
# echo "Press 'Enter' to dotsource .custom into running session (or CTRL+C to skip)."
# read -e -p "Note that this will run automatically if invoked from Github via curl."; "$@"
echo ""
echo ""
[ -f ~/.custom ] && [[ $- == *"i"* ]] && . ~/.custom
echo "Note the above configuration details for any useful additional manual actions."
echo "'update-distro' to run through all update/upgrade actions (def 'distro-update' to check)."
echo "'update-custom-tools' will update .custom to latest version from Github."
echo "'cat ~/.custom' to view the functions that will load in all new interactive shells."
echo ""
echo ""
echo ""
if [ -f /var/run/reboot-required ]; then
    echo "A reboot is required (/var/run/reboot-required is present)." >&2
    echo "Re-run this script after reboot to finish the install." >&2
fi




####################
#
# Notes
#
####################

# Most common parsing issues that I found leading to "syntax error: unexpected end of file" errors:
# - Line endings being Windows instead of Unix.
# - Bash treats "then\r" as a command name, and "fi\r" as another, and so thinks that it has not seen the correct format for an if …; then …; fi statement
#   For line-endings, can either change this with "dos2unix <filename>" or, easier, open in vim and use ":set fileformat=unix"
#   Alternatively, within Notepad++. Edit -> EOL Conversion-> Unix (LF) or Macintosh (CR). Change it to Macintosh (CR) even if you are using Windows OS.
#   Alternatively, within VS Code. Look for the icon in tray, either "CRLF" or "LF", you can click on and change it.
#   https://stackoverflow.com/questions/48692741/how-to-make-all-line-endings-eols-in-all-files-in-visual-studio-code-unix-lik
# 
# - Also check on the termination of single-line functions with semicolon.
#   e.g. die () { test -n "$@" && echo "$@"; exit 1 }   The script might complete but the error will be seen.
#   To make the dumb parser happy:   die () { test -n "$@" && echo "$@"; exit 1; }     (i.e. add the ";" at the end)
#
# Tip: use trap to debug (if your script is on the large side...)
# e.g.
# set -x
# trap read debug
# 
# The 'trap' command is a way to debug your scripts by esentially breaking after every line.
# A fuller discussion is here: 
# hppts://stackoverflow.com/questions/951336/how-to-debug-a-bash-script/45096876#45096876 
#
# An alternative for handling line endings:
# export SHELLOPTS
# set -o igncr
# Put into .bashrc or .bash_profile and then do not need to run unix2dos

# Default LS_COLORS (on Ubuntu)
# Original di is 01;34 then is overwritten by 0;94 later
# rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36::di=0;94

# ToDo: rd() { [ $# = 1 ] && [ "$(ls -A "$@")" ] && echo "Not Empty" || echo "Empty"   # ToDo: remove a folder only if it is empty

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

# What is the .vscode folder in ~ ?

# To check that a script has root priveleges (did not require for the above script):
# if [ "$(id -u)" -ne 0 ]; then
#     echo 'This script must be run with root privileges' >&2
#     return
# fi



# echo ""
# echo "Byobu is a suite of enhancements to tmux, as a command line"
# echo "tool providing live system status, dynamic window management,"
# echo "and some convenient keybindings:"
# echo ""
# echo "F1                             * Used by X11 *"
# echo "  Shift-F1                     Display this help"
# echo "F2                             Create a new window"
# echo "  Shift-F2                     Create a horizontal split"
# echo "  Ctrl-F2                      Create a vertical split"
# echo "  Ctrl-Shift-F2                Create a new session"
# echo "F3/F4                          Move focus among windows"
# echo "  Alt-Left/Right               Move focus among windows"
# echo "  Alt-Up/Down                  Move focus among sessions"
# echo "  Shift-Left/Right/Up/Down     Move focus among splits"
# echo "  Shift-F3/F4                  Move focus among splits"
# echo "  Ctrl-F3/F4                   Move a split"
# echo "  Ctrl-Shift-F3/F4             Move a window"
# echo "  Shift-Alt-Left/Right/Up/Down Resize a split"
# echo "F5                             Reload profile, refresh status"
# echo "  Alt-F5                       Toggle UTF-8 support, refresh status"
# echo "  Shift-F5                     Toggle through status lines"
# echo "  Ctrl-F5                      Reconnect ssh/gpg/dbus sockets"
# echo "  Ctrl-Shift-F5                Change status bar's color randomly"
# echo "F6                             Detach session and then logout"
# echo "  Shift-F6                     Detach session and do not logout"
# echo "  Alt-F6                       Detach all clients but yourself"
# echo "  Ctrl-F6                      Kill split in focus"
# echo "F7                             Enter scrollback history"
# echo "  Alt-PageUp/PageDown          Enter and move through scrollback"
# echo "  Shift-F7                     Save history to \$BYOBU_RUN_DIR/printscreen"
# echo "F8                             Rename the current window"
# echo "  Ctrl-F8                      Rename the current session"
# echo "  Shift-F8                     Toggle through split arrangements"
# echo "  Alt-Shift-F8                 Restore a split-pane layout"
# echo "  Ctrl-Shift-F8                Save the current split-pane layout"
# echo "F9                             Launch byobu-config window"
# echo "  Ctrl-F9                      Enter command and run in all windows"
# echo "  Shift-F9                     Enter command and run in all splits"
# echo "  Alt-F9                       Toggle sending keyboard input to all splits"
# echo "F10                            * Used by X11 *"
# echo "F11                            * Used by X11 *"
# echo "  Alt-F11                      Expand split to a full window"
# echo "  Shift-F11                    Zoom into a split, zoom out of a split"
# echo "  Ctrl-F11                     Join window into a vertical split"
# echo "F12                            Escape sequence"
# echo "  Shift-F12                    Toggle on/off Byobu's keybindings"
# echo "  Alt-F12                      Toggle on/off Byobu's mouse support"
# echo "  Ctrl-Shift-F12               Mondrian squares"
