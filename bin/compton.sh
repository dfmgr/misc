#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202103231659-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : WTFPL
# @ReadME        : compton.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Tuesday, Mar 23, 2021 16:59 EDT
# @File          : compton.sh
# @Description   : polybar compton/picom status script
# @TODO          :
# @Other         :
# @Resource      : https://github.com/jaagr/polybar/wiki/User-contributed-modules
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
PROG="$(basename "$0")"
VERSION="202103231659-git"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main function file
compton.sh_main() {
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
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  __help() {
    app_help "4" "Usage: compton.sh " \
      "-c, --config           -  create config file" \
      "-v, --version          -  display version" \
      "-h, --help             -  display help" \
      "--options              -  used by completions"
    exit $?
  }
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  __gen_config() {
    printf_green "Generating the config file in"
    printf_green "$COMPTON_SH_CONFIG_DIR/$COMPTON_SH_CONFIG_FILE"
    [ -d "$COMPTON_SH_CONFIG_DIR" ] || mkdir -p "$COMPTON_SH_CONFIG_DIR"
    [ -d "$COMPTON_SH_CONFIG_BACKUP_DIR" ] || mkdir -p "$COMPTON_SH_CONFIG_BACKUP_DIR"
    [ -f "$COMPTON_SH_CONFIG_DIR/$COMPTON_SH_CONFIG_FILE" ] &&
      cp -Rf "$COMPTON_SH_CONFIG_DIR/$COMPTON_SH_CONFIG_FILE" "$COMPTON_SH_CONFIG_BACKUP_DIR/$COMPTON_SH_CONFIG_FILE.$$"
    cat <<EOF >"$COMPTON_SH_CONFIG_DIR/$COMPTON_SH_CONFIG_FILE"
# Settings for compton.sh
COMPTON_SH_ICON='  '

EOF
    if [ -f "$COMPTON_SH_CONFIG_DIR/$COMPTON_SH_CONFIG_FILE" ]; then
      printf_green "Your config file for compton.sh has been created"
      true
    else
      printf_red "Failed to create the config file"
      false
    fi
  }
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Defaults
  local exitCode=""
  local COMPTON_SH_CONFIG_FILE="settings.conf"
  local COMPTON_SH_CONFIG_DIR="$HOME/.config/misc/settings/compton.sh"
  local COMPTON_SH_CONFIG_BACKUP_DIR="$HOME/.local/share/misc/compton.sh/backups"
  local COMPTON_SH_OPTIONS_DIR="$HOME/.local/share/misc/compton.sh/options"
  local COMPTON_SH_ICON='  '
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Argument/Option settings
  local SETARGS="${*}"
  local SHORTOPTS="c,v,h"
  local LONGOPTS="options,config,version,help"
  local ARRAY=""
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Generate Files
  [ -f "$COMPTON_SH_CONFIG_DIR/$COMPTON_SH_CONFIG_FILE" ] || __gen_config &>/dev/null
  [ -f "$COMPTON_SH_OPTIONS_DIR/options" ] || __list_options "$COMPTON_SH_OPTIONS_DIR" &>/dev/null
  [ -f "$COMPTON_SH_OPTIONS_DIR/array" ] || __list_array "$COMPTON_SH_OPTIONS_DIR" "$ARRAY" &>/dev/null
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Import config
  [ -f "$COMPTON_SH_CONFIG_DIR/$COMPTON_SH_CONFIG_FILE" ] && . "$COMPTON_SH_CONFIG_DIR/$COMPTON_SH_CONFIG_FILE"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # options
  local setopts=$(getopt -o "$SHORTOPTS" --long "$LONGOPTS" -n "$PROG" -- "$@" 2>/dev/null)
  eval set -- "$setopts" 2>/dev/null
  while :; do
    case $1 in
    --options)
      __list_options "$COMPTON_SH_OPTIONS_DIR"
      __list_array "$COMPTON_SH_OPTIONS_DIR" "$ARRAY"
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
  if pgrep -x "compton" &>/dev/null || pgrep -x "picom" &>/dev/null; then
    printf '%s\n' "%{F#00AF02}$COMPTON_SH_ICON " #Green
  else
    printf '%s\n' "%{F#65737E}$COMPTON_SH_ICON " #Gray
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # lets exit with code
  return "${exitCode:-$?}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# execute function
compton.sh_main "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
