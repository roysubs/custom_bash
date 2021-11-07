#!/bin/bash
####################
#
# Always run the git config before cloning to fix potential line ending problems, especially on WSL
# git config --global core.autocrlf input   
# git clone https://github.com/roysubs/custom_bash
# . <(curl -sS https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom)   # To dotsource from github immediately
# 
# This script performs some configuration options to make a consistent bash environemt, and then
# installss .custom into the profile ready to be used in interactive shells.
#
####################

# Some WSL / Putty / Linux editing:
# To paste into a Terminal (in Linux, not via Putty), use Ctrl+Shift+V. In Putty, use  Shift+Insert.
# Also can use the middle mouse button to paste selected text in a Linux Terminal (i.e. if in a Hyper-V Ubuntu session)
# https://askubuntu.com/questions/734647/right-click-to-paste-in-terminal?newreg=00145d6f91de4cc781cd0f4b76fccd2e

# Useful Toolkits to look through:
# https://www.commandlinefu.com/commands/browse
# Nam Nguyen : https://github.com/gdbtek/ubuntu-cookbooks/blob/master/libraries/util.bash referenced from https://serverfault.com/questions/20747/find-last-time-update-was-performed-with-apt-get
# SSH keys setup : https://github.com/creynoldsaccenture/bash-toolkit
# BEF (Bash Essential Functions) : https://github.com/shoogle/bash-essential-functions/blob/master/modules/bef-filepaths.sh
# Bash-it : https://www.tecmint.com/bash-it-control-shell-scripts-aliases-in-linux/
# https://www.digitalocean.com/community/tutorials/an-introduction-to-useful-bash-aliases-and-functions
# https://gitlab.com/bertrand-benoit/scripts-common
# https://opensource.com/article/19/7/bash-aliases
# https://src-r-r.github.io/articles/essential-bash-commands-to-make-life-easier/
# https://tldp.org/LDP/abs/html/sample-bashrc.html
# https://www.linuxhowtos.org/Tips%20and%20Tricks/
# https://www.quora.com/What-are-some-useful-bash_profile-and-bashrc-tips?encoded_access_token=e46b28e4342944a58cb01681b425df9e&expires_in=5184000&fb_uid=4467565573287648&force_dialog=1&provider=facebook&share=1&success=True#_=_
# https://dev.to/awwsmm/101-bash-commands-and-tips-for-beginners-to-experts-30je
# https://www.addictivetips.com/ubuntu-linux-tips/edit-the-bashrc-file-on-linux/
# https://crunchbang.org/forums/viewtopic.php?id=1093
# https://wiki.linuxquestions.org/wiki/Scripts#Command_Line_Trash_Can  cli trash can function, large compressed files, Kerberos, JVMs
# https://wiki.linuxquestions.org/wiki/Bash_tips
# https://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html
# http://philip.vanmontfort.be/bestanden/linux/bashrc
# https://github.com/erwanjegouzo/dotfiles/blob/master/.bash_profile
# https://serverfault.com/questions/3743/what-useful-things-can-one-add-to-ones-bashrc?page=1&tab=votes#tab-top
# https://tldp.org/LDP/abs/html/testconstructs.html#DBLBRACKETS
# https://github.com/algotech/dotaliases
# https://github.com/dmeekabc/tagaProductized/tree/master/iboaUtils IBOA Utils, alias tools
# https://www.grymoire.com/Unix/Sed.html  Excellent Sed Guide
# https://blog.sanctum.geek.nz/series/unix-as-ide/  Excellent Guide on shell usage
# https://www.cyberciti.biz/tips/bash-aliases-mac-centos-linux-unix.html
# https://blog.ssdnodes.com/blog/13-smart-terminal-tools-to-level-up-your-linux-servers/ # Some very useful tools
# tldr: Read simplified instructions on common terminal commands
# how2: Get answers to your terminal questions
# z: Jump to ‘frecently’ used places
# trash-cli: Put files in the trash
# nnn: Manage your files visually
# bat: View files with syntax highlighting
# pomo: A Pomodoro timer in your terminal
# fselect: Find files with the speed of SQL
# exa: List files with more features (and colors) than ls
# peco: Get grep-like filtering with interactivity
# has: Do you 'has' the dependencies you need?
# progress: See how much longer mv, dd, cp, and more will take
# mackup: Sync and restore your application settings
# transfer.sh: Share files directly from the command line
# https://www.tecmint.com/12-top-command-examples-in-linux/
# https://www.dedoimedo.com/computers/new-cool-list-linux.html
# https://www.xmodulo.com/useful-cli-tools-linux-system-admins.html
# The [[ ]] construct is the more versatile Bash version of [ ]. This is the extended test command, adopted from ksh88.
# Using the [[ ... ]] test construct, rather than [ ... ] can prevent many logic errors in scripts. For example, the &&, ||, <, and > operators work within a [[ ]] test, despite giving an error within a [ ] construct.
# Problem with 'set -e', so have removed. It should stop on first error, but instead it kills the WSL client completely https://stackoverflow.com/q/3474526/
# If you want to run apt-get without having to supply a sudo password, just edit the sudo config file to allow that. (Replace “jfb” in this example with your own login).
# jfb ALL=(root) NOPASSWD: /usr/bin/apt-get
# https://www.cyberciti.biz/open-source/30-cool-best-open-source-softwares-of-2013/
# alias gitupdate='(for l in `find . -name .git | xargs -i dirname {}` ; do cd $l; pwd; git pull; cd -; done)'   # https://stackoverflow.com/questions/4083834/what-are-some-interesting-shell-scripts
# alias backup='rsync -av ~/Documents user@domain.com: --delete --delete-excluded --exclude-from=/Users/myusername/.rsync/exclude --rsh="ssh"'

####################
#
# Setup print_header() and exe() functions
#
####################

hh=/tmp/.custom   # This is the location of all helper scripts, could change this location
[ -d $hh ] || mkdir $hh

### print_header() will display up to 3 arguments as a simple banner
print_header() {
    printf "\n\n####################\n"
    printf "#\n"
    if [ "$1" != "" ]; then printf "# $1\n"; fi
    if [ "$2" != "" ]; then printf "# $2\n"; fi
    if [ "$3" != "" ]; then printf "# $3\n"; fi
    printf "#\n"
    printf "####################\n"
}

### exe() will display a command and then run that same command, so you can see what is about to be run
# https://stackoverflow.com/questions/2853803/how-to-echo-shell-commands-as-they-are-executed
# By default, the following exe() will run run unattended, i.e. will show the command and then execute immediately
# However, if "y" is chosen, the exe() function is updated to display the command, then display a pause before running as follows:
# exe() { printf "\n\n"; echo "\$ ${@/eval/}"; read -e -p "Press 'Enter' to continue..."; "$@"; }
# ToDo (might not be required): modify this so that it displays a y/n after each command so can skip some and continue on to other commands.
# https://stackoverflow.com/questions/29436275/how-to-prompt-for-yes-or-no-in-bash
exe() { printf "\n"; echo "\$ ${@/eval/}"; "$@"; }



####################
#
print_header "Start common cross-distro configuration steps" "and setup common tools (.custom / .vimrc / .inputrc)" "without creating complex changes in .bashrc etc"
#
####################

####################
#
print_header "Also configure some basic useful settings in" ".inputrc / .vimrc / and etc/sudoers.d/custom_rules"
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
if [ -f "$HOME/custom_loader.sh" ]; then read -e -p "Do not run custom_loader.sh \$HOME"; read -e -p "Press 'Ctrl-C' to exit script..."; fi
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

# if [ -f ~/.config/.custom-locale ];
#     echo "Input locale to set for this system (this will be saved in ~/.config/.custom-locale)"
#     echo "Possible locales are: EN, GB, US, NL, FR, IT, etc"
#     [[ "$(read -e -p 'Input locale code to set for this system? > '; echo $REPLY)" == []* ]] && exe() { printf "\n\n"; echo "\$ ${@/eval/}"; read -e -p "Press 'Enter' to continue..."; "$@"; } 
# fi

[[ "$(read -e -p 'Confirm each configutation step? [y/N]> '; echo $REPLY)" == [Yy]* ]] && exe() { printf "\n\n"; echo "\$ ${@/eval/}"; read -e -p "Press 'Enter' to continue..."; "$@"; } 



####################
#
print_header "Find package manager and run package/distro updates"
#
####################

manager=
type apt    &> /dev/null && manager=apt    && DISTRO="Debian/Ubuntu"
type yum    &> /dev/null && manager=yum    && DISTRO="RHEL/Fedora/CentOS"
type dnf    &> /dev/null && manager=dnf    && DISTRO="RHEL/Fedora/CentOS"   # $manager=dnf will be default if both dnf and yum are present
type zypper &> /dev/null && manager=zypper && DISTRO="SLES"
type apk    &> /dev/null && manager=apk    && DISTRO="Alpine"

# apk does not require 'sudo' or a '-y' to install
if [ "$manager" = "apk" ]; then
    INSTALL="$manager add"
else
    INSTALL="sudo $manager install -y"
fi

# Only install each a binary from that package is not already present on the system
check_and_install() { type $1 &> /dev/null && printf "\n$1 is already installed" || exe $INSTALL $2; }
             # e.g.   type dos2unix &> /dev/null || exe sudo $manager install dos2unix -y

[[ "$manager" = "apk" ]] && check_and_install sudo sudo   # Just install sudo on Alpine for script compatibility

echo -e "\n\n>>>>>>>>    A variant of '$DISTRO' was found, so will use"
echo -e     ">>>>>>>>    the '$manager' package manager for setup tasks."
echo ""
printf "> sudo $manager update -y\n> sudo $manager upgrade -y\n> sudo $manager dist-upgrade -y\n> sudo $manager install ca-certificates -y\n> sudo $manager autoremove -y\n"
# Note 'install ca-certificates' to allow SSL-based applications to check for the authenticity of SSL connections

# Need to make sure that 'needsrestarting' is present on CentOS to check if a reboot is required, or we find another tool
if type dnf &> /dev/null 2>&1; then
    type needsrestarting &> /dev/null || sudo dnf install yum-utils -y
fi



# I could 'source .custom' at the top of this script and then call 'pt' and 'updistro'. This is
# not good though; if there is a bug in '.custom', then this script will fail, and variables from
# there might interfere here. Just keep a copy of the 'updistro' function in this script also.
pt() {
    # 'package tool', arguments are a list of package names to try. e.g. pt vim dfc bpytop htop
    # Determine if packages are already installed, fetch distro package list to see what is available, and then install the difference
    # If '-auto' or '--auto' is in the list, will install without prompts. e.g. pt -auto vlc emacs
    # Package names can be different in Debian/Ubuntu vs RedHat/Fedora/CentOS. e.g. python3.9 in Ubuntu is python39 in CentOS
    arguments="$@"; isinrepo=(); isinstalled=(); caninstall=(); notinrepo=(); toinstall=""; packauto=0; endloop=0;
    [[ $arguments == *"--auto"* ]] && packauto=1 && arguments=$(echo $arguments | sed 's/--auto//')   # enable switch and remove switch from arguments
    [[ $arguments == *"-auto"* ]] && packauto=1 && arguments=$(echo $arguments | sed 's/-auto//')     # must do '--auto' before '-auto' or will be left with a '-' fragment
    mylist=("$arguments")   # Create array out of the arguments.    mylist=(python3.9 python39 mc translate-shell how2 npm pv nnn alien angband dwarf-fortress nethack-console crawl bsdgames bsdgames-nonfree tldr tldr-py bpytop htop fortune-mod)
    # if declare -p $1 2> /dev/null | grep -q '^declare \-a'; then echo "The input \$1 must be an array"; return; fi   # Test if the input is an array
    type apt &> /dev/null && manager="apt" && apt list &> /dev/null > /tmp/all-repo.txt && apt list --installed &> /dev/null > /tmp/all-here.txt && divider="/"
    type dnf &> /dev/null && manager="dnf" && dnf list &> /dev/null > /tmp/all-repo.txt && dnf list installed   &> /dev/null > /tmp/all-here.txt && divider=""
    type dnf &> /dev/null && manager="dnf" && dnf list &> /dev/null > /tmp/all-repo.txt && dnf list installed   &> /dev/null > /tmp/all-here.txt && divider=""
    for x in ${mylist[@]}; do grep "^$x$divider" /tmp/all-repo.txt &> /dev/null && isinrepo+=($x); done    # find items available in repo
    # echo -e "These are in the repo: ${isinrepo[@]}\n\n"   # $(for x in ${isinrepo[@]}; do echo $x; done)
    for x in ${mylist[@]}; do grep "^$x$divider" /tmp/all-here.txt &> /dev/null && isinstalled+=($x); done # find items already installed
    notinrepo+=(`echo ${mylist[@]} ${isinrepo[@]} | tr ' ' '\n' | sort | uniq -u `)  # get the diff from two arrays, jave have to consider the right arrays to use here # different answer here: https://stackoverflow.com/a/2315459/524587
    echo ""
    [[ ${isinrepo[@]} != "" ]]    && echo "These packages exist in the $manager repository:            ${isinrepo[@]}"   # $(for x in ${isinstalled[@]}
    [[ ${isinstalled[@]} != "" ]] && echo "These packages are already installed on this system:   ${isinstalled[@]}"   # $(for x in ${isinstalled[@]}
    [[ ${notinrepo[@]} != "" ]]   && echo "These packages do not exist in the repository:         ${notinrepo[@]}"     # $(for x in ${isinstalled[@]}

    caninstall+=(`echo ${isinrepo[@]} ${isinstalled[@]} | tr ' ' '\n' | sort | uniq -u `)  # get the diff from two arrays (use "${}" if spaces in array elements) # https://stackoverflow.com/a/28161520/524587
    if [ $packauto = 1 ]; then
        if (( ${#caninstall[@]} )); then sudo $manager install -y ${caninstall[@]}   # Test the number of elements, if non-zero then enter the loop
        else echo -e "\nNo selected packages can be installed. Exiting ...\n"
        fi
        return
    fi
    
    while [ $endloop = 0 ]; do
        caninstall=(Install-and-Exit)
        caninstall+=(`echo ${isinrepo[@]} ${isinstalled[@]} | tr ' ' '\n' | sort | uniq -u `)  # get the diff # https://stackoverflow.com/questions/2312762/compare-difference-of-two-arrays-in-bash#comment52200489_28161520
        if [[ ${caninstall[@]} = "Install-and-Exit" ]]; then echo -e "\nNo new packages exist in the repository to be installed. Exiting ...\n"; return; fi
        COLUMNS=12
        [[ $toinstall != "" ]] && echo -e "\n\nCurrently selected packages:   $toinstall"
        echo -e "\n\nSelect a package number to add to the install list.\nTo install the selected packages and exit the tool, select '1'.\n"
        printf -v PS3 '\n%s ' 'Enter number of package to install: '
        select x in ${caninstall[@]}; do
            toinstall+=" $x "
            toinstall=$(echo $toinstall | sed 's/Install-and-Exit//' | tr ' ' '\n' | sort -u | xargs)   # https://unix.stackexchange.com/a/353328/441685
            if [ $x == "Install-and-Exit" ]; then endloop=1; fi
            break
        done
    done
    if [[ $toinstall = *[!\ ]* ]]; then    # https://unix.stackexchange.com/a/147109/441685
        echo -e "\n\n\nAbout to run:   sudo $manager install $toinstall\n\n"
        read -p "Press Ctrl-C to skip installation or press any key to install the package(s) ..."
        sudo $manager install -y $toinstall
    else
        echo -e "\nNo selected packages can be installed. Exiting ...\n"
    fi
}

updistro() {    # Self-contained function, no arguments, perform all update/upgrade functions for the current distro
    type apt    &> /dev/null && manager=apt    && DISTRO="Debian/Ubuntu"
    type yum    &> /dev/null && manager=yum    && DISTRO="RHEL/Fedora/CentOS"
    type dnf    &> /dev/null && manager=dnf    && DISTRO="RHEL/Fedora/CentOS"   # $manager should be dnf if both dnf and yum are present
    type zypper &> /dev/null && manager=zypper && DISTRO="SLES"
    type apk    &> /dev/null && manager=apk    && DISTRO="Alpine"
    function separator() { echo -e "\n>>>>>>>>\n"; }
    function displayandrun() { echo -e "\$ ${@/eval/}\n"; "$@"; }          # Show a command to run, and then run it, useful for showing progress during scripts

    printf "\nCheck updates:"
    echo -e "\n\n>>>>>>>>    The '$DISTRO' package manager was found, so will"
    echo -e     ">>>>>>>>    use the '$manager' package manager for setup tasks."
    if [ "$manager" == "apt" ]; then separator; displayandrun sudo apt --fix-broken install -y; fi   # Check and fix any broken installs, do before and after updates
    if [ "$manager" == "apt" ]; then separator; displayandrun sudo apt dist-upgrade -y; fi
    if [ "$manager" == "apt" ]; then separator; displayandrun sudo apt-get update --ignore-missing -y; fi     # Note sure if this is needed
    if [ "$manager" == "apt" ]; then type apt-file &> /dev/null && separator && displayandrun sudo apt-file update; fi   # update apt-file cache but only if apt-file is present
    if [ "$manager" == "apk" ]; then
        separator; displayandrun apk update; separator; displayandrun apk upgrade
    else
        separator; displayandrun sudo $manager update
        separator; displayandrun sudo $manager upgrade      # Note that on dnf, update/upgrade are the same command
        separator; displayandrun sudo $manager install ca-certificates -y   # To allow SSL-based applications to check for the authenticity of SSL connections
        separator; displayandrun sudo $manager autoremove
    fi
    if [ "$manager" == "apt" ]; then separator; displayandrun sudo apt --fix-broken install -y; fi   # Check and fix any broken installs, do before and after updates
    if [ -f /var/run/reboot-required ]; then
        echo "A reboot is required (/var/run/reboot-required is present)." >&2
        echo "Re-run this script after reboot to check." >&2
        return
    fi
    echo ""
}

function getLastUpdate()
{
    if [[ $manager == "apt" ]]; then local updateDate="$(stat -c %Y '/var/cache/apt')"; fi   # %Y  time of last data modification, in seconds since Epoch
    if [[ $manager == "dnf" ]]; then local updateDate="$(stat -c %Y '/var/cache/dnf/expired_repos.json')"; fi   # %Y  time of last data modification, in seconds since Epoch
    local nowDate="$(date +'%s')"                    # %s  seconds since 1970-01-01 00:00:00 UTC
    echo $((nowDate - updateDate))                      # simple arithmetic with $(( ))
}

function runDistroUpdate()
{
    local updateInterval="${1}"     # An update interval can be specifide as $1, otherwise default to a value below
    local lastUpdate="$(getLastUpdate)"

    if [[ -z "$updateInterval" ]]   # "$(isEmptyString "${updateInterval}")" = 'true'
    then
        updateInterval="$((24 * 60 * 60))"   # Adjust this to how often to do updates, setting to 24 hours in seconds
    fi
    updateIntervalReadable=$(printf '%dh:%dm:%ds\n' $((updateInterval/3600)) $((updateInterval%3600/60)) $((updateInterval%60)))

    if [[ "${lastUpdate}" -gt "${updateInterval}" ]]   # only update if $updateInterval is more than 24 hours
    then
        print_header "apt updates will run as last update was more than ${updateIntervalReadable} ago"

        # Handle EPEL (Extra Packages for Enterprise Linux) and PowerTools, fairly essential for hundreds of packages like htop, lynx, etc
        # To remove EPEL (normally only do this if upgrading to a new distro of CentOS, e.g. from 7 to 8)
        # sudo rpm -qa | grep epel                                                               # Check the epel version installed
        # sudo rpm -e epel-release-x-x.noarch                                                    # Remove the installed epel, x-x is the version
        # sudo rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm   # Install the latest epel
        # yum repolist   # check if epel is installed
        # if type dnf &> /dev/null 2>&1; then exe sudo $manager -y upgrade https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm; fi
        if type dnf &> /dev/null 2>&1; then
            if [[ $(rpm -qa | grep epel-release) ]]; then
                echo ""
                echo "$DISTRO : EPEL Repository is already installed"
            else
                sudo dnf install epel-release
            fi
            if [[ $(dnf repolist | grep powertools) ]]; then
                echo "$DISTRO : PowerTools Repository is already installed"
            else
                sudo dnf -y install dnf-plugins-core
                sudo dnf config-manager --set-enabled powertools   # Note that this must be lowercase, 'PowerTools' fails
            fi
        fi

        updistro

    else
        local lastUpdate="$(date -u -d @"${lastUpdate}" +'%-Hh %-Mm %-Ss')"
        print_header "Skip apt-get update because its last run was ${updateIntervalReadable} ago"
    fi
}

runDistroUpdate



if [ -f /var/run/reboot-required ]; then
    echo ""
    echo "A reboot is required (/var/run/reboot-required is present)."   # >&2
    echo "If running in WSL, can shutdown with:   wsl.exe --terminate \$WSL_DISTRO_NAME"
    echo "Re-run this script after reboot to finish the install."
    . .custom   # In case this is first run of custom-loader.sh, source in .custom anyway to make those aliases and functions available
    return   # Script will exit here if a reboot is required
fi
if [[ "$manager" == "dnf" ]] || [[ "$manager" == "yum" ]]; then 
    needsReboot=$(needs-restarting -r &> /dev/null 2>&1; echo $?)   # Supress the output message from needs-restarting (from yum-utils)
    if [[ $needsReboot == 1 ]]; then
        echo "Note: A reboot is required (by checking: needs-restarting -r)."
        echo "Re-run this script after reboot to finish the install."
        . .custom   # In case this is first run of custom-loader.sh, source in .custom anyway to make those aliases and functions available
        return   # Script will exit here if a reboot is required
    fi
fi



####################
#
print_header "Check and install small/essential packages"
#
####################

# I could 'source .custom' at the top of this script and then call 'pt'.
# Decided not to do this though, as if there is a bug in '.custom', then this script will fail, so just
# keep a copy of the 'pt' function in this script also.
pt() {
    # 'package tool', arguments are a list of package names to try. e.g. pt vim dfc bpytop htop
    # Determine if packages are already installed, fetch distro package list to see what is available, and then install the difference
    # If '-auto' or '--auto' is in the list, will install without prompts. e.g. pt -auto vlc emacs
    # Package names can be different in Debian/Ubuntu vs RedHat/Fedora/CentOS. e.g. python3.9 in Ubuntu is python39 in CentOS
    arguments="$@"; isinrepo=(); isinstalled=(); caninstall=(); notinrepo=(); toinstall=""; packauto=0; endloop=0
    [[ $arguments == *"--auto"* ]] && packauto=1 && arguments=$(echo $arguments | sed 's/--auto//')   # enable switch and remove switch from arguments
    [[ $arguments == *"-auto"* ]] && packauto=1 && arguments=$(echo $arguments | sed 's/-auto//')     # must do '--auto' before '-auto' or will be left with a '-' fragment
    mylist=("$arguments")   # Create array out of the arguments.    mylist=(python3.9 python39 mc translate-shell how2 npm pv nnn alien angband dwarf-fortress nethack-console crawl bsdgames bsdgames-nonfree tldr tldr-py bpytop htop fortune-mod)
    # if declare -p $1 2> /dev/null | grep -q '^declare \-a'; then echo "The input \$1 must be an array"; return; fi   # Test if the input is an array
    type apt &> /dev/null && manager="apt" && apt list &> /dev/null > /tmp/all-repo.txt && apt list --installed &> /dev/null > /tmp/all-here.txt && divider="/"
    type dnf &> /dev/null && manager="dnf" && dnf list &> /dev/null > /tmp/all-repo.txt && dnf list installed   &> /dev/null > /tmp/all-here.txt && divider=""
    for x in ${mylist[@]}; do grep "^$x$divider" /tmp/all-repo.txt &> /dev/null && isinrepo+=($x); done    # find items available in repo
    # echo -e "These are in the repo: ${isinrepo[@]}\n\n"   # $(for x in ${isinrepo[@]}; do echo $x; done)
    for x in ${mylist[@]}; do grep "^$x$divider" /tmp/all-here.txt &> /dev/null && isinstalled+=($x); done # find items already installed
    notinrepo+=(`echo ${mylist[@]} ${isinrepo[@]} | tr ' ' '\n' | sort | uniq -u `)  # get the diff from two arrays, jave have to consider the right arrays to use here # different answer here: https://stackoverflow.com/a/2315459/524587
    echo ""
    [[ ${isinrepo[@]} != "" ]]    && echo "These packages exist in the $manager repository:            ${isinrepo[@]}"   # $(for x in ${isinstalled[@]}
    [[ ${isinstalled[@]} != "" ]] && echo "These packages are already installed on this system:   ${isinstalled[@]}"   # $(for x in ${isinstalled[@]}
    [[ ${notinrepo[@]} != "" ]]   && echo "These packages do not exist in the repository:         ${notinrepo[@]}"     # $(for x in ${isinstalled[@]}

    caninstall+=(`echo ${isinrepo[@]} ${isinstalled[@]} | tr ' ' '\n' | sort | uniq -u `)  # get the diff from two arrays (use "${}" if spaces in array elements) # https://stackoverflow.com/a/28161520/524587
    if [ $packauto = 1 ]; then
        if (( ${#caninstall[@]} )); then sudo $manager install -y ${caninstall[@]}   # Test the number of elements, if non-zero then enter the loop
        else echo -e "\nNo selected packages can be installed. Exiting ...\n"
        fi
        return
    fi
    
    while [ $endloop = 0 ]; do
        caninstall=(Install-and-Exit)
        caninstall+=(`echo ${isinrepo[@]} ${isinstalled[@]} | tr ' ' '\n' | sort | uniq -u `)  # get the diff # https://stackoverflow.com/questions/2312762/compare-difference-of-two-arrays-in-bash#comment52200489_28161520
        if [[ ${caninstall[@]} = "Install-and-Exit" ]]; then echo -e "\nNo new packages exist in the repository to be installed. Exiting ...\n"; return; fi
        COLUMNS=12
        [[ $toinstall != "" ]] && echo -e "\n\nCurrently selected packages:   $toinstall"
        echo -e "\n\nSelect a package number to add to the install list.\nTo install the selected packages and exit the tool, select '1'.\n"
        printf -v PS3 '\n%s ' 'Enter number of package to install: '
        select x in ${caninstall[@]}; do
            toinstall+=" $x "
            toinstall=$(echo $toinstall | sed 's/Install-and-Exit//' | tr ' ' '\n' | sort -u | xargs)   # https://unix.stackexchange.com/a/353328/441685
            if [ $x == "Install-and-Exit" ]; then endloop=1; fi
            break
        done
    done
    if [[ $toinstall = *[!\ ]* ]]; then    # https://unix.stackexchange.com/a/147109/441685
        echo -e "\n\n\nAbout to run:   sudo $manager install $toinstall\n\n"
        read -p "Press Ctrl-C to skip installation or press any key to install the package(s) ..."
        sudo $manager install -y $toinstall
    else
        echo -e "\nNo selected packages can be installed. Exiting ...\n"
    fi
}
nowDate="$(date +'%s')"                          # %s  seconds since 1970-01-01 00:00:00 UTC
updateDate=$nowDate
[ -f /tmp/all-repo.txt ] && updateDate="$(stat -c %Y '/tmp/all-repo.txt')"   # %Y  time of last data modification, in seconds since Epoch

lastUpdate=$((nowDate - updateDate))             # simple arithmetic with $(( ))
updateInterval="$((24 * 60 * 60))"   # Adjust this to how often to do updates, setting to 24 hours in seconds
updateIntervalReadable=$(printf '%dh:%dm:%ds\n' $((updateInterval/3600)) $((updateInterval%3600/60)) $((updateInterval%60)))
if [[ "${lastUpdate}" -gt "${updateInterval}" ]]
then
    packages=( dpkg apt-file alien \            # apt-file required for searching on 'what provides a package' searches, alien converts packages
               python3.9 python3-pip perl \     # Get latest python/pip and perl if not present on this distro
               cron curl wget pv dos2unix \     # Basic tools, cron is not installed by default on CentOS etc
               git vim zip unzip mount byobu \
               nnn dfc pydf ncdu tree  \        # nnn (more useful than mc), dfc, pdf, ncdu variants
               htop neofetch inxi )             # inxi system information tool

    pt -auto ${packages[@]}     # 'pt' will create a list of valid packages from those input and then installs those
fi

echo ""
echo ""
echo ""

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
    [ ! -f /tmp/figletfonts40.zip ] && exe sudo wget -nc --tries=3 -T20 --restrict-file-names=nocontrol -P /tmp/ "http://www.jave.de/figlet/figletfonts40.zip"
    [ -f /tmp/figletfonts40.zip ]   && exe sudo unzip -od /usr/share/figlet/ /tmp/figletfonts40.zip  # unzip to destination -d, with overwrite -o
    [ -d /usr/share/figlet/fonts ]  && exe sudo mv -f /usr/share/figlet/fonts/* /usr/share/figlet/   # move all fonts back into the main folder (force)
    [ -d /usr/share/figlet/fonts ]  && exe sudo rmdir /usr/share/figlet/fonts
    [ -f /tmp/figletfonts40.zip ]   && exe sudo rm /tmp/figletfonts40.zip                            # cleanup
fi



####################
#
print_header "PowerShell (pwsh) Shell for Linux"
#
####################
echo "Setup the PowerShell shell on Linux (start the shell with 'pwsh')"
echo ""
echo "=====> For Ubuntu"
# wget -q https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb"
echo "wget -q https://packages.microsoft.com/config/ubuntu/\$(lsb_release -rs)/packages-microsoft-prod.deb -O packages-microsoft-prod.deb"
echo "dpkg -i packages-microsoft-prod.deb"
echo "apt-get update -y"
echo "apt-get install powershell -y"
echo ""
echo "=====> For CentOS"
echo "curl https://packages.microsoft.com/config/rhel/8/prod.repo | sudo tee /etc/yum.repos.d/microsoft.repo"
echo "sudo dnf install powershell"
echo ""
echo ""
echo ""

# up.sh is a more complete "cd up" script. I don't really need this, just define u1, u2, u3, u4, u5 shortcuts in .custom
# shortcut creates a db of locations, similar to my PowerShell function, again, now sure if I want to use this, but handy to know about
# curl --create-dirs -o ~/.config/up/up.sh https://raw.githubusercontent.com/shannonmoeller/up/master/up.sh   # echo 'source ~/.config/up/up.sh' >> ~/.bashrc   # For .custom
# [[ ! -d ~/.config/shortcut ]] && git clone https://github.com/zakkor/shortcut.git ~/.config/shortcut   # install.sh will create ~/.scrc for key-pairs and /usr/local/bin/shortcut.sh

if [ ! $(which bat) ]; then    # if 'bat' is not present, then try to get it
    ####################
    #
    print_header "Download 'bat' (syntax highlighted replacement for 'cat') manually to a known working version"
    #
    ####################

    # Following task is to get the latest package from a non-repo site, then optionally convert it (with alien) to a compatible
    # format, and then install it. Some useful methods here that can be used elsewhere:
    # - Finding the latest download link on a site
    # - String manipulations to get components of link, filename, extension etc
    # - Using \K lookbehnid functionality in grep by using Perl regex mode (-P)
    # - Feed a variable into grep with '<<<' instead of a file
    # - Using 'alien' to (try and) convert a .deb into a .rpm to install on CentOS
    #     This is not currently working on CentOS, *but*, creating the .rpm on Ubuntu then moving that to CentOS works
    #     It generates some errors:
    #       file / from install of bat-musl-0.18.3-2.x86_64 conflicts with file from package filesystem-3.8-6.el8.x86_64
    #       file /usr/bin from install of bat-musl-0.18.3-2.x86_64 conflicts with file from package filesystem-3.8-6.el8.x86_64
    #     But forcing it to install did work and probably does not break anything, i.e. see here: https://stackoverflow.com/questions/27172142/conflicts-with-file-from-package-filesystem-3-2
    #       sudo rpm -i --force bat-musl-0.18.3-2.x86_64.rpm
    # - Note on extracting substrings in bash: https://www.baeldung.com/linux/bash-substring
    echo "# Download and setup 'bat' so that .custom can alias 'cat' to use 'bat' instead"
    echo "# This provides same functionality as 'cat' but with colour syntax highlighting"
    # When we get the .deb file, the install syntax is:
    # sudo dpkg -i /tmp/bat-musl_0.18.3_amd64.deb   # install
    # sudo dpkg -r bat                              # remove
    # Can alternatively use pygmentize: https://www.gilesorr.com/blog/pygmentize-less.html, but bat -f (--force-colorization) is better
    # We need to determine the latest download link for our needs, starting from this url
    # Need to look at /releases/ even though the downloads are under /releases/download/ as the links are here
    bat_releases=https://github.com/sharkdp/bat/releases/   
    content=$(wget $bat_releases -q -O -) 
    # -q quiet. -O option allows speficying a filename to download to; specify - to get the dump onto standard output (which we collect into $content)
    # Need to then look for first link ending "_amd64.deb", e.g. href="/sharkdp/bat/releases/download/v0.18.3/bat_0.18.3_amd64.deb"
    # content=$(curl -L google.com) # You could also use curl, -L as the page might have moved to get from new location, --location option helps with this.

    # grep -P uses Perl regular expressions to allow for \K lookbehinds. https://stackoverflow.com/questions/33573920/what-does-k-mean-in-this-regex
    # echo 'hello world' | grep 'hello \K(world)'   # Will only match 'world' if and only if it is preceded by 'hello ' but will not include the 'hello ' part in the match.
    # grep -oP 'href="\K/sharkdp/[^"]*_amd64\.deb'  # matches href=" (then drops it from the match), then matche /sharkdp/ and any number of chars *except* " , and then match _amd_64.deb
    firstlink=$(grep -oP 'href="/sharkdp/bat/releases/\K[^"]*_amd64\.deb' <<< "$content" | head -1)
    # Note how to feed a variable into grep with '<<<' instead of a file
    DL=$bat_releases$firstlink
    ver_and_filename=$(grep -oP 'https://github.com/sharkdp/bat/releases/download/\K[^"]*\.deb' <<< "$DL")   # v0.18.3/bat-musl_0.18.3_amd64.deb
    IFS='/' read -ra my_array <<< "$ver_and_filename"   # for i in "${my_array[@]}"; do echo $i; done
    ver=${my_array[0]}
    filename=${my_array[1]}
    IFS='.' read -ra my_array <<< "$filename"
    extension=${my_array[-1]}
    extension_with_dot="."$extension
    filename_no_extension=${filename%%${extension_with_dot}*}   # https://stackoverflow.com/questions/62657224/split-a-string-on-a-word-in-bash
    # various ways to get name without extension https://stackoverflow.com/questions/12152626/how-can-i-remove-the-extension-of-a-filename-in-a-shell-script
    echo -e "$DL\n$ver_and_filename\n$ver\n$filename\n$extension\n$filename_no_extension"

    [ ! -f /tmp/$filename ] && exe wget -nc --tries=3 -T20 --restrict-file-names=nocontrol -P /tmp/ $DL  # Timeout after 20 seconds

    # Try to use 'alien' to create a .rpm from a .deb:   alien --to-rpm <name>.deb   # https://forums.centos.org/viewtopic.php?f=54&t=75913
    # I can get this to work when running alien on Ubuntu, but alien fails with errors when running on CentOS.
    # Need to be able to do it from the CentOS system however to automate the install in this way.
    # In the end, looks like the 'alien' setup is not required as 'bat' will install into CentOS using dpkg(!)
    # But keep this code as might need for other packages to convert them.
    ### if [ "$manager" == "dnf" ] || [ "$manager" == "yum" ]; then        
    ###     # Don't need to worry about picking the latest version as unchanged since 2016
    ###     ALIENDL=https://sourceforge.net/projects/alien-pkg-convert/files/release/alien_8.95.tar.xz
    ###     ALIENTAR=alien_8.95.tar.xz
    ###     ALIENDIR=alien-8.95   # Note that the extracted dir has "-" while the downloaded file has "_"
    ###     exe wget -P /tmp/ $ALIENDL
    ###     tar xf $ALIENTAR
    ###     cd /tmp/$ALIENDIR
    ###     exe sudo $manager install perl -y
    ###     exe sudo $manager install perl-ExtUtils-Install -y
    ###     exe sudo $manager install make -y
    ###     sudo perl Makefile.PL
    ###     sudo make
    ###     sudo make install
    ###     cd ..
    ###     sudo alien --to-rpm $filename     # bat-musl_0.18.3_amd64.deb
    ###     # sudo rpm -ivh $FILE.rpm         # bat-musl-0.18.3-2.x86_64.rpm : note that the name has changed
    ###     # Ideally, we should create a folder, create the output in there, then grab the name from there, since the name can change
    ### fi

    which bat &> /dev/null || exe sudo dpkg -i /tmp/$filename   # if the 'bat' command is present, do nothing, otherwise install with dpkg
    # sudo dpkg -r bat   # to remove 'bat' if required
    # Also note that 'bat' is part of the 'bacula-console-qt' package but that is 48 MB for an entire backup tool
    # https://linuxconfig.org/how-to-install-deb-file-in-redhat-linux-8
    rm /tmp/$filename
fi



####################
#
print_header "Install exa (possible replacement for ls)"
#
####################
# WARNING!!! Could break system!
# sudo wget -P /tmp/ "http://ftp.nl.debian.org/debian/pool/main/g/glibc/libc6-udeb_2.32-4_amd64.udeb"
# sudo dpkg --install /tmp/libc6-udeb_2.32-4_amd64.udeb
# sudo wget -P /tmp/ "http://ftp.nl.debian.org/debian/pool/main/g/gcc-11/libgcc-s1_11.2.0-8_amd64.deb"
# sudo dpkg --install /tmp/libgcc-s1_11.2.0-8_amd64.deb
# sudo wget -P /tmp/ "http://ftp.nl.debian.org/debian/pool/main/r/rust-exa/exa_0.10.1-1_amd64.deb"
# sudo dpkg


####################
#
print_header "WSL Utilities"
#
####################
echo "https://github.com/wslutilities/wslu"
echo ""
echo ""
echo ""
# sudo apk add wslu
# Arch Linux
# AUR version of wslu is pulled due to that it violated its policy.
# 
# Download the latest package from release and install using the command: sudo pacman -U *.zst
# 
# CentOS/RHEL
# Add the repository for the corresponding Linux distribution:
# 
# CentOS 7: sudo yum-config-manager --add-repo https://download.opensuse.org/repositories/home:/wslutilities/CentOS_7/home:wslutilities.repo
# CentOS 8: sudo yum-config-manager --add-repo https://download.opensuse.org/repositories/home:/wslutilities/CentOS_8/home:wslutilities.repo
# Red Hat Enterprise Linux 7: sudo yum-config-manager --add-repo https://download.opensuse.org/repositories/home:/wslutilities/RHEL_7/home:wslutilities.repo
# Then install with the command sudo yum install wslu.
# 
# Debian / Kali
# You can install wslu with the following command:
# 
# sudo apt install gnupg2 apt-transport-https
# wget -O - https://pkg.wslutiliti.es/public.key | sudo tee -a /etc/apt/trusted.gpg.d/wslu.asc
# echo "deb https://pkg.wslutiliti.es/debian buster main" | sudo tee -a /etc/apt/sources.list
# sudo apt update
# sudo apt install wslu

# sudo apt install gnupg2 apt-transport-https
# wget -O - https://pkg.wslutiliti.es/public.key | sudo tee -a /etc/apt/trusted.gpg.d/wslu.asc
# echo "deb https://pkg.wslutiliti.es/kali kali-rolling main" | sudo tee -a /etc/apt/sources.list
# sudo apt update
# sudo apt install wslu

# Fedora
# sudo dnf copr enable wslutilities/wslu
# sudo dnf install wslu

####################
#
print_header "Update .bashrc so that it will load .custom during any interactive login sessions"
#
####################
# Object here is to carefully inject the required loader lines into ./bashrc. Intent is to only ever add two
# lines to ~/.bashrc, and only ever at the end of the file, so they will be pruned and re-attached to end of
# the file if required.
# (( grep for $thing in $file )) , or , (( echo $thing | tee --append $thing ))
# i.e. $expression1 || $expression2    where    $expression2 = echo $thing | tee --append $thing
# 'tee --append' is better than '>>' in general as it also permits updating protected files.
# e.g. echo "thing" >> ~/.bashrc      # fails as cannot update protected file (since the '>>' is not elevated)
#      sudo echo "thing" >> ~/.bashrc # also fails as the 'echo' is elevated, but '>>' is not(!)
# But: echo "thing" | sudo tee --append /etc/bashrc   # works as the 'tee' operation is elevated correctly.
# https://linux.die.net/man/1/grep
# https://stackoverflow.com/questions/3557037/appending-a-line-to-a-file-only-if-it-does-not-already-exist
# Could alternatively use sed for everything:
# https://unix.stackexchange.com/questions/295274/grep-to-find-the-correct-line-sed-to-change-the-contents-then-putting-it-back

# Backup ~/.custom
if [ ! -d $hh ]; then mkdir -p $hh; fi

if [ -f ~/.custom ]; then
    echo "Create Backup : $hh/.custom_$(date +"%Y-%m-%d__%H-%M-%S").sh"
    cp ~/.custom $hh/.custom_$(date +"%Y-%m-%d__%H-%M-%S").sh   # Need to rename this to make way for the new downloaded file
fi
if [ -f ~/.bashrc ]; then
    echo "Create Backup : $hh/.bashrc_$(date +"%Y-%m-%d__%H_%M_%S").sh"
    exe cp ~/.bashrc $hh/.bashrc_$(date +"%Y-%m-%d__%H_%M_%S").sh   # Backup .bashrc in case of issues
fi

### Note: removing GETCUSTOM, as it's a little pushy, and will fail on a non-internet connected system.
# Remove lines to trigger .custom at end of .bashrc (-v show everything except, -x full line match, -F fixed string / no regexp)
# https://stackoverflow.com/questions/28647088/grep-for-a-line-in-a-file-then-remove-the-line
# Remove our .custom from the end of .bashrc (-v show everything except our match, -q silent show no output, -x full line match, -F fixed string / no regexp)
# GETCUSTOM='[ ! -f ~/.custom ] && [[ $- == *"i"* ]] && curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > ~/.custom'
# grep -vxF "$GETCUSTOM" $rc > $rctmp.2    && sudo cp $rctmp.2 $rc

HEADERCUSTOM='# Dotsource .custom (download from GitHub if required)'
RUNCUSTOM='[ -f ~/.custom ] && [[ $- == *"i"* ]] && source ~/.custom'
rc=~/.bashrc
rctmp=$hh/.bashrc_$(date +"%Y-%m-%d__%H-%M-%S").tmp
if [ -f $rc ]; then
    grep -vxF "$HEADERCUSTOM" $rc > $rctmp.1 && sudo cp $rctmp.1 $rc   # grep to a .tmp file, then copy it back to the original
    grep -vxF "$RUNCUSTOM" $rc > $rctmp.3    && sudo cp $rctmp.3 $rc
    # If doing this with a system file (e.g. /etc/bashrc), just sudo the 'cp' part. i.e. grep <> /etc/bashrc > $rctmp && sudo cp /etc/bashrc

    # After removing our lines, make sure no empty lines at end of file, except for one required before our lines
    # Remove trailing whitepsace: https://stackoverflow.com/questions/4438306/how-to-remove-trailing-whitespaces-with-sed
    sed -i 's/[ \t]*$//' ~/.bashrc     # -i is in place, [ \t] applies to any number of spaces and tabs before the end of the file "*$"
    # Removes also any empty lines from the end of a file. https://unix.stackexchange.com/questions/81685/how-to-remove-multiple-newlines-at-eof/81687#81687
    sed -i -e :a -e '/^\n*$/{$d;N;};/\n$/ba' ~/.bashrc
    echo "" | tee --append ~/.bashrc   # Finally, add an empty line back in as a separator before our .custom call lines

    # Add lines to trigger .custom to end of .bashrc (-q silent show no output, -x full line match, -F fixed string / no regexp)
    echo $HEADERCUSTOM | tee --append ~/.bashrc
    echo $GETCUSTOM    | tee --append ~/.bashrc
    echo $RUNCUSTOM    | tee --append ~/.bashrc
fi

### .bash_profile checks ###
# In practice, the usage of the .bash_profile file is the same as the usage for the .bashrc file.
# Most .bash_profile files call the .bashrc file for the user by default. Then why do we have two
# different configuration files? Why can’t we do everything using a single file?
# Well, the short answer is freedom and convenience. The longer answer is as follows: Suppose, you
# wish to run a system diagnostic every time you log in to your Linux system. You can edit the
# configuration file to print the results or save it in a file. But you only wish to see it at
# startup and not every time you open your terminal. This is when you need to use the .bash_profile
# file instead of .bashrc.    Also: https://www.golinuxcloud.com/bashrc-vs-bash-profile/
# If ".bash_profile" is ever created, it takes precedence over .bashrc, *even* if it is empty, AND
# .bashrc will be suppressed and will NOT load in this case (just one of the crazy bash rules).
# To avoid this, we need to check for .bash_profile and whether it has contents.
# - If .bash_profile exists and is zero-length, simply delete it.
# - If .bash_profile exists is not zero length, then create a line to dotsource .bashrc so that .custom will also be called.
# - If .bash_profile exists and .bashrc does NOT exist, then add .custom lines to .bash_profile instead of .bashrc

if [ ! -s ~/.bash_profile ]; then   # This is specifically only if .bash_profile is zero-length (-z for zero-length is not available on some OS)
    echo "Deleting zero-size ~/.bash_profile to prevent overriding .bashrc"
    rm ~/.bash_profile &> /dev/null
fi

if [ -s ~/.bash_profile ]; then   # Only do this if a greater than zero size file exists
    echo "Existing ~/.bash_profile is not empty, so ensure line in ~/.bash_profile loads ~/.bashrc (and so then runs ~/.custom)"
    FIXBASHPROFILE='[ -f ~/.bashrc ] && . ~/.bashrc'
    grep -qxF "$FIXBASHPROFLIE" ~/.bash_profile || echo "$FIXBASHPROFILE" | tee --append ~/.bash_profile
fi

if [ -s ~/.bash_profile ] && [ ! -f ~/.bashrc ]; then   # Only do this if a greater than zero size file exists
    echo "Existing ~/.bash_profile is not empty, but ~/.bashrc does not exist. Ensure lines are in ~/.bash_profile to load ~/.custom"
    grep -qxF "$HEADERCUSTOM" ~/.bash_profile || echo "$HEADERCUSTOM" | tee --append ~/.bash_profile
    grep -qxF "$GETCUSTOM" ~/.bash_profile || echo "$GETCUSTOM" | tee --append ~/.bash_profile
    grep -qxF "$RUNCUSTOM" ~/.bash_profile || echo "$RUNCUSTOM" | tee --append ~/.bash_profile
fi



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
# Note: cannot >> back to the same file being read, so use "| sudo tee --append ~/.vimrc"
# Note: cannot have multiple spaces "   " in a line or can't grep -qxF on that as the spaces are stripped

ADDFILE=~/.vimrc
function addToFile() { grep -qxF "$1" $ADDFILE || echo $1 | tee --append $ADDFILE; }
addToFile '" Set simple syntax highlighting that is more readable than the default (also :set koehler)'
addToFile 'color industry'
addToFile '" Disable tabs (to get a tab, Ctrl-V<Tab>), tab stops are 4 chars, indents are 4 chars'
addToFile 'set expandtab tabstop=4 shiftwidth=4'
addToFile '" Allow saving of files as sudo if did not start vim with sudo'
addToFile "cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit"
addToFile '" Set F3 to toggle line numbers on/off'
addToFile 'noremap <F3> :set invnumber<CR>'
addToFile 'inoremap <F3> <C-O>:set invnumber<CR>'
addToFile '" Jump between windows with Ctrl-h/j/k/l'
addToFile 'nnoremap <C-H> <C-W>h'
addToFile 'nnoremap <C-J> <C-W>j'
addToFile 'nnoremap <C-K> <C-W>k'
addToFile 'nnoremap <C-L> <C-W>l'

# ADDLINE='" Set simple syntax highlighting that is more readable than the default (also :set koehler)'
# grep -qxF "$ADDLINE" ~/.vimrc || echo $ADDLINE | tee --append ~/.vimrc
# ADDLINE='color industry'
# grep -qxF "$ADDLINE" ~/.vimrc || echo $ADDLINE | tee --append ~/.vimrc

# Alternative way to auto-elevate vim (not sure if this works)
# ADDLINE='" command W w !sudo tee % >/dev/nullset expandtab tabstop=4 shiftwidth=4'



####################
#
print_header "Common changes to /etc/samba/smb.conf"
#
####################

# ToDo: add here generic changes to make sure that Samba will work, including some default sharing
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

# You’ll be able to browse through your command line history, simply start typing a few letters of the command and then use the arrow up and arrow down keys to browse through your history. This is similar to using Ctrl+r to do a reverse-search in your Bash, but a lot more powerful, and a feature I use every day.
# The .inputrc is basically the configuration file of readline - the command line editing interface used by Bash, which is actually a GNU project library. It is used to provide text related editing features, customized keybindings etc.
ADDFILE=~/.inputrc
function addToFile() { grep -qxF "$1" $ADDFILE || echo $1 | tee --append $ADDFILE; }
# Do not have extra spaces in lines (i.e. between ), as the grep above cannot handle them, so do not align all comments after the command etc
addToFile '$include /etc/inputrc'           # include settings from /etc/inputrc
addToFile '# Set tab completion for cd to be non-case sensitive'
addToFile 'set completion-ignore-case On # Set Tab completion to be non-case sensitive'
addToFile '"\e\C-e": alias-expand-line # Expand aliases, with Ctrl-Alt-l, additional to the default "Esc then Ctrl-e"'
addToFile '"\e[5~": history-search-backward # After Ctrl-r, release Ctrl, then PgUp to go backward'
addToFile '"\e[6~": history-search-forward # After Ctrl-r, release Ctrl, then PgDn to go forward'
addToFile '"\C-p": history-search-backward # After Ctrl-r, Ctrl-p to go backward (previous)'
addToFile '"\C-n": history-search-forward # After Ctrl-r, Ctrl-n to go forward (next)'

# INPUTRC='$include /etc/inputrc'   # include settings from /etc/inputrc
# grep -qxF "$INPUTRC" ~/.inputrc || echo $INPUTRC | sudo tee --append ~/.inputrc

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
print_header "Common changes to /etc/sudoers (/etc/sudoers.d/custom-rules)"
#
####################

# First, make sure that /etc/sudoers.d is enabled
custom_rules=/etc/sudoers.d/custom-rules

if ! sudo grep -q '^[@#]includedir /etc/sudoers.d$' /etc/sudoers; then
    sudo sed '$a\\n@includedir /etc/sudoers.d' /etc/sudoers > /etc/sudoers.new
    [ ! -d /etc/sudoers.d ] && sudo mkdir /etc/sudoers.d
    sudo visudo -c -f /etc/sudoers.new && sudo mv /etc/sudoers{.new,}
    echo "Create Backup : $hh/sudoers_$(date +"%Y-%m-%d__%H-%M-%S").sh"
    sudo cp /etc/sudoers $hh/sudoers_$(date +"%Y-%m-%d__%H-%M-%S").sh
fi

if [ -f $custom_rules ]; then
    echo "Create Backup : $hh/sudoers.d/custom_rules_$(date +"%Y-%m-%d__%H-%M-%S").sh"
    sudo cp $custom_rules $hh/custom_rules_$(date +"%Y-%m-%d__%H-%M-%S").sh
fi

# echo "   sudo visudo --file=/etc/sudoers.d/arash-extra-rules"
# echo "Automating this change will look something like the following, but do not do this as it will"
# echo "break /etc/sudoers in this format (so don't do this!):"
# echo "   # sed 's/env_reset$/env_reset,timestamp_timeout=600/g' /etc/sudoers \| sudo tee /etc/sudoers"
if ! [ -f /etc/sudoers.d/customrules ]; then

    echo "Automating changes to /etc/sudoers can make a system unbootable so we will"
    echo "only change a file under /etc/sudoers.d"
    echo "Note that if sudo breaks, you can run 'pkexec visudo' on some distros."
    echo "In pkexec visudo, fix any issues, copy in from a backup of /etc/sudoers"
    echo "See all options with 'man sudoers'"
    echo ""
    echo "Add a 10 hr timeout for sudo passwords to be re-entered for home systems:"
    echo "Add 'Defaults timestamp_timeout=600' to '/etc/sudoers.d/custom-rules'"
    echo "Note that mutiple Default statements on different lines/files will all be added."
    if [ ! -f $custom_rules ]; then
        sudo touch $custom_rules
        sudo chmod 0440 $custom_rules
    else
        if ! sudo grep -q '^# Defaults can be comma separated, or on multiple statements one per line' $custom_rules; then echo '# Defaults can be comma separated, or on multiple statements one per line' | sudo tee --append $custom_rules; fi
        if ! sudo grep -q '^Defaults timestamp_timeout=600' $custom_rules; then echo 'Defaults timestamp_timeout=600' | sudo tee --append $custom_rules; fi
    fi
    echo ""
fi

sudo visudo -c -f /etc/sudoers   # Will check all sudoer files

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
print_header "nnn -aA and cd on quit"
#
####################
# https://bleepcoder.com/nnn/631249390/conflicting-alias-and-cd-on-quit
# https://github.com/jarun/nnn/issues/689
# Vim provides built-in commands to print or change the current working directory without needing to exit vim. For example, you can run :cd ~ to change to your home directory or :pwd to print the current working directory. The nnn (n)vim plugin could serve as a much faster alternative to change the current working directory without needing to exit vim. In my case, I want to take advantage of nnn's fzz plugin to quickly change directories within vim. Somebody else raised an issue with the same interest: mcchrish/nnn.vim#57. Why would you want to change directories within vim? Well, there are many reasons. One might be that you want to run vim's builtin :make command, which invokes the Makefile on the current working directory.
# 
# I already have a working version. I had to modify both your nnn source code and the nnn vim plugin. @mcchrish agrees that this would be a neat feature to add (mcchrish/nnn.vim#57).


### ####################
### #
### print_header "Dotfile management"
### #
### ####################
### echo "The goal here is to create a folder for all dotfiles, then hard link them and so be able to"
### echo "create a git project that is easy to update / replicate on another system."
### echo "Using this script, and the dotfile project above it: https://github.com/gibfahn/dot/blob/main/link"
### echo ""
### echo ""
### echo ""



####################
####################
####################
####################
####################
#
print_header "HELP FILES : Create various help scripts for notes and tips and alias them in .custom"
#
####################
####################
####################
####################
####################

# Try to build a collection of common notes, summaries, tips, tricks to always be accessible from the console.
# This is a good template for creating help files for various summaries (could also do vim, tmux, etc)
# Note the "" surround $1 in exx() { echo "$1" >> $HELPFILE; } otherwise prefix/trailing spaces will be removed.
# Using echo -e to display the final help file, as printf requires escaping "%" as "%%" or "\045" etc)
# In .custom, we can then simply create aliases if that file exists.
# https://unix.stackexchange.com/questions/65803/why-is-printf-better-than-echo/65819#65819
# https://www.shellscript.sh/tips/echo/
# Both printf and echo -e have issues, but printf overall is probably better.
# Note escaping \$ \\, and " is little awkward, as requires \\\" (\\ => \ and \" => ").

#  ####################
#  # Quick help topics that can be defined in one-liners, basic syntax reminders for various tasks
#  ####################
#  # printf requires "\% characters to to be escaped as \" , \\ , %%. To get ' inside aliases use \" to open printf, e.g. alias x="printf \"stuff about 'vim'\n\""
#  # Bash designers seem to encourage not using aliases and only using functions, which eliminates this problem. https://stackoverflow.com/questions/67194736
#  # Example of using aliases for this:   alias help-listdirs="printf \"Several ways to list only directories:\nls -d */ | cut -f1 -d '/'\nfind \\. -maxdepth 1 -type d\necho */\ntree /etc -daifl   # -d (dirs only), -a (all, including hidden), -i (don't show tree structure), -f (full path), -l (don't follow symbolic links), -p (permissions), -u (user/UID), --du (disk usage)\n\""
#  # https://phoenixnap.com/kb/how-to-list-installed-packages-on-ubuntu   # https://phoenixnap.com/kb/uninstall-packages-programs-ubuntu
#  help-packages_apt() { fn-help "apt package management:" "info dir / info ls / def dir / def ls # Basic information on commands\napt show vim         # show details on the 'vim' package\napt list --installed   | less\napt list --upgradeable | less\napt remove vim       # uninstall a package (note --purge will also remove all config files)\n\napt-file searches packages for specific files (both local and from repos).\nUnlike 'dpkg -L', it can search also remote repos. It uses a local cache of package contents 'sudo apt-file update'\napt-file list vim    # (or 'apt-file show') the exact contents of the 'vim' package\napt-file search vim  # (or 'apt-file find') search every reference to 'vim' across all packages"; }

####################
#
echo "Copy Docker Aliases '.custom-dk' into the helper folder if this is an interactive session"
#
####################
if [ -f ./.custom-dk ] && [[ $- == *"i"* ]] && [[ ! $(pwd) == $HOME ]]; then
    cp ./.custom-dk $hh/
fi



####################
#
echo "Hyper-V VM Notes if this Linux is running inside a full VM"
#
####################

HELPFILE=$hh/help-hyperv.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small HyperV Help)\${NC}"
exx ""
exx "\${BYELLOW}***** To correctly change the resolution of the Hyper-V console\${NC}"
exx "Step 1: 'dmesg | grep virtual' to check, then 'sudo vi /etc/default/grub'"
exx "   Change: GRUB_CMDLINE_LINUX_DEFAULT=\\\"quiet splash\\\""
exx "   To:     GRUB_CMDLINE_LINUX_DEFAULT=\\\"quiet splash video=hyperv_fb:1920x1080\\\""
exx "Adjust 1920x1080 to your current monitor resolution."
exx "Step 2: 'sudo reboot', then 'sudo update-grub', then 'sudo reboot' again."
exx ""
exx "\${BYELLOW}***** Setup Guest Services so that text can be copied/pasted to/from the Hyper-V console\${NC}"
exx "From Hyper-V manager dashboard, find the VM, and open Settings."
exx "Go to Integration Services tab > Make sure Guest services section is checked."
exx ""
exx "\${BYELLOW}***** Adjust Sleep Settings for the VM\${NC}"
exx "systemctl status sleep.target   # Show current sleep settings"
exx "sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target   # Disable sleep settings"
exx "sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target   # Enable sleep settings again"
exx ""
exx "\""   # require final line with a single " to end the multi-line text variable
exx "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "GitHub, npm, gem, etc (call with 'help-apps-assorted')"
#
####################
HELPFILE=$hh/help-apps-assorted.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small GitHub, npm, gem, etc)\${NC}"
exx ""
exx "https://github.com/awesome-lists/awesome-bash   # \\\"A curated list of delightful Bash scripts and resources.\\\""
exx "git clone https://github.com/alexanderepstein/Bash-Snippets    # Very useful set of scripts:"
exx "    sudo ./install.sh all  # https://ostechnix.com/collection-useful-bash-scripts-heavy-commandline-users/"
exx "    # bak2dvd, bash-snippets, cheat, cloudup, crypt, cryptocurrency, currency, extras, geo, gist, .git, .github, lyrics,"
exx "    # meme, movies, newton, pwned, qrify, short, siteciphers, stocks, taste, tests, todo, transfer, weather, ytview"
exx "npm i -g movie-cli         # mayankchd/movie, access movie database from cli, 'movie Into The Wild', or 'movie Into The Wild :: Wild' to compare two movies"
exx "npm install -g mediumcli   # djadmin/medium-cli, a cli for reading Medium stories, 'medium -h'"
exx "npm install hget --save    # bevacqua/hget, A CLI and an API to convert HTML into plain text. npm install hget -g   (to install globally)"
exx "    # hget ponyfoo.com, hget file.html, cat file.html | hget,   hget echojs.com --root #newslist --ignore \\\"article>:not(h2)\\\""
exx "npm install -g moro        # getmoro/moro, A command line tool for tracking work hours, as simple as it can get. https://asciinema.org/a/106792 https://github.com/getmoro/moro/blob/master/DOCUMENTATION.md"
exx "git clone git://github.com/VitaliyRodnenko/geeknote.git   # Evernote cli client"
exx "gem install doing          # ToDo tool"
exx "git clone git://github.com/wting/autojump.git  # cd autojump, ./install.py or ./uninstall.py, j foo, jc foo, jo foo, jco foo"
exx "sudo apt install ranger    # console file manager with VI key bindings"
exx "sudo apt install taskwarrior   # 'task' to start, ToDo list https://taskwarrior.org/docs/"
exx "npm install battery-level      # https://github.com/gillstrom/battery-level"
exx "npm install --global brightness-cli   # https://github.com/kevva/brightness-cli"
exx "https://github.com/yudai/gotty   # publish console as a web application (written in Go)"
exx "https://github.com/cmus/cmus     # cli music player"
exx "npm i -g mdlt               # Metadelta CLI, advanced math utility, https://github.com/metadelta/mdlt"
exx "sudo apt install hub        # Better GitHub integration than git, https://hub.github.com/   hub clone github/hub"
exx "go get -v github.com/zquestz/s; cd $GOPATH/src/github.com/zquestz/s; make; make install   # Advanced web search, https://github.com/zquestz/s"
exx "Terminal Image Viewers:"
exx "sudo apt install fim   # Fbi IMproved, Linux frame buffer viewer that can also create ASCII art. https://ostechnix.com/how-to-display-images-in-the-terminal/"
exx "   fim -a dog.jpg   ;   fim -t dog.jpg   # -a auto-zoom, -t render ASCII art"
exx ""
exx "chronic: runs a command quietly unless it fails"
exx "combine: combine the lines in two files using boolean operations"
exx "errno: look up errno names and descriptions"
exx "ifdata: get network interface info without parsing ifconfig output"
exx "ifne: run a program if the standard input is not empty"
exx "isutf8: check if a file or standard input is utf-8"
exx "lckdo: execute a program with a lock held"
exx "mispipe: pipe two commands, returning the exit status of the first"
exx "parallel: run multiple jobs at once"
exx "pee: tee standard input to pipes"
exx "sponge: soak up standard input and write to a file"
exx "ts: timestamp standard input"
exx "vidir: edit a directory in your text editor"
exx "vipe: insert a text editor into a pipe"
exx "zrun: automatically uncompress arguments to command"
exx "\""   # require final line with a single " to end the multi-line text variable
exx "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "Fun Tools and Toys (call with 'help-toys-cli')"
#
####################
HELPFILE=$hh/help-toys-cli.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small Console Toys)\${NC}"
exx ""
exx "git clone https://gitlab.com/dwt1/shell-color-scripts ~/shell-color-scripts   # Set of simple colour ASCII scripts"
exx "   sudo cp -rf ~/shell-color-scripts /opt/"
exx "   alias colorscript='/opt/shell-color-scripts/colorscript.sh'"
exx "git clone https://gitlab.com/dwt1/wallpapers ~     # Set of wallpapers for desktops or testing ASCII graphics tools"
exx ""
exx "git clone https://github.com/pipeseroni/maze.py    # Simple curses pipes written in Python"
exx "git clone https://github.com/pipeseroni/pipes.sh   # pipes.sh, a pipe screensaver for cli (bash)"
exx "git clone https://github.com/pipeseroni/pipesX.sh  # Animated pipes terminal screensaver at an angle (bash)"
exx "git clone https://github.com/pipeseroni/snakes.pl  # Pipes written in Perl"
exx "git clone https://github.com/pipeseroni/weave.sh   # Weaving in terminal (bash)"
exx "https://www.tecmint.com/cool-linux-commandline-tools-for-terminal/"
exx "sudo $manager install cowsay xcowsay ponysay lolcat toilet   # https://www.asciiart.eu/faq"
exx "# Random Animal Effect"
exx "dir=/usr/share/cowsay/cows/; file=\\\$(/bin/ls -1 \\\"\$dir\\\" | sort –random-sort | head -1); cow=\\\$(echo \\\"\$file\\\" | sed -e \\\"s/\.cow//\\\")"
exx "/usr/games/fortune /usr/share/games/fortunes | cowsay -f \\\$cow"
exx "sudo $manager install lolcat     # pipe text, fortune, figlet, cowsay etcfor 256 colour rainbow effect. To install on CentOS:"
exx "   sudo yum install ruby install gcc g++ make automake autoconf curl-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel ruby-rdoc ruby-devel rubygems"
exx "   sudo gem install lolcat"
exx "sudo $manager install toilet     # pipe text, fortune, figlet, cowsay etc for coloured output   http://caca.zoy.org/wiki/toilet"
exx "# toilet -f mono9 -F metal \\\$(date)  ;  while true; do echo \\\"\\\$(date '+%D %T' | toilet -f term -F border --gay)\\\"; sleep 1; done"
exx "sudo $manager install boxes      # ascii boxes around text"
exx "sudo apt moo                     # an easter egg inside 'apt'"
exx "sudo $manager install funny-manpages # Installs various funny man pages"
exx "   baby celibacy condom date echo flame flog gong grope egrope fgrope party rescrog rm rtfm tm uubp woman (undocumented) xkill xlart sex strfry"
exx "cd /tmp; git clone https://github.com/bartobri/no-more-secrets.git   # No More Secrets (eye candy). Pipe text to it to garble that, then press any key to unscramble the text, like the film Sneakers"
exx "cd no-more-secrets; sudo make nms; sudo make sneakers; sudo make install                 # https://ostechnix.com/no-more-secrets-recreate-famous-data-decryption-effect-seen-on-sneakers-movie/"
exx "   ls -l | nms -f green -a       # To remove: 'sudo make uninstall', then delete the git folder"
exx "sudo $manager install chafa      # chafa convert images, including GIFs, to ANSI/Unicode character output for a terminal"
exx "sudo $manager install cmatrix    # cmatrix, colour matrix screensaver for terminal   http://www.asty.org/cmatrix/"
exx "sudo $manager install aafire     # A fireplace animation"
exx "sudo $manager install sl         # Stupd train animation, means as a way to teach you not to make the 'sl' typo instead of 'ls'. Daft."
exx "sudo $manager install aview      # asciiview elephant.jpg -driver curses   # Convert an image file into ASCII art"
exx "git clone https://github.com/Naategh/Funny-Scripts     # A few scripts (might remove this)"
exx "colorful-date.sh   Show date and time in a colorful way     extractor.sh   Simply extract any archived file"
exx "get-info.sh        Get some information from a domain       ip-tor.sh      Install tor and show public ip"
exx "length-finder.sh   Get length of a given string             mailer.sh      Send an email"
exx "movies.sh          Quick search that grabs relevant information about a movie"
exx "top-ips.sh         List all top hitting IP address to your webserver"
exx "turn-server-uploads.sh   Turn on or off Apache / Nginx / Lighttpd web server upload     web-server.sh   Simple web server"
exx ""
exx "rev (reverse), tac (cat backwards) and (nl) are not completely trivial, can be used to manipulate text while working on pipeline"
exx "sudo $manager install ddate      # Convert Gregorian dates to Discordian dates"
exx "sudo $manager rig                # Generate random name, address, zip code identities"
exx "sudo npm install -g terminalizer # Record Linux terminal and generate animated GIF"
exx "terminalizer record test     # To start a recording. End recording with CTRL+D or terminate the program using CTRL+C"
exx "After stopping, test.yml is created in the current directory. Edit configurations and the recorded frames as required"
exx "terminalizer play test       # replay your recording using the play command"
exx "terminalizer render test     # render your recording as an animated gif"
exx "To create a global configuration directory, use the init command. You can also customize it using the config.yml file"
exx "sudo $manager install trash-cli  # trash-cli, cli recoverable trashcan, https://pypi.org/project/trash-cli/"
exx ""
exx "sudo $manager nodejs npm; sudo npm install wikit -g  # wikit, wikipedia cli tool https://www.tecmint.com/wikipedia-commandline-tool/"
exx "sudo $manager install googler    # googler googler is a power tool to Google (web, news, videos and site search) from the command-line. It shows the title, URL and abstract for each result, which can be directly opened in a browser from the terminal. Results are fetched in pages (with page navigation). Supports sequential searches in a single googler instance."
exx "sudo $manager install browsh     # browsh text mode browser, can render anything, including videos on terminal https://www.brow.sh/"
exx "https://www.youtube.com/watch?time_continue=3&v=zqAoBD62gvo&feature=emb_logo"
exx "curl -u YourUsername:YourPassword -d status=\\\"Your status message\\\" http://twitter.com/statuses/update.xml   # update Twitter status message"
exx "Use 'pv' (pipe viewer) to slow print text by limiting the transfer rate:"
exx "URL=https://genius.com/Monty-python-the-knights-who-say-ni-annotated; content=\\\$(wget \\\$URL -q -O -); lynx -dump \\\$URL | sed -n '/HEAD/,/Aaaaugh/p' | pv -qL 50"
exx "Fancy meta tags radio stream output:"
exx "#$ ogg123 http://ai-radio.org"
exx "or"
exx "#$ wget -qO- http://ai-radio.org/128.opus | opusdec – – | aplay -qfdat"
exx "or"
exx "#$ curl -sLN http://ai-radio.org/128.opus | opusdec – – | aplay -qfdat"
exx "example output"
exx "http://ai-radio.org/chronos/.media/fancy_meta.gif"
exx ""
exx "Google Search Operators   https://www.yeahhub.com/top-8-basic-google-search-dorks-live-examples/"
exx "S.No.	Operator	Description	Example"
exx "1	intitle:    finds strings in the title of a page        intitle:'Your Text'"
exx "2	allintext:  finds all terms in the title of a page      allintext:'Contact'"
exx "3	inurl:      finds strings in the URL of a page          inurl:'news.php?id='"
exx "4	site:       restricts a search to a particular site or domain   site:yeahhub.com 'Keyword'"
exx "5	filetype:   finds specific types of files (doc, pdf, mp3 etc) based on file extension   filetype:pdf 'Cryptography'"
exx "6	link:       searches for all links to a site or URL     link:'example.com'"
exx "7	cache:      displays Google’s cached copy of a page     cache:yeahhub.com"
exx "8	info:       displays summary information about a page   info:www.example.com"
exx ""
exx "for i in {1..12}; do for j in \\\$(seq 1 \\\$i); do echo -ne \\\$iÃ—\\\$j=$((i*j))\\t;done; echo; done   # Multiplication tables"
exx "for i in {0..600}; do echo \\\$i; sleep 1; done | dialog --guage 'Installing Patches….' 6 40exx"
exx ""
exx "# AsciiAquarium   # Might also need: perl -MCPAN -e shell ; install Term::Animation"
exx "pt tar wget make libcurses-perl   # using 'package tool'"
exx "cd /tmp"
exx "wget http://search.cpan.org/CPAN/authors/id/K/KB/KBAUCOM/Term-Animation-2.4.tar.gz"
exx "tar -zxvf Term-Animation-2.4.tar.gz"
exx "cd Term-Animation-2.4/"
exx "sudo perl Makefile.PL && make && make test"
exx "sudo make install"
exx "cd /tmp"
exx "wget http://www.robobunny.com/projects/asciiquarium/asciiquarium.tar.gz --no-check-certificate"
exx "tar -zxvf asciiquarium.tar.gz"
exx "cd asciiquarium_1.1/"
exx "sudo cp asciiquarium /usr/local/bin"
exx "sudo chmod 0755 /usr/local/bin/asciiquarium"
exx ""
exx "\""   # require final line with a single " to end the multi-line text variable
exx "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "byobu terminal multiplexer (call with help-byobu)"
#
####################
# byobu cheat sheet / keybindings: https://cheatography.com/mikemikk/cheat-sheets/byobu-keybindings/
# byobu good tutorial: https://simonfredsted.com/1588   https://gist.github.com/jshaw/5255721
# Learn byobu (enhancement for tmux) while listening to Mozart: https://www.youtube.com/watch?v=NawuGmcvKus
# Learn tmux (all commands work in byobu also): https://www.youtube.com/watch?v=BHhA_ZKjyxo
# Tutorial Part 1 and 2: https://www.youtube.com/watch?v=R0upAE692fY , https://www.youtube.com/watch?v=2sD5zlW8a5E , https://www.youtube.com/c/DevInsideYou/playlists
# Byobu: https://byobu.org/​ , tmux: https://tmux.github.io/​ , Screen: https://www.gnu.org/software/screen/​
# tmux and how to configure it, a detailed guide: https://thevaluable.dev/tmux-config-mouseless/
# https://superuser.com/questions/423310/byobu-vs-gnu-screen-vs-tmux-usefulness-and-transferability-of-skills#423397

HELPFILE=$hh/help-byobu.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small byobu Help)\${NC}"
exx ""
exx "byobu is a suite of enhancements for tmux (which it is built on) with convenient shortcuts."
exx "Terminal multiplexers like tmux allow multiple panes and windows inside a single console."
exx "Note that byobu connects to already open sessions by default (tmux just opens a new session by default)."
exx "byobu keybindings can be user defined in /usr/share/byobu/keybindings/"
exx ""
exx "\${RED}BASIC NOTES\${NC}"
exx "Use, alias b='byobu' then 'b' to start, 'man byobu', F12-: then 'list-commands' to see all byobu terminal commands"
exx "byobu-<tab><tab> to see all bash commands, can 'man' on each of these"
exx "Shift-F1 (quick help, 'q' to exit), F1 (help/configuration UI, ESC to exit), F9 (byobu-config, but is same as F1)"
exx "Alt-F12 (toggle mouse support on/off), or F12-: then 'set mouse on' / 'set mouse off'"
exx "With mouse, click on panes and windows to switch. Scroll on panes with the mouse wheel or trackpad. Resize panes by dragging from edges"
exx "Mouse support *breaks* copy/paste, but just hold down 'Shift' while selecting text and it works fine."
exx "Byobu shortcuts can interfere with other application shortcuts. To toggle enabling/disabling byobu, use Shift-F12."
exx "Ctrl-Shift-F12 for Mondrian Square (just a toy). Press Ctrl-D to kill this window."
exx "F5 (reload profile, refresh status), Shift-F5 (toggle different status lines), Ctrl-Shift-F5 randomises status bar colours, to reset, use: rm ~/.byobu/color.tmux"
exx "Alt-F5 (toggle UTF-8 support, refresh), Ctrl-F5 (reconnect ssh/gpg/dbus sockets)"
exx "F7 (enter scrollback history), Alt-PgUp/PgDn (enter and move through scrollback), Shift-F7 (save history to '\$BYOBU_RUN_DIR/printscreen')"
exx "F12-: (to enable the internal terminal), then 'set mouse on', then ENTER to enable mouse mode."
exx "For other commands, 'list-commands'"
exx "F12-T (fullscreen graphical clock)"
exx "To completely kill your session, and byobu in the background, type F12-: then 'kill-server'"
exx "'b ls', 'b list-session' or 'b list-sessions'"
exx "On starting byobu, session tray shows:   u  20.04 0:-*      11d12h 0.00 4x3.4GHz 12.4G3% 251G2% 2021-04-27 08:41:50"
exx "u = Ubuntu, 20.04 = version, 0:~* is the session, 11d12h = uptime, 0.00 = ?, 4x3.40GHz = 3.4GHz Core i5 with 4 cores"
exx "12.4G3% = 12.4 G free memory, 3% CPU usage,   251G2% = 251 G free space, 2% used, 2021-04-27 08:41:50 = date/time"
exx ""
exx "\${RED}BASH COMMANDS\${NC}"
exx "byobu-<tab><tab> to see all byobu bash commands, can 'man <command>' on each of these"
exx "byobu-config              byobu-enable-prompt       byobu-launcher            byobu-quiet               byobu-select-session      byobu-tmux"
exx "byobu-ctrl-a              byobu-export              byobu-launcher-install    byobu-reconnect-sockets   byobu-shell               byobu-ugraph"
exx "byobu-disable             byobu-janitor             byobu-launcher-uninstall  byobu-screen              byobu-silent              byobu-ulevel"
exx "byobu-disable-prompt      byobu-keybindings         byobu-layout              byobu-select-backend      byobu-status"
exx "byobu-enable              byobu-launch              byobu-prompt              byobu-select-profile      byobu-status-detail"
exx ""
exx "\${RED}PANES\${NC}"
exx "Ctrl-F2 (vertical split F12-%), Shift-F2 (horizontal split, F12-|) ('|' feels like it should be for 'vertical', so this is a little confusing)"
exx "Shift-F3/F4 (jump between panes), Ctrl-F3/F4 (move a pane to a different location)"
exx "Shift-<CursorKeys> (move between panes), Shift-Alt-<CursorKeys> (resize a pane), Shift-F8 (toggle pane arrangements)"
exx "Shift-F9 (enter command to run in all visible panes)"
exx "Shift-F8 (toggle panes through the grid templates), F12-z (toggle fullscreen/restore for a pane)"
exx "Alt-PgUp (scroll up in current pane/window), Alt-PgDn (scroll down in current pane/window)"
exx "Ctrl-F6 or Ctrl-D (kill the current pane that is in focus), or 'exit' in that pane"
exx "Note: if the pane dividers disappear, press F5 to refresh status, including rebuilding the pane dividers."
exx "Shift-F8 (toggle panes through the grid templates)"
exx ""
exx "\${RED}WINDOWS\${NC}"
exx "F2 (new window in current session)"
exx "Alt-Left/Right or F3/F4 (toggle through windows), Ctrl-Shift-F3/F4 (move a window left or right)  "
exx "Ctrl-F6 or Ctrl-D (kill the current pane, *or* will kill the current window if there is only one pane), or 'exit' in that window"
exx "Ctrl-F8 (rename session)"
exx ""
exx "\${RED}SESSIONS\${NC}"
exx "Ctrl-Shift-F2 (new session i.e. a new tmux instance with only '0:-*'), Alt-Up/Down (toggle through sessions)"
exx "F12-S (toggle through sessions with preview)"
exx "F9: Enter command and run in all sessions"
exx "F6 (detach the current session, leaving session running in background, and logout of byobu/tmux)"
exx "Shift-F6 (detach the current, leaving session running in background, but do not logout of byobu/tmux)"
exx "F6 (detach session and logout), Shift-F6 (detach session and do not logout)"
exx "Alt-F6 (detach ALL clients but this one), Ctrl-F6 (kill pane that is in focus)"
exx "F8 (rename window)"
exx ""
exx "\""   # require final line with a single " to end the multi-line text variable
exx "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "tmux Help (call with 'help-tmux'):"
#
####################

HELPFILE=$hh/help-tmux.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small tmux Help)\${NC}"
exx ""
exx "C-b : (to enter command mode), then  :ls, :help, :set mouse on  (or other commands)"
exx "C-d  (Note: no C-b first!)  (Detach from a session, or C-b d or C-b D for interactive)"
exx "'M-' stands for 'Meta' key and is the Alt key on Linux"
exx "C-b ?  (list all key bindings)   C-z  (Suspend tmux)   C-q  (Unsuspend tmux)"
exx "tmux a  (Attach last session)    tmux a -t mysession   (Attach to mysession)"
exx "tmux ls (list sessions),  tmux a (attach),   tmux a -t <name> (attach named session)"
exx "tmux    (start tmux),    tmux new -s <name>,   tmux new -s mysession -n mywindow"
exx "tmux kill-session –t <name>  (kill a session)   tmux kill-server  (kill tmux server)"
exx ""
exx "\${BYELLOW}***** Panes (press C-b first):\${NC}"
exx "\\\"  (Split new pane up/down)                  %  (Split new pane left/right)"   # 3x spaces due to "\\\"
exx "z  (Toggle zoom of current pane)             x  (Kill current pane)"
exx "{ / }  (Swap current pane with previous pane / next pane)   t  (Show the time in pane)"
exx "q  (Display pane indexes)                    !  (Break current pane out of the window)"
exx "m  (Mark current pane, see :select-pane -m)  M  Clear marked pane"
exx "Up/Down/Left/Right    (Change pane in cursorkey direction, must let go of Ctrl)"
exx "C-Up/Down/Left/Right  (Resize the current pane in steps of 1 cell, must hold down Ctrl)"
exx "M-Left, M-Right  (Resize current pane in steps of 5 cells)"
exx "o  (Go to next pane in current window)       ;  (Move to the previously active pane)"
exx "C-o  (rotate panes in current window)       M-o  (Rotate panes backwards)"
exx "M-1 to M-5  (Arrange panes preset layouts: tiled, horizontal, vertical, main-hor, main-ver)"
exx ""
exx "\${BYELLOW}***** Windows (press C-b first):\${NC}"
exx "c       (Create a new window)         ,  (Rename the current window)"
exx "0 to 9  (Select windows 0 to 9)       '  (Prompt for window index to select)"
exx "s / w   (Window preview)              .  (Prompt for an index to move the current window)"
exx "w       (Choose the current window interactively)     &  (Kill the current window)"
exx "n / p   (Change to next / previous window)      l  (Change to previously selected window)"
exx "i       (Quick window info in tray)"
exx ""
exx "\${BYELLOW}***** Sessions (press C-b first):\${NC}"
exx "$  (Rename the current session)"
exx "( / )  (Switch 'attached' client to previous / next session)"
exx "L  Switch the attached client back to the last session."
exx "f  Prompt to search for text in open windows."
exx "r  Force redraw of the attached client."
exx "s  (Select a new session for the attached client interactively)"
exx "~  Show previous messages from tmux, if any."
exx "Page Up     Enter copy mode and scroll one page up."
exx "Space       Arrange the current window in the next preset layout."
exx "M-n         Move to the next window with a bell or activity marker."
exx "M-p         Move to the previous window with a bell or activity marker."
exx ""
exx "\${BYELLOW}***** Buffers (copy mode) \${NC}"
exx "[  (Enter 'copy mode' to use PgUp/PgDn etc, press 'q' to leave copy mode)"
exx "]  (View history / Paste the most recent text buffer)"
exx "#  (List all paste buffers     =  (Choose a buffer to paste, from a list)"
exx "-  Delete the most recently copied buffer of text."
exx "C-Up, C-Down"
exx "M-Up, M-Down"
exx "Key bindings may be changed with the bind-key and unbind-key commands."
exx ""
exx "\""   # require final line with a single " to close multi-line string
exx "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "tmux.conf Help (call with 'help-tmux-conf'):"
#
####################

HELPFILE=$hh/help-tmux-conf.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small tmux.conf Options)\${NC}"
exx ""
exx "Some useful options for ~/.tmux.conf"
exx ""
exx "# ~/.tmux.conf"
exx ""
exx "# unbind default prefix and set it to ctrl-a"
exx "unbind C-b"
exx "set -g prefix C-a"
exx "bind C-a send-prefix"
exx ""
exx "# make delay shorter"
exx "set -sg escape-time 0"
exx ""
exx "#### key bindings ####"
exx ""
exx "# reload config file"
exx "bind r source-file ~/.tmux.conf ; display \\\".tmux.conf reloaded!\\\""   # needed \\\ for the " here
exx ""
exx "# quickly open a new window"
exx "bind N new-window"
exx ""
exx "# synchronize all panes in a window"
exx "bind y setw synchronize-panes ; display \\\"toggle synchronize-panes!\\\""
exx ""
exx "# pane movement shortcuts (same as vim)"
exx "bind h select-pane -L"
exx "bind j select-pane -D"
exx "bind k select-pane -U"
exx "bind l select-pane -R"
exx ""
exx "# enable mouse support for switching panes/windows"
exx "set -g mouse-utf8 on"
exx "set -g mouse on"
exx ""
exx "#### copy mode : vim ####"
exx ""
exx "# set vi mode for copy mode"
exx "setw -g mode-keys vi"
exx ""
exx "# copy mode using 'Esc'"
exx "unbind ["
exx "bind Escape copy-mode"
exx ""
exx "# start selection with 'space' and copy using 'y'"
exx "bind -t vi-copy 'y' copy-selection"
exx ""
exx "# paste using 'p'"
exx "unbind p"
exx "bind p paste-buffer"
exx ""
exx "\""   # require final line with a single " to close multi-line string
exx "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "ps notes (call with 'help-ps')"
#
####################

HELPFILE=$hh/help-ps.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small ps Help)\${NC}"
exx ""
exx "To see every process on the system using standard syntax:"
exx "   ps -e  ,  ps -ef  ,  ps -eF  ,  ps -ely"
exx "To see every process on the system using BSD syntax:"
exx "   ps ax  ,  ps axu"
exx "To print a process tree:"
exx "   ps -ejH  ,  ps axjf"
exx "To get info about threads:"
exx "   ps -eLf  ,  ps axms"
exx "To get security info:"
exx "   ps -eo euser,ruser,suser,fuser,f,comm,label  ,  ps axZ  ,  ps -eM"
exx "To see every process running as root (real & effective ID) in user format:"
exx "   ps -U root -u root u"
exx "To see every process with a user-defined format:"
exx "   ps -eo pid,tid,class,rtprio,ni,pri,psr,pcpu,stat,wchan:14,comm"
exx "   ps axo stat,euid,ruid,tty,tpgid,sess,pgrp,ppid,pid,pcpu,comm"
exx "   ps -Ao pid,tt,user,fname,tmout,f,wchan"
exx "Print only the process IDs of syslogd:"
exx "   ps -C syslogd -o pid="
exx "Print only the name of PID 42:"
exx "   ps -q 42 -o comm="
exx ""
exx "https://www.ubuntupit.com/useful-examples-of-linux-ps-command-for-aspiring-sysadmins/"
exx ""
exx "\""   # require final line with a single " to close multi-line string
exx "echo -e \"\$HELPNOTES\\n\""
chmod 755 $HELPFILE



####################
#
echo "RHEL WSL2 Setup (call with 'help-wsl2redhat')"
#
####################

HELPFILE=$hh/help-wsl2-redhat.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small WSL2 RedHat Setup)\${NC}"
exx ""
exx "https://access.redhat.com/discussions/5398621"
exx "https://www.zdnet.com/article/red-hat-introduces-free-rhel-for-small-production-workloads-development-teams/"
exx "https://wsl.dev/mobyrhel8/"
exx ""
exx "1) Install RHEL in a Virtual Machine. Doesn't matter which. I used the boot iso as it is small, and you want to keep the install as minimal as possible to save time. You can always add any package later using dnf"
exx ""
exx "2) When installed, reboot into RHEL and login as root."
exx ""
exx "3) Create a tarball of the file system:"
exx ""
exx "cd /"
exx ""
exx "tar cvfzp rhel8.tar.gz bin dev etc home lib lib64 media opt run root sbin srv usr var"
exx ""
exx "Note: these are not all directories under / and are intentionally excluded"
exx ""
exx "4) transfer the file rhel8.tar.gz to host system; for easy, I use scp to copy to my server so I can grab it from any workstation"
exx ""
exx "5) Create the WSL instance by importing: wsl.exe --import RHEL rhel8.tar.gz --version 2"
exx ""
exx "6) create a shortcut to wsl -d rhel to start, or start manually."
exx ""
exx "After first start (it will start with user root) you can go to HKLU\Software\Microsoft\Windows\CurrentVersion\Lxss and change the defaultuid for your distro to whatever you want; typically this would be 1000 for the first user created."
exx ""
exx "Enjoy your new RHEL8 under WSL2 and install whatever software you need."
exx ""
exx "See: https://www.sport-touring.eu/old/stuff/rhel83-2.png"
exx ""
exx "\""   # require final line with a single " to close multi-line string
exx "echo -e \"\$HELPNOTES\\n\""
chmod 755 $HELPFILE



####################
#
echo "Bash shell notes (call with 'help-bash')"
#
####################
# https://www.tecmint.com/linux-command-line-bash-shortcut-keys/
# https://ostechnix.com/navigate-directories-faster-linux/
# https://itsfoss.com/linux-command-tricks/

# This is more for a help-file on loops and various structures
# for i in $(seq 1 9); do alias "hx${i}"="hx | tail -${i}0"; done   # for i in $(seq 1 9); do alias "hh${i}"="hh | tail -${i}0"; done   # 'History Hash', prefix '#' to eaxh command, useful for porting to documentation
# Following is now redundant but keep as example of alias generation:   for i in $(seq 1 9); do alias "h${i}"="h | tail -${i}0"; done   # Set h=history and h1..h9 for multiples of 10 lines

# [ -f $hh/help-bash.sh ] && alias help-bash='$hh/help-bash.sh'   # for .custom
HELPFILE=$hh/help-bash.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small bash Notes)\${NC}"
exx ""
exx "https://wiki.linuxquestions.org/wiki/Bash_tips"
exx ""
exx "\$EDITOR was originally for instruction-based editors like ed. When editors with GUIs (vim, emacs, etc), editing changed dramatically,"
exx "so \$VISUAL came about. \$EDITOR is meant for a fundamentally different workflow, but nobody uses 'ed' any more. Just setting \$EDITOR"
exx "is not enough e.g. git on Ubuntu ignores EDITOR and just uses nano (the compiled in default, I guess), so always set \$EDITOR and \$VISUAL."
exx "Ctrl-x then Ctrl-e is a bash built-in to open vim (\$EDITOR) automatically."
exx ""
exx "Test shell scripts with https://www.shellcheck.net/"
exx ""
exx "\${BYELLOW}***** Bash variables, special invocations, keyboard shortcuts\${NC}"
exx "\\\$\\\$  Get process id (pid) of the currently running bash script."
exx "\\\$n  Holds the arguments passed in while calling the script or arguments passed into a function inside the scope of that function. e.g: $1, $2… etc.,"
exx "\\\$0  The filename of the currently running script."
exx "\\<command> Run the original command, ignoring all aliases. e.g. \\ls"
exx ""
exx "-   e.g.  cd -      Last Working Directory"
exx "!!  e.g.  sudo !!   Last executed command"
exx "!$  e.g.  ls !$     Arguments of the last executed command"
exx "echo !?             Show error message of last run command"
exx ""
exx "touch a.txt b.txt c.txt"
exx "echo !^ –> display first parameter"
exx "echo !:1 –> also display first parameter"
exx "echo !:2 –> display second parameter"
exx "echo !:3 –> display third parameter"
exx "echo !$ –> display last (in our case 3th) parameter"
exx "echo !* –> display all parameters"
exx "!? finds the last command with its string argument. For example, if these are in history:"
exx "   1013 grep tornado /usr/share/wind"
exx "   1014 grep hurricane /usr/share/dict/words"
exx "   1015 wc -l /usr/share/dict/words"
exx "!?torn   will grep for tornado again, while !torn would search in vain for a command starting with torn."
exx "wc !?torn?:2   would also work, selecting argument 2 from the found command and run 'wc'. e.g. wc /usr/share/wind"
exx ""
exx "\${BYELLOW}***** Linux Keyboard Shortcuts\${NC}"
exx "https://www.howtogeek.com/howto/ubuntu/keyboard-shortcuts-for-bash-command-shell-for-ubuntu-debian-suse-redhat-linux-etc/"
exx "Ctrl-K (cut to end of line),           Ctrl-U (cut to start of line), these use the kill ring buffer in bash"
exx "Ctrl-Y (paste from kill ring buffer),  Ctrl-W (cut the word on the left side of the cursor)"
exx "Ctrl-R (recall: search history of used commands),   Ctrl-O (run found command),  Ctrl-G (do not run found command)"
exx "Ctrl-C (kill currently running terminal process),   Ctrl-Z (stop current process)  =>  (fg / bg / jobs)"
exx "Ctrl-D (logout of Terminal or ssh (or tmux) session"
exx "Ctrl-L (clear Terminal; much more useful than the 'clear' command as all info is retained, just scrolls the screen up)"
exx "Navigation Bindings:"
exx "Ctrl-A (or Home) / E (or End)  Move to start / end of current line"
exx "Alt -F / B  Move forward / backwards one wordCtrl-F / B  Move forward / backwards one character"
exx ""
exx "\${BYELLOW}***** Use AutoHotkey to enable Ctrl-Shift-PgUp/PgDn to control WSL console scrolling\${NC}"
exx "; Console scrolling with keyboard. The default in Linux is usually +PgUp, but as Windows Terminal"
exx "; already uses Ctrl-Shift-PgUp, use that also for Cmd / WSL windows."
exx "#IfWinActive ahk_class ConsoleWindowClass"
exx "^+PgUp:: Send {WheelUp}"
exx "^+PgDn:: Send {WheelDown}"
exx "#IfWinActive"
exx ""
exx "grep \\\`whoami\\\` /etc/passwd   # show current shell,   cat /etc/shells   # show available shells"
exx "sudo usermod --shell /bin/bash boss   , or ,   chsh -s /bin/bash   , or ,   vi /etc/passwd  # change default shell for user 'boss'"
exx ""
exx "\${BYELLOW}***** Breaking a hung SSH session\${NC}"
exx "Sometimes, SSH sessions hang and Ctrl+c will not work, so that closing the terminal is the only option. There is a little known solution:"
exx "Hit 'Enter', and '~', and '.' as a sequence and the broken session will be successfully terminated."
exx ""
exx "\${BYELLOW}***** Random points to remember\${NC}"
exx "sudo !!   - re-run previous command with 'sudo' prepended"
exx "use 'less +F' to view logfiles, instead of 'tail' (ctrl-c, shift-f, q to quit)"
exx "ctrl-x-e  - continue editing your current shell line in a text editor (uses \$EDITOR)"
exx "alt-.     - paste previous commands *argument* (useful for running multiple commands on the same resource)"
exx "reset     - resets/unborks your terminal"
exx ""
exx "\""   # require final line with a single " to close multi-line string
exx "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "Jobs (Background Tasks) (call with 'help-jobs')"
#
####################
# https://stackoverflow.com/questions/1624691/linux-kill-background-task
HELPFILE=$hh/help-jobs.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small Jobs, Ctrl-Z, bg)\${NC}"
exx ""
exx "Two main ways to create a background task:"
exx "1. Put '&' at the end of a command to start it in background:  sleep 300 &; bg -l; kill %"
exx "2. On a running task, press Ctrl-Z to suspend, then type 'bg' to change it to a background job"
exx ""
exx "Type 'jobs' to see all background jobs, and fg <job-number> to bring a job to the foreground"
exx ""
exx "To kill background jobs, refer to them by:   jobs -l   then use the number of the job"
exx "kill %1      # To stop a job (in this case, job [1]). Will NOT kill the job."
exx "kill %%      # To stop the most recent background job"
exx "kill -9 %1   # To kill a job (in this case, job [1]). This will fully kill the job."
exx "kill -9 %%   # To kill the most recent background job"
exx "kill all background tasks: kill -9 %%   # or, jobs -p | xargs kill -9"
exx ""
exx "In the bash shell, % introduces a job name. Job number n may be referred to as %n."
exx "Also refer to a prefix of the name, e.g. %ce refers to a stopped ce job. If a prefix matches more"
exx "than one job, bash reports an error. Using %?ce, on the other hand, refers to any job containing"
exx "the string ce in its command line. If the substring matches more than one job, bash reports an error."
exx "%% and %+ refer to the shell's notion of the current job, which is the last job stopped while it was"
exx "in the foreground or started in the background. The previous job may be referenced using %-. In output"
exx "pertaining to jobs (e.g., the output of the jobs command), the current job is always flagged with a +"
exx "and the previous job with a -. A single % (with no accompanying job specification) also refers to the"
exx "current job."
exx ""
exx "Also note 'skill' and 'killall' (though 'killall' is quite dangerous)."
exx ""
exx "\""   # require final line with a single " to close multi-line string
exx "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "Bash Tips  (show with 'help-bash-tips')"
#
####################
# When using printf, remember that "%" has to be escaped as "%%" or "\045", but
# this is much easier than 'echo -e' where almost everything has to be escaped.
# % => %%
# Inside ''  :  $ => \$, " => \\", ' is impossible, () => \(\)
# For awk lines, put inside "", then ' is literal, ()) are literal, " => \\\\\" (5x \)
# Inside ""  :  $() => \\$, but variables are handled differently, $3 => \\\\\$3 (5x \)
# \b => \\\\\\b (6x \) to prevent \b being intpreted as a 'backspace'
# $ => \$ , " => \\" , % => %%%% , %% => %%%%%%%% (will fold to %%%% then down to %% at final print )
HELPFILE=$hh/help-bash-tips.sh
zzz() { printf "$1\n" >> $HELPFILE; }   # echo without '-e'
printf "#!/bin/bash\n" > $HELPFILE
zzz "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
zzz 'HELPNOTES="'
zzz '${BCYAN}$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small Bash Tips)${NC}'
zzz ''
zzz '${BYELLOW}Example of splitting a string by another string (quite tricky in Bash):${NC}'
#    split() { str="LearnABCtoABCSplitABCaABCString"; delimiter=ABC; s=$str$delimiter; array=(); while [[ $s ]]; do array+=( "${s%%"$delimiter"*}" ); s=${s#*"$delimiter"}; done; declare -p array; echo $array; }
zzz '''split() { str=\\"LearnABCtoABCSplitABCaABCString\\"; delimiter=ABC; s=\$str\$delimiter; array=(); while [[ \$s ]]; do array+=( \\"\${s%%%%%%%%\\"\$delimiter\\"*}\\" ); s=\${s#*\\"\$delimiter\\"}; done; declare -p array; echo \$array; }'
zzz ''
zzz '${BYELLOW}Some structures to remember:${NC}'
zzz '[[ \\"\$(read -e -p \\"Ask a question? [y/N]> \\"; echo $REPLY)\\" == [Yy]*: ]]   # One-liner to get input'
zzz 'for i in {3..10}; do echo \$i; done     # Arbitrary loop from 3 to 10'
zzz 'for (( i=3; i<=10; i++ )); do echo -n \\"\$i \\"; done   # Another way using csh loop syntax'
zzz 'for i in \`seq 3 10\`; do echo \$i; done               # Another way using seq'
zzz 'i=0; while [ \$i -le 2 ]; do echo Number: \$i; ((i++)); done     # basic while loop based upon test condition'
zzz 'if [[ ( \$x -lt 10 ) && ( \$y -eq 0 ) ]]; then echo \\"\$x \$y\\"; fi  # if multiple conditions, then do something'
# BACKUPFILE=backup-$(date +%m-%d-%Y)
# archive=${1:-$BACKUPFILE}
# 
# find . -mtime -1 -type f -print0 | xargs -0 tar rvf "$archive.tar"
# echo "Directory $PWD backed up in archive file \"$archive.tar.gz\"."
# exit 0
zzz ''
zzz '${BYELLOW}Using ls or other commands inside for-loops:${NC}'
zzz 'It is bad practice to use ls as part of a for-loop, because the output can be uncertain.'
zzz 'Use ls for console use, but find is generally the right tool to get a set of files into a for-loop.'
zzz 'for i in \$(someCommand) is usually bad (unless the output is certain, such as \$(seq 1 9)). A better construct is:'
zzz 'someCommand | while read i; do ...; done          # This is much better than for i in \$(someCommand)'
zzz 'someCommand | while IFS= read -r i; do; ... done  # This is even better'
zzz 'It is ok to use a command inside a for-loop if the output is certain, e.g. for i in \$(seq 1 9)   would be fine.'
zzz 'You can also use the -ls predicate to mimic ls:   find . -maxdepth 1 -type f -ls'
zzz ''
zzz '"'   # require final line with a single " to end the multi-line text variable
zzz 'printf "$HELPNOTES"'
chmod 755 $HELPFILE



####################
#
echo "Package Tools (Background Tasks) (call with 'help-packages')"
#
####################
# https://stackoverflow.com/questions/1624691/linux-kill-background-task
HELPFILE=$hh/help-packages.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small Packages)\${NC}"
exx ""
exx "apt, apt-file, yum, dnf, alien, debtree"
exx ""
exx "alien converts a package to another format (primarily useful to run on Debian/Ubuntu and convert to deb to rpm):"
exx "sudo alien --to-rpm \\\$filename"
exx "alien converts between Red Hat rpm, Debian deb, Stampede slp, Slackware tgz, and Solaris pkg file formats."
exx "Then take that package to CentOS and install using dpkg/rpm"
exx ""
exx "apt-file search htop   # Show all files in all packages matching 'htop'"
exx "apt-file show htop     # Show all files contained in package 'htop'"
exx "htop: /usr/bin/htop"
exx "htop: /usr/share/applications/htop.desktop"
exx "htop: /usr/share/doc/htop/AUTHORS"
exx "htop: /usr/share/doc/htop/README"
exx "htop: /usr/share/doc/htop/changelog.Debian.gz"
exx "htop: /usr/share/doc/htop/copyright"
exx "htop: /usr/share/man/man1/htop.1.gz"
exx "htop: /usr/share/pixmaps/htop.png"
exx ""
exx "debtree htop           # Show a dependency tree for 'htop' and total size of all packages"
exx "\\\"htopz\\\" -> \\\"libncursesw6\\\" [color=blue,label=\\\"\\\(>= 6\\\)\\\"];"
exx "\\\"libncursesw6\\\" -> \\\"libtinfo6\\\" [color=blue,label=\\\"(= 6.2-0ubuntu2)\\\"];"
exx "\\\"libncursesw6\\\" -> \\\"libgpm2\\\";"
exx "\\\"htop\\\" -> \\\"libtinfo6\\\" [color=blue,label=\\\"(>= 6)\\\"];"
exx "// total size of all shown packages: 1263616"
exx "// download size of all shown packages: 314968"
exx ""
exx "debtree dpkg > dpkg.dot               # Generate the dependency graph for package dpkg and save the output to a file 'dpkg.dot'."
exx "dot -Tsvg -o dpkg.svg dpkg.dot        # Use dot to generate an SVG image from the '.dot' file."
exx "debtree dpkg | dot -Tpng > dpkg.png   # Generate the dependency graph for package dpkg as PNG image and save the resulting output to a file."
exx "debtree -b dpkg | dot -Tps | kghostview - &     # Generate the build dependency graph for package dpkg in postscript format and view the result using KDE's kghostview(1)"
exx ""
exx "\""   # require final line with a single " to close multi-line string
exx "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE




####################
#
echo "Help Tools (call with 'help-help')"
#
####################
HELPFILE=$hh/help-help.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small Help Tools)\${NC}"
exx ""
exx "https://ostechnix.com/3-good-alternatives-man-pages-every-linux-user-know/"
exx "***** TLDR++"
exx "https://ostechnix.com/search-study-and-practice-linux-commands-on-the-fly/"
exx "https://help.ubuntu.com/"
exx "http://manpages.ubuntu.com/   :   https://manpages.debian.org/"
exx ""
exx "https://explainshell.com/   # Extremely useful, deconstructs the meaning of a command."
exx "Try the following:   find -iname '*.txt' -exec cp {} /home/ostechnix/ \\;"
exx ""
exx "Look through man directories (1 to 8) and display the longest man page in each directory in descending order."
exx "It can take a few minutes depending upon the number of man pages. https://ostechnix.com/how-to-find-longest-man-page-in-linux/"
exx "for i in {1..8}; do f=/usr/share/man/man\\\$i/\\\$(ls -1S /usr/share/man/man\\\$i/ | head -n1); printf \\\"%s: %9d\\\\\\n\\\" \\\"\\\$f\\\" \\\$(man \\\"\\\$f\\\" 2>/dev/null | wc -l); done"
exx ""
exx "\${BYELLOW}***** man and info (installed by default) and pinfo\${NC}"
exx "man uname"
exx "info uname"
exx ""
exx "sudo yum install pinfo"
exx "pinfo uname       # cursor keys up/down to select highlight options and right/left to jumpt to those topics"
exx "# pinfo pinfo"
exx ""
exx "\${BYELLOW}***** bropages\${NC}"
exx "sudo apt install ruby-dev    # apt version"
exx "sudo dnf install ruby-devel  # dnf version"
exx "sudo gem install bropages"
exx "bro -h"
exx "# bro thanks       # add your email for upvote/downvotes"
exx "# bro thanks 2     # upvote example 2 in previous list"
exx "# bro ...no  2     # downvote example 2"
exx "# bro add find     # add an entry for 'find'"
exx ""
exx "\${BYELLOW}***** cheat\${NC}"
exx "sudo pip install cheat   # or: go get -u github.com/cheat/cheat/cmd/cheat, (or sudo snap install cheat, but snap does not work on WSL yet)"
exx "cheat find"
exx "# cheat --list     # list all entries"
exx "# cheat -h         # help"
exx ""
exx "\${BYELLOW}***** manly\${NC}"
exx "sudo pip install --user manly"
exx "# manly dpkg"
exx "# manly dpkg -i -R"
exx "manly --help       # help"
exx ""
exx "\${BYELLOW}***** kb\${NC}"
exx "pip install -U kb-manager"
exx ""
exx "\${BYELLOW}***** tldr\${NC}"
exx "sudo $manager install tldr   # Works on CentOS, but might not on Ubuntu"
exx "sudo $manager install npm"
exx "sudo npm install -g tldr     # Alternative"
exx "tldr find"
exx "# tldr --list-all  # list all cached entries"
exx "# tldr --update    # update cache"
exx "# tldr -h          # help"
exx ""
exx "\${BYELLOW}***** kmdr\${NC}"
exx "https://docs.kmdr.sh/get-started-with-kmdr-cl"
exx "sudo npm install kmdr@latest --global"
exx ""
exx "\${BYELLOW}***** tldr (tealdeer version: same example files as above tldr, but coloured etc)\${NC}"
exx "sudo $manager install tealdeer   # fails for me"
exx "sudo $manager install cargo      # 270 MB"
exx "cargo install tealdeer      # seems to install ok"
exx "export PATH=\\\$PATH:/home/\\\$USER/.cargo/bin   # And add to .bashrc to make permanent"
exx "# tldr --update"
exx "# tldr --list"
exx "# tldr --clear-cache"
exx "Alterntaive installation method:"
exx "wget https://github.com/dbrgn/tealdeer/releases/download/v1.4.1/tldr-linux-x86_64-musl"
exx "sudo cp tldr-linux-x86_64-musl /usr/local/bin/tldr"
exx "sudo chmod +x /usr/local/bin/tldr"
exx ""
exx "\${BYELLOW}***** how2 (free form questions, 'stackoverflow for the terminal')\${NC}"
exx "like man, but you can query it using natural language"
exx "sudo $manager install npm"
exx "npm install -g how-2"
exx "how2 how do I unzip a .gz?"
exx ""
exx "\""   # require final line with a single " to close multi-line string
exx "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "Apps (call with 'help-apps')"
#
####################
HELPFILE=$hh/help-apps.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small Apps)\${NC}"
exx ""
exx "Just a list of various apps..."
exx ""
exx "sudo apt install bashtop bpytop"
exx "https://www.osradar.com/install-bpytop-on-ubuntu-debian-a-terminal-monitoring-tool/"
exx "Very good guide of random tips for Linux to review"
exx "https://www.tecmint.com/51-useful-lesser-known-commands-for-linux-users/"
exx ""
exx "bc, dc, $(( )), calc, apcalc: Calculators, echo \\\"1/2\\\" | bc -l  # need -l to get fraction, https://unix.stackexchange.com/a/480316/441685"
exx "The factor command:   factor 182: 2 7 13"
exx "lynx elinks links2 w3m : console browsers"
exx "wyrd : text based calendar"
exx ""
exx "Some template structures: (also xargs seq etc)"
exx "for i in {1,2,3,4,5}; do echo \$i; done"
exx "Perform a command with different arguments:"
exx "for argument in 1 2 3; do command \$argument; done"
exx "Perform a command in every directory:"
exx "for d in *; do (cd \$d; command); done"
exx ""
exx "\""   # require final line with a single " to close multi-line string
exx "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "CLI Games (call with 'help-games-cli')"
#
####################
HELPFILE=$hh/help-games-cli.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small CLI Games)\${NC}"
exx ""
exx "Just a list of various console games:"
exx ""
exx "\${BYELLOW}The Classic Rogue Games: Angband / Crawl / Nethack / Rogue\${NC}"
exx "Note that Rogue was from 'bsdgames', but was moved into bsdgames-nonfree due to licensing"
exx "sudo apt install angband crawl nethack-console bsdgames-nonfree"
exx "Comparison of Nethack and Angband https://roguelikefan.wordpress.com/2012/08/12/nethack-and-angband/"
exx "'Angband is a more balanced game, but Zangband and PosChengband are crazy.' https://www.reddit.com/r/angband/comments/6ir244/angband_or_zangband/"
exx "There are ~100 variants of Angband: http://www.roguebasin.com/index.php?title=List_of_Angband_variantsexx"
exx "ZAngband / ToME 'Troubles of Middle-earth' / Moria / Sil   https://www.reddit.com/r/roguelikes/comments/3po8g0/comment/cw80nis/?utm_source=reddit&utm_medium=web2x&context=3"
exx "Sil seems to be mainly for Windows GUI   amirrorclear.net/flowers/game/sil/   http://angband.oook.cz/comic/"
exx "Roguelikes stem from a game called Rogue that was written before computers had graphics and instead used symbols"
exx "on the screen to represent a dungeon filled with monsters and treasure, that was randomly generated each time"
exx "you played. Rogue also had 'permanent death': you have only one life and must choose wisely lest you have to"
exx "start again. Finally, it had a system of unidentified items whose powers you must discover for yourself."
exx ""
exx "\${BYELLOW}Getting the latest version of Angband\${NC}   https://roguelikefan.wordpress.com/2014/08/"
exx "Building nightly builds: http://angband.oook.cz/forum/showthread.php?t=4302"
exx "Repo version is often behind the latest, so grab latest source from http://rephial.org/release"
exx "https://angband.readthedocs.io/en/latest/hacking/compiling.html#linux-other-unix"
exx "# Always git clone latest version:   git clone http://github.com/angband/angband"
exx "sudo apt-get install autoconf gcc libc6-dev libncurses5-dev libx11-dev \\   # Install required compilation tools"
exx "             libsdl1.2-dev libsdl-ttf2.0-dev libsdl-mixer1.2-dev libsdl-image1.2-dev \\"
exx "             libgtk2.0-dev libglade2-dev"
exx "# Run the autogen.sh to create the ./configure script"
exx "./autogen.sh"
exx "# To build Angband to be run in-place:"
exx "./configure --with-no-install [other options as needed]"
exx "make"
exx "# That creates an executable in the src directory. You can run it from the same directory where you ran make with:"
exx "src/angband"
exx "alias angband='~/angband/src/angband   # if you want a shortcut to this"
exx "# To see what command line options are accepted, use:"
exx "src/angband -?"
exx "# If you want to do a system install (making Angband available for all users on the system), make sure you add the users to the \\\"games\\\" group. Otherwise, when your users attempt to run Angband, they will get error messages about not being able to write to various files in the /usr/local/games/lib/angband folders."
exx "./configure --with-setgid=games --with-libpath=/usr/local/games/lib/angband --bindir=/usr/local/games"
exx "make"
exx "make install"
exx ""
exx "\${BYELLOW}sudo $manager console-games   # A collection of classic console games\${NC}"
exx "aajm, an, angband, asciijump, bastet, bombardier, bsdgames,cavezofphear,"
exx "colossal-cave-adventure, crawl, curseofwar, empire, freesweep, gearhead,"
exx "gnugo, gnuminishogi, greed, matanza, moria, nethack-console, netris, nettoe,"
exx "ninvaders, nsnake, nudoku, ogamesim, omega-rpg, open-adventure, pacman4console,"
exx "petris, robotfindskitten, slashem, sudoku, tetrinet-client, tint, tintin++,"
exx "zivot"
exx "sudo $manager animals   # A ridiculous game, guessing animals, waste of time..."
exx ""
exx "\${BYELLOW}CoTerminal Apps\${NC} (under active development in 2021, non-graphical puzzles and games with sound for Linux/OSX/Win, SpaceInvaders, Pacman, and Frogger, plus 10 puzzles. https://github.com/fastrgv?tab=repositories"
exx "cd /tmp"
exx "git clone https://github.com/fastrgv/CoTerminalApps"
exx "wget https://github.com/fastrgv/CoTerminalApps/releases/download/v2.3.4/co29sep21.7z"
exx ""
exx "./gnuterm.sh"
exx ""
exx "\${BYELLOW}sudo apt install bsdgames\${NC}"
exx "adventure, arithmetic, atc (Air Traffic Control), backgammon, battlestar, bcd, boggle, caesar, canfield, countmail, cribbage, dab, go-fish, gomoku, hack, hangman, hunt, mille, monop, morse, number, pig, phantasia, pom, ppt, primes, quiz, random, rain, robots, rot13, sail, snake, tetris, trek, wargames, worm, worms, wump, wtf"
exx ""
exx "adventure                     # Installed by default on Ubuntu, no package on CentOS"
exx "sudo apt install gnuchess     # GNU Chess, weird, just an engine"
exx "sudo apt install pacman4console  # Terminal version of Pac-man"
exx "sudo apt install greed        # Combination of Pac-man and Tron, move around a grid of numbers to erase as much as possible."
exx "sudo apt install moon-buggy   # moon-buggy, console graphical game, driving on the moon"
exx "sudo apt install moon-lander  # moon-lander, console graphical game, fly lunar module to surface of the moon"
exx "sudo apt install ninvaders    # Space Invaders"
exx "sudo apt install nsnake       # Snake game"
exx "sudo apt install nudoku       # Linux terminal sudoku game"
exx "sudo apt install sudoku       # Sudoku"
exx "sudo apt install bastet       # Tetris clone"
exx "ssh sshtron.zachlatta.com     # Multiplayer Online Tron Game, requires other players to connect to score"
exx ""
exx "\${BYELLOW}Alienwave (a good Galaga variant, you only have one life)\${NC}"
exx "cd /tmp"
exx "wget http://www.alessandropira.org/alienwave/alienwave-0.4.0.tar.gz"
exx "tar xvzf alienwave-0.4.0.tar.gz"
exx "cd alienwave   # note that the tar inside the gaz defines the folder name, so alienwave and not alienwave-0.4.0"
exx "sudo apt install libncurses5-dev libncursesw5-dev -y"
exx "sudo make"
exx "sudo make install"
exx "sudo cp alienwave /usr/games"
exx "alienwave # Start game"
exx ""
exx "\${BYELLOW}You Only Live Once\${NC}"
exx "cd /tmp"
exx "wget http://www.zincland.com/7drl/liveonce/liveonce005.tar.gz"
exx "cd linux   # weird, but the extracted directory is called 'linux'"
exx "./liveonce"
exx ""
exx "\${BYELLOW}Cgames (cmines, cblocks, csokoban)\${NC}"
exx "cd /tmp"
exx "git clone https://github.com/BR903/cgames.git"
exx "cd cgames"
exx "sudo ./configure --disable-mouse"
exx "sudo make"
exx "sudo make install"
exx ""
exx "\${BYELLOW}Vitetris (start with 'tetris', Tetris clone, best one available for terminal)\${NC}"
exx "cd /tmp"
exx "wget http://www.victornils.net/tetris/vitetris-0.57.tar.gz"
exx "tar xvzf vitetris-0.57.tar.gz"
exx "cd vitetris-0.57/"
exx "sudo ./configure"
exx "sudo make install"
exx "make install-hiscores"
exx "sudo make install-hiscores"
exx "tetris"
exx ""
exx "\${BYELLOW}2048-cli, move puzzles to make tiles that will create the number 2048.\${NC}"
exx "# sudo apt-get install libncurses5-dev"
exx "# sudo apt-get install libsdl2-dev libsdl2-ttf-dev"
exx "# sudo apt-get install 2048-cli"
exx "# 2048"
exx "wget https://raw.githubusercontent.com/mevdschee/2048.c/master/2048.c"
exx "gcc -o 2048 2048.c"
exx "./2048"
exx ""
exx "\${BYELLOW}Nettoe (tic-tac-toe variant, playable over the internet\${NC}"
exx "cd /tmp"
exx "git clone https://github.com/RobertBerger/nettoe.git"
exx "cd nettoe"
exx "sudo ./configure"
exx "sudo make"
exx "sudo make install"
exx "nettoe"
exx ""
exx "\${BYELLOW}ASCII-Rain (not a game, just terminal displaying rain :))\${NC}"
exx "cd /tmp"
exx "git clone https://github.com/nkleemann/ascii-rain.git "
exx "cd ascii-rain"
exx "sudo apt install libncurses-dev ncurses-dev -y"
exx "gcc rain.c -o rain -lncurses"
exx "./rain"
exx ""
exx "\${BYELLOW}My man, Terminal Pac-man game (arcade).\${NC}"
exx "https://myman.sourceforge.io/ https://sourceforge.net/projects/myman/"
exx "https://sourceforge.net/projects/myman/files/myman/myman-0.7.0/"
exx "cd /tmp"
exx "wget https://sourceforge.net/projects/myman/files/myman/myman-0.7.0/myman-0.7.0.tar.gz/download"
exx "sudo ./configure"
exx "sudo make"
exx "sudo make install"
exx ""
exx "\${BYELLOW}Robot Finds Kitten\${NC}"
exx "http://robotfindskitten.org/ Another easy-to-play Linux terminal game. In this game, a robot is supposed to find a kitten by checking around different objects. The robot has to detect items and find out whether it is a kitten or something else. The robot will keep wandering until it finds a kitten. Simon Charless has characterized robot finds kitten as 'less a game and more a way of life.'"
exx ""
exx "\${BYELLOW}Emacs Games (dunnet 'secret adventure', tetris)\${NC}"
exx "sudo $manager install emacs"
exx "Tetris: emacs -nw   # Then 'M-x tetris' (done by holding the Meta key, typically alt by default) and x then typing tetris and pressing enter. -nw flag for no-window to force terminal and not GUI."
exx "Doctor: emacs -nw at the terminal and then entering M-x doctor. Talk to a Rogerian psychotherapist who will help you with your problems. It is based on ELIZA, the AI program created at MIT in the 1960s."
exx "Dunnet: emacs -nw at the terminal and then entering M-x dunnet. Similar to Adventure, but with a twist."
exx "emacs -batch -l dunnet"
exx ""
exx "\${BYELLOW}sudo $manager install fractalnow\${NC} Fractal creation tool (fractalnow and qfractalnow GUI)"
exx ""
exx "\""   # require final line with a single " to close multi-line string
exx "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "GUI Games (call with 'help-games-gui')"
#
####################
HELPFILE=$hh/help-games-gui.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small GUI Games)\${NC}"
exx ""
exx "\${BYELLOW}xxx\${NC}"
exx "sudo $manager install nestopia   # The error was 'GLXBadFBConfig' ... try to fix"
exx "RetroPie ... try to fix"
exx ""
exx "\""   # require final line with a single " to close multi-line string
exx "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "Vim Notes (call with 'help-vim')"
#
####################
# Vim, Tips and tricks: https://www.cs.umd.edu/~yhchan/vim.pdf
# Vim, Tips And Tricks: https://www.tutorialspoint.com/vim/vim_tips_and_tricks.htm
# Vim, Tips And Tricks: https://www.cs.oberlin.edu/~kuperman/help/vim/searching.html
# 8 Vim Tips And Tricks That Will Make You A Pro User: https://itsfoss.com/pro-vim-tips/
# Intro to Vim Modes: https://irian.to/blogs/introduction-to-vim-modes/
# Vim, Advanced Guide: https://thevaluable.dev/vim-advanced/
# Vim, Advanced Cheat Sheet: https://vimsheet.com/advanced.html https://vim.fandom.com/wiki/Using_marks
# https://www.freecodecamp.org/news/learn-linux-vim-basic-features-19134461ab85/
# https://vi.stackexchange.com/questions/358/how-to-full-screen-browse-vim-help
# https://phoenixnap.com/kb/vim-color-schemes https://vimcolorschemes.com/sainnhe/sonokai
# https://stackoverflow.com/questions/28958713/vim-how-to-stay-in-visual-mode-after-fixing-indentation-with
# https://www.ubuntupit.com/100-useful-vim-commands-that-youll-need-every-day/

# [ -f /tmp/help-vim.sh ] && alias help-vim='/tmp/help-vim.sh' && alias help-vi='/tmp/help-vim.sh' && alias help-v='/tmp/help-vim.sh'   # for .custom
HELPFILE=$hh/help-vim.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small vim Help)\${NC}"
exx ""
exx ":Tutor<Enter>  30 min tutorial built into Vim."
exx "The clipboard or bash buffer can be accessed with Ctrl-Shift-v, use this to paste into Vim without using mouse right-click."
exx ":set mouse=a   # Mouse support ('a' for all modes, use   :h 'mouse'   to get help)."
exx ""
exx "\${BYELLOW}***** MODES   :h vim-modes-intro\${NC}"
exx "7 modes (normal, visual, insert, command-line, select, ex, terminal-job). The 3 main modes are normal, insert, and visual."
exx "i insert mode, Shift-I insert at start of line, a insert after currect char, Shift-A insert after line.   ':h A'"
exx "o / O create new line below / above and then insert, r / R replace char / overwrite mode, c / C change char / line."
exx "v visual mode (char), Shift-V to select whole lines, Ctrl-V to select visual block"
exx "Can only do visual inserts with Ctrl-V, then select region with cursors or hjkl, then Shift-I for visual insert (not 'i'), type edits, then Esc to apply."
exx "Could also use r to replace, or d to delete a selected visual region."
exx "Also note '>' to indent a selected visual region, or '<' to predent (unindent) the region."
exx ": to go into command mode, and Esc to get back to normal mode."
exx ""
exx "\${BYELLOW}***** MOTIONS\${NC}   :h motions"
exx "h/l left/right, j/k up/down, 'w' forward by word, 'b' backward by word, 'e' forward by end of word."
exx "^ start of line, $ end of line, 80% go to 80% position in the whole document. G goto line (10G is goto line 10)."
exx "'(' jump back a sentence, ')' jump forward a sentence, '{' jump back a paragraph, '}' jump forward a paragraph."
exx "Can combine commands, so 10j jump 10 lines down, 3w jump 3 words forward, 2} jump 2 paragraphs forward."
exx "/Power/   Go to the first line containing the string 'Power'."
exx "ddp       Swap the current line with the next one."
exx "g;        Bring back cursor to the previous position."
exx ":/friendly/m\$   Move the next line containing the string 'friendly' to the end of the file."
exx ":/Cons/+1m-2    Move two lines up the line following 'Cons'"
exx ""
exx "\${BYELLOW}***** EDITING\${NC}   :h edits"
exx "x  delete char under cursor, '11x' delete 11 char from cursor. 'dw' delete word, '3dw' delete 3 words, '5dd delete 5 lines."
exx ":10,18d delete lines 10 to 18 inclusive, r<char> replace char under cursor by another character."
exx "u  undo (or :u, :undo), Ctrl-r to redo (or :redo)."
exx ":w  write/save the currect file, :wq  write and quit, :q  quit current file, :q!  quit without saving."
exx "Copy/Paste: '5y' yank (copy)) 5 chars, '5yy' yank 5 lines. Then, move cursor to another location, then 'p' to paste."
exx "Cut/Paste: '5x' cut 5 chars (or '5d<space>'), '5dd' 5 lines downwards. Then move cursor to another location, then 'p' to paste."
exx ">> shift/indent current line, << unindent, 5>> indent 5 lines down from current position. 5<< unindent 5 lines, :h >>"
exx ":10,20> indent lines 10 to 20 by standard indent amount. :10,20< unindent same lines."
exx "(vim-commentary plugin), gc to comment visual block selected, gcgc to uncomment a region."
exx ""
exx "\${BYELLOW}***** HELP SYSTEM\${NC}   :h      Important to learn to navigate this.   ':h A', ':h I', ':h ctrl-w', ':h :e', ':h :tabe', ':h >>'"
exx "Even better, open the help in a new tab with ':tab help >>', then :q when done with help tab."
exx "Open all help"
exx "Maximise the window vertically with 'Ctrl-w _' or horizontally with 'Ctrl-w |' or 'Ctrl-w o' to leave only the help file open."
exx "Usually don't want to close everything, so 'Ctrl-w 10+' to increase current window by 10 lines is also good.   :h ctrl-w"
exx ""
exx "\${BYELLOW}***** SUBSTITUTION\${NC}   :h :s   :h s_flags"
exx "https://www.theunixschool.com/2012/11/examples-vi-vim-substitution-commands.html"
exx "https://www.thegeekstuff.com/2009/04/vi-vim-editor-search-and-replace-examples/"
exx ":s/foo/bar/  replace first occurence in current line only,  add 'g' to end for every occurence on line, and 'i' to be case insensitive."
exx ":%s/foo/bar/gi   replace every occurence on every line and case insensitive (% every line, g every occurence in range, i insensitive)."
exx ":5,10s/foo/bar/g   :5,\$s/foo/bar/g   replace in lines 5 to 10, replace in lines 5 to $ (end of file)."
exx ":%s/foo/bar/gci   adding /c will require confirmation for each replace, and /i for case insensitive."
exx ":s/\<his\>/her/   only replace 'his' if it is a complete word (caused by <>)."
exx ":%s/\(good\|nice\)/awesome/g   replace good or nice by awesome."
exx ":%s!\~!\= expand(\$HOME)!g   ~! will be replaced by the expansion of \$HOME ( /home/username/ )"
exx "In Visual Mode, hit colon and the symbol '<,'> will appear, then do :'<,'>s/foo/bar/g for replace on the selected region."
exx ":%s/example:.*\n/\0    tracker: ''\r/g   # finds any line with 'example: ...' and appends 'tracker: ''' underneath it"
exx ":g/./ if getcurpos()[1] % 2 == 0 | s/foo/bar/g | endif   # for each line that has content, get the line number and if an even line number, then do a substitution"
exx ":g/foo/ if getcurpos()[1] % 2 == 0 | s//bar/g | endif   # alternative approach to above where substitution pattern can be empty as it's part of the global pattern"
exx ":for i in range(2, line('$'),2)| :exe i.'s/foo/bar/g'|endfor   # yet another way using a 'for' loop"   # https://gist.github.com/Integralist/042d1d6c93efa390b15b19e2f3f3827a
exx "nmap <expr> <S-F6> ':%s/' . @/ . '//gc<LEFT><LEFT><LEFT>'   # Put into .vimrc then press Shift-F6 to interactively replace word at cursor globally (with confirmation)."
exx ""
exx "\${BYELLOW}***** BUFFERS\${NC}   :h buffers   Within a single window, can see buffers with :ls"
exx "vim *   Open all files in current folder (or   'vim file1 file2 file3'   etc)."
exx ":ls     List all open buffers (i.e. open files)   # https://dev.to/iggredible/using-buffers-windows-and-tabs-efficiently-in-vim-56jc"
exx ":bn, :bp, :b #, :b name to switch. Ctrl-6 alone switches to previously used buffer, or #ctrl-6 switches to buffer number #."
exx ":bnext to go to next buffer (:bprev to go back), :buffer <name> (Vim can autocomplete with <Tab>)."
exx ":bufferN where N is buffer number. :buffer2 for example, will jump to buffer #2."
exx "Jump between your last 'position' with <Ctrl-O> and <Ctrl-i>. This is not buffer specific, but it works. Toggle between previous file with <Ctrl-^>"
exx ""
exx "\${BYELLOW}***** WINDOWS\${NC}   :h windows-into  :h window  :h windows  :h ctrl-w  :h winc"
exx "vim -o *  Open all with horizontal splits,   vim -O *   Open all with vertical splits."
exx "<C-W>W   to switch windows (note: do not need to take finger off Ctrl after <C-w> just double press on 'w')."
exx "<C-W>N :sp (:split, :new, :winc n)  new horizontal split,   <C-W>V :vs (:vsplit, :winc v)  new vertical split"
exx ""
exx "\${BYELLOW}***** TABS\${NC}   :h tabpage   Tabbed multi-file editing is a available from Vim 7.0+ onwards (2009)."
exx "vim -p *   Open all files in folder in tabs (or   'vim -p file1 file2 file3' etc)."
exx ":tabnew, just open a new tab, :tabedit <filename> (or tabe), create a new file at filename; like :e, but in a new tab."
exx "gt/gT  Go to next / previous tab (and loop back to first/last tab if at end). Also: 1gt go to tab 1, 5gt go to tab 5."
exx "gt/gT are easier, but note :tabn (:tabnext or Ctrl-PgDn), :tabp (:tabprevious or Ctrl-PgUp), :tabfirst, :tablast, :tabrewind, tabmove 2 (or :tabm 2) to go to tab 2 (tabs are numbered from 1)"
exx "Note window splitting commands,  :h :new,  :h :vnew,  :h :split,  :h :vsplit, ..."
exx ":tabdo %s/foo/bar/g   # perform a substitution in all open tabs (the command following :tabdo operates on all tabs)."
exx ":tabclose   close current tab,   :tabonly   close all other tab pages except current one."
exx ":tabedit .   # Opens new tab, prompts for file to open in it. Use cursor keys to navigate and press enter on top of the file you wish to open."
exx "tab names are prefixed with a '+' if they have unsaved changes,  :w  to write changes."
exx ":set mouse=a   # Mouse support works with tabs, just click on a tab to move there."
exx ""
exx "\${BYELLOW}***** VIMRC OPTIONS\${NC}   /etc/vimrc, ~/.vimrc"
exx ":set number (to turn line numbering on), :set nonumber (to turn it off), :set invnumber (to toggle)"
exx "noremap <F3> :set invnumber<CR>   # For .vimrc, Set F3 to toggle line numbers on/off"
exx "inoremap <F3> <C-O>:set invnumber<CR>   # Also this line for the F3 toggle"
exx "cnoremap help tab help   # To always open help screens in a new tab, put this into .vimrc"
exx "color industry   # change syntax highlighting"
exx "set expandtab tabstop=4 shiftwidth=4   # Disable tabs (to get a tab, Ctrl-V<Tab>), tab stops to 4 chars, indents are 4 chars."
exx "cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit   # Allow saving of files as sudo if did not start vim with sudo"
exx "cnoreabbrev <expr> h getcmdtype() == \\\":\\\" && getcmdline() == 'h' ? 'tab help' : 'h'   # Always expand ':h<space>' to ':tab help'"
exx "nnoremap <space>/ :Commentary<CR>   \\\" / will toggle the comment/uncomment state of the current line (vim-commentry plugin)."
exx "vnoremap <space>/ :Commentary<CR>   \\\" / will toggle the comment/uncomment state of the visual region (vim-commentry plugin)."
exx ""
exx "\${BYELLOW}***** PLUGINS, VIM-PLUG\${NC}    https://www.linuxfordevices.com/tutorials/linux/vim-plug-install-plugins"
exx "First, install vim-plug:"
exx "curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
exx "Then add the following lines to ~/.vimrc"
exx "call plug#begin('~/.vim/plugged')"
exx "Plug 'https://github.com/vim-airline/vim-airline' \\\" Status bar"
exx "Plug 'https://github.com/junegunn/vim-github-dashboard.git'"
exx "Plug 'junegunn/vim-easy-align' \\\"For GitHub repositories, you can just mention the username and repository"
exx "Plug 'tyru/open-browser.vim' \\\" Open URLs in browser"
exx "Plug 'https://github.com/tpope/vim-fugitive' \\\" Git suppoty"
exx "Plug 'https://github.com/tpope/vim-surround' \\\" Surrounding ysw)"
exx "Plug 'https://github.com/preservim/nerdtree', { 'on': 'NERDTreeToggle' } \\\" NERDTree file explorer, on-demand loading"
exx "Plug 'https://github.com/ap/vim-css-color' \\\" CSS Color Preview"
exx "Plug 'https://github.com/tpope/vim-commentary' \\\" For Commenting gcc & gc"
exx "call plug#end()"
exx "Save ~/.vimrc with :w, and then source it with :source %"
exx "Now install the plugins with :PlugInstall  (a side window will appear as the repo's clone to to ~/.vim/plugged)"
exx "Restart Vim and test that the plugins have installed with :NERDTreeToggle (typing 'N'<tab> should be enough)"
exx "vim-fugitive : Git support, see https://github.com/tpope/vim-fugitive https://vimawesome.com/?q=tag:git"
exx "vim-surround : \\\"Hello World\\\" => with cursor inside this region, press cs\\\"' and it will change to 'Hello World!'"
exx "   cs'<q> will change to <q></q> tag, or ds' to remove the delimiter. When on Hello, ysiw] will surround the wordby []"
exx "nerdtree : pop-up file explorer in a left side window, :N<tab> (or :NERDTree, or use :NERDTreeToggle to toggle) :h NERDTree.txt"
exx "vim-css-color"
exx "vim-commentary : comment and uncomment code, v visual mode to select some lines then 'gc'<space> to comment, 'gcgc' to uncomment."
exx "Folloing will toggle comment/uncomment by pressing <space>/ on a line or a visual selected region."
exx "nnoremap <space>/ :Commentary<CR>"
exx "vnoremap <space>/ :Commentary<CR>"
exx ""
exx "\${BYELLOW}***** SPELL CHECKING / AUTOCOMPLETE\${NC}"
exx ":setlocal spell spelllang=en   (default 'en', or can use 'en_us' or 'en_uk')."
exx "Then,  :set spell  to turn on and  :set nospell  to turn off. Most misspelled words will be highlighted (but not all)."
exx "]s to move to the next misspelled word, [s to move to the previous. When on any word, press z= to see list of possible corrections."
exx "Type the number of the replacement spelling and press enter <enter> to replace, or just <enter> without selection to leave, mouse support can click on replacement."
exx "Press 1ze to replace by first correction Without viewing the list (usually the 1st in list is the most likely replacement)."
exx "Autocomplete: Say that 'Fish bump consecrate day night ...' is in a file. On another line, type 'cons' then Ctrl-p, to autocomplete based on other words in this file."
exx ""
exx "\${BYELLOW}***** SEARCH\${NC}"
exx "/ search forwards, ? search backwards are well known but * and # are less so."
exx "* search for word nearest to the cursor (forward), and # (backwards)."
exx "Can repeat a search with / then just press Enter, but easier to use n, or N to repeat a search in the opposite direction."
exx ""
exx "\${BYELLOW}***** PASTE ISSUES IN TERMINALS\${NC}"
exx "Paste Mode: Pasting into Vim sometimes ends up with badly aligned result, especially in Putty sessions etc."
exx "Fix that with ':set paste' to put Vim in Paste mode before you paste, so Vim will just paste verbatim."
exx "After you have finished pasting, type ':set nopaste' to go back to normal mode where indentation will take place again."
exx "You normally only need :set paste in terminals, not in GUI gVim etc."
exx ""
exx "dos2unix can change line-endings in a file, or in Vim we can use  :%s/^M//g  (but use Ctrl-v Ctrl-m to generate the ^M)."
exx "you can also use   :set ff=unix   and vim will do it for you. 'fileformat' help  :h ff,  vim wiki: https://vim.fandom.com/wiki/File_format."
exx ""
exx "\""   # require final line with a single " to close multi-line string
exx "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "grep Notes (call with 'help-grep')"
#
####################
# https://www.richud.com/wiki/Grep_one_liners
HELPFILE=$hh/help-grep.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small grep Notes)\${NC}"
exx ""
exx "https://manned.org/grep, https://tldr.ostera.io/grep"
exx ""
exx "\${BYELLOW}***** Useful content search with grep\${NC}   # https://stackoverflow.com/a/16957078/524587"
exx "grep -rnw '/path/to/somewhere/' -e 'pattern'"
exx "-r or -R is recursive, -n is line number, -w to match the whole word, -e is the pattern used during the search."
exx "Optional: -l (not 1, but lower-case L) can be added to only return the file name of matching files."
exx "Optional: --exclude, --include, --exclude-dir flags can be used to refine searches."
exx ""
exx "\${BYELLOW}***** Finding files with grep\${NC}   # https://stackoverflow.com/a/16957078/524587"
exx "grep -rnwl '/' -e 'python'   # Find all files that contain 'python' and return only filenames (-l)."
exx "grep --include=\*.{c,h} -rnw '/path/to/somewhere/' -e 'pattern'   # Only search files .c or .h extensions, show every matching line."
exx "grep --exclude=\*.o -rnw '/path/to/somewhere/' -e 'pattern'   # Exclude searching all the files ending with .o extension"
exx "It is possible to exclude one or more directories with --exclude-dir."
exx "e.g. exclude the dirs dir1/, dir2/ and all of them matching *.dst/"
exx "grep --exclude-dir={dir1,dir2,*.dst} -rnw '/path/to/somewhere/' -e 'pattern'"
exx "https://www.tecmint.com/find-a-specific-string-or-word-in-files-and-directories/"
exx ""
exx "grep \\\"search_pattern\\\" path/to/file   # Search for a pattern within a file"
exx "grep --fixed-strings \\\"exact_string\\\" path/to/file   # Search for an exact string (disables regular expressions)"
exx "grep --recursive --line-number --binary-files=without-match \\\"search_pattern\\\" path/to/directory   # all files recursively, showing line numbers and ignoring binary files"
exx "grep --extended-regexp --ignore-case \\\"search_pattern\\\" path/to/file   # extended regular expressions (supports ?, +, {}, () and |), in case-insensitive mode"
exx "grep --context|before-context|after-context=3 \\\"search_pattern\\\" path/to/file   # Print 3 lines of context around, before, or after each match"
exx "grep --with-filename --line-number \\\"search_pattern\\\" path/to/file   # Print file name and line number for each match"
exx "grep --only-matching \\\"search_pattern\\\" path/to/file   # Search for lines matching a pattern, printing only the matched text"
exx "cat path/to/file | grep --invert-match \\\"search_pattern\\\"   # Search stdin for lines that do not match a pattern"
exx ""
exx "\""   # require final line with a single " to end the multi-line text variable
exx "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "find Notes (call with 'help-find')"
#
####################
# https://www.richud.com/wiki/Grep_one_liners
HELPFILE=$hh/help-find.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small find Notes)\${NC}"
exx ""
exx "\${BYELLOW}***** Find files and directories (complex app, https://manned.org/find, https://tldr.ostera.io/find\${NC}"
exx "sudo find / -mount -name 'git-credential-manager*'            # -mount will ignore mounts, e.g. /mnt/c, /mnt/d, etc in WSL"
exx "find root_path -name '*.ext'                                  # files by extension"
exx "find root_path -path '**/path/**/*.ext' -or -name '*pattern*' # files matching multiple path/name patterns"
exx "find root_path -type d -iname '*lib*'                         # directories matching a given name, in case-insensitive mode"
exx "find root_path -name '*.py' -not -path '*/site-packages/*'    # files matching a given pattern, excluding specific paths"
exx "find root_path -size +500k -size -10M                         # files matching a given size range"
exx "find root_path -name '*.ext' -exec wc -l {} \;                # run a command for each file ({} within the command referends the filename)"
exx "# find root_path -daystart -mtime -7 -delete                  # files modified in the last 7 days and delete them"
exx "# find root_path -type f -empty -delete                       # Find empty (0 byte) files and delete them"
exx ""
exx "\""   # require final line with a single " to end the multi-line text variable
exx "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "Assorted Linux Commands (call with 'help-assorted')"
#
####################
# https://www.richud.com/wiki/Grep_one_liners
HELPFILE=$hh/help-assorted.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small Assorted Commands)\${NC}"
exx ""
exx "Various commands as a general refresher/reminder list ..."
exx "https://www.tecmint.com/51-useful-lesser-known-commands-for-linux-users/"
exx ""
exx "\${BYELLOW}***** Find\${NC}"
exx "grep [pattern] [file_name]         # Search for a specific pattern in a file with grep"
exx "grep -r [pattern] [directory_name] # Recursively search for a pattern in a directory"
exx "find [/folder/location] -name [a]  # List names that begin with a specified character [a] in a specified location [/folder/location] by using the find command"
exx "find [/folder/location] -size [+100M]  # See files larger than a specified size [+100M] in a folder"
exx "locate [name]                      # Find all files and directories related to a particular name"
exx ""
exx "gpg -c [file_name]  /  gpg [file_name.gpg]   # Encrypt (-c) or Decrypt a file"
exx "rsync -a [/your/directory] [/backup/]        # Synchronize the contents of a directory with a backup directory using the rsync command"
exx ""
exx "\${BYELLOW}***** Hardware\${NC}"
exx "dmesg                      # Show bootup messages"
exx "cat /proc/cpuinfo          # See CPU information"
exx "free -h                    # Display free and used memory with"
exx "lshw                       # List hardware configuration information"
exx "lsblk                      # See information about block devices"
exx "lspci -tv                  # Show PCI devices in a tree-like diagram"
exx "lsusb -tv                  # Display USB devices in a tree-like diagram"
exx "dmidecode                  # Show hardware information from the BIOS"
exx "hdparm -i /dev/disk        # Display disk data information"
exx "hdparm -tT /dev/[device]   # Conduct a read-speed test on device/disk"
exx "badblocks -s /dev/[device] # Test for unreadable blocks on device/disk"
exx ""
exx "\${BYELLOW}***** Users\${NC}"
exx "groupadd [group]    # Add new group"
exx "adduser [user]                 # Add a new user"
exx "usermod -aG [group] [user]     # Add to a group"
exx "userdel [user]                 # Delete a user"
exx "usermod                        # Modify a user"
exx "id      # Details about active users,     last     # Show last system login"
exx "who     # Show currently logged on,       w        # Show logged on users activity"
exx "whoami        # See which user you are using"
exx "finger [username]"
exx ""
exx "\${BYELLOW}***** Tasks, Processes, Jobs\${NC}"
exx "pstree   # Show processes in a tree-like diagram"
exx "pmap     # Display a memory usage map of processes"
exx "kill [process_id]     # Terminate a Linux process under a given ID"
exx "pkill [proc_name]     # Terminate a process under a specific name"
exx "killall [proc_name]   # Terminate all processes labelled “proc”"
exx "Cltr-Z to suspend a task, then 'bg' to put into background as a job"
exx "bg  /  jobs   # List and resume jobs in the background"
exx "fg            # Bring the most recently suspended job to the foreground"
exx "fg [job]      # Bring a particular job to the foreground"
exx "lsof          # List files opened by running processes"
exx "last reboot   # List system reboot history"
exx "cal           # Calendar"
exx "w             # List logged in users"
exx ""
exx "\${BYELLOW}***** Disk space usage\${NC}"
exx "df -h      # Free inodes on mounted filesystems"
exx "df -i      # Display disk partitions and types"
exx "fdisk -l   # Display disk partitions, sizes, and types with the command"
exx "du -ah     # See disk usage for all files and directory"
exx "du -sh     # Show disk usage of the directory you are currently in"
exx "findmnt    # Display target mount point for all filesystem"
exx "mount [device_path] [mount_point]   # Mount a device"
exx ""
exx "\${BYELLOW}***** File permissions\${NC}"
exx "chmod 777 [file_name]   # Assign read, write, and execute permission to everyone"
exx "chmod 755 [file_name]   # Give read, write, and execute permission to owner, and read and execute permission to group and others"
exx "chmod 766 [file_name]   # Assign full permission to owner, and read and write permission to group and others"
exx "chown [user] [file_name]   # Change the ownership of a file"
exx "chown [user]:[group] [file_name]   # Change the owner and group ownership of a file"
exx ""
exx "\${BYELLOW}***** Networking\${NC}"
exx "ip addr show      # List IP addresses and network interfaces"
exx "ip address add [IP_address]   # Assign an IP address to interface eth0"
exx "ifconfig          # Display IP addresses of all network interfaces with"
exx "netstat -pnltu    # See active (listening) ports with the netstat command"
exx "netstat -nutlp    # Show tcp and udp ports and their programs"
exx "whois [domain]    # Display more information about a domain"
exx "dig [domain]      # Show DNS information about a domain using the dig command"
exx "dig -x host       # Do a reverse lookup on domain"
exx "dig -x [ip_address]   # Do reverse lookup of an IP address"
exx "host [domain]     # Perform an IP lookup for a domain"
exx "hostname -I       # Show the local IP address"
exx ""
exx "\""   # require final line with a single " to end the multi-line text variable
exx "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "netstat Notes (call with 'help-netstat')"
#
####################
# https://www.richud.com/wiki/Grep_one_liners
HELPFILE=$hh/help-netstat.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small netstat)\${NC}"
exx ""
exx "netstat (ntcommand statistics). Overview of network activities and displays which ports are open or have established connections. Essential for discovering network problems. Part of the 'net-tools' package. Though still widely used, netstat is considered obsolete, and ss command is recommended as a faster and simpler tool."
exx ""
exx "Terminal output of the netstat"
exx "The first list in the output displays active established internet connections on the computer. The following details are in the columns:"
exx "Proto – Protocol of the connection (TCP, UDP)."
exx "Recv-Q – Receive queue  of bytes received or ready to be received."
exx "Send-Q – Send queue of bytes ready to be sent."
exx "Local address – Address details and port of the local connection. An asterisk (*) in the host indicates that the server is listening and if a port is not yet established."
exx "Foreign address– Address details and port of the remote end of the connection. An asterisk (*) appears if a port is not yet established."
exx "State – State of the local socket, most commonly ESTABLISHED, LISTENING, CLOSED or blank."
exx ""
exx "The second list shows all active 'Unix Domain' open sockets with the following details:"
exx "Proto – Protocol used by the socket (always unix)."
exx "RefCnt – Reference count of the number of attached processes to this socket."
exx "Flags – Usually ACC or blank."
exx "Type – The socket type."
exx "State – State of the socket, most often CONNECTED, LISTENING or blank."
exx "I-Node – File system inode (index node) associated with this socket."
exx "Path – System path to the socket."
exx "For advanced usage, expand the netstat command with options:"
exx ""
exx "netstat -a    # List All Ports and Connections"
exx "netstat -at   # List All TCP Ports"
exx "netstat -au   # List All UDP Ports"
exx "netstat -l    # List Only Listening Ports"
exx "netstat -lt   # List TCP Listening Ports"
exx "netstat -lu   # List UDP Listening Ports"
exx "netstat -lx   # List UNIX Listening Ports"
exx "Note: Scan for open ports with nmap as an alternative."
exx "netstat -s    # Display Statistics by Protocol"
exx "netstat -st   # List Statistics for TCP Ports"
exx "netstat -su   # List Statistics for UDP Ports"
exx "netstat -i    # List Network Interface Transactions"
exx "netstat -ie   # Add the option -e to netstat -i to extend the details of the kernel interface table:"
exx "netstat -M    # Display Masqueraded Connections"
exx "netstat -tp   # Display the PID/Program name related to a specific connection by adding the -p option to netstat. For example, to view the TCP connections with the PID/Program name listed, use:"
exx "netstat -lp   # Find Listening Programs"
exx "netstat -r    # Display Kernel IP Routing Table"
exx "netstat -g    # Display IPv4 and IPv6 Group Membership"
exx "netstat -c    # Print netstat Info Continuously"
exx "netstat -ic   # e.g. To print the kernel interface table continuously, run:"
exx "netstat --verbose   # Find Unconfigured Address Families at the end of '--verbose'"
exx "netstat -n    # Display Numerical Addresses, Host Addresses, Port Numbers, and User IDs. By default, addresses, port numbers, and user IDs are resolved into human-readable names when possible. Knowing the unresolved port number is important for tasks such as SSH port forwarding."
exx "netstat --numeric-hosts    # Display Numerical Host Addresses"
exx "netstat --numeric-ports    # Display Numerical Port Numbers"
exx "netstat --numeric-users    # Display Numerical User Ids"
exx "netstat -an | grep ':[port number]'   # Find a Process That Is Using a Particular Port"
exx "netstat -an | grep ':80'   # e.g. What process is using port 80?"
exx ""
exx "\""   # require final line with a single " to end the multi-line text variable
exx "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "cron Notes (call with 'help-cron')"
#
####################
# https://www.guru99.com/crontab-in-linux-with-examples.html
# https://stackoverflow.com/questions/4672383/how-to-run-cronjobs-more-often-than-once-per-minute
# rsync --archive --verbose --delete /home/valorin/ /mnt/c/Users/valorin/wsl2-backup/
# Using Windows Task Scheduler to automate WSL operations (Windows Task starts wsl.exe and then runs a bash script to run a backup)
# https://stephenreescarter.net/automatic-backups-for-wsl2/
# Note: In my tests, rsync will occasionally mark things as not up-to-date due to permission differences only (Linux has permissions that conflict with what it gets from looking at the Windows copy of the file). I think what happens in this case is that rsync notes the difference, but since it is not a content difference no copying is done. Instead, rsync will just try to change the permissions of the target system. Since the target system is Windows, this attempt to change permissions is ineffective and basically a waste of time.
# Bottom line: if instead of using –archive (which is equivalent to rlptgoD), you drop the permission related options (which do not really do anything anyway) and just use the -rltD, you may see a speed up for large amounts of files. At least, it did in my testing.
# Alternative is to use robocopy from Windows to backup WSL \\wsl$\Ubuntu\home\boss
# Does it wake up the WSL instance if it’s offline and you’re trying to access it via \\wsl$\ ?
# net use u: \\wsl$\Ubuntu
# robocopy /mir u:\home\myuser\sites\ C:\ubuntu-sites-backup\
# net use u: /delete
# RoboCopy pull from \\WSL$\Ubuntu   # 15,157,379 Bytes/sec
# rsync to /mnt/s/backupdir          #  2,338,573 Bytes/sec
HELPFILE=$hh/help-cron.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small cron Help)\${NC}"
exx ""
exx "crontab -e   will edit current users cron"
exx "crontab -e   will edit current users cron"
exx "crontab -a <filename>:   create a new <filename> as crontab file"
exx "crontab -e:   edit our crontab file or create one if it doesn’t already exist"
exx "crontab -l:   show up our crontab file"
exx "crontab -r:   delete our crontab file"
exx "crontab -v:   show up the last time we have edited our crontab file"
exx ""
exx "crontab layout  =>  minute(s) hour(s) day(s) month(s) weekday(s) command(s)"
exx ""
exx "minute(s)   0-59"
exx "hour(s)     0-23"
exx "day(s)      1-31  Calendar day of the month"
exx "month(s)    1-12  Calendar month of the year (can also use Jan ... Dec)"
exx "weekday(s)  0-6   Day 0 is Sun (can also use Sun, Mon, Tue, Wed, Thu, Fri, Sat)"
exx "command(s)        rest of line is free form with spaces for the command to be executed"
exx "There are several special symbols:  *  /  -  ,"
exx "*   Represents all of the range The number inside,"
exx "/   'every', e.g. */5 means every 5 units, in the first column this would be every 5 minutes"
exx "-   'from a number to a number'"
exx ",   'separate several discrete numbers', e.g. 0,5,18,47 in first column would run at these minutes of the hour"
exx ""
exx "0 6 * * * echo \\\"Good morning.\\\" >>/tmp/crontest.txt         # 6 o'clock every morning"
exx "# Note that you can't see any output from the screen, as cron emails any output to root's mailbox."
exx "0 23-7/2,8 * * * echo \\\"Night work.\\\" >>/tmp/crontest.txt   # Every 2 hours between 11pm and 8am AND at 8am (the ',8')"
exx "0 11 1 * 1-3 command line    # on the 1st of every month and every Monday to Wednesday at 11 AM"
exx ""
exx "Whenever a user edits their cron settings, a file with the same name as the user is generated at /var/spool/cron."
exx "Do not edit this document at /var/spool/cron, only edit this with crontab -e."
exx "After cron is started, this file is read every minute to check whether to execute the commands inside."
exx "Therefore, there is no need to restart the cron service after this file is modified. 2. Edit/etc/crontab file to configure cron 　　cron service not only reads all files in/var/spool/cron once per minute, but also needs to read/etc/crontab once, so we can configure this file to use cron service to do some thing. The configuration with crontab is for a certain user, while editing/etc/crontab is a task for the system. The file format of this file is: 　　SHELL=/bin/bash"
exx "Every two hours"
exx "PATH=/sbin:/bin:/usr/sbin:/usr/bin"
exx "MAILTO=root//If there is an error or there is data output, the data will be sent to this account as an email"
exx "HOME=///The path where the user runs, here It is the root directory"
exx "# run-parts"
exx "01 * * * * root run-parts/etc/cron.hourly//Execute the script in/etc/cron.hourly every hour"
exx "02 4 * * * root run-parts/etc/cron. daily//Execute the scripts in/etc/cron.daily every day"
exx "22 4 * * 0 root run-parts/etc/cron.weekly//Execute the scripts in/etc/cron.weekly every week"
exx "42 4 1 * * root run -parts/etc/cron.monthly//month to execute scripts in the/etc/cron.monthly"
exx "attention to \\\"run-parts\\\" of this argument, if this parameter is removed, then later you can write a script to run Name instead of folder name."
exx ""
exx "# Autostart cron in WSL:"
exx "sudo tee /etc/profile.d/start_cron.sh <<EOF"
exx "if ! service cron status &> /dev/null; then"
exx "  sudo service cron start"
exx "fi"
exx "EOF"
exx ""
exx "you can use this service to start automatically when the system starts:"
exx "at the end of /etc/rc.d/rc.local script plus: /sbin/service crond start"
exx ""
exx "service cron start    # Start the service"
exx "service cron stop     # Close the service"
exx "service cron status   # Show staus of the service"
exx "service cron restart  # Restart the service"
exx "service cron reload   # Reload the configuration"
exx ""
exx "Starting/stopping cron manually:"
exx "$ ~/custom_bash $ sudo service cron start"
exx " * Starting periodic command scheduler cron             [ OK ]"
exx "$ sudo service cron stop  "
exx " * Stopping periodic command scheduler cron             [ OK ]"
exx ""
exx "/etc/crontab: system-wide crontab"
exx "Unlike any other crontab you don't have to run the 'crontab'"
exx "command to install the new version when you edit this file"
exx "and files in /etc/cron.d. These files also have username fields,"
exx "that none of the other crontabs do."
exx ""
exx "SHELL=/bin/sh"
exx "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin"
exx ""
exx "\${BYELLOW}Example of job definition:\${NC}"
exx "\${BCYAN}.---------------- minute (0 - 59)"
exx "\${BCYAN}|  .------------- hour (0 - 23)"
exx "\${BCYAN}|  |  .---------- day of month (1 - 31)"
exx "\${BCYAN}|  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ..."
exx "\${BCYAN}|  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat"
exx "\${BCYAN}|  |  |  |  |\${NC}"
exx "*  *  *  *  * user-name command to be executed"
exx "17 *    * * *   root    cd / && run-parts --report /etc/cron.hourly"
exx "25 6    * * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )"
exx "47 6    * * 7   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )"
exx "52 6    1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )"
exx ""
exx "Edit the crontab file for the current user:"
exx "crontab -e"
exx ""
exx "Edit the crontab file for a specific user:"
exx "sudo crontab -e -u user"
exx ""
exx "Replace the current crontab with the contents of the given file:"
exx "crontab path/to/file"
exx ""
exx "View a list of existing cron jobs for current user:"
exx "crontab -l"
exx ""
exx "Remove all cron jobs for the current user:"
exx "crontab -r"
exx ""
exx "Sample job which runs at 10:00 every day (* means any value):"
exx "0 10 * * * command_to_execute"
exx ""
exx "Sample job which runs every minute on the 3rd of April:"
exx "* * 3 Apr * command_to_execute"
exx ""
exx "Sample job which runs a certain script at 02:30 every Friday:"
exx "30 2 * * Fri /absolute/path/to/script.sh"
exx ""
exx "https://stackoverflow.com/questions/9619362/running-a-cron-every-30-seconds"
exx ""
exx "\""   # require final line with a single " to end the multi-line text variable
exx "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "awk Notes (show with 'help-awk')"
#
####################
# https://linoxide.com/useful-awk-one-liners-to-keep-handy/
# https://unixutils.blogspot.com/2006/12/handy-one-liners-for-awk.html
# https://knowstar.org/blog/unix-awk-one-liners.html
# https://www.shebanglinux.com/best-awk-one-liners/
# http://softpanorama.org/Tools/Awk/awk_one_liners.shtml

HELPFILE=$hh/help-awk.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small awk Notes)\${NC}"
exx ""
exx "\${BYELLOW}***** Useful AWK One-Liners to Keep Handy\${NC}"
exx "Search and scan files line by line, splits input lines into fields, compares input lines/fields to pattern and performs an action on matched lines."
exx ""
exx "\${BYELLOW}***** Text Conversion (sub, gsub operations on tabs and spaces)\${NC}"
exx "awk NF contents.txt       # The awk NF variable will delete all blank lines from a file."
exx "awk '/./' /contents.txt   # Alternative way to delete all blank lines."
exx "awk '{ sub(/^[ \t]+/, \\\"\\\"); print }' contents.txt   # Delete leading whitespace and Tabs from the beginning of each line"
exx "awk '{ sub(/[ \t]+$/, ""); print }' contents.txt   # Delete trailing whitespace and Tabs from the end of each line"
exx "awk '{ gsub(/^[ \t]+|[ \t]+$/, \\\"\\\"); print }' contents.txt   # Delete both leading and trailing whitespaces from each line"
exx ""
exx "Following is a well known awk one-liner that records all lines in an array and arrange them in reverse order."
exx "awk '{ a[i++] = \\\$0 } END { for (j=i-1; j>=0;) print a[j--] }' contents.txt   # Arrange all lines in reverse order"
exx "Run this awk one-liner to arrange all lines in reverse order in file contents.txt:"
exx ""
exx "Use the NF variable to arrange each field (i.e. words on line) in each line in reverse order."
exx "awk '{ for (i=NF; i>0; i--) printf(\\\"\%s \\\", \\\$i); printf (\\\"\\\n\\\") }' contents.txt"
exx ""
exx "\${BYELLOW}***** Remove duplicate lines\${NC}"
exx "awk 'a != \\\$0; { a = \\\$0 }' contents.txt   # Remove consecutive duplicate lines from the file"  # $0 => \\\$0
exx "awk '!a[\\\$0]++' contents.txt         # Remove Nonconsecutive duplicate lines"
exx ""
exx "\${BYELLOW}***** Numbering and Calculations (FN, NR)\${NC}"
exx "awk '{ print NR \\\"\\\t\\\" \\\$0 }' contents.txt               # Number all lines in a file"
exx "awk '{ printf(\\\"%5d : %s\\\n\\\", NR, \\\$0) }' contents.txt   # Number lines, indented, with colon separator"
exx "awk 'NF { \\\$0=++a \\\" :\\\" \\\$0 }; { print }' contents.txt    # Number only non-blank lines in files"
exx "awk '/engineer/{n++}; END {print n+0}'  contents.txt     # You can number only non-empty lines with the following command:"
exx "Print number of lines that contains specific string"
exx ""
exx "\${BYELLOW}***** Regular Expressions\${NC}"
exx "In this section, we will show you how to use regular expressions with awk command to filter text or strings in files."
exx ""
exx "awk '/engineer/' contents.txt   # Print lines that match the specified string"
exx "awk '!/jayesh/' contents.txt    # Print lines that don't matches specified string"
exx "awk '/rajesh/{print x};{x=\\\$0}' contents.txt   # Print line before the matching string"
exx "awk '/account/{getline; print}' contents.txt   # Print line after the matching string"
exx ""
exx "\${BYELLOW}***** Substitution\${NC}"
exx "awk '{gsub(/engineer/, \\\"doctor\\\")};{print}' contents.txt   # Substitute 'engineer' with 'doctor'"
exx "awk '{gsub(/jayesh|hitesh|bhavesh/,\\\"mahesh\\\");print}' contents.txt   # Find the string 'jayesh', 'hitesh' or 'bhavesh' and replace them with string 'mahesh', run the following command:"
exx ""
exx "df -h | awk '{print \\\$1, \\\$4}'   # Find Free Disk Space with Device Name"   # $1 => \\\$1, $4 => \\\$4
exx "A useful list of open connections to your server sorted by amount (useful if suspect server attacks)."
exx "netstat -ntu | awk '{print \\\$5}' | cut -d: -f1 | sort | uniq -c | sort -n   # Find Number of open connections per ip"
exx ""
exx "Print the fifth column (a.k.a. field) in a space-separated file:"
exx "awk '{print \\\$5}' filename"
exx ""
exx "Print the second column of the lines containing \\\"foo\\\" in a space-separated file:"
exx "awk '/foo/ {print \\\$2}' filename"
exx ""
exx "Print the last column of each line in a file, using a comma (instead of space) as a field separator:"
exx "awk -F ',' '{print \\\$NF}' filename"
exx ""
exx "Sum the values in the first column of a file and print the total:"
exx "awk '{s+=\\\$1} END {print s}' filename"
exx ""
exx "Print every third line starting from the first line:"
exx "awk 'NR%3==1' filename"
exx ""
exx "Print different values based on conditions:"
exx "awk '{if (\\\$1 == \\\"foo\\\") print \\\"Exact match foo\\\"; else if (\\\$1 ~ \\\"bar\\\") print \\\"Partial match bar\\\"; else print \\\"Baz\\\"}' filename"
exx ""
exx "Print all lines where the 10th column value equals the specified value :"
exx "awk '(\\\$10 == value)'"
exx ""
exx "Print all the lines which the 10th column value is between a min and a max :"
exx "awk '(\\\$10 >= min_value && \\\$10 <= max_value)'"
exx ""
exx "\""   # require final line with a single " to end the multi-line text variable
exx "echo -e \"\$HELPNOTES\\n\""
chmod 755 $HELPFILE



####################
#
echo "sed Notes (show with 'help-sed')"
#
####################
# https://linuxhint.com/newline_replace_sed/
HELPFILE=$hh/help-sed.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small sed Notes)\${NC}"
exx ""
exx "\${BYELLOW}***** Useful AWK One-Liners to Keep Handy, work in progress\${NC}"
exx "Good sed tutorial https://linuxhint.com/newline_replace_sed/"
exx "Remove whitespace https://linuxhint.com/sed_remove_whitespace/"
exx ""
exx "\""   # require final line with a single " to end the multi-line text variable
exx "echo -e \"\$HELPNOTES\\n\""
chmod 755 $HELPFILE



####################
#
echo "find Notes (call with 'help-git')"
#
####################
# https://www.richud.com/wiki/Grep_one_liners
HELPFILE=$hh/help-git.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
exx "HELPNOTES=\""
exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small git & GitHub Notes)\${NC}"
exx ""
exx "\${BYELLOW}***** Various git & GitHub notes\${NC}"
exx "Passwords to access GitHub were banned in August 2021, you must generate a token on your account and use that"
exx "Two ways to create a new GitHub project"
exx "gh auth login --with-token < ~/.mytoken   # login to GitHub account"
exx "git init my-project                       # create a new project normally with git, creates the folder and .git subfolder"
exx "cd my-project"
exx "gh repo create my-project --confirm --public   # change to --private if required"
exx "cd ..; rm -rf my-project                  # Delete the project locally so that we can clone it with authentication"
exx "git clone --depth=1 https://roysubs:my-project@github.com/roysubs/my-project; }"
# This function is a work in progress, to automate the above, only problem is deleting folders can be risky if an existing project is there, have to make it check if the folder exists or if the project exists on GitHub already
# githubnew() { [ $# -ne 3 ] && echo "123" && return; gh auth login --with-token < $3; git init $2; cd $2; gh repo create $2 --confirm --public; cd ..; rm -rfi $2; git clone --depth=1 https://$1:$3@github.com/$1/$2; }
# This function shows all public projects for a given username
# getgituser() { curl -s https://api.github.com/users/$1/repos?per_page=1000 | grep git_url | awk '{print $2}'| sed 's/"\(.*\)",/\1/'; }   # Get all visible repositories for a given git account $1 https://stackoverflow.com/questions/42832359/how-to-search-repositories-with-github-api-v3-based-on-language-and-user-name
# Parse a git branch. Have taken these 3 functions out of .custom as trying to reduce the size there.
# gitbranch() { git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'; }   
exx ""
exx "\""   # require final line with a single " to end the multi-line text variable
exx "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "WSL integration (show with 'help-wsl'), only run this if WSL is detected"
#
####################

# Test if running in WSL, and if so, create /tmp/help-wsl with important WSL notes
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then

    echo ""
    echo "The following lines in a PowerShell console on Windows will alter the jarring Windows Event sounds that affect WSL sessions:"
    echo ""
    echo '$toChange = @(".Default","SystemAsterisk","SystemExclamation","Notification.Default","SystemNotification","WindowsUAC","SystemHand")'
    echo 'foreach ($c in $toChange) { Set-ItemProperty -Path "HKCU:\AppEvents\Schemes\Apps\.Default\$c\.Current\" -Name "(Default)" -Value "C:\WINDOWS\media\ding.wav" }'
    
    # Go ahead and run the PowerShell to adjust the system as it's such a minor/useful alteration
    powershell.exe -NoProfile -c '$toChange = @(".Default","SystemAsterisk","SystemExclamation","Notification.Default","SystemNotification","WindowsUAC","SystemHand"); foreach ($c in $toChange) { Set-ItemProperty -Path "HKCU:\AppEvents\Schemes\Apps\.Default\$c\.Current\" -Name "(Default)" -Value "C:\WINDOWS\media\ding.wav" }' 2>&1
    
    # https://devblogs.microsoft.com/commandline/windows-terminal-tips-and-tricks/
    # Now create /tmp/help-wsl.sh
    # [ -f /tmp/help-wsl.sh ] && alias help-wsl='/tmp/help-wsl.sh'   # for .custom
    HELPFILE=$hh/help-wsl.sh
    exx() { echo "$1" >> $HELPFILE; }
    echo "#!/bin/bash" > $HELPFILE
    exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
    exx "HELPNOTES=\""
    exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small WSL Help)\${NC}"
    exx ""
    exx "You can start the distro from the Ubuntu icon on the Start Menu, or by running 'wsl' or 'bash' from a PowerShell"
    exx "or CMD console. You can toggle fullscreen on WSL/CMD/PowerShell (native consoles or also in Windows Terminal sessions)"
    exx "with 'Alt-Enter'. Registered distros are automatically added to Windows Terminal."
    exx ""
    exx "Right-click on WSL title bar and select Properties, then go to options and enable Ctrl-Shift-C and Ctrl-Shift-V"
    exx "To access WSL folders: go into bash and type:   explorer.exe .    (must use .exe or will not work),   or, from Explorer, \\wsl$"
    exx "From here, I can use GUI tools like BeyondCompare (to diff files easily, much easier than pure console tools)."
    exx ""
    exx "Run the following to alter the jarring Windows Event sounds inside WSL sessions (it is run automatically by custom_bash.sh):"
    exx "\\\$toChange = @(\\\".Default\\\",\\\"SystemAsterisk\\\",\\\"SystemExclamation\\\",\\\"Notification.Default\\\",\\\"SystemNotification\\\",\\\"WindowsUAC\\\",\\\"SystemHand\\\")"
    exx "foreach (\\\$c in \\\$toChange) { Set-ItemProperty -Path \\\"HKCU:\\\AppEvents\\\Schemes\\\Apps\\\.Default\\\\\\\$c\\\.Current\\\" -Name \\\"(Default)\\\" -Value \\\"C:\\WINDOWS\\media\\ding.wav\\\" }"
    exx ""
    exx "\${BYELLOW}***** Breaking a hung Windows session when Ctrl+Alt+Del doesn't work\${NC}"
    exx "In this case, to see Task manager, try Alt+Tab and *hold* Alt for a few seconds to get Task manager preview."
    exx "Also press Alt+D to switch out of not-very-useful Compact mode and into Details mode."
    exx "With Task manager open, press Alt+O followed by Alt+D to enable 'Always on Top'."
    exx "But something that might be even better is to Win+Tab to get the Switcher, then press the '+' at top left to create a new virtual desktop, giving you a clean desktop with nothing on it. In particular, the hung application is not on this desktop, and you can run Task manager here to use it to terminate the hung application."
    exx ""
    exx "\${BYELLOW}***** Windows Terminal (wt) via PowerShell Tips and Split Panes\${NC}"
    exx "Double click on a tab title to rename it (relating to what you are working on there maybe)."
    exx "Alt+Shift+PLUS (vertical split of your default profile), Alt+Shift+MINUS (horizontal)."
    exx "Click the new tab button, then hold down Alt while pressing a profile, to open an 'auto' split (will vertical or horizontal to be most square)"
    exx "Click on a tab with mouse or just Alt-CursorKey to move to different tabs."
    exx "To resize, hold down Alt+Shift, then CursorKey to change the size of the selected pane."
    exx "Close focused pane or tab with Ctrl+Shift+W. If you only have one pane, this close the tab or window if only one tab."
    exx "https://powershellone.wordpress.com/2021/04/06/control-split-panes-in-windows-terminal-through-powershell/"
    exx "To make bash launch in ~ instead of /mnt/c/Users in wt, open the wt Settings, find WSL2 profile, add \\\"commandline\\\": \\\"bash.exe ~\\\" (remember a comma after the previous line to make consistent), or \\\"startingDirectory\\\": \\\"//wsl$/Ubuntu/home/\\\"."
    exx ""
    exx "\${BYELLOW}***** Important Docker tips for WSL\${NC}"
    exx "https://abdus.dev/posts/fixing-wsl2-localhost-access-issue/"
    exx ""
    exx "\${BYELLOW}***** To enable 'root'\${NC}"
    exx "By default on Ubuntu, root has no password and 'su -' will not work."
    exx "https://msdn.microsoft.com/en-us/commandline/wsl/user_support"
    exx "The Windows user owns the VM, so from PowerShell/Cmd, run 'wsl -d <distro-name> -u root' to enter the VM as root."
    exx "Now run 'passwd root' and set the password for root, then 'exit' to return to Windows shell."
    exx "To change default user::   ubuntu.exe config --default-user [user]"
    exx "In legacy versions 1703, 1709, it was:   lxrun /setdefaultuser [user]"
    exx "A restart may be required:   wsl -d <distro_name> --terminate"
    exx "Go back into the VM normally, and you should not be able to run 'su -' to become root."
    exx "Can now use 'su':   su -h,   su -    will take you to 'root'"
    exx "- or -l or -login [user]: Runs login script and switch to a specific username, if no user specified, use 'root'"
    exx "su -c [command] [user]    # Run a single command as antoher user."
    exx "su -s /usr/bin/zsh        # Open root user in Z shell."
    exx "su -p [other_user]        # Keep environment of current user account, keep the same home directory."
    exx ""
    exx "Upgrade Ubuntu to 20.10 inside WSL: https://discourse.ubuntu.com/t/installing-ubuntu-20-10-on-wsl/18941"
    exx "sudo sed --in-place 's/focal/groovy/g' /etc/apt/sources.list"
    exx "sudo apt update -y && sudo apt upgrade -y"
    exx "This guide required more to get working https://www.windowscentral.com/how-upgrade-ubuntu-2010-wsl-windows-10"
    exx "sudo vi /etc/update-manager/release-upgrades   # Change lts to normal on last line"
    exx "sudo do-release-upgrade -d"
    exx ""
    exx "\""   # require final line with a single " to end the multi-line text variable
    exx "echo -e \"\$HELPNOTES\\n\""
    chmod 755 $HELPFILE

    ####################
    #
    echo "WSL X Window Setup (show with 'help-wsl-x')"
    #
    ####################
    HELPFILE=$hh/help-wsl-x.sh
    exx() { echo "$1" >> $HELPFILE; }
    echo "#!/bin/bash" > $HELPFILE
    exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
    exx "HELPNOTES=\""
    exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small WSL X Window GUI)\${NC}"
    exx ""
    exx "GUI apps that run in WSL:"
    exx "gnome-system-monitor"
    exx ""
    exx "\${BYELLOW}***** Run X-Display GUI from WSL\${NC}"
    exx "https://ripon-banik.medium.com/run-x-display-from-wsl-f94791795376"
    exx "https://github.com/microsoft/WSL/issues/4793#issuecomment-577232999"
    exx "https://blog.nimamoh.net/wsl2-and-vcxsrv/"
    exx "https://github.com/cascadium/wsl-windows-toolbar-launcher"
    exx "Require to run X apps as WSL distro does not come with GUI, so we need to install an X-Server on Windows."
    exx "1. Install VcXsrv Windows X Server: choco install vcxsrv -y   or   https://sourceforge.net/projects/vcxsrv/"
    exx "2. Configure: Multiple Windows, Start no client, Clipboard, Primary Selection, Native OpenGL, Disable access control"
    exx "3. Enable Outgoing Connection from Windows Firewall:"
    exx "   Windows Security -> Firewall & network protection -> Allow an app through firewall -> make sure VcXsrv has both public and private checked."
    exx "4. Configure WSL to use the X-Server, you can put that at the end of ~/.bashrc to load it every log in"
    exx "   export DISPLAY=\\\"\$(/sbin/ip route \| awk '/default/ { print \$3 }'):0\\\""
    exx "5. Create a .xsession file in the user home directory e.g."
    exx "   echo xfce4-session > ~/.xsession"
    exx "6. Test by running xeyes"
    exx "   sudo apt install x11-apps"
    exx "Now run 'xeyes' and you should be able to see the the xeyes application"
    exx "After reboots, can run XLaunch from Start:"
    exx "   Multiple Windows, Start no client, Clipboard, Primary Selection, Native OpenGL, and also: Disable access control"
    exx "Can also auto start VcXsrv with Win+R then:   shell:startup"
    exx "Right click > new > shortcut"
    exx "Enter shortcut location to \\\"C:\\Program Files\\VcXsrv\\\\\\vcxsrv.exe\\\" -ac -multiwindow"
    exx "-ac : accept any client connection, ok for a home desktop, but be careful of these kind of options on a mobile device like a laptop."
    exx "Troubleshooting: can check that no blocking rule exist for VcXsrv windows xserver in your firewall configuration:"
    exx "   Win+R then:   wf.msc  , Click on inbound rule. Delete each blocking rule for VcXsrv windows xserver"
    exx ""
    exx "\""   # require final line with a single " to end the multi-line text variable
    exx "echo -e \"\$HELPNOTES\\n\""
    chmod 755 $HELPFILE

    ####################
    #
    echo "WSL Sublime GUI X Window App (show with 'help-wsl-sublime')"
    #
    ####################
    HELPFILE=$hh/help-wsl-sublime.sh
    exx() { echo "$1" >> $HELPFILE; }
    echo "#!/bin/bash" > $HELPFILE
    exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
    exx "HELPNOTES=\""
    exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small Sublime on WSL)\${NC}"
    exx ""
    exx "# This is to demonstrate running a full GUI app within WSL:"
    exx "sudo apt update"
    exx "sudo apt install apt-transport-https ca-certificates curl software-properties-common"
    exx "# Import the repository’s GPG key using the following:"
    exx "curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -"
    exx "# Add Sublime Text APT repository:"
    exx "sudo add-apt-repository \\\"deb https://download.sublimetext.com/apt/stable/\\\""
    exx "# Update apt sources then you can install Sublime Text 3:"
    exx "sudo apt update"
    exx "sudo apt install sublime-text"
    exx "# It might be required to create a symbolic link (but this should be automatic):"
    exx "# sudo ln -s /opt/sublime/sublime_text /usr/bin/subl"
    exx "Start Sublime from console (with & to prevent holding console):"
    exx "subl file.ext &"
    exx ""
    exx "\""   # require final line with a single " to end the multi-line text variable
    exx "echo -e \"\$HELPNOTES\\n\""
    chmod 755 $HELPFILE

    ####################
    #
    echo "WSL Audio Setup (show with 'help-wsl-audio')"
    #
    ####################
    # When using printf, remember that "%" has to be escaped as "%%" or "\045", but
    # this is much easier than 'echo -e' where almost everything has to be escaped.
    # % => %%, inside '', $ is literal, " => \\", ' is impossible, () => \(\)
    # For awk lines, put inside "", then ' is literal, ()) are literal, " => \\\\\" (5x \)
    # Inside "", $() => \\$, but variables are handled differently, $3 => \\\\\$3 (5x \)
    # \b => \\\\\\b (6x \) to prevent \b being intpreted as a backspace
    HELPFILE=$hh/help-wsl-audio.sh
    zzz() { printf "$1\n" >> $HELPFILE; }   # echo without '-e'
    printf "#!/bin/bash\n" > $HELPFILE
    zzz "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
    zzz 'HELPNOTES="'
    zzz '${BCYAN}$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small WSL Audio Setup)${NC}'
    zzz ''
    zzz '${BYELLOW}***** To enable sound (PulseAudio) on WSL2:${NC}'
    zzz 'https://www.linuxuprising.com/2021/03/how-to-get-sound-pulseaudio-to-work-on.html'
    zzz 'https://www.linuxuprising.com/2021/03/how-to-get-sound-pulseaudio-to-work-on.html'
    zzz 'https://x410.dev/cookbook/wsl/enabling-sound-in-wsl-ubuntu-let-it-sing/'
    zzz 'Download the zipfile with preview binaries https://www.freedesktop.org/wiki/Software/PulseAudio/Ports/Windows/Support/'
    zzz 'Current is: http://bosmans.ch/pulseaudio/pulseaudio-1.1.zip (but check for newer from above)'
    zzz ''
    zzz '${BYELLOW}***** Setup PulseAudio:${NC}'
    zzz 'Copy the \\"bin\\" folder from pulseaudio zip file to C:\\\\\\bin'
    zzz 'Rename bin folder to C:\pulse (this contains the pulseaudio.exe)'
    zzz 'Create C:\pulse\config.pa and add the following to that file:'
    zzz 'load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1;172.16.0.0/12'
    zzz 'load-module module-esound-protocol-tcp auth-ip-acl=127.0.0.1;172.16.0.0/12'
    zzz 'load-module module-waveout sink_name=output source_name=input record=0'
    zzz 'This allows connections from 127.0.0.1 which is the local IP address'
    zzz '172.16.0.0/12 is the default WSL2 space (172.16.0.0 - 172.31.255.255)'
    zzz ''
    zzz '${BYELLOW}***** WSL settings:${NC}'
    zzz 'On WSL Linux, install libpulse0 (available on Ubuntu, but not CentOS):'
    zzz 'sudo apt install libpulse0'
    zzz 'Add the following to ~/.bashrc:'
    zzz "export HOST_IP=\\\\\"\\\$(ip route |awk '/^default/{print \\\\\$3}')\\\\\""
    zzz 'export PULSE_SERVER=\\"tcp:\$HOST_IP\\"'
    zzz '# export DISPLAY=\\"\$HOST_IP:0.0\\"   # This format if certain you are on 0:0'
    zzz ''
    zzz '${BYELLOW}***** NSSM (non-sucking service manager):${NC}'
    zzz 'Get NSSM from https://nssm.cc/download'
    zzz 'Copy nssm.exe to C:\pulse\nssm.exe, then run:'
    zzz 'C:\\\\\\pulse\\\\\\nssm.exe install PulseAudio'
    zzz 'Application path:  C:\pulse\pulseaudio.exe'
    zzz 'Startup directory: C:\pulse'
    zzz 'Arguments:         -F C:\pulse\config.pa --exit-idle-time=-1'
    zzz 'Service name should be automatically filled when the NSSM dialog opens: PulseAudio'
    zzz 'On the Details tab, enter PulseAudio in the Display name field'
    zzz 'pulseaudio -F, to run the specified script on startup'
    zzz 'pulseaudio --exit-idle-time=-1 disables the option to terminate the daemon after a number of seconds of inactivity.'
    zzz ''
    zzz '${BYELLOW}***** Remove NSSM and Troubleshooting:${NC}'
    zzz 'If you want to remove this service at some point:   C:\pulse\nssm.exe remove PulseAudio'
    zzz 'PulseAudio is installed as a service (in Windows), so starts at every login (no need to start manually).'
    zzz ''
    zzz '"'   # require final line with a single " to end the multi-line text variable
    zzz 'printf "$HELPNOTES"'
    chmod 755 $HELPFILE

    ### This is the old version using echo -e
    # exx "HELPNOTES=\""
    # exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small WSL Audio Setup)\${NC}"
    # exx ""
    # exx "\${BYELLOW}***** To enable sound (PulseAudio) on WSL2:\${NC}"
    # exx "https://www.linuxuprising.com/2021/03/how-to-get-sound-pulseaudio-to-work-on.html"
    # exx "Download the zipfile with preview binaries https://www.freedesktop.org/wiki/Software/PulseAudio/Ports/Windows/Support/"
    # exx "Current is: http://bosmans.ch/pulseaudio/pulseaudio-1.1.zip (but check for newer from above)"
    # exx "Copy the 'bin' folder from there to C:\\ bin and rename to C:\\pulse (this contains the pulseaudio.exe)"
    # exx "Create C:\\ pulse\\ config.pa and add the following to that file:"
    # exx "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1;172.16.0.0/12"
    # exx "load-module module-esound-protocol-tcp auth-ip-acl=127.0.0.1;172.16.0.0/12"
    # exx "load-module module-waveout sink_name=output source_name=input record=0"
    # exx "This allows connections from 127.0.0.1 which is the local IP address, and 172.16.0.0/12 which is the default space (172.16.0.0 - 172.31.255.255) for WSL2."
    # exx "On WSL Linux, install libpulse0 (available on Ubuntu, but not CentOS):"
    # exx "sudo apt install libpulse0"
    # exx "Add the following to ~/.bashrc:"
    # exx "export HOST_IP=\\\"\$(ip route |awk '/^default/{print \\\$3}')\\\""
    # exx "export PULSE_SERVER=\\\"tcp:\$HOST_IP\\\""
    # exx "#export DISPLAY=\\\"\$HOST_IP:0.0\\\""
    # exx "Get NSSM (non-sucking service manager) from https://nssm.cc/download"
    # exx "Copy nssm.exe to C:\\pulse\\ nssm.exe, then run:"
    # exx "C:\\pulse\\ nssm.exe install PulseAudio"
    # exx "Application path:  C:\\pulse\\pulseaudio.exe"
    # exx "Startup directory: C:\\pulse"
    # exx "Arguments:         -F C:\pulse\\ config.pa --exit-idle-time=-1"
    # exx "Service name should be automatically filled when the NSSM dialog opens: PulseAudio"
    # exx "On the Details tab, enter PulseAudio in the Display name field"
    # exx "In the Arguments field we're using -F, which tells PulseAudio to run the specified script on startup, while --exit-idle-time=-1 disables the option to terminate the daemon after a number of seconds of inactivity."
    # exx "If you want to remove this service at some point:   C:\pulse\ nssm.exe remove PulseAudio"
    # exx "Since we've installed PulseAudio as a service on Windows 10, once started, it will automatically start when you login to your Windows desktop, so there's no need to start it manually again."
    # exx "\""   # require final line with a single " to end the multi-line text variable
    # exx "echo -e \"\$HELPNOTES\\n\""




    ####################
    #
    echo "WSL SSHD Server Notes (show with 'help-wsl-sshd')"
    #
    ####################
    HELPFILE=$hh/help-wsl-sshd.sh
    exx() { echo "$1" >> $HELPFILE; }
    echo "#!/bin/bash" > $HELPFILE
    exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
    exx "HELPNOTES=\""
    exx "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small WSL SSHD Server)\${NC}"
    exx ""
    exx "Connect to WSL via SSH: https://superuser.com/questions/1123552/how-to-ssh-into-wsl"
    exx "SSH into a WSL2 host remotely and reliably: https://medium.com/@gilad215/ssh-into-a-wsl2-host-remotely-and-reliabley-578a12c91a2"
    exx "sudo apt install openssh-server # Install SSH server"
    exx "/etc/ssh/sshd_config # Change Port 22 to Port 2222 as Windows uses port 22"
    exx "sudo visudo  # We setup service ssh to not require a password"
    exx ""
    exx "# Allow members of group sudo to execute any command"
    exx "%sudo   ALL=(ALL:ALL) ALL"
    exx "%sudo   ALL=NOPASSWD: /usr/sbin/service ssh *"
    exx ""
    exx "sudo service ssh --full-restart # Restart ssh service  sudo /etc/init.d/ssh start"
    exx "You might see: sshd: no hostkeys available -- exiting"
    exx "If so, you need to run: sudo ssh-keygen -A to generate in /etc/ssh/"
    exx "Now restart the server: sudo /etc/init.d/ssh start"
    exx "You might see the following error on connecting: \\\"No supported authentication methods available (server sent: publickey)\\\""
    exx "To fix this, sudo vi /etc/ssh/sshd_config. Change as follows to allow username/password authentication:"
    exx "PasswordAuthentication = yes"
    exx "ChallengeResponseAuthentication = yes"
    exx "Restart ssh sudo /etc/init.d/ssh restart (or sudo service sshd restart)."
    exx "Note: If you set PasswordAuthentication to yes and ChallengeResponseAuthentication to no you are able to connect automatically with a key, and those that don't have a key will connwct with a password - very useful"
    exx ""
    exx "# Using PuttyGen, keygen-ssh and authorized_keys"
    exx "PuttyGen will create a public key file that looks like:"
    exx ""
    exx "---- BEGIN SSH2 PUBLIC KEY ----"
    exx "Comment: \\\"rsa-key-20121022\\\""
    exx "AAAAB3NzaC1yc2EAAAABJQAAAIEAhGF6GIuMY8FJ1+CNApnSY1N2YSlkYz72Yvwu"
    exx "a6N1nFpBklz1+dsIMg4rcTLcF34M/tW5Yz+NUDAw2AEbxQ32FPgw7sAOIXktkYOH"
    exx "tr7mmimiTjkoSCrJh1kqalPSpi8rglT/Bp67Ql2SZwvUFfMzHISryR0EZC4rXP/u"
    exx "vObrJe8="
    exx "---- END SSH2 PUBLIC KEY ----"
    exx ""
    exx "However, this will not work, so what you need to do is to open the key in PuttyGen, and then copy it from there (this results in the key being in the right format and in 1 line):"
    exx ""
    exx "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEAhGF6GIuMY8FJ1+CNApnSY1N2YSlkYz72Yvwua6N1nFpBklz1+dsIMg4rcTLcF34M/tW5Yz+NUDAw2AEbxQ32FPgw7sAOIXktkYOHtr7mmimiTjkoSCrJh1kqalPSpi8rglT/Bp67Ql2SZwvUFfMzHISryR0EZC4rXP/uvObrJe8= rsa-key-20121022"
    exx ""
    exx "Paste this into authorized_keys then it should work."
    exx ""
    exx "\""   # require final line with a single " to end the multi-line text variable
    exx "echo -e \"\$HELPNOTES\\n\""
    chmod 755 $HELPFILE

fi



echo ""
echo ""
echo ""



####################
#
echo "Python Server on port 8001 (Script Template, call by 'py3web' from .custom)"
#
####################
HELPFILE=$hh/py3web-example.py
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/python3" > $HELPFILE
exx "# Python 3 server example on port 8001"
exx "# Copy this script into your home folder to work with if required as the"
exx "# copy in $hh may be overwritten by .custom configuration periodically."
exx "# The .custom function 'pyweb3example' will look first in ~, then in"
exx "# $hh only if if there is no working copy in ~."
exx "# If you open an url like http://127.0.0.1/example the method do_GET() is called."
exx "# We send the webpage manually in this method, web server in python 3"
exx "# The variable self.path returns the web browser url requested. In this case it would be /example"
exx ""
exx "from http.server import BaseHTTPRequestHandler, HTTPServer"
exx "import time"
exx ""
exx "hostName = \"localhost\""
exx "serverPort = 8001"
exx ""
exx "class MyServer(BaseHTTPRequestHandler):"
exx "    def do_GET(self):"
exx "        self.send_response(200)"
exx "        self.send_header(\"Content-type\", \"text/html\")"
exx "        self.end_headers()"
exx "        self.wfile.write(bytes(\"<html><head><title>https://pythonbasics.org</title></head>\", \"utf-8\"))"
exx "        self.wfile.write(bytes(\"<p>Request: %s</p>\" % self.path, \"utf-8\"))"
exx "        self.wfile.write(bytes(\"<body>\", \"utf-8\"))"
exx "        self.wfile.write(bytes(\"<p>This is an example web server.</p>\", \"utf-8\"))"
exx "        self.wfile.write(bytes(\"</body></html>\", \"utf-8\"))"
exx ""
exx "if __name__ == \"__main__\":        "
exx "    webServer = HTTPServer((hostName, serverPort), MyServer)"
exx "    print(\"Server started http://%s:%s\" % (hostName, serverPort))"
exx ""
exx "    try:"
exx "        webServer.serve_forever()"
exx "    except KeyboardInterrupt:"
exx "        pass"
exx ""
exx "    webServer.server_close()"
exx "    print(\"Server stopped.\")"
chmod 755 $HELPFILE



echo ""
echo ""
echo ""



####################
#
echo "Liquid prompt script setup (call by 'start-liquidprompt' in .custom)"
#
####################
# https://blog.infoitech.co.uk/linux-liquidprompt-an-adaptive-prompt-for-bash/
# https://liquidprompt.readthedocs.io/en/stable/config.html#features
# https://liquidprompt.readthedocs.io/_/downloads/en/v2.0.0-rc.1/pdf/
HELPFILE=$hh/liquid.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "[[ ! -d ~/liquidprompt ]] && git clone --branch stable https://github.com/nojhan/liquidprompt.git ~/liquidprompt"
exx "[[ \$- = *i* ]] && source ~/liquidprompt/liquidprompt"
exx "[[ \$- = *i* ]] && source ~/liquidprompt/themes/powerline/powerline.theme"
exx "[[ \$- = *i* ]] && lp_theme powerline"
exx "echo ''"
exx "echo https://liquidprompt.readthedocs.io/_/downloads/en/v2.0.0-rc.1/pdf/"
exx "echo Alternatives Prompt Projects:"
exx "echo https://github.com/chris-marsh/pureline https://github.com/reujab/silver"
exx "echo ''"
exx "echo 'Some adaptive info Liquid Prompt may display as needed::'"
exx "echo '- Error code of the last command if it failed in some way (in red at end of prompt).'"
exx "echo '- Number of attached running jobs (commands started with a &), if there are any;'"
exx "echo '- Mumber of attached sleeping jobs (when you interrupt a command with Ctrl-Z and bring it back with fg), if there are any;'"
exx "echo '- Average processors load (if over a given limit with a colormap for increasing load).'"
exx "echo '- Number of detached sessions (screen or tmux), if any.'"
exx "echo '- Current host if connected via SSH (either a blue hostname or different colors for different hosts).'"
exx "echo '- Adaptive branch, added/delted lines, pending commits etc if in aersion control repository (git, mercurial, subversion, bazaar or fossil).'"
exx "echo ''"
exx "echo 'The default settings are good in most cases, but can be altered as follows:'"
exx "echo '# cp ~/liquidprompt/liquidpromptrc-dist ~/.liquidpromptrc'"
exx "echo '# vi ~/.liquidpromptrc'"
exx "echo ''"
exx "echo LiquidPrompt requires a NerdFont to display icons correctly:"
exx "echo https://www.nerdfonts.com/ https://github.com/ryanoasis/nerd-fonts"
exx "echo ''"
chmod 755 $HELPFILE



echo ""



####################
#
print_header "List Installed Repositories"
#
####################
if [ "$manager" = "apt" ]; then
    echo       ">>>>>>>>  sudo grep -rhE ^deb /etc/apt/sources.list*"
    echo ""
    sudo \grep -rhE ^deb /etc/apt/sources.list*
    echo -e "\n>>>>>>>>  sudo apt-cache policy | grep http\n"
    sudo apt-cache policy | \grep http | sed 's/^ //'
    echo ""
fi
if [ "$manager" = "dnf" ] || [ "$manager" = "yum" ]; then
    echo ">>>>>>>>  sudo $manager repolist   (straight print of the repolist from $manager)"
    sudo $manager repolist | cat
    echo ""
fi


####################
#
print_header "Copy .custom (if present) to ~/.custom, *or* download latest .custom to ~/.custom"
#
####################

if . .custom; then
    echo -e ">>>>> '.custom' was sourced successfully <<<<<\n"
else
    echo -e "!!!!! '.custom' failed to load (check for errors above) !!!!!\n"

fi

# The test for `pwd` is important as custom_loader.sh should never run from inside $HOME.
echo "If ./.custom exists here and this session is an interactive login and pwd is not "\$HOME", then copy it to the home directory."
if [ -f ./.custom ] && [[ $- == *"i"* ]] && [[ ! $(pwd) == $HOME ]]; then
    echo "[ -f ./.custom ] && [[ \$- == *"i"* ]] && [[ ! $(pwd) == \$HOME ]] = TRUE"
    cp ./.custom ~/.custom   # This will overwrite the copy in $HOME
elif [ ! -f ~/.custom ] && [[ $- == *"i"* ]]; then
    echo "~/.custom is still not in \$HOME, so get latest version from Github."
    echo "[ ! -f ~/.custom ] && [[ $- == *"i"* ]] = TRUE"
    curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > ~/.custom   # Download new .custom
fi

echo "Note the above configuration details for any useful additional manual actions."
echo "'updistro' to run through all update/upgrade actions (use 'def updistro' to see commands)."
echo "sudo visudo, set sudo timeout to 10 hours, additional line:   Defaults timestamp_timeout=600"
echo ""
# Only show the following lines if WSL is detected
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    echo "For WSL consoles: Can toggle fullscreen mode with Alt-Enter."
    echo "For WSL consoles: Right-click on title bar > Properties > Options > 'Use Ctrl+Shift+C/V as Copy/Paste'."
    echo "From bash, view WSL folders in Windows Eplorer: 'explorer.exe .' (note the '.exe'), or from Explorer, '\\\\wsl$'."
    echo "Access Windows from bash: 'cd /mnt/c' etc, .custom has 'alias c:='cd /mnt/c' 'd:', 'e:', 'home:', 'pf:', 'sys32:' etc"
fi
echo ""
echo ""
echo ""
# Repeat "reboot required" messsage right at end so that it can't be missed
if [ -f /var/run/reboot-required ]; then
    echo ""
    echo "A reboot is required (/var/run/reboot-required is present)."
    echo "If running in WSL, can shutdown with:   wsl.exe --terminate \$WSL_DISTRO_NAME"
    echo "Re-run this script after reboot to finish the install."
    return   # Script will exit here if a reboot is required
fi
if [ "$manager" == "dnf" ] || [ "$manager" == "yum" ]; then 
    needsReboot=$(needs-restarting -r &> /dev/null 2>&1; echo $?)   # Supress the output message from needs-restarting (from yum-utils)
    if [[ $needsReboot == 1 ]]; then
        echo "Note: A reboot is required (by checking: needs-restarting -r)."
        echo "Re-run this script after reboot to finish the install."
        return   # Script will exit here if a reboot is required 
    fi
fi



# ####################
# #
# print_header "Configure Locale"
# #
# ####################
# # https://askubuntu.com/questions/683406/how-to-automate-dpkg-reconfigure-locales-with-one-command
# # Must do this as very last step, as it will be the only interactive part
# # This required setting should be saved so that this section will be skipped in future
# # Three ways to automate in Ubuntu:
# # 1:  sudo update-locale "LANG=en_GB.UTF-8"; sudo locale-gen --purge "en_GB.UTF-8"; sudo dpkg-reconfigure --frontend noninteractive locales
# # 2:  echo "en_GB.UTF-8" | sudo tee -a /etc/locale.gen; sudo locale-gen
# # 3:  sudo update-locale LANG=en_GB.UTF-8
# 
# # Following are usual defaults
# # LANG=en_US.UTF-8
# # LANGUAGE=
# # LC_CTYPE="en_US.UTF-8"
# # LC_NUMERIC=nl_NL.UTF-8
# # LC_TIME=nl_NL.UTF-8
# # LC_COLLATE="en_US.UTF-8"
# # LC_MONETARY=nl_NL.UTF-8
# # LC_MESSAGES="en_US.UTF-8"
# # LC_PAPER=nl_NL.UTF-8
# # LC_NAME=nl_NL.UTF-8
# # LC_ADDRESS=nl_NL.UTF-8
# # LC_TELEPHONE=nl_NL.UTF-8
# # LC_MEASUREMENT=nl_NL.UTF-8
# # LC_IDENTIFICATION=nl_NL.UTF-8
# # LC_ALL=
# 
# echo "To change locale for language and keyboard settings (e.g. GB, FR, NL, etc)"
# echo "we have to set LANG, LANGUAGE, and all LC variables (via LC_ALL):"
# echo '   # sudo update-locale LANG="en_GB.UTF-8" LANGUAGE="en_GB"   # for GB'
# echo '   # sudo update-locale LANG="nl_NL.UTF-8" LANGUAGE="nl_NL"   # for NL'
# echo '   # sudo update-locale LANG="fr_FR.UTF-8" LANGUAGE="fr_FR"   # for FR'
# echo "   # sudo localectl set-locale LANG=en_GB.UTF-8"
# echo "   # sudo update-locale LC_ALL=en_GB.UTF-8 LANGUAGE"
# echo ""
# echo "For Ubuntu, just need to run the folloing and choose the UTF-8 option:"
# echo "   # sudo dpkg-reconfigure locales"
# echo ""
# echo "Run 'locale' to view the current settings before changing."



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
# - Also check on the termination of single-line functions with semicolon.
#   e.g. die () { test -n "$@" && echo "$@"; exit 1 }   The script might complete but the error will be seen.
#   To make the dumb parser happy:   die () { test -n "$@" && echo "$@"; exit 1; }     (i.e. add the ";" at the end)
# - Use https://www.shellcheck.net/# to try and debug issues
# - https://unix.stackexchange.com/questions/672004/bash-debug-options/672058#672058
#   I found this simple shell breakpoint-debugger in a german shell-scripting book. You add the two following lines where ever you want to start debugging and step through by pressing enter or evaulate variables and functions at runtime.
#      read var    # set simple breakpoint
#      echo -e "dbg> \c"; read cmd; eval $cmd
#      run script
#   $ dbg> doSomethingFunction
#   $ dbg> echo $SOME_VAR
# - Alternatively using set -x and modifying the prompt variable PS4 has helped me in the past.
#   PS4='+ ${BASH_SOURCE##*/}.${LINENO} ${FUNCNAME}: '
# - Tip: use trap to debug (if your script is on the large side...)
#   e.g.     set -x
#   trap read debug
#   The 'trap' command is a way to debug your scripts by esentially breaking after every line.
#   A fuller discussion is here: 
#   hppts://stackoverflow.com/questions/951336/how-to-debug-a-bash-script/45096876#45096876 
# - An alternative for handling line endings:
#   export SHELLOPTS
#   set -o igncr
#   Put into .bashrc or .bash_profile and then do not need to run unix2dos
# - This error:   -bash: syntax error near unexpected token `('
#   This happens when you try to define a function that is already aliased. To fix, 'unalias' the existing alias and try again

# Finding duplicate alias / function declarations.
# https://unix.stackexchange.com/questions/673454/finding-duplicate-aliases-and-functions-in-a-script-bashrc-etc
### #!/usr/bin/perl
### 
### use strict;
### #use Data::Dump qw(dd);
### 
### my $f_re = qr/(?:^|&&|\|\||;|&)\s*(?:(?:function\s+)?([-\w.]+)\s*\(\)|function\s+([-\w.]+)\s+(?:\(\))?\s*\{)/;
### 
### my $a_re = qr/(?:^|&&|\|\||;|&)(?:\s*alias\s*)([-\w.]+)=/;
### 
### # Hash-of-Hashes (HoH) to hold function/alias names and the files/lines they
### # were found on.  i.e an associative array where each element is another
### # associative array.  Search for HoH in the perldsc man page.
### my %fa;
### 
### while(<>) {
###   while(/$f_re/g) {
###       my $match = $1 // $2;
###       #print "found: '$match':'$&':$ARGV:$.\n";
###       $fa{$match}{"function $ARGV:$."}++;
###   };
###   while(/$a_re/g) {
###       #print "found: '$1':'$&':$ARGV:$.\n";
###       $fa{$1}{"alias $ARGV:$."}++;
###   };
### 
###   close(ARGV) if eof; # this resets the line counter to zero for every input file
### };
### 
### #dd \%fa;
### 
### foreach my $key (sort keys %fa) {
###   my $p = 0;
###   $p = 1 if keys %{ $fa{$key} } > 1;
###   foreach my $k (keys %{ $fa{$key} }) {
###     if ($fa{$key}{$k} > 1) {
###       $p = 1;
###     };
###   };
###   print join("\n\t", "$key:", (keys %{$fa{$key}}) ), "\n\n" if $p;
### };

# Initial script is simpler and can also do the job if I prep the script first (replace & | then do by newline then remove all whitespace from start of lines)
# cat .custom | sed 's/&/\n/g' | sed 's/\|/\n/g' | sed 's/then /\n/g' | sed 's/do /\n/g' | sed 's/^[ \t]*//'
### #!/usr/bin/perl
### 
### use strict;
### 
### my $header = 1 if $#ARGV > 0;
### 
### while(<>) {
###   if (($. == 1) && $header) {
###     print "\n" if $header++ > 1;
###     print "==> $ARGV <==\n"
###   };
### 
###   if (/^\s*(?:function\s+)?([-\w]+)\s*\(\)/ ||
###       /^\s*function\s+([-\w]+).*\{/) {
###     printf "%5i\tfunction %s\n", $.,$1
###   } elsif (/^\s*alias\s+([-\w]+)=/) {
###     printf "%5i\talias %s\n", $.,$1
###   };
### 
###   close(ARGV) if eof
### }