exe() { printf "\n"; echo "\$ ${@/eval/}"; "$@"; }

MANAGER=xxx
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

function runAptGetUpdate()   # This is not working fully. On a newly installed instance, there is no last
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

runAptGetUpdate


if [ -f /var/run/reboot-required ]; then
    echo "" >&2
    echo "A reboot is required (/var/run/reboot-required is present)." >&2
    echo "If running in WSL, can shutdown with:   wsl.exe --terminate \$WSL_DISTRO_NAME" >&2
    echo "Re-run this script after reboot to finish the install." >&2
    return
fi

