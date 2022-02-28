#!/bin/bash
#
# Move fonts to '~/.local/share/fonts' and
# reset font cache
#

echo "Installing fonts..."

fonts_dir="$HOME/.local/share/fonts"
mkdir -p $fonts_dir

for font in *; do
    if [ ! "$font" = "setup.sh" ]; then
        cp -n "$font" "$fonts_dir/$font"
    fi
done

# Reset font cache
if which fc-cache >/dev/null 2>&1 ; then
    echo "Resetting font cache, this may take a moment..."
    fc-cache -f "$fonts_dir"
fi

echo "Fonts installed correctly"

#
# Now go a head to install powerline fonts
echo ""
echo "Now lets install Powerline fonts"
git clone https://github.com/powerline/fonts.git powerline_fonts --depth=1
cd powerline_fonts
./install.sh

# Clean up a bit
cd ..
rm -rf powerline_fonts

