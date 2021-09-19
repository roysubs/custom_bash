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
# BEF (Bash Essential Functions) : https://github.com/shoogle/bash-essential-functions/blob/master/modules/bef-filepaths.sh
# Bash-it : https://www.tecmint.com/bash-it-control-shell-scripts-aliases-in-linux/
# https://www.digitalocean.com/community/tutorials/an-introduction-to-useful-bash-aliases-and-functions
# https://gitlab.com/bertrand-benoit/scripts-common
# https://opensource.com/article/19/7/bash-aliases
# https://src-r-r.github.io/articles/essential-bash-commands-to-make-life-easier/

####################
#
# Setup print_header() and exe() functions
#
####################

TMP="/tmp/custom_bash"
mkdir $TMP &> /dev/null

### print_header() will display up to 3 arguments as a simple banner
print_header() {
    printf "\n\n\n####################\n"
    printf "#\n"
    if [ "$1" != "" ]; then printf "# $1\n"; fi
    if [ "$2" != "" ]; then printf "# $2\n"; fi
    if [ "$3" != "" ]; then printf "# $3\n"; fi
    printf "#\n"
    printf "####################\n\n"
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
# Note 'install ca-certificates' to allow SSL-based applications to check for the authenticity of SSL connections

function getLastAptGetUpdate()
{
    local aptDate="$(stat -c %Y '/var/cache/apt')"   # %Y  time of last data modification, in seconds since Epoch
    local nowDate="$(date +'%s')"                    # %s  seconds since 1970-01-01 00:00:00 UTC
    echo $((nowDate - aptDate))                      # returns from the function the number of seconds since last /var/cache/apt update
}

function runAptGetUpdate()
{
    local updateInterval="${1}"
    local lastAptGetUpdate="$(getLastAptGetUpdate)"

    if [[ -z "$updateInterval" ]]   # "$(isEmptyString "${updateInterval}")" = 'true'
    then
        updateInterval="$((24 * 60 * 60))"   # Adjust this to how often to do updates, setting to 24 hours in seconds
    fi

    if [[ "${lastAptGetUpdate}" -gt "${updateInterval}" ]]   # only update if $updateInterval is more than 24 hours
    then
        print_header "apt updates will run as last update was more than '${updateInterval}' seconds ago"
        # echo -e "apt-get update"
        if [ "$MANAGER" == "apt" ]; then exe sudo apt --fix-broken install; fi   # Check and fix any broken installs, do before and after updates
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
        # echo -e "\nSkip apt-get update because its last run was '${lastUpdate}' ago"
        print_header "Skip apt-get update because its last run was '${lastUpdate}' ago"
    fi
}

runAptGetUpdate



if [ -f /var/run/reboot-required ]; then
    echo "" >&2
    echo "A reboot is required (/var/run/reboot-required is present)." >&2
    echo "If running in WSL, can shutdown with:   wsl.exe --terminate \$WSL_DISTRO_NAME" >&2
    echo "Re-run this script after reboot to finish the install." >&2
    return   # Script will exit here if a reboot is required
fi



####################
#
print_header "Check and install small/essential packages"
#
####################

INSTALL="sudo $MANAGER install"
if [ "$MANAGER" = "apk" ]; then INSTALL="$MANAGER add"; fi
# Only install each if not already installed
check_and_install() { which $1 &> /dev/null && printf "\n$1 is already installed" || exe $INSTALL $2 -y; }
# which dos2unix &> /dev/null || exe sudo $MANAGER install dos2unix -y

check_and_install dpkg dpkg     # 'Debian package' is the low level package management from Debian ('apt' is a higher level tool)
check_and_install apt apt-file  # find which package includes a specific file, or to list all files included in a package on remote repositories.
check_and_install git git
check_and_install vim vim
check_and_install curl curl
check_and_install wget wget
check_and_install perl perl
check_and_install python python
check_and_install pydf
check_and_install dos2unix dos2unix
check_and_install mount mount.cifs
check_and_install neofetch neofetch
# check_and_install screenfetch screenfetch   # Same as neofetch
check_and_install tree tree
check_and_install byobu byobu    # Also installs 'tmux' as a dependency
check_and_install zip zip
check_and_install unzip unzip
check_and_install pip pip
check_and_install lr lr          # lr (list recursively), all files under current location, also: tree . -fail / tree . -dfail
# check_and_install bat bat      # 'cat' clone with syntax highlighting and git integration, but downloads old version, so install manually
check_and_install ifconfig net-tools   # Package name is different from the 'ifconfig' tool that is wanted
check_and_install 7z p7zip-full        # Package name is different from the '7z' tool that is wanted
# which ifconfig &> /dev/null && printf "\np7zip-full is already installed" || exe sudo $MANAGER install net-tools -y
# which 7z &> /dev/null && printf "\np7zip-full is already installed" || exe sudo $MANAGER install p7zip-full -y
check_and_install fortune fortune
check_and_install cowsay cowsay
check_and_install figlet figlet
# Note that Ubuntu 20.04 could not see this in dnf repo until after full update, but built-in snap can see it
which figlet &> /dev/null || exe sudo snap install figlet -y

# More complex installers
curl --create-dirs -o ~/.config/up/up.sh https://raw.githubusercontent.com/shannonmoeller/up/master/up.sh   # echo 'source ~/.config/up/up.sh' >> ~/.bashrc   # For .custom
git clone https://github.com/zakkor/shortcut.git ~/.config/shortcut   # install.sh will create ~/.scrc for key-pairs and /usr/local/bin/shortcut.sh



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



# Some useful templates that could be used elsewhere:
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

if [ ! $(which bat) ]; then    # if 'bat' is not present, then try to get it
    ####################
    #
    print_header "Download 'bat' (syntax highlighted replacement for 'cat') manually to a known working version"
    #
    ####################
    echo "# Download and setup 'bat' so that .custom can alias 'cat' to use 'bat' instead"
    echo "# This provides same functionality as 'cat' but with colour syntax highlighting"
    # When we get the .deb file, the install syntax is:
    # sudo dpkg -i /tmp/bat-musl_0.18.3_amd64.deb   # install
    # sudo dpkg -r bat                              # remove

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
    IFS='\/' read -ra my_array <<< "$ver_and_filename"   # for i in "${my_array[@]}"; do echo $i; done
    ver=${my_array[0]}
    filename=${my_array[1]}
    IFS='.' read -ra my_array <<< "$filename"
    extension=${my_array[-1]}
    extension_with_dot="."$extension
    filename_no_extension=${filename%%${extension_with_dot}*}   # https://stackoverflow.com/questions/62657224/split-a-string-on-a-word-in-bash
    # various ways to get name without extension https://stackoverflow.com/questions/12152626/how-can-i-remove-the-extension-of-a-filename-in-a-shell-script
    echo $DL
    echo $ver_and_filename
    echo $ver
    echo $filename
    echo $extension
    echo $filename_no_extension

    [ ! -f /tmp/$filename ] && exe wget -P /tmp/ $DL       # 64-bit version
    which bat &> /dev/null || exe sudo dpkg -i /tmp/$filename   # if the 'bat' command is present, do nothing, otherwise install with dpkg

    # Using 'alien' to create a .rpm from a .deb   # https://forums.centos.org/viewtopic.php?f=54&t=75913
    if [ "$MANAGER" == "dnf" ] || [ "$MANAGER" == "yum" ]; then        
        exe sudo $MANAGER install perl-ExtUtils-Install
        exe sudo $MANAGER install make -y
        ALIENDL=https://sourceforge.net/projects/alien-pkg-convert/files/release/alien_8.95.tar.xz
        ALIENTAR=alien_8.95.tar.xz
        ALIENDIR=alien-8.95
        exe wget -P /tmp/ $ALIENDL
        tar xf $ALIENTAR
        cd /tmp/$ALIENDIR   # dnf install perl
        sudo perl Makefile.PL
        sudo make
        sudo make install
        cd ..
        sudo alien --to-rpm $filename     # bat-musl_0.18.3_amd64.deb
        # sudo rpm -ivh $FILE.rpm         # bat-musl-0.18.3-2.x86_64.rpm : note that the name has changed
        # Ideally, we should create a folder, create the output in there, then grab the name from there, since the name can change
    fi

    # sudo dpkg -r bat   # to remove after install
    # Also installs as part of 'bacula-console-qt' but that is 48 MB for the entire backup tool  
    rm /tmp/$filename
fi

# For CentOS
# Get latest tar.xz from https://sourceforge.net/projects/alien-pkg-convert/files/release/
# wget -c https://sourceforge.net/projects/alien-pkg-convert/files/release/alien_8.95.tar.xz
# tar xf alien_8.95.tar.xz
# dnf install perl
# perl Makefile.PL; make; make install
# alien --to-rpm file.deb   # where file.deb is the DEB package you have downloaded.
# rpm -ivh file.rpm
# https://linuxconfig.org/how-to-install-deb-file-in-redhat-linux-8

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
TMP=/tmp
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
# Note: cannot >> back to the same file being read, so use "| sudo tee --append ~/.vimrc"
# Note: cannot have multiple spaces "   " in a line or can't grep -qxF on that as the spaces are stripped

ADDFILE=~/.vimrc
function addToFile() { grep -qxF "$1" ~/.vimrc || echo $1 | tee --append $ADDFILE; }

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

# You’ll be able to browse through your command line history, simply start typing a few letters of the command and then use the arrow up and arrow down keys to browse through your history. This is similar to using Ctrl+r to do a reverse-search in your Bash, but a lot more powerful, and a feature I use every day.

The .inputrc is basically the configuration file of readline - the command line editing interface used by Bash, which is actually a GNU project library. It is used to provide text related editing features, customized keybindings etc.
ADDFILE=~/.vimrc
function addToFile() { grep -qxF "$1" ~/.vimrc || echo $1 | tee --append $ADDFILE; }

INPUTRC='$include /etc/inputrc'   # include settings from /etc/inputrc
grep -qxF "$INPUTRC" ~/.inputrc || echo $INPUTRC | sudo tee --append ~/.inputrc
INPUTRC='# Set tab completion for cd to be non-case sensitive'
grep -qxF "$INPUTRC" ~/.inputrc || echo $INPUTRC | sudo tee --append ~/.inputrc
INPUTRC='set completion-ignore-case On'   # Set Tab completion to be non-case sensitive
grep -qxF "$INPUTRC" ~/.inputrc || echo $INPUTRC | sudo tee --append ~/.inputrc
INPUTRC='"\C-p":history-search-backward'
grep -qxF "$INPUTRC" ~/.inputrc || echo $INPUTRC | sudo tee --append ~/.inputrc
INPUTRC='"\C-n":history-search-forward'
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
print_header "HELP FILES : Will create various scripts to show notes and tips, then alias them in .custom"
#
####################

# Try to build a collection of common notes, summaries, tips, tricks to always be accessible from the console.
# Note the "" to surround the $1 string otherwise prefix/trailing spaces will be removed
# Note that using exx() requires escaping characters \$ \\ and " is awkward, requires \\\" (\\ => \ and \" => ")
# Using echo -e to display the final help file, as printf requires escaping "%" as "%%" or "\045" etc)
# This is a good template for creating help files for various summaries (could also do vim, tmux, etc)
# In .custom, we can then simply create aliases if the files exist:
# [ -f /tmp/help-byobu.sh ] && alias help-byobu='/tmp/help-byobu.sh' && alias help-b='/tmp/help-byobu.sh'   # for .custom
# https://www.shellscript.sh/tips/echo/



####################
#
echo "Help / summary notes for this instance is running inside a Hyper-V VM." "e.g. How to run full-screen and disable sleep"
#
####################

HELPFILE=/tmp/help-hyperv.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "HELPNOTES=\""
exx ""
exx "Step 1: 'dmesg | grep virtual' to check, then 'sudo vi /etc/default/grub'"
exx "   Change: GRUB_CMDLINE_LINUX_DEFAULT=\\\"quiet splash\\\""
exx "   To:     GRUB_CMDLINE_LINUX_DEFAULT=\\\"quiet splash video=hyperv_fb:1920x1080\\\""
exx "Adjust 1920x1080 to your current monitor resolution."
exx "Step 2: 'sudo reboot', then 'sudo update-grub', then 'sudo reboot' again."
exx ""
exx "From Hyper-V Manager dashboard, find the VM, and open Settings."
exx "Go to Integration Services tab > Make sure Guest services section is checked."
exx ""
exx "systemctl status sleep.target   # Show current sleep settings"
exx "sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target   # Disable sleep settings"
exx "sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target   # Enable sleep settings again"
exx "\""   # require final line with a single " to end the multi-line text variable
exx "echo -e \"\$HELPNOTES\\n\""
chmod 755 $HELPFILE
/tmp/help-hyperv.sh   # Display this immediately



####################
#
echo "Help / summary notes for byobu terminal multiplexer: /tmp/help-byobu.sh alias it in .custom"
#
####################

HELPFILE=/tmp/help-byobu.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "HELPNOTES=\""
exx "byobu is a suite of enhancements for tmux (on which it is built) with convenient shortcuts."
exx "Terminal multiplexers like tmux allow multiple panes and windows inside a single console."
exx "Note that byobu will connect to already open sessions by default (tmux just opens a new session by default)."
exx "byobu keybindings can be user defined in /usr/share/byobu/keybindings/"
exx ""
exx "byobu cheat sheet / keybindings: https://cheatography.com/mikemikk/cheat-sheets/byobu-keybindings/"
exx "byobu good tutorial: https://simonfredsted.com/1588   https://gist.github.com/jshaw/5255721"
exx "Learn byobu (enhancement for tmux) while listening to Mozart: https://www.youtube.com/watch?v=NawuGmcvKus"
exx "Learn tmux (all commands work in byobu also): https://www.youtube.com/watch?v=BHhA_ZKjyxo"
exx "Tutorial Part 1 and 2: https://www.youtube.com/watch?v=R0upAE692fY , https://www.youtube.com/watch?v=2sD5zlW8a5E , https://www.youtube.com/c/DevInsideYou/playlists"
exx "Byobu: https://byobu.org/​ , tmux: https://tmux.github.io/​ , Screen: https://www.gnu.org/software/screen/​"
exx "tmux and how to configure it, a detailed guide: https://thevaluable.dev/tmux-config-mouseless/"
exx "https://superuser.com/questions/423310/byobu-vs-gnu-screen-vs-tmux-usefulness-and-transferability-of-skills#423397"
exx ""
exx "- BASIC NOTES: Use, alias b='byobu' then 'b' to start, 'man byobu', F12-: then 'list-commands' to see all byobu terminal commands"
exx "  byobu-<tab><tab> to see all bash commands, can 'man' on each of these"
exx "  Shift-F1 (quick help, 'q' to exit), F1 (help/configuration UI, ESC to exit), F9 (byobu-config, but is same as F1)"
exx "  Alt-F12 (toggle mouse support on/off), or F12-: then 'set mouse on' / 'set mouse off'"
exx "  With mouse, click on panes and windows to switch. Scroll on panes with the mouse wheel or trackpad. Resize panes by dragging from edges"
exx "  Mouse support *breaks* copy/paste, but just hold down 'Shift' while selecting text and it works fine."
exx "  Byobu shortcuts can interfere with other application shortcuts. To toggle enabling/disabling byobu, use Shift-F12."
exx "  Ctrl-Shift-F12 for Mondrian Square (just a toy). Press Ctrl-D to kill this window."
exx ""
exx "- PANES: Ctrl-F2 (vertical split F12-%), Shift-F2 (horizontal split, F12-|) ('|' feels like it should be for 'vertical', so this is a little confusing)"
exx "  Shift-F3/F4 (jump between panes), Ctrl-F3/F4 (move a pane to a different location)"
exx "  Shift-<CursorKeys> (move between panes), Shift-Alt-<CursorKeys> (resize a pane), Shift-F8 (toggle pane arrangements)"
exx "  Shift-F9 (enter command to run in all visible panes)"
exx "  Shift-F8 (toggle panes through the grid templates), F12-z (toggle fullscreen/restore for a pane)"
exx "  Alt-PgUp (scroll up in current pane/window), Alt-PgDn (scroll down in current pane/window)"
exx "  Ctrl-F6 or Ctrl-D (kill the current pane that is in focus), or 'exit' in that pane"
exx "  Note: if the pane dividers disappear, press F5 to refresh status, including rebuilding the pane dividers."
exx ""
exx "- WINDOWS: F2 (new window in current session)"
exx "  Alt-Left/Right or F3/F4 (toggle through windows), Ctrl-Shift-F3/F4 (move a window left or right)  "
exx "  Ctrl-F6 or Ctrl-D (kill the current pane, *or* will kill the current window if there is only one pane), or 'exit' in that window"
exx ""
exx "- SESSIONS: Ctrl-Shift-F2 (new session i.e. a new tmux instance with only '0:-*'), Alt-Up/Down (toggle through sessions)"
exx "  F12-S (toggle through sessions with preview)"
exx "  F9: Enter command and run in all sessions"
exx "  F6 (detach the current session, leaving session running in background, and logout of byobu/tmux)"
exx "  Shift-F6 (detach the current, leaving session running in background, but do not logout of byobu/tmux)"
exx ""
exx "- F5 (reload profile, refresh status), Shift-F5 (toggle different status lines), Ctrl-Shift-F5 randomises status bar colours, to reset, use: rm ~/.byobu/color.tmux"
exx "  Alt-F5 (toggle UTF-8 support, refresh), Ctrl-F5 (reconnect ssh/gpg/dbus sockets)"
exx ""
exx "- F6 (detach session and logout), Shift-F6 (detach session and do not logout)"
exx "  Alt-F6 (detach ALL clients but this one), Ctrl-F6 (kill pane that is in focus)"
exx ""
exx "- F7 (enter scrollback history), Alt-PgUp/PgDn (enter and move through scrollback), Shift-F7 (save history to '\$BYOBU_RUN_DIR/printscreen')"
exx ""
exx "- F8 (rename window), Ctrl-F8 (rename session), Shift-F8 (toggle panes through the grid templates)"
exx ""
exx "- F12-: (to enable the internal terminal), then 'set mouse on', then ENTER to enable mouse mode."
exx "  For other commands, 'list-commands'"
exx "  F12-T (fullscreen graphical clock)"
exx "  To completely kill your session, and byobu in the background, type F12-: then 'kill-server'"
exx ""
exx "- 'b ls', 'b list-session' or 'b list-sessions'"
exx "  On starting byobu, session tray shows:   u  20.04 0:-*      11d12h 0.00 4x3.4GHz 12.4G3% 251G2% 2021-04-27 08:41:50"
exx "  u = Ubuntu, 20.04 = version, 0:~* is the session, 11d12h = uptime, 0.00 = ?, 4x3.40GHz = 3.4GHz Core i5 with 4 cores"
exx "  12.4G3% = 12.4 G free memory, 3% CPU usage,   251G2% = 251 G free space, 2% used, 2021-04-27 08:41:50 = date/time"
exx ""
exx "- byobu-<tab><tab> to see all byobu bash commands, can 'man <command>' on each of these"
exx "  byobu-config              byobu-enable-prompt       byobu-launcher            byobu-quiet               byobu-select-session      byobu-tmux"
exx "  byobu-ctrl-a              byobu-export              byobu-launcher-install    byobu-reconnect-sockets   byobu-shell               byobu-ugraph"
exx "  byobu-disable             byobu-janitor             byobu-launcher-uninstall  byobu-screen              byobu-silent              byobu-ulevel"
exx "  byobu-disable-prompt      byobu-keybindings         byobu-layout              byobu-select-backend      byobu-status"
exx "  byobu-enable              byobu-launch              byobu-prompt              byobu-select-profile      byobu-status-detail"
exx "\""   # require final line with a single " to end the multi-line text variable
exx "echo -e \"\$HELPNOTES\\n\""
chmod 755 $HELPFILE



####################
#
echo "Help / summary notes for tmux terminal multiplexer: /tmp/help-tmux.sh alias it in .custom"
#
####################

# Note the "" to surround the $1 string otherwise prefix/trailing spaces will be removed
# Using echo -e to display the final help file, as printf requires escaping "%" as "%%" or "\045" etc
# This is a good template for creating help files for various summaries (could also do vim, tmux, etc)
# In .custom, we can then simply create aliases if the files exist:
# [ -f /tmp/help-tmux.sh ] && alias help-tmux='/tmp/help-tmux.sh' && alias help-t='/tmp/help-tmux.sh'   # for .custom

# https://davidwinter.dev/tmux-the-essentials/
# https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/
# https://www.golinuxcloud.com/tmux-cheatsheet/
# https://tmuxguide.readthedocs.io/en/latest/tmux/tmux.html

HELPFILE=/tmp/help-tmux.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "HELPNOTES=\""
exx "tmux is a terminal multiplexer which allows multiple panes and windows inside a single console."
exx ""
exx "Essentials:  <C-b> means Ctrl-b  ,  <C-b> : => enter command mode"
exx "List sessions: tmux ls , tmux list-sessions  , <C-b> : ls"
exx "Show sessions: <C-b> s ,<C-b> w (window preview)"
exx ""
exx "Start a new session:  tmux , tmux new -s my1 , :new -s my1"
exx "Detach this session:  <C-b> d , tmux detach"
exx "Re-attach a session:  tmux a -t my1  (or by the index of the session)"
exx "Kill/Delete session:  tmux kill-sess -t my1  , all but current:  tmux kill-sess -a ,  all but 'my1':  tmux kill-sess -a -t my1"

exx "Ctrl + b $   Rename session,   Ctrl + b d   Detach from session"
exx "attach -d    Detach others on the session (Maximize window by detach other clients)"
exx ""
exx "tmux a / at / attach / attach-session   Attach to last session"
exx "tmux a -t mysession   Attach to a session with the name mysession"
exx ""
exx "Ctrl + b (  (move to previous session) , <C-b> b )  (move to next session)"

exx "Command	Description"
exx "tmux	start tmux"
exx "tmux new -s <name>	start tmux with <name>"
exx "tmux ls	shows the list of sessions"
exx "tmux a #	attach the detached-session"
exx "tmux a -t <name>	attach the detached-session to <name>"
exx "tmux kill-session –t <name>	kill the session <name>"
exx "tmux kill-server	kill the tmux server"
exx "Windows"
exx "tmux new -s mysession -n mywindow"
exx "start a new session with the name mysession and window mywindow"
exx ""
exx "Ctrl + b c"
exx "Create window"
exx ""
exx "Ctrl + b ,"
exx "Rename current window"
exx ""
exx "Ctrl + b &"
exx "Close current window"
exx ""
exx "Ctrl + b p"
exx "Previous window"
exx ""
exx "Ctrl + b n"
exx "Next window"
exx ""
exx "Ctrl + b 0 ... 9"
exx "Switch/select window by number"
exx ""
exx "swap-window -s 2 -t 1"
exx "Reorder window, swap window number 2(src) and 1(dst)"
exx ""
exx "swap-window -t -1"
exx "Move current window to the left by one position"
exx ""
exx "***** Panes"
exx "Splits:  Ctrl + b %  (horizontal)  ,  Ctrl + b \\\"  (vertical)"
exx "Moves:   <C-b> o  (next pane)  , <C-b> {  (left)  ,  <C-b> {  (right)  ,  <C-b> <cursor-key>  (move to pane in that direction)"
exx "         <C-b> ;  (toggle last active)  ,  <C-b> <space>  (toggle different pane layouts)"
exx "Send:    :setw sy (synchronize-panes, toggle sending all commands to all panes)"
exx "Index:   <C-b> q  (show pane indexes)  ,  <C-b> q 0 .. 9  (switch to a pane by its index) "
exx "Zoom:    <C-b> z  (toggle pane between full screen and back to windowed)"
exx "Resize:  <C-b> <C-cursor-key>  (hold down Ctrl, first press b, then a cursor, don't hold, press again for more resize)"
exx "Close:   <C-b> x  (close pane)"
exx ""

exx "Ctrl + b !"
exx "Convert pane into a window"
exx ""
exx "Copy Mode"
exx "setw -g mode-keys vi"
exx "use vi keys in buffer"
exx ""
exx "Ctrl + b ["
exx "Enter copy mode"
exx ""
exx "Ctrl + b PgUp"
exx "Enter copy mode and scroll one page up"
exx ""
exx "q"
exx "Quit mode"
exx ""
exx "g"
exx "Go to top line"
exx ""
exx "G"
exx "Go to bottom line"
exx ""
exx "Scroll up"
exx ""
exx "Scroll down"
exx ""
exx "h"
exx "Move cursor left"
exx ""
exx "j"
exx "Move cursor down"
exx ""
exx "k"
exx "Move cursor up"
exx ""
exx "l"
exx "Move cursor right"
exx ""
exx "w"
exx "Move cursor forward one word at a time"
exx ""
exx "b"
exx "Move cursor backward one word at a time"
exx ""
exx "/"
exx "Search forward"
exx ""
exx "?"
exx "Search backward"
exx ""
exx "n"
exx "Next keyword occurance"
exx ""
exx "N"
exx "Previous keyword occurance"
exx ""
exx "Spacebar"
exx "Start selection"
exx ""
exx "Esc"
exx "Clear selection"
exx ""
exx "Enter"
exx "Copy selection"
exx ""
exx "Ctrl + b ]"
exx "Paste contents of buffer_0"
exx ""
exx "show-buffer"
exx "display buffer_0 contents"
exx ""
exx "capture-pane"
exx "copy entire visible contents of pane to a buffer"
exx ""
exx "list-buffers"
exx "Show all buffers"
exx ""
exx "choose-buffer"
exx "Show all buffers and paste selected"
exx ""
exx "save-buffer buf.txt"
exx "Save buffer contents to buf.txt"
exx ""
exx "delete-buffer -b 1"
exx "delete buffer_1"
exx ""
exx "Misc"
exx "Ctrl + b :"
exx "Enter command mode"
exx ""
exx "set -g OPTION"
exx "Set OPTION for all sessions"
exx ""
exx "setw -g OPTION"
exx "Set OPTION for all windows"
exx ""
exx "set mouse on"
exx "Enable mouse mode"
exx ""
exx "Help"
exx "tmux list-keys"
exx "list-keys"
exx "Ctrl + b ?"
exx "List key bindings(shortcuts)"
exx ""
exx "tmux info"
exx "Show every session, window, pane, etc..."
exx ""
exx ""
exx "\""   # require final line with a single " to end the multi-line text variable
exx "echo -e \"\$HELPNOTES\\n\""
chmod 755 $HELPFILE



####################
#
echo "Help / summary notes for bash shell: /tmp/help-bash.sh alias it in .custom (useful refresher notes)"
#
####################

# [ -f /tmp/help-bash.sh ] && alias help-bash='/tmp/help-bash.sh'   # for .custom
HELPFILE=/tmp/help-bash.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "HELPNOTES=\""
exx "bash refresher notes..."
exx ""
exx "https://www.tecmint.com/linux-command-line-bash-shortcut-keys/"
exx "It doesn't make sense, but it's the convention. EDITOR used to be for instruction-based editors like ed. When editors with GUIs came about--and by GUI, I mean CLI GUI (vim, emacs, etc.--think ncurses), not desktop environment GUI--the editing process changed dramatically, so the need for another variable arose. In this context, CLI GUI and desktop environment GUI editors are more or less the same, so you can set VISUAL to either; however, EDITOR is meant for a fundamentally different workflow. Of course, this is all historical. Nobody uses ed these days."
exx "just setting EDITOR is not enough e.g. for git on Ubuntu 12.04. Without VISUAL being set git ignores EDITOR and just uses nano (the compiled in default, I guess). "
exx "\$VISUAL vs \$EDITOR C-x C-e to open vim automatically"
exx "https://ostechnix.com/navigate-directories-faster-linux/"
exx "https://itsfoss.com/linux-command-tricks/"
exx ""
exx "***** Bash variables, special invocations, keyboard shortcuts"
exx "\$\$  Get process id (pid) of the currently running bash script."
exx "\$n   Holds the arguments passed in while calling the script or arguments passed into a function inside the scope of that function. e.g: $1, $2… etc.,"
exx "\$0   The filename of the currently running script."
exx ""
exx "–   e.g.  cd –	     Last Working Directory"
exx "!!  e.g.  sudo !!   Last executed command"
exx "!$  e.g.  ls !$     Arguments of the last executed command"
exx ""
exx "Shortcut   Description"
exx "Tab        Autocomplete commands"
exx "Ctrl + a   Move to the beginning of a command"
exx "Ctrl + e   Move to the end of a command"
exx "Ctrl + w   Cut the word on the left side of the cursor"
exx "Ctrl + k   Cut all text on the right side of the cursor"
exx "Ctrl + u   Cut all text on the left side of the curor"
exx "Ctrl + r   Search the history of commands used"
exx "Ctrl + l   Clear Terminal"
exx "Ctrl + d   Logout of Terminal or ssh session"
exx "Alt + f    Move cursor to the next word"
exx "Alt + b    Move cursor to the previous word"
exx ""
exx "***** Break an SSH session"
exx "Sometimes, SSH sessions hang and Ctrl+c will not work, so that closing the terminal is the only option. There is a little known solution:"
exx "Hit 'Enter', '~' and '.' as a sequence (↵~.) and the broken session will be successfully terminated."
exx "\""   # require final line with a single " to end the multi-line text variable
exx "echo -e \"\$HELPNOTES\\n\""
chmod 755 $HELPFILE



####################
#
echo "Help / summary notes for Vim: /tmp/help-vim.sh alias it in .custom (useful refresher notes)"
#
####################

# [ -f /tmp/help-vim.sh ] && alias help-vim='/tmp/help-vim.sh' && alias help-vi='/tmp/help-vim.sh' && alias help-v='/tmp/help-vim.sh'   # for .custom
HELPFILE=/tmp/help-vim.sh
exx() { echo "$1" >> $HELPFILE; }
echo "#!/bin/bash" > $HELPFILE
exx "HELPNOTES=\""
exx "********************"
exx "* Vim Notes..."
exx "********************"
exx ""
# exx "Vim, Tips and tricks: https://www.cs.umd.edu/~yhchan/vim.pdf"
# exx "Vim, Tips And Tricks: https://www.tutorialspoint.com/vim/vim_tips_and_tricks.htm"
# exx "Vim, Tips And Tricks: https://www.cs.oberlin.edu/~kuperman/help/vim/searching.html"
# exx "8 Vim Tips And Tricks That Will Make You A Pro User: https://itsfoss.com/pro-vim-tips/"
# exx "Intro to Vim Modes: https://irian.to/blogs/introduction-to-vim-modes/"
# exx "Vim, Advanced Guide: https://thevaluable.dev/vim-advanced/"
# exx "Vim, Advanced Cheat Sheet: https://vimsheet.com/advanced.html https://vim.fandom.com/wiki/Using_marks"
# exx "https://www.freecodecamp.org/news/learn-linux-vim-basic-features-19134461ab85/"
# exx "https://vi.stackexchange.com/questions/358/how-to-full-screen-browse-vim-help"
# exx "https://phoenixnap.com/kb/vim-color-schemes https://vimcolorschemes.com/sainnhe/sonokai"
exx ""
exx ":Tutor<Enter>  30 min tutorial built into Vim."
exx "The clipboard or bash buffer can be accessed with Ctrl-Shift-v, use this to paste into Vim without using mouse right-click."
exx ":set mouse=a   # Mouse support ('a' for all modes, use   :h 'mouse'   to get help)."
exx ""
exx "***** MODES   :h vim-modes-intro"
exx "7 modes (normal, visual, insert, command-line, select, ex, terminal-job). The 3 main modes are normal, insert, and visual."
exx "i insert mode, Shift-I insert at start of line, a insert after currect char, Shift-A insert after line.   ':h A'"
exx "o / O create new line below / above and then insert, r / R replace char / overwrite mode, c / C change char / line."
exx "v visual mode (char), Shift-V to select whole lines, Ctrl-V to select visual block"
exx "Can only do visual inserts with Ctrl-V, then select region with cursors or hjkl, then Shift-I for visual insert (not 'i'), type edits, then Esc to apply."
exx "Could also use r to replace, or d to delete a selected visual region."
exx "Also note '>' to indent a selected visual region, or '<' to predent (unindent) the region."
exx ": to go into command mode, and Esc to get back to normal mode."
exx ""
exx "***** MOTIONS   :h motions"
exx "h/l left/right, j/k up/down, 'w' forward by word, 'b' backward by word, 'e' forward by end of word."
exx "^ start of line, $ end of line, 80% go to 80% position in the whole document. G goto line (10G is goto line 10)."
exx "'(' jump back a sentence, ')' jump forward a sentence, '{' jump back a paragraph, '}' jump forward a paragraph."
exx "Can combine commands, so 10j jump 10 lines down, 3w jump 3 words forward, 2} jump 2 paragraphs forward."
exx "/Power/	Go to the first line containing the string 'Power'."
exx "ddp	    Swap the current line with the next one."
exx "g;	    Bring back cursor to the previous position."
exx ":/friendly/m\$   Move the next line containing the string 'friendly' to the end of the file."
exx ":/Cons/+1m-2    Move two lines up the line following 'Cons'"
exx ""
exx "***** EDITING   :h edits"
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
exx "***** HELP SYSTEM   :h      Important to learn to navigate this.   ':h A', ':h I', ':h ctrl-w', ':h :e', ':h :tabe', ':h >>'"
exx "Even better, open the help in a new tab with ':tab help >>', then :q when done with help tab."
exx "Open all help"
exx "Maximise the window vertically with 'Ctrl-w _' or horizontally with 'Ctrl-w |' or 'Ctrl-w o' to leave only the help file open."
exx "Usually don't want to close everything, so 'Ctrl-w 10+' to increase current window by 10 lines is also good.   :h ctrl-w"
exx ""
exx "***** SUBSTITUTION   :h :s   :h s_flags"
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
exx "***** BUFFERS   :h buffers   Within a single window, can see buffers with :ls"
exx "vim *   Open all files in current folder (or   'vim file1 file2 file3'   etc)."
exx ":ls     List all open buffers (i.e. open files)   # https://dev.to/iggredible/using-buffers-windows-and-tabs-efficiently-in-vim-56jc"
exx ":bn, :bp, :b #, :b name to switch. Ctrl-6 alone switches to previously used buffer, or #ctrl-6 switches to buffer number #."
exx ":bnext to go to next buffer (:bprev to go back), :buffer <name> (Vim can autocomplete with <Tab>)."
exx ":bufferN where N is buffer number. :buffer2 for example, will jump to buffer #2."
exx "Jump between your last 'position' with <Ctrl-O> and <Ctrl-i>. This is not buffer specific, but it works. Toggle between previous file with <Ctrl-^>"
exx ""
exx "***** WINDOWS   :h windows-into  :h window  :h windows  :h ctrl-w  :h winc"
exx "vim -o *  Open all with horizontal splits,   vim -O *   Open all with vertical splits."
exx "<C-W>W   to switch windows (note: do not need to take finger off Ctrl after <C-w> just double press on 'w')."
exx "<C-W>N :sp (:split, :new, :winc n)  new horizontal split,   <C-W>V :vs (:vsplit, :winc v)  new vertical split"
exx ""
exx "***** TABS   :h tabpage   Tabbed multi-file editing is a available from Vim 7.0+ onwards (2009)."
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
exx "***** VIMRC OPTIONS   /etc/vimrc, ~/.vimrc"
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
exx "***** PLUGINS, VIM-PLUG    https://www.linuxfordevices.com/tutorials/linux/vim-plug-install-plugins"
exx "First, install vim-plug:"
exx "curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
exx "Then add the following lines to ~/.vimrc ("
exx "call plug#begin()"
exx "Plug 'tyru/open-browser.vim' \\\" opens url in browser"
exx "Plug 'http://github.com/tpope/vim-surround' \\\" Surrounding ysw)"
exx "Plug 'https://github.com/preservim/nerdtree', { 'on': 'NERDTreeToggle' }"
exx "Plug 'https://github.com/ap/vim-css-color' \\\" CSS Color Preview"
exx "Plug 'https://github.com/tpope/vim-commentary' \\\" For Commenting gcc & gc"
exx "call plug#end()"
exx "Save ~/.vimrc with :w, and then source it with :source %"
exx "Now install the plugins with :PlugInstall  (a side window will appear as the repo's clone to to ~/.vim/plugged)"
exx "Restart Vim and test that the plugins have installed with :NERDTreeToggle (typing 'N'<tab> should be enough)"
exx "vim-surround : \\\"Hello World\\\" => with cursor inside this region, press cs\\\"' and it will change to 'Hello World!'"
exx "   cs'<q> will change to <q></q> tag, or ds' to remove the delimiter. When on Hello, ysiw] will surround the wordby []"
exx "nerdtree : pop-up file explorer in a left side window, :N<tab> (or :NERDTree, or use :NERDTreeToggle to toggle) :h NERDTree.txt"
exx "vim-css-color"
exx "vim-commentary : comment and uncomment code, v visual mode to select some lines then 'gc'<space> to comment, 'gcgc' to uncomment."
exx "Folloing will toggle comment/uncomment by pressing <space>/ on a line or a visual selected region."
exx "nnoremap <space>/ :Commentary<CR>"
exx "vnoremap <space>/ :Commentary<CR>"
exx ""
exx "***** SPELL CHECKING / AUTOCOMPLETE"
exx ":setlocal spell spelllang=en   (default 'en', or can use 'en_us' or 'en_uk')."
exx "Then,  :set spell  to turn on and  :set nospell  to turn off. Most misspelled words will be highlighted (but not all)."
exx "]s to move to the next misspelled word, [s to move to the previous. When on any word, press z= to see list of possible corrections."
exx "Type the number of the replacement spelling and press enter <enter> to replace, or just <enter> without selection to leave, mouse support can click on replacement."
exx "Press 1ze to replace by first correction Without viewing the list (usually the 1st in list is the most likely replacement)."
exx "Autocomplete: Say that 'Fish bump consecrate day night ...' is in a file. On another line, type 'cons' then Ctrl-p, to autocomplete based on other words in this file."
exx ""
exx "***** SEARCH"
exx "/ search forwards, ? search backwards are well known but * and # are less so."
exx "* search for word nearest to the cursor (forward), and # (backwards)."
exx "Can repeat a search with / then just press Enter, but easier to use n, or N to repeat a search in the opposite direction."
exx ""
exx "***** PASTE ISSUES IN TERMINALS"
exx "Paste Mode: Pasting into Vim sometimes ends up with badly aligned result, especially in Putty sessions etc."
exx "Fix that with ':set paste' to put Vim in Paste mode before you paste, so Vim will just paste verbatim."
exx "After you have finished pasting, type ':set nopaste' to go back to normal mode where indentation will take place again."
exx "You normally only need :set paste in terminals, not in GUI gVim etc."
exx ""
exx "dos2unix can change line-endings in a file, or in Vim we can use  :%s/^M//g  (but use Ctrl-v Ctrl-m to generate the ^M)."
exx "you can also use   :set ff=unix   and vim will do it for you. 'fileformat' help  :h ff,  vim wiki: https://vim.fandom.com/wiki/File_format."
exx ""
exx "\""   # require final line with a single " to end the multi-line text variable
exx "echo -e \"\$HELPNOTES\\n\""
chmod 755 $HELPFILE



####################
#
echo "Help / summary notes for WSL integration: /tmp/help-wsl.sh alias it in .custom (useful refresher notes)"
#
####################

echo ""
echo "The following lines in a PowerShell console on Windows will alter the jarring Windows Event sounds that affect WSL sessions:"
echo ""
echo '$toChange = @(".Default","SystemAsterisk","SystemExclamation","Notification.Default","SystemNotification","WindowsUAC","SystemHand")'
echo 'foreach ($c in $toChange) { Set-ItemProperty -Path "HKCU:\AppEvents\Schemes\Apps\.Default\$c\.Current\" -Name "(Default)" -Value "C:\WINDOWS\media\ding.wav" }'
# Following command will run the above PowerShell from within this session to inject the registry changes:

# Create a template help-wsl for this and other important WSL points (only create if running WSL)
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then

    # Run the PowerShell to adjust the system 
    powershell.exe '$toChange = @(".Default","SystemAsterisk","SystemExclamation","Notification.Default","SystemNotification","WindowsUAC","SystemHand"); foreach ($c in $toChange) { Set-ItemProperty -Path "HKCU:\AppEvents\Schemes\Apps\.Default\$c\.Current\" -Name "(Default)" -Value "C:\WINDOWS\media\ding.wav" }'
    # [ -f /tmp/help-wsl.sh ] && alias help-wsl='/tmp/help-wsl.sh'   # for .custom
    HELPFILE=/tmp/help-wsl.sh
    exx() { echo "$1" >> $HELPFILE; }
    echo "#!/bin/bash" > $HELPFILE
    exx "HELPNOTES=\""
    exx "Quick WSL notes to remember..."
    exx ""
    exx "You can start the distro from the Ubuntu icon on the Start Menu, or by running 'wsl' or 'bash' from a PowerShell"
    exx "or CMD console. You can go into fullscreen on WSL/CMD/PowerShell (native consoles or also in Windows Terminal sessions)"
    exx "with 'Alt-Enter'. Registered distros are automatically added to Windows Terminal."
    exx ""
    exx "Right-click on WSL title bar and select Properties, then go to options and enable Ctrl-Shift-C and Ctrl-Shift-V"
    exx "To access WSL folders: go into bash and type:   explorer.exe .    (must use .exe or will not work),   or, from Explorer, \\wsl$"
    exx "From here, I can use GUI tools like BeyondCompare (to diff files easily, much easier than pure console tools)."
    exx ""
    exx "The following has been run by custom_bash.sh to alter the jarring Windows Event sounds inside WSL sessions:"
    exx ""
    exx '$toChange = @(".Default","SystemAsterisk","SystemExclamation","Notification.Default","SystemNotification","WindowsUAC","SystemHand")'
    exx 'foreach ($c in $toChange) { Set-ItemProperty -Path "HKCU:\AppEvents\Schemes\Apps\.Default\$c\.Current\" -Name "(Default)" -Value "C:\WINDOWS\media\ding.wav" }'
    exx ""
    exx "\""   # require final line with a single " to end the multi-line text variable
    exx "echo -e \"\$HELPNOTES\\n\""
    chmod 755 $HELPFILE
fi

####################
#
print_header "Run 'source ~/.custom' to load '.custom' into this current session"
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
# Only show the following lines if WSL is detected
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null ; then
    echo "For WSL consoles: Can go into fullscreen mode with Alt-Enter."
    echo "For WSL consoles: Right-click on title bar > Properties > Options > 'Use Ctrl+Shift+C/V as Copy/Paste."
    echo "From bash, view WSL folders in Windows Eplorer: 'explorer.exe .' (note the '.exe'), or from Explorer, '\\wsl$'."
    echo "Access Windows from bash: 'cd /mnt/c' etc, can use 'alias c:='cd /mnt/c && ll' and same for 'd', 'e' etc"
fi
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

# KEYBINDINGS
# byobu keybindings can be user defined in /usr/share/byobu/keybindings/ (or within .screenrc
# if byobu-export was used). The common key bindings are:
# 
#    F2 - Create a new window
#    F3 - Move to previous window
#    F4 - Move to next window
#    F5 - Reload profile
#    F6 - Detach from this session
#    F7 - Enter copy/scrollback mode
#    F8 - Re-title a window
#    F9 - Configuration Menu
#    F12 -  Lock this terminal
#
#    shift-F2 - Split horizontally         ctrl-F2  - Split the screen vertically
#    shift-F3 - Shift to previous split    shift-F4 - Shift the focus to the next split region
#    shift-F5 - Join all splits            ctrl-F6  - Remove this split
#
#    ctrl-F5 - Reconnect GPG and SSH sockets
#    shift-F6 - Detach, but do not logout
#    alt-pgup - Enter scrollback mode      alt-pgdn - Enter scrollback mode
#
#    Ctrl-a $ - show detailed status       Ctrl-a R - Reload profile
#    Ctrl-a k - Kill the current window    Ctrl-a ~ - Save the current window's scrollback buffer
#    Ctrl-a ! - Toggle key bindings on and off
#
# Most of Byobu's documentation exists in the form of traditional UNIX manpages.
# Although generated by Ubuntu, these HTML renderings of Byobu's manpages are generally applicable:
# 
# byobu, byobu-config, byobu-ctrl-a, byobu-disable, byobu-enable, byobu-export, byobu-janitor,
# byobu-launch, byobu-launcher, byobu-launcher-install, byobu-launcher-uninstall, byobu-layout,
# byobu-quiet, byobu-reconnect-sockets, byobu-screen, byobu-select-backend, byobu-select-profile,
# byobu-select-session, byobu-shell, byobu-silent, byobu-status, byobu-status-detail, byobu-tmux
# 
# /usr/share/doc/byobu/help.tmux.txt   
