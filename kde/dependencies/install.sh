#!/bin/bash
#
# Installs the required dependencies for themes
# to work
#

function _yaml {
    curr_dir="$(pwd)"
    target_dir="/opt/kwin_yaml"
    sudo mkdir -p "$target_dir"
    cd "$target_dir"

    # Install required dependencies
    sudo apt-get install -y cmake extra-cmake-modules kwin-dev libdbus-1-dev \
        libkf5config-dev libkf5configwidgets-dev libkf5coreaddons-dev \
        libkf5windowsystem-dev qtbase5-dev

    # Clone and install Kwin YAML
    sudo git clone https://github.com/zzag/kwin-effects-yet-another-magic-lamp.git .
    sudo mkdir build && cd build
    sudo cmake .. \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr
    sudo make
    sudo make install
}

_yaml
