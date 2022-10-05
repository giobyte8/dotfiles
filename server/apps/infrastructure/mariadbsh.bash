#!/bin/bash
#
# Connects to local mariadb through a container

# ref: https://stackoverflow.com/a/4774063/3211029
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
CURR_PATH="${pwd}"

cd $HERE

# Source env to load creds
source .env

docker run --rm -it --network hservices mariadb:10.8.3-jammy mysql -hmariadb -uroot -p${MARIADB_ROOT_PASSWORD}

