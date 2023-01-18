#!/bin/bash

function size-compare {
    if [ ! $# -eq 2 ]; then
        echo "ERR: Wrong number of arguments"
        echo " Usage: size-compare <source/> <dest/>"
        return 1
    fi

    SRC=$1
    DST=$2

    c=0

    for file in "$SRC"/*
    do
        size=$(wc -c <"$file")
        bname=$(basename "$file")

        transcoded_file="$DST/$bname"
        if [ -f "$transcoded_file" ]; then
            transcoded_size=$(wc -c <"$transcoded_file")

            if [ $transcoded_size -ge $size ]; then
                let c++

                echo "$bname"
                echo "Size:            $size"
                echo "Transcoded size: $transcoded_size"
                echo
            fi
        else
            echo "$bname not found in destination"
            echo
        fi
    done

    echo "$c transcoded videos are heavier than originals"
}
