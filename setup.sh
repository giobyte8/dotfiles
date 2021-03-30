#!/bin/bash
#
# Setups the next items:
# .bashrc
# .vimrc
# DEPRECATED
# TODO: Automate bash setup, symlinking file is not
#       enough since every system may already have
#       some custom settings

function check_dependencies {
    printf "\nVerifying dependencies\n"

    sudo apt-get update
    sudo apt-get upgrade -y
    sudo apt-get install -y git vim
}

function ensure_backup_dir {
    if [ ! -d "./backups/config" ]; then
        mkdir -p ./backups/config
    fi
}

function setup_bashrc {
    printf "\nSetting up bashrc\n"

    target_bash="$HOME/.bashrc"
    
    # Backup before setup symlink
    if [ -f "$target_bash" ]; then
        echo "Backing up orginal .bashrc"

        ensure_backup_dir
        backup="./backups/bashrc"
        cp $target_bash $backup
        rm $target_bash
    fi

    echo "Symlinking .bashrc"
    ln -s "$(pwd)/bashrc" $target_bash
    source $target_bash
}

function setup_vimrc {
    printf "\nSetting up vimrc and Vundle\n"

    target_vim="$HOME/.vimrc"

    # Install Vundle
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

    # Backup before setup symlink
    if [ -f "$target_vim" ]; then
        echo "Backing up original .vimrc"

        ensure_backup_dir
        backup="./backups/vimrc"
        cp $target_vim $backup
        rm $target_vim
    fi

    echo "Symlinking .vimrc"
    ln -s "$(pwd)/vimrc" $target_vim

    # Install all vim plugins
    vim +PluginInstall +qall
}

check_dependencies
setup_bashrc
setup_vimrc
