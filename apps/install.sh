#!/bin/bash
#
# Installs the apps I use regardless of the
# distro (Ubuntu based) or DE
#

function _chrome {
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i ./google-chrome*.deb
    sudo apt-get install -f
}

_chrome
