#!/bin/bash
#
# Symlink the config files to current user's '~/.config/'
# folder and backups original files into '../backups/config/*'
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
            ln -s "$(pwd)/$file" $target
        fi
    done
}

#
# Setup fonts
function setup_fonts {
    echo "Setting up fonts for your system UIs"
    kwriteconfig5 --file kdeglobals --group General --key font "Ubuntu,12,-1,5,50,0,0,0,0,0,Regular"
    kwriteconfig5 --file kdeglobals --group General --key fixed "Hack [simp],11,-1,5,50,0,0,0,0,0,Regular"
    kwriteconfig5 --file kdeglobals --group General --key smallestReadableFont "Roboto,11,-1,5,50,0,0,0,0,0,Regular"
    kwriteconfig5 --file kdeglobals --group General --key toolBarFont "Ubuntu,12,-1,5,50,0,0,0,0,0,Regular"
    kwriteconfig5 --file kdeglobals --group General --key menuFont "Ubuntu,12,-1,5,50,0,0,0,0,0,Regular"
    kwriteconfig5 --file kdeglobals --group WM --key activeFont "Ubuntu,12,-1,5,50,0,0,0,0,0,Regular"
}

# backup_current_config
setup_fonts
