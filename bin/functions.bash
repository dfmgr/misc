#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202207042253-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.pro
# @License       : WTFPL
# @ReadME        : fuctions.bash
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Thursday, Mar 11, 2021 06:53 EST
# @File          : fuctions.bash
# @Description   : Main functions file
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
PATH="/usr/local/opt/gnu-getopt/bin:$PATH"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
MYARGS="$*"
__search_dir() {
  # I'm sure there is a better way to do this
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
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
SET_DAY="$(date +'%d')"
SET_YEAR="$(date +'%Y')"
SET_MONTH="$(date +'%m')"
SET_HOUR="$(date +'%H')"
SET_MINUTE="$(date +'%M')"
SET_TIME="$(date +'%H:%M')"
SET_DATE="$(date +'%Y-%m-%d')"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# dont output
devnull() { tee >/dev/null 2>&1; }
devnull2() { "$@" 2>/dev/null; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# sudo
sudoif() { (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null && return 0 || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# commands
command() { builtin command ${1+"$@"}; }
type() { builtin type ${1+"$@"}; }
mkd() { devnull mkdir -p "$@"; }
rm_rf() { devnull rm -Rf "$@"; }
cp_rf() { if [ -e "$1" ]; then devnull cp -Rfa "$@"; fi; }
mv_f() { if [ -e "$1" ]; then devnull mv -f "$@"; fi; }
ln_rm() { devnull find "${1:-$HOME}" -xtype l -delete; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__am_i_online() { ping -c 1 "${1:-1.1.1.1}" >/dev/null 2>&1 || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__cmd_exists() { builtin type "$1" >/dev/null 2>&1 || builtin command -v "$1" >/dev/null 2>&1 || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ln_sf() {
  devnull ln -sf "$@"
  ln_rm "${1:-$HOME}"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
cd_into() { pushd "$1" >/dev/null 2>&1 || printf_return "Failed to cd into $1" 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# colorize
if [ "$SHOW_RAW" = "true" ]; then
  printf_color() { printf '%b' "$1" | tr -d ''; }
  __printf_color() { printf_color "$1"; }
else
  __printf_color() { printf_color "$1" "$2"; }
  printf_color() {
    printf "%b" "$(tput setaf "$2" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"
  }
fi
printf_normal() { printf_color "$1\n" "$2"; }
printf_green() { printf_color "$1\n" 2; }
printf_red() { printf_color "$1\n" 1; }
printf_purple() { printf_color "$1\n" 5; }
printf_yellow() { printf_color "$1\n" 3; }
printf_blue() { printf_color "$1\n" 4; }
printf_cyan() { printf_color "$1\n" 6; }
printf_info() { printf_color "[ ℹ️  ] $1\n" 3; }
printf_read() { printf_color "$1" 5; }
printf_success() { printf_color "[ ✔ ] $1\n" 2; }
printf_error() { printf_color "[ ✖ ] $1 $2\n" 1; }
printf_warning() { printf_color "[ ❗ ] $1\n" 3; }
printf_question() { printf_color "[ ❓ ] $1 " 6; }
printf_error_stream() { while read -r line; do printf_error "↳ ERROR: $line"; done; }
printf_execute_success() { printf_color "[ ✔ ] $1 [ ✔ ] \n" 2; }
printf_execute_error() { printf_color "[ ✖ ] $1 $2 [ ✖ ] \n" 1; }
printf_execute_error_stream() { while read -r line; do printf_execute_error "↳ ERROR: $line"; done; }
printf_help() { printf_blue "$*"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_debug() {
  printf_yellow "Running in debug mode "
  for d in "$@"; do
    echo "$d" | printf_readline "5"
  done
  exit 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_pause() {
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="5"
  local msg="${*:-Press any key to continue}"
  printf_color "$msg " "$color"
  read -r -n 1 -s
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
printf_custom() {
  [[ $1 == ?(-)+([0-9]) ]] && local color="$1" && shift 1 || local color="3"
  local msg="$*"
  shift
  printf_color "$msg" "$color"
  printf "\n"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_return() {
  [[ $1 == ?(-)+([0-9]) ]] && local color="$1" && shift 1 || local color="3"
  [[ $1 == ?(-)+([0-9]) ]] && local exit="$1" && shift 1 || local exit="1"
  printf_color "$1\n" "$color" && return $exit
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_exit() {
  [[ $1 == ?(-)+([0-9]) ]] && local color="$1" && shift 1 || local color="3"
  [[ $1 == ?(-)+([0-9]) ]] && local exit="$1" && shift 1 || local exit="1"
  printf_color "$1\n" "$color" && exit $exit
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_custom_question() {
  [[ $1 == ?(-)+([0-9]) ]] && local color="$1" && shift 1 || local color="3"
  local msg="$*"
  shift
  printf_color "$msg" "$color"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
printf_read() {
  set -o pipefail
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="6"
  while read line; do
    printf_color "$line" "$color"
  done
  printf "\n"
  set +o pipefail
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
printf_column() {
  local -a column=""
  set -o pipefail
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="7"
  cat - | column | printf_readline "${color:-$COLOR}"
  printf "\n"
  set +o pipefail
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
return_error() {
  printf '%s' "$*"
  printf '\n'
  return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# get description for help
get_desc() {
  local PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin"
  local appname="$SRC_DIR/${PROG:-$APPNAME}"
  local desc="$(grep_head "Description" "$appname" | head -n1 | sed 's#..* : ##g')"
  [ -n "$desc" ] && printf '%s' "$desc" || printf '%s' "$appname help"
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# display help
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
# grep header
sed_remove_empty() { sed '/^\#/d;/^$/d;s#^ ##g'; }
sed_head_remove() { awk -F'  :' '{print $2}'; }
sed_head() { sed -E 's|^.*#||g;s#^ ##g;s|^@||g'; }
grep_head() { grep -sE '[".#]?@[A-Z]' "${2:-$command}" | grep "${1:-}" | head -n 12 | sed_head | sed_remove_empty | grep '^' || return 1; }
grep_head_remove() { grep -sE '[".#]?@[A-Z]' "${2:-$command}" | grep "${1:-}" | grep -Ev 'GEN_SCRIPTS_*|\${|\$\(' | sed_head_remove | sed '/^\#/d;/^$/d;s#^ ##g' | grep '^' || return 1; }
grep_version() { grep_head ''${1:-Version}'' "${2:-$command}" | sed_head | sed_head_remove | sed_remove_empty | head -n1 | grep '^'; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# display version
app_version() {
  local prog="${PROG:-$APPNAME}"              # get from file
  local name="$(basename "${1:-$prog}")"      # get from os
  local appname="${prog:-$name}"              # figure out wich one
  local filename="$SRC_DIR/${PROG:-$APPNAME}" # get filename
  if [ -f "$filename" ]; then                 # check for file
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
notify_good() {
  local prog="${PROG:-$APPNAME}"
  local name="${1:-$(basename $0)}"
  local message="${*:-Command was successfull}"
  notifications "${prog:-$name}:" "$message"
  printf_green "${prog:-$name}: $message"
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
notify_error() {
  local prog="${PROG:-$APPNAME}"
  local name="${1:-$(basename $0)}"
  local message="${*:-Command has failed}"
  notifications "${prog:-$name}:" "$message"
  printf_red "${prog:-$name}: $message"
  return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ask question and execute
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
# show a spinner while executing code or zenity
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
__dirname() { cd "$1" 2>/dev/null && pwd || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__is_dir() { echo "${1:-/}" | grep -q "^${2:-/}$" && return 1 || return 0; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__git_porcelain_count() {
  [ -d "$(__git_top_dir "${1:-.}")/.git" ] &&
    [ "$(git -C "${1:-.}" status --porcelain 2>/dev/null | wc -l 2>/dev/null)" -eq "0" ] &&
    return 0 || return 1
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__git_porcelain() { __git_porcelain_count "${1:-.}" && return 0 || return 1; }
__git_top_dir() { git -C "${1:-.}" rev-parse --show-toplevel 2>/dev/null | grep -v fatal && return 0 || echo "${1:-$PWD}"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
unset SEARCH_DIR SEARCH_FILE ARGS opts
