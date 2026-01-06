#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202601061012-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.pro
# @License       : WTFPL
# @ReadME        : functions.bash
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Thursday, Mar 11, 2021 06:53 EST
# @File          : functions.bash
# @Description   : Main functions file - sourced by other scripts
# @Changelog     : Refactored for self-contained operation
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Script variables
PROG="functions.bash"
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
# Path setup
PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Argument helpers
MYARGS="$*"
__search_dir() {
  while :; do
    ARGS="$MYARGS"
    for opt in $ARGS; do
      if [ -d "$opt" ]; then
        SEARCH_DIR="$opt"
        shift 1
        break 2
      fi
      shift 1
      [ $# -ne 0 ] || break 2
    done
  done
  SET_DIR="$SEARCH_DIR"
}

__search_file() {
  while :; do
    ARGS="$MYARGS"
    for opt in $ARGS; do
      if [ -f "$opt" ]; then
        SEARCH_FILE="$opt"
        shift 1
        break 2
      fi
      shift 1
      [ $# -ne 0 ] || break 2
    done
  done
  SET_FILE="$SEARCH_FILE"
}

SET_ARGS="$MYARGS"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Date variables - optimized single date call
_DATE_INFO="$(date +'%d %Y %m %H %M %H:%M %Y-%m-%d')"
read -r SET_DAY SET_YEAR SET_MONTH SET_HOUR SET_MINUTE SET_TIME SET_DATE <<< "$_DATE_INFO"
unset _DATE_INFO
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Output redirection
devnull() { "$@" >/dev/null 2>&1; }
devnull2() { "$@" 2>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Sudo check
sudoif() { (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null && return 0 || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Command wrappers
command() { builtin command ${1+"$@"}; }
type() { builtin type ${1+"$@"}; }
mkd() { devnull mkdir -p "$@"; }
rm_rf() { devnull rm -Rf "$@"; }
cp_rf() { if [ -e "$1" ]; then devnull cp -Rfa "$@"; fi; }
mv_f() { if [ -e "$1" ]; then devnull mv -f "$@"; fi; }
ln_rm() { [ -d "${1:-$HOME}" ] && find "${1:-$HOME}" -maxdepth 3 -xtype l -delete 2>/dev/null; }
ln_sf() {
  devnull ln -sf "$@"
  ln_rm "${1:-$HOME}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Network check
__am_i_online() { ping -c 1 "${1:-1.1.1.1}" >/dev/null 2>&1 || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Command existence (exported version)
cmd_exists() {
  local check_error=""
  [ "$1" = "--error" ] && check_error=true && shift
  if builtin type "$1" >/dev/null 2>&1 || builtin command -v "$1" >/dev/null 2>&1; then
    return 0
  else
    [ -n "$check_error" ] && __printf_red "Error: $1 is required but not found"
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Directory operations
cd_into() { pushd "$1" >/dev/null 2>&1 || printf_return "Failed to cd into $1" 1; }
__dirname() { cd "$1" 2>/dev/null && pwd || return 1; }
__is_dir() { echo "${1:-/}" | grep -q "^${2:-/}$" && return 1 || return 0; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Colorized output functions
if [ "$SHOW_RAW" = "true" ]; then
  printf_color() { printf '%b' "$1" | tr -d ''; }
else
  printf_color() {
    printf "%b" "$(tput setaf "$2" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"
  }
fi

printf_normal() { printf_color "$1\n" "$2"; }
printf_green() { printf_color "$1\n" 10; }
printf_red() { printf_color "$1\n" 9; }
printf_purple() { printf_color "$1\n" 13; }
printf_yellow() { printf_color "$1\n" 11; }
printf_blue() { printf_color "$1\n" 12; }
printf_cyan() { printf_color "$1\n" 14; }
printf_info() { printf_color "[ i ] $1\n" 11; }
printf_read() { printf_color "$1" 13; }
printf_success() { printf_color "[ OK ] $1\n" 10; }
printf_error() { printf_color "[ ERROR ] $1 $2\n" 9; }
printf_warning() { printf_color "[ WARN ] $1\n" 11; }
printf_question() { printf_color "[ ? ] $1 " 14; }
printf_error_stream() { while read -r line; do printf_error "ERROR: $line"; done; }
printf_execute_success() { printf_color "[ OK ] $1 [ OK ] \n" 2; }
printf_execute_error() { printf_color "[ ERROR ] $1 $2 [ ERROR ] \n" 1; }
printf_execute_error_stream() { while read -r line; do printf_execute_error "ERROR: $line"; done; }
printf_help() { printf_blue "$*"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Debug output
printf_debug() {
  printf_yellow "Running in debug mode "
  for d in "$@"; do
    echo "$d" | printf_readline "5"
  done
  exit 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Pause prompt
printf_pause() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="5"
  local msg="${*:-Press any key to continue}"
  printf_color "$msg " "$color"
  read -r -n 1 -s
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Directory creation prompt
printf_mkdir() {
  [ -n "$1" ] || return 1
  if ask_confirm "$1 doesn't exist should i create it?" "mkdir -p $1"; then
    true
  else
    printf_red "$1 doesn't seem to be a directory"
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Yes/No question in terminal
printf_question_term() {
  printf_question "$* [yN] "
  read -r -n 1 REPLY
  printf "\n"
  if [[ "$REPLY" == "y" || "$REPLY" == "Y" ]]; then
    return 0
  else
    return 1
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Custom color output
printf_custom() {
  [[ $1 == ?(-)+([0-9]) ]] && local color="$1" && shift 1 || local color="3"
  local msg="$*"
  shift
  printf_color "$msg" "$color"
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Return with message
printf_return() {
  [[ $1 == ?(-)+([0-9]) ]] && local color="$1" && shift 1 || local color="3"
  [[ $1 == ?(-)+([0-9]) ]] && local exit="$1" && shift 1 || local exit="1"
  printf_color "$1\n" "$color" && return $exit
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Exit with message
printf_exit() {
  [[ $1 == ?(-)+([0-9]) ]] && local color="$1" && shift 1 || local color="3"
  [[ $1 == ?(-)+([0-9]) ]] && local exit="$1" && shift 1 || local exit="1"
  printf_color "$1\n" "$color" && exit $exit
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Custom question output
printf_custom_question() {
  [[ $1 == ?(-)+([0-9]) ]] && local color="$1" && shift 1 || local color="3"
  local msg="$*"
  shift
  printf_color "$msg" "$color"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Read line coloring
printf_readline() {
  set -o pipefail
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="6"
  while read line; do
    printf_color "$line" "$color"
    printf "\n"
  done
  set +o pipefail
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Column output
printf_column() {
  local -a column=""
  set -o pipefail
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="7"
  cat - | column | printf_readline "${color:-$COLOR}"
  printf "\n"
  set +o pipefail
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Return error
return_error() {
  printf '%s' "$*"
  printf '\n'
  return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Get description from script header
get_desc() {
  local PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
  local appname="$SRC_DIR/${PROG:-$APPNAME}"
  local desc="$(grep_head "Description" "$appname" | head -n1 | sed 's#..* : ##g')"
  [ -n "$desc" ] && printf '%s' "$desc" || printf '%s' "$appname help"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Help display
app_help() {
  printf "\n"
  local set_desc="$(get_desc)"
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="4"
  local msg1="$1" && shift 1
  local msg2="$1" && shift 1 || msg2=
  local msg3="$1" && shift 1 || msg3=
  local msg4="$1" && shift 1 || msg4=
  local msg5="$1" && shift 1 || msg5=
  local msg6="$1" && shift 1 || msg6=
  local msg7="$1" && shift 1 || msg7=
  local msg8="$1" && shift 1 || msg8=
  local msg9="$1" && shift 1 || msg9=
  local msg10="$1" && shift 1 || msg10=
  local msg11="$1" && shift 1 || msg11=
  local msg12="$1" && shift 1 || msg12=
  local msg13="$1" && shift 1 || msg13=
  local msg14="$1" && shift 1 || msg14=
  local msg15="$1" && shift 1 || msg15=
  local msg16="$1" && shift 1 || msg16=
  local msg17="$1" && shift 1 || msg17=
  local msg18="$1" && shift 1 || msg18=
  local msg19="$1" && shift 1 || msg19=
  local msg20="$1" && shift 1 || msg20=
  shift $#
  if [ -n "${PROG:-$APPNAME}" ] && [ -n "$set_desc" ]; then
    printf_purple "$set_desc"
  fi
  [ -z "$msg1" ] || printf_color "$msg1\n" "$color"
  [ -z "$msg2" ] || printf_color "$msg2\n" "$color"
  [ -z "$msg3" ] || printf_color "$msg3\n" "$color"
  [ -z "$msg4" ] || printf_color "$msg4\n" "$color"
  [ -z "$msg5" ] || printf_color "$msg5\n" "$color"
  [ -z "$msg6" ] || printf_color "$msg6\n" "$color"
  [ -z "$msg7" ] || printf_color "$msg7\n" "$color"
  [ -z "$msg8" ] || printf_color "$msg8\n" "$color"
  [ -z "$msg9" ] || printf_color "$msg9\n" "$color"
  [ -z "$msg10" ] || printf_color "$msg10\n" "$color"
  [ -z "$msg11" ] || printf_color "$msg11\n" "$color"
  [ -z "$msg12" ] || printf_color "$msg12\n" "$color"
  [ -z "$msg13" ] || printf_color "$msg13\n" "$color"
  [ -z "$msg14" ] || printf_color "$msg14\n" "$color"
  [ -z "$msg15" ] || printf_color "$msg15\n" "$color"
  [ -z "$msg16" ] || printf_color "$msg16\n" "$color"
  [ -z "$msg17" ] || printf_color "$msg17\n" "$color"
  [ -z "$msg18" ] || printf_color "$msg18\n" "$color"
  [ -z "$msg19" ] || printf_color "$msg19\n" "$color"
  [ -z "$msg20" ] || printf_color "$msg20\n" "$color"
  printf "\n"
  exit "${exitCode:-1}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Header grep utilities
sed_remove_empty() { sed '/^\#/d;/^$/d;s#^ ##g'; }
sed_head_remove() { awk -F'  :' '{print $2}'; }
sed_head() { sed -E 's|^.*#||g;s#^ ##g;s|^@||g'; }
grep_head() { grep -sE '[".#]?@[A-Z]' "${2:-$command}" | grep "${1:-}" | head -n 12 | sed_head | sed_remove_empty | grep '^' || return 1; }
grep_head_remove() { grep -sE '[".#]?@[A-Z]' "${2:-$command}" | grep "${1:-}" | grep -Ev 'GEN_SCRIPTS_*|\${|\$\(' | sed_head_remove | sed '/^\#/d;/^$/d;s#^ ##g' | grep '^' || return 1; }
grep_version() { grep_head ''${1:-Version}'' "${2:-$command}" | sed_head | sed_head_remove | sed_remove_empty | head -n1 | grep '^'; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Version display
app_version() {
  local prog="${PROG:-$APPNAME}"
  local name="$(basename "${1:-$prog}")"
  local appname="${prog:-$name}"
  local filename="$SRC_DIR/${PROG:-$APPNAME}"
  if [ -f "$filename" ]; then
    printf "\n"
    printf_green "Getting info for $appname"
    grep_head "Version" "$filename" >/dev/null 2>&1 &&
      grep_head '' "$filename" | printf_readline "3" &&
      printf_green "$(grep_head "Version" "$filename" | head -n1)" ||
      printf_return "${filename:-File} was found, however, No information was provided"
  else
    printf_red "$filename was not found"
    exitCode=1
  fi
  printf "\n"
  exit "${exitCode:-$?}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check local file type
check_local() {
  local showv=""
  [[ "$1" = -s ]] && shift 1 && showv=true
  local file="${1:-$PWD}"
  if [ -d "$file" ]; then
    type="dir"
    localfile="true"
    exitCode=0
  elif [ -f "$file" ]; then
    type="file"
    localfile="true"
    exitCode=0
  elif [ -L "$file" ]; then
    type="symlink"
    localfile="true"
    exitCode=0
  elif [ -S "$file" ]; then
    type="socket"
    localfile="true"
    exitCode=0
  elif [ -b "$file" ]; then
    type="block"
    localfile="true"
    exitCode=0
  elif [ -p "$file" ]; then
    type="pipe"
    localfile="true"
    exitCode=0
  elif [ -c "$file" ]; then
    type="character"
    localfile="true"
    exitCode=0
  elif [ -e "$file" ]; then
    type="file"
    localfile="true"
    exitCode=0
  else
    type=""
    localfile=""
    exitCode=1
  fi
  [ -n "$showv" ] || echo "$type"
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Check URI type
check_uri() {
  local showv=""
  [[ "$1" = -s ]] && shift 1 && showv=true
  local url="$1"
  if echo "$url" | grep -q "http.*://\S\+\.[A-Za-z]\+\S*"; then
    uri="http"
    exitCode=0
  elif echo "$url" | grep -q "ftp.*://\S\+\.[A-Za-z]\+\S*"; then
    uri="ftp"
    exitCode=0
  elif echo "$url" | grep -q "git.*://\S\+\.[A-Za-z]\+\S*"; then
    uri="git"
    exitCode=0
  elif echo "$url" | grep -q "ssh.*://\S\+\.[A-Za-z]\+\S*"; then
    uri="ssh"
    exitCode=0
  else
    uri=""
    exitCode=1
  fi
  [ -n "$showv" ] || echo "$uri"
  return ${exitCode:-$?}
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Notification helpers
notify_good() {
  local prog="${PROG:-$APPNAME}"
  local name="${1:-$(basename $0)}"
  local message="${*:-Command was successful}"
  __notifications "${prog:-$name}:" "$message"
  printf_green "${prog:-$name}: $message"
  return 0
}

notify_error() {
  local prog="${PROG:-$APPNAME}"
  local name="${1:-$(basename $0)}"
  local message="${*:-Command has failed}"
  __notifications "${prog:-$name}:" "$message"
  printf_red "${prog:-$name}: $message"
  return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Confirmation prompt
ask_confirm() {
  local question="${1:-Continue}"
  local command="${2:-true}"
  if [ -f "$(type -P ask_yes_no_question)" ]; then
    ask_yes_no_question "$question" "$command" "${APPNAME:-$PROG}"
  else
    __zenity() { zenity --question --text="$1" --ellipsize --default-cancel && $2 || return 1; }
    __dmenu() { [ "$(printf "No\\nYes" | dmenu -i -p "$1" -nb darkred -sb red -sf white -nf gray)" = "Yes" ] && ${2:-true} || return 1; }
    __rofi() { [ "$(printf "No\\nYes" | rofi -dmenu -i -p "$1" -nb darkred -sb red -sf white -nf gray)" = "Yes" ] && ${2:-true} || return 1; }
    __dialog() { gdialog --trim --cr-wrap --colors --title "question" --yesno "$1" 15 40 && "$2" || return 1; }
    __term() { printf_question_term "$1" && $2 || return 1; }
    if [ -n "$DESKTOP_SESSION" ] || [ -n "$DISPLAY" ]; then
      if [ -f "$(command -v zenity 2>/dev/null)" ]; then
        __zenity "$question" "$command" && notify_good || notify_error
      elif [ -f "$(command -v rofi 2>/dev/null)" ]; then
        __rofi "$question" "$command" && notify_good || notify_error
      elif [ -f "$(command -v dmenu 2>/dev/null)" ]; then
        __dmenu "$question" "$command" && notify_good || notify_error
      elif [ -f "$(command -v gdialog 2>/dev/null)" ]; then
        __dialog "$question" "$command" && notify_good || notify_error
      else
        __term "$question" "$command" || notify_error
      fi
    else
      if [ -t 0 ]; then
        export -f __term notify_error
        __term "$question" "$command" || notify_error
      else
        __term "$question" "$command" || notify_error
      fi
    fi
    return ${exitCode:-$?}
  fi
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Execute with spinner or zenity progress
if [ -f "$(command -v zenity 2>/dev/null)" ] && [ -n "$DESKTOP_SESSION" ]; then
  execute() {
    local CMD="$1" && shift $#
    eval $CMD | zenity --progress --no-cancel --pulsate --auto-close --title="${title:-Attempting install}" --text="${text:-Trying to install}" --height=200 --width=400 || printf_readline "5"
  }
else
  execute() {
    __set_trap() { trap -p "$1" | grep "$2" >/dev/null 2>&1 || trap '$2' "$1"; }
    __kill_all_subprocesses() {
      local i=""
      for i in $(jobs -p); do
        kill "$i"
        wait "$i" >/dev/null 2>&1
      done
    }
    __show_spinner() {
      local -r FRAMES='/-\|'
      local -r NUMBER_OR_FRAMES=${#FRAMES}
      local -r CMDS="$2"
      local -r MSG="$3"
      local -r PID="$1"
      local i=0
      local frameText=""
      while kill -0 "$PID" >/dev/null 2>&1; do
        frameText="                [${FRAMES:i++%NUMBER_OR_FRAMES:1}] $MSG"
        printf "%s" "$frameText"
        sleep 0.2
        printf "\r"
      done
    }
    local -r CMDS="$1"
    local -r MSG="${2:-$1}"
    local -r TMP_FILE="$(mktemp /tmp/XXXXX)"
    local exitCode=0
    local cmdsPID=""
    __set_trap "EXIT" "__kill_all_subprocesses"
    eval "$CMDS" >/dev/null 2>"$TMP_FILE" &
    cmdsPID=$!
    __show_spinner "$cmdsPID" "$CMDS" "$MSG"
    wait "$cmdsPID" >/dev/null 2>&1
    exitCode=$?
    printf_execute_result $exitCode "$MSG"
    if [ $exitCode -ne 0 ]; then
      printf_execute_error_stream <"$TMP_FILE"
    fi
    rm -rf "$TMP_FILE"
    return ${exitCode:-$?}
  }
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Git utilities
__git_porcelain_count() {
  [ -d "$(__git_top_dir "${1:-.}")/.git" ] &&
    [ -z "$(git -C "${1:-.}" status --porcelain 2>/dev/null)" ] &&
    return 0 || return 1
}

__git_porcelain() { __git_porcelain_count "${1:-.}" && return 0 || return 1; }

__git_top_dir() {
  local check_dir="${1:-.}"
  if [ "$_GIT_TOPDIR_CACHE_PWD" != "$check_dir" ]; then
    _GIT_TOPDIR_CACHE_PWD="$check_dir"
    _GIT_TOPDIR_CACHE="$(git -C "$check_dir" rev-parse --show-toplevel 2>/dev/null | grep -v fatal || echo "${1:-$PWD}")"
  fi
  echo "$_GIT_TOPDIR_CACHE"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Alias for notifications (backward compatibility)
notifications() { __notifications "$@"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Option listing helpers
__list_options() {
  local dir="$1"
  [ -d "$dir" ] || mkdir -p "$dir"
  echo "$SHORTOPTS" | tr ',' '\n' | sed 's/:$//' > "$dir/options"
  echo "$LONGOPTS" | tr ',' '\n' | sed 's/:$//' >> "$dir/options"
}

__list_array() {
  local dir="$1"
  local array="$2"
  [ -d "$dir" ] || mkdir -p "$dir"
  echo "$array" > "$dir/array"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Cleanup
unset SEARCH_DIR SEARCH_FILE ARGS opts
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
