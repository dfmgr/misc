#!/usr/bin/env bash

SCRIPTNAME="$(basename $0)"
SCRIPTDIR="$(dirname "${BASH_SOURCE[0]}")"
USER="${SUDO_USER:-${USER}}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# @Author      : Jason
# @Contact     : casjaysdev@casjay.net
# @File        : check-for-updates
# @Created     : Mon, Dec 31, 2019, 00:00 EST
# @License     : WTFPL
# @Copyright   : Copyright (c) CasjaysDev
# @Description : check for package updates
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {
  DIR="${BASH_SOURCE%/*}"
  if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
  if [[ -f "$DIR/functions.bash" ]]; then
    source "$DIR/functions.bash"
  else
    echo "\t\tCouldn't source the functions file"
    exit 1
  fi

  [ ! "$1" = "--help" ] || printf_help "check-for-updates.sh    |    update checker for arch based systems"

  if [ -e "/usr/local/bin/dmenupass" ]; then
    SUDO_ASKPASS="/usr/local/bin/dmenupass}"
  fi

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  updatemess="You have updates available \nWould you like to update now?"
  xmessageopts="-nearmouse -timeout 10 -geometry 500x200 -center"

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  [ -d "$HOME/.local/tmp" ] || mkdir -p "$HOME/.local/tmp"
  [ -f "$HOME/.local/tmp/update_check" ] || rm -Rf "$HOME/.local/tmp/update_check"

  # run
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

  if [[ $updates -gt 0 ]]; then
    echo " $updates"
  else
    echo "0"
    rm -Rf "$HOME/.local/tmp/update_check"
    exit 0
  fi

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #if [ ! -f $HOME/.cache/update_nag ] && [ ! -z $DISPLAY ]; then
  #DISPLAY=$DISPLAY xmessage -buttons Yes:0,No:1 -default Yes $xmessageopts --title "You have updates" "$updatemess" && \
  #sleep 20 && #pkmgr silent-update && \
  #DISPLAY=$DISPLAY xmessage -buttons OK:0 -default Ok $xmessageopts --title "Done updating" "Update completed successfully" && \
  #sleep 20
  #DISPLAY=$DISPLAY xmessage -buttons Yes:0,No:1 -default Yes $xmessageopts --title "message" "Show this again?" && \
  #sleep 20 ; ret=$? ; if [ "$ret" -ne 0 ]; then touch $HOME/.cache/update_nag ; fi
  #fi

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if [[ $updates -gt 0 ]]; then
    if [ -f /usr/local/bin/notifications ]; then
      #      while : ; do
      if [ ! -f "$HOME/.local/tmp/update_check" ]; then
        echo "$updates" >"$HOME/.local/tmp/update_check"
        /usr/local/bin/notifications "System Updates:" "You have $updates update[s] avaliable"
      fi
      #         [ ! -f $HOME/.cache/updates-disabled ] || break
      #         sleep 600
      #     done &> /dev/null &
    fi
  fi
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main "$@"

# end
