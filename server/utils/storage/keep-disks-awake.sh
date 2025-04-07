#!/bin/bash

# List your mount points here
MOUNT_POINTS=(
    /media/vstore
    /media/redstore1
)

for MOUNT in "${MOUNT_POINTS[@]}"; do
    if mountpoint -q "$MOUNT"; then
        ls "$MOUNT" >/dev/null 2>&1
    fi
done
