#!/usr/bin/env bash

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set path
PATH="/usr/local/bin:$HOME/.local/bin:$PATH"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set umask
#umask 022

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create directories
mkdir -p "$HOME/.ssh"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/log"
mkdir -p "$HOME/.local/tmp"
mkdir -p "$HOME/.config/todo"
mkdir -p "$HOME/.config/cheatsh"
mkdir -p "$HOME/.local/share/fnm"
mkdir -p "$HOME/.local/share/nvm"
mkdir -p "$HOME/.local/share/rvm"
mkdir -p "$HOME/.local/share/gem/bin"
mkdir -p "$HOME/.local/share/wallpapers"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setting the temp directory
export TMP="${TEMP:-$HOME/.local/tmp}"
export TEMP="${TEMP:-$HOME/.local/tmp}"

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
export LC_ALL="$LC_ALL"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# bash specific
if [ -n "$BASH_VERSION" ]; then
  export BASH_SILENCE_DEPRECATION_WARNING=1
  export BASH_COMPLETION_USER_DIR="$HOME/.local/share/bash-completion/completions"
  export HISTCONTROL=ignoreboth
  export HISTFILESIZE=10000
  export HISTIGNORE="&:[bf]g:c:clear:history:exit:q"
  export HISTSIZE=10000
  cmd_exists direnv && eval "$(direnv hook bash)"  || true

# zsh specific
elif [ -n "$ZSH_VERSION" ]; then
  export ZDOTDIR="$HOME/.config/zsh"
  export ZSH_CACHEDIR="$HOME/.cache/oh-my-zsh"
  export ZSH="$HOME/.local/share/zsh/oh-my-zsh"
  export ZSH_CUSTOM="$HOME/.local/share/zsh/oh-my-zsh/custom"
  export HISTFILE="${ZDOTDIR/.history:-$HOME/.cache/zhistory}"
  export SAVEHIST=5000
  export HISTSIZE=2000
  cmd_exists direnv && eval "$(direnv hook zsh)"  || true
  autoload compinit && compinit
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# configure display
if [ -n "$DISPLAY" ]; then
  case "$(uname -s)" in
  Linux)
    if cat /proc/version | grep -iq chromium && [ ! -z $DISPLAY ] && [ ! -z $DISPLAY_LOW_DENSITY ]; then
      export DISPLAY="$DISPLAY_LOW_DENSITY"
    fi
    cmd_exists xrandr && export RESOLUTION="$(xrandr --current | grep '*' | uniq | awk '{print $1}')"  || true
    ;;
  esac
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# disable blank screen
if [ -n "$DISPLAY" ]; then
  case "$(uname -s)" in
  Linux)
    cmd_exists xset && xset s off >/dev/null 2>&1  || true
    cmd_exists xset && xset -dpms >/dev/null 2>&1  || true
    cmd_exists xset && xset s off -dpms >/dev/null 2>&1  || true
    ;;
  esac
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# enviroment variables when using a desktop
if [ -n "$DISPLAY" ]; then
  case "$(uname -s)" in
  Linux)
    cmd_exists dbus-update-activation-environment && dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY  || true
    ;;
  esac
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# enable control alt backspace
if [ -n "$DISPLAY" ]; then
  case "$(uname -s)" in
  Linux)
    export XKBOPTIONS="terminate:ctrl_alt_bksp"
    cmd_exists setxkbmap && setxkbmap -model pc104 -layout us -option "terminate:ctrl_alt_bksp"  || true
    ;;
  esac
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# setup modifiers
if [ -n "$DISPLAY" ]; then
  case "$(uname -s)" in
  Linux)
    if [ -n "$(command -v ibus)" ]; then
      export XMODIFIERS=@im=ibus
      export GTK_IM_MODULE=ibus
      export QT_IM_MODULE=ibus
    elif [ -n "$(command -v fcitx)" ]; then
      export XMODIFIERS=@im=fcitx
      export GTK_IM_MODULE=fcitx
      export QT_IM_MODULE=fcitx
    fi
    ;;
  esac
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# xserver settings
if [ -n "$DISPLAY" ]; then
  case "$(uname -s)" in
  Linux)
    if [ ! -f ~/.Xdefaults ]; then
      touch ~/.Xdefaults
    else
      cmd_exists xrdb && xrdb ~/.Xdefaults 2>/dev/null || true
    fi
    ;;
  esac
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# xserver settings
if [ -n "$DISPLAY" ]; then
  case "$(uname -s)" in
  Linux)
    if [ ! -f ~/.Xresources ]; then
      touch ~/.Xresources
    else
      cmd_exists xrdb && xrdb ~/.Xresources 2>/dev/null || true
      cmd_exists xrdb && xrdb -merge ~/.Xresources 2>/dev/null || true
    fi
    ;;
  esac
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ensure .gitconfig exists
if [ -f ~/.config/local/gitconfig.local ] && [ ! -f ~/.gitconfig ]; then
  cp -f ~/.config/local/gitconfig.local ~/.gitconfig
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Sudo prompt
case "$(uname -s)" in
Linux | Darwin)
  export SUDO_PROMPT="$(printf "\t\t\033[1;36m")[sudo]$(printf "\033[0m") password for %p: "
  ;;
Linux)
  if [ ! -z "$DESKTOP_SESSION" ] && [ -e "/usr/local/bin/dmenupass" ]; then
    export SUDO_ASKPASS="${SUDO_ASKPASS:-/usr/local/bin/dmenupass}"
  fi
  ;;
esac

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export gpg tty
  export GPG_TTY="$(tty)"
  export SSH_AUTH_SOCK="/run/user/$(id -u)/gnupg/S.gpg-agent.ssh"
  cmd_exists gpg-agent && eval "$(gpg-agent --daemon 2>/dev/null)"  || true

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export ssh
  if [ ! -S "$HOME/.ssh/ssh_auth_sock" ]; then
    cmd_exists ssh-agent && eval "$(ssh-agent >/dev/null 2>&1)"  || true
    ln -sf "${SSH_AUTH_SOCK}" ${HOME}/.ssh/ssh_auth_sock
  fi

  sshdir=$(ls "$HOME"/.ssh/id_* 2>/dev/null | wc -l)
  if [ "$sshdir" != "0" ]; then
    for f in $(ls "$HOME"/.ssh/id_* | grep -v .pub); do
      ssh-add "$f" >/dev/null 2>&1
    done
  fi

export SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-$HOME/.ssh/ssh_auth_sock}"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Use custom `less` colors for `man` pages.
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Don't clear the screen after quitting a `man` page.
export MANPAGER="less -X"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# add emacs to bin
if [ -d $HOME/.emacs.d/bin ]; then
  export PATH="$HOME/.emacs.d/bin:$PATH"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# rpm devel
export QA_RPATHS="$((0x0001 | 0x0010))"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# mpd name
export MPDSERVER="$(hostname)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set hostname
export HOSTNAME=$(hostname -f 2>/dev/null || hostname -s 2>/dev/null || hostname 2>/dev/null)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# tizonia cloud player config
export TIZONIA_RC_FILE="$HOME/.config/tizonia/tizonia.conf"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create a banner
if [ -n "$(command -v figlet 2>/dev/null)" ]; then
  export BANNER="figlet -f banner"
elif [ -n "$(command -v toilet 2>/dev/null)" ]; then
  export BANNER="toilet -f mono9.tlf"
elif [ -n "$(command -v banner 2>/dev/null)" ]; then
  export BANNER="banner"
else
  export BANNER="echo -e"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup ruby
export GEM_HOME="$HOME/.local/share/gem"
export GEM_PATH="$HOME/.local/share/gem"
export PATH="$GEM_HOME/bin:$PATH"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Ruby Version Manager
if [ -s "$HOME/.rvm/scripts/rvm" ]; then source "$HOME/.local/share/rvm/scripts/rvm"; fi
if [ -d $HOME/.local/share/rvm/bin ]; then PATH="$HOME/.local/share/rvm/bin:$PATH"; fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Fast Node Manager 
  export FNM_DIR="$HOME/.local/share/fnm"
  export FNM_MULTISHELL_PATH="$HOME/.local/bin"
  cmd_exists fmv && eval "$(fnm env --multi --use-on-cd --fnm-dir=$HOME/.local/share/fnm/ )" || true

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# node version manager
export NVM_DIR="$HOME/.local/share/nvm"
export NVM_BIN="$HOME/.local/bin"
export NO_UPDATE_NOTIFIER="true"
export NODE_REPL_HISTORY_SIZE=10000
if [ -s "$NVM_DIR/nvm.sh" ]; then source "$NVM_DIR/nvm.sh"; fi
if [ -s "$NVM_DIR/bash_completion" ]; then source "$NVM_DIR"/bash_completion; fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# setup setV
export SETV_VIRTUAL_DIR_PATH="$HOME/.local/share/venv/"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# configure GO
export GOPATH="$HOME/.local/share/go"
export GOBIN="$GOPATH/bin"
export GODIR="$GOPATH"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Add Rust/Cargo to the path
export PATH="$HOME/.cargo/bin:$PATH"
if [ -f "$HOME/.cargo/env" ]; then source "$HOME/.cargo/env"; fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export browser
if [ -n "$(command -v garcon-url-handler 2>/dev/null)" ]; then
  export BROWSER="garcon-url-handler --url"
elif [ -n "$(command -v firefox 2>/dev/null)" ]; then
  export BROWSER="firefox"
elif [ -n "$(command -v chromium 2>/dev/null)" ]; then
  export BROWSER="chromium"
elif [ -n "$(command -v google-chrome 2>/dev/null)" ]; then
  export BROWSER="google-chrome"
elif [ -n "$(command -v opera 2>/dev/null)" ]; then
  export BROWSER="opera"
elif [ -n "$(command -v epiphany-browser 2>/dev/null)" ]; then
  export BROWSER="epiphany-browser"
elif [ -n "$(command -v falkon 2>/dev/null)" ]; then
  export BROWSER="falkon"
elif [ -n "$(command -v midori 2>/dev/null)" ]; then
  export BROWSER="midori"
elif [ -n "$(command -v netsurf 2>/dev/null)" ]; then
  export BROWSER="netsurf"
elif [ -n "$(command -v surf 2>/dev/null)" ]; then
  export BROWSER="surf"
elif [ -n "$(command -v arora 2>/dev/null)" ]; then
  export BROWSER="arora"
elif [ -f "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ]; then
  export BROWSER="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
elif [ -f "/Applications/Firefox.app/Contents/MacOS/firefox-bin" ]; then
  export BROWSER="/Applications/Firefox.app/Contents/MacOS/firefox-bin"
elif [ -n "$(command -v lynx 2>/dev/null)" ]; then
  export BROWSER="lynx"
elif [ -n "$(command -v links 2>/dev/null)" ]; then
  export BROWSER="links"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export terminal
if [ -n "$(command -v termite 2>/dev/null)" ]; then
  export TERMINAL="termite"
elif [ -n "$(command -v terminology 2>/dev/null)" ]; then
  export TERMINAL="terminology"
elif [ -n "$(command -v xfce4-terminal 2>/dev/null)" ]; then
  export TERMINAL="xfce4-terminal"
elif [ -n "$(command -v qterminal-terminal 2>/dev/null)" ]; then
  export TERMINAL="qterminal-terminal"
elif [ -n "$(command -v qterminal-terminal 2>/dev/null)" ]; then
  export TERMINAL="qterminal-terminal"
elif [ -n "$(command -v xterm 2>/dev/null)" ]; then
  export TERMINAL="xterm"
elif [ -n "$(command -v uxterm 2>/dev/null)" ]; then
  export TERMINAL="uxterm"
elif [ -f "/Applications/iTerm.app/Contents/MacOS/iTerm" ]; then
  export TERMINAL="/Applications/iTerm.app/Contents/MacOS/iTerm"
elif [ -f "/System/Applications/Utilities/Terminal.app/Contents/MacOS/Terminal" ]; then
  export TERMINAL="/System/Applications/Utilities/Terminal.app/Contents/MacOS/Terminal"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# virtual machine manager
if [ -n "$(command -v VirtualBox 2>/dev/null)" ]; then
  VMMANAGER="VirtualBox"
elif [ -n "$(command -v VMWare 2>/dev/null)" ]; then
  VMMANAGER="VMWare"
elif [ -n "$(command -v virt-manager 2>/dev/null)" ]; then
  VMMANAGER="virt-manager"
elif [ -n "$(command -v kubectl 2>/dev/null)" ]; then
  VMMANAGER="kubectl"
elif [ -n "$(command -v docker 2>/dev/null)" ]; then
  VMMANAGER="docker"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export torrent client
if [ -n "$(command -v transmission-remote-gtk 2>/dev/null)" ]; then
  export TORRENT="transmission-remote-gtk"
elif [ -n "$(command -v transmission-remote-cli 2>/dev/null)" ]; then
  export TORRENT="transmission-remote-cli"
elif [ -n "$(command -v transmission-gtk 2>/dev/null)" ]; then
  export TORRENT="transmission-gtk"
elif [ -n "$(command -v transmission-qt 2>/dev/null)" ]; then
  export TORRENT="transmission-qt"
elif [ -n "$(command -v deluge 2>/dev/null)" ]; then
  export TORRENT="deluge"
elif [ -n "$(command -v vuze 2>/dev/null)" ]; then
  export TORRENT="vuze"
elif [ -n "$(command -v qbittorrent)" ]; then
  export TORRENT="qbittorrent"
elif [ -n "$(command -v ktorrent 2>/dev/null)" ]; then
  export TORRENT="ktorrent"
elif [ -n "$(command -v ctorrent 2>/dev/null)" ]; then
  export TORRENT="ctorrent"
elif [ -n "$(command -v unworkable 2>/dev/null)" ]; then
  export TORRENT="unworkable"
elif [ -n "$(command -v rtorrent 2>/dev/null)" ]; then
  export TORRENT="rtorrent"
elif [ -n "$(command -v bitstormlite 2>/dev/null)" ]; then
  export TORRENT="bitstormlite"
elif [ -f "/Applications/Transmission.app/Contents/MacOS/Transmission" ]; then
  export TORRENT="/Applications/Transmission.app/Contents/MacOS/Transmission"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export email client
if [ -n "$(command -v thunderbird 2>/dev/null)" ]; then
  EMAIL="thunderbird"
elif [ -n "$(command -v evolution 2>/dev/null)" ]; then
  EMAIL="evolution"
elif [ -n "$(command -v clawsmail 2>/dev/null)" ]; then
  EMAIL="clawsmail"
elif [ -n "$(command -v geary 2>/dev/null)" ]; then
  EMAIL="geary"
elif [ -n "$(command -v neomutt 2>/dev/null)" ]; then
  EMAIL="myterminal -e neomutt"
elif [ -n "$(command -v mutt 2>/dev/null)" ]; then
  EMAIL="myterminal -e mutt"
elif [ -n "$(command -v kmail 2>/dev/null)" ]; then
  EMAIL="kmail"
elif [ -n "$(command -v emacs 2>/dev/null)" ]; then
  EMAIL="emacs"
elif [ -n "$(command -v gmail 2>/dev/null)" ]; then
  EMAIL="mybrowser https://gmail.com"
elif [ -n "$(command -v sylpheed 2>/dev/null)" ]; then
  EMAIL="sylpheed"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export editor
if [ -n "$(command -v code 2>/dev/null)" ]; then
  export EDITOR="code"
elif [ -n "$(command -v vscode 2>/dev/null)" ]; then
  export EDITOR="vscode"
elif [ -n "$(command -v vim 2>/dev/null)" ]; then
  export EDITOR="vim"
elif [ -n "$(command -v nvim 2>/dev/null)" ]; then
  export EDITOR="nvim"
elif [ -n "$(command -v geany 2>/dev/null)" ]; then
  export EDITOR="geany"
elif [ -n "$(command -v gedit 2>/dev/null)" ]; then
  export EDITOR="gedit"
elif [ -n "$(command -v atom 2>/dev/null)" ]; then
  export EDITOR="atom"
elif [ -n "$(command -v brackets 2>/dev/null)" ]; then
  export EDITOR="brackets"
elif [ -n "$(command -v emacs 2>/dev/null)" ]; then
  export EDITOR="emacs"
elif [ -n "$(command -v mousepad 2>/dev/null)" ]; then
  export EDITOR="mousepad"
elif [ -n "$(command -v nano 2>/dev/null)" ]; then
  export EDITOR="nano"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export todo.sh config
export TODO_DIR="$HOME/.local/share/todo"
export TODOTXT_CFG_FILE="$HOME/.config/todo/config"
export TODO_FILE="$HOME/.local/share/todo/todo.txt"
export DONE_FILE="$HOME/.local/share/todo/done.txt"
export REPORT_FILE="$HOME/.local/share/todo/report.txt"

if [ ! -f "$TODOTXT_CFG_FILE" ]; then
  touch "$TODOTXT_CFG_FILE"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export notes dir
export NOTES_DIRECTORY="$HOME/.local/share/notes"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export color
export CLICOLOR=1
export GREP_COLORS="mt=37;45"

if [ -f "$HOME/.dircolors" ]; then
  export DIRCOLOR="$HOME/.dircolors"
else
  export DIRCOLOR="$HOME/.config/dircolors/dracula"
fi

case "$(uname -s)" in
Linux)
  cmd_exists dircolors && eval "$(dircolors $DIRCOLOR)"  || true
  ;;
Darwin)
  export LSCOLORS=exfxcxdxbxegedabagacad
  cmd_exists gdircolors && eval "$(gdircolors $DIRCOLOR)"  || true
  ;;
esac

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup wallpaper directory
export WALLPAPERS="$HOME/.local/share/wallpapers"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lf file manager icons
cmd_exists lf && export LF_ICONS="di=:fi=:ln=:or=:ex=:*.c=:*.cc=:*.clj=:*.coffee=:*.cpp=:*.css=:*.d=:*.dart=:*.erl=:*.exs=:*.fs=:*.go=:*.h=:*.hh=:*.hpp=:*.hs=:*.html=:*.java=:*.jl=:*.js=:*.json=:*.lua=:*.md=:*.php=:*.pl=:*.pro=:*.py=:*.rb=:*.rs=:*.scala=:*.ts=:*.vim=:*.cmd=:*.ps1=:*.sh=:*.bash=:*.zsh=:*.fish=:*.tar=:*.tgz=:*.arc=:*.arj=:*.taz=:*.lha=:*.lz4=:*.lzh=:*.lzma=:*.tlz=:*.txz=:*.tzo=:*.t7z=:*.zip=:*.z=:*.dz=:*.gz=:*.lrz=:*.lz=:*.lzo=:*.xz=:*.zst=:*.tzst=:*.bz2=:*.bz=:*.tbz=:*.tbz2=:*.tz=:*.deb=:*.rpm=:*.jar=:*.war=:*.ear=:*.sar=:*.rar=:*.alz=:*.ace=:*.zoo=:*.cpio=:*.7z=:*.rz=:*.cab=:*.wim=:*.swm=:*.dwm=:*.esd=:*.jpg=:*.jpeg=:*.mjpg=:*.mjpeg=:*.gif=:*.bmp=:*.pbm=:*.pgm=:*.ppm=:*.tga=:*.xbm=:*.xpm=:*.tif=:*.tiff=:*.png=:*.svg=:*.svgz=:*.mng=:*.pcx=:*.mov=:*.mpg=:*.mpeg=:*.m2v=:*.mkv=:*.webm=:*.ogm=:*.mp4=:*.m4v=:*.mp4v=:*.vob=:*.qt=:*.nuv=:*.wmv=:*.asf=:*.rm=:*.rmvb=:*.flc=:*.avi=:*.fli=:*.flv=:*.gl=:*.dl=:*.xcf=:*.xwd=:*.yuv=:*.cgm=:*.emf=:*.ogv=:*.ogx=:*.aac=:*.au=:*.flac=:*.m4a=:*.mid=:*.midi=:*.mka=:*.mp3=:*.mpc=:*.ogg=:*.ra=:*.wav=:*.oga=:*.opus=:*.spx=:*.xspf=:*.pdf="

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set term type
export TERM="screen-256color"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# logging
export DEFAULT_LOG="scripts"
export DEFAULT_LOG_DIR="${LOGDIR:-$HOME/.local/log}"
export LOGDIR="${DEFAULT_LOG_DIR:-$HOME/.local/log}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set PATH so it includes user's private bin if it exists
if [ -d "$HOME"/.local/bin ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME"/.local/share/scripts/bin ]; then
  export PATH="$HOME/.local/share/scripts/bin:$PATH"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# cheat.sh settings
export CHTSH_HOME="$HOME/.config/cheatsh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# task warrior settings

export TASKRC="$HOME/.taskrc"
export TASKDATA="$HOME/.local/share/taskwarrior"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export vdpau driver
case "$(uname -s)" in
Linux)
  if [ -n "$VDPAU_DRIVER" ]; then
    export VDPAU_DRIVER=va_gl
  fi
  ;;
esac

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# import local profile
if [ -f "$HOME/.config/local/profile.local" ]; then
  . "$HOME/.config/local/profile.local"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# passmgr default settings - copy to your bash.local and change for your setup
if [ -f "$HOME/.config/secure/passmgr.txt" ]; then
  . "$HOME/.config/secure/passmgr.txt"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# github default settings - copy to your bash.local and change for your setup
if [ -f "$HOME/.config/secure/github.txt" ]; then
  . "$HOME/.config/secure/github.txt"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# gitlab default settings - copy to your bash.local and change for your setup
if [ -f "$HOME/.config/secure/gitlab.txt" ]; then
  . "$HOME/.config/secure/gitlab.txt"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# your private git - copy to your bash.local and change for your setup
if [ -f "$HOME/.config/secure/gitpriv.txt" ]; then
  . "$HOME/.config/secure/gitpriv.txt"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Dotfiles base repo  - copy to your bash.local and change for your setup
if [ -f "$HOME/.config/secure/personal.txt" ]; then
  . "$HOME/.config/secure/personal.txt"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# APIKEYS  - copy to your bash.local and change for your setup
if [ -f "$HOME/.config/secure/apikeys.txt" ]; then
  . "$HOME/.config/secure/apikeys.txt"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# cursor
if [ -n "$BASH_VERSION" ]; then
  echo -e -n "\x1b[\x35 q"
  echo -e -n "\e]12;white\a"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# unset unneeded vars
unset sshdir

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Make sure SBIN gets added to the path
export PATH="$PATH:/usr/local/sbin:/usr/bin:/sbin"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# fix PATH
export PATH="$(echo $PATH | tr ':' '\n' | awk '!seen[$0]++' | tr '\n' ':' | sed 's#::#:#g')"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set profile as sourced
export SRCPROFILERC="$HOME/.profile"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# end
