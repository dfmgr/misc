#!/usr/bin/env bash
compton-toggle.sh_main() {
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  PROG="$(basename "$0")"
  VERSION="202103231633-git"
  USER="${SUDO_USER:-${USER}}"
  HOME="${USER_HOME:-${HOME}}"
  SRC_DIR="${BASH_SOURCE%/*}"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #set opts

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ##@Version       : 202103231633-git
  # @Author        : Jason Hempstead
  # @Contact       : jason@casjaysdev.com
  # @License       : WTFPL
  # @ReadME        : compton-toggle.sh --help
  # @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
  # @Created       : Tuesday, Mar 23, 2021 16:33 EDT
  # @File          : compton-toggle.sh
  # @Description   : polybar compton/picom toggle script
  # @TODO          :
  # @Other         :
  # @Resource      : https://github.com/jaagr/polybar/wiki/User-contributed-modules
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
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  __help() {
    app_help "4" "Usage: compton-toggle.sh" \
      "-c, --config           -  create config file" \
      "-v, --version          -  display version" \
      "-h, --help             -  display help" \
      "--options              -  used by completions"
    exit $?
  }
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  __gen_config() {
    printf_green "Generating the config file in"
    printf_green "$COMPTON_TOGGLE_SH_CONFIG_DIR/$COMPTON_TOGGLE_SH_CONFIG_FILE"
    [ -d "$COMPTON_TOGGLE_SH_CONFIG_DIR" ] || mkdir -p "$COMPTON_TOGGLE_SH_CONFIG_DIR"
    [ -d "$COMPTON_TOGGLE_SH_CONFIG_BACKUP_DIR" ] || mkdir -p "$COMPTON_TOGGLE_SH_CONFIG_BACKUP_DIR"
    [ -f "$COMPTON_TOGGLE_SH_CONFIG_DIR/$COMPTON_TOGGLE_SH_CONFIG_FILE" ] &&
      cp -Rf "$COMPTON_TOGGLE_SH_CONFIG_DIR/$COMPTON_TOGGLE_SH_CONFIG_FILE" "$COMPTON_TOGGLE_SH_CONFIG_BACKUP_DIR/$COMPTON_TOGGLE_SH_CONFIG_FILE.$$"
    cat <<EOF >"$COMPTON_TOGGLE_SH_CONFIG_DIR/$COMPTON_TOGGLE_SH_CONFIG_FILE"
# Settings for compton-toggle.sh
COMPTON_TOGGLE_SH_PICOM_FILE="\${COMPTON_TOGGLE_SH_PICOM_FILE:-\$DESKTOP_SESSION_CONFDIR/picom.conf}"
COMPTON_TOGGLE_SH_COMPTON_FILE="\${COMPTON_TOGGLE_SH_PICOM_FILE:-\$DESKTOP_SESSION_CONFDIR/compton.conf}"

EOF
    if [ -f "$COMPTON_TOGGLE_SH_CONFIG_DIR/$COMPTON_TOGGLE_SH_CONFIG_FILE" ]; then
      printf_green "Your config file for compton-toggle.sh has been created"
      true
    else
      printf_red "Failed to create the config file"
      false
    fi
  }
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Defaults
  local exitCode=""
  local COMPTON_TOGGLE_SH_CONFIG_FILE="settings.conf"
  local COMPTON_TOGGLE_SH_CONFIG_DIR="$HOME/.config/misc/settings/compton-toggle.sh"
  local COMPTON_TOGGLE_SH_CONFIG_BACKUP_DIR="$HOME/.local/share/misc/compton-toggle.sh/backups"
  local COMPTON_TOGGLE_SH_OPTIONS_DIR="$HOME/.local/share/misc/compton-toggle.sh/options"
  local COMPTON_TOGGLE_SH_PICOM_FILE="${COMPTON_TOGGLE_SH_PICOM_FILE:-$DESKTOP_SESSION_CONFDIR/picom.conf}"
  local COMPTON_TOGGLE_SH_COMPTON_FILE="${COMPTON_TOGGLE_SH_PICOM_FILE:-$DESKTOP_SESSION_CONFDIR/compton.conf}"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Argument/Option settings
  local SETARGS="${*}"
  local SHORTOPTS="c,v,h"
  local LONGOPTS="options,config,version,help"
  local ARRAY=""
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Generate Files
  [ -f "$COMPTON_TOGGLE_SH_CONFIG_DIR/$COMPTON_TOGGLE_SH_CONFIG_FILE" ] || __gen_config &>/dev/null
  [ -f "$COMPTON_TOGGLE_SH_OPTIONS_DIR/options" ] || __list_options "$COMPTON_TOGGLE_SH_OPTIONS_DIR" &>/dev/null
  [ -f "$COMPTON_TOGGLE_SH_OPTIONS_DIR/array" ] || __list_array "$COMPTON_TOGGLE_SH_OPTIONS_DIR" "$ARRAY" &>/dev/null
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Import config
  [ -f "$COMPTON_TOGGLE_SH_CONFIG_DIR/$COMPTON_TOGGLE_SH_CONFIG_FILE" ] && . "$COMPTON_TOGGLE_SH_CONFIG_DIR/$COMPTON_TOGGLE_SH_CONFIG_FILE"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # options
  local setopts=$(getopt -o "$SHORTOPTS" --long "$LONGOPTS" -n "$PROG" -- "$@" 2>/dev/null)
  eval set -- "$setopts" 2>/dev/null
  while :; do
    case $1 in
    --options)
      __list_options "$COMPTON_TOGGLE_SH_OPTIONS_DIR"
      __list_array "$COMPTON_TOGGLE_SH_OPTIONS_DIR" "$ARRAY"
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
  if cmd_exists picom; then
    if pgrep -x "picom" &>/dev/null; then
      killall picom &>/dev/null || return 1
    else
      if [ -f "$COMPTON_TOGGLE_SH_PICOM_FILE" ]; then
        picom -b --config "$COMPTON_TOGGLE_SH_PICOM_FILE" &>/dev/null
      elif [ -f "$COMPTON_TOGGLE_SH_COMPTON_FILE" ]; then
        picom -b --config "$COMPTON_TOGGLE_SH_COMPTON_FILE" &>/dev/null
      else
        picom -b &>/dev/null
      fi
    fi
  elif cmd_exists comptom; then
    if pgrep -x "compton" &>/dev/null; then
      killall compton &>/dev/null || return 1
    else
      if [ -f "$COMPTON_TOGGLE_SH_PICOM_FILE" ]; then
        compton -b --config "$COMPTON_TOGGLE_SH_PICOM_FILE" &>/dev/null
      elif [ -f "$COMPTON_TOGGLE_SH_COMPTON_FILE" ]; then
        compton -b --config "$COMPTON_TOGGLE_SH_COMPTON_FILE" &>/dev/null
      else
        compton -b &>/dev/null
      fi
    fi
  fi
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # lets exit with code
  return "${exitCode:-$?}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# execute function
compton-toggle.sh_main "$@"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# End application
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
