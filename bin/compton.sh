#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202601061012-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.pro
# @License       : WTFPL
# @ReadME        : compton.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Tuesday, Mar 23, 2021 16:59 EDT
# @File          : compton.sh
# @Description   : polybar compton/picom status script
# @Changelog     : Refactored for self-contained operation
# @TODO          :
# @Other         :
# @Resource      : https://github.com/jaagr/polybar/wiki/User-contributed-modules
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Script variables
PROG="compton.sh"
VERSION="202601061012-git"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Environment Detection
__get_os() {
  case "$(uname -s)" in
    Linux*) echo "linux" ;;
    Darwin*) echo "mac" ;;
    *BSD*) echo "bsd" ;;
    MINGW*|MSYS*|CYGWIN*) echo "windows" ;;
    *) echo "unknown" ;;
  esac
}

__is_remote() {
  [ -n "${SSH_CLIENT:-}" ] || [ -n "${SSH_TTY:-}" ] || [ -n "${SSH_CONNECTION:-}" ]
}

__has_display() {
  [ -n "${DISPLAY:-}" ] || [ -n "${WAYLAND_DISPLAY:-}" ]
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Core helper functions
__cmd_exists() { command -v "$1" >/dev/null 2>&1; }

__is_running() {
  local proc="$1"
  case "$(__get_os)" in
    mac) pgrep -x "$proc" >/dev/null 2>&1 ;;
    windows) tasklist 2>/dev/null | grep -qi "$proc" ;;
    *) pgrep -x "$proc" >/dev/null 2>&1 || pgrep -f "$proc" >/dev/null 2>&1 ;;
  esac
}

__printf_color() {
  local color="${2:-0}"
  printf "\033[0;%sm%s\033[0m\n" "$color" "$1"
}
__printf_red() { __printf_color "$1" "31"; }
__printf_green() { __printf_color "$1" "32"; }
__printf_yellow() { __printf_color "$1" "33"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Smart notifications
__notifications() {
  local title="$1" msg="$2"

  # Remote/no display - just print to stderr
  if __is_remote || ! __has_display; then
    printf "[%s] %s\n" "$title" "$msg" >&2
    return 0
  fi

  # GUI notifications based on OS
  case "$(__get_os)" in
    mac)
      osascript -e "display notification \"$msg\" with title \"$title\"" 2>/dev/null && return 0
      ;;
    linux|bsd)
      if __cmd_exists notify-send; then
        notify-send "$title" "$msg" 2>/dev/null && return 0
      fi
      ;;
    windows)
      if __cmd_exists powershell.exe; then
        powershell.exe -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('$msg', '$title')" 2>/dev/null && return 0
      fi
      ;;
  esac

  # Fallback
  printf "[%s] %s\n" "$title" "$msg" >&2
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Version and help
__version() { echo "$PROG $VERSION"; }

__help() {
  cat <<EOF
$PROG $VERSION - Polybar compton/picom status script

Usage: $PROG [options]

Options:
  -v, --version    Show version
  -h, --help       Show this help

Description:
  Displays status icon for polybar indicating whether compton/picom
  compositor is running. Green when running, gray when not.

Output:
  %{F#00AF02}ICON   - Green (compositor running)
  %{F#65737E}ICON   - Gray (compositor not running)
EOF
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main function
main() {
  local exitCode=0
  local COMPTON_ICON='  '

  # Parse options
  case "${1:-}" in
    -v|--version) __version; exit 0 ;;
    -h|--help) __help; exit 0 ;;
  esac

  # Check if compton or picom is running
  if pgrep -x "compton" &>/dev/null || pgrep -x "picom" &>/dev/null; then
    printf '%s\n' "%{F#00AF02}$COMPTON_ICON "  # Green
  else
    printf '%s\n' "%{F#65737E}$COMPTON_ICON "  # Gray
  fi

  return "${exitCode:-$?}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Execute
main "$@"
exit $?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
