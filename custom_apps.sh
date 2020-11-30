####################
#
# Check and install larger packages
#
####################

copyq
clipboardfusion
gufw


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
Alt+F2 and type: gksu gedit /etc/nsswitch.conf

Look for this line:

hosts:  files mdns4_minimal [NOTFOUND=return] dns mdns4

Add wins so it looks like this:

hosts:  files mdns4_minimal [NOTFOUND=return] wins dns mdns4

Install the "winbind" package: sudo apt-get install winbind
https://forums.linuxmint.com/viewtopic.php?t=332108
https://forums.linuxmint.com/viewtopic.php?t=322404 Samba and Mint20




# Remember the "alternativeto" site when trying to find apps
# Trawled some lists to find these:
# https://www.omgubuntu.co.uk/2016/12/21-must-have-apps-ubuntu


# exe() { printf "\n\n"; echo "\$ ${@/eval/}"; read -p "Any key to continue..."; "$@"; }
exe() { printf "\n\n"; echo "\$ ${@/eval/}"; "$@"; }

# Apt
exe which chromium &> /dev/null || sudo apt install chromium -y  # Chromium, alternatively Chrome or Brave
exe which gimp &> /dev/null || sudo apt install gimp -y          # GIMP Image Editor
exe which kdenlive &> /dev/null || sudo apt install kdenlive -y  # Kdenlive Video Editor
exe which vlc &> /dev/null || sudo apt install vlc -y            # VLC Video Player
exe which celluloid &> /dev/null || sudo apt install celluloid -y   # Celluloid Video Player
exe which calibre &> /dev/null || sudo apt install calibre -y    # Calibre eBook management tool
exe which zathura &> /dev/null || sudo apt install zathura -y    # Zathur Document Reader, PDF, ePub, Mobi, etc
exe which caffeine &> /dev/null || sudo apt install caffeine -y  # Caffeine Keep-Alive Tool
exe which etcher &> /dev/null || sudo apt install etcher -y      # Etcher ISO Image Writer (like Rufus)
exe which timeshift &> /dev/null || sudo apt install timeshift -y   # TimeShift Backup / Snapshots with rsync / btrfs
exe which syncthing &> /dev/null || sudo apt install syncthing -y   # Syncthing, sync across network
exe which baobab &> /dev/null || sudo apt install baobab -y      # baobab, Disk Usage Analyzer
exe which steam &> /dev/null || sudo apt install steam -y        # Steam
exe which playonlinux &> /dev/null || sudo apt get playonlinux   # WINE implementation for Windows games https://www.playonlinux.com/en
exe which retroarch &> /dev/null || sudo apt get retroarch       # Simple frontend for the libretro library
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

####################
#
# Ganes
#
####################
# RetroArch
# RetroArch is a graphical frontend for emulators, game engines, and media players. Created by libretro
# What systems does it play?
# - Arcade (emulator: Final Burn Alpha / iMAME4All / MAME)
# - Atari 2600 (emulator: Stella)
# - Atari Lynx (emulator: Handy)
# - Nintendo Entertainment System... More Info »

# Lutris
# Lutris is an open source gaming platform for GNU/Linux. It allows you to gather and manage (install, configure and launch) all your games acquired from any source, in a...

# PlayOnLinux
# PlayOnLinux (PlayOnMac at http://www.playonmac.com ) is a tool to help Linux (and Mac) users run games and programs for Windows on Linux (or Mac, FreeBSD), via the use...
# Free Open Source Mac Linux BSD Wine FreeBSD
# Run Windows software Ad-free Games Add a feature

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
# 52
# GameHub
# 
# Games library manager. Supports: Steam, GOG, Humble Bundle, Humble Trove, Wine and RetroArch .
# 
# Free Open Source Linux AppImageHub Flatpak
# Flatpak Gameboy emulation Import from GoG Import from Steam ...
# 
# GameHub icon
# 18
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