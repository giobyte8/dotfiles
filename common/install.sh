#!/bin/bash
# Installs common setup for all *nix systems


# ref: https://stackoverflow.com/a/4774063/3211029
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
DOTF_ROOT="${HERE}/.."
BKP_DIR="${DOTF_ROOT}/backup"
BKP_CNF_DIR="${BKP_DIR}/config"


## The exit status of the last command run is 
## saved automatically in the special variable $?.
## So, if last command exit status is different
## than 0, abort execution
function check_for_errors {
    if [[ $? > 0 ]]
    then
        echo
        >&2 echo "Aborting installation"
        exit
    fi
}


## Ensures existence of config backup directory
function verify_cnf_bkp_dir {
    echo
    echo " Verifying backup directory"

    if [ ! -d "${BKP_CNF_DIR}" ]; then
        mkdir -p "${BKP_CNF_DIR}"

        # Abort if directory could not be created
        if [ ! -d "${BKP_CNF_DIR}" ]; then
            echo ""
            echo " ERR: Backup dir couldn't be created"
            return 1
        fi
    fi
}

## Makes sure all necessary programs are installed
function verify_dependencies {
    if command -v apt-get &> /dev/null
    then
        sudo apt-get update
        check_for_errors

        sudo apt-get upgrade -y
        check_for_errors
    else
        echo
        echo " apt-get command not found on this system"
        echo "  skipping update"
    fi

    ## Verify vim
    if ! command -v vim &> /dev/null
    then

        # Check if apt-get is available to install vim
        if ! command -v apt-get &> /dev/null
        then
            echo
            echo " ERR: vim and apt-get were not found on this system"

            return 1
        fi

        echo
        echo " Installing vim"
        sudo apt-get install -y vim
        check_for_errors
    fi

    ## Verify git
    if ! command -v git &> /dev/null
    then
        
        # Check if apt-get is available to install git
        if ! command -v apt-get &> /dev/null
        then
            echo
            echo " ERR: git and apt-get were not found on this system"

            return 1
        fi

        echo
        echo " Installing git"
        sudo apt-get install -y git
        check_for_errors
    fi
}


## Install and Setup vim
function setup_vim {
    echo
    echo "Setting up vim and Vundle"

    verify_dependencies
    check_for_errors

    VIMRC_PATH="${HOME}/.vimrc"

    # TODO Verify VIMRC and BKP_CNF_DIR write permissions

    # Check for preivous symlink existence
    if [ -L "${VIMRC_PATH}" ]; then
        echo " WARN: ${VIMRC_PATH} is already a symlink"
        echo "       $(readlink -f ${VIMRC_PATH})"
    fi

    # Backup before symlinking
    if [ -f "${VIMRC_PATH}" ]; then
        echo " Backing up original .vimrc"

        verify_cnf_bkp_dir
        check_for_errors

        vimrc_backup="${BKP_CNF_DIR}/vimrc"
        cp $VIMRC_PATH $vimrc_backup
        rm $VIMRC_PATH
    fi

    echo " Symlinking .vimrc"
    ln -s "${DOTF_ROOT}/config/vimrc" "${VIMRC_PATH}"

    # Install Vundle
    echo
    echo " Installing Vundle"
    git clone \
        https://github.com/VundleVim/Vundle.vim.git \
        ~/.vim/bundle/Vundle.vim

    # Install all vim plugins
    echo
    echo " Installing plugins"
    vim +PluginInstall +qall
}

setup_vim
## TODO Add source to 'sourceme.sh' file in .bashrc or .zshrc files