#!/bin/bash
# macos.sh - Initial setup script for macOS
# This script automates the installation of tools and applications
# that I use daily on a fresh macOS installation.

# Official fonts
brew install --cask font-cascadia-code-pl

# Nerd Fonts
brew install --cask font-caskaydia-cove-nerd-font
brew install --cask font-monaspace-nerd-font

# Tools
brew install mise

# GUI Apps
brew install --cask wezterm
brew install --cask keyboardcleantool
brew install --cask rectangle
brew install --cask visual-studio-code
brew install --cask spotify
brew install --cask obsidian
brew install --cask typora