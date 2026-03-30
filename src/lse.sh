#
# lse: Inspects extensions found at a given path
#  Current path is used by default

function lse {
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
