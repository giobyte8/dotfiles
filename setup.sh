#!/bin/bash
#
# Setups the next items:
# .bashrc
# .vimrc
#

function ensure_backup_dir {
    if [ ! -d "./backups/config" ]; then
        mkdir -p ./backups/config
    fi
}

function setup_bashrc {
    target_bash="$HOME/.bashrc"
    
    # Backup before setup symlink
    if [ -f "$target_bash" ]; then
        echo "Backing up orginal .bashrc"

        ensure_backup_dir
        backup="./backups/bashrc"
        cp $target_bash $backup
        rm $target
    fi

    echo "Symlinking .bashrc to: $target_bash"
    ln -s "$(pwd)/bashrc" $target_bash
    source $target_bash
}

setup_bashrc
