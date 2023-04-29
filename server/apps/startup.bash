# Automatically start docker apps

echo "Starting borgmatic"
cd borgmatic && docker-compose up -d && cd ..

echo
echo "Starting photoprism"
cd photoprism && docker-compose up -d && cd ..

echo
echo "Starting plex"
cd plex && docker-compose up -d && cd ..

echo
echo "Starting rterminal"
cd rterminal && docker-compose up -d && cd ..

echo
echo "Starting bifrost"
cd infrastructure && docker-compose up -d bifrost && cd ..
