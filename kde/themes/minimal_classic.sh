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

function _konsole {
    _restore_or_backup konsolerc

    
}

_konsole
