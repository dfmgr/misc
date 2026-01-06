#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202601061012-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.pro
# @License       : WTFPL
# @ReadME        : pub-ip.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Thursday, Mar 11, 2021 12:19 EST
# @File          : pub-ip.sh
# @Description   : Get your public IP address
# @Changelog     : Refactored for self-contained operation
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Script variables
PROG="pub-ip.sh"
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
# Network helper functions
__am_i_online() {
  # Try multiple methods to check connectivity
  if __cmd_exists ping; then
    ping -c 1 -W 2 1.1.1.1 &>/dev/null && return 0
    ping -c 1 -W 2 8.8.8.8 &>/dev/null && return 0
  fi
  if __cmd_exists curl; then
    curl -q -LSsf --connect-timeout 2 http://ifconfig.co &>/dev/null && return 0
  fi
  if __cmd_exists wget; then
    wget -q --spider --timeout=2 http://ifconfig.co &>/dev/null && return 0
  fi
  return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Version and help
__version() { echo "$PROG $VERSION"; }

__help() {
  cat <<EOF
$PROG $VERSION - Get your public IP address

Usage: $PROG [options]

Options:
  -v, --version    Show version
  -h, --help       Show this help

Description:
  Retrieves your public IP address from ifconfig.co.
  If connected through a VPN (openvpn), it will prefix
  the IP with "VPN:".

Examples:
  $PROG              Show public IP
EOF
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main function
main() {
  # Parse options
  case "${1:-}" in
    -v|--version) __version; exit 0 ;;
    -h|--help) __help; exit 0 ;;
  esac

  # Check for curl
  if ! __cmd_exists curl; then
    __printf_red "Error: curl is not installed"
    exit 1
  fi

  # Check internet connectivity
  if ! __am_i_online; then
    __printf_red "No internet connection"
    return 1
  fi

  # Get public IP
  local IP
  IP=$(curl -q -4 -LSsf http://ifconfig.co/ip 2>/dev/null || echo '')

  if [ -n "$IP" ]; then
    if __is_running openvpn; then
      echo "VPN: $IP"
    else
      echo "$IP"
    fi
  else
    __printf_red "Failed to retrieve public IP"
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Execute
main "$@"
exit $?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
