#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
PROG="weather.sh"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 031120211842-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : WTFPL
# @ReadME        : weather.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Thursday, Mar 11, 2021 18:42 EST
# @File          : weather.sh
# @Description   : weather tool for conky
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set functions
__version() { app_version; }
__help() {
  app_help "Usage: weather.sh <options> <locationcode>" \
    "See curl http://wttr.in/:help?A for all options" \
    "IE: weather.sh Au0 mian" \
    "-v, --version          -  display version" \
    "-h, --help             -  display help"
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
  local LANG="$(echo $LANG | sed 's#_.*##g')"
  local METRIC="u"
  [ -n "$1" ] && OPTS="$1" || OPTS="A$METRIC"
  [ -n "$2" ] && LOC="$2" || LOC="${MYLOCATIONID:-alb}"
  if am_i_online; then
    curl -H "Accept-Language: $LANG" -Ls "http://wttr.in/$LOC?$OPTS" | sed -n '3,7{s/\d27\[[0-9;]*m//g;s/^..//;s/ *$//;p}'
    curl -H "Accept-Language: $LANG" -Ls "http://wttr.in/$LOC?$OPTS" | grep "Weather report"
  else
    echo "Weather report unavailable"
    return 1
  fi
  return $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
main "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit $?
# end
