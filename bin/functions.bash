#!/usr/bin/env bash

SET_DAY="$(date +'%d')"
SET_YEAR="$(date +'%Y')"
SET_MONTH="$(date +'%m')"
SET_HOUR="$(date +'%H')"
SET_MINUTE="$(date +'%M')"
SET_TIME="$(date +'%H:%M')"
SET_DATE="$(date +'%Y-%m-%d')"

__tput() { tput "$@" 2>/dev/null; }
printf_color() { printf "%b" "$(tput setaf "$2" 2>/dev/null)" "$1" "$(tput sgr0 2>/dev/null)"; }
printf_normal() { printf_color "\t\t$1\n" "$2"; }
printf_green() { printf_color "\t\t$1\n" 2; }
printf_red() { printf_color "\t\t$1\n" 1; }
printf_purple() { printf_color "\t\t$1\n" 5; }
printf_yellow() { printf_color "\t\t$1\n" 3; }
printf_blue() { printf_color "\t\t$1\n" 4; }
printf_cyan() { printf_color "\t\t$1\n" 6; }
printf_info() { printf_color "\t\t[ ℹ️ ] $1\n" 3; }
printf_help() { printf_color "\t\t$1\n" 1 && exit 1; }
printf_exit() { printf_color "\t\t$1\n" 1 && exit 1; }
printf_read() { printf_color "\t\t$1" 5; }
printf_success() { printf_color "\t\t[ ✔ ] $1\n" 2; }
printf_error() { printf_color "\t\t[ ✖ ] $1 $2\n" 1; }
printf_warning() { printf_color "\t\t[ ❗ ] $1\n" 3; }
printf_question() { printf_color "\t\t[ ❓ ] $1 [❓] " 6; }
printf_error_stream() { while read -r line; do printf_error "↳ ERROR: $line"; done; }
printf_execute_success() { printf_color "\t\t[ ✔ ] $1 [ ✔ ] \n" 2; }
printf_execute_error() { printf_color "\t\t[ ✖ ] $1 $2 [ ✖ ] \n" 1; }
printf_execute_error_stream() { while read -r line; do printf_execute_error "↳ ERROR: $line"; done; }

printf_custom() {
  if [[ $1 == ?(-)+([0-9]) ]]; then
    local color="$1"
    shift 1
  else local color="3"; fi
  local msg="$@"
  shift
  printf_color "\t\t$msg" "$color"
  echo ""
}

printf_custom_question() {
  local custom_question
  if [[ $1 == ?(-)+([0-9]) ]]; then
    local color="$1"
    shift 1
  else
    local color="2"
  fi
  local msg="$*"
  shift
  printf_color "\t\t$msg" "$color"
}

printf_readline() {
  set -o pipefail
  if [[ $1 == ?(-)+([0-9]) ]]; then
    local color="$1"
    shift 1
  else
    local color="3"
  fi
  while read -r line; do
    printf_color "\t\t$line\n" "$color"
  done
  set +o pipefail
}

devnull() { "$@" >/dev/null 2>&1; }
devnull2() { "$@" 2>/dev/null; }

mkd() { mkdir -p "$@"; }
rm_rf() { devnull rm -Rf "$@"; }
cp_rf() { if [ -e "$1" ]; then devnull cp -Rfa "$@"; fi; }
mv_f() { if [ -e "$1" ]; then devnull mv -f "$@"; fi; }
ln_rm() { devnull find "$HOME" -xtype l -delete; }
ln_sf() {
  devnull ln -sf "$@"
  ln_rm
}
