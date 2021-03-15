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
SET_DAY="$(date +'%d')"
SET_YEAR="$(date +'%Y')"
SET_MONTH="$(date +'%m')"
SET_HOUR="$(date +'%H')"
SET_MINUTE="$(date +'%M')"
SET_TIME="$(date +'%H:%M')"
SET_DATE="$(date +'%Y-%m-%d')"

command() { builtin command ${1+"$@"}; }
type() { builtin type ${1+"$@"}; }

printf_color() { printf "%b" "$(tput setaf "$2" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"; }
printf_normal() { printf_color "\t\t$1\n" "$2"; }
printf_green() { printf_color "\t\t$1\n" 2; }
printf_red() { printf_color "\t\t$1\n" 1; }
printf_purple() { printf_color "\t\t$1\n" 5; }
printf_yellow() { printf_color "\t\t$1\n" 3; }
printf_blue() { printf_color "\t\t$1\n" 4; }
printf_cyan() { printf_color "\t\t$1\n" 6; }
printf_info() { printf_color "\t\t[ ℹ️  ] $1\n" 3; }
printf_exit() { printf_color "\t\t$1\n" "${3:-1}" && exit "${2:-1}"; }
printf_return() { printf_color "\t\t$1\n" "${3:-1}" && return "${2:-1}"; }
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

printf_custom() {
  [[ $1 == ?(-)+([0-9]) ]] && local color="$1" && shift 1 || local color="3"
  local msg="$*"
  shift
  printf_color "\t\t$msg" "$color"
  printf "\n"
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

get_desc() {
  local PATH="$HOME/.local/bin:/usr/local/bin:/usr/bin:/usr/sbin"
  local appname="$(type -P "${PROG:-$APPNAME}" 2>/dev/null || command -v "${PROG:-$APPNAME}" 2>/dev/null || which "${PROG:-$APPNAME}" 2>/dev/null)"
  local desc="$(grep ^"# @Description" "$appname" 2>/dev/null | grep ' : ' | sed 's#..* : ##g' | grep '^')"
  [ -n "$desc" ] && printf "%s" "$desc" || printf "%s" "${PROG:-$APPNAME} --help"
}
devnull() { "$@" >/dev/null 2>&1; }
devnull2() { "$@" 2>/dev/null; }

mkd() { devnull mkdir -p "$@"; }
rm_rf() { devnull rm -Rf "$@"; }
cp_rf() { if [ -e "$1" ]; then devnull cp -Rfa "$@"; fi; }
mv_f() { if [ -e "$1" ]; then devnull mv -f "$@"; fi; }
ln_rm() { devnull find "${1:-$HOME}" -xtype l -delete; }
ln_sf() {
  devnull ln -sf "$@"
  ln_rm "${1:-$HOME}"
}

app_help() {
  local set_desc="$(get_desc)"
  printf "\n"
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
  if [ -n "${PROG:-$APPNAME}" ] && [ -n "set_desc" ]; then
    printf_color "\t\t$set_desc\n" 6
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

app_version() {
  local prog="${PROG:-$APPNAME}"           # get from file
  local name="$(basename "${1:-$prog}")"   # get from os
  local appname="${prog:-$name}"           # figure out wich one
  filename="$(type -P "$appname")"         # get filename
  if [ -f "$(type -P "$filename")" ]; then # check for file
    printf "\n"
    printf_green "Getting info for $filename"
    cat "$filename" | grep '^# @' | grep '  :' >/dev/null 2>&1 &&
      cat "$filename" | grep '^# @' | grep -v '\$' | grep '  :' | sed 's/# @//g' | printf_readline "3" &&
      printf_green "$(cat "$filename" | grep -v '\$' | grep "##@Version" | sed 's/##@//g')" ||
      printf_return "File was found, however, No information was provided"
  else
    printf_red "${1:-$appname} was not found"
    exitCode=1
  fi
  printf "\n"
  exit "${exitCode:-$?}"
}
