#!/bin/bash
#
# This script install all the tools I use for normal
# development workflow
#

function basic_tools {
    sudo apt-get install -y \
        curl \
        zip \
        unzip \
        build-essential \
        git \
        vim
}

function node_js {
    echo "Installing node and npm"
    curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
    sudo apt-get install -y nodejs

    sudo npm install -g http-server
}

function sdk_man_and_related {
    echo ""
    echo "Installing sdk man, java, kotlin, maven and gradle"

    curl -s "https://get.sdkman.io" | bash
    source "$HOME/.sdkman/bin/sdkman-init.sh"

    sdk install java
    sdk install kotlin
    sdk install maven
    sdk install gradle
}

function docker {
    echo ""
    echo "Installing docker"

    # Clean up prev versions and setup dependencies
    sudo apt-get remove docker docker-engine docker.io containerd runc
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        software-properties-common

    # Add repository
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"

    # install
    sudo apt-get update
    sudo apt-get install -y docker-ce
    sudo usermod -aG docker $USER
}

function python {
    sudo apt-get install -y python3-pip
    pip3 install virtualenv
}

# basic_tools
python
# node_js
# sdk_man_and_related
# docker
