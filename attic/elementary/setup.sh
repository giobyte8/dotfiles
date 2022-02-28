#!/bin/bash

echo
echo "==========================================="
echo "Let's setup elementary os"
echo

echo " Setting up terminal"
echo "  > Font: Fira Mono for powerline 10"
gsettings set io.elementary.terminal.settings font 'Fira Mono for powerline 10'

echo "  > Cursor: IBeam"
gsettings set io.elementary.terminal.settings cursor-shape 'I-Beam'

echo

