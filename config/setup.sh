#!/bin/bash
#
# Symlink the files to current user's '~/.config/' folder and
# backups original files into '../backups/config/*'
#
# @author Giovanni Aguirre
# @since January 12, 2019
#

#
# Backup files from current config
function backup_current_config {
    if [ ! -d "../backups/config" ]; then
        mkdir -p ../backups/config
    fi

    for file in *; do
        if [ ! $file = "README.md" ] && [ ! $file = "setup.sh" ]; then 
            
            # Check if file exists on active config
            target="$HOME/.config/$file"
            backup="../backups/config/$file"
            if [ -f "$target" ]; then
                backup="../backups/config/$file"
                cp $target $backup
                rm $target
            fi
      
            echo "Symlinking: $file"
            ln -s "./$file" $target
        fi
    done
}

backup_current_config

