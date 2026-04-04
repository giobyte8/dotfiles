#!/bin/bash

# List your mount points here
MOUNT_POINTS=(
#    /media/vstore
    /media/redstore1
)

for MOUNT in "${MOUNT_POINTS[@]}"; do

    # 'mountpoint' checks if directory is a mount point
    if mountpoint -q "$MOUNT"; then
        ls "$MOUNT" >/dev/null 2>&1
    else
        echo "Path is not a mountpoint: $MOUNT" >&2
    fi
done
