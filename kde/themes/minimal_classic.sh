#!/bin/bash
# 
# Setups a minimalistic and classic style for environment
# check screenshot for details
#
# Dependencies:
# - Kwin script: YAML -> 
#

CONFIG_PATH="$HOME/.config"
BACKUPS_PATH="../../backups/config"

function _dependencies {
    printf "\nValidating dependencies\n"
}

function _backup_config_file {
    if [ ! -d "$BACKUPS_PATH" ]; then
        mkdir -p "$BACKUPS_PATH"
    fi

    origin="$CONFIG_PATH/$1"
    target="$BACKUPS_PATH/$1"
    if [ -f "$origin" ]; then
        echo "Backing up $origin to $target"
        cp $origin $target
    else
        echo "$1 file not found in $CONFIG_PATH"
    fi
}

function _restore_config_file {
    origin="$BACKUPS_PATH/$1"
    target="$CONFIG_PATH/$1"

    if [ -f "$origin" ]; then
        echo "Restoring $origin to $target"
        cp "$origin" "$target"
    else
        echo "$1 file not found on $BACKUPS_PATH"
    fi
}

#
# If file exists in backups dir, restore it to config dir,
# otherwise, if file exists in config dir, backup it to
# backups dir
function _restore_or_backup {
    if [ -f "$BACKUPS_PATH/$1" ]; then
        _restore_or_backup $1
    else
        if [ -f "$CONFIG_PATH/$1" ]; then
            _backup_config_file $1
        fi
    fi
}

function _konsolerc {
    #_restore_or_backup konsolerc

    kwriteconfig5 --file konsolerc --group "DownloadDialog Settings" --key "Height 1080" 684
    kwriteconfig5 --file konsolerc --group "DownloadDialog Settings" --key "Width 1920" 936

    kwriteconfig5 --file konsolerc --group KonsoleWindow --key AllowMenuAccelerators true
    kwriteconfig5 --file konsolerc --group KonsoleWindow --key ShowAppNameOnTitleBar false
    kwriteconfig5 --file konsolerc --group KonsoleWindow --key ShowMenuBarByDefault false

    kwriteconfig5 --file konsolerc --group MainWindow --key "Height 1080" 898
    kwriteconfig5 --file konsolerc --group MainWindow --key "Width 1920" 958
    kwriteconfig5 --file konsolerc --group MainWindow --key MenuBar Disabled
    kwriteconfig5 --file konsolerc --group MainWindow --key ToolBarsMovable Disabled

    kwriteconfig5 --file konsolerc --group TabBar --key ShowQuickButtons true
    kwriteconfig5 --file konsolerc --group TabBar --key TabBarPosition Top
    kwriteconfig5 --file konsolerc --group TabBar --key TabBarVisibility ShowTabBarWhenNeeded
}

function _konsole_profile {
    scheme="./local/share/konsole/MonaLisa.colorscheme"
    profile"./local/share/konsole/MinimalClassic.profile"

    cp "$scheme" "$HOME/.local/share/konsole/"
    cp "$profile" "$HOME/.local/share/konsole/"

    kwriteconfig5 --file konsolerc --group "Desktop Entry" --key DefaultProfile MinimalClassic.profile
    kwriteconfig5 --file konsolerc --group "Favorite Profiles" --key MinimalClassic.profile
}

function _konsole {
    _konsolerc
    _konsole_profile
}

_konsole
