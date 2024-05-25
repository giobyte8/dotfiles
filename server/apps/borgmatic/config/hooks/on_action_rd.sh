#!/bin/bash
# Executed by borgmatic action hooks to deliver notifications
# through redis.
#
# Usage:
# > on_action_rd.sh                 \
# >   "backups/pictures_repo.borg"  \
# >   "Photos"                      \
# >   "Backup completed"
#
# Accepted arguments
# 1: Repository
# 2: Backup config file name (provided by borgmatic variables)
# 3: Action message (Starting backup, Starting prune, etc)
#
# Environment configuration
# Config variables are taken from environment.
# docker-compose.yml takes care of passing env values to container.
#

CALLER_PATH="$(pwd)"
SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd "$SCRIPT_PATH"


# Check if python is available
if ! command -v python &> /dev/null
then
    echo "Python is not available"
    exit 1
fi

# For dev purposes only
if [ -f "../../.env" ]; then
    env_file=$(realpath ../../.env)

    echo "Loading env: ${env_file}"
    source $env_file
fi

# Validate arguments
if [ ! $# -eq 3 ]; then
    echo "ERR: Wrong number of arguments"
    echo " Usage: ./on_action_rd.sh <repo> <config> <msg>"
    exit 1
fi

# Read and validate arguments
REPO=$1
CONF=$2
MESSAGE=$3

# Simplify repository names
if [ "$REPO" = "ssh://uh46y91c@uh46y91c.repo.borgbase.com/./repo" ]; then
    REPO="Offsite"
elif [ "$REPO" = "/mnt/host-local-borg-repository" ]; then
    REPO="Onsite"
fi

# Simplify config file name
if type basename &> /dev/null; then
    CONF=$(basename "${CONF}")
fi


# Prepare message for actions with repo and without repo
if [ '--' == "$REPO" ]; then
    msg="$MESSAGE

Conf: $CONF"
else
    msg="$MESSAGE

Conf: $CONF
Repo: $REPO"
fi

# Invoke python script to post redis notification
python rd_post_notif.py "Borgmatic" "$msg"
