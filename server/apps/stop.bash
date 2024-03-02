# Stop docker apps

# ref: https://stackoverflow.com/a/4774063/3211029
HERE="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
CURP="$(pwd)"

cd $HERE

cd borgmatic && docker-compose down && cd ..

echo
cd syncthing && docker-compose down && cd ..

echo
cd photoprism && docker-compose down && cd ..

echo
cd plex && docker-compose down && cd ..

echo
cd rterminal && docker-compose down && cd ..

echo
cd infrastructure && docker-compose stop bifrost && cd ..

echo
echo "Services stopped"

cd $CURP

