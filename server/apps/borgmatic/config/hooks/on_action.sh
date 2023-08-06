#!/bin/bash
# Executed by borgmatic action hooks
#
# Usage:
# > on_action.sh                    \
# >   "backups/pictures_repo.borg"  \
# >   "Photos"                      \
# >   "LOW"                         \
# >   "Backup completed"
#
# Accepted arguments
# 1: Repository
# 2: Backup config file name (provided by borgmatic variables)
# 3: Notification priority: LOW | MEDIUM | HIGH
# 4: Action message (Starting backup, Starting prune, etc)
#
# Environment configuration
# Config variables are taken from environment, docker-compose.yml
# takes care of passing env values.
#
# RabbitMQ vhost
# Currently vhost is always passed as '%2F' wich means '/' (url encoded)
# This value is not parametrized for now
#

# For dev purposes only
if [ -f ../.env ]; then
    source ../.env
fi


if [ ! $# -eq 4 ]; then
    echo "ERR: Wrong number of arguments"
    echo " Usage: on_action.sh <repo> <config> <priority> <msg>"
    exit 1
fi

# Read and validate arguments
REPO=$1
CONF=$2
PRIORITY=$3
MESSAGE=$4

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


# Prepare message payload

function json_escape() {
    printf '%s' "$1" | python -c 'import json,sys; print(json.dumps(sys.stdin.read()))'
}

msg="$MESSAGE

Conf: $CONF
Repo: $REPO"
j_msg=$(json_escape "$msg")

notification="{
    \"level\": \"$PRIORITY\",
    \"message\": $j_msg
}"
j_payload=$(json_escape "$notification")
#payload=$(printf '%s' "$jnotif" | base64)

amqp_msg="{
    \"properties\": {},
    \"routing_key\": \"INFRASTRUCTURE_NOTIFICATIONS\",
    \"payload\": $j_payload,
    \"payload_encoding\": \"string\"
}"


# Post message to RabbitMQ
# For debug remove '-s' flag and use '-v' for verbose mode
curl -s \
    -u "$RABBITMQ_USER:$RABBITMQ_PASS"  \
    -X POST                             \
    -d "$amqp_msg"                      \
    http://$RABBITMQ_HOST:$RABBITMQ_API_PORT/api/exchanges/%2F/$RABBITMQ_EXCHANGE/publish
