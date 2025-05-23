#!/bin/bash
# Custom functionality setup for mac boxes

if [[ $OSTYPE == 'darwin'* ]]; then

  ## MacOS-only aliases
  alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
  alias typora="open -a typora"

  ## Alias/Shortcuts
  alias dotf="code ~/dotf"

  ## Global env variables setup
  export GEM_HOME=$HOME/.gem
  export PATH=$GEM_HOME/bin:$PATH


  function dns-set {
    if [ $1 = "cloudflare" ]; then
      echo "Switching to Cloudflare DNS servers"
      networksetup -setdnsservers Wi-Fi 1.1.1.1 1.0.0.1
    elif [ $1 = "opendns" ]; then
      echo "Switching to OpenDNS DNS servers"
      networksetup -setdnsservers Wi-Fi 208.67.222.222 208.67.220.220
    elif [ $1 = "google" ]; then
      echo "Switching to Google DNS servers"
      networksetup -setdnsservers Wi-Fi 8.8.8.8 8.8.4.4
    elif [ $1 = "pihole" ]; then
      echo "Switching to pihole as DNS server"
      networksetup -setdnsservers Wi-Fi 192.168.1.202 1.1.1.1
    else
      echo "Setting $@ as DNS servers"
      networksetup -setdnsservers Wi-Fi "$@"
    fi
  }

  function dns-unset {
    echo "Removing DNS servers"
    networksetup -setdnsservers Wi-Fi empty
  }

  function dns-list {
    echo "Some suggested DNS servers:"
    echo "cloudflare: 1.1.1.1 1.0.0.1"
    echo "opendns:    208.67.222.222 208.67.220.220"
    echo "google:     8.8.8.8 8.8.4.4"
    echo "pihole:     192.168.1.252"
    echo ""
    echo "Current DNS:"
    networksetup -getdnsservers Wi-Fi
  }
fi
