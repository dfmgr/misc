#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202601061012-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.pro
# @License       : WTFPL
# @ReadME        : tempcores.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Thursday, Mar 11, 2021 18:32 EST
# @File          : tempcores.sh
# @Description   : Get information from cores temp thanks to sensors
# @Changelog     : Refactored for self-contained operation
# @TODO          :
# @Other         :
# @Resource      : https://github.com/jaagr/polybar/wiki/User-contributed-modules#per-core-temperatures
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Script variables
PROG="tempcores.sh"
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
# Temperature thresholds and colors
TEMP_VALUES=(140 150 160 170 180 190)
TEMP_COLORS=("#6bff49" "#f4cb24" "#ff8819" "#ff3205" "#f40202" "#ef02db")
TEMP_ICONS=(     )
DEGREE="F"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check if polybar is running for formatting
__in_polybar() {
  __is_running polybar
}

# Get temperature color based on value
__get_temp_color() {
  local temp="$1"
  local i
  for i in "${!TEMP_VALUES[@]}"; do
    if ((temp < TEMP_VALUES[i])); then
      echo "${TEMP_COLORS[$i]}"
      return 0
    fi
  done
  echo "${TEMP_COLORS[-1]}"
}

# Get temperature icon based on value
__get_temp_icon() {
  local temp="$1"
  local i
  for i in "${!TEMP_VALUES[@]}"; do
    if ((temp < TEMP_VALUES[i])); then
      echo "${TEMP_ICONS[$i]}"
      return 0
    fi
  done
  echo "${TEMP_ICONS[-1]}"
}

# Format temperature for output
__format_temp() {
  local temp="$1"
  local color icon

  if __in_polybar; then
    color=$(__get_temp_color "$temp")
    printf "%%{F%s}%s%s%%{F-}" "$color" "$temp" "$DEGREE"
  else
    printf "%s%s" "$temp" "$DEGREE"
  fi
}

# Format icon for output
__format_icon() {
  local temp="$1"
  local color icon

  icon=$(__get_temp_icon "$temp")
  if __in_polybar; then
    color=$(__get_temp_color "$temp")
    printf "%%{F%s}%s%%{F-}" "$color" "$icon"
  else
    printf "%s" "$icon"
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Version and help
__version() { echo "$PROG $VERSION"; }

__help() {
  cat <<EOF
$PROG $VERSION - Get CPU core temperatures

Usage: $PROG [options]

Options:
  -v, --version    Show version
  -h, --help       Show this help

Output:
  Displays CPU core temperature with color coding.
  When polybar is running, output includes polybar formatting.

Temperature Thresholds (Fahrenheit):
  < 140F  - Green (cool)
  < 150F  - Yellow (warm)
  < 160F  - Orange (hot)
  < 170F  - Red (very hot)
  < 180F  - Dark red (critical)
  >= 190F - Magenta (danger)

Requirements:
  - lm_sensors (sensors command)

Examples:
  $PROG              # Show current temperature
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

  # Check for sensors command
  if ! __cmd_exists sensors; then
    __printf_red "Error: sensors command not found"
    __printf_yellow "Install lm_sensors package"
    exit 1
  fi

  # Get raw temperature data
  local rawData
  rawData=$(sensors -f 2>/dev/null | grep -m 1 Core | awk '{print substr($3, 2, length($3)-5)}')

  if [ -z "$rawData" ]; then
    printf '%s\n' "No sensor data was found"
    exit 1
  fi

  # Parse temperature values into array
  local tempCore=($rawData)
  local total=0
  local finalEcho=""

  # Process each core temperature
  for temp in "${tempCore[@]}"; do
    finalEcho=$(__format_temp "$temp")
    total=$((temp + total))
  done

  # Calculate average temperature
  local avg=$((total / ${#tempCore[@]}))
  local icon
  icon=$(__format_icon "$avg")

  # Output: icon followed by temperature
  echo -e "$icon $finalEcho"

  return $exitCode
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Execute
main "$@"
exit $?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
