#!/bin/bash
#
# Installs the apps I use regardless of the
# distro (Ubuntu based) or DE
#

#
# Adds all ppas through this function to avoid
# multiple apt-get update
function _ppas {

}

function _utils {
    printf "\nInstalling common utils"

    sudo apt-get install -y net-tools openssh-server
}

function _chrome {
    printf "\nInstalling google chrome"

    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i ./google-chrome*.deb
    sudo apt-get install -f
}

function _spotify {
    printf "\nInstalling spotify client"

    # 1. Add the Spotify repository signing keys to be able to verify downloaded packages
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90

    # 2. Add the Spotify repository
    echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

    # 3. Update list of available packages
    sudo apt-get update

    # 4. Install Spotify
    sudo apt-get install -y spotify-client
}

function _gimp {
    sudo add-apt-repository ppa:otto-kesselgulasch/gimp -y
    sudo apt update
    sudo apt install -y gimp

    # Uninstall by using:
    #sudo apt install ppa-purge
    #sudo ppa-purge ppa:otto-kesselgulasch/gimp
    #sudo apt remove gimp # ?? Not sure on this
}

function _inkscape {
    sudo add-apt-repository ppa:inkscape.dev/stable -y
    sudo apt-get update
    sudo apt-get install -y inkscape
}

function _typecatcher {
    sudo add-apt-repository ppa:andrewsomething/typecatcher -y
    sudo apt-get update
    sudo apt-get install -y typecatcher
}

#function _dropbox {
#}

#function _franz {
#}

function _qBittorrent {
    sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y
    sudo apt-get update
    sudo apt-get install -y qbittorrent
}

function _vlc {
    sudo add-apt-repository ppa:videolan/stable-daily -y
    sudo apt-get update
    sudo apt-get install -y vlc
}

function _audacity {
    sudo apt-get install -y audacity
}

#function _virtualbox {
#}

function _gparted {
    sudo apt-get install -y gparted
}

function _gravit {
    sudo snap install gravit-designer
}

#_utils
#_chrome
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

