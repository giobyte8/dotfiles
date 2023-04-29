# Automatically start docker apps

echo "Starting borgmatic"
cd borgmatic && dc up -d && cd ..

echo
echo "Starting photoprism"
cd photoprism && dc up -d && cd ..

echo
echo "Starting plex"
cd plex && dc up -d && cd ..

echo
echo "Starting rterminal"
cd rterminal && dc up -d && cd ..

echo
echo "Starting bifrost"
cd infrastructure && dc up -d bifrost && cd ..
