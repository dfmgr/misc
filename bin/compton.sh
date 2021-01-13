#!/usr/bin/env bash

# https://github.com/jaagr/polybar/wiki/User-contributed-modules

main() {
  DIR="${BASH_SOURCE%/*}"
  if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
  if [[ -f "$DIR/functions.bash" ]]; then
    source "$DIR/functions.bash"
  else
    echo -e "\t\tCouldn't source the functions file"
    exit 1
  fi

  [ ! "$1" = "--help" ] || printf_help "Usage: compton.sh"

  #The icon that would change color
  icon=""

  if pgrep -x "compton" >/dev/null || pgrep -x "picom" >/dev/null; then
    echo "%{F#00AF02}$icon " #Green
  else
    echo "%{F#65737E}$icon " #Gray
  fi
}

main "$@"
