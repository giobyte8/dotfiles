#!/bin/bash
#
# Setups a debian based system such as:
# * Ubuntu (And flavour)
# * Elementary
# 

# Current path
# ref: https://stackoverflow.com/a/4774063/3211029
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
BKP_DIR="${HERE}/backup"
BKP_CNF_DIR="${BKP_DIR}/config"

# Ensures existence of config backup directory
function verify_cnf_bkp_dir {
    echo "Verifying backup directory"

    if [ ! -d "${BKP_CNF_DIR}" ]; then
        mkdir -p "${BKP_CNF_DIR}"

        # Abort if directory can not be created
        if [ ! -d "${BKP_CNF_DIR}" ]; then
            echo ""
            echo " ERR: Backup dir can not be created"
            exit 1
        fi
    fi
}

# Install apps I always use on deb systems
function install_and_setup_apps {
    sudo apt-get update
    sudo apt-get upgrade -y

    echo ""
    echo "Installing basic programs"
    sudo apt-get install -y \
        build-essential \
        openssh-server \

    setup_ssh
}

function setup_ssh {
    echo ""
    echo "Setting up ssh programs"

    UFW_STATUS="$(systemctl is-active ufw)"
    if [ "${UFW_STATUS}" == "active" ]; then
        echo " Allowing ssh in ufw"
        sudo ufw allow ssh
    else
        echo " WARN: ufw not found, firewall setup for ssh may be required"
    fi
}


# Execute:
verify_cnf_bkp_dir
install_and_setup_apps
