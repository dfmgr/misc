#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
PROG="check-all-updates.sh"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 031120211916-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : WTFPL
# @ReadME        : check-all-updates.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Thursday, Mar 11, 2021 19:16 EST
# @File          : check-all-updates.sh
# @Description   : check for package updates
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main function
__version() { app_version; }
__help() {
  app_help "Usage: check-all-updates.sh"
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
    -v | --version)
      __version
     ;;
    -h | --help)
      __help
      ;;
  esac
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  [ -f "$(command -v dmenupass)" ] && SUDO_ASKPASS="/usr/local/bin/dmenupass"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  [ -d "$HOME/.local/tmp" ] || mkdir -p "$HOME/.local/tmp"
  [ -f "$HOME/.local/tmp/update_check" ] || rm -Rf "$HOME/.local/tmp/update_check"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  local updatemess="You have updates available \nWould you like to update now?"
  local xmessageopts="-nearmouse -timeout 10 -geometry 500x200 -center"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if am_i_online; then
    #Arch update check
    if [ -f /usr/bin/pacman ]; then
      if ! updates_arch=$(pacman -Qu 2>/dev/null | wc -l); then
        updates_arch=0
        updates="$updates_arch"
      fi
    #    #yay doesn't do sudo
    #    if [ -f /usr/bin/yay ]; then
    #        if ! updates_aur=$(yay -Qum 2>/dev/null | wc -l); then
    #            updates_aur=0
    #        fi
    #    fi
    #    updates=$(("$updates_arch" + "$updates_aur"))
    #Debian update check
    elif [ -f /usr/bin/apt ]; then
      if ! updates=$(sudo apt-get update >/dev/null && apt-get --just-print upgrade | grep "Inst " | wc -l); then
        updates=0
      fi

    elif [ -f /usr/bin/dnf ]; then
      if ! updates=$(sudo dnf check-update -q | grep -v Security | wc -l); then
        updates=0
      fi

    elif [ -f /usr/bin/yum ]; then
      if ! updates=$(sudo yum check-update -q | grep -v Security | wc -l); then
        updates=0
      fi
    fi
  else
    updates=0
  fi
  if [[ $updates -gt 0 ]]; then
    echo " $updates"
  else
    echo "0"
    rm -Rf "$HOME/.local/tmp/update_check"
    exit 0
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #if [ ! -f $HOME/.cache/update_nag ] && [ -n $DISPLAY ]; then
  #DISPLAY=$DISPLAY xmessage -buttons Yes:0,No:1 -default Yes $xmessageopts --title "You have updates" "$updatemess" && \
  #sleep 20 && #pkmgr silent-update && \
  #DISPLAY=$DISPLAY xmessage -buttons OK:0 -default Ok $xmessageopts --title "Done updating" "Update completed successfully" && \
  #sleep 20
  #DISPLAY=$DISPLAY xmessage -buttons Yes:0,No:1 -default Yes $xmessageopts --title "message" "Show this again?" && \
  #sleep 20 ; ret=$? ; if [ "$ret" -ne 0 ]; then touch $HOME/.cache/update_nag ; fi
  #fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if [[ $updates -gt 0 ]]; then
    if [ -f "$(command -v notifications)" ]; then
      if [ ! -f "$HOME/.local/tmp/update_check" ]; then
        echo "$updates" >"$HOME/.local/tmp/update_check"
        /usr/local/bin/notifications "System Updates:" "You have $updates update[s] avaliable"
      fi
    fi
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
main "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
exit $?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
