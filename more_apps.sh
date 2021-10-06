####################
#
# Check and install larger packages
#
####################

# Keep only essential packages, how to completely debloat a Linux installation
# https://askubuntu.com/questions/79665/keep-only-essential-packages
# https://ostechnix.com/debfoster-keep-only-essential-packages-in-debian-and-ubuntu/

# Gnome and other terminals have really annoying right-click menus when you want to just copy/paste (like Putty).
# https://askubuntu.com/questions/734647/right-click-to-paste-in-terminal

# Connect to a Windows box
# mkdir ~/asus
# sudo mount.cifs //192.168.1.16/Drives ~/asus -o user=Boss
# sudo mount -t cifs -o ip=<ip>, username=<win-user> //<pc>/<share> /mnt/mountpoint
# When you are inside a share and it shows read-only, right-click and select "Open as root" to get read-write
# https://askubuntu.com/questions/74789/failed-to-retrieve-share-list-from-server-error-when-browsing-a-share-with-nau
# Alt+F2 and type: gksu gedit /etc/nsswitch.conf
# Look for this line:
# hosts:  files mdns4_minimal [NOTFOUND=return] dns mdns4
# Add wins so it looks like this:
# hosts:  files mdns4_minimal [NOTFOUND=return] wins dns mdns4
# Install the "winbind" package: sudo apt-get install winbind



# temp() {    # 
#     if [ $# -eq 0 ] ; then
#       cat << EOF >&2
# Usage: $0 temperature[F|C|K]
# where the suffix:
#    F	indicates input is in Fahrenheit (default)
#    C	indicates input is in Celsius
#    K	indicates input is in Kelvin
# EOF
#         return
#     fi
#     unit="$(echo $1|sed -e 's/[-[[:digit:]]*//g' | tr '[:lower:]' '[:upper:]' )"
#     temp="$(echo $1|sed -e 's/[^-[[:digit:]]*//g')"
#     case ${unit:=F}
#     in
#         F ) # Fahrenheit to Celsius formula:  Tc = (F -32 ) / 1.8
#         farn="$temp"
#         cels="$(echo "scale=2;($farn - 32) / 1.8" | bc)"
#         kelv="$(echo "scale=2;$cels + 273.15" | bc)"
#         ;;
#         C ) # Celsius to Fahrenheit formula: Tf = (9/5)*Tc+32
#         cels=$temp
#         kelv="$(echo "scale=2;$cels + 273.15" | bc)"
#         farn="$(echo "scale=2;((9/5) * $cels) + 32" | bc)"
#         ;;
#         K ) # Celsius = Kelvin + 273.15, then use Cels -> Fahr formula
#         kelv=$temp
#         cels="$(echo "scale=2; $kelv - 273.15" | bc)"
#         farn="$(echo "scale=2; ((9/5) * $cels) + 32" | bc)"
#     esac
#     echo "Fahrenheit = $farn"
#     echo "Celsius    = $cels"
#     echo "Kelvin     = $kelv"
# }
# 





# https://itsfoss.com/best-ubuntu-apps/

 # https://www.cryfs.org Command line crypt tool
 # Whatsie WhatsApp client
 # sudo apt install flameshot for image capture
# sudo apt install peek for gifs
# blender
# mailspring for mail
# Clamtk av
# Standard notes
# Web: Firefox
# Mail: Thunderbird
# pdf: no good choice, all suck, suffering with Foxit
# Cloud: Nextcloud, very nice.
# Music: Audacity, no BS here.
# Backup: Grsync, very granular
# Optical: K3B, all others appear abandoned (rubby ripper, sound juicer)
# Video Editing: Lightworks
# Video playback: VLC
# Documents: MS Office on Crossover
# Drawing: MS Visio on Crossover
# Password manager: KeepassX
# Virtual Machine: VMware
# VPN Client: Private Internet Access
# Neywork: Samba, shit most of the time.
# Storage: Gparted
# Video Chat: none
# Atril PFD / Evince
# Music Player: Audacious (Audacity is great for audio manipulation).
# Master PDF
# PDF Studio
# Acronis True Image:
1. Backup entire Linux install to USB
2. Create recovery partition on Linux computer
try https://extensions.gnome.org/extension/779/clipboard-indicator/
copyq and just disable, or ignore whatever built-in clipboard manager might exist.

Currently using neon, but have also enjoyed copyq with gnome and windows

copyq can be configured with whatever shortcuts you like.
pcloud offers free storage only 10Gb but month and lifetime plan…

Cherrytree by Giuseppe Penone. It is THE best database/list/notebook/PIM programme out there. It is a database attached to a word processor. It’s small and simple to use. It does what it says and does it well. It’s one of those programmes that replaces a whole mess of other apps/programmes due to its versatility. I use it for all my writing/word processing needs – logbook, inventory, poetry, story/article/letter writing, address book/contacts list, recipe book, to do/task lists, project management, notebook, and much, much more. It will handle *.txt or *.rtf format and saves it’s data in a folder location of your choice. You can even insert links, tables or pictures. It’s cross platform so I can use it on Windows or Linux without skipping a beat. I have yet to find a more useful, versatile programme.
“MY SMS” to your message app. It sync to your phone so you can send and receive from either and the thread appears on both.
Windscribe VPN
Opera mini has a free, very good, VPN which can easily be switched on/off.
XnviewMP to sort, view, catalog your pictures but also does videos. I’ve been using it for decades before I shifted to Linux. Developper is very responsive and people on the forums as well.
4K Video Downloader
Cloud: Megasync is the king [50GB free + best sync client]
Messaging: Telegram Desktop [FOSS & a lot to offer]
Coding: Sublime Text 3 [Undoubtly fastest of all still being feature rich]
Opera (very underrated browser)
Freemind
Zim
Workrave
Rhinote
Glabels
Odio
pdfshuffler
– bitwarden: Lastpass but open source, audited, and secure
– gocryptfs: you can locally encrypt files (client side encryption) that are stored in a cloud service like Dropbox, so even if you get hacked hackers can’t read any of your files
– veracrypt: an awesome encryption suite
– GPG/PAM: you can use GPG and a Yubikey/Nitrokey to provide 2nd factor authentication to LUKS, login or simply sign and encrypt documents
 Restic: blazing fast backup
– Git: duh
– keybase: signal + Dropbox with client side encryption and 200 GB free storage + a GPG keyserver + ledger security + Lumen wallet all rolled into one. Most impressive piece of software I’ve seen in a while
– Signal: the gold standard in privacy
– wavebox: the most robust communication client out there
– nordvpn: has a nice CLI Linux client
– Quodlibet: Music player for audiophiles (bit perfect output). Runs natively in Wayland
– Flatpak: containerized apps
– Tor: gold standard in privacy
– Firefox nightly: now runs natively in Wayland providing security benefits
– Anaconda: Python + R environment manager
– remmina: the best RDP app I’ve found
keepassXP for passwords, Recoll to indexing documents, MEGA as a good cloud option too, Transmission, Kodi, Anki, Gramps, Electrum, Anydesk, Retroarch… all of them I consider them the best of their categories.
sudo apt purge thunderbird*
sudo apt install geary
Pocket to save all sorts of articles.
Document Viewer is standard in Ubuntu, but I prefer Foxit-reader as is allows also some editing , just enough to fill a pdf form.
gconf-editor?
kdenlive, mpv media player and atom after reading this post. than kyou for the suggestions.
“The Old Reader” , in the web browser for that.
kodi
Lutris & DXVK for Gaming without a doubt!
Nextcloud for your private cloud storage. BoxBackup for encrypted backups.
MegaSync but you can give Rclone a try.
Bitwarden is open source password manager. It supports cloud-sync, has desktop and mobile applications along with browser extensions.
I have used https://pwsafe.org/ for years it is best in my opinion and is available for windows and android as well. It even works with yubikeys if you like. I may eventually adopt that for mobility on my android device.
Anbox is there but it’s not very usable at the moment. Android emulator
Nuvola is not a free application: in requires a subscription.
pCloud is a nice tool, however unlike Dropbox the files are stored ONLY on their server, not mirrored on your computer, so if you find yourself without internet access, you will also not have access to your files.
I have implemented Syncthing for cloud storage, keeping files on all my computers as well as on a backup system… was a little bit more complicated to set up, but works well. One note, there is not a Linux GUI, but they do have a web gui launched from the terminal, and if you close the browser, the sync continues until you kill the terminal.
CopyQ is a very useful, cross-platform clipboard manager.
AutoKey is great for text expansion and automating repetitive tasks.
wiki Zim
Its a local personnal wiki to take note, todo list, storage information with Links power.
httpS works fine too: https :// feeds. feedburner. com / ItsFoss
GoldenDict. Once you figure out where to get dictionaries, it becomes an excellent tool for looking up definitions and translations.

Scribus is a good desktop publishing tool.

MyPaint is very similar to Krita

TuxGuitar is a good midi player and Guitar music play and score tool

IrfanView is an excellent image display and edit program from Windows that installs easily under WINE in Linux, and runs perfectly.

And, let’s not forget Detox for converting whitespace to underscore in file names, and

Grub Customizer for adjusting the Boot Menu in dual boot systems.
Megaupload, Franz, Mailspring and Zenkit.
Use Turboprint
 Musescore does a wonderful job.

 KeePassX -password manager-cross platform-works for me on Ubuntu 14.04, the latest Xubuntu, and Windows 7.
Back In Time -backup-once set up runs automaticaly and can save files to any HD, USB stick or whatever. Backups saved as individual files and can be retrieved as such.
Streema- online free world music-hundreds of choices
PDF Shuffler- can’t edit pdf’s but you can add or delete pages or combine two pdf files into one. I use it a lot! Very small program.
Gnote-quick note taker. Write out a note and print it out on paper or print as a pdf and save somewhere or put into a notebook.
I don’t run any from command line, so I don’t know about that . . .

KeePassXC
Blender is essential for visualization thinking in 3D and 2D not only for rendering of 3D art.
Mega, mega.co.nz. You get 50gb free storage, the megasync application for Ubuntu, Mint and others, a Nautilus plug in and an extension for Firefox and Chrome that provides a secure login and faster, safer uploads and downloads.
Double Commander” as a file manager. Over the many years, I believe I’ve tried all similar available on Linux, and, IMHO, think this one is the best. I use it on all my machines. And, for those who double boot with Windows, thre is a version available.

Zotero to manage and annotate academic literature. Anki is great for flash cards. LastPass to manage passwords. VNCViewer or TeamViewer for remote access to my other devices.
Can you recommend a good notebook program, an alternative to OneNote?

OBS screen recorder and ST3 editor?

Peek for simple screencasting: https://github.com/phw/peek

reeOffice 2018, which can read and write .docx documents pretty well, if that’s an issue. The free version lacks many features though.

Rambox! It’s a great tool and it’s more FOSS than Franz since it doesn’t ask you to pay nor subscribe (which you can do anyway on a voluntary basis)

Compiz (3D desktop)

PlayOnLinux with Lutris, please.
What about LMMS, Ardour and maybe Natron?

LMMS several times a week. I’ve not heard of Natron – I’ll have to check it out.

Geany, a value added text editor, for coding, pysolfc loads of idle single player games, openshot a nonlinear video editor, password gorilla for generating and saving passwords, clipgrab to download videos from many different locations, simple screen recorder does what it says on the tin, blender for 3d modeling, openscad for 3d modeling

Cribbage, Dominoes, Spades, Hearts. Klondike Forever, and The Othello on linux.

MPlayer. Does as much or more than VLC does and works out of the box with any file.

Cloud Storage – none that you recommended is FOSS.

Image editors – Krita is net superior to any image editor. I am designing websites for the past 15 years so I can tell you that using Photoshop for 10 years Krita was the only Linux alternative that could do the job Photoshop did. So Krita is far from a paint app.

Photo apps (for gallery) – Shotwell is still the best in my view. The other ones do not work well with over 20k images.

Kdenlive – I am making documentaries for the past 8 years. Comparing Kdenlive with Movie Maker is really crazy :)). Kdenlive is far superior. Have you used it? It is on par with Sony Vegas I would say, a software that I used for many years before migrating to Linux.

Xnconvert – is closed source. If you want an open source solution try Converseen.

LibreOffice – again, believe it or not but I also write books and design them into LO. Books that are hundreds of pages long each. LO is more than capable of editing PDF’s – I edited 600 pages PDF (that had a heavy design) with Draw. And I currently design a 1k page book into Draw.

Skype – closed source. Proprietary. Linux is full of messaging apps so why recommend a proprietary one? Use Riot, Signal, qTox, Jitsi, and so forth.

Remember The Milk – not open source.

Steam – promotes DRM and non-free software. Same goes for PlayOnLinux .

For backup use Deja Dup. Using it for the past 5 years with 0 issues. Creates scheduled encrypted backups.

I really enjoy your website, but I am very sad to see that you don’t respect what FOSS stands for and you promote software that is neither open source or free (as in freedom). Why is that?

sudo apt install lshw
sudo lshw
for a deeper look
sudo apt install hwinfo
sudo hwinfo
Finely top
sudo top but a more overlooked little network command line killer is iftop
sudo apt install iftop
sudo iftop
watch your throughput rx tx levels see how a dns server is fooling your actual net speeds from your isp
All the best may your FOSS be with u

Didn’t know that LibreOffice Draw could edit PDFs! Thank you for this tip.

gscan2pdf (for scanning, OCR, split and save) and DocFetcher (for search and view). And I save the pdf-Files in a meaningfull Filestructure (2018, 2017, … car, house, family, …) with “speaking” filenames (date-name-title.pdf). So I can search for the file by the file-explorer or by DocFetcher.

DaVinci Resolve for video editing and REAPER for audio editing and music production.
Reaper is one of the best DAW’s out there. I like it better than Pro Tools. While it is free to try out, the developer, pretty much on an honor system, requires purchase of a license (very cheap for what it is) if you’re going to continue using it beyond the trial period to support his work. It is not free, it’s just not locked down.



Alt+F2 and type: gksu gedit /etc/nsswitch.conf

Look for this line:

hosts:  files mdns4_minimal [NOTFOUND=return] dns mdns4

Add wins so it looks like this:

hosts:  files mdns4_minimal [NOTFOUND=return] wins dns mdns4

Install the "winbind" package: sudo apt-get install winbind
https://forums.linuxmint.com/viewtopic.php?t=332108
https://forums.linuxmint.com/viewtopic.php?t=322404 Samba and Mint20




# Enable snap (if needed) on distros that do not have it (Linux Mint deem it a backdoor).
# https://linuxmint-user-guide.readthedocs.io/en/latest/snap.html
# Even though Ubuntu is pushing to use Snap more than ever, the Linux Mint team is against it. Hence, it forbids APT to use snapd.
# So, you won’t have the support for snap out-of-the-box. However, sooner or later, you’ll realize that some software is packaged only in Snap format. In such cases, you’ll have to enable snap support on Linux Mint 20.
# Just because Linux Mint forbids the use of it, you will have to follow the commands below to successfully install snap:

sudo rm /etc/apt/preferences.d/nosnap.pref
sudo apt update
sudo apt install snapd




# Remember the "alternativeto" site when trying to find apps
# Trawled some lists to find these:
# https://www.omgubuntu.co.uk/2016/12/21-must-have-apps-ubuntu
# https://itsfoss.com/best-ubuntu-apps/
# https://www.fossmint.com/best-ubuntu-apps/

https://itsfoss.com/things-to-do-after-installing-ubuntu-18-04/
sudo apt install ubuntu-restricted-extras   # Additional codes for Ubuntu
sudo apt install mint-meta-codecs           # Additional codecs for Mint

Install Notepad++ with WINE


# System Resource Monitoring
https://itsfoss.com/linux-system-monitoring-tools/
# Note that for "top", press "z" if you want colour

sudo apt install htop   # Note the vim patches
sudo apt install atop
sudo apt install ytop   # similar to glances only written in Rust and supports themes like Monokai
sudo apt install bpytop
sudo apt install nmon
sudo apt install glances
sudo apt install ksysguard
sudo apt install gkrellm
sudo apt search gkrellm   # Tons of plugins for gkrellm

sudo apt install cargo   # # Note that this was 360 MB download (entire Go and Rust I think)
cargo install -f --git https://github.com/cjbassi/ytop ytop   
wget https://github.com/cjbassi/ytop/releases/download/0.5.1/ytop-0.5.1-x86_64-unknown-linux-gnu.tar.gz
tar zxvf ytop-0.5.1-x86_64-unknown-linux-gnu.tar.gz
./ytop

sudo add-apt-repository ppa:bashtop-monitor/bashtop
sudo apt update
sudo apt install bashtop

sudo apt install nodejs
sudo apt install npm
sudo npm install -g vtop
sudo npm install -g gtop


# exe() { printf "\n\n"; echo "\$ ${@/eval/}"; read -p "Any key to continue..."; "$@"; }
exe() { printf "\n\n"; echo "\$ ${@/eval/}"; "$@"; }

# Apt
exe which chromium &> /dev/null || sudo apt install chromium -y  # Chromium, alternatively Chrome or Brave

exe which gimp &> /dev/null || sudo apt install gimp -y          # GIMP Image Editor
exe which kdenlive &> /dev/null || sudo apt install kdenlive -y  # Kdenlive Video Editor
exe which krita &> /dev/null || sudo apt install krita -y  # Krita
exe which blender &> /dev/null || sudo apt install blender -y  # Blender
exe which darktable &> /dev/null || sudo apt install darktable -y  # Dark Table


exe which vlc &> /dev/null || sudo apt install vlc -y            # VLC Video Player
exe which celluloid &> /dev/null || sudo apt install celluloid -y   # Celluloid Video Player

exe which calibre &> /dev/null || sudo apt install calibre -y    # Calibre eBook management tool
exe which zathura &> /dev/null || sudo apt install zathura -y    # Zathur Document Reader, PDF, ePub, Mobi, etc
exe which caffeine &> /dev/null || sudo apt install caffeine -y  # Caffeine Keep-Alive Tool
exe which etcher &> /dev/null || sudo apt install etcher -y      # Etcher ISO Image Writer (like Rufus)
exe which timeshift &> /dev/null || sudo apt install timeshift -y   # TimeShift Backup / Snapshots with rsync / btrfs
exe which syncthing &> /dev/null || sudo apt install syncthing -y   # Syncthing, sync across network
exe which baobab &> /dev/null || sudo apt install baobab -y      # baobab, Disk Usage Analyzer
sudo add-apt-repository ppa:peek-developers/stable
exe which peek &> /dev/null || sudo apt install peek             # Screen Recording
sudo add-apt-repository ppa:kasra-mp/ubuntu-indicator-weather
sudo apt install indicator-weather
# Pinta – Paint alternative in Linux
# Kazam – Screen recorder tool
# Gdebi – Lightweight package installer for .deb packages
# Spotify – For streaming music
# Skype – For video messaging

# Flatpak is a universal packaging format from Fedora and works on all Linux distributions. Many apps are available as Flatpaks.
# Canonical, the creators of Ubuntu also have created something similar that they call Snaps.
# Similarly, there is an independent packaging format known as Appimage.
# These are all different packaging systems and often you’ll find programs that are available as only one of them.
# This kind of beats the purpose of a single unified packaging system, but all of these do work across any Linux distributions
# so they’re still better than platform-specific packaging systems.

# Snap
which code &> /dev/null || exe sudo snap install code --classic  # Visual Studio Code
which libre !!! &> /dev/null || exe sudo snap install libreoffice
which only-office &> /dev/null || exe sudo snap only-office      # OnlyOffice Free Office Suite
which telegram-desktop &> /dev/null || exe sudo snap install telegram-desktop   # Telegram Desktop
which cowbird &> /dev/null || exe sudo snap install cowbird      # Cowbird Twitter Client
which foliate &> /dev/null || exe sudo snap install foliate      # Foliate ePub Reader
which tilix &> /dev/null || exe sudo apt install tilix           # Tilix Multi Terminal Emulator, https://gnunn1.github.io/tilix-web/manual/vteconfig/
which flameshot &> /dev/null || exe sudo apt install flameshot   # Flamehsot Screenshots
which geary &> /dev/null || exe sudo apt install geary -y        # Geary Email Client
which shotcut &> /dev/null || exe sudo apt install shotcut -y    # Video Editing

# Flatpak
# sudo add-apt-repository ppa:alexlarsson/flatpak   # Probably not required as Flatpak is usually already available
# sudo apt update
which flatpak &> /dev/null || exe sudo apt install flatpak
# Useful to also add the Flatpak repository to ensure easy download/install of apps available as Flatpak.
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
which flatpak &> /dev/null || exe sudo flatpak install flathub de.haeckerfelix.Shortwave   # Radio player, https://www.flathub.org/apps/details/de.haeckerfelix.Shortwave

# exe which lollypop &> /dev/null || Ubuntu Software Store       # Lollypop Music Player
sudo add-apt-repository ppa:ubuntuhandbook1/apps

which pitivi &> /dev/null || exe flatpak install flathub org.pitivi.Pitivi
which pitivi &> /dev/null || exe flatpak run org.pitivi.Pitivi//stable

[ ! -f /tmp/ulauncher_5.7.5_all.deb ] && exe wget -P /tmp/ https://github.com/Ulauncher/Ulauncher/releases/download/5.7.5/ulauncher_5.7.5_all.deb
exe sudo apt install python3-pyinotify gir1.2-keybinder-3.0 python3-distutils-extra python3-levenshtein python3-websocket python3-xdg
sudo apt --fix-broken install -y
exe sudo dpkg -i /tmp/ulauncher_5.7.5_all.deb
# dpkg: dependency problems prevent configuration of ulauncher:
#  ulauncher depends on python3-pyinotify; however:
#   Package python3-pyinotify is not installed.
#  ulauncher depends on gir1.2-keybinder-3.0 (>= 0.3); however:
#   Package gir1.2-keybinder-3.0 is not installed.
#  ulauncher depends on python3-distutils-extra; however:
#   Package python3-distutils-extra is not installed.
#  ulauncher depends on python3-levenshtein; however:
#   Package python3-levenshtein is not installed.
#  ulauncher depends on python3-websocket; however:
#   Package python3-websocket is not installed.
#  ulauncher depends on python3-xdg; however:
#   Package python3-xdg is not installed.

[ ! -f /tmp/stacer_1.1.0_amd64.deb/download ] && exe wget -P /tmp/ https://sourceforge.net/projects/stacer/files/v1.1.0/stacer_1.1.0_amd64.deb/download
exe sudo dpkg -i /tmp/ulauncher_5.7.5_all.deb
# Alternatively, by adding the PPA repository
sudo add-apt-repository ppa:oguzhaninan/stacer -y
sudo apt-get update
sudo apt-get install stacer -y   # CPU, 

sudo add-apt-repository ppa:teejee2008/ppa
sudo apt-get update
sudo apt-get install conky-manager

exe which flatpak &> /dev/null || sudo apt install flatpak           # Tilix Multi Terminal Emulator
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo apt install gnome-software-plugin-flatpak -y
exe which shortwave &> /dev/null || sudo apt install shortwave           # Tilix Multi Terminal Emulator

sudo apt-add-repository ppa:lucioc/sayonara
sudo apt-get update
sudo apt-get install sayonara
# On Fedora, you can find Sayonara in the repositories.
# sudo dnf install sayonara


####################
#
# Cleanup
#
####################
exe sudo apt update -y
exe sudo apt upgrade -y
exe sudo apt autoremove -y




####################
#
# Testing
#
####################
git clone https://github.com/pacha/vem.git
cd vem
sudo make install

# https://www.fossmint.com/best-bittorrent-clients-for-linux/

# https://getharmony.xyz/download   # Cross-platform music player

# https://www.microsoftedgeinsider.com/en-us/?form=MO12HB&OCID=MO12HB

copyq
clipboardfusion
gufw
WhatsApp Desktop App
libreoffice
openoffice


c
####################
#
# Ganes
#
####################
# https://archive.org/details/internetarcade   # Play old games in browser
# https://www.fossmint.com/best-linux-games-of-2018/

exe which steam &> /dev/null || sudo apt install steam -y        # Steam
# https://www.fossmint.com/best-steam-games-for-linux/

# Lutris
# Lutris is an open source gaming platform for GNU/Linux. It allows you to gather and manage (install, configure and launch) all your games acquired from any source, in a...
sudo add-apt-repository ppa:lutris-team/lutris
sudo apt update
sudo apt install lutris
# Make sure to install Wine and drivers!
# If you plan on playing games for Windows, to ensure a smooth experience, install a recent version of Wine on your system.
# This will provide all necessary dependency as Lutris cannot ship with every component in its runtime.
# When playing games lutris will use a custom version of Wine optimized for games.

# https://github.com/lutris/docs/blob/master/InstallingDrivers.md
# For Intel HD graphics:
# sudo add-apt-repository ppa:kisak/kisak-mesa
# Enable 32 bit architecture (if you haven't already):
# sudo dpkg --add-architecture i386 
# Upgrade your system:
# sudo apt update && sudo apt upgrade
# Install support for 32-bit games:
# sudo apt install libgl1-mesa-dri:i386
# Install support for Vulkan API (will be functional only if you have a Vulkan capable GPU):
# sudo apt install mesa-vulkan-drivers mesa-vulkan-drivers:i386




# GameHub   # Games library manager. Supports: Steam, GOG, Humble Bundle, Humble Trove, Wine and RetroArch .
sudo apt install --no-install-recommends software-properties-common
sudo add-apt-repository ppa:tkashkin/gamehub
sudo apt update
sudo apt install com.github.tkashkin.gamehub
# Free Open Source Linux AppImageHub Flatpak
# Flatpak Gameboy emulation Import from GoG Import from Steam ...

# RetroArch
# RetroArch is a graphical frontend for emulators, game engines, and media players. Created by libretro
# What systems does it play?
# - Arcade (emulator: Final Burn Alpha / iMAME4All / MAME)
# - Atari 2600 (emulator: Stella)
# - Atari Lynx (emulator: Handy)
# - Nintendo Entertainment System... More Info »
exe which retroarch &> /dev/null || sudo apt get retroarch       # Simple frontend for the libretro library

# PlayOnLinux
# PlayOnLinux (PlayOnMac at http://www.playonmac.com ) is a tool to help Linux (and Mac) users run games and programs for Windows on Linux (or Mac, FreeBSD), via the use...
# Free Open Source Mac Linux BSD Wine FreeBSD
# Run Windows software Ad-free Games Add a feature
exe which playonlinux &> /dev/null || sudo apt get playonlinux   # WINE implementation for Windows games https://www.playonlinux.com/en






# Snes9x
# Snes9x is a portable, Super Nintendo Entertainment System (SNES) emulator. It allows you to play most games designed for the SNES and Super Famicom Nintendo game systems...

# ePSXe
# ePSXe (enhanced PSX emulator) is an emulator of the PlayStation video game console for x86-based PC hardware. ePSXe makes use of a plugin system to emulate GPU, SPU, and...

# SteamOS
# A Debian-based Linux distribution designed to run Valve's Steam and Steam games.
# 
# Free Open Source Linux Wine Steam Proton
# Linux Based on Debian Games Gaming-focused ...
# 
# SteamOS icon
# 130
# ZSNES
# 
# ZSNES is a Super Nintendo Entertainment System emulator. Aside from emulation accuracy, many interface features first introduced in ZSNES have been adopted by other...
# 
#     Discontinued
#     The program is no longer updated. Last version, 1.51, released in January 2007, can be still downloaded from the official website.
# 
# Free Open Source Mac Windows Linux
# No features added Add a feature
# 
# ZSNES icon
# 195
# VisualBoyAdvance
# 
# VisualBoyAdvance (VBA) is a free software (GNU GPL) emulator targeted for the Game Boy, Super Game Boy, Game Boy Color, and Game Boy Advance handheld game consoles sold...
# 
#     Discontinued
#     The project is no longer developed. Last version, 1.8.0 beta 3, released in October 2005, can be still downloaded from FileHippo
# 
#     Retroarch is for ios VBA is for windows Guest • Sep 2015 • 1 agrees and 9 disagrees
# 
# Free Open Source Mac Windows Linux BSD Haiku ...
# Emulation Portable Add a feature
# 
# VisualBoyAdvance icon
# 141
# Project64
# 
# Project64 is a Nintendo 64 emulator for the Windows platform. It employs a plugin system that allows 3rd party developers to implement their own software. It is an...
# 
# Free Open Source Windows Android
# Portable Add a feature
# 
# Project64 icon
# 96
# Know any more alternatives to RetroArch?
# PPSSPP
# 
# PPSSPP is a PSP emulator written in C++, and translates PSP CPU instructions directly into optimized x86, x64 and ARM machine code, using JIT recompilers (dynarecs). ...
# 
# Free Open Source Mac Windows Linux Android iPhone ...
# Jailbreak required Add a feature
# 
# PPSSPP icon
# 

# ScummVM
# 
# ScummVM is a program which allows you to run certain classic graphical point-and-click adventure games, provided you already have their data files.
# 
# Free Open Source Mac Windows Linux Windows Mobile Android ...
# Adventure Game Games Jailbreak required Portable ...
# 
# ScummVM icon
# 112
# Lakka
# 
# Lakka is the official Linux distribution of RetroArch and the libretro ecosystem. Each game system is implemented as a libretro core, while the frontend RetroArch takes care of inputs and display.
# 
# Free Open Source Mac Windows Linux Cubieboard HummingBoard ...
# Emulation Gaming-focused Linux-based Operating system Add a feature
# 
# Lakka icon
# 24
# OpenEmu
# 
# Open Emu is an open source project to bring game emulation to OS X as a first class citizen, leveraging modern OS X technologies such as Cocoa, Core Animation and Quartz, and 3rd party libraries like Sparkle for...
# 
# Free Open Source Mac
# Access the AppStore Multi System Emulator Add a feature
# 
# OpenEmu icon
# 46
# Mame
# 
# MAME stands for Multiple Arcade Machine Emulator.
# 
# Free Open Source Mac Windows Linux AmigaOS MorphOS
# Arcade Integrated Android Emulator Portable Add a feature
# 
# Mame icon
# 74
# LaunchBox
# 
# LaunchBox was originally built as an attractive frontend to DOSBox, but has since expanded to support both modern PC games and emulated console platforms.
# 
# Freemium $ $ $ Windows
# Front End Emulation Batch import Game launcher Launcher ...
# 
# LaunchBox icon
# 41
# higan
# 
# higan was formerly known as bsnes. The project was renamed after becoming a multi-system emulator. higan is a Nintendo multi-system emulator that began development on 2004-10-14.
# 
# Free Open Source Mac Windows Linux
# Multi System Emulator Portable Add a feature
# 
# higan icon
# 41
# CrossOver
# 
# Windows compatibility on Mac, Linux, and Chrome OS with no Windows license. CrossOver allows you to install many popular Windows applications on your Mac Linux or Chromebook computer.
# 
#     CrossOver runs desktop software. RetroArch runs retro games. Guest • Mar 2020
# 
# Commercial $ $ $ Mac Linux Android Chrome OS
# Compatibility layers Add a feature
# 
# CrossOver icon
# 61
# Kega Fusion
# 
# Kega Fusion is an emulator for the Sega Genesis / Megadrive, Master System, Game Gear, 32x, SegaCD/MegaCD, SVP, Pico, SG-1000, SC-3000, and SF-7000 emulator for Win9x/ME/2000/XP/Vista/Win7, Mac OSX (Intel), and Linux.
# 
#     Discontinued
#     The program is no longer updated. Last version, 3.64, released on March 7, 2010, can be still downloaded from the official website.
# 
# Free Mac Windows Linux
# Emulation Portable Add a feature
# 
# Kega Fusion icon
# 42
# Mednafen
# 
# Mednafen is a portable, utilizing OpenGL and SDL, argument(command-line)-driven multi-system emulator with many advanced features.
# 
# Free Open Source Windows Linux
# Multi System Emulator Portable Add a feature
# 
# Mednafen icon
# 16
# mGBA
# 
# mGBA is a new Game Boy Advance emulator written in C.
# 
# Free Open Source Mac Windows Linux
# Optimal performance Add a feature
# 
# mGBA icon
# 12
# Ludo
# 
# Ludo is an Emulator Frontend able to run retro video games. Ludo does not emulate the consoles itself, but does it through emulator plugins called libretro cores.
# 
# Free Open Source Mac Windows Linux
# Lightweight User interface Emulation Playstation Add a feature
# 
# Ludo icon
# 5
# Citra
# 
# An experimental open-source Nintendo 3DS emulator/debugger written in C++.
# 
# Free Open Source Mac Windows Linux
# No features added Add a feature
# 
# Citra icon
# 12
# Pegasus
# 
# Pegasus is a graphical frontend for browsing your game library (especially retro games) and launching them from one place.
# 
# Free Open Source Mac Windows Linux Android Raspberry Pi
# Portable Game launcher Add a feature
# 
# Pegasus icon
# 6
# Snes9x EX
# 
# Snes9x EX is an SNES/Super Famicom emulator written in C++ for Android, iOS, WebOS and Linux. It uses the emulation backend from Snes9x and is built on top of the Imagine engine.
# 
# Free Linux Android iPhone iPad
# Jailbreak required Add a feature
# 
# Snes9x EX icon
# 13
# No$GBA
# 
# NO$GBA is a Nintendo DS emulator for Microsoft Windows.
# 
# Freemium Windows
# NDS support Gameboy emulation Remote Debugging Add a feature
# 
# No$GBA icon
# 29
# Nostlan
# 
# A front-end or user interface (UI) is the presentation and interaction layer of an app or website.
# 
# Free Open Source Mac Windows Linux
# Emulation Game launcher Games Xbox Add a feature
# 
# Nostlan icon
# 4
# Kosmi
# 
# Kosmi is a free real time application and communication platform that offers voice, text and video calls along with games and applications such as SNES Party, NES Party, OpenArena, Poker, Virtual Cardtables and Cowatch...
# 
# Free Web
# Share your screen Watch videos together Channels Games ...
# 
# Kosmi icon
# 10
# RetriX
# 
# RetriX is the first Libretro front end that is optimized for multiple input methods: gamepad, mouse + keyboard and touch are all first class citizens.
# 
# Free Open Source Windows Windows Mobile Windows Phone Xbox
# Emulation Multi System Emulator Add a feature
# 
# RetriX icon
# 5
# pSX
# 
# PSX is an emulator of the PlayStation video game console for x86-based PC hardware. It is Windows and Linux compatible. The original game CDs can be used to play the games. ISO files are also supported.
# 
#     Discontinued
#     The official website is no longer available. Last version, 1.13, released on February 2008, can be still downloaded from Wayback Machine.
# 
# Free Windows Linux
# No features added Add a feature
# 
# pSX icon
# 18
# melonDS
# 
# A Nintendo DS emulator with support for commercial games.
# 
# Free Open Source Windows Linux
# Portable Add a feature
# 
# melonDS icon
# 4
# My Boy!
# 
# My Boy! is an emulator to run GameBoy Advance games on the broadest range of Android devices, from very low-end phones to modern tablets. It emulates nearly all aspects of the real hardware correctly.
# 
# Freemium Android Windows Phone
# Controller support Emulation Add a feature
# 
# My Boy! icon
# 4
# Drastic
# 
# DraStic is a fast Nintendo DS emulator for Android.
# 
# Commercial Android
# Games Add a feature
# 
# Drastic icon
# 6
# RomStation
# 
# Simple and all in one emulation with RomStation! Features * All in one GB, GBC, GBA, NDS, NES, SNES, N64, GameCube, Wii, Game Gear, Master System, MegaDrive, 32X, Mega-CD, Dreamcast, Neo-Geo, PS1, PS2 and Arcade...
# 
# Free Windows
# Emulation Gamecube Games Integrated Search ...
# 
# RomStation icon
# 8
# GBA.emu
# 
# Pro version: https://play.google.com/store/apps/details?id=com.explusalpha .
# 
# Freemium Android
# Emulation Add a feature
# 
# GBA.emu icon
# 6
# MD.Emu
# 
# Advanced open-source Sega Genesis/Mega Drive, Sega CD, and Master System/Mark III emulator based on portions of Genesis Plus/Gens/Picodrive/Mednafen, designed and tested on the original Droid/Milestone, Xoom, Galaxy S2...
# 
# Commercial Android
# Emulation Add a feature
# 
# MD.Emu icon
# 6
# FB Alpha
# 
# FB Alpha or FBA as it is commonly known is an emulator of arcade games, that is, it takes the program code, graphics data, etc.
# 
# Free Open Source Windows
# Arcade Emulation Games Add a feature
# 
# FB Alpha icon
# 9
# BizHawk
# 
# BizHawk is a multi-system emulator designed predominantly around the production of Tool Assisted Speedruns (TAS). It is written in C# and requires .NET 4.0 to run.
# 
# Free Open Source Windows
# Multi System Emulator Add a feature
# 
# BizHawk icon
# 4
# uoYabause
# 
# uoYabause aka Yaba Sanshiro, is a unofficial port of Yabause SEGA Saturn Emulator. This project is focused on the Android version of yabause using OpenGL ES 3.x. Versions are also available for iOS and Windows.
# 
# Free Open Source Windows Android iPhone
# Emulation Add a feature
# 
# uoYabause icon
# 3
# D-Fend Reloaded
# 
# D-Fend Reloaded is a graphical environment for DOSBox .
# 
#     Discontinued
#     Seems to be no longer in development as the last version 1.4.4 was released in 2015-07-31.
# 
# Free Open Source Windows DOSBox
# DOS emulation Add a feature
# 
# D-Fend Reloaded icon
# 9
# Gens/GS
# 
# Gens/GS is a version of Gens maintained by GerbilSoft. The main goal of Gens/GS is to clean up the source code and combine features from various forks of Gens, as well as improving portability to other platforms.
# 
#     Discontinued
#     last version: r7: February 23, 2010
# 
# Free Open Source Windows Linux
# Emulation Portable Rewind the changes Add a feature
# 
# Gens/GS icon
# 11
# Kawaks
# 
# Kawaks is a streamlined Neo-Geo/Capcom (CPS1/2) emulator that works well even in low-end computers and is compatible with Kaillera Netplay.
# 
# Free Windows
# Emulation Networking Add a feature
# 
# Kawaks icon
# 11
# Gens
# 
# Gens is a Win9x based emulator for the SEGA Genesis/Mega-Drive/Sega-CD/ Mega-CD/32X systems, it allows you to play games developed for these classic SEGA 16bit game consoles on your x86 compatible PC.
# 
# Free Open Source Mac Windows Linux
# Emulation Portable Add a feature
# 
# Gens icon
# 4
# Happy Chick
# 
# Happy Chick emulates more than 18 systems all in one APP, some of the included emulators are FAB/MAME/MAMEPLUS,PS,PSP,FC(NES),SFC(SNES),GBA,GBC,MD,NDS,DC,NGP,WS(WSC),PCE, ONS…etc.
# 
#     Simple,fast easy to use and you can also get your roms here tho Guest • Aug 2019 • 2 agrees and 2 disagrees
# 
# Free Windows Android iPhone iPad
# Multi System Emulator Emulation English-to-LaTeX Add a feature
# 
# Happy Chick icon
# 7
# GBA4iOS
# 
# The number one Game Boy Advance emulator for iOS is back, and has been rewritten from the ground up for iOS 7.
# 
# Free Open Source iPhone iPad Bitbucket
# No features added Add a feature
# 
# GBA4iOS icon
# 6
# nds4droid
# 
# nds4droid is a free, open source Nintendo DS emulator written for Android smartphones. It is based off of the excellent emulator DeSmuME. The source code can be found on sourceforge.
# 
# Free Open Source Android
# No features added Add a feature
# 
# nds4droid icon
# 4
# Genecyst
# 
# Genecyst is a Sega Genesis system emulator released in 1997.
# 
#     Discontinued
#     The project is no longer updated, but last version, xxx for DOS, released on August 1998, can be still downloaded from the official website.
# 
# Free Windows
# No features added Add a feature
# 
# 3
# Jpcsp
# 
# JPCSP is an open source PlayStation Portable emulator for Windows, Linux and Mac OS X written in Java.
# 
# Free Open Source Mac Windows Linux
# Games Portable Add a feature
# 
# Jpcsp icon
# 6
# MESS
# 
# MESS emulates portable and console gaming systems, computer platforms and calculators. The project strives for accuracy and portability and therefore is not always the fastest emulator for any one particular system.
# 
# Free Personal Mac Windows Linux
# Arcade Emulation Multi System Emulator Add a feature
# 
# MESS icon
# 12
# Yabause
# 
# Yabause is a Sega Saturn emulator under the GNU GPL. It currently runs on FreeBSD, GNU/Linux, Mac OS X, Windows, Dreamcast, PSP and Wii. Yabause supports booting games using Saturn cds or iso files.
# 
# Free Open Source Mac Windows Linux BSD
# Emulation Games Add a feature
# 
# Yabause icon
# 5
# Gens32 Surreal
# 
# A revamped version of Gens32. It has a smoother frame rate and an advanced sound configuration system. Gens32 is an emulator for: SEGA Genesis, Mega-Drive, Sega-CD, Mega-CD, 32X systems.
# 
# Free Windows
# Emulation Portable Add a feature
# 
# Gens32 Surreal icon
# 4
# Gens Plus!
# 
# Gens Plus! is a Sega Genesis / 32X / SegaCD / Master System / Game Gear emulator based on the Gens emulator that has added features.
# 
# Free Windows
# Emulation Portable Add a feature
# 
# Gens Plus! icon
# 3
# Ages
# 
# Ages is a SEGA Genesis, SEGA 32X, and Sega CD emulator. Compare it to your favorite SEGA Genesis emulator and send your thoughts to the authors. This emulator has full sound, and has been built from scratch.
# 
#     Discontinued
#     The official website is no longer available. Last version, v0.30a, released on July 2002, can be still downloaded from Zophar.net
# 
# Free Windows
# No features added Add a feature
# 
# Ages icon
# 3
# DGen
# 
# DGen is a Genesis/Megadrive emulator, which currently runs under Windows 95/98/2000 and possibly NT using DirectX.
# 
#     Discontinued
#     The official website is no longer available. Last version, v1.21, released on January 2000, can be still downloaded from Zophar.net
# 
# Free Windows AmigaOS
# Emulation Portable Add a feature
# 
# DGen icon
# 3
# Boxer
# 
# Boxer plays all the MS-DOS games of your misspent youth, right here on your Mac.
# 
# Free Open Source Mac
# Emulation Add a feature
# 
# Boxer icon
# 10
# GenEm
# 
# GenEm95 is a SEGA Genesis/SEGA Mega Drive Emulator.
# 
#     Discontinued
#     The official website is no longer available. Last version, 0.19, released on February 2010, can be still downloaded from Sega Retro.
# 
# Free Windows
# Portable Add a feature
# 
# GenEm icon
# 2
# Generator
# 
# Generator is a Sega Genesis (Mega Drive) emulator.
# 
# Free Mac Windows
# Emulation Add a feature
# 
# 2
# PicoDrive
# 
# PicoDrive is a Sega Mega Drive/Pico emulator programmed by notaz. It works on windows systems and has the functions that would be expected of a Pico emulator.
# 
# Free Windows
# Emulation Add a feature
# 
# 2
# Genesis Plus
# 
# Genesis Plus is a freeware, open-source, portable emulator for the Genesis and MegaDrive consoles. Mirror at Zophar's Domain: http://www.zophar.net/genesis/genesis-plus.html
# 
# Free Open Source Mac Windows
# Emulation Portable Add a feature
# 
# Genesis Plus icon
# 2
# FPse
# 
# PSX emulator on Windows Mobile or Windows Phone Device and Android. The name means First PlayStation Emulator.
# 
#     Discontinued
#     no official update to download!
# 
# Freemium Windows Mobile Android
# Playstation Add a feature
# 
# FPse icon
# 5
# 1964
# 
# 1964 is a Nintendo 64 emulator for Microsoft Windows, written in C and released as free software. It is one of the oldest and most popular N64 emulators, supporting many commercial N64 games.
# 
#     Discontinued
#     last update: August 17, 2012
# 
# Free Open Source Windows
# No features added Add a feature
# 
# 1964 icon
# 7
# GENPlusDroid
# 
# GENPlusDroid is an open source Sega Genesis emulator powered by GENPlus. Runs Sega Master System and Sega Mega Drive games. High compatibility, games like Virtual Racing and Phantasy Star work full speed!.
# 
# Free Android
# Emulation Add a feature
# 
# GENPlusDroid icon
# 3
# SSF
# 
# SSF is a Sega Saturn emulator for Windows systems using DirectX 9.0c or higher.
# 
#     Discontinued
#     Author's website not available.
# 
# Free Windows
# Emulation Add a feature
# 
# SSF icon
# 4
# iDeaS
# 
# iDeaS is a plugin-based Game Boy Advance and Nintendo DS emulator for Microsoft Windows and Linux, using the GTK+ toolkit.
# 
#     Discontinued
#     last update: February 12, 2012
# 
# Free Windows Linux
# No features added Add a feature
# 
# iDeaS icon
# 6
# BoycottAdvance
# 
# BoycottAdvance is a free and portable emulator for the Nintendo Gameboy Advance handheld. Program is available on Windows, Macintosh, BeOS, Linux, FreeBSD and there is even a Java port, playable online.
# 
#     Discontinued
#     last update: September 27, 2008
# 
# Free Mac Windows Linux Web BSD ...
# Portable Add a feature
# 
# BoycottAdvance icon
# 2
# KiGB
# 
# KiGB is the most accurate and free portable emulator for Gameboy, Gameboy Color and Super Gameboy for Windows, Linux and MS-DOS.
# 
# Free Mac Windows Linux
# No features added Add a feature
# 
# KiGB icon
# 2
# Nebula
# 
# Nebula is an arcade emulator. Specifically it emulates the CPS 1 & 2, Neo-Geo, PGM (PolyGameMaster) and Konami systems. Features include multiplayer, netplay and cheat code support.
# 
# Free Windows
# No features added Add a feature
# 
# Nebula icon
# 3
# John GBA
# 
# John GBA Lite is GBA emulator for android 2.3+. This app does not work without your own game files.
# 
# Freemium Android Android Tablet
# Games Add a feature
# 
# John GBA icon
# 3
# SNEeSe
# 
# SNEeSe is a Super NintEndo Entertainment System Emulator for PC's running MS-DOS, with at least a 486 CPU.
# 
#     Discontinued
#     Latest public release: v0.841 (22-6-2005).
# 
# Free Windows
# Portable Add a feature
# 
# 2
# Pasofami
# 
# Pasofami is the first Super Famicom emulator in Japan, it started developing from 1995.
# 
#     Discontinued
#     No recent activity/updates.
# 
# Commercial Windows
# No features added Add a feature
# 
# Pasofami icon
# 2
# SNESGT
# 
# SNESGT is a super famicom emulator. It is said it has the most accurate BS Satellaview emulation.
# 
#     Discontinued
#     No recent activity/updates.
# 
# Free Windows
# Portable Add a feature
# 
# SNESGT icon
# 2
# TigerSNES
# 
# The famous SNES emulator for android - FREE - Save/Load states - Virutal Touch Keys - Seamless Integrated with ROM download - Customize keys - WiiMote support - Save/Load states
# 
# Free Android
# No features added Add a feature
# 
# TigerSNES icon
# 2
# John GBC
# 
# John GBC is GB/GBC emulator for android 2.3+. This app does not work without your own game files. Please try John GBC lite before purchasing. John GBC can take over John GBC Lite data.
# 
# Freemium Android Android Tablet
# Games Add a feature
# 
# John GBC icon
# 2
# Sixtyforce
# 
# Sixtyforce is an emulator that runs Nintendo 64 games. It does this by dynamically translating the code that a Nintendo 64 uses into something your Mac understands.
# 
# Freemium Mac
# Emulation Add a feature
# 
# Sixtyforce icon
# 2
# WinDS PRO
# 
# WinDS PRO contains the best emulators for the consoles Gameboy Advance and Nintendo DS for PC. It contains the latest version of the emulator iDeaS, DeSmuME, the complements of http://alternativeto .
# 
# Free Windows
# Multi System Emulator Skinnable Add a feature
# 
# WinDS PRO icon
# 7
# Matsu
# 
# Matsu is a free and ad-supported emulator for Android supporting multiple videogame systems from SNES to PSX and featuring save states, fast forward and rewind.
# 
# Freemium Android Android Tablet
# No features added Add a feature
# 
# Matsu icon
# 1
# CD-i Emulator
# 
# The CD-i emulator program (cdiemu) provides a fairly complete emulation of the hardware of an actual physical CD-i player. You can download a time-limited edition from the Downloads section (Windows only for now).
# 
# Commercial $ $ $ Windows
# Emulation Games Add a feature
# 
# 1
# NESBox
# 
# Nesbox Emulator is a multiplatform emulator of video consoles. You can play your favorite NES, Super Nintendo, Sega Genesis and GameBoy Color/Advanced games on any computer working under Windows 8.
# 
# Free Open Source Windows Windows RT Windows Phone Self-Hosted JavaScript ...
# Based on Flash Player Multi System Emulator Add a feature
# 
# NESBox icon
# 14
# Snowflake
# 
# Snowflake is a brand-new zero-config emulator frontend powered by HTML5. Ready to use out-of-the-box ... Snowflake is super easy to use and understand.
# 
# Free Open Source Windows
# Emulation Games Multi System Emulator Add a feature
# 
# Snowflake icon
# 4
# SuperRetro16
# 
# SuperRetro16 the Super Nintendo emulator that delivers the full console experience. An original emulator developed from the ground up for mobile processors, which makes it the fastest out there.
# 
# Freemium Android Android Tablet
# No features added Add a feature
# 
# SuperRetro16 icon
# 6
# GameEx
# 
# GameEx is a graphical DirectX based front-end for MAME, GameBase, Daphne, PC Games, and all command line based game emulators, along with being a complete Home Theatre PC solution or plug in for https://alternativeto .
# 
# Freemium Windows
# No features added Add a feature
# 
# GameEx icon
# 3
# GNOME Games
# 
# Games is a GNOME 3 application to browse your video games library and to easily pick and play a game from it. It aims to do for games what Music already does for your music library.
# 
# Free Open Source Linux
# No features added Add a feature
# 
# GNOME Games icon
# 3
# RetroX
# 
# RetroX is an Android application that will help you organize and play your own Retro Games with the less possible effort. Put your collection in your device and RetroX will take care of the rest.
# 
# Freemium Android
# No features added Add a feature
# 
# RetroX icon
# 4
# PyWinery
# 
# PyWinery is a graphical, easy and simple wine-prefix manager which allows you to launch apps, explore and manage configuration of separate prefixes, graphically and faster than setting variables on linux shell.
# 
# Free Open Source Mac Linux Cedega Wine
# Windows-explorer Add a feature
# 
# PyWinery icon
# 1
# SegaEMU
# 
# SegaEMU is a multi-console Sega Emulator. The Sega consoles that are emulated are: * SG-1000 * Genesis / MegaDrive * SegaCD / MegaCD
# 
#     Discontinued
#     The official website is no longer available. Last version, v0.52b, released on November 2003, can be still downloaded from Zophar.net
# 
# Free Windows
# Portable Add a feature
# 
# SegaEMU icon
# 2
# Ngage Cool!
# 
# Are you waiting for the next-generation mobile game deck? N-Gage vs. N-Gage QD, What''s Right for You? Download: https://ngage-cool.soft32 .
# 
#     Discontinued
#     Official site unavailable.
# 
# Freemium Windows Linux
# No features added Add a feature
# 
# Ngage Cool! icon
# 1
# Genital
# 
# Genital is a Sega Genesis/MegaDrive emulator for Pentium DOS machines.
# 
#     Discontinued
#     Last version, 1.2.0, was released on June, 2001. It can be still downloaded from the Zophar.net
# 
# Free Windows
# Emulation Add a feature
# 
# 1
# Gens+ REWiND!
# 
# Gens+ REWiND! is an Emulator with added support for real-time rewinding! Feel free to call this feature "sands of time" if you want ;) ...
# 
# Free Windows
# Emulation Portable Add a feature
# 
# Gens+ REWiND! icon
# 1
# MEGASIS
# 
# MEGASIS is Genesis/MegaDrive emulator for Windows95/98.
# 
#     Discontinued
#     Last version, 0.06a, released on April 2001, can be still downloaded from the official website.
# 
# Free Windows
# Portable Add a feature
# 
# MEGASIS icon
# 1
# retroDrive
# 
# retroDrive is Sega Genesis and Sega 32X emulator, formerly "GenSX", formerly "Vegas", this was the public's first 32x emulator ever.
# 
# Free Windows
# Emulation Portable Add a feature
# 
# 1
# DebuGens
# 
# DebuGens is a modified version of Gens by Fuzzbuzz. It offers dumps for the ROM, RAM and YM2612 channels for debugging purposes, along with Tile Layer Pro palette creation and layer toggling options.
# 
# Free Windows
# Emulation Portable Add a feature
# 
# DebuGens icon
# 1
# Gens Re-Recording
# 
# Gens Re-Recording, formerly known as Gens Movie Test, is a modification of the highly popular Gens emulator by Stéphane Dallongeville (also known as Stef).
# 
# Free Open Source Windows
# Emulation Portable Add a feature
# 
# Gens Re-Recording icon
# 1
# jEnesis
# 
# "jEnesis" is a Sega MegaDrive/Genesis Emulator entirely written in Java.
# 
# Free Mac Windows Linux
# Emulation Add a feature
# 
# jEnesis icon
# 1
# DroidEmu
# 
# DroidEmu is a game system to play SNES, NES, GameBoy Advanced, GameBoy/Color, SEGA GameGear, SEGA Genesis games on your Android phone. It runs thousands of games at full speed. 1.
# 
#     Discontinued
#     No longer available.
# 
# Freemium Android
# Multi System Emulator Add a feature
# 
# DroidEmu icon
# 4
# Regen
# 
# Regen is an accuracy focused emulator which can emulate the following Sega console and computer systems with very high degree of accuracy: Genesis/MegaDrive Master System Game Gear SC-3000 ...
# 
# Free Windows Linux
# Emulation Portable Add a feature
# 
# Regen icon
# 2
# F-Zero VS
# 
# F-Zero VS is an emulator that gives multiplayer capability for the game, F-Zero. It's a custom build of Snes9x that constantly patches the game with player positions and other data.
# 
#     Discontinued
#     No activity since 2009.
# 
# Free Windows
# Portable Add a feature
# 
# F-Zero VS icon
# 2
# Snes9k
# 
# This is an unofficial work in progress of Snes9x with Kaillera netplay support.
# 
#     Discontinued
#     last version, 0.09z, was released on April 3, 2005
# 
# Free Windows
# Portable Add a feature
# 
# Snes9k icon
# 2
# Snes9X Direct3D
# 
# This is a derivative of Snes9x which switches the its display code from DirectDraw to Direct3D9. The advantages are an optional bi-linear filter and no problems with Aero on Vista.
# 
#     Discontinued
#     last version: 1.51: February 25, 2009
# 
# Free Open Source Windows
# Portable Add a feature
# 
# Snes9X Direct3D icon
# 2
# snes4iphone
# 
# snes4iphone is a Super Nintendo emulator for the iPhone and iPod Touch. This port was developed by ZodTTD and the original source code was ported from Dr. PocketSNES.
# 
#     Discontinued
#     No activity since 2010.
# 
# Commercial iPhone
# Jailbreak required Add a feature
# 
# snes4iphone icon
# 2
# SNESoid
# 
# SNesoid is the famous Super Nintendo emulator for Android. * Net-play through Bluetooth (requires Android 2.
# 
#     Discontinued
#     No activity since 2011.
# 
# Free Open Source Android GitHub
# No features added Add a feature
# 
# SNESoid icon
# 2
# D-Box
# 
# D-Box is an easy to use front-end for DOSBox which enables you to run old MS-DOS games and other applications on a modern computer.
# 
# Free Open Source Mac Windows Linux AmigaOS
# No features added Add a feature
# 
# D-Box icon
# 7
# DBGL
# 
# DBGL is a Java frontend for DOSBox, based largely upon the proven interface of D-Fend. DBGL serves as a frontend / Graphical User Interface to DOSBox (configuration).
# 
# Free Open Source Mac Windows Linux
# No features added Add a feature
# 
# DBGL icon
# 5
# DuckStation
# 
# DuckStation is an simulator/emulator of the Sony PlayStation(TM) console, focusing on playability, speed, and long-term maintainability.
# 
# Free Open Source Mac Windows Linux Android Android Tablet
# Emulation Add a feature
# 
# DuckStation icon
# 1
# GamerOS
# 
# GamerOS is an operating system focused on an out of the box couch gaming experience. After installation, boot directly into Steam Big Picture and start playing your favorite games.
# 
# Free Open Source Linux
# Based on Arch Linux Gaming-focused Linux-based Operating system Add a feature
# 
# GamerOS icon
# 1
# iSNES
# 
# iSNES is an SNES emulator for your iPhone / iPod Touch. It is fully featured and includes: * Multiple save slots. * Save state screenshot previews. * Landscape and portrait views.
# 
#     Discontinued
# 
# Commercial iPhone
# No features added Add a feature
# 
# iSNES icon
# 1
# uosnes
# 
# uosnes is an unofficial Snes9x Windows port using its source code.
# 
#     Discontinued
#     No activity since 2011.
# 
# Free Open Source Windows
# Portable Add a feature
# 
# uosnes icon
# 1
# Provenance
# 
# Provenance is an iOS Frontend for multiple emulators, currently supporting Sega Genesis, Game Gear, Master System and SNES.
# 
#     This only has about a lot more less than retroarch because only plays sega master sega geniseis and other sega and the Super Nintendo Guest • Aug 2015 • 1 agrees and 0 disagrees
# 
# Free Open Source iPhone iPad Apple TV
# Jailbreak required Add a feature
# 
# Provenance icon
# 2
# gpSPhone
# 
# gpSPhone is a Nintendo Gameboy Advance emulator for the iPhone and iPod Touch. It has been ported by ZodTTD from the original source code of gpSP (made by Exophase). They are now both working together on this project.
# 
#     Discontinued
#     The app seems to be no longer updated.
# 
# Free iPhone iPad
# Jailbreak required SSH Add a feature
# 
# gpSPhone icon
# 0
# RESET Collection (Emulator Frontend)
# 
# Hey you, PLAYER 1...
# 
# Commercial $ $ $ Android
# Gaming-focused Arcade Add a feature
# 
# RESET Collection (Emulator Frontend) icon
# 2
# EmuCon
# 
# EmuCon Playground EX is frontend for console emulators (videogames and handhelds). It is compatible with all versions of Windows (Windows XP up to Windows 7.
# 
# Free Open Source Windows
# Emulation Multi System Emulator Add a feature
# 
# EmuCon icon
# 0
# Supercade
# 
# Supercade is a lagless P2P (peer-to-peer) arcade game emulator. It currently supports over 150 games.
# 
# Free Windows
# Arcade Integrated Chat Peer-To-Peer Add a feature
# 
# 0
# SNEShout
# 
# Based on the Snes9x core, this emulator features a few few minor tweaks and one major improvment; SNES games can be played using the Japanese version of ViaVoice.
# 
#     Discontinued
#     The official website is no longer available. Last version, v3.2, released on April 2001, can be still downloaded from Zophar.net
# 
# Free Windows
# Portable Add a feature
# 
# SNEShout icon
# 0
# Super Sleuth
# 
# Super Sleuth is a Super Nintendo Entertainment System emulator. It features a realtime debugging system and great compatibility.
# 
#     Discontinued
#     The official website is no longer available. Last version, v3.2, released on August 2008, can be still downloaded from Zophar.net
# 
# Free Windows
# Portable Add a feature
# 
# Super Sleuth icon
# 0
# Snes9x rerecording
# 
# Snes9x rerecording is a modification of Snes9x. The primary purpose of the project is to expand features related to creating Tool-Assisted movies.
# 
#     Discontinued
#     No longer developed.
# 
# Free Open Source Windows
# Portable Add a feature
# 
# Snes9x rerecording icon
# 0
# Snes9xpp
# 
# This is a custom version of Snes9x which adds an HQ2X filter.
# 
#     Discontinued
#     The official website is no longer available. Last version, v04-05-04, released in May 2004, can be still downloaded from Zophar.net
# 
# Free Windows
# Portable Add a feature
# 
# Snes9xpp icon
# 0
# JsDOSBox
# 
# [Development stage] JavaScript PC DOS Emulator
# 
# Free Open Source Web
# DOS emulation Add a feature
# 
# 0
# jDosbox
# 
# This is an x86 emulator written in pure Java based on the Dosbox project. It currently supports running Dosbox's built in DOS and well as booting into Windows 95/98/NT4.
# 
# Free Open Source Mac Windows Linux
# DOS emulation Add a feature
# 
# jDosbox icon
# 0
# Satourne
# 
# Satourne is an emulator for the Sega Saturn and Sega ST-V hardware. It can play commercial games.
# 
#     Discontinued
#     last official update: 30.08.06
# 
# Free Windows
# Emulation Games Add a feature
# 
# Satourne icon
# 0
# TronDS
# 
# A Nintendo 3DS Emulator, It's very simple and is only capable of running homebrews.
# 
#     Discontinued
#     hasn't had a release in 3 years, no signs of development
# 
# Free Windows
# Portable Add a feature
# 
# 1
# 3dmoo
# 
# 3DS Emulator Prototype
# 
# Free Open Source Windows
# No features added Add a feature
# 
# 0
# PCSP
# 
# PCSP is a Sony PSP emulator written in written in c++.
# 
#     Discontinued
#     The project is no longer developed. Last version, 0.5.4, released in October 2011, can be still downloaded from the official website.
# 
# Free Open Source Windows
# No features added Add a feature
# 
# PCSP icon
# 0
# gGens (MD)
# 
# gGens (MD) is a free, ad-driven emulator for Android that emulates the classic Sega Genesis and Sega Mega Drive videogame systems.
# 
# Freemium Android Android Tablet
# No features added Add a feature
# 
# gGens (MD) icon
# 0
# Bottles
# 
# Bottles is an application designed for elementary OS (but works on all GNU/Linux distributions), which helps in managing wineprefix. This tool simplifies the management of wine prefixes.
# 
# Free Open Source Linux
# Ad-free Games Run Windows software Add a feature
# 
# Bottles icon
# 0
# John SNES
# 
# John SNES is a feature-packed Super Nintendo emulator for Android with high compatibility and long history of development and support.
# 
# Commercial Android Android Tablet
# No features added Add a feature
# 
# John SNES icon
# 0
# Fake64 Good alternative? YES NO
# 
# Fake64 one of the older N64 emulators, but is suprisingly fast, as well as it can support a wide range of games.
# 
# Free Open Source Linux 





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

# ashow => apt show 
# aiy = sudo apt install -y nq
# alias xzip filename.zip         # zip extract
# alias xgzip filename.gz         # gzip extract
# alias xtar -xvf filename.tar      # tar extract '-xv'
# alias xtar -xzf filename.tar.gz   # .tar.gz extract '-xz'
# alias xtar -xJf filename.tar.xz   # .tar.xz extract '-xJ'
# alias xtar -xjf filename.tar.bz2  # .tar.bz2 (bzip2) extract '-xj'
#  
# tar -xf filename.tar.gz
# Extract .7z file in Linux
# These files are 7zip archive files. This is not generally used on Linux systems, but sometimes you may need to extract some source files. You must have the 7zip package installed on your system. Use the following command to extract these files.
# 
# 7z x filename.7z
# 7z x filename.rar         # Using 7zip 
# unrar x filename.rar      # Using Unrar 

# fzf
# export FZF_DEFAULT_COMMAND='fd --type f --color=never --hidden'
# export FZF_DEFAULT_OPTS='--no-height --color=bg+:#343d46,gutter:-1,pointer:#ff3c3c,info:#0dbc79,hl:#0dbc79,hl+:#23d18b'
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :50 {}'"
# export FZF_ALT_C_COMMAND='fd --type d . --color=never --hidden'
# export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -50'"

# git clone https://github.com/roysubs/custom_bash      # Preferred way to get project, then run '. custom_loader.sh' from inside that folder.
# curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/custom_loader.sh | bash              # Alternative one-line installation.
# curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/custom_loader.sh > custom_loader.sh  # Download custom_loader.sh
# curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/.custom > .custom                    # Download .custom

# login_banner() { printf "\n##########\n$(ver)\n##########\n$(sys)\n##########\n"; [ -f /usr/bin/figlet ] && fignow; }
# login_banner() { printf "\n##########\n$(sys)\n##########\n$(ver) : $(date +"%Y-%m-%d, %H:%M:%S, %A, Week %V")\n##########\n"; type figlet >/dev/null 2>&1  && fignow; }



##  ####################
##  #
##  echo "tmux terminal multiplexer (call with help-tmux)"
##  #
##  ####################
##  
##  # Note the "" to surround the $1 string otherwise prefix/trailing spaces will be removed
##  # Using echo -e to display the final help file, as printf requires escaping "%" as "%%" or "\045" etc
##  # This is a good template for creating help files for various summaries (could also do vim, tmux, etc)
##  # In .custom, we can then simply create aliases if the files exist:
##  # [ -f /tmp/help-tmux.sh ] && alias help-tmux='/tmp/help-tmux.sh' && alias help-t='/tmp/help-tmux.sh'   # for .custom
##  
##  # https://davidwinter.dev/tmux-the-essentials/
##  # https://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/
##  # https://www.golinuxcloud.com/tmux-cheatsheet/
##  # https://tmuxguide.readthedocs.io/en/latest/tmux/tmux.html
##  
##  HELPFILE=$hh/help-tmux.sh
##  exx() { echo "$1" >> $HELPFILE; }
##  echo "#!/bin/bash" > $HELPFILE
##  exx "BLUE='\\033[0;34m'; RED='\\033[0;31m'; NC='\\033[0m'"

##  exx "HELPNOTES=\""
##  exx "tmux is a terminal multiplexer which allows multiple panes and windows inside a single console."
##  exx ""
##  exx "Essentials:  <C-b> means Ctrl-b  ,  <C-b> : => enter command mode"
##  exx "List sessions: tmux ls , tmux list-sessions  , <C-b> : ls"
##  exx "Show sessions: <C-b> s ,<C-b> w (window preview)"
##  exx ""
##  exx "Start a new session:  tmux , tmux new -s my1 , :new -s my1"
##  exx "Detach this session:  <C-b> d , tmux detach"
##  exx "Re-attach a session:  tmux a -t my1  (or by the index of the session)"
##  exx "Kill/Delete session:  tmux kill-sess -t my1  , all but current:  tmux kill-sess -a ,  all but 'my1':  tmux kill-sess -a -t my1"
##  
##  exx "Ctrl + b $   Rename session,   Ctrl + b d   Detach from session"
##  exx "attach -d    Detach others on the session (Maximize window by detach other clients)"
##  exx ""
##  exx "tmux a / at / attach / attach-session   Attach to last session"
##  exx "tmux a -t mysession   Attach to a session with the name mysession"
##  exx ""
##  exx "Ctrl + b (  (move to previous session) , <C-b> b )  (move to next session)"
##  
##  exx "Command	Description"
##  exx "tmux	start tmux"
##  exx "tmux new -s <name>	start tmux with <name>"
##  exx "tmux ls	shows the list of sessions"
##  exx "tmux a #	attach the detached-session"
##  exx "tmux a -t <name>	attach the detached-session to <name>"
##  exx "tmux kill-session –t <name>	kill the session <name>"
##  exx "tmux kill-server	kill the tmux server"
##  exx "Windows"
##  exx "tmux new -s mysession -n mywindow"
##  exx "start a new session with the name mysession and window mywindow"
##  exx ""
##  exx "Ctrl + b c"
##  exx "Create window"
##  exx ""
##  exx "Ctrl + b ,"
##  exx "Rename current window"
##  exx ""
##  exx "Ctrl + b &"
##  exx "Close current window"
##  exx ""
##  exx "Ctrl + b p"
##  exx "Previous window"
##  exx ""
##  exx "Ctrl + b n"
##  exx "Next window"
##  exx ""
##  exx "Ctrl + b 0 ... 9"
##  exx "Switch/select window by number"
##  exx ""
##  exx "swap-window -s 2 -t 1"
##  exx "Reorder window, swap window number 2(src) and 1(dst)"
##  exx ""
##  exx "swap-window -t -1"
##  exx "Move current window to the left by one position"
##  exx ""
##  exx "***** Panes"
##  exx "Splits:  Ctrl + b %  (horizontal)  ,  Ctrl + b \\\"  (vertical)"
##  exx "Moves:   <C-b> o  (next pane)  , <C-b> {  (left)  ,  <C-b> {  (right)  ,  <C-b> <cursor-key>  (move to pane in that direction)"
##  exx "         <C-b> ;  (toggle last active)  ,  <C-b> <space>  (toggle different pane layouts)"
##  exx "Send:    :setw sy (synchronize-panes, toggle sending all commands to all panes)"
##  exx "Index:   <C-b> q  (show pane indexes)  ,  <C-b> q 0 .. 9  (switch to a pane by its index) "
##  exx "Zoom:    <C-b> z  (toggle pane between full screen and back to windowed)"
##  exx "Resize:  <C-b> <C-cursor-key>  (hold down Ctrl, first press b, then a cursor, don't hold, press again for more resize)"
##  exx "Close:   <C-b> x  (close pane)"
##  exx ""
##  
##  exx "Ctrl + b !"
##  exx "Convert pane into a window"
##  exx ""
##  exx "Copy Mode"
##  exx "setw -g mode-keys vi"
##  exx "use vi keys in buffer"
##  exx ""
##  exx "Ctrl + b ["
##  exx "Enter copy mode"
##  exx ""
##  exx "Ctrl + b PgUp"
##  exx "Enter copy mode and scroll one page up"
##  exx ""
##  exx "q"
##  exx "Quit mode"
##  exx ""
##  exx "g"
##  exx "Go to top line"
##  exx ""
##  exx "G"
##  exx "Go to bottom line"
##  exx ""
##  exx "Scroll up"
##  exx ""
##  exx "Scroll down"
##  exx ""
##  exx "h"
##  exx "Move cursor left"
##  exx ""
##  exx "j"
##  exx "Move cursor down"
##  exx ""
##  exx "k"
##  exx "Move cursor up"
##  exx ""
##  exx "l"
##  exx "Move cursor right"
##  exx ""
##  exx "w"
##  exx "Move cursor forward one word at a time"
##  exx ""
##  exx "b"
##  exx "Move cursor backward one word at a time"
##  exx ""
##  exx "/"
##  exx "Search forward"
##  exx ""
##  exx "?"
##  exx "Search backward"
##  exx ""
##  exx "n"
##  exx "Next keyword occurance"
##  exx ""
##  exx "N"
##  exx "Previous keyword occurance"
##  exx ""
##  exx "Spacebar"
##  exx "Start selection"
##  exx ""
##  exx "Esc"
##  exx "Clear selection"
##  exx ""
##  exx "Enter"
##  exx "Copy selection"
##  exx ""
##  exx "Ctrl + b ]"
##  exx "Paste contents of buffer_0"
##  exx ""
##  exx "show-buffer"
##  exx "display buffer_0 contents"
##  exx ""
##  exx "capture-pane"
##  exx "copy entire visible contents of pane to a buffer"
##  exx ""
##  exx "list-buffers"
##  exx "Show all buffers"
##  exx ""
##  exx "choose-buffer"
##  exx "Show all buffers and paste selected"
##  exx ""
##  exx "save-buffer buf.txt"
##  exx "Save buffer contents to buf.txt"
##  exx ""
##  exx "delete-buffer -b 1"
##  exx "delete buffer_1"
##  exx ""
##  exx "Misc"
##  exx "Ctrl + b :      # Enter command mode"
##  exx "set -g OPTION   # Set OPTION for all sessions"
##  exx "setw -g OPTION  # Set OPTION for all windows"
##  exx "set mouse on    # Enable mouse mode"
##  exx "Help"
##  exx "tmux list-keys  # list-keys"
##  exx "Ctrl + b ?      # List key bindings (i.e. shortcuts)"
##  exx "tmux info       # Show every session, window, pane, etc..."
##  exx "\""   # require final line with a single " to close multi-line string
##  exx "echo -e \"\$HELPNOTES\""
##  chmod 755 $HELPFILE



##  ####################
##  # Quick help topics that can be defined in one-liners, basic syntax reminders for various tasks
##  ####################
##  # printf requires "\% characters to to be escaped as \" , \\ , %%. To get ' inside aliases use \" to open printf, e.g. alias x="printf \"stuff about 'vim'\n\""
##  # Bash designers seem to encourage not using aliases and only using functions, which eliminates this problem. https://stackoverflow.com/questions/67194736
##  # Example of using aliases for this:   alias help-listdirs="printf \"Several ways to list only directories:\nls -d */ | cut -f1 -d '/'\nfind \\. -maxdepth 1 -type d\necho */\ntree /etc -daifl   # -d (dirs only), -a (all, including hidden), -i (don't show tree structure), -f (full path), -l (don't follow symbolic links), -p (permissions), -u (user/UID), --du (disk usage)\n\""
##  fn-help() { printf "\n$1\n==========\n\n$2\n\n"; }
##  help-listdirs() { fn-help "Several ways to list directories only (but no files):" "ls -d */ | cut -f1 -d '/'\nfind \\. -maxdepth 1 -type d\necho */\ntree /etc -faild   # -d (dirs only), -f (full path), -a (all, including hidden), -i (don't show tree structure), -l (don't follow symbolic links). Show additional info with -p (permissions), -u (user/UID), --du (disk usage) -h (human readable), tree . -fail --du -h\nlr   # list files and directories recursively, equivalent to 'tree -fail'\nNote dir/vdir/ls differences https://askubuntu.com/questions/103913/."; }
##  help-zip() { fn-help "Common 'zip and '7z/7za' archive examples:" "7z a -y -r -t7z -mx9 repo * '-xr!.git' -x@READ*   # recurse with 7z output and max compression, exclude a file\nzip -r repo ./ -x '*.git*' '*README.md'    # recurse and exclude files/folders"; }
##  help-mountcifs() { fn-help "Connect to CIFS/SAMBA shares on a Windows system:" "mkdir <local-mount-path>   # Create a path to mount the share in\nsudo mount.cifs //<ip>/<sharename> ~/winpc -o user=<winusername>\nsudo mount -t cifs -o ip=<ip>, username=<winusername> //<hostname-or-ip>/<sharename> /<local-mount-path   # Alternate syntax"; }
##  # https://phoenixnap.com/kb/how-to-list-installed-packages-on-ubuntu   # https://phoenixnap.com/kb/uninstall-packages-programs-ubuntu
##  help-packages_apt() { fn-help "apt package management:" "info dir / info ls / def dir / def ls # Basic information on commands\napt show vim         # show details on the 'vim' package\napt list --installed   | less\napt list --upgradeable | less\napt remove vim       # uninstall a package (note --purge will also remove all config files)\n\napt-file searches packages for specific files (both local and from repos).\nUnlike 'dpkg -L', it can search also remote repos. It uses a local cache of package contents 'sudo apt-file update'\napt-file list vim    # (or 'apt-file show') the exact contents of the 'vim' package\napt-file search vim  # (or 'apt-file find') search every reference to 'vim' across all packages"; }

##  #=========================================================================
##  #
##  #  PROGRAMMABLE COMPLETION SECTION
##  #  Most are taken from the bash 2.05 documentation and from Ian McDonald's
##  # 'Bash completion' package (http://www.caliban.org/bash/#completion)
##  #  You will in fact need bash more recent then 3.0 for some features.
##  #
##  #  Note that most linux distributions now provide many completions
##  # 'out of the box' - however, you might need to make your own one day,
##  #  so I kept those here as examples.
##  #=========================================================================
##  
##  if [ "${BASH_VERSION%.*}" \< "3.0" ]; then
##      echo "You will need to upgrade to version 3.0 for full \
##            programmable completion features"
##      return
##  fi
##  
##  shopt -s extglob        # Necessary.
##  
##  complete -A hostname   rsh rcp telnet rlogin ftp ping disk
##  complete -A export     printenv
##  complete -A variable   export local readonly unset
##  complete -A enabled    builtin
##  complete -A alias      alias unalias
##  complete -A function   function
##  complete -A user       su mail finger
##  
##  complete -A helptopic  help     # Currently same as builtins.
##  complete -A shopt      shopt
##  complete -A stopped -P '%' bg
##  complete -A job -P '%'     fg jobs disown
##  
##  complete -A directory  mkdir rmdir
##  complete -A directory   -o default cd
##  
##  # Compression
##  complete -f -o default -X '*.+(zip|ZIP)'  zip
##  complete -f -o default -X '!*.+(zip|ZIP)' unzip
##  complete -f -o default -X '*.+(z|Z)'      compress
##  complete -f -o default -X '!*.+(z|Z)'     uncompress
##  complete -f -o default -X '*.+(gz|GZ)'    gzip
##  complete -f -o default -X '!*.+(gz|GZ)'   gunzip
##  complete -f -o default -X '*.+(bz2|BZ2)'  bzip2
##  complete -f -o default -X '!*.+(bz2|BZ2)' bunzip2
##  complete -f -o default -X '!*.+(zip|ZIP|z|Z|gz|GZ|bz2|BZ2)' extract
##  
##  
##  # Documents - Postscript,pdf,dvi.....
##  complete -f -o default -X '!*.+(ps|PS)'  gs ghostview ps2pdf ps2ascii
##  complete -f -o default -X \
##  '!*.+(dvi|DVI)' dvips dvipdf xdvi dviselect dvitype
##  complete -f -o default -X '!*.+(pdf|PDF)' acroread pdf2ps
##  complete -f -o default -X '!*.@(@(?(e)ps|?(E)PS|pdf|PDF)?\
##  (.gz|.GZ|.bz2|.BZ2|.Z))' gv ggv
##  complete -f -o default -X '!*.texi*' makeinfo texi2dvi texi2html texi2pdf
##  complete -f -o default -X '!*.tex' tex latex slitex
##  complete -f -o default -X '!*.lyx' lyx
##  complete -f -o default -X '!*.+(htm*|HTM*)' lynx html2ps
##  complete -f -o default -X \
##  '!*.+(doc|DOC|xls|XLS|ppt|PPT|sx?|SX?|csv|CSV|od?|OD?|ott|OTT)' soffice
##  
##  # Multimedia
##  complete -f -o default -X \
##  '!*.+(gif|GIF|jp*g|JP*G|bmp|BMP|xpm|XPM|png|PNG)' xv gimp ee gqview
##  complete -f -o default -X '!*.+(mp3|MP3)' mpg123 mpg321
##  complete -f -o default -X '!*.+(ogg|OGG)' ogg123
##  complete -f -o default -X \
##  '!*.@(mp[23]|MP[23]|ogg|OGG|wav|WAV|pls|\
##  m3u|xm|mod|s[3t]m|it|mtm|ult|flac)' xmms
##  complete -f -o default -X '!*.@(mp?(e)g|MP?(E)G|wma|avi|AVI|\
##  asf|vob|VOB|bin|dat|vcd|ps|pes|fli|viv|rm|ram|yuv|mov|MOV|qt|\
##  QT|wmv|mp3|MP3|ogg|OGG|ogm|OGM|mp4|MP4|wav|WAV|asx|ASX)' xine
##  
##  
##  
##  complete -f -o default -X '!*.pl'  perl perl5
##  
##  
##  #  This is a 'universal' completion function - it works when commands have
##  #+ a so-called 'long options' mode , ie: 'ls --all' instead of 'ls -a'
##  #  Needs the '-o' option of grep
##  #+ (try the commented-out version if not available).
##  
##  #  First, remove '=' from completion word separators
##  #+ (this will allow completions like 'ls --color=auto' to work correctly).
##  
##  COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
##  
##  
##  _get_longopts()
##  {
##    #$1 --help | sed  -e '/--/!d' -e 's/.*--\([^[:space:].,]*\).*/--\1/'| \
##    #grep ^"$2" |sort -u ;
##      $1 --help | grep -o -e "--[^[:space:].,]*" | grep -e "$2" |sort -u
##  }
##  
##  _longopts()
##  {
##      local cur
##      cur=${COMP_WORDS[COMP_CWORD]}
##  
##      case "${cur:-*}" in
##         -*)      ;;
##          *)      return ;;
##      esac
##  
##      case "$1" in
##         \~*)     eval cmd="$1" ;;
##           *)     cmd="$1" ;;
##      esac
##      COMPREPLY=( $(_get_longopts ${1} ${cur} ) )
##  }
##  complete  -o default -F _longopts configure bash
##  complete  -o default -F _longopts wget id info a2ps ls recode
##  
##  _tar()
##  {
##      local cur ext regex tar untar
##  
##      COMPREPLY=()
##      cur=${COMP_WORDS[COMP_CWORD]}
##  
##      # If we want an option, return the possible long options.
##      case "$cur" in
##          -*)     COMPREPLY=( $(_get_longopts $1 $cur ) ); return 0;;
##      esac
##  
##      if [ $COMP_CWORD -eq 1 ]; then
##          COMPREPLY=( $( compgen -W 'c t x u r d A' -- $cur ) )
##          return 0
##      fi
##  
##      case "${COMP_WORDS[1]}" in
##          ?(-)c*f)
##              COMPREPLY=( $( compgen -f $cur ) )
##              return 0
##              ;;
##          +([^Izjy])f)
##              ext='tar'
##              regex=$ext
##              ;;
##          *z*f)
##              ext='tar.gz'
##              regex='t\(ar\.\)\(gz\|Z\)'
##              ;;
##          *[Ijy]*f)
##              ext='t?(ar.)bz?(2)'
##              regex='t\(ar\.\)bz2\?'
##              ;;
##          *)
##              COMPREPLY=( $( compgen -f $cur ) )
##              return 0
##              ;;
##  
##      esac
##  
##      if [[ "$COMP_LINE" == tar*.$ext' '* ]]; then
##          # Complete on files in tar file.
##          #
##          # Get name of tar file from command line.
##          tar=$( echo "$COMP_LINE" | \
##                          sed -e 's|^.* \([^ ]*'$regex'\) .*$|\1|' )
##          # Devise how to untar and list it.
##          untar=t${COMP_WORDS[1]//[^Izjyf]/}
##  
##          COMPREPLY=( $( compgen -W "$( echo $( tar $untar $tar \
##                                  2>/dev/null ) )" -- "$cur" ) )
##          return 0
##  
##      else
##          # File completion on relevant files.
##          COMPREPLY=( $( compgen -G $cur\*.$ext ) )
##  
##      fi
##  
##      return 0
##  
##  }
##  
##  complete -F _tar -o default tar
##  
##  _make()
##  {
##      local mdef makef makef_dir="." makef_inc gcmd cur prev i;
##      COMPREPLY=();
##      cur=${COMP_WORDS[COMP_CWORD]};
##      prev=${COMP_WORDS[COMP_CWORD-1]};
##      case "$prev" in
##          -*f)
##              COMPREPLY=($(compgen -f $cur ));
##              return 0
##              ;;
##      esac;
##      case "$cur" in
##          -*)
##              COMPREPLY=($(_get_longopts $1 $cur ));
##              return 0
##              ;;
##      esac;
##  
##      # ... make reads
##      #          GNUmakefile,
##      #     then makefile
##      #     then Makefile ...
##      if [ -f ${makef_dir}/GNUmakefile ]; then
##          makef=${makef_dir}/GNUmakefile
##      elif [ -f ${makef_dir}/makefile ]; then
##          makef=${makef_dir}/makefile
##      elif [ -f ${makef_dir}/Makefile ]; then
##          makef=${makef_dir}/Makefile
##      else
##         makef=${makef_dir}/*.mk         # Local convention.
##      fi
##  
##  
##      #  Before we scan for targets, see if a Makefile name was
##      #+ specified with -f.
##      for (( i=0; i < ${#COMP_WORDS[@]}; i++ )); do
##          if [[ ${COMP_WORDS[i]} == -f ]]; then
##              # eval for tilde expansion
##              eval makef=${COMP_WORDS[i+1]}
##              break
##          fi
##      done
##      [ ! -f $makef ] && return 0
##  
##      # Deal with included Makefiles.
##      makef_inc=$( grep -E '^-?include' $makef |
##                   sed -e "s,^.* ,"$makef_dir"/," )
##      for file in $makef_inc; do
##          [ -f $file ] && makef="$makef $file"
##      done
##  
##  
##      #  If we have a partial word to complete, restrict completions
##      #+ to matches of that word.
##      if [ -n "$cur" ]; then gcmd='grep "^$cur"' ; else gcmd=cat ; fi
##  
##      COMPREPLY=( $( awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ \
##                                 {split($1,A,/ /);for(i in A)print A[i]}' \
##                                  $makef 2>/dev/null | eval $gcmd  ))
##  
##  }
##  
##  complete -F _make -X '+($*|*.[cho])' make gmake pmake
##  
##  
##  
##  
##  _killall()
##  {
##      local cur prev
##      COMPREPLY=()
##      cur=${COMP_WORDS[COMP_CWORD]}
##  
##      #  Get a list of processes
##      #+ (the first sed evaluation
##      #+ takes care of swapped out processes, the second
##      #+ takes care of getting the basename of the process).
##      COMPREPLY=( $( ps -u $USER -o comm  | \
##          sed -e '1,1d' -e 's#[]\[]##g' -e 's#^.*/##'| \
##          awk '{if ($0 ~ /^'$cur'/) print $0}' ))
##  
##      return 0
##  }
##  
##  complete -F _killall killall killps
##  
##  
##  
##  # Local Variables:
##  # mode:shell-script
##  # sh-shell:bash
##  # End:

# Chagning keyboard layouts
# The following came from #http://eklhad.net/linux/app/onehand.html (now seems dead)
# alias keyboard-asdf="loadkeys /usr/lib/kbd/keytables/dvorak.map"
# alias keyboard-aoeu="loadkeys /usr/lib/kbd/keytables/us.map"   # didn't work - must be a different command?
# But the below do work (from the KDE Control Module Layout tab in the bottom where it says Command)
# alias keyboard-asdf="setxkbmap -layout us -variant dvorak"
# alias keyboard-aoeu="setxkbmap -layout us -variant basic"


###   ### profile example:
###   
###   #BASH environment
###   shopt -s histappend
###   shopt -s cmdhist
###   export PROMPT_COMMAND="history -n" #; history -a
###   export HISTIGNORE="&:ls:[bf]g:exit"
###   export HISTCONTROL="ignoreboth:ignorespace:erasedups"
###   #PS1='\[\e[0;32m\]\u@\h\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$ \[\e[m\]\[\e[1;37m\] '
###   #PS1='\[\e[1;37m\]\@\e[m\] \[\e[0;33m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$ \[\e[m\]'
###   
###   ##################
###   #users and groups#
###   ##################
###   
###   uinf(){
###   echo "current directory="`pwd`;
###   echo "you are="`whoami`
###   echo "groups in="`id -n -G`;
###   tree -L 1 -h $HOME;
###   echo "terminal="`tty`;
###   }
###   
###   #################
###   #search and find#
###   #################
###   
###   alias ww="which"
###   
###   #search and grep
###   g(){
###   cat $1|grep $2
###   }
###   
###   #find
###   ff(){
###   find . -name $@ -print;
###   }
###   
###   ######################
###   #directory navigation#
###   ######################
###   
###   alias c="cd"
###   alias u="cd .."
###   alias cdt="cd $1&&tree -L 3 -h"
###   alias c-="cd -"
###   
###   ##ls when cd
###   cd(){
###   if [ -n "$1" ]; then
###   builtin cd "$@"&&ls -la --color=auto
###   else
###   builtin cd ~&&ls -la --color=auto
###   fi
###   }
###   
###   #######################
###   #directory information#
###   #######################
###   
###   alias du="du -h"
###   alias ds="du -h|sort -n"
###   alias dusk="du -s -k -c *| sort -rn"
###   alias dush="du -s -k -c -h *| sort -rn"
###   alias t3="tree -L 3 -h"
###   alias t="tree"
###   alias dir="dir --color=auto"
###   
###   #ls
###   alias ls="ls --color=auto"
###   alias ll="ls -l"
###   alias l="ls -CF"
###   alias la="ls -la"
###   alias li="ls -ai1|sort" # sort by index number
###   alias lt="ls -alt|head -20" # 20, all, long listing, modification time
###   alias lh="ls -Al" # show hidden files
###   alias lx="ls -lXB" # sort by extension
###   alias lk="ls -lSr" # sort by size
###   alias lss="ls -shAxSr" # sort by size
###   alias lc="ls -lcr" # sort by change time
###   alias lu="ls -lur" # sort by access time
###   alias ld="ls -ltr" # sort by date
###   alias lm="ls -al|more" # pipe through ‘more’
###   alias lsam="ls -am" # List files horizontally
###   alias lr="ls -lR" # recursive
###   alias lsx="ls -ax" # sort right to left rather then in columns
###   alias lh="ls -lAtrh" # sort by date and human readable
###   
###   #top10 largest in directory
###   t10(){
###   pwd&&du -ab $1|sort -n -r|head -n 10
###   }
###   
###   #top10 apparent size
###   t10a(){
###   pwd&&du -ab --apparent-size $1|sort -n -r|head -n 10
###   }
###   
###   #dsz - finds directory sizes and lists them for the current directory
###   dsz (){
###   du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
###   egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
###   egrep '^ *[0-9.]*M' /tmp/list
###   egrep '^ *[0-9.]*G' /tmp/list
###   rm /tmp/list
###   }
###   
###   #################################
###   #file and directory manipulation#
###   #################################
###   
###   alias n="nano"
###   alias rm="rm -i"
###   alias cp="cp -i"
###   alias mv="mv -i"
###   alias dclr="find . -maxdepth 1 -type f -exec rm {} \;" #clean out directory,leaving intact
###   
###   
###   #remove from startup but keep init script handy
###   sym(){
###   update-rc.d -f $1 remove
###   }
###   
###   #force directory rm
###   rmd(){
###   rm -fr $@;
###   }
###   
###   #makes a directory, then changes into it
###   #mkcd (){
###   #mkdir -p $1&& cd $1
###   #}
###   
###   # makes directory($1), and moves file in current (pwd+$2) to new directory and changes to new directory
###   mkcd(){
###   THIS=`pwd`
###   mkdir -p $1&&mv $THIS/$2 $1&&cd $1
###   }
###   
###   #changes to the parent directory, then removes the one you were just in.
###   cdrm(){
###   THIS=`pwd`
###   cd ..
###   rmd $THIS
###   }
###   
###   ##########
###   #archives#
###   ##########
###   
###   # Extract files from any archive
###   ex () {
###   if [ -f $1 ] ; then
###   case $1 in
###   *.tar.bz2) tar xjf $1 ;;
###   *.tar.gz) tar xzf $1 ;;
###   *.bz2) bunzip2 $1 ;;
###   *.rar) rar x $1 ;;
###   *.gz) gunzip $1 ;;
###   *.tar) tar xf $1 ;;
###   *.tbz2) tar xjf $1 ;;
###   *.tgz) tar xzf $1 ;;
###   *.zip) unzip $1 ;;
###   *.Z) uncompress $1 ;;
###   *.7z) 7z x $1 ;;
###   *) echo "'$1' cannot be extracted via extract()" ;;
###   esac
###   else
###   echo "'$1' is not a valid file"
###   fi
###   }
###   
###   #######################
###   #processes and sysinfo#
###   #######################
###   
###   alias fr="free -otm"
###   alias d="df"
###   alias df="df -h"
###   alias h="htop"
###   alias pst="pstree"
###   alias psx="ps auxw|grep $1"
###   alias pss="ps --context ax"
###   alias psu="ps -eo pcpu -o pid -o command -o user|sort -nr|head"
###   alias cpuu="ps -e -o pcpu,cpu,nice,state,cputime,args --sort pcpu | sed '/^ 0.0 /d'"
###   alias memu='ps -e -o rss=,args= | sort -b -k1,1n | pr -TW$COLUMNS'
###   alias ducks='ls -A | grep -v -e '\''^\.\.$'\'' |xargs -i du -ks {} |sort -rn |head -16 | awk '\''{print $2}'\'' | xargs -i du -hs {}' # useful alias to browse your filesystem for heavy usage quickly
###   
###   #system roundup
###   sys(){
###   if [ `id -u` -ne 0 ]; then echo "you are not root"&&exit;fi;
###   uname -a
###   echo "runlevel" `runlevel`
###   uptime
###   last|head -n 5;
###   who;
###   echo "============= CPUs ============="
###   grep "model name" /proc/cpuinfo #show CPU(s) info
###   cat /proc/cpuinfo | grep 'cpu MHz'
###   echo ">>>>>current process"
###   pstree
###   echo "============= MEM ============="
###   #KiB=`grep MemTotal /proc/meminfo | tr -s ' ' | cut -d' ' -f2`
###   #MiB=`expr $KiB / 1024`
###   #note various mem not accounted for, so round to appropriate sizeround=32
###   #echo "`expr \( \( $MiB / $round \) + 1 \) \* $round` MiB"
###   free -otm;
###   echo "============ NETWORK ============"
###   ip link show
###   /sbin/ifconfig | awk /'inet addr/ {print $2}'
###   /sbin/ifconfig | awk /'Bcast/ {print $3}'
###   /sbin/ifconfig | awk /'inet addr/ {print $4}'
###   /sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
###   echo "============= DISKS =============";
###   df -h;
###   echo "============= MISC =============="
###   echo "==<kernel modules>=="
###   lsmod|column -t|awk '{print $1}';
###   echo "=======<pci>========"
###   lspci -tv;
###   echo "=======<usb>======="
###   lsusb;
###   }
###   
###   #readable df
###   dfh(){
###   df -PTah $@
###   }
###   
###   #Locate processes
###   function pspot () {
###   echo `ps auxww | grep $1 | grep -v grep`
###   }
###   
###   #Nuke processes
###   function pk () {
###   killing=`ps auxww | grep $1 | grep -v grep | cut -c10-16`
###   echo "Killing $killing"
###   kill -9 $killing
###   }
###   
###   #########
###   #network#
###   #########
###   
###   alias d.="sudo ifdown eth0"
###   alias u.="sudo ifup eth0"
###   alias if.="sudo iftop -Pp -i eth0"
###   alias i.="ifconfig"
###   alias r.="route"
###   alias ipt.="sudo iptstate -l -1"
###   alias iptq.="sudo iptstate -l -1|grep $1"
###   alias n1.='netstat -tua'
###   alias n2.="netstat -alnp --protocol=inet|grep -v CLOSE_WAIT|cut -c-6,21-94|tail"
###   alias n3.='watch --interval=2 "sudo netstat -apn -l -A inet"'
###   alias n4.='watch --interval=2 "sudo netstat -anp --inet --inet6"'
###   alias n5.='sudo lsof -i'
###   alias n6.='watch --interval=2 "sudo netstat -p -e --inet --numeric-hosts"'
###   alias n7.='watch --interval=2 "sudo netstat -tulpan"'
###   alias n8.='sudo netstat -tulpan'
###   alias n9.='watch --interval=2 "sudo netstat -utapen"'
###   alias n10.='watch --interval=2 "sudo netstat -ano -l -A inet"'
###   alias n11.='netstat -an | sed -n "1,/Active UNIX domain sockets/ p" | more'
###   
###   #network information
###   ni.(){
###   echo "--------------- Network Information ---------------"
###   /sbin/ifconfig | awk /'inet addr/ {print $2}'
###   /sbin/ifconfig | awk /'Bcast/ {print $3}'
###   /sbin/ifconfig | awk /'inet addr/ {print $4}'
###   /sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
###   echo "---------------------------------------------------"
###   }
###   
###   #####
###   #apt#
###   #####
###   
###   alias update="sudo apt-get update"
###   alias upgrade="sudo apt-get update&&sudo apt-get dist-upgrade"
###   alias apt="sudo apt-get install"
###   alias remove="sudo apt-get autoremove"
###   alias search="apt-cache search"
###   
###   ######
###   #misc#
###   ######
###   
###   alias .a="nano ~/.bash_alias" #personal shortcut for editing aliases
###   alias .a2="kwrite ~/.bash_alias&"
###   alias .x="xset dpms force off" # turns off lcd screen
###   alias .mpd="synclient TouchpadOff=1"
###   alias .mpu="synclient TouchpadOff=0"
###   
###   #2nd life
###   2l(){
###   esd&
###   ~/SL/SecondLife_i686_1_20_14_92115_RELEASECANDIDATE/secondlife
###   }
###   
###   #email sort from text e.g. webpage source html
###   address(){
###   cat $1|grep $2|perl -wne'while(/[\w\.\-]+@[\w\.\-]+\w+/g){print "$&\n"}'| sort -u > address.txt
###   }
###   
###   #parse links from html LINKS is a perl script
###   #or ?
###   #remove most HTML tags (accommodates multiple-line tags)
###   #sed -e :a -e 's/<[^>]*>//g;/</N;//ba'
###   links(){
###   links $1|sort -u>>./parsedlinks.txt
###   }
###   
###   #analyze your bash usage
###   check(){
###   cut -f1 -d" " .bash_history | sort | uniq -c | sort -nr | head -n 30
###   }
###   
###   # clock - A bash clock that can run in your terminal window.
###   clock (){
###   while true;do clear;echo "===========";date +"%r";echo "===========";sleep 1;done
###   }
###   
###   #Welcome Screen#
###   clear
###   echo -ne "${GREEN}" "Hello, $USER. today is, "; date
###   echo -e "${WHITE}"; cal;
###   echo -ne "${CYAN}";
###   echo -ne "${BRIGHT_VIOLET}Sysinfo:";uptime ;echo ""
###   ##
###   
###   # Define a word - USAGE: define dog
###   define (){
###   lynx -dump "http://www.google.com/search?hl=en&q=define%3A+${1}&btnG=Google+Search" |
###   grep -m 3 -w "*" | sed 's/;/ -/g' | cut -d- -f1 > /tmp/templookup.txt
###   if [[ -s /tmp/templookup.txt ]] ;then
###   until ! read response
###   do
###   echo "${response}"
###   done < /tmp/templookup.txt
###   else
###   echo "Sorry $USER, I can't find the term
###   \"${1} \""
###   fi
###   \rm -f /tmp/templookup.txt
###   }
###   
###   #py template
###   py(){
###   echo -e '#!/usr/bin/python\n# -*- coding: UTF-8 -*-\n#\n#\n'>$1.py
###   chmod +x $1.py
###   nano $1.py
###   }
###   
###   
###   
###   
###   
###   
###   
###   
###   
###   
###   
###   
###   
###   
###   
###   
###   
###   
###   
###   
###   
###   
###   ################################################## ################################
###   #to be determined#
###   # regex for email?
###   # ^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,6}$
###   # regex for httpaddresses?
###   # /<a\s[^>]*href=(\"??)([^\" >]*?)\\1[^>]*>(.*)<\/a>/siU
###   # /<a\s[^>]*href\s*=\s*(\"??)([^\" >]*?)\\1[^>]*>(.*)<\/a>/siU
###   #
###   #lcfiles - Lowercase all files in the current directory
###   #lcfiles() {
###   #read -p "Really lowercase all files? (y/n)"
###   #[$REPLY=="y"]||exit
###   #for i in *
###   #do mv $i $i:l
###   #echo "done";
###   #fi
###   
###   #alias lup='/etc/rc.d/lighttpd start'
###   #alias lup.='/etc/rc.d/lighttpd restart'
###   #alias t3="tree"
###   #PS1='[\d \u@\h:\w]'
###   #PS1='[\u@\h \W]\$ '
###   #PS1="\[\033[1;30m\][\[\033[1;34m\]\u\[\033[1;30m\]@\[\033[0;35m\]\h\[\033[1;30m\]]\[\033[0;37m\]\W \[\033[1;30m\]\$\[\033[0m\]"
###   #cool colors for manpages
###   #alias man="TERMINFO=~/.terminfo TERM=mostlike LESS=C PAGER=less man"
###   #alias sl="/home/wind/SL/SL/secondlife"
###   
###   # Compress the cd, ls -l series of commands.
###   #alias lc="cl"
###   #function cl () {
###   # if [ $# = 0 ]; then
###   # cd && ll
###   # else
###   # cd "$*" && ll
###   # fi
###   #}
###   
###   #readln prompt default
###   #
###   #function readln () {
###   # if [ "$DEFAULT" = "-d" ]; then
###   # echo "$1"
###   # ans=$2
###   # else
###   # echo -n "$1"
###   # IFS='@' read ans </dev/tty || exit 1
###   # [ -z "$ans" ] && ans=$2
###   # fi
###   #}
###   
###   
###   #http://seanp2k.com/?p=13
###   #It’s for running scp with preset variables, you could maybe make a few of
###   #these for different servers you use scp to send files to, again a big
###   #time-saver.
###   # function sshcp {
###   # #ssh cp function by seanp2k
###   # FNAME=$1
###   # #the name of the file or files you want to copy
###   # PORTNUM=”22″
###   # #the port number for ssh, usually 22
###   # HOSTNAM=”192.168.1.1″
###   # #the host name or IP you are trying to ssh into
###   # if [ $2 ]
###   # then
###   # RFNAME=”:$2″
###   # else
###   # RFNAME=”:”
###   # fi
###   # #if you specify a second argument, i.e. sshcp foo.tar blah.tar,
###   # #it will take foo.tar locally and copy it to remote file bar.tar
###   # #otherwise, just use the input filename
###   # USRNAME=”root”
###   # #you should never allow root login via ssh, so change this username
###   #
###   # scp -P “$PORTNUM” “$FNAME” “$USRNAME@$HOSTNAM$RFNAME”
###   #
###   # }
###   
###   #http://seanp2k.com/?p=13
###   #searches through the text of all the files in your current directory. #Very useful for, say, debugging a PHP script you didn’t write and can’t #trackdown where that damn MySQL connect string actually is.
###   #function grip {
###   #grep -ir “$1″ “$PWD”
###   #}
###   
###   ##top10 again *only produces one line still needs work
###   #t10(){
###   #du -ks $1|sort -n -r|head -n 10
###   #}
###   
###   
###   #found but not yet tested
###   #
###   #################
###   ### FUNCTIONS ###
###   #################
###   #
###   #function ff { find . -name $@ -print; }
###   #
###   
###   #function osr { shutdown -r now; }
###   #function osh { shutdown -h now; }
###   
###   #function mfloppy { mount /dev/fd0 /mnt/floppy; }
###   #function umfloppy { umount /mnt/floppy; }
###   
###   #function mdvd { mount -t iso9660 -o ro /dev/dvd /mnt/dvd; }
###   #function umdvd { umount /mnt/dvd; }
###   
###   #function mcdrom { mount -t iso9660 -o ro /dev/cdrom /mnt/cdrom; }
###   #function umcdrom { umount /mnt/cdrom; }
###   
###   #function psa { ps aux $@; }
###   #function psu { ps ux $@; }
###   
###   #function dub { du -sclb $@; }
###   #function duk { du -sclk $@; }
###   #function dum { du -sclm $@; }
###   
###   #function dfk { df -PTak $@; }
###   #function dfm { df -PTam $@; }
###   
###   #function dfi { df -PTai $@; }
###   
###   #copy and go to dir
###   #cpg (){
###   # if [ -d "$2" ];then
###   # cp $1 $2 && cd $2
###   # else
###   # cp $1 $2
###   # fi
###   #}
###   
###   #move and go to dir
###   #mvg (){
###   # if [ -d "$2" ];then
###   # mv $1 $2 && cd $2
###   # else
###   # mv $1 $2
###   # fi


# Below have been superseded by 'trans' (Translate-Shell), but leaving them here as good techniques for web crawling
# webget() { lynx -dump "http://www.google.com/search?hl=en&q=define%3A+${1}&btnG=Google+Search" | sed -n '/^   '"${2:-noun}"'$/,${p;/^$/q}'; }   # https://ubuntuforums.org/showthread.php?t=679762&page=2
# webdef() { if [ -z $2 ]; then header=40; else header=$2; fi; lynx -dump "http://www.google.com/search?hl=en&q=define%3A+${1}&btnG=Google+Search" | grep -v "\[1\] Google" | grep -v "define: ${1}__" | grep -v "ALL.*IMAGES" | head -n ${header}; }  # https://ubuntuforums.org/showthread.php?t=679762&page=2
# websyn() { if [ -z $2 ]; then header=40; else header=$2; fi; lynx -dump "http://www.google.com/search?hl=en&q=synonym%3A+${1}&btnG=Google+Search" | grep -v "\[1\] Google" | grep -v "define: ${1}__" | grep -v "ALL.*IMAGES" | head -n ${header}; }   # https://ubuntuforums.org/showthread.php?t=679762&page=2
# webdefapi() { lynx -dump "https://api.dictionaryapi.dev/api/v2/entries/en/${1}" | jq '.[] | .meanings[] | select(.partOfSpeech=="noun") | .definitions | .[].definition'; }

# If in WSL, bypass need for git in Linux and use Git for Windows for all projects (this is almost definitely redundant since I now use git tokens natively on WSL)
    # [ -f '/mnt/c/Program Files/Git/bin/git.exe' ] && alias git="'/mnt/c/Program Files/Git/bin/git.exe'"
    # winalias() { [ -f $2 ] && alias $1="$2" }   # Possible general function for winaliases, $1 is name of alias, $ is the escaped path to target file



####################
#
# Randomly select from array 
# 
# 
# # Following syntax is correct, but VS Code thinks it is wrong due to the complex braces https://stackoverflow.com/questions/28544522/function-to-get-a-random-element-of-an-array-bash
# # randArrayElement(){ arr=("${!1}"); echo ${arr["$[RANDOM % ${#arr[@]}]"]}; }   # Select a random item from an array
# 
# # Following is my attempt to select randomly, then reduce the size of the array, then keep doing that until array is empty
# files=(/usr/share/cowsay/*.cow)
# for file in "${files[@]}"; do echo "$file"; done   # This just shows the items in order
# 
# files_length=${#files[@]}   # Length of the array 
# for (( i=0; i<$files_length; ++i)); do
#     index=$[RANDOM % ${#files[@]}]   # Select a random index
#     item=${files["$index"]}
#     files=("${files[@]/$item}");     # Delete the item from the array (leaving a blank space at that index)
#     new_files=()                 # temp array to help with resizing
#     for j in "${!files[@]}"; do
#         new_item=${files["$j"]}
#         [[ $new_item != $item ]] && new_files+=($new_item)
#     done
#     echo "New Length = ${#new_files[@]}"
#     files=("${new_files[@]}")
#     echo "$i $index $item"
# done
# 
# for file in "${files[@]}"; do
#     echo "$file"
# done
# cx() { arr=("${!1}"); index=$[RANDOM % ${#arr[@]}]; item=${arr["$index"]}; echo $item; }
# 
# cx() {
#     randArrayItem() { arr=("${!1}"); index=$[RANDOM % ${#arr[@]}]; item=${arr["$index"]}; echo $item; }
#     echo "$(randArrayItem "files[@]")"
#     files=("${arr[@]/$item}"); 
# }

# files=(/usr/share/cowsay/*.cow)
# files_length=${#files[@]}   # Length of the array
# 
# for (( i=0; i<$files_length; ++i)); do
#     while found
#     index=$(( ( RANDOM % $files_length )  + 1 ))
#     if [[ ! " ${array[*]} " =~ " ${value} " ]]; then
#     
# 
# 
# for (( i=0; i<$files_length; ++i)); do
#     index=$[RANDOM % ${#files[@]}]   # Select a random index
#     item=${files["$index"]}
#     files=("${files[@]/$item}");     # Delete the item from the array (leaving a blank space at that index)
#     new_files=()                 # temp array to help with resizing
#     for j in "${!files[@]}"; do
#         new_item=${files["$j"]}
#         [[ $new_item != $item ]] && new_files+=($new_item)
#     done
#     echo "New Length = ${#new_files[@]}"
#     files=("${new_files[@]}")
#     echo "$i $index $item"
# done
# 
# d1=(/usr/share/cowsay/*.cow)
# d2=(/usr/share/ponysay/ponies/*.pony)
# files=("${d1[@]}" "${d2[@]}")
# 
# while IFS= read -d $'\0' -r file; do
#     echo "$file"
# done < <(printf '%s\0' "${files[@]}" | shuf -z)


# http://fungi.yuggoth.org/weather/  weather utility console ... but using lynx could be better if can find a way



##### Nice / simple prompt
#export black="\[\033[0;38;5;0m\]"
#export red="\[\033[0;38;5;1m\]"
#export orange="\[\033[0;38;5;130m\]"
#export green="\[\033[0;38;5;2m\]"
#export yellow="\[\033[0;38;5;3m\]"
#export blue="\[\033[0;38;5;4m\]"
#export bblue="\[\033[0;38;5;12m\]"
#export magenta="\[\033[0;38;5;55m\]"
#export cyan="\[\033[0;38;5;6m\]"
#export white="\[\033[0;38;5;7m\]"
#export coldblue="\[\033[0;38;5;33m\]"
#export smoothblue="\[\033[0;38;5;111m\]"
#export iceblue="\[\033[0;38;5;45m\]"
#export turqoise="\[\033[0;38;5;50m\]"
#export smoothgreen="\[\033[0;38;5;42m\]"
#export defaultcolor="\[\e[m\]"
#PS1="$bblue\[┌─\]($orange\$newPWD$bblue)\[─\${fill}─\]($orange\u@\h \$(date \"+%a, %d %b %y\")$bblue)\[─┐\]\n$bblue\[└─\](\$newRET)(\#)($orange\$(date \"+%H:%M\")$bblue)->$defaultcolor "

### ##### Secure-delete substitution
### 
### alias srm='sudo srm -f -s -z -v'
### alias srm-m='sudo srm -f -m -z -v'
### alias smem-secure='sudo sdmem -v'
### alias smem-f='sudo sdmem -f -l -l -v'
### alias smem='sudo sdmem -l -l -v'
### alias sfill-f='sudo sfill -f -l -l -v -z'
### alias sfill='sudo sfill -l -l -v -z'
### alias sfill-usedspace='sudo sfill -i -l -l -v'
### alias sfill-freespace='sudo sfill -I -l -l -v'
### alias sswap='sudo sswap -f -l -l -v -z'
### alias sswap-sda5='sudo sswap -f -l -l -v -z /dev/sda5'
### alias swapoff='sudo swapoff /dev/sda5'
### alias swapon='sudo swapon /dev/sda5'
### 
### 
### 
### ##### Shred substitution
### 
### alias shred-sda='sudo shred -v -z -n 0 /dev/sda'
### alias shred-sdb='sudo shred -v -z -n 0 /dev/sdb'
### alias shred-sdc='sudo shred -v -z -n 0 /dev/sdc'
### alias shred-sdd='sudo shred -v -z -n 0 /dev/sdd'
### alias shred-sde='sudo shred -v -z -n 0 /dev/sde'
### alias shred-sdf='sudo shred -v -z -n 0 /dev/sdf'
### alias shred-sdg='sudo shred -v -z -n 0 /dev/sdg'
### alias shred-sda-r='sudo shred -v -z -n 1 /dev/sda'
### alias shred-sdb-r='sudo shred -v -z -n 1 /dev/sdb'
### alias shred-sdc-r='sudo shred -v -z -n 1 /dev/sdc'
### alias shred-sdd-r='sudo shred -v -z -n 1 /dev/sdd'
### alias shred-sde-r='sudo shred -v -z -n 1 /dev/sde'
### alias shred-sdf-r='sudo shred -v -z -n 1 /dev/sdf'
### alias shred-sdg-r='sudo shred -v -z -n 1 /dev/sdg'
### 
### 
### 
### ##### DD substitution
### 
### alias backup-sda='sudo dd if=/dev/hda of=/dev/sda bs=64k conv=notrunc,noerror' # to backup the existing drive to a USB drive
### alias restore-sda='sudo dd if=/dev/sda of=/dev/hda bs=64k conv=notrunc,noerror' # to restore from the USB drive to the existing drive
### alias partitioncopy='sudo dd if=/dev/sda1 of=/dev/sda2 bs=4096 conv=notrunc,noerror' # to duplicate one hard disk partition to another hard disk partition
### alias cdiso='sudo dd if=/dev/hda of=cd.iso bs=2048 conv=sync,notrunc' # to make an iso image of a CD
### alias diskcopy='sudo dd if=/dev/dvd of=/dev/cdrecorder'
### alias cdcopy='sudo dd if=/dev/cdrom of=cd.iso' # for cdrom
### alias scsicopy='sudo dd if=/dev/scd0 of=cd.iso' # if cdrom is scsi
### alias dvdcopy='sudo dd if=/dev/dvd of=dvd.iso' # for dvd
### alias floppycopy='sudo dd if=/dev/fd0 of=floppy.image' # to duplicate a floppy disk to hard drive image file
### alias dd-sda='sudo dd if=/dev/zero of=/dev/sda conv=notrunc' # to wipe hard drive with zero
### alias dd-sdb='sudo dd if=/dev/zero of=/dev/sdb conv=notrunc' # to wipe hard drive with zero
### alias dd-sdc='sudo dd if=/dev/zero of=/dev/sdc conv=notrunc' # to wipe hard drive with zero
### alias dd-sdd='sudo dd if=/dev/zero of=/dev/sdd conv=notrunc' # to wipe hard drive with zero
### alias dd-sde='sudo dd if=/dev/zero of=/dev/sde conv=notrunc' # to wipe hard drive with zero
### alias dd-sdf='sudo dd if=/dev/zero of=/dev/sdf conv=notrunc' # to wipe hard drive with zero
### alias dd-sdg='sudo dd if=/dev/zero of=/dev/sdg conv=notrunc' # to wipe hard drive with zero
### alias dd-sda-r='sudo dd if=/dev/urandom of=/dev/sda bs=102400' # to wipe hard drive with random data option (1)
### alias dd-sdb-r='sudo dd if=/dev/urandom of=/dev/sdb bs=102400' # to wipe hard drive with random data option (1)
### alias dd-sdc-r='sudo dd if=/dev/urandom of=/dev/sdc bs=102400' # to wipe hard drive with random data option (1)
### alias dd-sdd-r='sudo dd if=/dev/urandom of=/dev/sdd bs=102400' # to wipe hard drive with random data option (1)
### alias dd-sde-r='sudo dd if=/dev/urandom of=/dev/sde bs=102400' # to wipe hard drive with random data option (1)
### alias dd-sdf-r='sudo dd if=/dev/urandom of=/dev/sdf bs=102400' # to wipe hard drive with random data option (1)
### alias dd-sdg-r='sudo dd if=/dev/urandom of=/dev/sdg bs=102400' # to wipe hard drive with random data option (1)
### alias dd-sda-full='sudo dd if=/dev/urandom of=/dev/sda bs=8b conv=notrunc,noerror' # to wipe hard drive with random data option (2)
### alias dd-sdb-full='sudo dd if=/dev/urandom of=/dev/sdb bs=8b conv=notrunc,noerror' # to wipe hard drive with random data option (2)
### alias dd-sdc-full='sudo dd if=/dev/urandom of=/dev/sdc bs=8b conv=notrunc,noerror' # to wipe hard drive with random data option (2)
### alias dd-sdd-full='sudo dd if=/dev/urandom of=/dev/sdd bs=8b conv=notrunc,noerror' # to wipe hard drive with random data option (2)
### alias dd-sde-full='sudo dd if=/dev/urandom of=/dev/sde bs=8b conv=notrunc,noerror' # to wipe hard drive with random data option (2)
### alias dd-sdf-full='sudo dd if=/dev/urandom of=/dev/sdf bs=8b conv=notrunc,noerror' # to wipe hard drive with random data option (2)
### alias dd-sdg-full='sudo dd if=/dev/urandom of=/dev/sdg bs=8b conv=notrunc,noerror' # to wipe hard drive with random data option (2)



# function mediainfo() {    # ii id3v2 mp3gain metaflac
#     EXT=`echo "${1##*.}" | sed 's/\(.*\)/\L\1/'`
#     if [ "$EXT" == "mp3" ]; then
#         id3v2 -l "$1"
#         echo
#         mp3gain -s c "$1"
#     elif [ "$EXT" == "flac" ]; then
#         metaflac --list --block-type=STREAMINFO,VORBIS_COMMENT "$1"
#     else
#         echo "ERROR: Not a supported file type."
#     fi
# }
# 
# # Convert videos to AVI files
# function conv2avi() {
# 	# copyright 2007 - 2010 Christopher Bratusek
# 	if [[ $(which mencoder-mt) != "" ]]; then
# 	mencoder-mt "$1" -lavdopts threads=8 \
# 	  -ovc xvid -xvidencopts fixed_quant=4 -of avi \
# 	  -oac mp3lame -lameopts vbr=3 \
# 	  -o "$1".avi
# 	else
# 	mencoder "$1" -lavdopts \
# 	  -ovc xvid -xvidencopts fixed_quant=4 -of avi \
# 	  -oac mp3lame -lameopts vbr=3 \
# 	  -o "$1".avi
# 	fi
# }

### # Optimize PNG files
### function pngoptim()
### {
###        NAME_="pngoptim"
###        HTML_="optimize png files"
###     PURPOSE_="reduce the size of a PNG file if possible"
###    SYNOPSIS_="$NAME_ [-hl] <file> [file...]"
###    REQUIRES_="standard GNU commands, pngcrush"
###     VERSION_="1.0"
###        DATE_="2004-06-29; last update: 2004-12-30"
###      AUTHOR_="Dawid Michalczyk <dm@eonworks.com>"
###         URL_="www.comp.eonworks.com"
###    CATEGORY_="gfx"
###    PLATFORM_="Linux"
###       SHELL_="bash"
###  DISTRIBUTE_="yes"
### # This program is distributed under the terms of the GNU General Public License
### usage() {
### echo >&2 "$NAME_ $VERSION_ - $PURPOSE_
### Usage: $SYNOPSIS_
### Requires: $REQUIRES_
### Options:
###      -h, usage and options (this help)
###      -l, see this script"
### exit 1
### }
### # tmp file set up
### tmp_1=/tmp/tmp.${RANDOM}$$
### # signal trapping and tmp file removal
### trap 'rm -f $tmp_1 >/dev/null 2>&1' 0
### trap "exit 1" 1 2 3 15
### # var init
### old_total=0
### new_total=0
### # arg handling and main execution
### case "$1" in
###     -h) usage ;;
###     -l) more $0; exit 1 ;;
###      *.*) # main execution
###         # check if required command is in $PATH variable
###         which pngcrush &> /dev/null
###         [[ $? != 0 ]] && { echo >&2 required \"pngcrush\" command is not in your PATH; exit 1; }
###         for a in "$@";do
###             if [ -f $a ] && [[ ${a##*.} == [pP][nN][gG] ]]; then
###                 old_size=$(ls -l $a | { read b c d e f g; echo $f ;} )
###                 echo -n "${NAME_}: $a $old_size -> "
###                 pngcrush -q $a $tmp_1
###                 rm -f -- $a
###                 mv -- $tmp_1 $a
###                 new_size=$(ls -l $a | { read b c d e f g; echo $f ;} )
###                 echo $new_size bytes
###                 (( old_total += old_size ))
###                 (( new_total += new_size ))
###             else
###                 echo ${NAME_}: file $a either does not exist or is not a png file
###             fi
###         done ;;
###     *) echo ${NAME_}: skipping $1 ; continue ;;
### esac
### percentage=$(echo "scale = 2; ($new_total*100)/$old_total" | bc)
### reduction=$(echo $(( old_total - new_total )) \
### | sed '{ s/$/@/; : loop; s/\(...\)@/@.\1/; t loop; s/@//; s/^\.//; }')
### echo "${NAME_}: total size reduction: $reduction bytes (total size reduced to ${percentage}%)"
### }

### Online Bash Debugger (useful to put a function snippet in and check outside of main script)
### https://www.onlinegdb.com/online_bash_shell

# alias shutdown='cmd.exe /c "wsl.exe -t $WSL_DISTRO_NAME"'
# alias reboot='cd /mnt/c/ && cmd.exe /c start "Rebooting WSL ..." cmd /c "timeout 5 && title "$WSL_DISTRO_NAME" && wsl.exe -d $WSL_DISTRO_NAME" && wsl.exe --terminate $WSL_DISTRO_NAME'

# PS1="\[\033[1;34m\](\[\033[1;37m\]\w\[\033[1;34m\]) \[\033[1;32m\]*\[\033[1;0m\] "                        # (/tmp/.custom) *
# PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '   # boss@Asus:/tmp/.custom$

# remindme() { sleep $1 && zenity --info --text "$2"; }

# download-custom-tools() { curl -s https://raw.githubusercontent.com/roysubs/custom_bash/master/custom_loader.sh | bash; }   # Download latest custom_loader, commented out, just use 'git clone https://github.com/roysubs/custom_bash ~/custom_bash'

# .screenrc
# GNU Screen is a very handy tool I should have learned earlier about. It lets you have persistent shell sessions, so you can log out on one computer and reconnect to the still running session from an other computer. Recommended if you're "commandlining" a lot in an networked environment. Anyway, here is my .screenrc to have a handy caption bar, listing the available windows.
# 
# # Set the default window name to empty string instead of the arbitrary "bash"
# shelltitle ''
# 
# # Set the window caption.
# # I use caption instead of hardstatus, so it is available per split window too
# # (hardstatus is only per complete screen).
# caption always "%{= KW}%-Lw%{= wb}%n %t %{= KW}%+Lw %-=| ${USER}@%H | %M%d %c%{-}"
# # Some decryption hints:
# # %{= KW}     background light black (aka dark gray) with foreground light white
# # %{= wb}     background dark white (ake light gray) with foreground dark blue
# # %-Lw        all windows before the current window.
# # %n%f %t     current window number, flags and title.
# # %+Lw        all windows after the current window.
# # %-=         pad remaining spaces.
# # %H          hostname.
# # %M%d %s     month and day (MmmDD) and current time (HH:MM).


# packtool iftop iptstate net-tools lsof nmap
# packtool xterm gnome-terminal terminator terminology cool-retro-term rxvt-unicode tilda
# stacer (gui system monitoring), timeshift (gui / terminal sync backup tool), deja du?
# wyrd (console calendar with notifications), remind

# sudo add-apt-repository ppa:gnome-terminator
# sudo apt-get update
# snap install alacritty --classic

# Mouse pointer is tiny in Linux GUI apps. Tried following but it does not work
# gsettings get org.gnome.desktop.interface cursor-size
# 24 is the default cursor size, can use 32, 48, 64, 96
# gsettings set org.gnome.desktop.interface cursor-size [sizeInPixels]

##### ucaresystem-core
# sudo add-apt-repository ppa:utappia/stable
# sudo apt-get update
# sudo apt-get install ucaresystem-core
# wget https://launchpad.net/~utappia/+archive/ubuntu/stable/+files/ucaresystem-core_4.0+xenial_all.deb
# sudo dpkg -i ucaresystem-core_4.0+xenial_all.deb
# sudo apt-get install -f
# sudo ucaresystem-core

##### TopGrade
##### Upgrade Atom packages, Update Flatpak packages on Linux, Update snap packages on Linux, Run fwupdmgr to show firmware upgrade.
##### Upgrade Emacs packages, Run Cargo install-update, Run.brew update && brew upgrade. This should handle both Homebrew and Linuxbrew on Unix,
##### Run zplug update on Unix, Unix: Run fisherman update, Upgrade tmux plugins with TPM, Upgrade Vim/Neovim packages.
### Don't use this => git clone https://aur.archlinux.org/yay.git
### Don't use this => cd yay
### Don't use this => makepkg -si
# wget https://github.com/r-darwish/topgrade/releases/tag/v7.1.0/topgrade-v7.1.0-x86_64-unknown-linux-musl.tar.gz
# tar xvf topgrade-v7.1.0-x86_64-unknown-linux-musl.tar.gz

# export ver="v0.9.0"
# wget https://github.com/r-darwish/topgrade/releases/download/${ver}/topgrade-${ver}-x86_64-unknown-linux-gnu.tar.gz
# tar xvf topgrade-${ver}x86_64-unknown-linux-gnu.tar.gz
# sudo mv topgrade /usr/local/bin/
# which topgrade
# topgrade --help

# Running topgrade in a tmux session
# It is recommended to leave topgrade running in tmux session to avoid accidental human interruption or network timeouts, especially when working on a remote system. For this use:

# $ topgrade -t
# If you don't have tmux installed, you can get it using your OS package manager:
# 
# On Ubuntu:
# 
# $ sudo apt-get install tmux
# On CentOS / Fedora:
# 
# $ sudo yum install tmux
# $ sudo dnf install tmux
# On Arch Linux, use:
# 
# $ sudo pacman -S tmux
# Customizing topgrade
# You can place a configuration file at ~/.config/topgrade.toml. Here's an example:
# 
# git_repos = [
#     "~/dev/topgrade",
# ]
# 
# [pre_commands]
# "Emacs Snapshot" = "rm -rf ~/.emacs.d/elpa.bak && cp -rl ~/.emacs.d/elpa ~/.emacs.d/elpa.bak"
# 
# [commands]
# "Python Environment" = "~/dev/.env/bin/pip install -i https://pypi.python.org/simple -U --upgrade-strategy eager jupyter"
# In this example:
# 
# git_repos - A list of custom Git repositories to pull
# pre_commands - Commands to execute before starting any action
# commands - Custom upgrade steps.
# Read also
# 
# How to Exclude Specific Packages from Yum Update
# How to Upgrade Individual Packages in Ubuntu/CentOS
# How to Install Packages on Arch Linux
# Topgrade seems to be a must-have Sysadmin tool for managing updates across a cluster of servers you administer daily. The fact that you can have it run in a tmux session by just using -t flag, keeps updates safer by ensuring they finish gracefully. Give it a try and let us know how you liking it through our comment section.

# uCareSystem Core : A Basic Maintenance Tool For Ubuntu
# Written by Sk Published: April 26, 2016Last Updated on October 20, 2018 4744 Views
# 0 comment0 
# There are numerous tools out there for Ubuntu operating system's maintenance and administration. Today, let me introduce a new tool called "uCareSystem Core", a basic maintenance tool for Ubuntu. This tool is very simple all-in one, system update and maintenance tool that can be used to perform some basic system maintenance tasks. It will automatically refresh your packagelist, download and install updates (if there are any), remove any old kernels, obsolete packages and configuration files to free up disk space, without any need of user interference.
# 
# Recommended Download - Free EBook: "Ubuntu Documentation: Ubuntu Server Guide 2014"
# Here is the list of processes that uCareSystem Core will do for you:
# 
# Updates all available packages.
# Updates your Ubuntu system.
# upgrade Ubuntu to the next release
# Downloads and install updates.
# Checks for the list of old Linux Kernels and uninstalls them. Do not worry, though, as it keeps the current and one previous version and deletes all the previous one.
# Clears the cache folder (the retrieved packages).
# Uninstall packages that are obsolete and no longer needed.
# Uninstall orphaned packages.
# Deletes package settings that you have previously uninstalled.
# All of above tasks will be performed automatically without any user intervention.
# 
# Install uCareSystem Core
# We can install uCareSystem Core either using PPA or DEB file.
# 
# 1. Install uCareSystem Core using PPA
# I tested this PPA on Ubuntu 16.04, however It might work on older Ubuntu versions, and Ubuntu derivatives such as Linux Mint.
# 
# uCareSystem Core developer have created a PPA to make the installation much easier for beginners.
# 
# To add the PPA, run:
# 
# $ sudo add-apt-repository ppa:utappia/stable
# Update the sources list using command:
# 
# $ sudo apt-get update
# Finally, install uCareSystem core using the following command:
# 
# $ sudo apt-get install ucaresystem-core
# 2. Install uCareSystem Core using DEB file
# Download uCareSystem deb file fro your Ubuntu version from this link.
# 
# 
# 
# Download the required version that suits your Ubuntu version. Here, I am downloading it for Ubuntu 16.04 LTS.
# 
# $ wget https://launchpad.net/~utappia/+archive/ubuntu/stable/+files/ucaresystem-core_4.0+xenial_all.deb
# After downloading the .deb file install it as follows.
# 
# $ sudo dpkg -i ucaresystem-core_4.0+xenial_all.deb
# $ sudo apt-get install -f
# Please note that this app will not update automatically if you install it from .deb file. If you want regular updates, always use PPA.
# 
# Usage
# uCareSystem Core usage is simple and straight forward.
# 
# Open Terminal, and run the following command to start uCareSystem Core:
# 
# $ sudo ucaresystem-core
# Once it is completed, you will see a message like below.
# 
# 
# 
# That's it. Now, there is no obsolete packages, old kernels, old configuration files. Your Ubuntu system is now clean and up-to-date.
# 
# Upgrade Ubuntu
# From ucaresystem Core v4.0, the developer has added an option to upgrade Ubuntu to the next release. So now you can upgrade your previous Ubuntu version to next available version easily.
# 
# The new version (4.0) comes with two additional parameters:
# 
# -u : This parameter will allow you upgrade to the next Ubuntu stable release. You can use it to upgrade both LTS to LTS or non-LTS to next available version.
# -d : It will allow you to upgrade to next development version.
# You can run the following command to see the list of available parameters.
# 
# $ sudo ucaresystem-core -h
# 
# 
# If you want to upgrade your Ubuntu to next available stable version, for example 17.04 to 17.10, simply run:
# 
# $ sudo ucaresystem-core -u
# Remember you can also use the same command to upgrade any LTS version to next available LTS version. It will perform all basic maintenance tasks first. And then, it will ask whether you want to upgrade Ubuntu to next available version. If there are no new versions, it will only perform the maintenance tasks and nothing else.
# 
# If you want to upgrade your Ubuntu to development version, run it with -d parameter:
# 
# $ sudo ucaresystem-core -d
# First, it will perform all maintenance tasks. And, then it check if the development cycle of the next version of Ubuntu is open and will prompt you if you want to continue the upgrade.
# 
# Hope it helps. If you find this tutorial useful, please share it on your social, professional networks and support us. More good stuffs to come. Stay tuned.
# 
# Cheers!
# 
# Source and Reference link:
# 
# 
# 
# 
# 
# Create A .deb File From Source In Ubuntu 16.04
# Written by Sk Published: April 25, 2016Last Updated on April 25, 2017 3,019 Views
# 2 comments0 
# Ubuntu has thousands of .deb files in the official and unofficial repositories. But, all packages will not be available in DEB format. Some times, packages might be available only for RPM based distros, or Arch based distros. In such cases, it's important to know how to create a .deb file from source file. In this brief tutorial, let us see how to create a .deb file from Source file in Ubuntu 16.04 LTS. This guide should work on all DEB based systems such as Debian, Linux Mint, and Elementary OS etc.
# 
# Create a .deb file from Source in Ubuntu
# First, we need to install the required dependencies to compile and create DEB file from source file.
# 
# To do so, run:
# 
# sudo apt-get install checkinstall build-essential automake autoconf libtool pkg-config libcurl4-openssl-dev intltool libxml2-dev libgtk2.0-dev libnotify-dev libglib2.0-dev libevent-dev
# We have installed the required dependencies. Let us go ahead and download the source file of a package.
# 
# Downloading source tarballs
# For the purpose of this tutorial, let us create .deb file for Leafpad source file. As you know already, Leafpad is the simple, graphical text editor.
# 
# Go to the Leafpad home page and download the tar file.
# 
# wget http://tarot.freeshell.org/leafpad/leafpad-0.8.17le2.tar.bz2
# Then, extract the downloaded tar file as shown below.
# 
# tar xvjf leafpad-0.8.17le2.tar.bz2
# Then, go to the extracted folder, and run the following commands one by one to compile the source code:
# 
# cd leafpad-0.8.17le2/
# ./configure
# Note: In case ./configure command is not found, skip it and continue with next command.
# 
# make
# Finally, run the following commands to create .deb file from source code.
# 
# sudo checkinstall
# Sample output:
# 
# Type Y when asked to create the description for the Deb file.
# 
#  checkinstall 1.6.2, Copyright 2009 Felipe Eduardo Sanchez Diaz Duran
#  This software is released under the GNU GPL.
#  The package documentation directory ./doc-pak does not exist.
#  Should I create a default set of package docs? [y]: y
# 
# 
# Next, type the description for the DEB file, and press ENTER double time to continue.
# 
#  Preparing package documentation...OK
# 
#  Please write a description for the package.
#  End your description with an empty line or EOF.
#  >> This Leafpad DEB file has been created from source code
#  >> EOF
# 
# 
# In the next screen, you will see the details of source file that you are going to create a DEB file from it. The DEB package will be built according to these details.
# 
# Review the details, and change them as your wish.
# 
#  *****************************************
#  **** Debian package creation selected ***
#  *****************************************
# 
# This package will be built according to these values:
# 
#  0 - Maintainer: [ root@ostechnix ]
#  1 - Summary: [ This Leafpad DEB file has been created from source code ]
#  2 - Name: [ leafpad ]
#  3 - Version: [ 0.8.17 ]
#  4 - Release: [ 1 ]
#  5 - License: [ GPL ]
#  6 - Group: [ checkinstall ]
#  7 - Architecture: [ amd64 ]
#  8 - Source location: [ leafpad-0.8.17 ]
#  9 - Alternate source location: [ ]
#  10 - Requires: [ ]
#  11 - Provides: [ leafpad ]
#  12 - Conflicts: [ ]
#  13 - Replaces: [ ]
# 
# 
# For example, I want to change the maintainer Email id. To do so, press number "0". Type the maintainer email, and press ENTER key.
# 
# 
# 
#  Enter a number to change any of them or press ENTER to continue: 0
#  Enter the maintainer's name and e-mail address:
#  >> sk@ostechnix.com
# Finally, press Enter if you ok with details.
# 
# The .deb Package has been built successfully, and installed automatically.
# 
# **********************************************************************
# 
# Done. The new package has been installed and saved to 
# /home/ostechnix/leafpad-0.8.17/leafpad_0.8.17-1_amd64.deb
# 
# You can remove it from your system anytime using:
# 
# dpkg -r leafpad
# 
# **********************************************************************
# 
# 
# The .deb will be saved in the directory where you extracted the source file.
# 
# Let us view the contents of the source directory:
# 
# ls
# Sample output:
# 
# ABOUT-NLS config.sub intltool-extract missing
# aclocal.m4 configure intltool-extract.in mkinstalldirs
# AUTHORS configure.ac intltool-merge NEWS
# ChangeLog COPYING intltool-merge.in po
# compile data intltool-update README
# config.guess depcomp intltool-update.in src
# config.h description-pak leafpad_0.8.17-1_amd64.deb stamp-h1
# config.h.in doc-pak Makefile
# config.log INSTALL Makefile.am
# config.status install-sh Makefile.in
# ostechnix@ostechnix:~/leafpad-0.8.17$
# As you can see in the above output, the deb file has been successfully created and saved in the source directory itself.
# 
# You can also remove the installed deb package as shown below.
# 
# sudo dpkg -r leafpad
# I have tested these guide with Leafpad and 7zip source files. It worked like a charm as I described above.
# 
# That's all for now. You know now how to create .deb file from its source file. I will be soon here with another interesting article. Until then, stay tuned with OSTechNix.
# 
# If you find this article useful, please share it on your social networks and support us.











###   
###   # Initially try to grab everything (quicker), then test the packages, note the gaps in the below to do with the different repositories
###   [[ "$manager" = "apt" ]] && sudo apt install python3.9 python3-pip dpkg git vim nnn curl wget perl dfc cron     ncdu tree dos2unix mount neofetch byobu zip unzip # mc pydf
###   [[ "$manager" = "dnf" ]] && sudo dnf install python39  python3-pip      git vim     curl wget perl     crontabs      tree dos2unix                      zip unzip # mc pydf dpkg nnn dfc ncdu mount neofetch byobu 
###   
###   [[ "$manager" = "apt" ]] && check_and_install apt apt-file  # find which package includes a specific file, or to list all files included in a package on remote repositories.
###   check_and_install dpkg dpkg     # dpkg='Debian package', the low level package management from Debian ('apt' is a higher level tool)
###   check_and_install git git
###   check_and_install vim vim
###   check_and_install curl curl
###   check_and_install wget wget
###   check_and_install perl perl
###   [[ "$manager" = "apt" ]] && check_and_install python3.9 python3.9
###   [[ "$manager" = "dnf" ]] && check_and_install python3.9 python39
###   # if [ "$manager" = "dnf" ]; then sudo yum groupinstall python3-devel         # Will default to installingPython 3.6
###   # if [ "$manager" = "dnf" ]; then sudo yum groupinstall python39-devel        # Will force Python 3.9
###   # if [ "$manager" = "dnf" ]; then sudo yum groupinstall 'Development Tools'   # Total download size: 172 M, Installed size: 516 M
###   check_and_install pip3 python3-pip   # https://pip.pypa.io/en/stable/user_guide/
###   # check_and_install pip2 python2     # Do not install (just for reference): python2 is the package to get pip2
###   [[ "$manager" = "apt" ]] && check_and_install dfc dfc     # For CentOS below, search for "dfc rpm" then pick the x86_64 version
###   # if [ "$manager" = "dnf" ]; then if ! type dfc &> /dev/null; then wget -P /tmp/ https://raw.githubusercontent.com/rpmsphere/x86_64/master/d/dfc-3.0.4-4.1.x86_64.rpm
###   #         RPM=/tmp/dfc-3.0.4-4.1.x86_64.rpm; type $RPM &> /dev/null && rpm -i $RPM; rm $RPM &> /dev/null
###   #     fi
###   # fi
###   [[ "$manager" = "apt" ]] && check_and_install pydf pydf   # For CentOS below, search for "pydf rpm" then pick the x86_64 version
###   if [[ "$manager" = "dnf" ]]; then if ! type pydf &> /dev/null; then wget -nc --tries=3 -T20 --restrict-file-names=nocontrol -P /tmp/ https://download-ib01.fedoraproject.org/pub/fedora/linux/development/rawhide/Everything/x86_64/os/Packages/p/pydf-12-11.fc35.noarch.rpm
###           RPM=/tmp/pydf-12-11.fc35.noarch.rpm; type $RPM &> /dev/null && rpm -i $RPM; rm $RPM &> /dev/null
###       fi
###   fi
###   # [[ "$manager" = "apt" ]] && check_and_install crontab cron     # Package is called 'cron' for apt, but is installed by default on Ubuntu
###   [[ "$manager" = "dnf" ]] && check_and_install crontab crontabs   # cron is not installed by default on CentOS
###   [[ "$manager" = "apt" ]] && check_and_install ncdu ncdu
###   check_and_install tree tree
###   check_and_install dos2unix dos2unix
###   check_and_install mount mount
###   [[ "$manager" = "apt" ]] && check_and_install neofetch neofetch  # screenfetch   # Same as neofetch, but not available on CentOS, so just use neofetch
###   [[ "$manager" = "apt" ]] && check_and_install inxi inxi          # System information, currently a broken package on CentOS
###   # check_and_install macchina macchina    # System information
###   check_and_install byobu byobu        # Also installs 'tmux' as a dependency (requires EPEL library on CentOS)
###   check_and_install zip zip
###   check_and_install unzip unzip
###   [[ "$manager" = "apt" ]] && check_and_install lr lr   # lr (list recursively), all files under current location, also: tree . -fail / tree . -dfail
###   # check_and_install bat bat      # 'cat' clone with syntax highlighting and git integration, but downloads old version, so install manually
###   check_and_install ifconfig net-tools   # Package name is different from the 'ifconfig' tool that is wanted
###   [[ "$manager" = "apt" ]] && check_and_install 7za p7zip-full  # Package name is different from the '7za' tool that is wanted, Ubuntu also creates '7z' as well as '7za'
###   [[ "$manager" = "dnf" ]] && check_and_install 7za p7zip       # Package name is different from the '7za' tool that is wanted
###   # which ifconfig &> /dev/null && printf "\np7zip-full is already installed" || exe sudo $manager install net-tools -y
###   # which 7z &> /dev/null && printf "\np7zip-full is already installed" || exe sudo $manager install p7zip-full -y
###   check_and_install fortune fortune-mod    # Note that the Ubuntu apt says "selecting fortune-mod instead of fortune" if you try 'apt install fortune'
###   check_and_install cowsay cowsay
###   check_and_install figlet figlet
###   # Note that Ubuntu 20.04 could not see this in apt repo until after full update, but built-in snap can see it:
###   # which figlet &> /dev/null || exe sudo snap install figlet -y





# #!/bin/bash
# # https://stephenreescarter.net/automatic-backups-for-wsl2/
# LOGFILE=/home/valorin/winhome/backup/${WSL_DISTRO_NAME}.log
# 
# if [ ! -e /home/valorin/winhome/ ]; then
#     echo "ERROR: ~/winhome/ is broken, cannot backup ${WSL_DISTRO_NAME}" | tee -a $LOGFILE
#     exit
# fi
# 
# {
#     echo "=====>"
#     echo "=====> Starting ${WSL_DISTRO_NAME} Backup"
#     echo "=====> "`date '+%F %T'`
#     echo "=====>"
# 
#     if [ -d /etc/mysql ]; then
#         echo
#         echo "==> Backing up MySQL Databases <=="
#         echo
#         sudo service mysql status | grep -q stopped
#         RUNNING=$?
#         if [ $RUNNING == "0" ]; then
#             sudo service mysql start
#             echo
#         fi
# 
#         DATABASES=`sudo mysql --execute="SHOW DATABASES" | awk '{print $1}' | grep -vP "^Database|performance_schema|mysql|information_schema|sys$" | tr \\\r\\\n ,\ `
#         for DATABASE in $DATABASES; do
#             if [ -f /home/valorin/db/mysql-$DATABASE.sql ]; then
#                 rm /home/valorin/db/mysql-$DATABASE.sql
#             fi
#             if [ -f /home/valorin/db/mysql-$DATABASE.sql.gz ]; then
#                 rm /home/valorin/db/mysql-$DATABASE.sql.gz
#             fi
#             echo " * ${DATABASE}";
#             sudo mysqldump --opt --single-transaction $DATABASE > /home/valorin/db/mysql-$DATABASE.sql
#         done
# 
#         if [ $RUNNING == "0" ]; then
#             echo
#             sudo service mysql stop
#         fi
# 
#         chown valorin:valorin -R /home/valorin/db
#         gzip /home/valorin/db/*.sql
#     fi
# 
#     echo
#     echo "==> Syncing files <=="
#     echo
# 
#     mkdir -p /home/valorin/winhome/backup/${WSL_DISTRO_NAME}/
#     time rsync --archive --verbose --delete /home/valorin/ /home/valorin/winhome/backup/${WSL_DISTRO_NAME}/
# 
#     echo
#     echo "=====> "`date '+%F %T'` FINISHED ${WSL_DISTRO_NAME}
#     echo
# 
# } 2>&1 | tee ${LOGFILE}



# WSL2 Network Issues and Win 10 Fast Start-Up
# Post date
# July 1, 2020
# 6 Commentson WSL2 Network Issues and Win 10 Fast Start-Up
# 
# I recently encountered a network issue where my WSL2 (Windows Subsystem for Linux) distro was unable to retrieve DNS and connect to the internet without me changing /etc/resolv.conf. Likewise, Windows was unable to connect to the WSL2 ports via localhost.
# 
# To quickly workaround these issues, I set my nameserver to be 1.1.1.1 in /etc/resolv.conf and updated my hosts file in Windows to reflect the WSL2 IP. While this fixed the issue quickly, I had to change both files each time I opened WSL2… which sucked.
# 
# After a few hours of frustration and searching, I worked out what was breaking my WSL2: Fast Startup in Windows! Since I know I’ll forget this before it happens again, I thought it’d be best to document the fix here, so I can easily find it again. Hopefully it’ll help you fix your WSL2 network issues too!
# 
# WSL2 Network Issues
# I first noticed the issue when trying to work on my local dev web server. I opened the browser and saw this:
# 
# Network issue cannot reach WSL2: ERR_CONNECTION_REFUSED
# Cannot reach page error: ERR_CONNECTION_REFUSED
# I fixed this my editing the Windows hosts file, however when trying to pull code changs down via git, I encountered this worrying error:
# 
# 
# ssh: Could not resolve hostname github.com: Temporary failure in name resolution
# Again, I could work around this, but the fix was temporary.
# 
# Disabling Fast Startup
# I eventually stumbled upon some advice to disable Fast Startup in Windows. It sounded familiar and I thought I had already disabled it before, but I figured I should check anyway. As it turns out, something had reenabled Fast Startup and it was the cause of the WSL2 network issues issues I was experiencing.
# 
# The option to disable it is buried under a few screens. Let’s walk through the process.
# 
# First, open up settings and go into the System settings:
# 
# 
# Open the System settings in the control panel.
# Next, go into the Power & Sleep section and click Additional power settings under the Related Settings heading. Note, this option may be at the bottom of the screen, if your window isn’t wide enough to display it on the right.
# 
# 
# Power & Sleep > Additional Power Settings
# Next, select the Choose what the power buttons do option on the left of the Power Options screen.
# 
# 
# Choose what the power buttons do
# Finally, we’ve found the option! We just need to jump through the final hoop to stop it being greyed out and allow us to disable Fast Startup.
# 
# Select Change settings that are currently unavailable near the top. This will allow you to untick the Turn on fast start-up option under Shut-down settings.
# 
# Disable fast start-up to fix WSL2 network issues
# Disable Turn on fast start-up option.
# Once you’ve disabled the option, close all the open windows and reboot your computer. WSL2 should start working with the network again!
# 
# Summary
# This is a rather frustrating issue that can be a pain to debug and identify, but is fairly easy to fix when you know what you’re looking for. I hope you find this article helpful.
# 
# If you know of other resources that are helpful for debugging WSL2 network issues, please drop them below in the comments!


# alfn() {
#     echo -e "\nAliases / Functions with '$1' in either\ntheir name or contents. Use 'def <name>'\ntoview alias or function contents.\n"
#     alias | grep $1 | while read -r line; do
#         delimiter="='"
#         s=$line$delimiter
#         array=();
#         while [[ -n $s ]]; do
#             array+=("${s%%"$delimiter"*}")
#             s=${s#*"$delimiter"} 
#         done
#         echo ${array[0]} | awk '{print $2}'
#     done
#     declare -f | grep '()' | grep -v '^_' | grep -v 'lp_' | grep $1
# }
# 
# daf() {   # Just match on alias / function names
#     if [ -z "$1" ]; then echo "Requires a string argument to search for in aliases/functions."; return; fi
#     alias | sed 's/=/ /g' | awk '{print $2}' | grep $1                # Alias names containing the match string
#     declare -f | grep '()' | grep -v '^_' | grep -v 'lp_' | grep $1   # Function names containing the match string
# }
# 
# dafx() {   # Match also on contents of aliases / functions 
#     if [ -z "$1" ]; then echo "Requires a string argument to search for in aliases/functions."; return; fi
#     alias | sed 's/^alias / /g' | grep $1                # Alias full definition names containing the match string
#     for i in `declare -f`; do
#         | grep '()' | grep -v '^_' | grep -v 'lp_' | grep $1   # 
# }
# 
# 
# alfn() {   # $1 for this function a grep so supports regular expressions
#     if [ -z "$1" ]; then echo "Requires a string argument to search for in aliases/functions."; return; fi
#     alias | sed 's/=/ /g' | awk '{print $2}' | grep $1                # Alias names containing the match string
#     declare -f | grep '()' | grep -v '^_' | grep -v 'lp_' | grep $1   # 
# }

### Aborted attempt to automate locale changing
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


### Don't really need this anymore
#    https://raw.githubusercontent.com/roysubs/custom_bash/master/custom_loader.sh  =>  https://git.io/Jt0fZ  (using git.io)
#
# Can download custom_loader.sh before running with:
#    curl -L https://git.io/Jt0fZ > ~/custom_loader.sh
# To run unattended (all read -e -p will be ignored, script will run in full):
#    curl -L https://git.io/Jt0fZ | bash
# To run attended (prompts like read -e -p will be respected):
#    curl -L https://git.io/Jt0fZ > custom_loader.sh ; bash custom_loader.sh


### From another profile
# alias dn='OPTIONS=$(\ls -F | grep /$); select s in $OPTIONS; do cd $PWD/$s; break;done'
# alias help='OPTIONS=$(\ls ~/.tips -F);select s in $OPTIONS; do less ~/.tips/$s; break;done'


# Abbreviated syntax as an alternative. ai => sudo 'a'pt 'i'nstall, ys => 'y'um search, etc
# Be very careful to avoid standard commands like 'du' (would have been 'dnf update' so cannot use this)
# ai, ar, as, ah, aptup  |  di, dr, ds, dh, dnfup  |  yi, yr, ys, yh, yumup  |  i(install), r(emove), s(search), h(istory), aptuu, dnfuu => update + upgrade + dist-update
# dpi, dpr, dps, dph (dpkg),  sni, snr, sns snh (snap),  fli, flr, fls, flh (flatpak),  api, apr, aps, aph (appimage)
# ainfo, dinfo, yinfo, ashow, dshow, yshow (package details)  |  afiles, dfiles, yfiles (files in package)
# ToDo: Generic functions. pki(install), pkr(remove), pkh(history), pks(search), find OS (/etc/issue), that will use the default tool for that OS
#    or a function patch() to patch correctly per OS. 'update' + 'upgrade' + 'remove obsolete packages' + 'autoremove', + 'dist-upgrade' etc
#    or a function 'pk' with arguments i, r, h, s, gi(groupinstall), gl(grouplist), etc uses default tool depending on OS it is on (or specify with another variable d, y, a, z, d, s, f, ai)
# alias ax='apt show $1 2>/dev/null | egrep --color=never -i "Origin:|Download-Size:|Installed-Size:|Description:|^  *"'
# if type apt >/dev/null 2>&1; then alias ai='sudo apt install'; alias ar='sudo apt remove'; alias as='apt search'; alias ah='apt history'; alias ashow='apt show'; alias ainfo='apt show'; alias afiles='apt-file list'; alias al='sudo apt list --upgradable'; alias aptuu='sudo apt list --upgradable && sudo apt update && sudo apt upgrade'; fi   # apt
# if type yum >/dev/null 2>&1; then alias yi='sudo yum install'; alias yr='sudo yum remove'; alias ys='yum search'; alias yh='yum history'; alias yinfo='yum info'; alias yshow='yum info'; alias yfiles='repoquery --list'; alias yumuu='sudo yum update && sudo yum upgrade'; fi   # yum   # could just assign dng here?
# if type dnf >/dev/null 2>&1; then alias di='sudo dnf install'; alias dr='sudo dnf remove'; alias ds='dnf search'; alias dh='dnf history'; alias dinfo='dnf info'; alias dshow='dnf info'; alias dfiles='repoquery --list'; alias dnfuu='sudo dnf update && sudo dnf upgrade'; fi   # dnf
# if type apk >/dev/null 2>&1; then alias apa='apk add'; alias api='aa'; alias apd='apk del'; alias apr='ad'; alias aps='apk info'; alias apl='apk list'; alias apkuu='sudo apt update && sudo apt upgrade'; fi   # apt
# if type zypper >/dev/null 2>&1; then alias zi='sudo zypper install';  alias zr='sudo zypper remove';  alias zs='zypper search';  alias zh='zypper history'; fi  # SLES
# if type dpkg >/dev/null 2>&1; then alias dpi='sudo dpkg install'; alias dpr='sudo dpkg remove'; alias dps='dpkg search'; alias dph='dpkg history'; fi   # dpkg
# if type snap >/dev/null 2>&1; then alias sni='sudo snap install'; alias snr='sudo snap remove'; alias sns='snap search'; alias snh='snap history'; fi   # snap
# if type flatpak >/dev/null 2>&1; then alias fli='sudo flatpak install';  alias flr='sudo flatpak remove';  alias fls='flatpak search';  alias flh='flatpak history'; fi  # flatpak
# if type appimage >/dev/null 2>&1; then alias appi='sudo appimage install'; alias appr='sudo appimage remove'; alias apps='appimage search'; alias apph='appimage history'; fi   # appimage


# Default LS_COLORS (on Ubuntu)
# Original di is 01;34 then is overwritten by 0;94 later
# rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36::di=0;94
