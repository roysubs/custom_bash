getmystuff() {
    # Presents items from 'mylist' that are not already installed and offers to install them
    # Package names can be different in Debian/Ubuntu vs RedHat/Fedora/CentOS. e.g. python3.9 in Ubuntu is python39 in CentOS
    mylist=(); isinrepo=(); isinstalled=(); caninstall=(); endloop=0; toinstall=""
    mylist=(python3.9 python39 mc translate-shell how2 npm pv nnn alien angband dwarf-fortress nethack-console crawl bsdgames bsdgames-nonfree tldr tldr-py)

    type apt &> /dev/null && manager="apt" && apt list &> /dev/null > /tmp/all-repo.txt && apt list --installed &> /dev/null > /tmp/all-here.txt
    type dnf &> /dev/null && manager="dnf" && dnf list &> /dev/null > /tmp/all-repo.txt && dnf list installed   &> /dev/null > /tmp/all-here.txt
    for x in ${mylist[@]}; do grep "^$x/" /tmp/all-repo.txt &> /dev/null && isinrepo+=($x); done    # find items available in repo
    # echo -e "These are in the repo: ${isinrepo[@]}\n\n"   # $(for x in ${isinrepo[@]}; do echo $x; done)
    for x in ${mylist[@]}; do grep "^$x/" /tmp/all-here.txt &> /dev/null && isinstalled+=($x); done # find items already installed
    # echo -e "These are already installed: ${isinstalled[@]}\n\n"   # $(for x in ${isinstalled[@]}

    while [ $endloop = 0 ]; do
        caninstall=(Install-and-Exit)
        caninstall+=(`echo ${isinrepo[@]} ${isinstalled[@]} | tr ' ' '\n' | sort | uniq -u `)  # get the diff # https://stackoverflow.com/questions/2312762/compare-difference-of-two-arrays-in-bash#comment52200489_28161520
        COLUMNS=12
        echo -e "Select a package number to add to the install list.\nCurrently selected packages: $toinstall\nTo install the selected packages and exit the tool, select '1'.\n\n"
        printf -v PS3 '\n%s ' 'Input number of package to install: '
        select x in ${caninstall[@]}; do
            toinstall+=" $x "
            toinstall=$(echo $toinstall | sed 's/Install-and-Exit//'| awk '{for (i=1;i<=NF;i++) if (!a[$i]++) printf("%s%s",$i,FS)}{printf("\n")}')
            if [ $x == "Install-and-Exit" ]; then endloop=1; fi
            break
        done
    done
    echo "About to run:   sudo $manager install -y $toinstall"
}

getmystuff