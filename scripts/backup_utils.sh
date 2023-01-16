#!/bin/bash

function bkp-photos {
    if [ ! $# -eq 2 ]; then
        echo "ERR: Wrong number of arguments"
        echo " Usage: bkp-photos <source/> <dest>"
        return 1
    fi

    SRC=$1
    DST=$2

    echo "Backing up photo files through rsync:"
    echo " From: $SRC"
    echo "   To: $DST"
    echo

    # Params overview:
    #   -h, --human-readable        output numbers in a human-readable format
    #   -r, --recursive             recurse into directories
    #   -u, --update                skip files that are newer on the receiver
    #   -z, --compress              compress file data during the transfer
    #
    #       --progress              show progress during transfer
    #
    # Sync files by extension
    # In order to sync files with specific extensions only, we exclude
    # everything with --exclude and use --include to specify dirs and
    # the file extensions.
    #
    # Included extensions
    #   .gpr  GoPro raw extension
    #   .xmp  Extensible Metadata Platform (Sidecar file)
    #   .dng  Samsung Galaxy S20 raw extension

    rsync -hruz --progress    \
        --include '*/'        \
        --include '*.jpg'     \
        --include '*.JPG'     \
        --include '*.jpeg'    \
        --include '*.JPEG'    \
        --include '*.gpr'     \
        --include '*.GPR'     \
        --include '*.raw'     \
        --include '*.xmp'     \
        --include '*.dng'     \
        --exclude '*'         \
        $SRC                  \
        $DST
}

function bkp-videos {
    if [ ! $# -eq 2 ]; then
        echo "ERR: Wrong number of arguments"
        echo " Usage: bkp-videos <source/> <dest>"
        return 1
    fi

    SRC=$1
    DST=$2

    echo "Backing up video files through rsync:"
    echo " From: $SRC"
    echo "   To: $DST"
    echo

    # Params overview:
    #   -h, --human-readable        output numbers in a human-readable format
    #   -r, --recursive             recurse into directories
    #   -u, --update                skip files that are newer on the receiver
    #   -z, --compress              compress file data during the transfer
    #
    #       --progress              show progress during transfer
    #
    # Sync files by extension
    # In order to sync files with specific extensions only, we exclude
    # everything with --exclude and use --include to specify dirs and
    # the file extensions.

    rsync -hruz --progress    \
        --include '*/'        \
        --include '*.mp4'     \
        --include '*.MP4'     \
        --exclude '*'         \
        $SRC                  \
        $DST
}

function bkp {
    if [ ! $# -eq 2 ]; then
        echo "ERR: Wrong number of arguments"
        echo " Usage: bkp <source/> <destination>"
        return 1
    fi

    SRC=$1
    DST=$2

    echo "Backing up files through rsync:"
    echo " From: $SRC"
    echo "   To: $DST"

    # Params overview:
    #   -h, --human-readable        output numbers in a human-readable format
    #   -r, --recursive             recurse into directories
    #   -u, --update                skip files that are newer on the receiver
    #   -z, --compress              compress file data during the transfer
    #
    #       --progress              show progress during transfer
    #

    rsync -hruz --progress    \
        $SRC                  \
        $DST
}
