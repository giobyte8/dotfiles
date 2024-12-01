# Automatically start docker apps

# ref: https://stackoverflow.com/a/4774063/3211029
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
CURP="$(pwd)"

cd $HERE

cd borgmatic && docker-compose up -d borgmatic && cd ..

echo
cd syncthing && docker-compose up -d && cd ..

echo
cd photoprism && docker-compose up -d && cd ..

echo
cd plex && docker-compose up -d && cd ..

#echo
#cd rterminal && docker-compose up -d && cd ..

echo
cd infrastructure && docker-compose up -d bifrost && cd ..

echo
echo "Services started"

cd $CURP

