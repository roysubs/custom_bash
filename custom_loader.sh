#!/bin/bash
####################
#
# *** custom_loader.sh *** prepares common configurations and sets up the .custom profile extensions
# - Compatible with most distros (uses apt / yum / dnf / apk package managers as appropriate)
# - Installs a common set of tools, such as vim, 
#    dpkg apt-file alien \            # apt-file required for searching on 'what provides a package' searches, alien converts packages
#    python3.9 python3-pip perl \     # Get latest python/pip and perl if not present on this distro
#    cron curl wget pv dos2unix \     # Basic tools, cron is not installed by default on CentOS etc
#    git vim zip unzip mount \        # Basic tools, git, full vim package, zip/unzip, mount is not on all systems
#    nnn dfc pydf ncdu tree net-tools \   # nnn (more useful than mc), dfc, pdf, ncdu variants
#    htop neofetch inxi figlet )      # neofetch/inxi system information tool, apt contains figlet, so try this

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
# there might interfere here. Just keep a copy of the 'updistro' function in this script also and
# make sure both are in sync.
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
    type apk &> /dev/null && manager="apk" && apk list &> /dev/null    > /tmp/all-repo.txt && dnf list installed   &> /dev/null > /tmp/all-here.txt && divider=""
    type apt &> /dev/null && manager="apt" && apt list &> /dev/null    > /tmp/all-repo.txt && apt list --installed &> /dev/null > /tmp/all-here.txt && divider="/"
    type dnf &> /dev/null && manager="dnf" && dnf list -y &> /dev/null > /tmp/all-repo.txt && dnf list installed   &> /dev/null > /tmp/all-here.txt && divider=""
    for x in ${mylist[@]}; do grep "^$x$divider" /tmp/all-repo.txt &> /dev/null && isinrepo+=($x); done    # find items available in repo
    # echo -e "These are in the repo: ${isinrepo[@]}\n\n"   # $(for x in ${isinrepo[@]}; do echo $x; done)
    for x in ${mylist[@]}; do grep "^$x$divider" /tmp/all-here.txt &> /dev/null && isinstalled+=($x); done # find items already installed
    notinrepo+=(`echo ${mylist[@]} ${isinrepo[@]} | tr ' ' '\n' | sort | uniq -u `)  # get the diff from two arrays, jave have to consider the right arrays to use here # different answer here: https://stackoverflow.com/a/2315459/524587
    echo ""
    [[ ${isinrepo[@]} != "" ]]    && echo "These packages exist in the $manager repository:            ${isinrepo[@]}"   # $(for x in ${isinstalled[@]}
    [[ ${isinstalled[@]} != "" ]] && echo "These packages are already installed on this system:   ${isinstalled[@]}"   # $(for x in ${isinstalled[@]}
    [[ ${notinrepo[@]} != "" ]]   && echo "These packages do not exist in the repository:         ${notinrepo[@]}"     # $(for x in ${isinstalled[@]}
    echo 3
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
        print_header "Skip apt-get update because its last run was less than ${updateIntervalReadable} ago" "Last apt-get update run was ${lastUpdate} ago"
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
# keep a copy of the 'pt' function in this script also (has been added in previous section).

nowDate="$(date +'%s')"                # %s  seconds since 1970-01-01 00:00:00 UTC
updateDate=$nowDate
[ -f /tmp/all-repo.txt ] && updateDate="$(stat -c %Y '/tmp/all-repo.txt')"   # %Y  time of last data modification, in seconds since Epoch

lastUpdate=$((nowDate - updateDate))   # simple arithmetic with $(( ))
updateInterval="$((24 * 60 * 60))"     # Adjust this to how often to do updates, setting to 24 hours in seconds
updateIntervalReadable=$(printf '%dh:%dm:%ds\n' $((updateInterval/3600)) $((updateInterval%3600/60)) $((updateInterval%60)))

echo $lastUpdate
echo $updateInterval

if [[ "${lastUpdate}" -gt "${updateInterval}" ]]
then
    echo ""
    # echo Put tasks that should only run once every 24 hours here
fi

packages=( dpkg apt-file alien \            # apt-file required for searching on 'what provides a package' searches, alien converts packages
           python3.9 python3-pip perl \     # Get latest python/pip and perl if not present on this distro
           cron curl wget pv dos2unix \     # Basic tools, cron is not installed by default on CentOS etc
           git vim zip unzip mount \        # Basic tools, git, full vim package, zip/unzip, mount is not on all systems
           nnn dfc pydf ncdu tree net-tools \   # nnn (more useful than mc), dfc, pdf, ncdu variants
           htop neofetch inxi figlet )      # neofetch/inxi system information tool, apt contains figlet, so try this

pt -auto ${packages[@]}     # 'pt' will create a list of valid packages from those input and then installs those

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

HEADERCUSTOM='# Dotsource .custom; download project from: git clone https://github.com/roysubs/custom_bash --depth=1'
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

# To verify which code is sent to your terminal when you press a key or a combination of keys,first
# press Ctrl+V and then press on the desired key. This can be different depending upon the terminal,
# such as PuTTY. For example, pressing Ctrl+V then the Home key on my PuTTY terminal:
#    ^[[1~
# That means that PuTTY sends the escape character ^[ followed by the string [1~
# After this, .inputrc codes can be defined for these key codes.

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
addToFile '"\eOD": backward-word'
addToFile '"\eOC": forward-word'

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
# Note the "" surround $1 in out1() { echo "$1" >> $HELPFILE; } otherwise prefix/trailing spaces will be removed.
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
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small HyperV Help)\${NC}"
out1 ""
out1 "\${BYELLOW}***** To correctly change the resolution of the Hyper-V console\${NC}"
out1 "Step 1: 'dmesg | grep virtual' to check, then 'sudo vi /etc/default/grub'"
out1 "   Change: GRUB_CMDLINE_LINUX_DEFAULT=\\\"quiet splash\\\""
out1 "   To:     GRUB_CMDLINE_LINUX_DEFAULT=\\\"quiet splash video=hyperv_fb:1920x1080\\\""
out1 "Adjust 1920x1080 to your current monitor resolution."
out1 "Step 2: 'sudo reboot', then 'sudo update-grub', then 'sudo reboot' again."
out1 ""
out1 "\${BYELLOW}***** Setup Guest Services so that text can be copied/pasted to/from the Hyper-V console\${NC}"
out1 "From Hyper-V manager dashboard, find the VM, and open Settings."
out1 "Go to Integration Services tab > Make sure Guest services section is checked."
out1 ""
out1 "\${BYELLOW}***** Adjust Sleep Settings for the VM\${NC}"
out1 "systemctl status sleep.target   # Show current sleep settings"
out1 "sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target   # Disable sleep settings"
out1 "sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target   # Enable sleep settings again"
out1 ""
out1 "\""   # require final line with a single " to end the multi-line text variable
out1 "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "GitHub, npm, gem, etc (call with 'help-apps-assorted')"
#
####################
HELPFILE=$hh/help-apps-assorted.sh
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small GitHub, npm, gem, etc)\${NC}"
out1 ""
out1 "https://github.com/awesome-lists/awesome-bash   # \\\"A curated list of delightful Bash scripts and resources.\\\""
out1 "git clone https://github.com/alexanderepstein/Bash-Snippets    # Very useful set of scripts:"
out1 "    sudo ./install.sh all  # https://ostechnix.com/collection-useful-bash-scripts-heavy-commandline-users/"
out1 "    # bak2dvd, bash-snippets, cheat, cloudup, crypt, cryptocurrency, currency, extras, geo, gist, .git, .github, lyrics,"
out1 "    # meme, movies, newton, pwned, qrify, short, siteciphers, stocks, taste, tests, todo, transfer, weather, ytview"
out1 "npm i -g movie-cli         # mayankchd/movie, access movie database from cli, 'movie Into The Wild', or 'movie Into The Wild :: Wild' to compare two movies"
out1 "npm install -g mediumcli   # djadmin/medium-cli, a cli for reading Medium stories, 'medium -h'"
out1 "npm install hget --save    # bevacqua/hget, A CLI and an API to convert HTML into plain text. npm install hget -g   (to install globally)"
out1 "    # hget ponyfoo.com, hget file.html, cat file.html | hget,   hget echojs.com --root #newslist --ignore \\\"article>:not(h2)\\\""
out1 "npm install -g moro        # getmoro/moro, A command line tool for tracking work hours, as simple as it can get. https://asciinema.org/a/106792 https://github.com/getmoro/moro/blob/master/DOCUMENTATION.md"
out1 "git clone git://github.com/VitaliyRodnenko/geeknote.git   # Evernote cli client"
out1 "gem install doing          # ToDo tool"
out1 "git clone git://github.com/wting/autojump.git  # cd autojump, ./install.py or ./uninstall.py, j foo, jc foo, jo foo, jco foo"
out1 "sudo apt install ranger    # console file manager with VI key bindings"
out1 "sudo apt install taskwarrior   # 'task' to start, ToDo list https://taskwarrior.org/docs/"
out1 "npm install battery-level      # https://github.com/gillstrom/battery-level"
out1 "npm install --global brightness-cli   # https://github.com/kevva/brightness-cli"
out1 "https://github.com/yudai/gotty   # publish console as a web application (written in Go)"
out1 "https://github.com/cmus/cmus     # cli music player"
out1 "npm i -g mdlt               # Metadelta CLI, advanced math utility, https://github.com/metadelta/mdlt"
out1 "sudo apt install hub        # Better GitHub integration than git, https://hub.github.com/   hub clone github/hub"
out1 "go get -v github.com/zquestz/s; cd $GOPATH/src/github.com/zquestz/s; make; make install   # Advanced web search, https://github.com/zquestz/s"
out1 "Terminal Image Viewers:"
out1 "sudo apt install fim   # Fbi IMproved, Linux frame buffer viewer that can also create ASCII art. https://ostechnix.com/how-to-display-images-in-the-terminal/"
out1 "   fim -a dog.jpg   ;   fim -t dog.jpg   # -a auto-zoom, -t render ASCII art"
out1 ""
out1 "chronic: runs a command quietly unless it fails"
out1 "combine: combine the lines in two files using boolean operations"
out1 "errno: look up errno names and descriptions"
out1 "ifdata: get network interface info without parsing ifconfig output"
out1 "ifne: run a program if the standard input is not empty"
out1 "isutf8: check if a file or standard input is utf-8"
out1 "lckdo: execute a program with a lock held"
out1 "mispipe: pipe two commands, returning the exit status of the first"
out1 "parallel: run multiple jobs at once"
out1 "pee: tee standard input to pipes"
out1 "sponge: soak up standard input and write to a file"
out1 "ts: timestamp standard input"
out1 "vidir: edit a directory in your text editor"
out1 "vipe: insert a text editor into a pipe"
out1 "zrun: automatically uncompress arguments to command"
out1 "\""   # require final line with a single " to end the multi-line text variable
out1 "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "Fun Tools and Toys (call with 'help-toys-cli')"
#
####################
HELPFILE=$hh/help-toys-cli.sh
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small Console Toys)\${NC}"
out1 ""
out1 "git clone https://gitlab.com/dwt1/shell-color-scripts ~/shell-color-scripts   # Set of simple colour ASCII scripts"
out1 "   sudo cp -rf ~/shell-color-scripts /opt/"
out1 "   alias colorscript='/opt/shell-color-scripts/colorscript.sh'"
out1 "git clone https://gitlab.com/dwt1/wallpapers ~     # Set of wallpapers for desktops or testing ASCII graphics tools"
out1 ""
out1 "git clone https://github.com/pipeseroni/maze.py    # Simple curses pipes written in Python"
out1 "git clone https://github.com/pipeseroni/pipes.sh   # pipes.sh, a pipe screensaver for cli (bash)"
out1 "git clone https://github.com/pipeseroni/pipesX.sh  # Animated pipes terminal screensaver at an angle (bash)"
out1 "git clone https://github.com/pipeseroni/snakes.pl  # Pipes written in Perl"
out1 "git clone https://github.com/pipeseroni/weave.sh   # Weaving in terminal (bash)"
out1 "https://www.tecmint.com/cool-linux-commandline-tools-for-terminal/"
out1 "sudo $manager install cowsay xcowsay ponysay lolcat toilet   # https://www.asciiart.eu/faq"
out1 "# Random Animal Effect"
out1 "dir=/usr/share/cowsay/cows/; file=\\\$(/bin/ls -1 \\\"\$dir\\\" | sort –random-sort | head -1); cow=\\\$(echo \\\"\$file\\\" | sed -e \\\"s/\.cow//\\\")"
out1 "/usr/games/fortune /usr/share/games/fortunes | cowsay -f \\\$cow"
out1 "sudo $manager install lolcat     # pipe text, fortune, figlet, cowsay etcfor 256 colour rainbow effect. To install on CentOS:"
out1 "   sudo yum install ruby install gcc g++ make automake autoconf curl-devel openssl-devel zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel ruby-rdoc ruby-devel rubygems"
out1 "   sudo gem install lolcat"
out1 "sudo $manager install toilet     # pipe text, fortune, figlet, cowsay etc for coloured output   http://caca.zoy.org/wiki/toilet"
out1 "# toilet -f mono9 -F metal \\\$(date)  ;  while true; do echo \\\"\\\$(date '+%D %T' | toilet -f term -F border --gay)\\\"; sleep 1; done"
out1 "sudo $manager install boxes      # ascii boxes around text"
out1 "sudo apt moo                     # an easter egg inside 'apt'"
out1 "sudo $manager install funny-manpages # Installs various funny man pages"
out1 "   baby celibacy condom date echo flame flog gong grope egrope fgrope party rescrog rm rtfm tm uubp woman (undocumented) xkill xlart sex strfry"
out1 "cd /tmp; git clone https://github.com/bartobri/no-more-secrets.git   # No More Secrets (eye candy). Pipe text to it to garble that, then press any key to unscramble the text, like the film Sneakers"
out1 "cd no-more-secrets; sudo make nms; sudo make sneakers; sudo make install                 # https://ostechnix.com/no-more-secrets-recreate-famous-data-decryption-effect-seen-on-sneakers-movie/"
out1 "   ls -l | nms -f green -a       # To remove: 'sudo make uninstall', then delete the git folder"
out1 "sudo $manager install chafa      # chafa convert images, including GIFs, to ANSI/Unicode character output for a terminal"
out1 "sudo $manager install cmatrix    # cmatrix, colour matrix screensaver for terminal   http://www.asty.org/cmatrix/"
out1 "sudo $manager install aafire     # A fireplace animation"
out1 "sudo $manager install sl         # Stupd train animation, means as a way to teach you not to make the 'sl' typo instead of 'ls'. Daft."
out1 "sudo $manager install aview      # asciiview elephant.jpg -driver curses   # Convert an image file into ASCII art"
out1 "git clone https://github.com/Naategh/Funny-Scripts     # A few scripts (might remove this)"
out1 "colorful-date.sh   Show date and time in a colorful way     extractor.sh   Simply extract any archived file"
out1 "get-info.sh        Get some information from a domain       ip-tor.sh      Install tor and show public ip"
out1 "length-finder.sh   Get length of a given string             mailer.sh      Send an email"
out1 "movies.sh          Quick search that grabs relevant information about a movie"
out1 "top-ips.sh         List all top hitting IP address to your webserver"
out1 "turn-server-uploads.sh   Turn on or off Apache / Nginx / Lighttpd web server upload     web-server.sh   Simple web server"
out1 ""
out1 "rev (reverse), tac (cat backwards) and (nl) are not completely trivial, can be used to manipulate text while working on pipeline"
out1 "sudo $manager install ddate      # Convert Gregorian dates to Discordian dates"
out1 "sudo $manager rig                # Generate random name, address, zip code identities"
out1 "sudo npm install -g terminalizer # Record Linux terminal and generate animated GIF"
out1 "terminalizer record test     # To start a recording. End recording with CTRL+D or terminate the program using CTRL+C"
out1 "After stopping, test.yml is created in the current directory. Edit configurations and the recorded frames as required"
out1 "terminalizer play test       # replay your recording using the play command"
out1 "terminalizer render test     # render your recording as an animated gif"
out1 "To create a global configuration directory, use the init command. You can also customize it using the config.yml file"
out1 "sudo $manager install trash-cli  # trash-cli, cli recoverable trashcan, https://pypi.org/project/trash-cli/"
out1 ""
out1 "sudo $manager nodejs npm; sudo npm install wikit -g  # wikit, wikipedia cli tool https://www.tecmint.com/wikipedia-commandline-tool/"
out1 "sudo $manager install googler    # googler googler is a power tool to Google (web, news, videos and site search) from the command-line. It shows the title, URL and abstract for each result, which can be directly opened in a browser from the terminal. Results are fetched in pages (with page navigation). Supports sequential searches in a single googler instance."
out1 "sudo $manager install browsh     # browsh text mode browser, can render anything, including videos on terminal https://www.brow.sh/"
out1 "https://www.youtube.com/watch?time_continue=3&v=zqAoBD62gvo&feature=emb_logo"
out1 "curl -u YourUsername:YourPassword -d status=\\\"Your status message\\\" http://twitter.com/statuses/update.xml   # update Twitter status message"
out1 "Use 'pv' (pipe viewer) to slow print text by limiting the transfer rate:"
out1 "URL=https://genius.com/Monty-python-the-knights-who-say-ni-annotated; content=\\\$(wget \\\$URL -q -O -); lynx -dump \\\$URL | sed -n '/HEAD/,/Aaaaugh/p' | pv -qL 50"
out1 "Fancy meta tags radio stream output:"
out1 "#$ ogg123 http://ai-radio.org"
out1 "or"
out1 "#$ wget -qO- http://ai-radio.org/128.opus | opusdec – – | aplay -qfdat"
out1 "or"
out1 "#$ curl -sLN http://ai-radio.org/128.opus | opusdec – – | aplay -qfdat"
out1 "example output"
out1 "http://ai-radio.org/chronos/.media/fancy_meta.gif"
out1 ""
out1 "Google Search Operators   https://www.yeahhub.com/top-8-basic-google-search-dorks-live-examples/"
out1 "S.No.	Operator	Description	Example"
out1 "1	intitle:    finds strings in the title of a page        intitle:'Your Text'"
out1 "2	allintext:  finds all terms in the title of a page      allintext:'Contact'"
out1 "3	inurl:      finds strings in the URL of a page          inurl:'news.php?id='"
out1 "4	site:       restricts a search to a particular site or domain   site:yeahhub.com 'Keyword'"
out1 "5	filetype:   finds specific types of files (doc, pdf, mp3 etc) based on file extension   filetype:pdf 'Cryptography'"
out1 "6	link:       searches for all links to a site or URL     link:'example.com'"
out1 "7	cache:      displays Google’s cached copy of a page     cache:yeahhub.com"
out1 "8	info:       displays summary information about a page   info:www.example.com"
out1 ""
out1 "for i in {1..12}; do for j in \\\$(seq 1 \\\$i); do echo -ne \\\$iÃ—\\\$j=$((i*j))\\t;done; echo; done   # Multiplication tables"
out1 "for i in {0..600}; do echo \\\$i; sleep 1; done | dialog --guage 'Installing Patches….' 6 40out1"
out1 ""
out1 "# AsciiAquarium   # Might also need: perl -MCPAN -e shell ; install Term::Animation"
out1 "pt tar wget make libcurses-perl   # using 'package tool'"
out1 "cd /tmp"
out1 "wget http://search.cpan.org/CPAN/authors/id/K/KB/KBAUCOM/Term-Animation-2.4.tar.gz"
out1 "tar -zxvf Term-Animation-2.4.tar.gz"
out1 "cd Term-Animation-2.4/"
out1 "sudo perl Makefile.PL && make && make test"
out1 "sudo make install"
out1 "cd /tmp"
out1 "wget http://www.robobunny.com/projects/asciiquarium/asciiquarium.tar.gz --no-check-certificate"
out1 "tar -zxvf asciiquarium.tar.gz"
out1 "cd asciiquarium_1.1/"
out1 "sudo cp asciiquarium /usr/local/bin"
out1 "sudo chmod 0755 /usr/local/bin/asciiquarium"
out1 ""
out1 "\""   # require final line with a single " to end the multi-line text variable
out1 "echo -e \"\$HELPNOTES\""
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
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small byobu Help)\${NC}"
out1 ""
out1 "byobu is a suite of enhancements for tmux (which it is built on) with convenient shortcuts."
out1 "Terminal multiplexers like tmux allow multiple panes and windows inside a single console."
out1 "Note that byobu connects to already open sessions by default (tmux just opens a new session by default)."
out1 "byobu keybindings can be user defined in /usr/share/byobu/keybindings/"
out1 ""
out1 "\${RED}BASIC NOTES\${NC}"
out1 "Use, alias b='byobu' then 'b' to start, 'man byobu', F12-: then 'list-commands' to see all byobu terminal commands"
out1 "byobu-<tab><tab> to see all bash commands, can 'man' on each of these"
out1 "Shift-F1 (quick help, 'q' to exit), F1 (help/configuration UI, ESC to exit), F9 (byobu-config, but is same as F1)"
out1 "Alt-F12 (toggle mouse support on/off), or F12-: then 'set mouse on' / 'set mouse off'"
out1 "With mouse, click on panes and windows to switch. Scroll on panes with the mouse wheel or trackpad. Resize panes by dragging from edges"
out1 "Mouse support *breaks* copy/paste, but just hold down 'Shift' while selecting text and it works fine."
out1 "Byobu shortcuts can interfere with other application shortcuts. To toggle enabling/disabling byobu, use Shift-F12."
out1 "Ctrl-Shift-F12 for Mondrian Square (just a toy). Press Ctrl-D to kill this window."
out1 "F5 (reload profile, refresh status), Shift-F5 (toggle different status lines), Ctrl-Shift-F5 randomises status bar colours, to reset, use: rm ~/.byobu/color.tmux"
out1 "Alt-F5 (toggle UTF-8 support, refresh), Ctrl-F5 (reconnect ssh/gpg/dbus sockets)"
out1 "F7 (enter scrollback history), Alt-PgUp/PgDn (enter and move through scrollback), Shift-F7 (save history to '\$BYOBU_RUN_DIR/printscreen')"
out1 "F12-: (to enable the internal terminal), then 'set mouse on', then ENTER to enable mouse mode."
out1 "For other commands, 'list-commands'"
out1 "F12-T (fullscreen graphical clock)"
out1 "To completely kill your session, and byobu in the background, type F12-: then 'kill-server'"
out1 "'b ls', 'b list-session' or 'b list-sessions'"
out1 "On starting byobu, session tray shows:   u  20.04 0:-*      11d12h 0.00 4x3.4GHz 12.4G3% 251G2% 2021-04-27 08:41:50"
out1 "u = Ubuntu, 20.04 = version, 0:~* is the session, 11d12h = uptime, 0.00 = ?, 4x3.40GHz = 3.4GHz Core i5 with 4 cores"
out1 "12.4G3% = 12.4 G free memory, 3% CPU usage,   251G2% = 251 G free space, 2% used, 2021-04-27 08:41:50 = date/time"
out1 ""
out1 "\${RED}BASH COMMANDS\${NC}"
out1 "byobu-<tab><tab> to see all byobu bash commands, can 'man <command>' on each of these"
out1 "byobu-config              byobu-enable-prompt       byobu-launcher            byobu-quiet               byobu-select-session      byobu-tmux"
out1 "byobu-ctrl-a              byobu-export              byobu-launcher-install    byobu-reconnect-sockets   byobu-shell               byobu-ugraph"
out1 "byobu-disable             byobu-janitor             byobu-launcher-uninstall  byobu-screen              byobu-silent              byobu-ulevel"
out1 "byobu-disable-prompt      byobu-keybindings         byobu-layout              byobu-select-backend      byobu-status"
out1 "byobu-enable              byobu-launch              byobu-prompt              byobu-select-profile      byobu-status-detail"
out1 ""
out1 "\${RED}PANES\${NC}"
out1 "Ctrl-F2 (vertical split F12-%), Shift-F2 (horizontal split, F12-|) ('|' feels like it should be for 'vertical', so this is a little confusing)"
out1 "Shift-F3/F4 (jump between panes), Ctrl-F3/F4 (move a pane to a different location)"
out1 "Shift-<CursorKeys> (move between panes), Shift-Alt-<CursorKeys> (resize a pane), Shift-F8 (toggle pane arrangements)"
out1 "Shift-F9 (enter command to run in all visible panes)"
out1 "Shift-F8 (toggle panes through the grid templates), F12-z (toggle fullscreen/restore for a pane)"
out1 "Alt-PgUp (scroll up in current pane/window), Alt-PgDn (scroll down in current pane/window)"
out1 "Ctrl-F6 or Ctrl-D (kill the current pane that is in focus), or 'exit' in that pane"
out1 "Note: if the pane dividers disappear, press F5 to refresh status, including rebuilding the pane dividers."
out1 "Shift-F8 (toggle panes through the grid templates)"
out1 ""
out1 "\${RED}WINDOWS\${NC}"
out1 "F2 (new window in current session)"
out1 "Alt-Left/Right or F3/F4 (toggle through windows), Ctrl-Shift-F3/F4 (move a window left or right)  "
out1 "Ctrl-F6 or Ctrl-D (kill the current pane, *or* will kill the current window if there is only one pane), or 'exit' in that window"
out1 "Ctrl-F8 (rename session)"
out1 ""
out1 "\${RED}SESSIONS\${NC}"
out1 "Ctrl-Shift-F2 (new session i.e. a new tmux instance with only '0:-*'), Alt-Up/Down (toggle through sessions)"
out1 "F12-S (toggle through sessions with preview)"
out1 "F9: Enter command and run in all sessions"
out1 "F6 (detach the current session, leaving session running in background, and logout of byobu/tmux)"
out1 "Shift-F6 (detach the current, leaving session running in background, but do not logout of byobu/tmux)"
out1 "F6 (detach session and logout), Shift-F6 (detach session and do not logout)"
out1 "Alt-F6 (detach ALL clients but this one), Ctrl-F6 (kill pane that is in focus)"
out1 "F8 (rename window)"
out1 ""
out1 "\""   # require final line with a single " to end the multi-line text variable
out1 "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "tmux Help (call with 'help-tmux'):"
#
####################

HELPFILE=$hh/help-tmux.sh
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small tmux Help)\${NC}"
out1 ""
out1 "C-b : (to enter command mode), then  :ls, :help, :set mouse on  (or other commands)"
out1 "C-d  (Note: no C-b first!)  (Detach from a session, or C-b d or C-b D for interactive)"
out1 "'M-' stands for 'Meta' key and is the Alt key on Linux"
out1 "C-b ?  (list all key bindings)   C-z  (Suspend tmux)   C-q  (Unsuspend tmux)"
out1 "tmux a  (Attach last session)    tmux a -t mysession   (Attach to mysession)"
out1 "tmux ls (list sessions),  tmux a (attach),   tmux a -t <name> (attach named session)"
out1 "tmux    (start tmux),    tmux new -s <name>,   tmux new -s mysession -n mywindow"
out1 "tmux kill-session –t <name>  (kill a session)   tmux kill-server  (kill tmux server)"
out1 ""
out1 "\${BYELLOW}***** Panes (press C-b first):\${NC}"
out1 "\\\"  (Split new pane up/down)                  %  (Split new pane left/right)"   # 3x spaces due to "\\\"
out1 "z  (Toggle zoom of current pane)             x  (Kill current pane)"
out1 "{ / }  (Swap current pane with previous pane / next pane)   t  (Show the time in pane)"
out1 "q  (Display pane indexes)                    !  (Break current pane out of the window)"
out1 "m  (Mark current pane, see :select-pane -m)  M  Clear marked pane"
out1 "Up/Down/Left/Right    (Change pane in cursorkey direction, must let go of Ctrl)"
out1 "C-Up/Down/Left/Right  (Resize the current pane in steps of 1 cell, must hold down Ctrl)"
out1 "M-Left, M-Right  (Resize current pane in steps of 5 cells)"
out1 "o  (Go to next pane in current window)       ;  (Move to the previously active pane)"
out1 "C-o  (rotate panes in current window)       M-o  (Rotate panes backwards)"
out1 "M-1 to M-5  (Arrange panes preset layouts: tiled, horizontal, vertical, main-hor, main-ver)"
out1 ""
out1 "\${BYELLOW}***** Windows (press C-b first):\${NC}"
out1 "c       (Create a new window)         ,  (Rename the current window)"
out1 "0 to 9  (Select windows 0 to 9)       '  (Prompt for window index to select)"
out1 "s / w   (Window preview)              .  (Prompt for an index to move the current window)"
out1 "w       (Choose the current window interactively)     &  (Kill the current window)"
out1 "n / p   (Change to next / previous window)      l  (Change to previously selected window)"
out1 "i       (Quick window info in tray)"
out1 ""
out1 "\${BYELLOW}***** Sessions (press C-b first):\${NC}"
out1 "$  (Rename the current session)"
out1 "( / )  (Switch 'attached' client to previous / next session)"
out1 "L  Switch the attached client back to the last session."
out1 "f  Prompt to search for text in open windows."
out1 "r  Force redraw of the attached client."
out1 "s  (Select a new session for the attached client interactively)"
out1 "~  Show previous messages from tmux, if any."
out1 "Page Up     Enter copy mode and scroll one page up."
out1 "Space       Arrange the current window in the next preset layout."
out1 "M-n         Move to the next window with a bell or activity marker."
out1 "M-p         Move to the previous window with a bell or activity marker."
out1 ""
out1 "\${BYELLOW}***** Buffers (copy mode) \${NC}"
out1 "[  (Enter 'copy mode' to use PgUp/PgDn etc, press 'q' to leave copy mode)"
out1 "]  (View history / Paste the most recent text buffer)"
out1 "#  (List all paste buffers     =  (Choose a buffer to paste, from a list)"
out1 "-  Delete the most recently copied buffer of text."
out1 "C-Up, C-Down"
out1 "M-Up, M-Down"
out1 "Key bindings may be changed with the bind-key and unbind-key commands."
out1 ""
out1 "\""   # require final line with a single " to close multi-line string
out1 "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "tmux.conf Help (call with 'help-tmux-conf'):"
#
####################

HELPFILE=$hh/help-tmux-conf.sh
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small tmux.conf Options)\${NC}"
out1 ""
out1 "Some useful options for ~/.tmux.conf"
out1 ""
out1 "# ~/.tmux.conf"
out1 ""
out1 "# unbind default prefix and set it to ctrl-a"
out1 "unbind C-b"
out1 "set -g prefix C-a"
out1 "bind C-a send-prefix"
out1 ""
out1 "# make delay shorter"
out1 "set -sg escape-time 0"
out1 ""
out1 "#### key bindings ####"
out1 ""
out1 "# reload config file"
out1 "bind r source-file ~/.tmux.conf ; display \\\".tmux.conf reloaded!\\\""   # needed \\\ for the " here
out1 ""
out1 "# quickly open a new window"
out1 "bind N new-window"
out1 ""
out1 "# synchronize all panes in a window"
out1 "bind y setw synchronize-panes ; display \\\"toggle synchronize-panes!\\\""
out1 ""
out1 "# pane movement shortcuts (same as vim)"
out1 "bind h select-pane -L"
out1 "bind j select-pane -D"
out1 "bind k select-pane -U"
out1 "bind l select-pane -R"
out1 ""
out1 "# enable mouse support for switching panes/windows"
out1 "set -g mouse-utf8 on"
out1 "set -g mouse on"
out1 ""
out1 "#### copy mode : vim ####"
out1 ""
out1 "# set vi mode for copy mode"
out1 "setw -g mode-keys vi"
out1 ""
out1 "# copy mode using 'Esc'"
out1 "unbind ["
out1 "bind Escape copy-mode"
out1 ""
out1 "# start selection with 'space' and copy using 'y'"
out1 "bind -t vi-copy 'y' copy-selection"
out1 ""
out1 "# paste using 'p'"
out1 "unbind p"
out1 "bind p paste-buffer"
out1 ""
out1 "\""   # require final line with a single " to close multi-line string
out1 "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "ps notes (call with 'help-ps')"
#
####################

HELPFILE=$hh/help-ps.sh
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small ps Help)\${NC}"
out1 ""
out1 "To see every process on the system using standard syntax:"
out1 "   ps -e  ,  ps -ef  ,  ps -eF  ,  ps -ely"
out1 "To see every process on the system using BSD syntax:"
out1 "   ps ax  ,  ps axu"
out1 "To print a process tree:"
out1 "   ps -ejH  ,  ps axjf"
out1 "To get info about threads:"
out1 "   ps -eLf  ,  ps axms"
out1 "To get security info:"
out1 "   ps -eo euser,ruser,suser,fuser,f,comm,label  ,  ps axZ  ,  ps -eM"
out1 "To see every process running as root (real & effective ID) in user format:"
out1 "   ps -U root -u root u"
out1 "To see every process with a user-defined format:"
out1 "   ps -eo pid,tid,class,rtprio,ni,pri,psr,pcpu,stat,wchan:14,comm"
out1 "   ps axo stat,euid,ruid,tty,tpgid,sess,pgrp,ppid,pid,pcpu,comm"
out1 "   ps -Ao pid,tt,user,fname,tmout,f,wchan"
out1 "Print only the process IDs of syslogd:"
out1 "   ps -C syslogd -o pid="
out1 "Print only the name of PID 42:"
out1 "   ps -q 42 -o comm="
out1 ""
out1 "https://www.ubuntupit.com/useful-examples-of-linux-ps-command-for-aspiring-sysadmins/"
out1 ""
out1 "\""   # require final line with a single " to close multi-line string
out1 "echo -e \"\$HELPNOTES\\n\""
chmod 755 $HELPFILE



####################
#
echo "Putty notes (call with 'help-putty')"
#
####################

HELPFILE=$hh/help-putty.sh
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small Putty Help)\${NC}"
out1 ""
out1 "Press Ctrl+C or right-click the highlighted text and then left-click on Copy in the context menu."
out1 "Position the cursor in PuTTY where you want to paste the copied text from Windows, then right-click"
out1 "or press Shift + Insert to paste the copied text at that location."
out1 ""
out1 "Window > Lines of scrollback = 99999"
out1 "Window > Display scroll bar in full screen mode"
out1 "Window > Appearance > Font Settings > Consolas, 14-point"
out1 "Window > Appearance > Font quality > Anti-aliased"
out1 "Connection > Sending of null packets > Enable TCP keep-alives and set to 60 seconds"
out1 ""
out1 "Connection > Data > Change 'xterm' to 'putty'"
out1 "Very often, Ctrl+Left/Right keys, Home/End, PgUp/PgDn keys do not work due to not having PuTTY's terminal type set"
out1 "correctly, or as the server doesn't have the correct terminfo definitions installed."
out1 "On Debian/Ubuntu-based systems, the ncurses-term package includes terminfo definition files for putty, putty-256color"
out1 "and putty-vt100 terminal types. If you have this package installed, set 'Terminal-type string' to 'putty' instead of"
out1 "the default 'xterm' in Putty's session configuration (under Connection > Data)."
out1 "https://superuser.com/questions/94436/how-to-configure-putty-so-that-home-end-pgup-pgdn-work-properly-in-bash"
out1 "Change the Terminal-type String under the Connection > Data tab from the default 'xterm' to 'linux'. It worked for me."
out1 ""
out1 "\""   # require final line with a single " to close multi-line string
out1 "echo -e \"\$HELPNOTES\\n\""
chmod 755 $HELPFILE



####################
#
HELP=maths; HELPFILE=$hh/help-$HELP.sh
echo "$HELP notes (call with 'help-$HELP')"
#
####################
out1() { echo "$1" >> $HELPFILE; }; echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small $HELP help)\${NC}"
out1 ""
out1 "((sum=25+35))   # Add two numeric value"
out1 ""
out1 "For bc, load match library and set scale=20 using '-l'"
out1 "https://stackoverflow.com/questions/22621488/"
out1 "Can define variables in .bcrc and call it as follows. e.g. create ~/.bcrc and put scale=3 into it"
out1 "Then define the following alias to load those variables if available"
out1 "alias bc='if [ -f ~/.bcrc ]; then bc -l ~/.bcrc; else  bc; fi'"
out1 "Then can call bc easily with these variables pre-defined:"
out1 "bc <<< 'sqrt 3'"
out1 "   1.7320508"
out1 "bc -l <<< 'scale=10; 4*a(1)'"
out1 "   3.1415926532"
out1 ""
out1 "\""   # require final line with a single " to close multi-line string
out1 "echo -e \"\$HELPNOTES\\n\""
chmod 755 $HELPFILE



####################
#
echo ".inputrc notes (call with 'help-inputrc')"
#
####################

HELPFILE=$hh/help-inputrc.sh
out1() { echo "$1" >> $HELPFILE; }
out2() { printf "$1\n" >> $HELPFILE; }   # echo without '-e'
echo "#!/bin/bash" > $HELPFILE
out2 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out2 'HELPNOTES="'
out2 '${BCYAN}$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small .inputrc Help)${NC}'
out2 ''
out2 'To verify which code is sent to your terminal when you press a key or a combination of keys,first'
out2 'press Ctrl+V and then press on the desired key. This can be different depending upon the terminal'
out2 'such as PuTTY. For example, pressing Ctrl+V then the Home key on my PuTTY terminal:'
out2 '   ^[[1~'
out2 'That means that PuTTY sends the escape character ^[ followed by the string [1~'
out2 'After this, .inputrc codes can be defined for these key codes.'
out2 'Note: Replace every ^[ character by the equivalent \\e string'
out2 ''
out2 'For this Home key example to add the beginning-of-line action (bound to Ctrl+A in Bash by default):'
out2 ''
out2 '"\\e[1~": beginning-of-line'
out2 'https://superuser.com/questions/94436/how-to-configure-putty-so-that-home-end-pgup-pgdn-work-properly-in-bash'
out2 ''
out2 '\""   # require final line with a single " to close multi-line string'
out2 'echo -e \"\$HELPNOTES\\n\"'
chmod 755 $HELPFILE

# To verify which code is sent to your terminal when you press a key or a combination of keys,first
# press Ctrl+V and then press on the desired key. This can be different depending upon the terminal,
# such as PuTTY. For example, pressing Ctrl+V then the Home key on my PuTTY terminal:
#    ^[[1~
# That means that PuTTY sends the escape character ^[ followed by the string [1~
# After this, .inputrc codes can be defined for these key codes.





####################
#
echo "RHEL WSL2 Setup (call with 'help-wsl2redhat')"
#
####################

HELPFILE=$hh/help-wsl2-redhat.sh
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small WSL2 RedHat Setup)\${NC}"
out1 ""
out1 "https://access.redhat.com/discussions/5398621"
out1 "https://www.zdnet.com/article/red-hat-introduces-free-rhel-for-small-production-workloads-development-teams/"
out1 "https://wsl.dev/mobyrhel8/"
out1 ""
out1 "1) Install RHEL in a Virtual Machine. Doesnt matter which. I used the boot iso as it is small, and you want to keep the install as minimal as possible to save time. You can always add any package later using dnf"
out1 ""
out1 "2) When installed, reboot into RHEL and login as root."
out1 ""
out1 "3) Create a tarball of the file system:"
out1 ""
out1 "cd /"
out1 ""
out1 "tar cvfzp rhel8.tar.gz bin dev etc home lib lib64 media opt run root sbin srv usr var"
out1 ""
out1 "Note: these are not all directories under / and are intentionally excluded"
out1 ""
out1 "4) transfer the file rhel8.tar.gz to host system; for easy, I use scp to copy to my server so I can grab it from any workstation"
out1 ""
out1 "5) Create the WSL instance by importing: wsl.exe --import RHEL rhel8.tar.gz --version 2"
out1 ""
out1 "6) create a shortcut to wsl -d rhel to start, or start manually."
out1 ""
out1 "After first start (it will start with user root) you can go to HKLU\Software\Microsoft\Windows\CurrentVersion\Lxss and change the defaultuid for your distro to whatever you want; typically this would be 1000 for the first user created."
out1 ""
out1 "Enjoy your new RHEL8 under WSL2 and install whatever software you need."
out1 ""
out1 "See: https://www.sport-touring.eu/old/stuff/rhel83-2.png"
out1 ""
out1 "\""   # require final line with a single " to close multi-line string
out1 "echo -e \"\$HELPNOTES\\n\""
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
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small bash Notes)\${NC}"
out1 ""
out1 "https://wiki.linuxquestions.org/wiki/Bash_tips"
out1 ""
out1 "\$EDITOR was originally for instruction-based editors like ed. When editors with GUIs (vim, emacs, etc), editing changed dramatically,"
out1 "so \$VISUAL came about. \$EDITOR is meant for a fundamentally different workflow, but nobody uses 'ed' any more. Just setting \$EDITOR"
out1 "is not enough e.g. git on Ubuntu ignores EDITOR and just uses nano (the compiled in default, I guess), so always set \$EDITOR and \$VISUAL."
out1 "Ctrl-x then Ctrl-e is a bash built-in to open vim (\$EDITOR) automatically."
out1 ""
out1 "Test shell scripts with https://www.shellcheck.net/"
out1 ""
out1 "\${BYELLOW}***** Bash variables, special invocations, keyboard shortcuts\${NC}"
out1 "\\\$\\\$  Get process id (pid) of the currently running bash script."
out1 "\\\$n  Holds the arguments passed in while calling the script or arguments passed into a function inside the scope of that function. e.g: $1, $2… etc.,"
out1 "\\\$0  The filename of the currently running script."
out1 "\\<command> Run the original command, ignoring all aliases. e.g. \\ls"
out1 ""
out1 "-   e.g.  cd -      Last Working Directory"
out1 "!!  e.g.  sudo !!   Last executed command"
out1 "!$  e.g.  ls !$     Arguments of the last executed command"
out1 "echo !?             Show error message of last run command"
out1 ""
out1 "touch a.txt b.txt c.txt"
out1 "echo !^ –> display first parameter"
out1 "echo !:1 –> also display first parameter"
out1 "echo !:2 –> display second parameter"
out1 "echo !:3 –> display third parameter"
out1 "echo !$ –> display last (in our case 3th) parameter"
out1 "echo !* –> display all parameters"
out1 "!? finds the last command with its string argument. For example, if these are in history:"
out1 "   1013 grep tornado /usr/share/wind"
out1 "   1014 grep hurricane /usr/share/dict/words"
out1 "   1015 wc -l /usr/share/dict/words"
out1 "!?torn   will grep for tornado again, while !torn would search in vain for a command starting with torn."
out1 "wc !?torn?:2   would also work, selecting argument 2 from the found command and run 'wc'. e.g. wc /usr/share/wind"
out1 ""
out1 "\${BYELLOW}***** Linux Keyboard Shortcuts\${NC}"
out1 "https://www.howtogeek.com/howto/ubuntu/keyboard-shortcuts-for-bash-command-shell-for-ubuntu-debian-suse-redhat-linux-etc/"
out1 "Ctrl-K (cut to end of line),           Ctrl-U (cut to start of line), these use the kill ring buffer in bash"
out1 "Ctrl-Y (paste from kill ring buffer),  Ctrl-W (cut the word on the left side of the cursor)"
out1 "Ctrl-R (recall: search history of used commands),   Ctrl-O (run found command),  Ctrl-G (do not run found command)"
out1 "Ctrl-C (kill currently running terminal process),   Ctrl-Z (stop current process)  =>  (fg / bg / jobs)"
out1 "Ctrl-D (logout of Terminal or ssh (or tmux) session"
out1 "Ctrl-L (clear Terminal; much more useful than the 'clear' command as all info is retained, just scrolls the screen up)"
out1 "Navigation Bindings:"
out1 "Ctrl-A (or Home) / E (or End)  Move to start / end of current line"
out1 "Alt -F / B  Move forward / backwards one wordCtrl-F / B  Move forward / backwards one character"
out1 ""
out1 "\${BYELLOW}***** Use AutoHotkey to enable Ctrl-Shift-PgUp/PgDn to control WSL console scrolling\${NC}"
out1 "; Console scrolling with keyboard. The default in Linux is usually +PgUp, but as Windows Terminal"
out1 "; already uses Ctrl-Shift-PgUp, use that also for Cmd / WSL windows."
out1 "#IfWinActive ahk_class ConsoleWindowClass"
out1 "^+PgUp:: Send {WheelUp}"
out1 "^+PgDn:: Send {WheelDown}"
out1 "#IfWinActive"
out1 ""
out1 "grep \\\`whoami\\\` /etc/passwd   # show current shell,   cat /etc/shells   # show available shells"
out1 "sudo usermod --shell /bin/bash boss   , or ,   chsh -s /bin/bash   , or ,   vi /etc/passwd  # change default shell for user 'boss'"
out1 ""
out1 "\${BYELLOW}***** Breaking a hung SSH session\${NC}"
out1 "Sometimes, SSH sessions hang and Ctrl+c will not work, so that closing the terminal is the only option. There is a little known solution:"
out1 "Hit 'Enter', and '~', and '.' as a sequence and the broken session will be successfully terminated."
out1 ""
out1 "\${BYELLOW}***** Random points to remember\${NC}"
out1 "sudo !!   - re-run previous command with 'sudo' prepended"
out1 "use 'less +F' to view logfiles, instead of 'tail' (ctrl-c, shift-f, q to quit)"
out1 "ctrl-x-e  - continue editing your current shell line in a text editor (uses \$EDITOR)"
out1 "alt-.     - paste previous commands *argument* (useful for running multiple commands on the same resource)"
out1 "reset     - resets/unborks your terminal"
out1 ""
out1 "\""   # require final line with a single " to close multi-line string
out1 "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "Jobs (Background Tasks) (call with 'help-jobs')"
#
####################
# https://stackoverflow.com/questions/1624691/linux-kill-background-task
HELPFILE=$hh/help-jobs.sh
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small Jobs, Ctrl-Z, bg)\${NC}"
out1 ""
out1 "Two main ways to create a background task:"
out1 "1. Put '&' at the end of a command to start it in background:  sleep 300 &; bg -l; kill %"
out1 "2. On a running task, press Ctrl-Z to suspend, then type 'bg' to change it to a background job"
out1 ""
out1 "Type jobs to see all background jobs, and fg <job-number> to bring a job to the foreground"
out1 ""
out1 "To kill background jobs, refer to them by:   jobs -l   then use the number of the job"
out1 "kill %1      # To stop a job (in this case, job [1]). Will NOT kill the job."
out1 "kill %%      # To stop the most recent background job"
out1 "kill -9 %1   # To kill a job (in this case, job [1]). This will fully kill the job."
out1 "kill -9 %%   # To kill the most recent background job"
out1 "kill all background tasks: kill -9 %%   # or, jobs -p | xargs kill -9"
out1 ""
out1 "In the bash shell, % introduces a job name. Job number n may be referred to as %n."
out1 "Also refer to a prefix of the name, e.g. %ce refers to a stopped ce job. If a prefix matches more"
out1 "than one job, bash reports an error. Using %?ce, on the other hand, refers to any job containing"
out1 "the string ce in its command line. If the substring matches more than one job, bash reports an error."
out1 "%% and %+ refer to the shells notion of the current job, which is the last job stopped while it was"
out1 "in the foreground or started in the background. The previous job may be referenced using %-. In output"
out1 "pertaining to jobs (e.g., the output of the jobs command), the current job is always flagged with a +"
out1 "and the previous job with a -. A single % (with no accompanying job specification) also refers to the"
out1 "current job."
out1 ""
out1 "Also note skill and killall (though killall is quite dangerous)."
out1 ""
out1 "\""   # require final line with a single " to close multi-line string
out1 "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "SAMBA / CIFS configuration (call with 'help-networkshare')"
#
####################
# https://stackoverflow.com/questions/1624691/linux-kill-background-task
HELPFILE=$hh/help-networkshare.sh
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small Network Shares, SMB-CIFS)\${NC}"
out1 ""
out1 "To setup samba SMB shares so that other systems can connect to this system:"
out1 ""
out1 "sudo apt install samba    # Install samba. Note: this will not work on Mint!!"
out1 "sudo apt-get install samba --install-recommends   # Fully install samba with all recommended components"
out1 "sudo apt-get install gvfs-backends                # Use these installs to get a full installation"
out1 ""
out1 "sudo smbpasswd -a boss    # Can set password here same as Linux password for convenience"
out1 "service smbd restart      # Need to restart the service between configuration changes"
out1 "smbclient -L 192.168.011  # (or -L //sysname) Will show the available shares on the remote system"
out1 ""
out1 "sudo iptables -I INPUT -p all -s 192.168.1.13 -j ACCEPT"
out1 "sudo iptables -A INPUT -p tcp -m tcp  -m multiport --dports 445,139 -m state --state NEW  -j ACCEPT"
out1 "sudo iptables -A INPUT -p udp -m udp  -m multiport --dports 138,137,139 -m state --state NEW  -j ACCEPT"
out1 ""
out1 "sudo cp /etc/samba/smb.conf /tmp/   # backup"
out1 ""
out1 "Setup a folder to share (note that the 0755 mask allows rw access)" 
out1 "sudo vi /etc/samba/smb.conf"
out1 ""
out1 "[media]"
out1 "   comment = removable media folder"
out1 "   browseable = yes"
out1 "   read only = no"
out1 "   create mask = 0755"
out1 "   directory mask = 0755"
out1 "   guest ok = yes"
out1 "   path = /media/boss"
out1 ""
out1 "sudo service smbd restart   # must restart after above changes. Shares should be browsable now."
out1 ""
out1 "testparm -s   # check an smb.conf configuration file for internal correctness"
out1 "net usershare info --long"
out1 ""
out1 "gio mount smb://<servername>/<sharename>"
out1 "gio mount smb://192.168.0.11/media"
out1 "gio / gvfs mounts at an odd location:"
out1 "cd  /run/user/1000/gvfs/smb-share:server=192.168.0.11,share=media"
out1 "Can create a link as follows:"
out1 "ln -s /run/user/<userid>/gvfs/smb-share\\\:server\\\=<servername>\\\,share\\\=<sharename>/ ~/<mountpoint>"
out1 "Note: The gio command is not persistent and you will have to run it each time the computer is rebooted,"
out1 "but the symbolic link should still be persistent upon re-running the gio command."
out1 ""
out1 "Mount SMB file share from Linux using cifs:"
out1 "sudo apt-get install cifs-utils"
out1 "sudo mount -t cifs -o user=<yournetid>,domain=ad //<servername>/<sharename> /<mountpoint>"
out1 ""
out1 "https://superuser.com/questions/337152/how-to-ls-a-remote-folder"
out1 ""
out1 "\""   # require final line with a single " to close multi-line string
out1 "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE


####################
#
echo "bash Tips  (show with 'help-bash-tips')"
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
out2() { printf "$1\n" >> $HELPFILE; }   # echo without '-e'
printf "#!/bin/bash\n" > $HELPFILE
out2 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out2 'HELPNOTES="'
out2 '${BCYAN}$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small Bash Tips)${NC}'
out2 ''
out2 '${BYELLOW}Example of splitting a string by another string (quite tricky in Bash):${NC}'
#    split() { str="LearnABCtoABCSplitABCaABCString"; delimiter=ABC; s=$str$delimiter; array=(); while [[ $s ]]; do array+=( "${s%%"$delimiter"*}" ); s=${s#*"$delimiter"}; done; declare -p array; echo $array; }
out2 '''split() { str=\\"LearnABCtoABCSplitABCaABCString\\"; delimiter=ABC; s=\$str\$delimiter; array=(); while [[ \$s ]]; do array+=( \\"\${s%%%%%%%%\\"\$delimiter\\"*}\\" ); s=\${s#*\\"\$delimiter\\"}; done; declare -p array; echo \$array; }'
out2 ''
out2 '${BYELLOW}Some structures to remember:${NC}'
out2 '[[ \\"\$(read -e -p \\"Ask a question? [y/N]> \\"; echo $REPLY)\\" == [Yy]*: ]]   # One-liner to get input'
out2 'for i in {3..10}; do echo \$i; done                  # Loop from 3 to 10'
out2 'for (( i=3; i<=10; i++ )); do echo -n \\"\$i \\"; done   # Loop using csh loop syntax'
out2 'for i in \`seq 3 10\`; do echo \$i; done               # Loop using seq'
out2 'i=0; while [ \$i -le 2 ]; do echo Number: \$i; ((i++)); done     # while loop based on a test condition'
out2 'if [[ ( \$x -lt 10 ) && ( \$y -eq 0 ) ]]; then echo \\"\$x \$y\\"; fi  # Testing on  multiple conditions in if-fi loop'
# BACKUPFILE=backup-$(date +%m-%d-%Y)
# archive=${1:-$BACKUPFILE}
# 
# find . -mtime -1 -type f -print0 | xargs -0 tar rvf "$archive.tar"
# echo "Directory $PWD backed up in archive file \"$archive.tar.gz\"."
# exit 0
out2 ''
out2 '${BYELLOW}Using ls or other commands inside for-loops:${NC}'
out2 'It is bad practice to use ls as part of a for-loop, because the output can be uncertain.'
out2 'Use ls for console use, but find is generally the right tool to get a set of files into a for-loop.'
out2 'for i in \$(someCommand) is usually bad (unless the output is certain, such as \$(seq 1 9)). A better construct is:'
out2 'someCommand | while read i; do ...; done          # This is much better than for i in \$(someCommand)'
out2 'someCommand | while IFS= read -r i; do; ... done  # This is even better'
out2 'It is ok to use a command inside a for-loop if the output is certain, e.g. for i in \$(seq 1 9)   would be fine.'
out2 'You can also use the -ls predicate to mimic ls:   find . -maxdepth 1 -type f -ls'
out2 ''
out2 '"'   # require final line with a single " to end the multi-line text variable
out2 'printf "$HELPNOTES"'
chmod 755 $HELPFILE



####################
#
echo "Package Tools (Background Tasks) (call with 'help-packages')"
#
####################
# https://stackoverflow.com/questions/1624691/linux-kill-background-task
HELPFILE=$hh/help-packages.sh
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small Packages)\${NC}"
out1 ""
out1 "apt, apt-file, yum, dnf, alien, debtree"
out1 ""
out1 "alien converts a package to another format (primarily useful to run on Debian/Ubuntu and convert to deb to rpm):"
out1 "sudo alien --to-rpm \\\$filename"
out1 "alien converts between Red Hat rpm, Debian deb, Stampede slp, Slackware tgz, and Solaris pkg file formats."
out1 "Then take that package to CentOS and install using dpkg/rpm"
out1 ""
out1 "apt-file search htop   # Show all files in all packages matching 'htop'"
out1 "apt-file show htop     # Show all files contained in package 'htop'"
out1 "htop: /usr/bin/htop"
out1 "htop: /usr/share/applications/htop.desktop"
out1 "htop: /usr/share/doc/htop/AUTHORS"
out1 "htop: /usr/share/doc/htop/README"
out1 "htop: /usr/share/doc/htop/changelog.Debian.gz"
out1 "htop: /usr/share/doc/htop/copyright"
out1 "htop: /usr/share/man/man1/htop.1.gz"
out1 "htop: /usr/share/pixmaps/htop.png"
out1 ""
out1 "debtree htop           # Show a dependency tree for 'htop' and total size of all packages"
out1 "\\\"htopz\\\" -> \\\"libncursesw6\\\" [color=blue,label=\\\"\\\(>= 6\\\)\\\"];"
out1 "\\\"libncursesw6\\\" -> \\\"libtinfo6\\\" [color=blue,label=\\\"(= 6.2-0ubuntu2)\\\"];"
out1 "\\\"libncursesw6\\\" -> \\\"libgpm2\\\";"
out1 "\\\"htop\\\" -> \\\"libtinfo6\\\" [color=blue,label=\\\"(>= 6)\\\"];"
out1 "// total size of all shown packages: 1263616"
out1 "// download size of all shown packages: 314968"
out1 ""
out1 "debtree dpkg > dpkg.dot               # Generate the dependency graph for package dpkg and save the output to a file 'dpkg.dot'."
out1 "dot -Tsvg -o dpkg.svg dpkg.dot        # Use dot to generate an SVG image from the '.dot' file."
out1 "debtree dpkg | dot -Tpng > dpkg.png   # Generate the dependency graph for package dpkg as PNG image and save the resulting output to a file."
out1 "debtree -b dpkg | dot -Tps | kghostview - &     # Generate the build dependency graph for package dpkg in postscript format and view the result using KDE's kghostview(1)"
out1 ""
out1 "\""   # require final line with a single " to close multi-line string
out1 "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE




####################
#
echo "Help Tools (call with 'help-help')"
#
####################
HELPFILE=$hh/help-help.sh
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small Help Tools)\${NC}"
out1 ""
out1 "https://ostechnix.com/3-good-alternatives-man-pages-every-linux-user-know/"
out1 "***** TLDR++"
out1 "https://ostechnix.com/search-study-and-practice-linux-commands-on-the-fly/"
out1 "https://help.ubuntu.com/"
out1 "http://manpages.ubuntu.com/   :   https://manpages.debian.org/"
out1 ""
out1 "https://explainshell.com/   # Extremely useful, deconstructs the meaning of a command."
out1 "Try the following:   find -iname '*.txt' -exec cp {} /home/ostechnix/ \\;"
out1 ""
out1 "Look through man directories (1 to 8) and display the longest man page in each directory in descending order."
out1 "It can take a few minutes depending upon the number of man pages. https://ostechnix.com/how-to-find-longest-man-page-in-linux/"
out1 "for i in {1..8}; do f=/usr/share/man/man\\\$i/\\\$(ls -1S /usr/share/man/man\\\$i/ | head -n1); printf \\\"%s: %9d\\\\\\n\\\" \\\"\\\$f\\\" \\\$(man \\\"\\\$f\\\" 2>/dev/null | wc -l); done"
out1 ""
out1 "\${BYELLOW}***** man and info (installed by default) and pinfo\${NC}"
out1 "man uname"
out1 "info uname"
out1 ""
out1 "sudo yum install pinfo"
out1 "pinfo uname       # cursor keys up/down to select highlight options and right/left to jumpt to those topics"
out1 "# pinfo pinfo"
out1 ""
out1 "\${BYELLOW}***** bropages\${NC}"
out1 "sudo apt install ruby-dev    # apt version"
out1 "sudo dnf install ruby-devel  # dnf version"
out1 "sudo gem install bropages"
out1 "bro -h"
out1 "# bro thanks       # add your email for upvote/downvotes"
out1 "# bro thanks 2     # upvote example 2 in previous list"
out1 "# bro ...no  2     # downvote example 2"
out1 "# bro add find     # add an entry for 'find'"
out1 ""
out1 "\${BYELLOW}***** cheat\${NC}"
out1 "sudo pip install cheat   # or: go get -u github.com/cheat/cheat/cmd/cheat, (or sudo snap install cheat, but snap does not work on WSL yet)"
out1 "cheat find"
out1 "# cheat --list     # list all entries"
out1 "# cheat -h         # help"
out1 ""
out1 "\${BYELLOW}***** manly\${NC}"
out1 "sudo pip install --user manly"
out1 "# manly dpkg"
out1 "# manly dpkg -i -R"
out1 "manly --help       # help"
out1 ""
out1 "\${BYELLOW}***** kb\${NC}"
out1 "pip install -U kb-manager"
out1 ""
out1 "\${BYELLOW}***** tldr\${NC}"
out1 "sudo $manager install tldr   # Works on CentOS, but might not on Ubuntu"
out1 "sudo $manager install npm"
out1 "sudo npm install -g tldr     # Alternative"
out1 "tldr find"
out1 "# tldr --list-all  # list all cached entries"
out1 "# tldr --update    # update cache"
out1 "# tldr -h          # help"
out1 ""
out1 "\${BYELLOW}***** kmdr\${NC}"
out1 "https://docs.kmdr.sh/get-started-with-kmdr-cl"
out1 "sudo npm install kmdr@latest --global"
out1 ""
out1 "\${BYELLOW}***** tldr (tealdeer version: same example files as above tldr, but coloured etc)\${NC}"
out1 "sudo $manager install tealdeer   # fails for me"
out1 "sudo $manager install cargo      # 270 MB"
out1 "cargo install tealdeer      # seems to install ok"
out1 "export PATH=\\\$PATH:/home/\\\$USER/.cargo/bin   # And add to .bashrc to make permanent"
out1 "# tldr --update"
out1 "# tldr --list"
out1 "# tldr --clear-cache"
out1 "Alterntaive installation method:"
out1 "wget https://github.com/dbrgn/tealdeer/releases/download/v1.4.1/tldr-linux-x86_64-musl"
out1 "sudo cp tldr-linux-x86_64-musl /usr/local/bin/tldr"
out1 "sudo chmod +x /usr/local/bin/tldr"
out1 ""
out1 "\${BYELLOW}***** how2 (free form questions, 'stackoverflow for the terminal')\${NC}"
out1 "like man, but you can query it using natural language"
out1 "sudo $manager install npm"
out1 "npm install -g how-2"
out1 "how2 how do I unzip a .gz?"
out1 ""
out1 "\""   # require final line with a single " to close multi-line string
out1 "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "Apps (call with 'help-apps')"
#
####################
HELPFILE=$hh/help-apps.sh
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small Apps)\${NC}"
out1 ""
out1 "Just a list of various apps..."
out1 ""
out1 "sudo apt install bashtop bpytop"
out1 "https://www.osradar.com/install-bpytop-on-ubuntu-debian-a-terminal-monitoring-tool/"
out1 "Very good guide of random tips for Linux to review"
out1 "https://www.tecmint.com/51-useful-lesser-known-commands-for-linux-users/"
out1 ""
out1 "bc, dc, $(( )), calc, apcalc: Calculators, echo \\\"1/2\\\" | bc -l  # need -l to get fraction, https://unix.stackexchange.com/a/480316/441685"
out1 "The factor command:   factor 182: 2 7 13"
out1 "lynx elinks links2 w3m : console browsers"
out1 "wyrd : text based calendar"
out1 ""
out1 "Some template structures: (also xargs seq etc)"
out1 "for i in {1,2,3,4,5}; do echo \$i; done"
out1 "Perform a command with different arguments:"
out1 "for argument in 1 2 3; do command \$argument; done"
out1 "Perform a command in every directory:"
out1 "for d in *; do (cd \$d; command); done"
out1 ""
out1 "\""   # require final line with a single " to close multi-line string
out1 "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "CLI Games (call with 'help-games-cli')"
#
####################
HELPFILE=$hh/help-games-cli.sh
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small CLI Games)\${NC}"
out1 ""
out1 "Just a list of various console games:"
out1 ""
out1 "\${BYELLOW}The Classic Rogue Games: Angband / Crawl / Nethack / Rogue\${NC}"
out1 "Note that Rogue was from 'bsdgames', but was moved into bsdgames-nonfree due to licensing"
out1 "sudo apt install angband crawl nethack-console bsdgames-nonfree"
out1 "Comparison of Nethack and Angband https://roguelikefan.wordpress.com/2012/08/12/nethack-and-angband/"
out1 "'Angband is a more balanced game, but Zangband and PosChengband are crazy.' https://www.reddit.com/r/angband/comments/6ir244/angband_or_zangband/"
out1 "There are ~100 variants of Angband: http://www.roguebasin.com/index.php?title=List_of_Angband_variantsout1"
out1 "ZAngband / ToME 'Troubles of Middle-earth' / Moria / Sil   https://www.reddit.com/r/roguelikes/comments/3po8g0/comment/cw80nis/?utm_source=reddit&utm_medium=web2x&context=3"
out1 "Sil seems to be mainly for Windows GUI   amirrorclear.net/flowers/game/sil/   http://angband.oook.cz/comic/"
out1 "Roguelikes stem from a game called Rogue that was written before computers had graphics and instead used symbols"
out1 "on the screen to represent a dungeon filled with monsters and treasure, that was randomly generated each time"
out1 "you played. Rogue also had 'permanent death': you have only one life and must choose wisely lest you have to"
out1 "start again. Finally, it had a system of unidentified items whose powers you must discover for yourself."
out1 ""
out1 "\${BYELLOW}Getting the latest version of Angband\${NC}   https://roguelikefan.wordpress.com/2014/08/"
out1 "Building nightly builds: http://angband.oook.cz/forum/showthread.php?t=4302"
out1 "Repo version is often behind the latest, so grab latest source from http://rephial.org/release"
out1 "https://angband.readthedocs.io/en/latest/hacking/compiling.html#linux-other-unix"
out1 "# Always git clone latest version:   git clone http://github.com/angband/angband"
out1 "sudo apt-get install autoconf gcc libc6-dev libncurses5-dev libx11-dev \\   # Install required compilation tools"
out1 "             libsdl1.2-dev libsdl-ttf2.0-dev libsdl-mixer1.2-dev libsdl-image1.2-dev \\"
out1 "             libgtk2.0-dev libglade2-dev"
out1 "# Run the autogen.sh to create the ./configure script"
out1 "./autogen.sh"
out1 "# To build Angband to be run in-place:"
out1 "./configure --with-no-install [other options as needed]"
out1 "make"
out1 "# That creates an executable in the src directory. You can run it from the same directory where you ran make with:"
out1 "src/angband"
out1 "alias angband='~/angband/src/angband   # if you want a shortcut to this"
out1 "# To see what command line options are accepted, use:"
out1 "src/angband -?"
out1 "# If you want to do a system install (making Angband available for all users on the system), make sure you add the users to the \\\"games\\\" group. Otherwise, when your users attempt to run Angband, they will get error messages about not being able to write to various files in the /usr/local/games/lib/angband folders."
out1 "./configure --with-setgid=games --with-libpath=/usr/local/games/lib/angband --bindir=/usr/local/games"
out1 "make"
out1 "make install"
out1 ""
out1 "\${BYELLOW}sudo $manager console-games   # A collection of classic console games\${NC}"
out1 "aajm, an, angband, asciijump, bastet, bombardier, bsdgames,cavezofphear,"
out1 "colossal-cave-adventure, crawl, curseofwar, empire, freesweep, gearhead,"
out1 "gnugo, gnuminishogi, greed, matanza, moria, nethack-console, netris, nettoe,"
out1 "ninvaders, nsnake, nudoku, ogamesim, omega-rpg, open-adventure, pacman4console,"
out1 "petris, robotfindskitten, slashem, sudoku, tetrinet-client, tint, tintin++,"
out1 "zivot"
out1 "sudo $manager animals   # A ridiculous game, guessing animals, waste of time..."
out1 ""
out1 "\${BYELLOW}CoTerminal Apps\${NC} (under active development in 2021, non-graphical puzzles and games with sound for Linux/OSX/Win, SpaceInvaders, Pacman, and Frogger, plus 10 puzzles. https://github.com/fastrgv?tab=repositories"
out1 "cd /tmp"
out1 "git clone https://github.com/fastrgv/CoTerminalApps"
out1 "wget https://github.com/fastrgv/CoTerminalApps/releases/download/v2.3.4/co29sep21.7z"
out1 ""
out1 "./gnuterm.sh"
out1 ""
out1 "\${BYELLOW}sudo apt install bsdgames\${NC}"
out1 "adventure, arithmetic, atc (Air Traffic Control), backgammon, battlestar, bcd, boggle, caesar, canfield, countmail, cribbage, dab, go-fish, gomoku, hack, hangman, hunt, mille, monop, morse, number, pig, phantasia, pom, ppt, primes, quiz, random, rain, robots, rot13, sail, snake, tetris, trek, wargames, worm, worms, wump, wtf"
out1 ""
out1 "adventure                     # Installed by default on Ubuntu, no package on CentOS"
out1 "sudo apt install gnuchess     # GNU Chess, weird, just an engine"
out1 "sudo apt install pacman4console  # Terminal version of Pac-man"
out1 "sudo apt install greed        # Combination of Pac-man and Tron, move around a grid of numbers to erase as much as possible."
out1 "sudo apt install moon-buggy   # moon-buggy, console graphical game, driving on the moon"
out1 "sudo apt install moon-lander  # moon-lander, console graphical game, fly lunar module to surface of the moon"
out1 "sudo apt install ninvaders    # Space Invaders"
out1 "sudo apt install nsnake       # Snake game"
out1 "sudo apt install nudoku       # Linux terminal sudoku game"
out1 "sudo apt install sudoku       # Sudoku"
out1 "sudo apt install bastet       # Tetris clone"
out1 "ssh sshtron.zachlatta.com     # Multiplayer Online Tron Game, requires other players to connect to score"
out1 ""
out1 "\${BYELLOW}Alienwave (a good Galaga variant, you only have one life)\${NC}"
out1 "cd /tmp"
out1 "wget http://www.alessandropira.org/alienwave/alienwave-0.4.0.tar.gz"
out1 "tar xvzf alienwave-0.4.0.tar.gz"
out1 "cd alienwave   # note that the tar inside the gaz defines the folder name, so alienwave and not alienwave-0.4.0"
out1 "sudo apt install libncurses5-dev libncursesw5-dev -y"
out1 "sudo make"
out1 "sudo make install"
out1 "sudo cp alienwave /usr/games"
out1 "alienwave # Start game"
out1 ""
out1 "\${BYELLOW}You Only Live Once\${NC}"
out1 "cd /tmp"
out1 "wget http://www.zincland.com/7drl/liveonce/liveonce005.tar.gz"
out1 "cd linux   # weird, but the extracted directory is called 'linux'"
out1 "./liveonce"
out1 ""
out1 "\${BYELLOW}Cgames (cmines, cblocks, csokoban)\${NC}"
out1 "cd /tmp"
out1 "git clone https://github.com/BR903/cgames.git"
out1 "cd cgames"
out1 "sudo ./configure --disable-mouse"
out1 "sudo make"
out1 "sudo make install"
out1 ""
out1 "\${BYELLOW}Vitetris (start with 'tetris', Tetris clone, best one available for terminal)\${NC}"
out1 "cd /tmp"
out1 "wget http://www.victornils.net/tetris/vitetris-0.57.tar.gz"
out1 "tar xvzf vitetris-0.57.tar.gz"
out1 "cd vitetris-0.57/"
out1 "sudo ./configure"
out1 "sudo make install"
out1 "make install-hiscores"
out1 "sudo make install-hiscores"
out1 "tetris"
out1 ""
out1 "\${BYELLOW}2048-cli, move puzzles to make tiles that will create the number 2048.\${NC}"
out1 "# sudo apt-get install libncurses5-dev"
out1 "# sudo apt-get install libsdl2-dev libsdl2-ttf-dev"
out1 "# sudo apt-get install 2048-cli"
out1 "# 2048"
out1 "wget https://raw.githubusercontent.com/mevdschee/2048.c/master/2048.c"
out1 "gcc -o 2048 2048.c"
out1 "./2048"
out1 ""
out1 "\${BYELLOW}Nettoe (tic-tac-toe variant, playable over the internet\${NC}"
out1 "cd /tmp"
out1 "git clone https://github.com/RobertBerger/nettoe.git"
out1 "cd nettoe"
out1 "sudo ./configure"
out1 "sudo make"
out1 "sudo make install"
out1 "nettoe"
out1 ""
out1 "\${BYELLOW}ASCII-Rain (not a game, just terminal displaying rain :))\${NC}"
out1 "cd /tmp"
out1 "git clone https://github.com/nkleemann/ascii-rain.git "
out1 "cd ascii-rain"
out1 "sudo apt install libncurses-dev ncurses-dev -y"
out1 "gcc rain.c -o rain -lncurses"
out1 "./rain"
out1 ""
out1 "\${BYELLOW}My man, Terminal Pac-man game (arcade).\${NC}"
out1 "https://myman.sourceforge.io/ https://sourceforge.net/projects/myman/"
out1 "https://sourceforge.net/projects/myman/files/myman/myman-0.7.0/"
out1 "cd /tmp"
out1 "wget https://sourceforge.net/projects/myman/files/myman/myman-0.7.0/myman-0.7.0.tar.gz/download"
out1 "sudo ./configure"
out1 "sudo make"
out1 "sudo make install"
out1 ""
out1 "\${BYELLOW}Robot Finds Kitten\${NC}"
out1 "http://robotfindskitten.org/ Another easy-to-play Linux terminal game. In this game, a robot is supposed to find a kitten by checking around different objects. The robot has to detect items and find out whether it is a kitten or something else. The robot will keep wandering until it finds a kitten. Simon Charless has characterized robot finds kitten as 'less a game and more a way of life.'"
out1 ""
out1 "\${BYELLOW}Emacs Games (dunnet 'secret adventure', tetris)\${NC}"
out1 "sudo $manager install emacs"
out1 "Tetris: emacs -nw   # Then 'M-x tetris' (done by holding the Meta key, typically alt by default) and x then typing tetris and pressing enter. -nw flag for no-window to force terminal and not GUI."
out1 "Doctor: emacs -nw at the terminal and then entering M-x doctor. Talk to a Rogerian psychotherapist who will help you with your problems. It is based on ELIZA, the AI program created at MIT in the 1960s."
out1 "Dunnet: emacs -nw at the terminal and then entering M-x dunnet. Similar to Adventure, but with a twist."
out1 "emacs -batch -l dunnet"
out1 ""
out1 "\${BYELLOW}sudo $manager install fractalnow\${NC} Fractal creation tool (fractalnow and qfractalnow GUI)"
out1 ""
out1 "\""   # require final line with a single " to close multi-line string
out1 "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "GUI Games (call with 'help-games-gui')"
#
####################
HELPFILE=$hh/help-games-gui.sh
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small GUI Games)\${NC}"
out1 ""
out1 "\${BYELLOW}xxx\${NC}"
out1 "sudo $manager install nestopia   # The error was 'GLXBadFBConfig' ... try to fix"
out1 "RetroPie ... try to fix"
out1 ""
out1 "\""   # require final line with a single " to close multi-line string
out1 "echo -e \"\$HELPNOTES\""
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
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small vim Help)\${NC}"
out1 ""
out1 ":Tutor<Enter>  30 min tutorial built into Vim."
out1 "The clipboard or bash buffer can be accessed with Ctrl-Shift-v, use this to paste into Vim without using mouse right-click."
out1 ":set mouse=a   # Mouse support ('a' for all modes, use   :h 'mouse'   to get help)."
out1 ""
out1 "\${BYELLOW}***** MODES   :h vim-modes-intro\${NC}"
out1 "7 modes (normal, visual, insert, command-line, select, ex, terminal-job). The 3 main modes are normal, insert, and visual."
out1 "i insert mode, Shift-I insert at start of line, a insert after currect char, Shift-A insert after line.   ':h A'"
out1 "o / O create new line below / above and then insert, r / R replace char / overwrite mode, c / C change char / line."
out1 "v visual mode (char), Shift-V to select whole lines, Ctrl-V to select visual block"
out1 "Can only do visual inserts with Ctrl-V, then select region with cursors or hjkl, then Shift-I for visual insert (not 'i'), type edits, then Esc to apply."
out1 "Could also use r to replace, or d to delete a selected visual region."
out1 "Also note '>' to indent a selected visual region, or '<' to predent (unindent) the region."
out1 ": to go into command mode, and Esc to get back to normal mode."
out1 ""
out1 "\${BYELLOW}***** MOTIONS\${NC}   :h motions"
out1 "h/l left/right, j/k up/down, 'w' forward by word, 'b' backward by word, 'e' forward by end of word."
out1 "^ start of line, $ end of line, 80% go to 80% position in the whole document. G goto line (10G is goto line 10)."
out1 "'(' jump back a sentence, ')' jump forward a sentence, '{' jump back a paragraph, '}' jump forward a paragraph."
out1 "Can combine commands, so 10j jump 10 lines down, 3w jump 3 words forward, 2} jump 2 paragraphs forward."
out1 "/Power/   Go to the first line containing the string 'Power'."
out1 "ddp       Swap the current line with the next one."
out1 "g;        Bring back cursor to the previous position."
out1 ":/friendly/m\$   Move the next line containing the string 'friendly' to the end of the file."
out1 ":/Cons/+1m-2    Move two lines up the line following 'Cons'"
out1 ""
out1 "\${BYELLOW}***** EDITING\${NC}   :h edits"
out1 "x  delete char under cursor, '11x' delete 11 char from cursor. 'dw' delete word, '3dw' delete 3 words, '5dd delete 5 lines."
out1 ":10,18d delete lines 10 to 18 inclusive, r<char> replace char under cursor by another character."
out1 "u  undo (or :u, :undo), Ctrl-r to redo (or :redo)."
out1 ":w  write/save the currect file, :wq  write and quit, :q  quit current file, :q!  quit without saving."
out1 "Copy/Paste: '5y' yank (copy)) 5 chars, '5yy' yank 5 lines. Then, move cursor to another location, then 'p' to paste."
out1 "Cut/Paste: '5x' cut 5 chars (or '5d<space>'), '5dd' 5 lines downwards. Then move cursor to another location, then 'p' to paste."
out1 ">> shift/indent current line, << unindent, 5>> indent 5 lines down from current position. 5<< unindent 5 lines, :h >>"
out1 ":10,20> indent lines 10 to 20 by standard indent amount. :10,20< unindent same lines."
out1 "(vim-commentary plugin), gc to comment visual block selected, gcgc to uncomment a region."
out1 ""
out1 "\${BYELLOW}***** HELP SYSTEM\${NC}   :h      Important to learn to navigate this.   ':h A', ':h I', ':h ctrl-w', ':h :e', ':h :tabe', ':h >>'"
out1 "Even better, open the help in a new tab with ':tab help >>', then :q when done with help tab."
out1 "Open all help"
out1 "Maximise the window vertically with 'Ctrl-w _' or horizontally with 'Ctrl-w |' or 'Ctrl-w o' to leave only the help file open."
out1 "Usually don't want to close everything, so 'Ctrl-w 10+' to increase current window by 10 lines is also good.   :h ctrl-w"
out1 ""
out1 "\${BYELLOW}***** SUBSTITUTION (REPLACE)\${NC}   :h :s   :h s_flags"
out1 "https://www.theunixschool.com/2012/11/examples-vi-vim-substitution-commands.html"
out1 "https://www.thegeekstuff.com/2009/04/vi-vim-editor-search-and-replace-examples/"
out1 ":s/foo/bar/  substitute only the first occurence in current line only, add 'g' every occurence on line, add 'i' to end for case-insensitive."
out1 ":%s/foo/bar/g   substitute on every line (% for every line), and 'g' every occurence on line, add 'i' to end for case-insensitive."
out1 ":5,10s/foo/bar/g   lines 5 to 10 (could use 5,$ instead of for end of file), substitute, change foo to bar, g (global) every occurenct on lines."
out1 ":%s/foo/bar/gci   every line '%', substitute 's', every occurence on line 'g', confirm each substitute 'c', case-insensitive 'i'."
out1 ":s/\<his\>/her/   only replace 'his' if it is a complete word (defined by '<>' around the word)."
out1 ":%s/\(good\|nice\)/awesome/g   replace 'good' *or* 'nice' by 'awesome'."
out1 ":%s!\~!\= expand(\$HOME)!g   ~! will be replaced by the expansion of \$HOME '/home/username/'."
out1 "In Visual Mode, hit colon and the symbol '<,'> will appear, then do :'<,'>s/foo/bar/g for replace on the selected region."
out1 ":%s/example:.*\n/\0    tracker: ''\r/g   # finds any line with 'example: ...' and appends 'tracker: ''' underneath it"
out1 ":g/./ if getcurpos()[1] % 2 == 0 | s/foo/bar/g | endif   # for each line that has content, get the line number and if an even line number, then do a substitution"
out1 ":g/foo/ if getcurpos()[1] % 2 == 0 | s//bar/g | endif   # alternative approach to above where substitution pattern can be empty as it's part of the global pattern"
out1 ":for i in range(2, line('$'),2)| :exe i.'s/foo/bar/g'|endfor   # yet another way using a 'for' loop"   # https://gist.github.com/Integralist/042d1d6c93efa390b15b19e2f3f3827a
out1 "nmap <expr> <S-F6> ':%s/' . @/ . '//gc<LEFT><LEFT><LEFT>'   # Put into .vimrc then press Shift-F6 to interactively replace word at cursor globally (with confirmation)."
out1 ""
out1 "\${BYELLOW}***** BUFFERS\${NC}   :h buffers   Within a single window, can see buffers with :ls"
out1 "vim *   Open all files in current folder (or   'vim file1 file2 file3'   etc)."
out1 ":ls     List all open buffers (i.e. open files)   # https://dev.to/iggredible/using-buffers-windows-and-tabs-efficiently-in-vim-56jc"
out1 ":bn, :bp, :b #, :b name to switch. Ctrl-6 alone switches to previously used buffer, or #ctrl-6 switches to buffer number #."
out1 ":bnext to go to next buffer (:bprev to go back), :buffer <name> (Vim can autocomplete with <Tab>)."
out1 ":bufferN where N is buffer number. :buffer2 for example, will jump to buffer #2."
out1 "Jump between your last 'position' with <Ctrl-O> and <Ctrl-i>. This is not buffer specific, but it works. Toggle between previous file with <Ctrl-^>"
out1 ""
out1 "\${BYELLOW}***** WINDOWS\${NC}   :h windows-into  :h window  :h windows  :h ctrl-w  :h winc"
out1 "vim -o *  Open all with horizontal splits,   vim -O *   Open all with vertical splits."
out1 "<C-W>W   to switch windows (note: do not need to take finger off Ctrl after <C-w> just double press on 'w')."
out1 "<C-W>N :sp (:split, :new, :winc n)  new horizontal split,   <C-W>V :vs (:vsplit, :winc v)  new vertical split"
out1 ""
out1 "\${BYELLOW}***** TABS\${NC}   :h tabpage   Tabbed multi-file editing is a available from Vim 7.0+ onwards (2009)."
out1 "vim -p *   Open all files in folder in tabs (or   'vim -p file1 file2 file3' etc)."
out1 ":tabnew, just open a new tab, :tabedit <filename> (or tabe), create a new file at filename; like :e, but in a new tab."
out1 "gt/gT  Go to next / previous tab (and loop back to first/last tab if at end). Also: 1gt go to tab 1, 5gt go to tab 5."
out1 "gt/gT are easier, but note :tabn (:tabnext or Ctrl-PgDn), :tabp (:tabprevious or Ctrl-PgUp), :tabfirst, :tablast, :tabrewind, tabmove 2 (or :tabm 2) to go to tab 2 (tabs are numbered from 1)"
out1 "Note window splitting commands,  :h :new,  :h :vnew,  :h :split,  :h :vsplit, ..."
out1 ":tabdo %s/foo/bar/g   # perform a substitution in all open tabs (the command following :tabdo operates on all tabs)."
out1 ":tabclose   close current tab,   :tabonly   close all other tab pages except current one."
out1 ":tabedit .   # Opens new tab, prompts for file to open in it. Use cursor keys to navigate and press enter on top of the file you wish to open."
out1 "tab names are prefixed with a '+' if they have unsaved changes,  :w  to write changes."
out1 ":set mouse=a   # Mouse support works with tabs, just click on a tab to move there."
out1 ""
out1 "\${BYELLOW}***** VIMRC OPTIONS\${NC}   /etc/vimrc, ~/.vimrc"
out1 ":set number (to turn line numbering on), :set nonumber (to turn it off), :set invnumber (to toggle)"
out1 "noremap <F3> :set invnumber<CR>   # For .vimrc, Set F3 to toggle line numbers on/off"
out1 "inoremap <F3> <C-O>:set invnumber<CR>   # Also this line for the F3 toggle"
out1 "cnoremap help tab help   # To always open help screens in a new tab, put this into .vimrc"
out1 "color industry   # change syntax highlighting"
out1 "set expandtab tabstop=4 shiftwidth=4   # Disable tabs (to get a tab, Ctrl-V<Tab>), tab stops to 4 chars, indents are 4 chars."
out1 "cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit   # Allow saving of files as sudo if did not start vim with sudo"
out1 "cnoreabbrev <expr> h getcmdtype() == \\\":\\\" && getcmdline() == 'h' ? 'tab help' : 'h'   # Always expand ':h<space>' to ':tab help'"
out1 "nnoremap <space>/ :Commentary<CR>   \\\" / will toggle the comment/uncomment state of the current line (vim-commentry plugin)."
out1 "vnoremap <space>/ :Commentary<CR>   \\\" / will toggle the comment/uncomment state of the visual region (vim-commentry plugin)."
out1 ""
out1 "\${BYELLOW}***** PLUGINS, VIM-PLUG\${NC}    https://www.linuxfordevices.com/tutorials/linux/vim-plug-install-plugins"
out1 "First, install vim-plug:"
out1 "curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
out1 "Then add the following lines to ~/.vimrc"
out1 "call plug#begin('~/.vim/plugged')"
out1 "Plug 'https://github.com/vim-airline/vim-airline' \\\" Status bar"
out1 "Plug 'https://github.com/junegunn/vim-github-dashboard.git'"
out1 "Plug 'junegunn/vim-easy-align' \\\"For GitHub repositories, you can just mention the username and repository"
out1 "Plug 'tyru/open-browser.vim' \\\" Open URLs in browser"
out1 "Plug 'https://github.com/tpope/vim-fugitive' \\\" Git suppoty"
out1 "Plug 'https://github.com/tpope/vim-surround' \\\" Surrounding ysw)"
out1 "Plug 'https://github.com/preservim/nerdtree', { 'on': 'NERDTreeToggle' } \\\" NERDTree file explorer, on-demand loading"
out1 "Plug 'https://github.com/ap/vim-css-color' \\\" CSS Color Preview"
out1 "Plug 'https://github.com/tpope/vim-commentary' \\\" For Commenting gcc & gc"
out1 "call plug#end()"
out1 "Save ~/.vimrc with :w, and then source it with :source %"
out1 "Now install the plugins with :PlugInstall  (a side window will appear as the repo's clone to to ~/.vim/plugged)"
out1 "Restart Vim and test that the plugins have installed with :NERDTreeToggle (typing 'N'<tab> should be enough)"
out1 "vim-fugitive : Git support, see https://github.com/tpope/vim-fugitive https://vimawesome.com/?q=tag:git"
out1 "vim-surround : \\\"Hello World\\\" => with cursor inside this region, press cs\\\"' and it will change to 'Hello World!'"
out1 "   cs'<q> will change to <q></q> tag, or ds' to remove the delimiter. When on Hello, ysiw] will surround the wordby []"
out1 "nerdtree : pop-up file explorer in a left side window, :N<tab> (or :NERDTree, or use :NERDTreeToggle to toggle) :h NERDTree.txt"
out1 "vim-css-color"
out1 "vim-commentary : comment and uncomment code, v visual mode to select some lines then 'gc'<space> to comment, 'gcgc' to uncomment."
out1 "Folloing will toggle comment/uncomment by pressing <space>/ on a line or a visual selected region."
out1 "nnoremap <space>/ :Commentary<CR>"
out1 "vnoremap <space>/ :Commentary<CR>"
out1 ""
out1 "\${BYELLOW}***** SPELL CHECKING / AUTOCOMPLETE\${NC}"
out1 ":setlocal spell spelllang=en   (default 'en', or can use 'en_us' or 'en_uk')."
out1 "Then,  :set spell  to turn on and  :set nospell  to turn off. Most misspelled words will be highlighted (but not all)."
out1 "]s to move to the next misspelled word, [s to move to the previous. When on any word, press z= to see list of possible corrections."
out1 "Type the number of the replacement spelling and press enter <enter> to replace, or just <enter> without selection to leave, mouse support can click on replacement."
out1 "Press 1ze to replace by first correction Without viewing the list (usually the 1st in list is the most likely replacement)."
out1 "Autocomplete: Say that 'Fish bump consecrate day night ...' is in a file. On another line, type 'cons' then Ctrl-p, to autocomplete based on other words in this file."
out1 ""
out1 "\${BYELLOW}***** SEARCH\${NC}"
out1 "/ search forwards, ? search backwards are well known but * and # are less so."
out1 "* search for word nearest to the cursor (forward), and # (backwards)."
out1 "Can repeat a search with / then just press Enter, but easier to use n, or N to repeat a search in the opposite direction."
out1 ""
out1 "\${BYELLOW}***** PASTE ISSUES IN TERMINALS\${NC}"
out1 "Paste Mode: Pasting into Vim sometimes ends up with badly aligned result, especially in Putty sessions etc."
out1 "Fix that with ':set paste' to put Vim in Paste mode before you paste, so Vim will just paste verbatim."
out1 "After you have finished pasting, type ':set nopaste' to go back to normal mode where indentation will take place again."
out1 "You normally only need :set paste in terminals, not in GUI gVim etc."
out1 ""
out1 "dos2unix can change line-endings in a file, or in Vim we can use  :%s/^M//g  (but use Ctrl-v Ctrl-m to generate the ^M)."
out1 "you can also use   :set ff=unix   and vim will do it for you. 'fileformat' help  :h ff,  vim wiki: https://vim.fandom.com/wiki/File_format."
out1 ""
out1 "\""   # require final line with a single " to close multi-line string
out1 "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "grep Notes (call with 'help-grep')"
#
####################
# https://www.richud.com/wiki/Grep_one_liners
HELPFILE=$hh/help-grep.sh
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small grep Notes)\${NC}"
out1 ""
out1 "https://manned.org/grep, https://tldr.ostera.io/grep"
out1 ""
out1 "\${BYELLOW}***** Useful content search with grep\${NC}   # https://stackoverflow.com/a/16957078/524587"
out1 "grep -rnw '/path/to/somewhere/' -e 'pattern'"
out1 "-r or -R is recursive, -n is line number, -w to match the whole word, -e is the pattern used during the search."
out1 "Optional: -l (not 1, but lower-case L) can be added to only return the file name of matching files."
out1 "Optional: --exclude, --include, --exclude-dir flags can be used to refine searches."
out1 ""
out1 "\${BYELLOW}***** Finding files with grep\${NC}   # https://stackoverflow.com/a/16957078/524587"
out1 "grep -rnwl '/' -e 'python'   # Find all files that contain 'python' and return only filenames (-l)."
out1 "grep --include=\*.{c,h} -rnw '/path/to/somewhere/' -e 'pattern'   # Only search files .c or .h extensions, show every matching line."
out1 "grep --exclude=\*.o -rnw '/path/to/somewhere/' -e 'pattern'   # Exclude searching all the files ending with .o extension"
out1 "It is possible to exclude one or more directories with --exclude-dir."
out1 "e.g. exclude the dirs dir1/, dir2/ and all of them matching *.dst/"
out1 "grep --exclude-dir={dir1,dir2,*.dst} -rnw '/path/to/somewhere/' -e 'pattern'"
out1 "https://www.tecmint.com/find-a-specific-string-or-word-in-files-and-directories/"
out1 ""
out1 "grep \\\"search_pattern\\\" path/to/file   # Search for a pattern within a file"
out1 "grep --fixed-strings \\\"exact_string\\\" path/to/file   # Search for an exact string (disables regular expressions)"
out1 "grep --recursive --line-number --binary-files=without-match \\\"search_pattern\\\" path/to/directory   # all files recursively, showing line numbers and ignoring binary files"
out1 "grep --extended-regexp --ignore-case \\\"search_pattern\\\" path/to/file   # extended regular expressions (supports ?, +, {}, () and |), in case-insensitive mode"
out1 "grep --context|before-context|after-context=3 \\\"search_pattern\\\" path/to/file   # Print 3 lines of context around, before, or after each match"
out1 "grep --with-filename --line-number \\\"search_pattern\\\" path/to/file   # Print file name and line number for each match"
out1 "grep --only-matching \\\"search_pattern\\\" path/to/file   # Search for lines matching a pattern, printing only the matched text"
out1 "cat path/to/file | grep --invert-match \\\"search_pattern\\\"   # Search stdin for lines that do not match a pattern"
out1 ""
out1 "\""   # require final line with a single " to end the multi-line text variable
out1 "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "find Notes (call with 'help-find')"
#
####################
# https://www.richud.com/wiki/Grep_one_liners
HELPFILE=$hh/help-find.sh
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small find Notes)\${NC}"
out1 ""
out1 "\${BYELLOW}***** Find files and directories (complex app, https://manned.org/find, https://tldr.ostera.io/find\${NC}"
out1 "sudo find / -mount -name 'git-credential-manager*'            # -mount will ignore mounts, e.g. /mnt/c, /mnt/d, etc in WSL"
out1 "find root_path -name '*.ext'                                  # files by extension"
out1 "find root_path -path '**/path/**/*.ext' -or -name '*pattern*' # files matching multiple path/name patterns"
out1 "find root_path -type d -iname '*lib*'                         # directories matching a given name, in case-insensitive mode"
out1 "find root_path -name '*.py' -not -path '*/site-packages/*'    # files matching a given pattern, excluding specific paths"
out1 "find root_path -size +500k -size -10M                         # files matching a given size range"
out1 "find root_path -name '*.ext' -exec wc -l {} \;                # run a command for each file ({} within the command referends the filename)"
out1 "# find root_path -daystart -mtime -7 -delete                  # files modified in the last 7 days and delete them"
out1 "# find root_path -type f -empty -delete                       # Find empty (0 byte) files and delete them"
out1 ""
out1 "\""   # require final line with a single " to end the multi-line text variable
out1 "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "Assorted Linux Commands (call with 'help-assorted')"
#
####################
# https://www.richud.com/wiki/Grep_one_liners
HELPFILE=$hh/help-assorted.sh
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small Assorted Commands)\${NC}"
out1 ""
out1 "Various commands as a general refresher/reminder list ..."
out1 "https://www.tecmint.com/51-useful-lesser-known-commands-for-linux-users/"
out1 ""
out1 "\${BYELLOW}***** Find\${NC}"
out1 "grep [pattern] [file_name]         # Search for a specific pattern in a file with grep"
out1 "grep -r [pattern] [directory_name] # Recursively search for a pattern in a directory"
out1 "find [/folder/location] -name [a]  # List names that begin with a specified character [a] in a specified location [/folder/location] by using the find command"
out1 "find [/folder/location] -size [+100M]  # See files larger than a specified size [+100M] in a folder"
out1 "locate [name]                      # Find all files and directories related to a particular name"
out1 ""
out1 "gpg -c [file_name]  /  gpg [file_name.gpg]   # Encrypt (-c) or Decrypt a file"
out1 "rsync -a [/your/directory] [/backup/]        # Synchronize the contents of a directory with a backup directory using the rsync command"
out1 ""
out1 "\${BYELLOW}***** Hardware\${NC}"
out1 "dmesg                      # Show bootup messages"
out1 "cat /proc/cpuinfo          # See CPU information"
out1 "free -h                    # Display free and used memory with"
out1 "lshw                       # List hardware configuration information"
out1 "lsblk                      # See information about block devices"
out1 "lspci -tv                  # Show PCI devices in a tree-like diagram"
out1 "lsusb -tv                  # Display USB devices in a tree-like diagram"
out1 "dmidecode                  # Show hardware information from the BIOS"
out1 "hdparm -i /dev/disk        # Display disk data information"
out1 "hdparm -tT /dev/[device]   # Conduct a read-speed test on device/disk"
out1 "badblocks -s /dev/[device] # Test for unreadable blocks on device/disk"
out1 ""
out1 "\${BYELLOW}***** Users\${NC}"
out1 "groupadd [group]    # Add new group"
out1 "adduser [user]                 # Add a new user"
out1 "usermod -aG [group] [user]     # Add to a group"
out1 "userdel [user]                 # Delete a user"
out1 "usermod                        # Modify a user"
out1 "id      # Details about active users,     last     # Show last system login"
out1 "who     # Show currently logged on,       w        # Show logged on users activity"
out1 "whoami        # See which user you are using"
out1 "finger [username]"
out1 ""
out1 "\${BYELLOW}***** Tasks, Processes, Jobs\${NC}"
out1 "pstree   # Show processes in a tree-like diagram"
out1 "pmap     # Display a memory usage map of processes"
out1 "kill [process_id]     # Terminate a Linux process under a given ID"
out1 "pkill [proc_name]     # Terminate a process under a specific name"
out1 "killall [proc_name]   # Terminate all processes labelled “proc”"
out1 "Cltr-Z to suspend a task, then 'bg' to put into background as a job"
out1 "bg  /  jobs   # List and resume jobs in the background"
out1 "fg            # Bring the most recently suspended job to the foreground"
out1 "fg [job]      # Bring a particular job to the foreground"
out1 "lsof          # List files opened by running processes"
out1 "last reboot   # List system reboot history"
out1 "cal           # Calendar"
out1 "w             # List logged in users"
out1 ""
out1 "\${BYELLOW}***** Disk space usage\${NC}"
out1 "df -h      # Free inodes on mounted filesystems"
out1 "df -i      # Display disk partitions and types"
out1 "fdisk -l   # Display disk partitions, sizes, and types with the command"
out1 "du -ah     # See disk usage for all files and directory"
out1 "du -sh     # Show disk usage of the directory you are currently in"
out1 "findmnt    # Display target mount point for all filesystem"
out1 "mount [device_path] [mount_point]   # Mount a device"
out1 ""
out1 "\${BYELLOW}***** File permissions\${NC}"
out1 "chmod 777 [file_name]   # Assign read, write, and execute permission to everyone"
out1 "chmod 755 [file_name]   # Give read, write, and execute permission to owner, and read and execute permission to group and others"
out1 "chmod 766 [file_name]   # Assign full permission to owner, and read and write permission to group and others"
out1 "chown [user] [file_name]   # Change the ownership of a file"
out1 "chown [user]:[group] [file_name]   # Change the owner and group ownership of a file"
out1 ""
out1 "\${BYELLOW}***** Networking\${NC}"
out1 "ip addr show      # List IP addresses and network interfaces"
out1 "ip address add [IP_address]   # Assign an IP address to interface eth0"
out1 "ifconfig          # Display IP addresses of all network interfaces with"
out1 "netstat -pnltu    # See active (listening) ports with the netstat command"
out1 "netstat -nutlp    # Show tcp and udp ports and their programs"
out1 "whois [domain]    # Display more information about a domain"
out1 "dig [domain]      # Show DNS information about a domain using the dig command"
out1 "dig -x host       # Do a reverse lookup on domain"
out1 "dig -x [ip_address]   # Do reverse lookup of an IP address"
out1 "host [domain]     # Perform an IP lookup for a domain"
out1 "hostname -I       # Show the local IP address"
out1 ""
out1 "\""   # require final line with a single " to end the multi-line text variable
out1 "echo -e \"\$HELPNOTES\""
chmod 755 $HELPFILE



####################
#
echo "netstat Notes (call with 'help-netstat')"
#
####################
# https://www.richud.com/wiki/Grep_one_liners
HELPFILE=$hh/help-netstat.sh
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small netstat)\${NC}"
out1 ""
out1 "netstat (ntcommand statistics). Overview of network activities and displays which ports are open or have established connections. Essential for discovering network problems. Part of the 'net-tools' package. Though still widely used, netstat is considered obsolete, and ss command is recommended as a faster and simpler tool."
out1 ""
out1 "Terminal output of the netstat"
out1 "The first list in the output displays active established internet connections on the computer. The following details are in the columns:"
out1 "Proto – Protocol of the connection (TCP, UDP)."
out1 "Recv-Q – Receive queue  of bytes received or ready to be received."
out1 "Send-Q – Send queue of bytes ready to be sent."
out1 "Local address – Address details and port of the local connection. An asterisk (*) in the host indicates that the server is listening and if a port is not yet established."
out1 "Foreign address– Address details and port of the remote end of the connection. An asterisk (*) appears if a port is not yet established."
out1 "State – State of the local socket, most commonly ESTABLISHED, LISTENING, CLOSED or blank."
out1 ""
out1 "The second list shows all active 'Unix Domain' open sockets with the following details:"
out1 "Proto – Protocol used by the socket (always unix)."
out1 "RefCnt – Reference count of the number of attached processes to this socket."
out1 "Flags – Usually ACC or blank."
out1 "Type – The socket type."
out1 "State – State of the socket, most often CONNECTED, LISTENING or blank."
out1 "I-Node – File system inode (index node) associated with this socket."
out1 "Path – System path to the socket."
out1 "For advanced usage, expand the netstat command with options:"
out1 ""
out1 "netstat -a    # List All Ports and Connections"
out1 "netstat -at   # List All TCP Ports"
out1 "netstat -au   # List All UDP Ports"
out1 "netstat -l    # List Only Listening Ports"
out1 "netstat -lt   # List TCP Listening Ports"
out1 "netstat -lu   # List UDP Listening Ports"
out1 "netstat -lx   # List UNIX Listening Ports"
out1 "Note: Scan for open ports with nmap as an alternative."
out1 "netstat -s    # Display Statistics by Protocol"
out1 "netstat -st   # List Statistics for TCP Ports"
out1 "netstat -su   # List Statistics for UDP Ports"
out1 "netstat -i    # List Network Interface Transactions"
out1 "netstat -ie   # Add the option -e to netstat -i to extend the details of the kernel interface table:"
out1 "netstat -M    # Display Masqueraded Connections"
out1 "netstat -tp   # Display the PID/Program name related to a specific connection by adding the -p option to netstat. For example, to view the TCP connections with the PID/Program name listed, use:"
out1 "netstat -lp   # Find Listening Programs"
out1 "netstat -r    # Display Kernel IP Routing Table"
out1 "netstat -g    # Display IPv4 and IPv6 Group Membership"
out1 "netstat -c    # Print netstat Info Continuously"
out1 "netstat -ic   # e.g. To print the kernel interface table continuously, run:"
out1 "netstat --verbose   # Find Unconfigured Address Families at the end of '--verbose'"
out1 "netstat -n    # Display Numerical Addresses, Host Addresses, Port Numbers, and User IDs. By default, addresses, port numbers, and user IDs are resolved into human-readable names when possible. Knowing the unresolved port number is important for tasks such as SSH port forwarding."
out1 "netstat --numeric-hosts    # Display Numerical Host Addresses"
out1 "netstat --numeric-ports    # Display Numerical Port Numbers"
out1 "netstat --numeric-users    # Display Numerical User Ids"
out1 "netstat -an | grep ':[port number]'   # Find a Process That Is Using a Particular Port"
out1 "netstat -an | grep ':80'   # e.g. What process is using port 80?"
out1 ""
out1 "\""   # require final line with a single " to end the multi-line text variable
out1 "echo -e \"\$HELPNOTES\""
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
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small cron Help)\${NC}"
out1 ""
out1 "crontab -e   will edit current users cron"
out1 "crontab -e   will edit current users cron"
out1 "crontab -a <filename>:   create a new <filename> as crontab file"
out1 "crontab -e:   edit our crontab file or create one if it doesn’t already exist"
out1 "crontab -l:   show up our crontab file"
out1 "crontab -r:   delete our crontab file"
out1 "crontab -v:   show up the last time we have edited our crontab file"
out1 ""
out1 "crontab layout  =>  minute(s) hour(s) day(s) month(s) weekday(s) command(s)"
out1 ""
out1 "minute(s)   0-59"
out1 "hour(s)     0-23"
out1 "day(s)      1-31  Calendar day of the month"
out1 "month(s)    1-12  Calendar month of the year (can also use Jan ... Dec)"
out1 "weekday(s)  0-6   Day 0 is Sun (can also use Sun, Mon, Tue, Wed, Thu, Fri, Sat)"
out1 "command(s)        rest of line is free form with spaces for the command to be executed"
out1 "There are several special symbols:  *  /  -  ,"
out1 "*   Represents all of the range The number inside,"
out1 "/   'every', e.g. */5 means every 5 units, in the first column this would be every 5 minutes"
out1 "-   'from a number to a number'"
out1 ",   'separate several discrete numbers', e.g. 0,5,18,47 in first column would run at these minutes of the hour"
out1 ""
out1 "0 6 * * * echo \\\"Good morning.\\\" >>/tmp/crontest.txt         # 6 o'clock every morning"
out1 "# Note that you can't see any output from the screen, as cron emails any output to root's mailbox."
out1 "0 23-7/2,8 * * * echo \\\"Night work.\\\" >>/tmp/crontest.txt   # Every 2 hours between 11pm and 8am AND at 8am (the ',8')"
out1 "0 11 1 * 1-3 command line    # on the 1st of every month and every Monday to Wednesday at 11 AM"
out1 ""
out1 "Whenever a user edits their cron settings, a file with the same name as the user is generated at /var/spool/cron."
out1 "Do not edit this document at /var/spool/cron, only edit this with crontab -e."
out1 "After cron is started, this file is read every minute to check whether to execute the commands inside."
out1 "Therefore, there is no need to restart the cron service after this file is modified. 2. Edit/etc/crontab file to configure cron 　　cron service not only reads all files in/var/spool/cron once per minute, but also needs to read/etc/crontab once, so we can configure this file to use cron service to do some thing. The configuration with crontab is for a certain user, while editing/etc/crontab is a task for the system. The file format of this file is: 　　SHELL=/bin/bash"
out1 "Every two hours"
out1 "PATH=/sbin:/bin:/usr/sbin:/usr/bin"
out1 "MAILTO=root//If there is an error or there is data output, the data will be sent to this account as an email"
out1 "HOME=///The path where the user runs, here It is the root directory"
out1 "# run-parts"
out1 "01 * * * * root run-parts/etc/cron.hourly//Execute the script in/etc/cron.hourly every hour"
out1 "02 4 * * * root run-parts/etc/cron. daily//Execute the scripts in/etc/cron.daily every day"
out1 "22 4 * * 0 root run-parts/etc/cron.weekly//Execute the scripts in/etc/cron.weekly every week"
out1 "42 4 1 * * root run -parts/etc/cron.monthly//month to execute scripts in the/etc/cron.monthly"
out1 "attention to \\\"run-parts\\\" of this argument, if this parameter is removed, then later you can write a script to run Name instead of folder name."
out1 ""
out1 "# Autostart cron in WSL:"
out1 "sudo tee /etc/profile.d/start_cron.sh <<EOF"
out1 "if ! service cron status &> /dev/null; then"
out1 "  sudo service cron start"
out1 "fi"
out1 "EOF"
out1 ""
out1 "you can use this service to start automatically when the system starts:"
out1 "at the end of /etc/rc.d/rc.local script plus: /sbin/service crond start"
out1 ""
out1 "service cron start    # Start the service"
out1 "service cron stop     # Close the service"
out1 "service cron status   # Show staus of the service"
out1 "service cron restart  # Restart the service"
out1 "service cron reload   # Reload the configuration"
out1 ""
out1 "Starting/stopping cron manually:"
out1 "$ ~/custom_bash $ sudo service cron start"
out1 " * Starting periodic command scheduler cron             [ OK ]"
out1 "$ sudo service cron stop  "
out1 " * Stopping periodic command scheduler cron             [ OK ]"
out1 ""
out1 "/etc/crontab: system-wide crontab"
out1 "Unlike any other crontab you don't have to run the 'crontab'"
out1 "command to install the new version when you edit this file"
out1 "and files in /etc/cron.d. These files also have username fields,"
out1 "that none of the other crontabs do."
out1 ""
out1 "SHELL=/bin/sh"
out1 "PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin"
out1 ""
out1 "\${BYELLOW}Example of job definition:\${NC}"
out1 "\${BCYAN}.---------------- minute (0 - 59)"
out1 "\${BCYAN}|  .------------- hour (0 - 23)"
out1 "\${BCYAN}|  |  .---------- day of month (1 - 31)"
out1 "\${BCYAN}|  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ..."
out1 "\${BCYAN}|  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat"
out1 "\${BCYAN}|  |  |  |  |\${NC}"
out1 "*  *  *  *  * user-name command to be executed"
out1 "17 *    * * *   root    cd / && run-parts --report /etc/cron.hourly"
out1 "25 6    * * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )"
out1 "47 6    * * 7   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )"
out1 "52 6    1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )"
out1 ""
out1 "Edit the crontab file for the current user:"
out1 "crontab -e"
out1 ""
out1 "Edit the crontab file for a specific user:"
out1 "sudo crontab -e -u user"
out1 ""
out1 "Replace the current crontab with the contents of the given file:"
out1 "crontab path/to/file"
out1 ""
out1 "View a list of existing cron jobs for current user:"
out1 "crontab -l"
out1 ""
out1 "Remove all cron jobs for the current user:"
out1 "crontab -r"
out1 ""
out1 "Sample job which runs at 10:00 every day (* means any value):"
out1 "0 10 * * * command_to_execute"
out1 ""
out1 "Sample job which runs every minute on the 3rd of April:"
out1 "* * 3 Apr * command_to_execute"
out1 ""
out1 "Sample job which runs a certain script at 02:30 every Friday:"
out1 "30 2 * * Fri /absolute/path/to/script.sh"
out1 ""
out1 "https://stackoverflow.com/questions/9619362/running-a-cron-every-30-seconds"
out1 ""
out1 "\""   # require final line with a single " to end the multi-line text variable
out1 "echo -e \"\$HELPNOTES\""
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
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small awk Notes)\${NC}"
out1 ""
out1 "\${BYELLOW}***** Useful AWK One-Liners to Keep Handy\${NC}"
out1 "Search and scan files line by line, splits input lines into fields, compares input lines/fields to pattern and performs an action on matched lines."
out1 ""
out1 "\${BYELLOW}***** Text Conversion (sub, gsub operations on tabs and spaces)\${NC}"
out1 "awk NF contents.txt       # The awk NF variable will delete all blank lines from a file."
out1 "awk '/./' /contents.txt   # Alternative way to delete all blank lines."
out1 "awk '{ sub(/^[ \t]+/, \\\"\\\"); print }' contents.txt   # Delete leading whitespace and Tabs from the beginning of each line"
out1 "awk '{ sub(/[ \t]+$/, ""); print }' contents.txt   # Delete trailing whitespace and Tabs from the end of each line"
out1 "awk '{ gsub(/^[ \t]+|[ \t]+$/, \\\"\\\"); print }' contents.txt   # Delete both leading and trailing whitespaces from each line"
out1 ""
out1 "Following is a well known awk one-liner that records all lines in an array and arrange them in reverse order."
out1 "awk '{ a[i++] = \\\$0 } END { for (j=i-1; j>=0;) print a[j--] }' contents.txt   # Arrange all lines in reverse order"
out1 "Run this awk one-liner to arrange all lines in reverse order in file contents.txt:"
out1 ""
out1 "Use the NF variable to arrange each field (i.e. words on line) in each line in reverse order."
out1 "awk '{ for (i=NF; i>0; i--) printf(\\\"\%s \\\", \\\$i); printf (\\\"\\\n\\\") }' contents.txt"
out1 ""
out1 "\${BYELLOW}***** Remove duplicate lines\${NC}"
out1 "awk 'a != \\\$0; { a = \\\$0 }' contents.txt   # Remove consecutive duplicate lines from the file"  # $0 => \\\$0
out1 "awk '!a[\\\$0]++' contents.txt         # Remove Nonconsecutive duplicate lines"
out1 ""
out1 "\${BYELLOW}***** Numbering and Calculations (FN, NR)\${NC}"
out1 "awk '{ print NR \\\"\\\t\\\" \\\$0 }' contents.txt               # Number all lines in a file"
out1 "awk '{ printf(\\\"%5d : %s\\\n\\\", NR, \\\$0) }' contents.txt   # Number lines, indented, with colon separator"
out1 "awk 'NF { \\\$0=++a \\\" :\\\" \\\$0 }; { print }' contents.txt    # Number only non-blank lines in files"
out1 "awk '/engineer/{n++}; END {print n+0}'  contents.txt     # You can number only non-empty lines with the following command:"
out1 "Print number of lines that contains specific string"
out1 ""
out1 "\${BYELLOW}***** Regular Expressions\${NC}"
out1 "In this section, we will show you how to use regular expressions with awk command to filter text or strings in files."
out1 ""
out1 "awk '/engineer/' contents.txt   # Print lines that match the specified string"
out1 "awk '!/jayesh/' contents.txt    # Print lines that don't matches specified string"
out1 "awk '/rajesh/{print x};{x=\\\$0}' contents.txt   # Print line before the matching string"
out1 "awk '/account/{getline; print}' contents.txt   # Print line after the matching string"
out1 ""
out1 "\${BYELLOW}***** Substitution\${NC}"
out1 "awk '{gsub(/engineer/, \\\"doctor\\\")};{print}' contents.txt   # Substitute 'engineer' with 'doctor'"
out1 "awk '{gsub(/jayesh|hitesh|bhavesh/,\\\"mahesh\\\");print}' contents.txt   # Find the string 'jayesh', 'hitesh' or 'bhavesh' and replace them with string 'mahesh', run the following command:"
out1 ""
out1 "df -h | awk '{print \\\$1, \\\$4}'   # Find Free Disk Space with Device Name"   # $1 => \\\$1, $4 => \\\$4
out1 "A useful list of open connections to your server sorted by amount (useful if suspect server attacks)."
out1 "netstat -ntu | awk '{print \\\$5}' | cut -d: -f1 | sort | uniq -c | sort -n   # Find Number of open connections per ip"
out1 ""
out1 "Print the fifth column (a.k.a. field) in a space-separated file:"
out1 "awk '{print \\\$5}' filename"
out1 ""
out1 "Print the second column of the lines containing \\\"foo\\\" in a space-separated file:"
out1 "awk '/foo/ {print \\\$2}' filename"
out1 ""
out1 "Print the last column of each line in a file, using a comma (instead of space) as a field separator:"
out1 "awk -F ',' '{print \\\$NF}' filename"
out1 ""
out1 "Sum the values in the first column of a file and print the total:"
out1 "awk '{s+=\\\$1} END {print s}' filename"
out1 ""
out1 "Print every third line starting from the first line:"
out1 "awk 'NR%3==1' filename"
out1 ""
out1 "Print different values based on conditions:"
out1 "awk '{if (\\\$1 == \\\"foo\\\") print \\\"Exact match foo\\\"; else if (\\\$1 ~ \\\"bar\\\") print \\\"Partial match bar\\\"; else print \\\"Baz\\\"}' filename"
out1 ""
out1 "Print all lines where the 10th column value equals the specified value :"
out1 "awk '(\\\$10 == value)'"
out1 ""
out1 "Print all the lines which the 10th column value is between a min and a max :"
out1 "awk '(\\\$10 >= min_value && \\\$10 <= max_value)'"
out1 ""
out1 "\""   # require final line with a single " to end the multi-line text variable
out1 "echo -e \"\$HELPNOTES\\n\""
chmod 755 $HELPFILE



####################
#
echo "sed Notes (show with 'help-sed')"
#
####################
# https://linuxhint.com/newline_replace_sed/
HELPFILE=$hh/help-sed.sh
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small sed Notes)\${NC}"
out1 ""
out1 "\${BYELLOW}***** Useful AWK One-Liners to Keep Handy, work in progress\${NC}"
out1 "Good sed tutorial https://linuxhint.com/newline_replace_sed/"
out1 "Remove whitespace https://linuxhint.com/sed_remove_whitespace/"
out1 ""
out1 "\""   # require final line with a single " to end the multi-line text variable
out1 "echo -e \"\$HELPNOTES\\n\""
chmod 755 $HELPFILE



####################
#
echo "find Notes (call with 'help-git')"
#
####################
# https://www.richud.com/wiki/Grep_one_liners
HELPFILE=$hh/help-git.sh
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
out1 "HELPNOTES=\""
out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small git & GitHub Notes)\${NC}"
out1 ""
out1 "\${BYELLOW}***** Various git & GitHub notes\${NC}"
out1 "git config --global user.email emailaddress@yahoo.com"
out1 "git config --global user.name username"
out1 "https://stackoverflow.com/questions/18935539/authenticate-with-github-using-a-token"
out1 "git clone https://roysubs:GHP_TOKEN_GOES_HERE@github.com/roysubs/custom_bash --depth=1"
out1 "Then can git push up to repository:"
out1 "gpush   =>   git add .  ;  git commit -m 'test'  ;  git status  ;   git push -u origin master"
out1 "Passwords to access GitHub were disabled on August 2021, you must generate a token on your account and use that"
out1 "Two ways to create a new GitHub project"
out1 "gh auth login --with-token < ~/.mytoken   # login to GitHub account"
out1 "git init my-project                       # create a new project normally with git, creates the folder and .git subfolder"
out1 "cd my-project"
out1 "gh repo create my-project --confirm --public   # change to --private if required"
out1 "cd ..; rm -rf my-project                  # Delete the project locally so that we can clone it with authentication"
out1 "git clone --depth=1 https://roysubs:my-project@github.com/roysubs/my-project"
# This function is a work in progress, to automate the above, only problem is deleting folders can be risky if an existing project is there, have to make it check if the folder exists or if the project exists on GitHub already
# githubnew() { [ $# -ne 3 ] && echo "123" && return; gh auth login --with-token < $3; git init $2; cd $2; gh repo create $2 --confirm --public; cd ..; rm -rfi $2; git clone --depth=1 https://$1:$3@github.com/$1/$2; }
# This function shows all public projects for a given username
# getgituser() { curl -s https://api.github.com/users/$1/repos?per_page=1000 | grep git_url | awk '{print $2}'| sed 's/"\(.*\)",/\1/'; }   # Get all visible repositories for a given git account $1 https://stackoverflow.com/questions/42832359/how-to-search-repositories-with-github-api-v3-based-on-language-and-user-name
# Parse a git branch. Have taken these 3 functions out of .custom as trying to reduce the size there.
# gitbranch() { git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'; }   
out1 ""
out1 "\""   # require final line with a single " to end the multi-line text variable
out1 "echo -e \"\$HELPNOTES\""
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
    out1() { echo "$1" >> $HELPFILE; }
    echo "#!/bin/bash" > $HELPFILE
    out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
    out1 "HELPNOTES=\""
    out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small WSL Help)\${NC}"
    out1 ""
    out1 "You can start the distro from the Ubuntu icon on the Start Menu, or by running 'wsl' or 'bash' from a PowerShell"
    out1 "or CMD console. You can toggle fullscreen on WSL/CMD/PowerShell (native consoles or also in Windows Terminal sessions)"
    out1 "with 'Alt-Enter'. Registered distros are automatically added to Windows Terminal."
    out1 ""
    out1 "Right-click on WSL title bar and select Properties, then go to options and enable Ctrl-Shift-C and Ctrl-Shift-V"
    out1 "To access WSL folders: go into bash and type:   explorer.exe .    (must use .exe or will not work),   or, from Explorer, \\wsl$"
    out1 "From here, I can use GUI tools like BeyondCompare (to diff files easily, much easier than pure console tools)."
    out1 ""
    out1 "Run the following to alter the jarring Windows Event sounds inside WSL sessions (it is run automatically by custom_bash.sh):"
    out1 "\\\$toChange = @(\\\".Default\\\",\\\"SystemAsterisk\\\",\\\"SystemExclamation\\\",\\\"Notification.Default\\\",\\\"SystemNotification\\\",\\\"WindowsUAC\\\",\\\"SystemHand\\\")"
    out1 "foreach (\\\$c in \\\$toChange) { Set-ItemProperty -Path \\\"HKCU:\\\AppEvents\\\Schemes\\\Apps\\\.Default\\\\\\\$c\\\.Current\\\" -Name \\\"(Default)\\\" -Value \\\"C:\\WINDOWS\\media\\ding.wav\\\" }"
    out1 ""
    out1 "\${BYELLOW}***** Breaking a hung Windows session when Ctrl+Alt+Del doesn't work\${NC}"
    out1 "In this case, to see Task manager, try Alt+Tab and *hold* Alt for a few seconds to get Task manager preview."
    out1 "Also press Alt+D to switch out of not-very-useful Compact mode and into Details mode."
    out1 "With Task manager open, press Alt+O followed by Alt+D to enable 'Always on Top'."
    out1 "But something that might be even better is to Win+Tab to get the Switcher, then press the '+' at top left to create a new virtual desktop, giving you a clean desktop with nothing on it. In particular, the hung application is not on this desktop, and you can run Task manager here to use it to terminate the hung application."
    out1 ""
    out1 "\${BYELLOW}***** Windows Terminal (wt) via PowerShell Tips and Split Panes\${NC}"
    out1 "Double click on a tab title to rename it (relating to what you are working on there maybe)."
    out1 "Alt+Shift+PLUS (vertical split of your default profile), Alt+Shift+MINUS (horizontal)."
    out1 "Click the new tab button, then hold down Alt while pressing a profile, to open an 'auto' split (will vertical or horizontal to be most square)"
    out1 "Click on a tab with mouse or just Alt-CursorKey to move to different tabs."
    out1 "To resize, hold down Alt+Shift, then CursorKey to change the size of the selected pane."
    out1 "Close focused pane or tab with Ctrl+Shift+W. If you only have one pane, this close the tab or window if only one tab."
    out1 "https://powershellone.wordpress.com/2021/04/06/control-split-panes-in-windows-terminal-through-powershell/"
    out1 "To make bash launch in ~ instead of /mnt/c/Users in wt, open the wt Settings, find WSL2 profile, add \\\"commandline\\\": \\\"bash.exe ~\\\" (remember a comma after the previous line to make consistent), or \\\"startingDirectory\\\": \\\"//wsl$/Ubuntu/home/\\\"."
    out1 ""
    out1 "\${BYELLOW}***** Important Docker tips for WSL\${NC}"
    out1 "https://abdus.dev/posts/fixing-wsl2-localhost-access-issue/"
    out1 ""
    out1 "\${BYELLOW}***** To enable 'root'\${NC}"
    out1 "By default on Ubuntu, root has no password and 'su -' will not work."
    out1 "https://msdn.microsoft.com/en-us/commandline/wsl/user_support"
    out1 "The Windows user owns the VM, so from PowerShell/Cmd, run 'wsl -d <distro-name> -u root' to enter the VM as root."
    out1 "Now run 'passwd root' and set the password for root, then 'exit' to return to Windows shell."
    out1 "To change default user::   ubuntu.exe config --default-user [user]"
    out1 "In legacy versions 1703, 1709, it was:   lxrun /setdefaultuser [user]"
    out1 "A restart may be required:   wsl -d <distro_name> --terminate"
    out1 "Go back into the VM normally, and you should not be able to run 'su -' to become root."
    out1 "Can now use 'su':   su -h,   su -    will take you to 'root'"
    out1 "- or -l or -login [user]: Runs login script and switch to a specific username, if no user specified, use 'root'"
    out1 "su -c [command] [user]    # Run a single command as antoher user."
    out1 "su -s /usr/bin/zsh        # Open root user in Z shell."
    out1 "su -p [other_user]        # Keep environment of current user account, keep the same home directory."
    out1 ""
    out1 "Upgrade Ubuntu to 20.10 inside WSL: https://discourse.ubuntu.com/t/installing-ubuntu-20-10-on-wsl/18941"
    out1 "sudo sed --in-place 's/focal/groovy/g' /etc/apt/sources.list"
    out1 "sudo apt update -y && sudo apt upgrade -y"
    out1 "This guide required more to get working https://www.windowscentral.com/how-upgrade-ubuntu-2010-wsl-windows-10"
    out1 "sudo vi /etc/update-manager/release-upgrades   # Change lts to normal on last line"
    out1 "sudo do-release-upgrade -d"
    out1 ""
    out1 "\""   # require final line with a single " to end the multi-line text variable
    out1 "echo -e \"\$HELPNOTES\\n\""
    chmod 755 $HELPFILE

    ####################
    #
    echo "WSL X Window Setup (show with 'help-wsl-x')"
    #
    ####################
    HELPFILE=$hh/help-wsl-x.sh
    out1() { echo "$1" >> $HELPFILE; }
    echo "#!/bin/bash" > $HELPFILE
    out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
    out1 "HELPNOTES=\""
    out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small WSL X Window GUI)\${NC}"
    out1 ""
    out1 "GUI apps that run in WSL:"
    out1 "gnome-system-monitor"
    out1 ""
    out1 "\${BYELLOW}***** Run X-Display GUI from WSL\${NC}"
    out1 "https://ripon-banik.medium.com/run-x-display-from-wsl-f94791795376"
    out1 "https://github.com/microsoft/WSL/issues/4793#issuecomment-577232999"
    out1 "https://blog.nimamoh.net/wsl2-and-vcxsrv/"
    out1 "https://github.com/cascadium/wsl-windows-toolbar-launcher"
    out1 "Require to run X apps as WSL distro does not come with GUI, so we need to install an X-Server on Windows."
    out1 "1. Install VcXsrv Windows X Server: choco install vcxsrv -y   or   https://sourceforge.net/projects/vcxsrv/"
    out1 "2. Configure: Multiple Windows, Start no client, Clipboard, Primary Selection, Native OpenGL, Disable access control"
    out1 "3. Enable Outgoing Connection from Windows Firewall:"
    out1 "   Windows Security -> Firewall & network protection -> Allow an app through firewall -> make sure VcXsrv has both public and private checked."
    out1 "4. Configure WSL to use the X-Server, you can put that at the end of ~/.bashrc to load it every log in"
    out1 "   export DISPLAY=\\\"\$(/sbin/ip route \| awk '/default/ { print \$3 }'):0\\\""
    out1 "5. Create a .xsession file in the user home directory e.g."
    out1 "   echo xfce4-session > ~/.xsession"
    out1 "6. Test by running xeyes"
    out1 "   sudo apt install x11-apps"
    out1 "Now run 'xeyes' and you should be able to see the the xeyes application"
    out1 "After reboots, can run XLaunch from Start:"
    out1 "   Multiple Windows, Start no client, Clipboard, Primary Selection, Native OpenGL, and also: Disable access control"
    out1 "Can also auto start VcXsrv with Win+R then:   shell:startup"
    out1 "Right click > new > shortcut"
    out1 "Enter shortcut location to \\\"C:\\Program Files\\VcXsrv\\\\\\vcxsrv.exe\\\" -ac -multiwindow"
    out1 "-ac : accept any client connection, ok for a home desktop, but be careful of these kind of options on a mobile device like a laptop."
    out1 "Troubleshooting: can check that no blocking rule exist for VcXsrv windows xserver in your firewall configuration:"
    out1 "   Win+R then:   wf.msc  , Click on inbound rule. Delete each blocking rule for VcXsrv windows xserver"
    out1 ""
    out1 "\""   # require final line with a single " to end the multi-line text variable
    out1 "echo -e \"\$HELPNOTES\\n\""
    chmod 755 $HELPFILE

    ####################
    #
    echo "WSL Sublime GUI X Window App (show with 'help-wsl-sublime')"
    #
    ####################
    HELPFILE=$hh/help-wsl-sublime.sh
    out1() { echo "$1" >> $HELPFILE; }
    echo "#!/bin/bash" > $HELPFILE
    out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
    out1 "HELPNOTES=\""
    out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small Sublime on WSL)\${NC}"
    out1 ""
    out1 "# This is to demonstrate running a full GUI app within WSL:"
    out1 "sudo apt update"
    out1 "sudo apt install apt-transport-https ca-certificates curl software-properties-common"
    out1 "# Import the repository’s GPG key using the following:"
    out1 "curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -"
    out1 "# Add Sublime Text APT repository:"
    out1 "sudo add-apt-repository \\\"deb https://download.sublimetext.com/apt/stable/\\\""
    out1 "# Update apt sources then you can install Sublime Text 3:"
    out1 "sudo apt update"
    out1 "sudo apt install sublime-text"
    out1 "# It might be required to create a symbolic link (but this should be automatic):"
    out1 "# sudo ln -s /opt/sublime/sublime_text /usr/bin/subl"
    out1 "Start Sublime from console (with & to prevent holding console):"
    out1 "subl file.ext &"
    out1 ""
    out1 "\""   # require final line with a single " to end the multi-line text variable
    out1 "echo -e \"\$HELPNOTES\\n\""
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
    out2() { printf "$1\n" >> $HELPFILE; }   # echo without '-e'
    printf "#!/bin/bash\n" > $HELPFILE
    out2 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
    out2 'HELPNOTES="'
    out2 '${BCYAN}$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small WSL Audio Setup)${NC}'
    out2 ''
    out2 '${BYELLOW}***** To enable sound (PulseAudio) on WSL2:${NC}'
    out2 'https://www.linuxuprising.com/2021/03/how-to-get-sound-pulseaudio-to-work-on.html'
    out2 'https://www.linuxuprising.com/2021/03/how-to-get-sound-pulseaudio-to-work-on.html'
    out2 'https://x410.dev/cookbook/wsl/enabling-sound-in-wsl-ubuntu-let-it-sing/'
    out2 'Download the zipfile with preview binaries https://www.freedesktop.org/wiki/Software/PulseAudio/Ports/Windows/Support/'
    out2 'Current is: http://bosmans.ch/pulseaudio/pulseaudio-1.1.zip (but check for newer from above)'
    out2 ''
    out2 '${BYELLOW}***** Setup PulseAudio:${NC}'
    out2 'Copy the \\"bin\\" folder from pulseaudio zip file to C:\\\\\\bin'
    out2 'Rename bin folder to C:\pulse (this contains the pulseaudio.exe)'
    out2 'Create C:\pulse\config.pa and add the following to that file:'
    out2 'load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1;172.16.0.0/12'
    out2 'load-module module-esound-protocol-tcp auth-ip-acl=127.0.0.1;172.16.0.0/12'
    out2 'load-module module-waveout sink_name=output source_name=input record=0'
    out2 'This allows connections from 127.0.0.1 which is the local IP address'
    out2 '172.16.0.0/12 is the default WSL2 space (172.16.0.0 - 172.31.255.255)'
    out2 ''
    out2 '${BYELLOW}***** WSL settings:${NC}'
    out2 'On WSL Linux, install libpulse0 (available on Ubuntu, but not CentOS):'
    out2 'sudo apt install libpulse0'
    out2 'Add the following to ~/.bashrc:'
    out2 "export HOST_IP=\\\\\"\\\$(ip route |awk '/^default/{print \\\\\$3}')\\\\\""
    out2 'export PULSE_SERVER=\\"tcp:\$HOST_IP\\"'
    out2 '# export DISPLAY=\\"\$HOST_IP:0.0\\"   # This format if certain you are on 0:0'
    out2 ''
    out2 '${BYELLOW}***** NSSM (non-sucking service manager):${NC}'
    out2 'Get NSSM from https://nssm.cc/download'
    out2 'Copy nssm.exe to C:\pulse\nssm.exe, then run:'
    out2 'C:\\\\\\pulse\\\\\\nssm.exe install PulseAudio'
    out2 'Application path:  C:\pulse\pulseaudio.exe'
    out2 'Startup directory: C:\pulse'
    out2 'Arguments:         -F C:\pulse\config.pa --exit-idle-time=-1'
    out2 'Service name should be automatically filled when the NSSM dialog opens: PulseAudio'
    out2 'On the Details tab, enter PulseAudio in the Display name field'
    out2 'pulseaudio -F, to run the specified script on startup'
    out2 'pulseaudio --exit-idle-time=-1 disables the option to terminate the daemon after a number of seconds of inactivity.'
    out2 ''
    out2 '${BYELLOW}***** Remove NSSM and Troubleshooting:${NC}'
    out2 'If you want to remove this service at some point:   C:\pulse\nssm.exe remove PulseAudio'
    out2 'PulseAudio is installed as a service (in Windows), so starts at every login (no need to start manually).'
    out2 ''
    out2 '"'   # require final line with a single " to end the multi-line text variable
    out2 'printf "$HELPNOTES"'
    chmod 755 $HELPFILE

    ### This is the old version using echo -e
    # out1 "HELPNOTES=\""
    # out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small WSL Audio Setup)\${NC}"
    # out1 ""
    # out1 "\${BYELLOW}***** To enable sound (PulseAudio) on WSL2:\${NC}"
    # out1 "https://www.linuxuprising.com/2021/03/how-to-get-sound-pulseaudio-to-work-on.html"
    # out1 "Download the zipfile with preview binaries https://www.freedesktop.org/wiki/Software/PulseAudio/Ports/Windows/Support/"
    # out1 "Current is: http://bosmans.ch/pulseaudio/pulseaudio-1.1.zip (but check for newer from above)"
    # out1 "Copy the 'bin' folder from there to C:\\ bin and rename to C:\\pulse (this contains the pulseaudio.exe)"
    # out1 "Create C:\\ pulse\\ config.pa and add the following to that file:"
    # out1 "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1;172.16.0.0/12"
    # out1 "load-module module-esound-protocol-tcp auth-ip-acl=127.0.0.1;172.16.0.0/12"
    # out1 "load-module module-waveout sink_name=output source_name=input record=0"
    # out1 "This allows connections from 127.0.0.1 which is the local IP address, and 172.16.0.0/12 which is the default space (172.16.0.0 - 172.31.255.255) for WSL2."
    # out1 "On WSL Linux, install libpulse0 (available on Ubuntu, but not CentOS):"
    # out1 "sudo apt install libpulse0"
    # out1 "Add the following to ~/.bashrc:"
    # out1 "export HOST_IP=\\\"\$(ip route |awk '/^default/{print \\\$3}')\\\""
    # out1 "export PULSE_SERVER=\\\"tcp:\$HOST_IP\\\""
    # out1 "#export DISPLAY=\\\"\$HOST_IP:0.0\\\""
    # out1 "Get NSSM (non-sucking service manager) from https://nssm.cc/download"
    # out1 "Copy nssm.exe to C:\\pulse\\ nssm.exe, then run:"
    # out1 "C:\\pulse\\ nssm.exe install PulseAudio"
    # out1 "Application path:  C:\\pulse\\pulseaudio.exe"
    # out1 "Startup directory: C:\\pulse"
    # out1 "Arguments:         -F C:\pulse\\ config.pa --exit-idle-time=-1"
    # out1 "Service name should be automatically filled when the NSSM dialog opens: PulseAudio"
    # out1 "On the Details tab, enter PulseAudio in the Display name field"
    # out1 "In the Arguments field we're using -F, which tells PulseAudio to run the specified script on startup, while --exit-idle-time=-1 disables the option to terminate the daemon after a number of seconds of inactivity."
    # out1 "If you want to remove this service at some point:   C:\pulse\ nssm.exe remove PulseAudio"
    # out1 "Since we've installed PulseAudio as a service on Windows 10, once started, it will automatically start when you login to your Windows desktop, so there's no need to start it manually again."
    # out1 "\""   # require final line with a single " to end the multi-line text variable
    # out1 "echo -e \"\$HELPNOTES\\n\""




    ####################
    #
    echo "WSL SSHD Server Notes (show with 'help-wsl-sshd')"
    #
    ####################
    HELPFILE=$hh/help-wsl-sshd.sh
    out1() { echo "$1" >> $HELPFILE; }
    echo "#!/bin/bash" > $HELPFILE
    out1 "BLUE='\\033[0;34m'; RED='\\033[0;31m'; BCYAN='\\033[1;36m'; BYELLOW='\\033[1;33m'; NC='\\033[0m'"
    out1 "HELPNOTES=\""
    out1 "\${BCYAN}\$(type figlet >/dev/null 2>&1 && figlet -w -t -k -f small WSL SSHD Server)\${NC}"
    out1 ""
    out1 "Connect to WSL via SSH: https://superuser.com/questions/1123552/how-to-ssh-into-wsl"
    out1 "SSH into a WSL2 host remotely and reliably: https://medium.com/@gilad215/ssh-into-a-wsl2-host-remotely-and-reliabley-578a12c91a2"
    out1 "sudo apt install openssh-server # Install SSH server"
    out1 "/etc/ssh/sshd_config # Change Port 22 to Port 2222 as Windows uses port 22"
    out1 "sudo visudo  # We setup service ssh to not require a password"
    out1 ""
    out1 "# Allow members of group sudo to execute any command"
    out1 "%sudo   ALL=(ALL:ALL) ALL"
    out1 "%sudo   ALL=NOPASSWD: /usr/sbin/service ssh *"
    out1 ""
    out1 "sudo service ssh --full-restart # Restart ssh service  sudo /etc/init.d/ssh start"
    out1 "You might see: sshd: no hostkeys available -- exiting"
    out1 "If so, you need to run: sudo ssh-keygen -A to generate in /etc/ssh/"
    out1 "Now restart the server: sudo /etc/init.d/ssh start"
    out1 "You might see the following error on connecting: \\\"No supported authentication methods available (server sent: publickey)\\\""
    out1 "To fix this, sudo vi /etc/ssh/sshd_config. Change as follows to allow username/password authentication:"
    out1 "PasswordAuthentication = yes"
    out1 "ChallengeResponseAuthentication = yes"
    out1 "Restart ssh sudo /etc/init.d/ssh restart (or sudo service sshd restart)."
    out1 "Note: If you set PasswordAuthentication to yes and ChallengeResponseAuthentication to no you are able to connect automatically with a key, and those that don't have a key will connwct with a password - very useful"
    out1 ""
    out1 "# Using PuttyGen, keygen-ssh and authorized_keys"
    out1 "PuttyGen will create a public key file that looks like:"
    out1 ""
    out1 "---- BEGIN SSH2 PUBLIC KEY ----"
    out1 "Comment: \\\"rsa-key-20121022\\\""
    out1 "AAAAB3NzaC1yc2EAAAABJQAAAIEAhGF6GIuMY8FJ1+CNApnSY1N2YSlkYz72Yvwu"
    out1 "a6N1nFpBklz1+dsIMg4rcTLcF34M/tW5Yz+NUDAw2AEbxQ32FPgw7sAOIXktkYOH"
    out1 "tr7mmimiTjkoSCrJh1kqalPSpi8rglT/Bp67Ql2SZwvUFfMzHISryR0EZC4rXP/u"
    out1 "vObrJe8="
    out1 "---- END SSH2 PUBLIC KEY ----"
    out1 ""
    out1 "However, this will not work, so what you need to do is to open the key in PuttyGen, and then copy it from there (this results in the key being in the right format and in 1 line):"
    out1 ""
    out1 "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAIEAhGF6GIuMY8FJ1+CNApnSY1N2YSlkYz72Yvwua6N1nFpBklz1+dsIMg4rcTLcF34M/tW5Yz+NUDAw2AEbxQ32FPgw7sAOIXktkYOHtr7mmimiTjkoSCrJh1kqalPSpi8rglT/Bp67Ql2SZwvUFfMzHISryR0EZC4rXP/uvObrJe8= rsa-key-20121022"
    out1 ""
    out1 "Paste this into authorized_keys then it should work."
    out1 ""
    out1 "\""   # require final line with a single " to end the multi-line text variable
    out1 "echo -e \"\$HELPNOTES\\n\""
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
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/python3" > $HELPFILE
out1 "# Python 3 server example on port 8001"
out1 "# Copy this script into your home folder to work with if required as the"
out1 "# copy in $hh may be overwritten by .custom configuration periodically."
out1 "# The .custom function 'pyweb3example' will look first in ~, then in"
out1 "# $hh only if if there is no working copy in ~."
out1 "# If you open an url like http://127.0.0.1/example the method do_GET() is called."
out1 "# We send the webpage manually in this method, web server in python 3"
out1 "# The variable self.path returns the web browser url requested. In this case it would be /example"
out1 ""
out1 "from http.server import BaseHTTPRequestHandler, HTTPServer"
out1 "import time"
out1 ""
out1 "hostName = \"localhost\""
out1 "serverPort = 8001"
out1 ""
out1 "class MyServer(BaseHTTPRequestHandler):"
out1 "    def do_GET(self):"
out1 "        self.send_response(200)"
out1 "        self.send_header(\"Content-type\", \"text/html\")"
out1 "        self.end_headers()"
out1 "        self.wfile.write(bytes(\"<html><head><title>https://pythonbasics.org</title></head>\", \"utf-8\"))"
out1 "        self.wfile.write(bytes(\"<p>Request: %s</p>\" % self.path, \"utf-8\"))"
out1 "        self.wfile.write(bytes(\"<body>\", \"utf-8\"))"
out1 "        self.wfile.write(bytes(\"<p>This is an example web server.</p>\", \"utf-8\"))"
out1 "        self.wfile.write(bytes(\"</body></html>\", \"utf-8\"))"
out1 ""
out1 "if __name__ == \"__main__\":        "
out1 "    webServer = HTTPServer((hostName, serverPort), MyServer)"
out1 "    print(\"Server started http://%s:%s\" % (hostName, serverPort))"
out1 ""
out1 "    try:"
out1 "        webServer.serve_forever()"
out1 "    except KeyboardInterrupt:"
out1 "        pass"
out1 ""
out1 "    webServer.server_close()"
out1 "    print(\"Server stopped.\")"
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
out1() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
out1 "[[ ! -d ~/liquidprompt ]] && git clone --branch stable https://github.com/nojhan/liquidprompt.git ~/liquidprompt"
out1 "[[ \$- = *i* ]] && source ~/liquidprompt/liquidprompt"
out1 "[[ \$- = *i* ]] && source ~/liquidprompt/themes/powerline/powerline.theme"
out1 "[[ \$- = *i* ]] && lp_theme powerline"
out1 "echo ''"
out1 "echo https://liquidprompt.readthedocs.io/_/downloads/en/v2.0.0-rc.1/pdf/"
out1 "echo Alternatives Prompt Projects:"
out1 "echo https://github.com/chris-marsh/pureline https://github.com/reujab/silver"
out1 "echo ''"
out1 "echo 'Some adaptive info Liquid Prompt may display as needed::'"
out1 "echo '- Error code of the last command if it failed in some way (in red at end of prompt).'"
out1 "echo '- Number of attached running jobs (commands started with a &), if there are any;'"
out1 "echo '- Mumber of attached sleeping jobs (when you interrupt a command with Ctrl-Z and bring it back with fg), if there are any;'"
out1 "echo '- Average processors load (if over a given limit with a colormap for increasing load).'"
out1 "echo '- Number of detached sessions (screen or tmux), if any.'"
out1 "echo '- Current host if connected via SSH (either a blue hostname or different colors for different hosts).'"
out1 "echo '- Adaptive branch, added/delted lines, pending commits etc if in aersion control repository (git, mercurial, subversion, bazaar or fossil).'"
out1 "echo ''"
out1 "echo 'The default settings are good in most cases, but can be altered as follows:'"
out1 "echo '# cp ~/liquidprompt/liquidpromptrc-dist ~/.liquidpromptrc'"
out1 "echo '# vi ~/.liquidpromptrc'"
out1 "echo ''"
out1 "echo LiquidPrompt requires a NerdFont to display icons correctly:"
out1 "echo https://www.nerdfonts.com/ https://github.com/ryanoasis/nerd-fonts https://morioh.com/p/a313770dba7a"
out1 "echo ''"
chmod 755 $HELPFILE



echo ""



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
echo "If ./.custom exists here (and this session is an interactive login and pwd is not "\$HOME"), then copy it to the home directory."
if [ -f ./.custom ] && [[ $- == *"i"* ]] && [[ ! $(pwd) == $HOME ]]; then
    echo "i.e. [ -f ./.custom ] *and* [[ \$- == *"i"* ]] *and* [[ $(pwd) != \$HOME ]] are all TRUE"
    cp ./.custom ~/.custom   # This will overwrite the copy in $HOME
elif [ ! -f ~/.custom ] && [[ $- == *"i"* ]]; then
    echo "As ~/.custom is still not in \$HOME, we must get the latest version from Github."
    echo "curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > ~/.custom"
    curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > ~/.custom   # Download new .custom
fi

echo ""
echo "Useful options in the custom_bash toolkit:"
echo "- Run 'def <command>' against any function or alias to get it's definition"
echo "- Run 'updistro' to follow correct update/upgrade actions (use 'def updistro' for full details)."
echo "- Run 'aaa' / 'fff' / 'aaff' to view all aliases / functions / aliases-and-functions."
echo "- Type 'help-' then <tab><tab> to show the help library installed by custom_loader.sh."
echo "- Set 'sudo timeou' to 10 hours => 'sudo visudo', then add additional line:   Defaults timestamp_timeout=600"
echo ""
# Only show the following lines if WSL is detected
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    echo ""
    echo "This session is running inside WSL (Windows Subsystem for Linux), so following extended functions apply:"
    echo "- For WSL consoles (i.e. if not in putty): Can toggle fullscreen mode with Alt-Enter."
    echo "- For WSL consoles: Right-click on title bar > Properties > Options > 'Use Ctrl+Shift+C/V as Copy/Paste'."
    echo "- From bash, view WSL folders in Windows Eplorer: 'explorer.exe .' (note the '.exe'), or from Explorer, '\\\\wsl$'."
    echo "- To access Windows from bash: 'cd /mnt/c' etc, .custom has 'alias c:='cd /mnt/c' (also 'd:', 'e:', 'home:', 'pf:', 'sys32:' etc)"
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
