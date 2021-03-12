#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
PROG="pub-ip.sh"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 031120211219-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : WTFPL
# @ReadME        : pub-ip.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Thursday, Mar 11, 2021 12:19 EST
# @File          : pub-ip.sh
# @Description   : get public ip address
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# main function
__help() {
  printf_help "Usage: pub-ip.sh    |    get public ip address"
}
main() {
  local DIR="${SRC_DIR:-$PWD}"
  if [[ -f "$DIR/functions.bash" ]]; then
    . "$DIR/functions.bash"
  else
    printf "\t\t\\033[0;31m%s \033[0m\n" "Couldn't source the functions file from $DIR"
    return 1
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  [ "$1" = "--help" ] && __help
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if am_i_online; then
    local IP=$(curl -q -4 -LSs http://ifconfig.co/ip)
    if [ -n "$IP" ]; then
      if pgrep -x openvpn >/dev/null; then
        echo VPN: "$IP"
      else
        echo "$IP"
      fi
    else
      IP=""
    fi
  else
    echo "No internet connection"
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
main "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit $?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
