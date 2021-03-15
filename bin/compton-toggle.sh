#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
PROG="compton-toggle.sh"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 031120210512-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : WTFPL
# @ReadME        : compton-toggle.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Thursday, Mar 11, 2021 05:12 EST
# @File          : compton-toggle.sh
# @Description   : picom/comptom toggle
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# main function
__version() { app_version; }
__help() {
  app_help "Usage: compton-toggle.sh"
}

main() {
  if [ -f "$SRC_DIR/functions.bash" ]; then local DIR="$SRC_DIR"; else local DIR="$HOME/.local/bin"; fi
  if [[ -f "$DIR/functions.bash" ]]; then
    . "$DIR/functions.bash"
  else
    printf "\t\t\\033[0;31m%s \033[0m\n" "Couldn't source the functions file from $DIR"
    return 1
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  case $1 in
    -v | --version) __version ;;
    -h | --help) __help ;;
  esac
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if [ -f "$(command -v picom 2>/dev/null)" ]; then
    if pgrep -x "picom" &>/dev/null; then
      killall picom &>/dev/null || return 1
    else
      if [ -f "$DESKTOP_SESSION_CONFDIR/picom.conf" ]; then
        picom -b --config $DESKTOP_SESSION_CONFDIR/picom.conf &>/dev/null
      elif [ -f "$DESKTOP_SESSION_CONFDIR/compton.conf" ]; then
        picom -b --config $DESKTOP_SESSION_CONFDIR/compton.conf &>/dev/null
      else
        picom -b &>/dev/null
      fi
    fi
  elif [ -f "$(command -v compton 2>/dev/null)" ]; then
    if pgrep -x "compton" &>/dev/null; then
      killall compton &>/dev/null || return 1
    else
      if [ -f "$DESKTOP_SESSION_CONFDIR/picom.conf" ]; then
        compton -b --config $DESKTOP_SESSION_CONFDIR/picom.conf &>/dev/null
      elif [ -f "$DESKTOP_SESSION_CONFDIR/compton.conf" ]; then
        compton -b --config $DESKTOP_SESSION_CONFDIR/compton.conf &>/dev/null
      else
        compton -b &>/dev/null
      fi
    fi
  else
    local exitCode=1
  fi
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
main "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit $?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
