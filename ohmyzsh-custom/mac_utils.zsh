
function dns-set {
  echo "Setting DNS servers"
  networksetup -setdnsservers Wi-Fi "$@"
}

function dns-unset {
  echo "Removing DNS servers"
  networksetup -setdnsservers Wi-Fi empty
}

function dns-list {
  echo "Cloudfare: 1.1.1.1 1.0.0.1"
  echo "OpenDNS:   208.67.222.222 208.67.220.220"
  echo "Google:    8.8.8.8 8.8.4.4"
}

