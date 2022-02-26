#!/bin/bash
#
# Downloads wallpapers from urls at sources/walls*urls.txt files
# into directory specified at .env#WALLPAPERS_DOWNLOADS_PATH
#
# TODO: Add support for below option
#   --write-log FILE           Write logging output to FILE
#

source .env

# Download/Update landscape wallpapers
docker-compose run --rm --name wallsdl                     \
    -v "${PWD}/sources/walls-landscape.urls.txt:/dl/urls"  \
    -v "${WALLPAPERS_DOWNLOADS_PATH}/Landscape:/landscape" \
    gallerydl                                              \
    -i urls                                                \
    -D "/landscape/"                                       \
    --quiet


# Download/Update portrait wallpapers
docker-compose run --rm --name wallsdl                     \
    -v "${PWD}/sources/walls-portrait.urls.txt:/dl/urls"   \
    -v "${WALLPAPERS_DOWNLOADS_PATH}/Portrait:/portrait"   \
    gallerydl                                              \
    -i urls                                                \
    -D "/portrait/"                                        \
    --quiet

