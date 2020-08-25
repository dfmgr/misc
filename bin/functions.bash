#!/usr/bin/env bash

# Set Main Repo for dotfiles
export DOTFILESREPO="${DOTFILESREPO:-https://github.com/dfmgr}"

# Set other Repos
export PKMGRREPO="${PKMGRREPO:-https://github.com/pkmgr}"
export ICONMGRREPO="${ICONMGRREPO:-https://github.com/iconmgr}"
export FONTMGRREPO="${FONTMGRREPO:-https://github.com/fontmgr}"
export THEMEMGRREPO="${THEMEMGRREPO:-https://github.com/thememgr}"
export SYSTEMMGRREPO="${THEMEMGRREPO:-https://github.com/systemmgr}"
export WALLPAPERMGRREPO="${THEMEMGRREPO:-https://github.com/wallpapermgr}"

if [[ $EUID -ne 0 ]] || [[ "$WHOAMI" != "root" ]]; then
  HOME="${HOME:-/home/$WHOAMI}"
  BIN="$HOME/.local/bin"
  CONF="$HOME/.config"
  SHARE="$HOME/.local/share"
  LOGDIR="$HOME/.local/log"
  STARTUP="$HOME/.config/autostart"
  SYSBIN="$HOME/.local/bin"
  SYSCONF="$HOME/.config"
  SYSSHARE="$HOME/.local/share"
  SYSLOGDIR="$HOME/.local/log"
  APPNAME="${APPNAME:-ERROR}"
  APPDIR="${APPDIR:-$HOME/.config/$APPNAME}"
  BACKUPDIR="${BACKUPS:-$HOME/.local/backups/dotfiles}"
  COMPDIR="${BASH_COMPLETION_USER_DIR:-$HOME/.local/share/bash-completion/completions}"
  THEMEDIR="$SHARE/themes"
  ICONDIR="$SHARE/icons"
  FONTDIR="$SHARE/fonts"
  FONTCONF="$SYSCONF/fontconfig/conf.d"
  CASJAYSDEVSHARE="$SHARE/CasjaysDev"
  CASJAYSDEVSAPPDIR="$CASJAYSDEVSHARE/apps"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/dotfiles"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/dotfiles"
  WALLPAPERS="$HOME/.local/share/wallpapers"
  #printf_info "Install Type: user - ${WHOAMI}"
elif [[ $EUID -eq 0 ]] || [[ "$WHOAMI" = "root" ]]; then
  HOME="${HOME:-/root}"
  BIN="$HOME/.local/bin"
  CONF="$HOME/.config"
  SHARE="$HOME/.local/share"
  LOGDIR="$HOME/.local/log"
  STARTUP="$HOME/.config/autostart"
  SYSBIN="/usr/local/bin"
  SYSCONF="/usr/local/etc"
  SYSSHARE="/usr/local/share"
  SYSLOGDIR="/usr/local/log"
  APPNAME="${APPNAME:-ERROR}"
  APPDIR="${APPDIR:-$CONF/$APPNAME}"
  BACKUPDIR="${BACKUPS:-$HOME/.local/backups/dotfiles}"
  COMPDIR="${BASH_COMPLETION_USER_DIR:-$HOME/.local/share/bash-completion/completions}"
  THEMEDIR="$SHARE/themes"
  ICONDIR="$SHARE/icons"
  FONTDIR="$SHARE/fonts"
  FONTCONF="$SYSCONF/fontconfig/conf.d"
  CASJAYSDEVSHARE="$SHARE/CasjaysDev"
  CASJAYSDEVSAPPDIR="$CASJAYSDEVSHARE/apps"
  USRUPDATEDIR="$SHARE/CasjaysDev/apps/dotfiles"
  SYSUPDATEDIR="$SYSSHARE/CasjaysDev/apps/dotfiles"
  WALLPAPERS="$SYSSHARE/wallpapers"
  printf_info "Installing as root - $APPDIR"
fi

__tput() { tput $* 2>/dev/null; }

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
  [[ $1 == ?(-)+([0-9]) ]] && local color="$1" && shift 1 || local color="3"
  local msg="$@"
  shift
  printf_color "\t\t$msg" "$color"
  echo ""
}

printf_custom_question() {
  local custom_question
  [[ $1 == ?(-)+([0-9]) ]] && local color="$1" && shift 1 || local color="1"
  local msg="$@"
  shift
  printf_color "\t\t$msg" "$color"
}

printf_newline() {
  set -o pipefail
  [[ $1 == ?(-)+([0-9]) ]] && local color="$1" && shift 1 || local color="3"
  while read line; do
    printf_color "\t\t$line\n" "$color"
  done
  set +o pipefail
}

devnull() { "$@" >/dev/null 2>&1; }

rm_rf() { devnull rm -Rf "$@"; }
cp_rf() { if [ -e "$1" ]; then devnull cp -Rfa "$@"; fi; }
mv_f() { if [ -e "$1" ]; then devnull mv -f "$@"; fi; }
ln_rm() { devnull find "$HOME" -xtype l -delete; }
ln_sf() {
  devnull ln -sf "$@"
  ln_rm
}

get_app_info() {
  local FILE="$(command -v $1)"
  if [ -f "$FILE" ]; then
    echo ""
    cat "$FILE" | grep "# @" | grep " : " >/dev/null 2>&1 &&
      cat "$FILE" | grep "# @" | grep " : " | printf_newline "3" ||
      printf_red "File was found, however, No information was provided"
    echo ""
  else
    printf_red "File was not found"
  fi
  exit 0
}

cd_into() {
  cd "$1" && printf_green "Type exit to return to your previous directory" && exec bash || exit 1
}
