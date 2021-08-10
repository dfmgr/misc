#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 031120210653-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
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

# dont output
devnull() { "$@" >/dev/null 2>&1; }
devnull2() { "$@" 2>/dev/null; }

# sudo
sudoif() { (sudo -vn && sudo -ln) 2>&1 | grep -v 'may not' >/dev/null && return 0 || return 1; }

# commands
command() { builtin command ${1+"$@"}; }
type() { builtin type ${1+"$@"}; }
notifications() {
  local notify="$(type -P notifications 2>/dev/null)"
  [ -n "$notify" ] && $notify "$@" || true
}
mkd() { devnull mkdir -p "$@"; }
rm_rf() { devnull rm -Rf "$@"; }
cp_rf() { if [ -e "$1" ]; then devnull cp -Rfa "$@"; fi; }
mv_f() { if [ -e "$1" ]; then devnull mv -f "$@"; fi; }
ln_rm() { devnull find "${1:-$HOME}" -xtype l -delete; }
ln_sf() {
  devnull ln -sf "$@"
  ln_rm "${1:-$HOME}"
}
cd_into() { pushd "$1" &>/dev/null || printf_return "Failed to cd into $1" 1; }
# colorize
printf_color() { printf "%b" "$(tput setaf "$2" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"; }
printf_normal() { printf_color "\t\t$1\n" "$2"; }
printf_green() { printf_color "\t\t$1\n" 2; }
printf_red() { printf_color "\t\t$1\n" 1; }
printf_purple() { printf_color "\t\t$1\n" 5; }
printf_yellow() { printf_color "\t\t$1\n" 3; }
printf_blue() { printf_color "\t\t$1\n" 4; }
printf_cyan() { printf_color "\t\t$1\n" 6; }
printf_info() { printf_color "\t\t[ ℹ️  ] $1\n" 3; }
printf_read() { printf_color "\t\t$1" 5; }
printf_success() { printf_color "\t\t[ ✔ ] $1\n" 2; }
printf_error() { printf_color "\t\t[ ✖ ] $1 $2\n" 1; }
printf_warning() { printf_color "\t\t[ ❗ ] $1\n" 3; }
printf_question() { printf_color "\t\t[ ❓ ] $1 " 6; }
printf_error_stream() { while read -r line; do printf_error "↳ ERROR: $line"; done; }
printf_execute_success() { printf_color "\t\t[ ✔ ] $1 [ ✔ ] \n" 2; }
printf_execute_error() { printf_color "\t\t[ ✖ ] $1 $2 [ ✖ ] \n" 1; }
printf_execute_error_stream() { while read -r line; do printf_execute_error "↳ ERROR: $line"; done; }
printf_help() { printf_blue "$*"; }

printf_debug() {
  printf_yellow "Running in debug mode "
  for d in "$@"; do
    echo "$d" | printf_readline "5"
  done
  exit 1
}

printf_mkdir() {
  [ -n "$1" ] || return 1
  if ask_confirm "$1 doesn't exist should i create it?" "mkdir -p $1"; then
    true
  else
    printf_red "$1 doesn't seem to be a directory"
    return 1
  fi
}

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

printf_custom() {
  [[ $1 == ?(-)+([0-9]) ]] && local color="$1" && shift 1 || local color="3"
  local msg="$*"
  shift
  printf_color "\t\t$msg" "$color"
  printf "\n"
}

printf_return() {
  [[ $1 == ?(-)+([0-9]) ]] && local color="$1" && shift 1 || local color="3"
  [[ $1 == ?(-)+([0-9]) ]] && local exit="$1" && shift 1 || local exit="1"
  printf_color "\t\t$1\n" "$color" && return $exit
}

printf_exit() {
  [[ $1 == ?(-)+([0-9]) ]] && local color="$1" && shift 1 || local color="3"
  [[ $1 == ?(-)+([0-9]) ]] && local exit="$1" && shift 1 || local exit="1"
  printf_color "\t\t$1\n" "$color" && exit $exit
}

printf_custom_question() {
  [[ $1 == ?(-)+([0-9]) ]] && local color="$1" && shift 1 || local color="3"
  local msg="$*"
  shift
  printf_color "\t\t$msg" "$color"
}

printf_read() {
  set -o pipefail
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="6"
  while read line; do
    printf_color "\t\t$line" "$color"
  done
  printf "\n"
  set +o pipefail
}

printf_readline() {
  set -o pipefail
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="6"
  while read line; do
    printf_color "\t\t$line" "$color"
    printf "\n"
  done
  set +o pipefail
}

printf_column() {
  set -o pipefail
  test -n "$1" && test -z "${1//[0-9]/}" && local color="$1" && shift 1 || local color="6"
  while read line; do
    printf_color "\t\t$line" "$color"
  done | column
  printf "\n"
  set +o pipefail
}

return_error() {
  printf '%s' "$*"
  printf '\n'
  return 1
}

# get description for help
get_desc() {
  local PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/usr/sbin"
  local appname="$SRC_DIR/${PROG:-$APPNAME}"
  local desc="$(grep_head "Description" "$appname" | head -n1 | sed 's#..* : ##g')"
  [ -n "$desc" ] && printf '%s' "$desc" || printf '%s' "$appname help"
}
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
  [ -z "$msg1" ] || printf_color "\t\t$msg1\n" "$color"
  [ -z "$msg2" ] || printf_color "\t\t$msg2\n" "$color"
  [ -z "$msg3" ] || printf_color "\t\t$msg3\n" "$color"
  [ -z "$msg4" ] || printf_color "\t\t$msg4\n" "$color"
  [ -z "$msg5" ] || printf_color "\t\t$msg5\n" "$color"
  [ -z "$msg6" ] || printf_color "\t\t$msg6\n" "$color"
  [ -z "$msg7" ] || printf_color "\t\t$msg7\n" "$color"
  [ -z "$msg8" ] || printf_color "\t\t$msg8\n" "$color"
  [ -z "$msg9" ] || printf_color "\t\t$msg9\n" "$color"
  [ -z "$msg10" ] || printf_color "\t\t$msg10\n" "$color"
  [ -z "$msg11" ] || printf_color "\t\t$msg11\n" "$color"
  [ -z "$msg12" ] || printf_color "\t\t$msg12\n" "$color"
  [ -z "$msg13" ] || printf_color "\t\t$msg13\n" "$color"
  [ -z "$msg14" ] || printf_color "\t\t$msg14\n" "$color"
  [ -z "$msg15" ] || printf_color "\t\t$msg15\n" "$color"
  [ -z "$msg16" ] || printf_color "\t\t$msg16\n" "$color"
  [ -z "$msg17" ] || printf_color "\t\t$msg17\n" "$color"
  [ -z "$msg18" ] || printf_color "\t\t$msg18\n" "$color"
  [ -z "$msg19" ] || printf_color "\t\t$msg19\n" "$color"
  [ -z "$msg20" ] || printf_color "\t\t$msg20\n" "$color"
  printf "\n"
  exit "${exitCode:-1}"
}
# grep header
sed_remove_empty() { sed '/^\#/d;/^$/d;s#^ ##g'; }
sed_head_remove() { awk -F'  :' '{print $2}'; }
sed_head() { sed -E 's|^.*#||g;s#^ ##g;s|^@||g'; }
grep_head() { grep -sE '[".#]?@[A-Z]' "${2:-$command}" | grep "${1:-}" | head -n 12 | sed_head | sed_remove_empty | grep '^' || return 1; }
grep_head_remove() { grep -sE '[".#]?@[A-Z]' "${2:-$command}" | grep "${1:-}" | grep -Ev 'GEN_SCRIPTS_*|\${|\$\(' | sed_head_remove | sed '/^\#/d;/^$/d;s#^ ##g' | grep '^' || return 1; }
grep_version() { grep_head ''${1:-Version}'' "${2:-$command}" | sed_head | sed_head_remove | sed_remove_empty | head -n1 | grep '^'; }

# display version
app_version() {
  local prog="${PROG:-$APPNAME}"              # get from file
  local name="$(basename "${1:-$prog}")"      # get from os
  local appname="${prog:-$name}"              # figure out wich one
  local filename="$SRC_DIR/${PROG:-$APPNAME}" # get filename
  if [ -f "$filename" ]; then                 # check for file
    printf "\n"
    printf_green "Getting info for $appname"
    grep_head "Version" "$filename" &>/dev/null &&
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

check_local() {
  local file="${1:-$PWD}"
  if [ -d "$file" ]; then
    type="dir"
    localfile="true"
    return 0
  elif [ -f "$file" ]; then
    type="file"
    localfile="true"
    return 0
  elif [ -L "$file" ]; then
    type="symlink"
    localfile="true"
    return 0
  elif [ -S "$file" ]; then
    type="socket"
    localfile="true"
    return 0
  elif [ -b "$file" ]; then
    type="block"
    localfile="true"
    return 0
  elif [ -p "$file" ]; then
    type="pipe"
    localfile="true"
    return 0
  elif [ -c "$"file"" ]; then
    type=character
    localfile=true
    return 0
  elif [ -e "$file" ]; then
    type="file"
    localfile="true"
    return 0
  else
    type=""
    localfile=""
    return 1
  fi
}
check_uri() {
  local url="$1"
  if echo "$url" | grep -q "http.*://\S\+\.[A-Za-z]\+\S*"; then
    uri="http"
    return 0
  elif echo "$url" | grep -q "ftp.*://\S\+\.[A-Za-z]\+\S*"; then
    uri="ftp"
    return 0
  elif echo "$url" | grep -q "git.*://\S\+\.[A-Za-z]\+\S*"; then
    uri="git"
    return 0
  elif echo "$url" | grep -q "ssh.*://\S\+\.[A-Za-z]\+\S*"; then
    uri="ssh"
    return 0
  else
    uri=""
    return 1
  fi
}
__am_i_online() { am_i_online "$@" &>/dev/null; }
# online check
am_i_online() {
  __curl() { devnull2 timeout 1 curl --disable -LSIs --max-time 1 "$site" | grep -e "HTTP/[0123456789]" | grep "200" -n1 &>/dev/null; }
  __ping() { devnull2 timeout 1 ping -c1 "$site" &>/dev/null; }
  case $1 in
  *err* | *show)
    shift 1
    showerror=yes
    site="${1:-1.1.1.1}"
    ;;
  *console)
    shift 1
    console="yes"
    site="${1:-1.1.1.1}"
    ;;
  *)
    site="${1:-1.1.1.1}"
    ;;
  esac
  shift
  test_ping() {
    __ping || false
    pingExit="$?"
    return ${pingExit:-$?}
  }
  test_http() {
    __curl || false
    httpExit="$?"
    return ${httpExit:-$?}
  }
  if test_ping || test_http; then exitCode=0; else
    exitCode="1"
    OFFLINE="true"
  fi
  if [ "$pingExit" = 0 ] || [ "$httpExit" = 0 ]; then
    if [ "$console" = "yes" ]; then
      notifications "Am I Online" "$site is up: you seem to be connected to the internet"
      exitCode="0"
    fi
  else
    if [ "$console" = "yes" ]; then
      notifications "Am I Online" "$site is down: you appear to not be connected to the internet"
      exitCode="1"
    fi
    if [ "$showerror" = "yes" ] && [ -z "$console" ]; then
      notifications "Am I Online" "$site is down: you appear to not be connected to the internet"
      exitCode="1"
    fi
  fi
  return ${exitCode:-$?}
}

notify_good() {
  local prog="${PROG:-$APPNAME}"
  local name="${1:-$(basename $0)}"
  local message="${*:-Command was successfull}"
  notifications "${prog:-$name}:" "$message"
  printf_green "${prog:-$name}: $message"
  return 0
}

notify_error() {
  local prog="${PROG:-$APPNAME}"
  local name="${1:-$(basename $0)}"
  local message="${*:-Command has failed}"
  notifications "${prog:-$name}:" "$message"
  printf_red "${prog:-$name}: $message"
  return 1
}
# ask question and execute
ask_confirm() {
  local question="${1:-Continue}"
  local command="${2:-true}"
  if [ -f "$(type -P ask_yes_no_question)" ]; then
    ask_yes_no_question "$question" "$command" "${APPNAME:-$PROG}"
  else
    __zenity() { zenity --question --text="$1" --ellipsize --default-cancel && $2 || return 1; }
    __dmenu() { [ "$(printf "No\\nYes" | dmenu -i -p "$1" -nb darkred -sb red -sf white -nf gray)" = "Yes" ] && ${2:-true} || return 1; }
    __dialog() { gdialog --trim --cr-wrap --colors --title "question" --yesno "$1" 15 40 && "$2" || return 1; }
    __term() { printf_question_term "$1" && $2 || return 1; }
    if [ -n "$DESKTOP_SESSION" ] || [ -n "$DISPLAY" ]; then
      if [ -f "$(command -v zenity 2>/dev/null)" ]; then
        __zenity "$question" "$command" && notify_good || notify_error
      elif [ -f "$(command -v dmenu1 2>/dev/null)" ]; then
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
__cmd_exists() { cmd_exists "$@"; }
# command check
cmd_exists() {
  [ "$CMD_EXISTS_NOTIFY" = "yes" ] || notifications() { true "$@"; }
  if [ "$CMD_EXISTS_INSTALL" = "yes" ]; then
    install_missing() { ask_confirm "Would you like to install $*" "pkmgr install $*" || return 1; }
  else
    install_missing() { true "$@"; }
  fi
  case "$1" in
  --show)
    local show=true
    shift 1
    ;;
  --error | --err)
    local error=show
    shift 1
    ;;
  --message | --msg)
    local message="$1"
    shift 2
    ;;
  esac
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  local command="$@"
  local exitCode="0"
  local missing=""
  for cmd in $command; do
    if command -v "$cmd" &>/dev/null || type -p "$cmd" &>/dev/null || return 1; then
      found+="$cmd "
      local exitCode+=0
    else
      missing="$cmd "
      local exitCode+=1
    fi
  done
  if [ "$show" = "true" ] && [ -n "$found" ]; then
    printf_green "$found"
    notifications "CMD Exists" "Found: $found"
  fi
  if [ "$show" = "true" ] && [ -n "$found" ] && [ -n "$missing" ]; then
    printf_red "${message:-Missing: $missing}"
    notifications "CMD Exists" "${message:-Missing: $missing}"
  fi
  if [ "$error" = "show" ] && [ -n "$missing" ] && [ -z "$show" ]; then
    printf_red "${message:-Missing: $missing}" >&2
    notifications "CMD Exists" "${message:-Missing: $missing}"
    exitCode="1"
  fi
  [ -z "$missing" ] || install_missing "$missing"
  unset cmd command missing
  return ${exitCode:-$?}
}

# show a spinner while executing code or zenity
if [ -f "$(command -v zenity 2>/dev/null)" ] && [ -n "$DESKTOP_SESSION" ]; then
  execute() {
    local CMD="$1" && shift $#
    $CMD | zenity --progress --no-cancel --pulsate --auto-close --title="Attempting install" --text="Trying to install" --height=200 --width=400 || printf_readline "5"
  }
else
  execute() {
    __set_trap() { trap -p "$1" | grep "$2" &>/dev/null || trap '$2' "$1"; }
    __kill_all_subprocesses() {
      local i=""
      for i in $(jobs -p); do
        kill "$i"
        wait "$i" &>/dev/null
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
      while kill -0 "$PID" &>/dev/null; do
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
    wait "$cmdsPID" &>/dev/null
    exitCode=$?
    printf_execute_result $exitCode "$MSG"
    if [ $exitCode -ne 0 ]; then
      printf_execute_error_stream <"$TMP_FILE"
    fi
    rm -rf "$TMP_FILE"
    return $exitCode
  }
fi

__list_array() {
  local OPTSDIR="${1:-$HOME/.local/share/misc/${PROG:-$APPNAME}/options}"
  mkdir -p "$OPTSDIR"
  echo "${2:-$ARRAY}" >"$OPTSDIR/array"
  return
}
__list_options() {
  local OPTSDIR="${1:-$HOME/.local/share/misc/${PROG:-$APPNAME}/options}"
  mkdir -p "$OPTSDIR"
  echo -n "-$SHORTOPTS " | sed 's#:##g;s#,# -#g' >"$OPTSDIR/options"
  echo "--$LONGOPTS " | sed 's#:##g;s#,# --#g' >>"$OPTSDIR/options"
  return
}
__dirname() { cd "$1" 2>/dev/null && pwd || return 1; }
__git_porcelain_count() {
  [ -d "$(__git_top_dir "${1:-.}")/.git" ] &&
    [ "$(git -C "${1:-.}" status --porcelain 2>/dev/null | wc -l 2>/dev/null)" -eq "0" ] &&
    return 0 || return 1
}
__git_porcelain() { __git_porcelain_count "${1:-.}" && return 0 || return 1; }
__git_top_dir() { git -C "${1:-.}" rev-parse --show-toplevel 2>/dev/null | grep -v fatal && return 0 || echo "${1:-$PWD}"; }

unset SEARCH_DIR SEARCH_FILE ARGS opts
