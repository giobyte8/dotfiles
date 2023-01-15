#!/bin/bash

# Lists all extensions found in given path
#  Current path is used by default
function ll-ext {
    TGT="$PWD"

    if [ $# -gt "0" ]; then
        TGT=$1
    fi

    find "$TGT" -type f -maxdepth 1 -name '*.*' | sed 's|.*\.||' | sort -u
}

# Lists all extensions found in given path and
# count the number of files with each extensions
#  Current path is used by default
function ll-ext-count {
    TGT="$PWD"

    if [ $# -gt "0" ]; then
        TGT=$1
    fi

    find "$TGT" -type f -maxdepth 1 -name '*.*' | \
        sed 's/[^\.]*//' | \
        sed 's/.*\.//'   | \
        sort             | \
        uniq -c
}
