#!/bin/bash

# Lists all extensions found in given path
#  Current path is used by default
function ll-ext {
    TGT="$PWD"

    if [ $# -gt "0" ]; then
        TGT=$1
    fi

    find "$TGT" -maxdepth 1 -type f -name '*.*' | sed 's|.*\.||' | sort -u
}

# Lists all extensions found in given path and
# count the number of files per extension
#  Current path is used by default
function ls-ext {
    TGT="$PWD"

    if [ $# -gt "0" ]; then
        TGT=$1
    fi

    find "$TGT" -maxdepth 1 -type f -name '*.*' | \
        sed 's/[^\.]*//' | \
        sed 's/.*\.//'   | \
        sort             | \
        uniq -c
}

# Lists all extensions found in given path and subdirectories
# in recursive mode along with a count of number of files per
# extension.
# Current path is used by default
function ls-extr {
    TGT="$PWD"

    if [ $# -gt "0" ]; then
        TGT=$1
    fi

    find "${TGT}" -type f -name '*.*' | \
        sed 's/[^\.]*//' | \
        sed 's/.*\.//'   | \
        sort             | \
        uniq -c
}
