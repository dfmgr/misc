#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202601061012-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.pro
# @License       : WTFPL
# @ReadME        : pavolume.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Thursday, Mar 11, 2021 11:51 EST
# @File          : pavolume.sh
# @Description   : Finds the active sink for pulse audio and increments the volume
# @Changelog     : Refactored for self-contained operation
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Script variables
PROG="pavolume.sh"
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
$PROG $VERSION - PulseAudio volume control

Usage: $PROG [options]

Options:
  -v, --version    Show version
  -h, --help       Show this help
  --up             Increase volume
  --down           Decrease volume
  --togmute        Toggle mute
  --mute           Mute audio
  --unmute         Unmute audio
  --sync           Sync all sink inputs to current volume
  --listen         Listen for events (for status bars)

Description:
  Finds the active sink for PulseAudio and controls volume.
  By default, outputs current volume status.

Examples:
  $PROG --up        Increase volume by 2%
  $PROG --down      Decrease volume by 2%
  $PROG --togmute   Toggle mute state
  $PROG             Show current volume
EOF
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Volume control helper functions
__qdbus() { [ -f "$(command -v qdbus)" ] && qdbus "$@" || true; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Main function
main() {
  # Parse options
  case "${1:-}" in
    -v|--version) __version; exit 0 ;;
    -h|--help) __help; exit 0 ;;
  esac

  # Check for required commands
  if ! __cmd_exists pactl || ! __cmd_exists pacmd; then
    __printf_red "Error: PulseAudio tools (pactl, pacmd) are not installed"
    exit 1
  fi

  # Configuration variables
  local osd='yes'
  local inc='2'
  local capvol='no'
  local maxvol='200'
  local autosync='yes'
  local curStatus="no"
  local active_sink=""
  local limit=$((100 - inc))
  local maxlimit=$((maxvol - inc))

  reloadSink() { active_sink=$(pacmd list-sinks | awk '/* index:/{print $3}'); }

  getCurVol() {
    curVol=$(pacmd list-sinks | grep -A 15 "index: $active_sink$" | grep 'volume:' | grep -E -v 'base volume:' | awk -F : '{print $3}' | grep -o -P '.{0,3}%' | sed s/.$// | tr -d ' ')
  }

  getSinkInputs() {
    input_array=$(pacmd list-sink-inputs | grep -B 4 "sink: $1 " | awk '/index:/{print $2}')
  }

  volSync() {
    getSinkInputs "$active_sink"
    getCurVol
    for each in $input_array; do
      pactl set-sink-input-volume "$each" "$curVol%"
    done
  }

  volUp() {
    getCurVol
    if [ "$capvol" = 'yes' ]; then
      if [ "$curVol" -le 100 ] && [ "$curVol" -ge "$limit" ]; then
        pactl set-sink-volume "$active_sink" -- 100%
      elif [ "$curVol" -lt "$limit" ]; then
        pactl set-sink-volume "$active_sink" -- "+$inc%"
      fi
    elif [ "$curVol" -le "$maxvol" ] && [ "$curVol" -ge "$maxlimit" ]; then
      pactl set-sink-volume "$active_sink" "$maxvol%"
    elif [ "$curVol" -lt "$maxlimit" ]; then
      pactl set-sink-volume "$active_sink" "+$inc%"
    fi

    getCurVol
    if [ "${osd}" = 'yes' ]; then
      __qdbus org.kde.kded /modules/kosd showVolume "$curVol" 0
    fi
    if [ "${autosync}" = 'yes' ]; then
      volSync
    fi
  }

  volDown() {
    pactl set-sink-volume "$active_sink" "-$inc%"
    getCurVol
    if [ "${osd}" = 'yes' ]; then
      __qdbus org.kde.kded /modules/kosd showVolume "$curVol" 0
    fi
    if [ "${autosync}" = 'yes' ]; then
      volSync
    fi
  }

  volMute() {
    case "$1" in
    mute)
      pactl set-sink-mute "$active_sink" 1
      curVol=0
      status=1
      ;;
    unmute)
      pactl set-sink-mute "$active_sink" 0
      getCurVol
      status=0
      ;;
    esac

    if [ "${osd}" = 'yes' ]; then
      __qdbus org.kde.kded /modules/kosd showVolume ${curVol} ${status}
    fi
  }

  volMuteStatus() {
    curStatus=$(pacmd list-sinks | grep -A 15 "index: $active_sink$" | awk '/muted/{ print $2}')
  }

  listen() {
    local firstrun=0
    pactl subscribe 2>/dev/null | {
      while true; do
        {
          if [ $firstrun -eq 0 ]; then
            firstrun=1
          else
            read -r event || break
            if ! echo "$event" | grep -e "on card" -e "on sink"; then
              continue
            fi
          fi
        } &>/dev/null
        output
      done
    }
  }

  output() {
    reloadSink
    getCurVol
    volMuteStatus
    if [ "${curStatus}" = 'yes' ]; then
      echo " $curVol%"
    else
      echo " $curVol%"
    fi
  }

  # Initialize sink
  reloadSink

  # Process commands
  case "${1:-}" in
    --up)
      volUp
      ;;
    --down)
      volDown
      ;;
    --togmute)
      volMuteStatus
      if [ "$curStatus" = 'yes' ]; then
        volMute unmute
      else
        volMute mute
      fi
      ;;
    --mute)
      volMute mute
      ;;
    --unmute)
      volMute unmute
      ;;
    --sync)
      volSync
      ;;
    --listen)
      listen
      ;;
    *)
      output
      ;;
  esac

  return $?
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Execute
main "$@"
exit $?
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
