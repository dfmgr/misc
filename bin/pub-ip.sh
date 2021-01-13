#!/usr/bin/env bash

pub_ip() {
  DIR="${BASH_SOURCE%/*}"
  if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
  if [[ -f "$DIR/functions.bash" ]]; then
    source "$DIR/functions.bash"
  else
    echo "\t\tCouldn't source the functions file"
    exit 1
  fi

  [ ! "$1" = "--help" ] || printf_help "Usage: pub-ip.sh    |    get public ip address"

  if am_i_online; then
    IP=$(curl -4 -s http://ifconfig.co/ip)
    if pgrep -x openvpn >/dev/null; then
      echo VPN: "$IP"
    else
      echo "$IP"
    fi
  else
    printf_error "No internet connection"
  fi
}

pub_ip "$@"
