#!/bin/bash

function backup {
    if [ ! $# -eq 2 ]; then
        echo "ERR: Wrong number of arguments"
        echo " Usage: backup <source/directory/path> <destination/dir/path>"
        return 1
    fi

    SRC=$1
    DST=$2

    if [ ! -d "$SRC" ]; then
        echo "ERR: Invalid source directory ${SRC}"
        return 1
    fi

    if [[ ! $SRC == */ ]]; then
        SRC="${SRC}/"
    fi

    echo "Backing up files through rsync:"
    echo " From: $SRC"
    echo "   To: $DST"

    rsync --progress -zrh     \
        --ignore-existing     \
        --exclude '*.THM'     \
        --exclude '*.LRV'     \
        --exclude '.trashed*' \
        $SRC                  \
        $DST
}
