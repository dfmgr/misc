#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
PROG="tempcores.sh"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 031120211832-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : WTFPL
# @ReadME        : tempcores.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Thursday, Mar 11, 2021 18:32 EST
# @File          : tempcores.sh
# @Description   : Get information from cores temp thanks to sensors
# @TODO          :
# @Other         :
# @Resource      : https://github.com/jaagr/polybar/wiki/User-contributed-modules#per-core-temperatures
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main function
__version() { app_version; }
__help() {
  app_help "Usage: tempcores.sh"
}
main() {
  if [ -f "$SRC_DIR/functions.bash" ]; then local DIR="$SRC_DIR"; else local DIR="$HOME/.local/bin"; fi
  if [[ -f "$DIR/functions.bash" ]]; then
    source "$DIR/functions.bash"
  else
    printf "\t\t\\033[0;31m%s \033[0m\n" "Couldn't source the functions file from $DIR"
    return 1
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  [ "$1" = "--version" ] && __version
  [ "$1" = "--help" ] && __help
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  rawData=$(sensors -f | grep -m 1 Core | awk '{print substr($3, 2, length($3)-5)}')
  tempCore="($rawData)"
  degree="°F"
  temperaturesValues=(140 150 160 170 180 190)
  temperaturesColors=("#6bff49" "#f4cb24" "#ff8819" "#ff3205" "#f40202" "#ef02db")
  temperaturesIcons=(     )
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  for iCore in ${!tempCore[*]}; do
    for iTemp in ${!temperaturesValues[*]}; do
      if (("${tempCore[$iCore]}" < "${temperaturesValues[$iTemp]}")); then
        tmpEcho="%{F${temperaturesColors[$iTemp]}}${tempCore[$iCore]}$degree%{F-}"
        finalEcho="$finalEcho $tmpEcho"
        break
      fi
    done
    total=$((${tempCore[$iCore]} + total))
  done && exitCode+=0 || exitCode+=1

  sum=$(($total / ${#tempCore[*]}))

  for iTemp in ${!temperaturesValues[*]}; do
    if (("$sum" < "${temperaturesValues[$iTemp]}")); then
      ## This line will color the icon too
      tmpEcho="%{F${temperaturesColors[$iTemp]}}${temperaturesIcons[$iTemp]}%{F-}"
      ## This line will NOT color the icon
      #tmpEcho="${temperaturesIcons[$iTemp]}"
      finalEcho=" $finalEcho $tmpEcho"
      break
    fi
  done && exitCode+=0 || exitCode+=1

  printf "%s\n" "$finalEcho"
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
main "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit $?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
