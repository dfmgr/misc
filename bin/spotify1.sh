#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202601061012-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.pro
# @License       : WTFPL
# @ReadME        : spotify1.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Thursday, Mar 11, 2021 18:25 EST
# @File          : spotify1.sh
# @Description   : Spotify polybar script - displays now playing info
# @Changelog     : Refactored for self-contained operation
# @TODO          :
# @Other         :
# @Resource      : https://github.com/NicholasFeldman/dotfiles/blob/master/polybar/.config/polybar/spotify.sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Script variables
PROG="spotify1.sh"
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
# Get Spotify metadata via D-Bus
__get_spotify_metadata() {
  local domain="org.mpris.MediaPlayer2"
  local meta

  meta=$(dbus-send --print-reply --dest=${domain}.spotify \
    /org/mpris/MediaPlayer2 \
    org.freedesktop.DBus.Properties.Get \
    string:${domain}.Player string:Metadata 2>/dev/null)

  echo "$meta"
}

__get_artist() {
  local meta="$1"
  echo "$meta" | sed -nr '/xesam:artist"/,+2s/^ +string "(.*)"$/\1/p' | tail -1 | sed "s/\&/+/g"
}

__get_album() {
  local meta="$1"
  echo "$meta" | sed -nr '/xesam:album"/,+2s/^ +variant +string "(.*)"$/\1/p' | tail -1
}

__get_title() {
  local meta="$1"
  echo "$meta" | sed -nr '/xesam:title"/,+2s/^ +variant +string "(.*)"$/\1/p' | tail -1 | sed "s/\&/+/g"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Version and help
__version() { echo "$PROG $VERSION"; }

__help() {
  cat <<EOF
$PROG $VERSION - Spotify polybar script

Usage: $PROG [options] [format]

Options:
  -v, --version    Show version
  -h, --help       Show this help

Format:
  Default format: %artist% - %title%
  Available placeholders:
    %artist%   - Artist name
    %title%    - Track title
    %album%    - Album name

Examples:
  $PROG                           # Output: Artist - Title
  $PROG "%artist% - %title%"      # Output: Artist - Title
  $PROG "%title% by %artist%"     # Output: Title by Artist
  $PROG "%artist% - %album%"      # Output: Artist - Album

Notes:
  Requires Spotify to be running with D-Bus support.
  Designed for use with polybar or similar status bars.
EOF
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main function
main() {
  local exitCode=0

  # Parse options
  case "${1:-}" in
    -v|--version) __version; exit 0 ;;
    -h|--help) __help; exit 0 ;;
  esac

  # Check if Spotify is running
  if ! __is_running spotify; then
    __printf_red "Spotify doesn't seem to be running"
    exit 1
  fi

  # Check for dbus-send
  if ! __cmd_exists dbus-send; then
    __printf_red "Error: dbus-send command not found"
    exit 1
  fi

  # Get metadata
  local meta artist album title format output
  meta=$(__get_spotify_metadata)

  if [ -z "$meta" ]; then
    __printf_red "Error: Could not retrieve Spotify metadata"
    exit 1
  fi

  artist=$(__get_artist "$meta")
  album=$(__get_album "$meta")
  title=$(__get_title "$meta")

  # Format output
  format="${*:-%artist% - %title%}"
  output=$(echo "$format" | sed "s/%artist%/$artist/g;s/%title%/$title/g;s/%album%/$album/g" | sed 's/&/\\&/g')

  echo "$output"
  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Execute
main "$@"
exit $?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
