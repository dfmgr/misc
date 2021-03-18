#!/usr/bin/env bash
compton.sh() {
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
PROG="compton.sh"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 031120210507-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : WTFPL
# @ReadME        : compton.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Thursday, Mar 11, 2021 05:07 EST
# @File          : compton.sh
# @Description   : polybar compton/picom script
# @TODO          :
# @Other         :
# @Resource      : https://github.com/jaagr/polybar/wiki/User-contributed-modules
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# main function
__version() { app_version; }
__help() {
  app_help "Usage: compton.sh" \
    "-v, --version          -  display version" \
    "-h, --help             -  display help"
}
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
  local icon='  '
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if pgrep -x "compton" &>/dev/null || pgrep -x "picom" &>/dev/null; then
    echo "%{F#00AF02}$icon " #Green
  else
    echo "%{F#65737E}$icon " #Gray
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
compton.sh "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit $?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end

