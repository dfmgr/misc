#!/usr/bin/env sh
# shellcheck shell=sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202208281859-git
# @@Author           :  Jason Hempstead
# @@Contact          :  git-admin@casjaysdev.pro
# @@License          :  WTFPL
# @@ReadME           :  This script is sourced by some shells (bash, zsh)
# @@Copyright        :  Copyright: (c) 2022 Jason Hempstead, Casjays Developments
# @@Created          :  Sunday, Aug 28, 2022 19:11 EDT
# @@File             :  .profile
# @@Description      :  user profile script
# @@Changelog        :  Added pnpm
# @@TODO             :  Refactor code
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  N/A
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# colors initialization
color_prompt=yes
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Reset
NC="$(tput sgr0 2>/dev/null)"
RESET="$(tput sgr0 2>/dev/null)"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Bold
BOLD="$(tput bold 2>/dev/null)"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Regular Colors
export BLACK='\033[0;30m'    # Black
export RED='\033[0;31m'      # Red
export GREEN='\033[0;32m'    # Green
export YELLOW='\033[0;33m'   # Yellow
export BLUE='\033[0;34m'     # Blue
export PURPLE='\033[0;35m'   # Purple
export CYAN='\033[0;36m'     # Cyan
export WHITE='\033[0;37m'    # White
export ORANGE='\033[0;33m'   # Orange
export LIGHTRED='\033[1;31m' # Light Red
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Bold
export BBLACK='\033[1;30m'  # Black
export BRED='\033[1;31m'    # Red
export BGREEN='\033[1;32m'  # Green
export BYELLOW='\033[1;33m' # Yellow
export BBLUE='\033[1;34m'   # Blue
export BPURPLE='\033[1;35m' # Purple
export BCYAN='\033[1;36m'   # Cyan
export BWHITE='\033[1;37m'  # White
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Underline
export UBLACK='\033[4;30m'  # Black
export URED='\033[4;31m'    # Red
export UGREEN='\033[4;32m'  # Green
export UYELLOW='\033[4;33m' # Yellow
export UBLUE='\033[4;34m'   # Blue
export UPURPLE='\033[4;35m' # Purple
export UCYAN='\033[4;36m'   # Cyan
export UWHITE='\033[4;37m'  # White
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Background
export ON_BLACK='\033[40m'  # Black
export ON_RED='\033[41m'    # Red
export ON_GREEN='\033[42m'  # Green
export ON_YELLOW='\033[43m' # Yellow
export ON_BLUE='\033[44m'   # Blue
export ON_PURPLE='\033[45m' # Purple
export ON_CYAN='\033[46m'   # Cyan
export ON_WHITE='\033[47m'  # White
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# High Intensity
export IBLACK='\033[0;90m'  # Black
export IRED='\033[0;91m'    # Red
export IGREEN='\033[0;92m'  # Green
export IYELLOW='\033[0;93m' # Yellow
export IBLUE='\033[0;94m'   # Blue
export IPURPLE='\033[0;95m' # Purple
export ICYAN='\033[0;96m'   # Cyan
export IWHITE='\033[0;97m'  # White
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Bold High Intensity
export BIBLACK='\033[1;90m'  # Black
export BIRED='\033[1;91m'    # Red
export BIGREEN='\033[1;92m'  # Green
export BIYELLOW='\033[1;93m' # Yellow
export BIBLUE='\033[1;94m'   # Blue
export BIPURPLE='\033[1;95m' # Purple
export BICYAN='\033[1;96m'   # Cyan
export BIWHITE='\033[1;97m'  # White
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# High Intensity backgrounds
export ON_IBLACK='\033[0;100m'  # Black
export ON_IRED='\033[0;101m'    # Red
export ON_IGREEN='\033[0;102m'  # Green
export ON_IYELLOW='\033[0;103m' # Yellow
export ON_IBLUE='\033[0;104m'   # Blue
export ON_IPURPLE='\033[0;105m' # Purple
export ON_ICYAN='\033[0;106m'   # Cyan
export ON_IWHITE='\033[0;107m'  # White
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# default path
USRBINDIR="$HOME/.local/bin"
SYSBINDIR="/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/bin:/sbin:/usr/share/games:/usr/games"
export PATH="$USRBINDIR:$SYSBINDIR"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# History
export HISTSIZE=1200
export HISTFILESIZE=1200
export SAVEHIST=4096
export HISTCONTROL=ignoredups:erasedups:ignoreboth
export HISTIGNORE="[bf]g:exit:pwd:clear:q:q!:quit"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# sh specific
if [ -n "$SH_VERSION" ]; then
  SHELL="$(which "$SHELL" 2>/dev/null)"
  ENV=$HOME/.shinit
  export ENV
# bash specific
elif [ -n "$BASH_VERSION" ]; then
  SHELL="$(which bash 2>/dev/null)"
  export BASH_SILENCE_DEPRECATION_WARNING="1"
  export OSH="$HOME/.local/share/bash/oh-my-bash"
  export BASH_COMPLETION_USER_DIR="$HOME/.local/share/bash-completion/completions"
  if [ -d "$HOME/.config/bash" ]; then
    history -r
    export HISTFILE="$HOME/.config/bash/bash_history"
    if [ -f "$HOME/.bash_history" ] && [ "$HISTFILE" != "$HOME/.bash_history" ]; then
      mv -f "$HOME/.bash_history" "$HISTFILE"
      history -a && history -w && history -r
    fi
  else
    export HISTFILE="$HOME/.bash_history"
  fi
  if which direnv >/dev/null 2>&1; then
    direnv hook bash >/dev/null 2>&1
  fi
  # cursor
# zsh specific
elif [ -n "$ZSH_VERSION" ]; then
  SHELL="$(which zsh 2>/dev/null)"
  export ZDOTDIR="$HOME/.config/zsh"
  export ZSH_CACHEDIR="$HOME/.cache/oh-my-zsh"
  export ZSH="$HOME/.local/share/zsh/plugins/oh-my-zsh"
  export ZSH_CUSTOM="$HOME/.local/share/zsh/plugins/oh-my-zsh/custom"
  export ZSH_DISABLE_COMPFIX="${ZSH_DISABLE_COMPFIX:-true}"
  export HISTFILE="$HOME/.config/zsh/zsh_history"
  autoload -Uz compinit && compinit -i
  autoload -U +X bashcompinit && bashcompinit
  which direnv >/dev/null 2>&1 && direnv hook zsh >/dev/null 2>&1
fi
SHELL_NAME="$(basename "$SHELL")"
export SHELL SHELL_NAME
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# get hostname info
HOSTNAME_FULL="$(hostname_cli="$(which hostname 2>/dev/null || which hostnamecli 2>/dev/null || echo 'true')" && [ -n "$hostname_cli" ] && $hostname_cli -f)"
HOSTNAME_SHORT="$(hostname_cli="$(which hostname 2>/dev/null || which hostnamecli 2>/dev/null || echo 'true')" && [ -n "$hostname_cli" ] && $hostname_cli -s)"
[ -n "$HOSTNAME_FULL" ] && HOSTNAME="$HOSTNAME_FULL" || HOSTNAME="$HOSTNAME_SHORT"
export HOSTNAME
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[ -n "$NODE_MANAGER" ] || NODE_MANAGER="fnm"
export NODE_MANAGER
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set umask
#umask 022
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setting the temp directory
export TMP="${TMP:-$HOME/.local/tmp}"
export TEMP="${TEMP:-$HOME/.local/tmp}"
export TMPDIR="${TMPDIR:-$HOME/.local/tmp}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set locale
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC="en_US.UTF-8"
export LC_TIME="en_US.UTF-8"
export LC_COLLATE="en_US.UTF-8"
export LC_MONETARY="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export LC_PAPER="en_US.UTF-8"
export LC_NAME="en_US.UTF-8"
export LC_ADDRESS="en_US.UTF-8"
export LC_TELEPHONE="en_US.UTF-8"
export LC_MEASUREMENT="en_US.UTF-8"
export LC_IDENTIFICATION="en_US.UTF-8"
[ -n "$LC_ALL" ] || LC_ALL="$LANG"
export LC_ALL LANG
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# configure display
if [ -n "$DISPLAY" ]; then
  if [ -n "$DISPLAY_LOW_DENSITY" ] && grep -siq chromium /proc/version; then
    export DISPLAY_LOW_DENSITY="$DISPLAY"
  fi
  if which xrandr >/dev/null 2>&1; then
    RESOLUTION="$(xrandr --current 2>/dev/null | grep '\*' | uniq | awk '{print $1}')"
  fi
fi
export RESOLUTION
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# disable blank screen
if [ -n "$DISPLAY" ] && which xset >/dev/null 2>&1; then
  xset s off >/dev/null 2>&1
  xset -dpms >/dev/null 2>&1
  xset s off -dpms >/dev/null 2>&1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# enable control alt backspace
if [ -n "$DISPLAY" ] && [ "$(uname -s)" = "Linux" ]; then
  XKBOPTIONS="terminate:ctrl_alt_bksp"
  if which setxkbmap >/dev/null 2>&1; then
    setxkbmap -model pc104 -layout us -option "terminate:ctrl_alt_bksp" 2>/dev/null
  fi
fi
export XKBOPTIONS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# setup modifiers
if [ -n "$DISPLAY" ] && [ -n "$DESKTOP_SESSION" ]; then
  if which ibus >/dev/null 2>&1; then
    XMODIFIERS=@im=ibus
    GTK_IM_MODULE="ibus"
    QT_IM_MODULE="ibus"
  elif which fcitx >/dev/null 2>&1; then
    XMODIFIERS=@im=fcitx
    GTK_IM_MODULE="fcitx"
    QT_IM_MODULE="fcitx"
  fi
fi
export XMODIFIERS GTK_IM_MODULE QT_IM_MODULE
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# xserver settings
if [ -n "$DISPLAY" ] && [ "$(uname -s)" = "Linux" ]; then
  if [ ! -f "$HOME/.Xdefaults" ]; then
    touch "$HOME/.Xdefaults"
  fi
  if which xrdb >/dev/null 2>&1; then
    xrdb -merge "$HOME/.Xdefaults" 2>/dev/null
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# XDG Settings
[ -n "$UID" ] || UID="$(id -u)"
CACHE_DIRECTORY="$HOME/.cache"
STATE_DIRECTORY="$HOME/.local/lib"
LOGS_DIRECTORY="${LOGDIR:-$HOME/.local/log}"
RUNTIME_DIRECTORY="${XDG_RUNTIME_DIR:-/run/user/$UID}"
CONFIGURATION_DIRECTORY="${CONFIGURATION_DIRECTORY:-$HOME/.config}"
XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-$RUNTIME_DIRECTORY}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$CONFIGURATION_DIRECTORY}"
export LOGS_DIRECTORY STATE_DIRECTORY CACHE_DIRECTORY RUNTIME_DIRECTORY
export CONFIGURATION_DIRECTORY XDG_RUNTIME_DIR XDG_CONFIG_HOME
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ensure .gitconfig exists
if [ ! -f "$HOME/.gitconfig" ]; then
  if [ -f "$HOME/.config/local/gitconfig.local" ]; then
    cp -f "$HOME/.config/local/gitconfig.local" "$HOME/.gitconfig"
  else
    touch "$HOME/.gitconfig"
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Sudo prompt
SUDO_PROMPT="$(printf "\033[1;31m")[sudo]$(printf "\033[1;36m") password for $(printf "\033[1;32m")%p: $(printf "\033[0m")"
export SUDO_PROMPT
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create a banner
if which figlet >/dev/null 2>&1; then
  export BANNER="figlet -f banner"
elif which toilet >/dev/null 2>&1; then
  export BANNER="toilet -f mono9.tlf"
elif which banner >/dev/null 2>&1; then
  export BANNER="banner"
else
  export BANNER="echo -e"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export gpg tty
GPG_TTY="$(tty)"
SSH_AUTH_SOCK="$RUNTIME_DIRECTORY/gnupg/S.gpg-agent.ssh"
if which gpg-agent >/dev/null 2>&1; then
  gpg-agent --enable-ssh-support --daemon -q >/dev/null 2>&1
fi
export GPG_TTY SSH_AUTH_SOCK
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export ssh
[ -d "$HOME/.ssh" ] || mkdir -p "$HOME/.ssh"
[ -n "$SSH_AUTH_SOCK" ] || SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock"
if [ -d "$HOME/.ssh" ] && ls -A "$HOME/.ssh"/id_* >/dev/null 2>&1; then
  for f in $(find "$HOME/.ssh"/id_* 2>/dev/null | grep -v '/*.pub'); do
    ssh-add -q "$f" >/dev/null 2>&1
  done
fi
if [ ! -S "$HOME/.ssh/ssh_auth_sock" ]; then
  if which ssh-agent >/dev/null 2>&1; then
    ssh-agent >/dev/null 2>&1
  fi
  if [ -n "$SSH_AUTH_SOCK" ] && [ "$SSH_AUTH_SOCK" != "$HOME/.ssh/ssh_auth_sock" ]; then
    ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/ssh_auth_sock" >/dev/null 2>&1
  fi
fi
[ -d "$HOME/.ssh/known_hosts.d" ] || mkdir -p "$HOME/.ssh/known_hosts.d"
export SSH_AUTH_SOCK
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Use custom `less` colors for `man` pages.
export LESS="RcQaix4M"
export GROFF_NO_SGR=1                           # for konsol
export LESS_TERMCAP_mb=$(printf '\e[1;31m')     # begin bold
export LESS_TERMCAP_md=$(printf '\e[1;33m')     # begin blink
export LESS_TERMCAP_so=$(printf '\e[01;44;37m') # begin reverse video
export LESS_TERMCAP_us=$(printf '\e[01;37m')    # begin underline
export LESS_TERMCAP_me=$(printf '\e[0m')        # reset bold/blink
export LESS_TERMCAP_se=$(printf '\e[0m')        # reset reverse video
export LESS_TERMCAP_ue=$(printf '\e[0m')        # reset underline
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# clear the screen after quitting a `man` page.
export MANPAGER="less -RcQaix4M +Gg"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# add emacs to bin
if [ -d "$HOME/.emacs.d/bin" ]; then
  TMP_BIN_PATH="$HOME/.emacs.d/bin:$TMP_BIN_PATH"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# add doom-emacs to bin
if [ -d "$HOME/.local/share/emacs/plugins/doom-emacs/bin" ]; then
  TMP_BIN_PATH="$HOME/.local/share/emacs/plugins/doom-emacs/bin:$TMP_BIN_PATH"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# rpm development
export QA_RPATHS="\$((0x0001 | 0x0010))"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# mpd server
export MPDSERVER="$HOSTNAME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# notes settings
[ -n "$NOTES_SERVER_NAME" ] || NOTES_SERVER_NAME="development"
NOTES_DIRECTORY="$HOME/.local/share/editors/notes"
export NOTES_SERVER_NAME NOTES_DIRECTORY
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup neovim
export NVIM_LISTEN_ADDRESS="$RUNTIME_DIRECTORY/nvim.${USER}.sock"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# configure lua - https://github.com/DhavalKapil/luaver
export LUAVER_HOME="$HOME/.local/share/misc/plugins/luaver"
[ -f "$LUAVER_HOME/luaver" ] && ln -sf "$LUAVER_HOME/luaver" "$HOME/.local/bin/luaver"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup luarocks
lua_ver="$(ls -A /usr/bin/lua* 2>/dev/null | grep 'lua[0-9].[0-9]' | sort -rV | sed 's|.*lua||g' | head -n1 | grep '^' || echo '5.4')"
export LUAROCKS_PREFIX="$HOME/.local/share/lua/luarocks"
export LUAROCKS_BIN="$LUAROCKS_PREFIX/bin"
TMP_BIN_PATH="$LUAROCKS_BIN:$TMP_BIN_PATH"
[ -d "$HOME/.config/luarocks" ] || mkdir -p "$HOME/.config/luarocks"
[ -f "$HOME/.config/luarocks/config-$lua_ver" ] || touch "$HOME/.config/luarocks/config-$lua_ver"
if grep -Rsq "home_tree" "$HOME/.config/luarocks/config-$lua_ver"; then
  sed -i "s|home_tree.*|home_tree = \"$LUAROCKS_PREFIX\"|g" "$HOME/.config/luarocks/config-$lua_ver"
else
  echo "home_tree = \"$LUAROCKS_PREFIX\"" >>"$HOME/.config/luarocks/config-$lua_ver"
fi
unset lua_ver
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# configure bash-it - https://github.com/Bash-it/bash-it
export BASH_IT="$HOME/.local/share/bash/plugins/bash-it"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# configure asdf - https://asdf-vm.com
export ASDF_DIR="$HOME/.local/share/misc/plugins/asdf"
export ASDF_DATA_DIR="$HOME/.local/share/misc/plugins/asdf"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# configure basher - https://www.basher.it
export BASHER_ROOT="$HOME/.local/share/misc/plugins/basher"
TMP_BIN_PATH="$HOME/.local/share/misc/plugins/basher/bin:$TMP_BIN_PATH"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# GO version Manager - https://github.com/moovweb/gvm
export GVM_ROOT="$HOME/.local/share/gvm"
[ -f "$GVM_ROOT/scripts/gvm-default" ] && . "$GVM_ROOT/scripts/gvm-default"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# configure GO
export GODIR="$HOME/.local/share/go"
export GOPATH="$GODIR"
export GOBIN="$GODIR/bin"
export GOCACHE="$GODIR/build"
TMP_BIN_PATH="$GOBIN:$TMP_BIN_PATH"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# configure gofish - https://gofi.sh
export GOFISH_CACHE="$HOME/cache/.gofish"
export GOFISH_HOME="$HOME/.local/share/gofish"
export GOFISH_RIGS="$GOFISH_HOME/Rigs"
export GOFISH_BARREL="$GOFISH_HOME/Barrel"
export GOFISH_DEFAULT_RIG="$GOFISH_HOME/Rigs/github.com/fishworks/fish-food"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ruby Version Manager
export rvm_path="$HOME/.local/share/rvm"
if [ -f "$rvm_path/scripts/rvm" ]; then
  TMP_BIN_PATH="$rvm_path/bin:$TMP_BIN_PATH"
  . "$rvm_path/scripts/rvm"
  . "$rvm_path/scripts/completion"
fi

# PNPM
export PNPM_HOME="$HOME/.local/share/nodejs/pnpm"
[ -d "$PNPM_HOME" ] || mkdir -p "$PNPM_HOME"
TMP_BIN_PATH="$PNPM_HOME:$TMP_BIN_PATH"
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Fast Node Manager
export FNM_BIN="$USRBINDIR"
export FNM_DIR="$HOME/.local/share/nodejs/fnm"
export FNM_DEFAULT="$FNM_DIR/aliases/default/bin"
if which fnm >/dev/null 2>&1; then
  eval "$(fnm env --version-file-strategy recursive --shell "$SHELL_NAME" 2>/dev/null)"
  if [ -d "$FNM_DEFAULT" ]; then
    ln -sf "$FNM_DEFAULT"/* "$USRBINDIR/" 2>/dev/null
  fi
fi
TMP_BIN_PATH="$FNM_BIN:$TMP_BIN_PATH"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# node version manager
export NVM_BIN="$USRBINDIR"
export NVM_DIR="$HOME/.local/share/nodejs/nvm"
export NO_UPDATE_NOTIFIER="true"
export NODE_REPL_HISTORY_SIZE=2000
if which nvm >/dev/null 2>&1; then
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Node
export NPM_PACKAGES="$HOME/.local/share/nodejs/modules"
export NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH"
if which node >/dev/null 2>&1; then
  npm config set prefix "$NPM_PACKAGES" >/dev/null 2>&1
fi
TMP_BIN_PATH="$NPM_PACKAGES/bin:$TMP_BIN_PATH"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Deno
export DENO_INSTALL="$HOME/.local/share/deno"
TMP_BIN_PATH="$DENO_INSTALL/bin:$TMP_BIN_PATH"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Python
if [ -z "$PYTHONPATH" ]; then
  export PYTHONPATH="/usr/local"
else
  PYTHONPATH="$(echo "$PYTHONPATH" | sed 's|:/usr/local||g')"
  export PYTHONPATH="$PYTHONPATH:/usr/local"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# setup python setV
export SETV_VIRTUAL_DIR_PATH="$HOME/.local/share/python/setvenv/"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# setup pipx
export PIPX_BIN_DIR="$USRBINDIR"
export PIPX_HOME="$HOME/.local/share/python/pipx"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# setup python virtualenvwrapper
export VIRTUALENVWRAPPER_VIRTUALENV_WORKON_CD="yes"
export VIRTUALENVWRAPPER_PIP="$(which pip3 2>/dev/null || which pip 2>/dev/null)"
export VIRTUALENVWRAPPER_VIRTUALENV="$(which venv 2>/dev/null || which virtualenv 2>/dev/null)"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Add Rust/Cargo to the path
export RUST_HOME="$HOME/.local/share/rust"
export CARGO_HOME="$HOME/.local/share/cargo"
export RUSTUP_HOME="$HOME/.local/share/rustup"
TMP_BIN_PATH="$TMP_BIN_PATH:$CARGO_HOME/bin:$RUST_HOME/bin:$RUSTUP_HOME/bin"
[ -f "$CARGO_HOME/env" ] && . "$CARGO_HOME/env"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Use hub as git if installed
#which hub >/dev/null 2>&1 && eval "$(hub alias -s >/dev/null 2>/dev/null)"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup vagrant
export VAGRANT_HOME="$HOME/.local/share/vagrant"
export VAGRANT_DEFAULT_PROVIDER="libvirt"
TMP_BIN_PATH="$TMP_BIN_PATH:$VAGRANT_HOME/bin"
[ -d "$VAGRANT_HOME/bin" ] || mkdir -p "$VAGRANT_HOME/bin"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Docker
if [ -S "/run/docker.sock" ]; then
  DOCKER_SOCK="/run/docker.sock"
elif [ -S "/run/docker/docker.sock" ]; then
  DOCKER_SOCK="/run/docker/docker.sock"
elif [ -S "${XDG_RUNTIME_DIR}/docker.sock" ]; then
  DOCKER_SOCK="${XDG_RUNTIME_DIR}/docker.sock"
fi
[ -n "$DOCKER_HOST" ] || DOCKER_HOST="$DOCKER_SOCK"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Kubernetes
KUBECONFIG="$HOME/.config/kube/config"
if which kubectl >/dev/null 2>&1; then
  eval "$(kubectl completion "$SHELL_NAME")"
elif which kubectl >/dev/null 2>&1; then
  eval "$()"
fi
which podman >/dev/null 2>&1 && KIND_EXPERIMENTAL_PROVIDER="podman" || KIND_EXPERIMENTAL_PROVIDER="docker"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup dockerstarter
export DOCKERCONFDIR="$HOME/.config/dockstarter"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# DockerMGR settings
export DOCKERMGR_HOME="$HOME/.config/myscripts/dockermgr"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# distrobox
DBX_SKIP_WORKDIR=0
DBX_NON_INTERACTIVE=1
DBX_CONTAINER_ALWAYS_PULL=1
DBX_HOME="$HOME/.local/share/distrobox"
TMP_BIN_PATH="$TMP_BIN_PATH:$DBX_HOME/bin"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# dotnet
export DOTNET_ROOT="$HOME/.local/share/dotnet"
TMP_BIN_PATH="$DOTNET_ROOT:$DOTNET_ROOT/tools:$TMP_BIN_PATH"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export browser
if [ -n "$SSH_CONNECTION" ] || [ -z "$DISPLAY" ]; then
  if which lynx >/dev/null 2>&1; then
    MYBROWSER="$(which lynx 2>/dev/null)"
  elif which links >/dev/null 2>&1; then
    MYBROWSER="$(which links 2>/dev/null)"
  fi
else
  if which garcon-url-handler >/dev/null 2>&1; then
    MYBROWSER="$(which garcon-url-handler 2>/dev/null) --url"
  elif which firefox >/dev/null 2>&1; then
    MYBROWSER="$(which firefox 2>/dev/null)"
  elif which chromium >/dev/null 2>&1; then
    MYBROWSER="$(which chromium 2>/dev/null)"
  elif which google-chrome >/dev/null 2>&1; then
    MYBROWSER="$(which google-chrome 2>/dev/null)"
  elif which opera >/dev/null 2>&1; then
    MYBROWSER="$(which opera 2>/dev/null)"
  elif which epiphany-browser >/dev/null 2>&1; then
    MYBROWSER="$(which epiphany-browser 2>/dev/null)"
  elif which falkon >/dev/null 2>&1; then
    MYBROWSER="$(which falkon 2>/dev/null)"
  elif which midori >/dev/null 2>&1; then
    MYBROWSER="$(which midori 2>/dev/null)"
  elif which netsurf >/dev/null 2>&1; then
    MYBROWSER="$(which netsurf 2>/dev/null)"
  elif which surf >/dev/null 2>&1; then
    MYBROWSER="$(which surf 2>/dev/null)"
  elif which arora >/dev/null 2>&1; then
    MYBROWSER="$(which arora 2>/dev/null)"
  elif [ -f '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' ]; then
    MYBROWSER='/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
  elif [ -f '/Applications/Firefox.app/Contents/MacOS/firefox-bin' ]; then
    MYBROWSER='/Applications/Firefox.app/Contents/MacOS/firefox-bin'
  elif [ -f '/Applications/Opera.app/Contents/MacOS/Opera' ]; then
    MYBROWSER='/Applications/Opera.app/Contents/MacOS/Opera'
  elif [ -f '/Applications/Brave Browser.app/Contents/MacOS/Brave Browser' ]; then
    MYBROWSER='/Applications/Brave Browser.app/Contents/MacOS/Brave Browser'
  elif [ -f '/Applications/Tor Browser.app/Contents/MacOS/firefox' ]; then
    MYBROWSER='/Applications/Tor Browser.app/Contents/MacOS/firefox'
  elif which lynx >/dev/null 2>&1; then
    MYBROWSER="$(which lynx 2>/dev/null)"
  elif which links >/dev/null 2>&1; then
    MYBROWSER="$(which links 2>/dev/null)"
  fi
fi
export BROWSER="$MYBROWSER"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export terminal
if [ -n "$SSH_CONNECTION" ] || [ -z "$DISPLAY" ]; then
  if which tmux-new >/dev/null 2>&1; then
    MYTERMINAL="tmux-new"
  elif which tmux >/dev/null 2>&1; then
    MYTERMINAL="tmux"
  elif which screen >/dev/null 2>&1; then
    MYTERMINAL="screen"
  fi
else
  if which termite >/dev/null 2>&1; then
    MYTERMINAL="termite"
  elif which xfce4-terminal >/dev/null 2>&1; then
    MYTERMINAL="xfce4-terminal"
  elif which qterminal >/dev/null 2>&1; then
    MYTERMINAL="qterminal"
  elif which mate-terminal >/dev/null 2>&1; then
    MYTERMINAL="mate-terminal"
  elif which i3-sensible-terminal >/dev/null 2>&1; then
    MYTERMINAL="i3-sensible-terminal"
  elif which rofi-sensible-terminal >/dev/null 2>&1; then
    MYTERMINAL="rofi-sensible-terminal"
  elif which terminology >/dev/null 2>&1; then
    MYTERMINAL="terminology"
  elif which gnome-terminal >/dev/null 2>&1; then
    MYTERMINAL="gnome-terminal"
  elif [ -f "/Applications/iTerm.app/Contents/MacOS/iTerm2" ]; then
    MYTERMINAL="/Applications/iTerm.app/Contents/MacOS/iTerm2"
  elif [ -f "/System/Applications/Utilities/terminal.app/Contents/MacOS/terminal" ]; then
    MYTERMINAL="/System/Applications/Utilities/terminal.app/Contents/MacOS/terminal"
  elif which xterm >/dev/null 2>&1; then
    MYTERMINAL="xterm"
  elif which uxterm >/dev/null 2>&1; then
    MYTERMINAL="uxterm"
  elif which garcon-terminal-handler >/dev/null 2>&1; then
    MYTERMINAL="garcon-terminal-handler"
  elif which tmux >/dev/null 2>&1; then
    MYTERMINAL="tmux"
  elif which screen >/dev/null 2>&1; then
    MYTERMINAL="screen"
  else
    MYTERMINAL="$SHELL -c"
  fi
fi
export TERMINAL="$MYTERMINAL"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export file manager
if [ -n "$SSH_CONNECTION" ] || [ -z "$DISPLAY" ]; then
  if which lf >/dev/null 2>&1; then
    MYFILEMANAGER="lf"
  elif which vifm >/dev/null 2>&1; then
    MYFILEMANAGER="vifm"
  elif which ranger >/dev/null 2>&1; then
    MYFILEMANAGER="ranger"
  elif which cfiles >/dev/null 2>&1; then
    MYFILEMANAGER="cfiles"
  elif which se >/dev/null 2>&1; then
    MYFILEMANAGER="se"
  fi
else
  if which thunar >/dev/null 2>&1; then
    MYFILEMANAGER="thunar"
  elif which Thunar >/dev/null 2>&1; then
    MYFILEMANAGER="Thunar"
  elif which caja >/dev/null 2>&1; then
    MYFILEMANAGER="caja"
  elif which spacefm >/dev/null 2>&1; then
    MYFILEMANAGER="spacefm"
  elif which nemo >/dev/null 2>&1; then
    MYFILEMANAGER="nemo"
  elif which pcmanfm >/dev/null 2>&1; then
    MYFILEMANAGER="pcmanfm"
  elif which polo >/dev/null 2>&1; then
    MYFILEMANAGER="polo"
  elif which nautilus >/dev/null 2>&1; then
    MYFILEMANAGER="nautilus"
  elif which polo >/dev/null 2>&1; then
    MYFILEMANAGER="polo"
  elif which dolphin >/dev/null 2>&1; then
    MYFILEMANAGER="dolphin"
  elif which konqueror >/dev/null 2>&1; then
    MYFILEMANAGER="konqueror"
  elif which lf >/dev/null 2>&1; then
    MYFILEMANAGER="lf"
  elif which vifm >/dev/null 2>&1; then
    MYFILEMANAGER="vifm"
  elif which ranger >/dev/null 2>&1; then
    MYFILEMANAGER="ranger"
  elif which cfiles >/dev/null 2>&1; then
    MYFILEMANAGER="cfiles"
  elif which se >/dev/null 2>&1; then
    MYFILEMANAGER="se"
  fi
fi
if [ "$(uname -s)" = Darwin ]; then
  MYFILEMANAGER="open"
fi
export FILEMANAGER="$MYFILEMANAGER"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# virtual machine manager
if [ -n "$SSH_CONNECTION" ] || [ -z "$DISPLAY" ]; then
  if which kind >/dev/null 2>&1; then
    MYVMMANAGER="kind"
  elif which minikube >/dev/null 2>&1; then
    MYVMMANAGER="minikube"
  elif which kubectl >/dev/null 2>&1; then
    MYVMMANAGER="kubectl"
  elif which docker >/dev/null 2>&1; then
    MYVMMANAGER="docker"
  elif which podman >/dev/null 2>&1; then
    MYVMMANAGER="podman"
  fi
else
  if which virt-manager >/dev/null 2>&1; then
    MYVMMANAGER="virt-manager"
  elif which VMWare >/dev/null 2>&1; then
    MYVMMANAGER="VMWare"
  elif which VirtualBox >/dev/null 2>&1; then
    MYVMMANAGER="VirtualBox"
  elif which kubectl >/dev/null 2>&1; then
    MYVMMANAGER="kubectl"
  elif which docker >/dev/null 2>&1; then
    MYVMMANAGER="docker"
  fi
fi
export VMMANAGER="$MYVMMANAGER"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export torrent client
if [ -n "$SSH_CONNECTION" ] || [ -z "$DISPLAY" ]; then
  if which transmission-remote >/dev/null 2>&1; then
    MYTORRENT="transmission-remote"
  fi
else
  if which transmission-remote-gtk >/dev/null 2>&1; then
    MYTORRENT="transmission-remote-gtk"
  elif which transmission-gtk >/dev/null 2>&1; then
    MYTORRENT="transmission-gtk"
  elif which transmission-cli >/dev/null 2>&1; then
    MYTORRENT="transmission-cli"
  elif which transmission-qt >/dev/null 2>&1; then
    MYTORRENT="transmission-qt"
  elif which deluge >/dev/null 2>&1; then
    MYTORRENT="deluge"
  elif which vuze >/dev/null 2>&1; then
    MYTORRENT="vuze"
  elif which qbittorrent >/dev/null 2>&1; then
    MYTORRENT="qbittorrent"
  elif which ktorrent >/dev/null 2>&1; then
    MYTORRENT="ktorrent"
  elif which ctorrent >/dev/null 2>&1; then
    MYTORRENT="ctorrent"
  elif which unworkable >/dev/null 2>&1; then
    MYTORRENT="unworkable"
  elif which rtorrent >/dev/null 2>&1; then
    MYTORRENT="rtorrent"
  elif which bitstormlite >/dev/null 2>&1; then
    MYTORRENT="bitstormlite"
  elif [ -f "/Applications/Transmission.app/Contents/MacOS/Transmission" ]; then
    MYTORRENT="/Applications/Transmission.app/Contents/MacOS/Transmission"
  elif which transmission-remote >/dev/null 2>&1; then
    MYTORRENT="transmission-remote"
  fi
fi
export TORRENT="$MYTORRENT"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export email client
if [ -n "$SSH_CONNECTION" ] || [ -z "$DISPLAY" ]; then
  if which neomutt >/dev/null 2>&1; then
    MYEMAIL="neomutt"
  elif which mutt >/dev/null 2>&1; then
    MYEMAIL="mutt"
  elif which emacs >/dev/null 2>&1; then
    MYEMAIL="emacs"
  fi
else
  if which thunderbird >/dev/null 2>&1; then
    MYEMAIL="thunderbird"
  elif which evolution >/dev/null 2>&1; then
    MYEMAIL="evolution"
  elif which clawsmail >/dev/null 2>&1; then
    MYEMAIL="clawsmail"
  elif which geary >/dev/null 2>&1; then
    MYEMAIL="geary"
  elif which kmail >/dev/null 2>&1; then
    MYEMAIL="kmail"
  elif which gmail >/dev/null 2>&1; then
    MYEMAIL="mybrowser https://gmail.com"
  elif which ymail >/dev/null 2>&1; then
    MYEMAIL="mybrowser https://ymail.com"
  elif which sylpheed >/dev/null 2>&1; then
    MYEMAIL="sylpheed"
  elif which neomutt >/dev/null 2>&1; then
    MYEMAIL="neomutt"
  elif which mutt >/dev/null 2>&1; then
    MYEMAIL="mutt"
  elif which emacs >/dev/null 2>&1; then
    MYEMAIL="emacs"
  fi
fi
export EMAIL="$MYEMAIL"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export editor
if [ -n "$SSH_CONNECTION" ] || [ -z "$DISPLAY" ]; then
  if which nvim >/dev/null 2>&1; then
    MYEDITOR="nvim"
  elif which vim >/dev/null 2>&1; then
    MYEDITOR="vim"
  elif which nano >/dev/null 2>&1; then
    MYEDITOR="nano"
  elif which emacs >/dev/null 2>&1; then
    MYEDITOR="emacs"
  fi
else
  if which code-insiders >/dev/null 2>&1; then
    MYEDITOR="code-insiders"
  elif which code >/dev/null 2>&1; then
    MYEDITOR="code"
  elif which vscode >/dev/null 2>&1; then
    MYEDITOR="vscode"
  elif which code-oss >/dev/null 2>&1; then
    MYEDITOR="code-oss"
  elif which geany >/dev/null 2>&1; then
    MYEDITOR="geany"
  elif which gedit >/dev/null 2>&1; then
    MYEDITOR="gedit"
  elif which atom >/dev/null 2>&1; then
    MYEDITOR="atom"
  elif which brackets >/dev/null 2>&1; then
    MYEDITOR="brackets"
  elif which mousepad >/dev/null 2>&1; then
    MYEDITOR="mousepad"
  elif which vim >/dev/null 2>&1; then
    MYEDITOR="vim"
  elif which nvim >/dev/null 2>&1; then
    MYEDITOR="nvim"
  elif which nano >/dev/null 2>&1; then
    MYEDITOR="nano"
  elif which emacs >/dev/null 2>&1; then
    MYEDITOR="emacs"
  fi
fi
export EDITOR="$MYEDITOR"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export git version format
export VERSION_DATE_FORMAT="%Y%m%d%H%M-git"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export todo config
export TODO_DIR="$HOME/.local/share/editors/todos"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export todo.sh config
#export TODOSH_DIR="$HOME/.local/share/todo.sh"
#export TODOTXT_CFG_FILE="$TODOSH_DIR/config"
#export TODOTXT_FILE="$TODOSH_DIR/todo.txt"
#export TODOTXT_DONE_FILE="$TODOSH_DIR/done.txt"
#export TODOTXT_REPORT_FILE="$TODOSH_DIR/report.txt"
#[ -d "$TODOSH_DIR" ] || mkdir -p "$TODOSH_DIR"
#[ -f "$TODOTXT_CFG_FILE" ] || touch "$TODOTXT_CFG_FILE"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export color
export CLICOLOR="1"
export GREP_COLORS='mt=38;5;220;1'
[ -f "$HOME/.config/misc/shell/other/ls" ] && . "$HOME/.config/misc/shell/other/ls"
[ -f "$HOME/.config/misc/shell/other/grep" ] && . "$HOME/.config/misc/shell/other/grep"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lf file manager icons
which lf >/dev/null 2>&1 && [ -f "$HOME/.config/misc/shell/other/lf" ] && . "$HOME/.config/misc/shell/other/lf"
export LF_ICONS
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup wallpaper directory
export WALLPAPER_DIR="$HOME/.local/share/wallpapers"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup theme directory
export THEME_DIR="$HOME/.local/share/themes"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup icon directory
export ICON_DIR="$HOME/.local/share/icons"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup font directory
export FONT_DIR="$HOME/.local/share/fonts"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set term type
export TERM="screen-256color"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# logging
export DEFAULT_LOG="apps"
export LOGDIR="$LOGS_DIRECTORY"
export DEFAULT_LOG_DIR="$LOGS_DIRECTORY"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Set scripts path if installed manually
if [ -d "$HOME/.local/share/scripts/bin" ] && [ -d "$HOME/.local/share/scripts/functions" ]; then
  CASJAYSDEVDIR="$HOME/.local/share/scripts"
  TMP_BIN_PATH="$CASJAYSDEVDIR:$TMP_BIN_PATH"
elif [ -d "$HOME/.local/share/CasjaysDev/scripts/bin" ] && [ -d "$HOME/.local/share/CasjaysDev/scripts/functions" ]; then
  CASJAYSDEVDIR="$HOME/.local/share/CasjaysDev/scripts"
  TMP_BIN_PATH="$CASJAYSDEVDIR:$TMP_BIN_PATH"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#asciinema settings
export ASCIINEMA_API_URL="https://asciinema.org"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# cheat.sh settings
export CHTSH_HOME="$HOME/.config/cheatsh"
[ -d "$CHTSH_HOME" ] || mkdir -p "$CHTSH_HOME"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# task warrior settings - I no lnonger use
#export TASKRC="$HOME/.taskrc"
#export TASKDATA="$HOME/.local/share/taskwarrior"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# multi_clipboard
if which multi_clipboard >/dev/null 2>&1; then
  export SCREENEXCHANGE="$HOME/.screen-exchange"
  export SCREEN_MSGMINWAIT="1"
  export CLIPBOARD="$HOME/.cache/.clipboard"
  export CLMAXHIST="20"
  export CLSEP='\x07'
  if [ "$(uname -s)" = Linux ]; then
    if which xsel >/dev/null 2>&1; then
      export CLXOS="xsel"
      export CLX="xsel"
    elif which xclip >/dev/null 2>&1; then
      export CLXOS="xclip"
      export CLX="xclip"
    fi
  elif [ "$(uname -s)" = cygwin ]; then
    if which xsel >/dev/null 2>&1; then
      export CLXOS="xsel"
      export CLX="xsel"
    elif which xclip >/dev/null 2>&1; then
      export CLXOS="xclip"
      export CLX="xclip"
    fi
  elif [ "$(uname -s)" = Darwin ]; then
    if which pbcopy >/dev/null 2>&1; then
      export CLXOS="pbcopy"
      export CLX="pbcopy"
    fi
  fi
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# fix - https://brew.sh
export HOMEBREW_INSTALL_BADGE="☕️ 🐸"
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# cursor
if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
  printf '%b' '\x1b[\x35 q' 2>/dev/null
  printf '%b' '\e]12;cyan\a' 2>/dev/null
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# global functions
[ -f "$HOME/.config/shell/functions/global.sh" ] && . "$HOME/.config/shell/functions/global.sh"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# passmgr settings - add your passmgr setup here
[ -f "$HOME/.config/secure/passmgr.txt" ] && . "$HOME/.config/secure/passmgr.txt"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# github settings - add github settings here
[ -f "$HOME/.config/secure/github.txt" ] && . "$HOME/.config/secure/github.txt"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# gitlab settings - add gitlab settings here
[ -f "$HOME/.config/secure/gitlab.txt" ] && . "$HOME/.config/secure/gitlab.txt"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# your private git - add your private git here
[ -f "$HOME/.config/secure/gitpriv.txt" ] && . "$HOME/.config/secure/gitpriv.txt"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# add your personal dotfiles repo here
[ -f "$HOME/.config/secure/personal.txt" ] && . "$HOME/.config/secure/personal.txt"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# store API keys here
[ -f "$HOME/.config/secure/apikeys.txt" ] && . "$HOME/.config/secure/apikeys.txt"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create env vars from shell files
if [ $(find -L "$HOME/.config/secure/inc" -type f -name '*.sh' 2>/dev/null | grep '^' || false) ]; then
  cat "$HOME/.config/secure/inc"/*.sh 2>/dev/null >"$HOME/.config/secure/env"
  [ -f "$HOME/.config/secure/env.sh" ] && . "$HOME/.config/secure/env.sh"
else
  rm -Rf "$HOME/.config/secure/env.sh" >/dev/null 2>&1
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# import local profile - override all other settings
[ -f "$HOME/.config/local/profile.local" ] && . "$HOME/.config/local/profile.local"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# import specific profiles for systems
[ -f "$HOME/.config/local/servers/$HOSTNAME_FULL.local" ] && . "$HOME/.config/local/servers/$HOSTNAME_FULL.local"
[ -f "$HOME/.config/local/servers/$HOSTNAME_SHORT.local" ] && . "$HOME/.config/local/servers/$HOSTNAME_SHORT.local"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Create directories
[ -d "$HOME/.config/local" ] || mkdir -p "$HOME/.config/local"
[ -d "$HOME/.config/secure/inc" ] || mkdir -p "$HOME/.config/secure/inc"
[ -n "$TMPDIR" ] && { [ -d "$TMPDIR" ] || mkdir -p "$TMPDIR"; }
[ -n "$LOGDIR" ] && { [ -d "$LOGDIR" ] || mkdir -p "$LOGDIR"; }
[ -n "$ICON_DIR" ] && { [ -d "$ICON_DIR" ] || mkdir -p "$ICON_DIR"; }
[ -n "$FONT_DIR" ] && { [ -d "$FONT_DIR" ] || mkdir -p "$FONT_DIR"; }
[ -n "$THEME_DIR" ] && { [ -d "$THEME_DIR" ] || mkdir -p "$THEME_DIR"; }
[ -n "$USRBINDIR" ] && { [ -d "$USRBINDIR" ] || mkdir -p "$USRBINDIR"; }
[ -n "$WALLPAPER_DIR" ] && { [ -d "$WALLPAPER_DIR" ] || mkdir -p "$WALLPAPER_DIR"; }
[ -n "$SETV_VIRTUAL_DIR_PATH" ] && { [ -d "$SETV_VIRTUAL_DIR_PATH" ] || mkdir -p "$SETV_VIRTUAL_DIR_PATH"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# bring in apps

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set profile as sourced
export PROFILERCSRC="$HOME/.profile"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Autolaunch application on ssh connection
if [ -n "$SSH_CONNECTION" ]; then
  [ -f "$HOME/.config/misc/shell/other/ssh" ] && . "$HOME/.config/misc/shell/other/ssh"
  [ -f "$HOME/.config/local/ssh.launch" ] && . "$HOME/.config/local/ssh.launch"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# fix PATH
if [ -z "$FNM_MULTISHELL_PATH" ]; then
  SET_USR_PATH="$(echo "$TMP_BIN_PATH" | tr ':' '\n' | grep -Fv '..' | grep "$HOME" | grep -vE "^\.|$USRBINDIR" | sed 's|:.$||g' | grep -v '^$' | tr '\n' ':' | sed 's|:$||g')"
  PATH="$SET_USR_PATH:$USRBINDIR:$SYSBINDIR:."
else
  SET_USR_PATH="$(echo "$TMP_BIN_PATH" | tr ':' '\n' | grep -Fv '..' | grep "$HOME" | grep -vE "^\.|$USRBINDIR|$FNM_MULTISHELL_PATH" | sed 's|:.$||g' | grep -v '^$' | tr '\n' ':' | sed 's|:$||g')"
  PATH="$FNM_MULTISHELL_PATH/bin:$SET_USR_PATH:$USRBINDIR:$SYSBINDIR:."
fi
export PATH
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# unset unneeded vars
unset SET_PATH SET_TMP_PATH TMP_BIN_PATH
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
