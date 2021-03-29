#!/usr/bin/env bash
check-all-updates.sh_main() {
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  PROG="$(basename "$0")"
  VERSION="202103230834-git"
  USER="${SUDO_USER:-${USER}}"
  HOME="${USER_HOME:-${HOME}}"
  SRC_DIR="${BASH_SOURCE%/*}"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #set opts

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ##@Version       : 202103230834-git
  # @Author        : Jason Hempstead
  # @Contact       : jason@casjaysdev.com
  # @License       : WTFPL
  # @ReadME        : check-all-updates.sh --help
  # @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
  # @Created       : Tuesday, Mar 23, 2021 08:34 EDT
  # @File          : check-all-updates.sh
  # @Description   : check for package updates
  # @TODO          :
  # @Other         :
  # @Resource      :
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Main function file
  if [ -f "$SRC_DIR/functions.bash" ]; then
    FUNCTIONS_DIR="$SRC_DIR"
    . "$FUNCTIONS_DIR/functions.bash"
  elif [ -f "$HOME/.local/bin/functions.bash" ]; then
    FUNCTIONS_DIR="$HOME/.local/bin"
    . "$FUNCTIONS_DIR/functions.bash"
  else
    printf "\t\t\033[0;31m%s \033[0m\n" "Couldn't source the functions file from $FUNCTIONS_DIR"
    return 1
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # helper functions - See github.com/dfmgr/misc/bin/functions.bash
  __version() { app_version; }
  __ask_me_to_update() { ask_yes_no_question "Would you like to update" "pkmgr silent upgrade"; }
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  __help() {
    app_help "4" "Usage: check-all-updates.sh" \
      "-c, --config           -  create config file" \
      "-v, --version          -  display version" \
      "-h, --help             -  display help" \
      "--options              -  used by completions"
    exit $?
  }
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  __gen_config() {
    printf_green "Generating the config file in"
    printf_green "$CHECK_ALL_UPDATES_SH_CONFIG_DIR/$CHECK_ALL_UPDATES_SH_CONFIG_FILE"
    [ -d "$CHECK_ALL_UPDATES_SH_CONFIG_DIR" ] || mkdir -p "$CHECK_ALL_UPDATES_SH_CONFIG_DIR"
    [ -d "$CHECK_ALL_UPDATES_SH_CONFIG_BACKUP_DIR" ] || mkdir -p "$CHECK_ALL_UPDATES_SH_CONFIG_BACKUP_DIR"
    [ -f "$CHECK_ALL_UPDATES_SH_CONFIG_DIR/$CHECK_ALL_UPDATES_SH_CONFIG_FILE" ] &&
      cp -Rf "$CHECK_ALL_UPDATES_SH_CONFIG_DIR/$CHECK_ALL_UPDATES_SH_CONFIG_FILE" "$CHECK_ALL_UPDATES_SH_CONFIG_BACKUP_DIR/$CHECK_ALL_UPDATES_SH_CONFIG_FILE.$$"
    cat <<EOF >"$CHECK_ALL_UPDATES_SH_CONFIG_DIR/$CHECK_ALL_UPDATES_SH_CONFIG_FILE"
# Settings for check-all-updates.sh
CHECK_ALL_UPDATES_SH_CACHEDIR="\${CACHE_DIR:-$HOME/.cache/check_all_updates_sh}"
CHECK_ALL_UPDATES_SH_ENABLE_NOTIFICATIONS="\${CHECK_ALL_UPDATES_SH_ENABLE_NOTIFICATIONS:-yes}"
CHECK_ALL_UPDATES_SH_ENABLE_UPDATE_NAG="\${CHECK_ALL_UPDATES_SH_ENABLE_UPDATE_NAG:-yes}"
CHECK_ALL_UPDATES_SH_SUDO_ASKPASS_PROGRAM="\${SUDO_ASKPASS:-/usr/local/bin/dmenupass}"
__ask_me_to_update() { ask_yes_no_question "Would you like to update" "pkmgr silent upgrade"; }

EOF
    if [ -f "$CHECK_ALL_UPDATES_SH_CONFIG_DIR/$CHECK_ALL_UPDATES_SH_CONFIG_FILE" ]; then
      printf_green "Your config file for check-all-updates.sh has been created"
      true
    else
      printf_red "Failed to create the config file"
      false
    fi
  }
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Defaults
  local exitCode=
  local CHECK_ALL_UPDATES_SH_CONFIG_FILE="settings.conf"
  local CHECK_ALL_UPDATES_SH_CONFIG_DIR="$HOME/.config/misc/settings/check-all-updates.sh"
  local CHECK_ALL_UPDATES_SH_CONFIG_BACKUP_DIR="$HOME/.local/share/misc/check-all-updates.sh/backups"
  local CHECK_ALL_UPDATES_SH_OPTIONS_DIR="$HOME/.local/share/misc/check-all-updates.sh/options"
  local CHECK_ALL_UPDATES_SH_CACHEDIR="${CACHE_DIR:-$HOME/.cache/check_all_updates_sh}"
  local CHECK_ALL_UPDATES_SH_ENABLE_NOTIFICATIONS="${CHECK_ALL_UPDATES_SH_ENABLE_NOTIFICATIONS:-yes}"
  local CHECK_ALL_UPDATES_SH_ENABLE_UPDATE_NAG="${CHECK_ALL_UPDATES_SH_ENABLE_UPDATE_NAG:-yes}"
  local CHECK_ALL_UPDATES_SH_SUDO_ASKPASS_PROGRAM="${SUDO_ASKPASS:-/usr/local/bin/dmenupass}"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Argument/Option settings
  local SETARGS="${*}"
  local SHORTOPTS="c,v,h"
  local LONGOPTS="options,config,version,help"
  local ARRAY=""
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Generate Files
  [ -f "$CHECK_ALL_UPDATES_SH_CONFIG_DIR/$CHECK_ALL_UPDATES_SH_CONFIG_FILE" ] || __gen_config &>/dev/null
  [ -f "$CHECK_ALL_UPDATES_SH_OPTIONS_DIR/options" ] || __list_options "$CHECK_ALL_UPDATES_SH_OPTIONS_DIR" &>/dev/null
  [ -f "$CHECK_ALL_UPDATES_SH_OPTIONS_DIR/array" ] || __list_array "$CHECK_ALL_UPDATES_SH_OPTIONS_DIR" "$ARRAY" &>/dev/null
  [ -d "$CHECK_ALL_UPDATES_SH_CACHEDIR" ] || mkdir -p "$CHECK_ALL_UPDATES_SH_CACHEDIR"
  [ -f "$CHECK_ALL_UPDATES_SH_CACHEDIR/update_check" ] || rm -Rf "$CHECK_ALL_UPDATES_SH_CACHEDIR/update_check"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Import config
  [ -f "$CHECK_ALL_UPDATES_SH_CONFIG_DIR/$CHECK_ALL_UPDATES_SH_CONFIG_FILE" ] &&
    . "$CHECK_ALL_UPDATES_SH_CONFIG_DIR/$CHECK_ALL_UPDATES_SH_CONFIG_FILE"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  local SUDO_ASKPASS="$CHECK_ALL_UPDATES_SH_SUDO_ASKPASS_PROGRAM"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # options
  local setopts=$(getopt -o "$SHORTOPTS" --long "$LONGOPTS" -n "$PROG" -- "$@" 2>/dev/null)
  eval set -- "$setopts" 2>/dev/null
  while :; do
    case $1 in
    --options)
      __list_options "$CHECK_ALL_UPDATES_SH_OPTIONS_DIR"
      __list_array "$CHECK_ALL_UPDATES_SH_OPTIONS_DIR" "$ARRAY"
      exit $?
      ;;
    -v | --version)
      __version
      exit $?
      ;;
    -h | --help)
      __help
      exit $?
      ;;
    -c | --config)
      __gen_config
      exit $?
      ;;
    --)
      shift 1
      break
      ;;
      #*) break ;;
    esac
    shift
  done
  set -- "$SETARGS"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Check for required applications
  cmd_exists --error bash || exit 1
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # begin main app
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
    echo "$updates"
  else
    echo 0
    rm -Rf "$CHECK_ALL_UPDATES_SH_CACHEDIR/update_check"
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if [ "$CHECK_ALL_UPDATES_SH_ENABLE_UPDATE_NAG" = "yes" ] && [[ "$updates" -gt 0 ]]; then
    __ask_me_to_update
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if [[ $updates -gt 0 ]]; then
    if [ "$CHECK_ALL_UPDATES_SH_ENABLE_NOTIFICATIONS" = "yes" ]; then
      if [ ! -f "$CHECK_ALL_UPDATES_SH_CACHEDIR/update_check" ]; then
        echo "$updates" >"$CHECK_ALL_UPDATES_SH_CACHEDIR/update_check"
        /usr/local/bin/notifications "System Updates:" "You have $updates update[s] avaliable"
      fi
    fi
  fi

  # lets exit with code
  return "${exitCode:-$?}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# execute function
check-all-updates.sh_main "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
