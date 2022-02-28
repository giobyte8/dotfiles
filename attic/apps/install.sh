#!/bin/bash
#
# Installs the apps I use regardless of the
# distro (Ubuntu based) or DE
#

#
# Adds all ppas through this function to avoid
# multiple apt-get update
function _ppas {
    printf "\nSetting up PPAs\n"

    sudo add-apt-repository ppa:otto-kesselgulasch/gimp -y
    sudo add-apt-repository ppa:inkscape.dev/stable -y
    sudo add-apt-repository ppa:andrewsomething/typecatcher -y
    sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y
    sudo add-apt-repository ppa:videolan/stable-daily -y

    #
    # Setup spotify PPA

    # 1. Add the Spotify repository signing keys to be able to verify downloaded packages
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
    
    # 2. Add the Spotify repository
    echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

    #
    # Setup Google chrome PPA

    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

    sudo apt-get update
    clear
}

function _utils {
    printf "\nInstalling common utils\n"
    sudo apt-get install -y net-tools openssh-server
    clear
}

function _chrome {
    printf "\nInstalling google chrome\n"
    sudo apt-get install -y google-chrome-stable
    clear
}

function _spotify {
    printf "\nInstalling spotify client\n"
    sudo apt-get install -y spotify-client
    clear
}

function _gimp {
    printf "\nInstalling Gimp\n"
    sudo apt install -y gimp
    clear

    # Uninstall by using:
    #sudo apt install ppa-purge
    #sudo ppa-purge ppa:otto-kesselgulasch/gimp
    #sudo apt remove gimp # ?? Not sure on this
}

function _inkscape {
    printf "\nInstalling Inkscape\n"
    sudo apt-get install -y inkscape
    clear
}

function _typecatcher {
    printf "\nInstalling Typecatcher\n"
    sudo apt-get install -y typecatcher
    clear
}

#function _dropbox {
#}

#function _franz {
#}

function _qBittorrent {
    printf "\nInstalling qBittorrent\n"
    sudo apt-get install -y qbittorrent
    clear
}

function _vlc {
    printf "\nInstalling VLC\n"
    sudo apt-get install -y vlc
    clear
}

function _audacity {
    printf "\nInstalling Audacity\n"
    sudo apt-get install -y audacity
    clear
}

#function _virtualbox {
#}

function _gparted {
    printf "\nInstalling GParted\n"
    sudo apt-get install -y gparted
    clear
}

function _gravit {
    printf "\nInstalling Gravit Designer\n"
    sudo snap install gravit-designer
    clear
}

_ppas
_utils
_chrome
_spotify
_gimp
_inkscape
_typecatcher
#_dropbox
#_franz
_qBittorrent
_vlc
_audacity
#_virtualbox
_gparted
_gravit
