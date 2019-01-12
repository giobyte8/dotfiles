#!/bin/bash
#
# Move fonts to '~/.local/share/fonts' and
# reset font cache
#

echo "Installing fonts..."
for font in *; do
    if [ ! $font = "setup.sh" ]; then
        cp -n $font "$HOME/.local/share/fonts/$font"
    fi
done

# Reset font cache
if which fc-cache >/dev/null 2>&1 ; then
    echo "Resetting font cache, this may take a moment..."
    fc-cache -f "$HOME/.local/share/fonts"
fi

echo "Fonts installed correctly"

