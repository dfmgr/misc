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
mkdir -p "$HOME/.local/share/rvm"
mkdir -p "$HOME/.local/share/gem/bin"
mkdir -p "$HOME/.local/share/nodejs/fnm"
mkdir -p "$HOME/.local/share/nodejs/nvm"
mkdir -p "$HOME/.local/share/wallpapers"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setting the temp directory
export TMP="${TMP:-$HOME/.local/tmp}"
export TEMP="${TMP:-$HOME/.local/tmp}"

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
  if [ -f "$(command -v direnv 2>/dev/null)" ]; then direnv hook bash &>/dev/null; fi

# zsh specific
elif [ -n "$ZSH_VERSION" ]; then
  export ZDOTDIR="$HOME/.config/zsh"
  export ZSH_CACHEDIR="$HOME/.cache/oh-my-zsh"
  export ZSH="$HOME/.local/share/zsh/oh-my-zsh"
  export ZSH_CUSTOM="$HOME/.local/share/zsh/oh-my-zsh/custom"
  export ZSH_DISABLE_COMPFIX="${ZSH_DISABLE_COMPFIX:-true}"
  export HISTFILE="${ZDOTDIR/.history:-$HOME/.cache/zhistory}"
  export SAVEHIST=5000
  export HISTSIZE=2000
  if [ -f "$(command -v direnv 2>/dev/null)" ]; then direnv hook zsh &>/dev/null; fi
  #autoload compinit && compinit
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# configure display
if [ -n "$DISPLAY" ]; then
  case "$(uname -s)" in
  Linux)
    if cat /proc/version | grep -iq chromium && [ ! -z $DISPLAY ] && [ ! -z $DISPLAY_LOW_DENSITY ]; then
      export DISPLAY="$DISPLAY_LOW_DENSITY"
    fi
    if [ -f "$(command -v xrandr 2>/dev/null)" ]; then export RESOLUTION="$(xrandr --current | grep '*' | uniq | awk '{print $1}')"; fi
    ;;
  esac
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# disable blank screen
if [ -n "$DISPLAY" ]; then
  case "$(uname -s)" in
  Linux)
    if [ -f "$(command -v xset 2>/dev/null)" ]; then
      xset s off >/dev/null 2>&1
      xset -dpms >/dev/null 2>&1
      xset s off -dpms >/dev/null 2>&1
    fi
    ;;
  esac
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# enviroment variables when using a desktop
if [ -n "$DISPLAY" ]; then
  case "$(uname -s)" in
  Linux)
    if [ -f "$(command -v dbus-update-activation-environment 2>/dev/null)" ]; then
      dbus-update-activation-environment --systemd DBUS_SESSION_BUS_ADDRESS DISPLAY XAUTHORITY
    fi
    ;;
  esac
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# enable control alt backspace
if [ -n "$DISPLAY" ]; then
  case "$(uname -s)" in
  Linux)
    export XKBOPTIONS="terminate:ctrl_alt_bksp"
    if [ -f "$(command -v cmd 2>/dev/null)" ]; then setxkbmap setxkbmap -model pc104 -layout us -option "terminate:ctrl_alt_bksp"; fi
    ;;
  esac
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# setup modifiers
if [ -n "$DISPLAY" ]; then
  case "$(uname -s)" in
  Linux)
    if [ -f "$(command -v ibus 2>/dev/null)" ]; then
      export XMODIFIERS=@im=ibus
      export GTK_IM_MODULE=ibus
      export QT_IM_MODULE=ibus
    elif [ -f "$(command -v fcitx 2>/dev/null)" ]; then
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
      if [ -f "$(command -v xrdb 2>/dev/null)" ]; then xrdb ~/.Xdefaults 2>/dev/null; fi
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
      if [ -f "$(command -v xrdb 2>/dev/null)" ]; then
        xrdb ~/.Xresources 2>/dev/null
        xrdb -merge ~/.Xresources 2>/dev/null
      fi
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
Darwin)
  export SUDO_PROMPT="$(printf "\t\t\033[1;31m")[sudo]$(printf "\033[1;36m") password for $(printf "\033[1;32m")%p: $(printf "\033[0m")"
  ;;
Linux)
  if [ -n "$DESKTOP_SESSION" ] && [ -f "$(command -v dmenupass 2>/dev/null)" ]; then
    export SUDO_ASKPASS="dmenupass"
  else
    export SUDO_ASKPASS="${SUDO_ASKPASS}"
    export SUDO_PROMPT="$(printf "\t\t\033[1;31m")[sudo]$(printf "\033[1;36m") password for $(printf "\033[1;32m")%p: $(printf "\033[0m")"
  fi
  ;;
esac

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export gpg tty
if [ -f "$(command -v gpg-agent 2>/dev/null)" ]; then
  gpg-agent --daemon &>/dev/null
fi
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK="/run/user/$(id -u)/gnupg/S.gpg-agent.ssh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export ssh
if [ ! -S "$HOME/.ssh/ssh_auth_sock" ]; then
  if [ -f "$(command -v ssh-agent 2>/dev/null)" ]; then
    ssh-agent &>/dev/null
  fi
  ln -sf "${SSH_AUTH_SOCK}" ${HOME}/.ssh/ssh_auth_sock
fi

sshdir=$(ls ~/.ssh/id_* 2>/dev/null | wc -l)
if [ "$sshdir" -ne "0" ]; then
  for f in $(ls ~/.ssh/id_* 2>/dev/null | grep .pub); do
    ssh-add "$f" &>/dev/null &
  done
fi

export SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-$HOME/.ssh/ssh_auth_sock}"

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
# mpd server
export MPDSERVER="$(hostname -s)"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set hostname
export HOSTNAME=$(hostname -f 2>/dev/null)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# create a banner
if [ -f "$(command -v figlet 2>/dev/null)" ]; then
  export BANNER="figlet -f banner"
elif [ -f "$(command -v toilet 2>/dev/null)" ]; then
  export BANNER="toilet -f mono9.tlf"
elif [ -f "$(command -v banner 2>/dev/null)" ]; then
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
if [ -f "$HOME/.local/share/scripts/rvm" ]; then
  export rvm_path="$HOME/.local/share/rvm"
  if [ -f "$HOME/.local/share/rvm/scripts/rvm" ]; then source "$HOME/.local/share/rvm/scripts/rvm"; fi
  if [ -d $HOME/.local/share/rvm/bin ]; then
    PATH="$HOME/.local/share/rvm/bin:$PATH"
  fi
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Fast Node Manager
export FNM_DIR="$HOME/.local/share/nodejs/fnm"
export FNM_MULTISHELL_PATH="$HOME/.local/bin"
if [ -f "$(command -v fnm 2>/dev/null)" ]; then fnm env --use-on-cd --fnm-dir=$FNM_DIR/ &>/dev/null; fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# node version manager
export NVM_DIR="$HOME/.local/share/nodejs/nvm"
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

# Use hub as git if installed
if [ -f "$(command -v hub 2>/dev/null)" ]; then
  eval "$(hub alias -s >/dev/null 2>&1)"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export browser
if [ -f "$(command -v garcon-url-handler 2>/dev/null)" ]; then
  export BROWSER="garcon-url-handler --url"
elif [ -f "$(command -v firefox 2>/dev/null)" ]; then
  export BROWSER="firefox"
elif [ -f "$(command -v chromium 2>/dev/null)" ]; then
  export BROWSER="chromium"
elif [ -f "$(command -v google-chrome 2>/dev/null)" ]; then
  export BROWSER="google-chrome"
elif [ -f "$(command -v opera 2>/dev/null)" ]; then
  export BROWSER="opera"
elif [ -f "$(command -v epiphany-browser 2>/dev/null)" ]; then
  export BROWSER="epiphany-browser"
elif [ -f "$(command -v falkon 2>/dev/null)" ]; then
  export BROWSER="falkon"
elif [ -f "$(command -v midori 2>/dev/null)" ]; then
  export BROWSER="midori"
elif [ -f "$(command -v netsurf 2>/dev/null)" ]; then
  export BROWSER="netsurf"
elif [ -f "$(command -v surf 2>/dev/null)" ]; then
  export BROWSER="surf"
elif [ -f "$(command -v arora 2>/dev/null)" ]; then
  export BROWSER="arora"
elif [ -f "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ]; then
  export BROWSER="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
elif [ -f "/Applications/Firefox.app/Contents/MacOS/firefox-bin" ]; then
  export BROWSER="/Applications/Firefox.app/Contents/MacOS/firefox-bin"
elif [ -f "$(command -v lynx 2>/dev/null)" ]; then
  export BROWSER="lynx"
elif [ -f "$(command -v links 2>/dev/null)" ]; then
  export BROWSER="links"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export terminal
if [ -f "$(command -v termite 2>/dev/null)" ]; then
  export TERMINAL="termite"
elif [ -f "$(command -v terminology 2>/dev/null)" ]; then
  export TERMINAL="terminology"
elif [ -f "$(command -v xfce4-terminal 2>/dev/null)" ]; then
  export TERMINAL="xfce4-terminal"
elif [ -f "$(command -v qterminal-terminal 2>/dev/null)" ]; then
  export TERMINAL="qterminal-terminal"
elif [ -f "$(command -v qterminal-terminal 2>/dev/null)" ]; then
  export TERMINAL="qterminal-terminal"
elif [ -f "$(command -v xterm 2>/dev/null)" ]; then
  export TERMINAL="xterm"
elif [ -f "$(command -v uxterm 2>/dev/null)" ]; then
  export TERMINAL="uxterm"
elif [ -f "/Applications/iTerm.app/Contents/MacOS/iTerm" ]; then
  export TERMINAL="/Applications/iTerm.app/Contents/MacOS/iTerm"
elif [ -f "/System/Applications/Utilities/Terminal.app/Contents/MacOS/Terminal" ]; then
  export TERMINAL="/System/Applications/Utilities/Terminal.app/Contents/MacOS/Terminal"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# virtual machine manager
if [ -f "$(command -v VirtualBox 2>/dev/null)" ]; then
  export VMMANAGER="VirtualBox"
elif [ -f "$(command -v VMWare 2>/dev/null)" ]; then
  export VMMANAGER="VMWare"
elif [ -f "$(command -v virt-manager 2>/dev/null)" ]; then
  export VMMANAGER="virt-manager"
elif [ -f "$(command -v kubectl 2>/dev/null)" ]; then
  export VMMANAGER="kubectl"
elif [ -f "$(command -v docker 2>/dev/null)" ]; then
  export VMMANAGER="docker"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export torrent client
if [ -f "$(command -v transmission-remote-gtk 2>/dev/null)" ]; then
  export TORRENT="transmission-remote-gtk"
elif [ -f "$(command -v transmission-remote-cli 2>/dev/null)" ]; then
  export TORRENT="transmission-remote-cli"
elif [ -f "$(command -v transmission-gtk 2>/dev/null)" ]; then
  export TORRENT="transmission-gtk"
elif [ -f "$(command -v transmission-qt 2>/dev/null)" ]; then
  export TORRENT="transmission-qt"
elif [ -f "$(command -v deluge 2>/dev/null)" ]; then
  export TORRENT="deluge"
elif [ -f "$(command -v vuze 2>/dev/null)" ]; then
  export TORRENT="vuze"
elif [ -f "$(command -v qbittorrent)" ]; then
  export TORRENT="qbittorrent"
elif [ -f "$(command -v ktorrent 2>/dev/null)" ]; then
  export TORRENT="ktorrent"
elif [ -f "$(command -v ctorrent 2>/dev/null)" ]; then
  export TORRENT="ctorrent"
elif [ -f "$(command -v unworkable 2>/dev/null)" ]; then
  export TORRENT="unworkable"
elif [ -f "$(command -v rtorrent 2>/dev/null)" ]; then
  export TORRENT="rtorrent"
elif [ -f "$(command -v bitstormlite 2>/dev/null)" ]; then
  export TORRENT="bitstormlite"
elif [ -f "/Applications/Transmission.app/Contents/MacOS/Transmission" ]; then
  export TORRENT="/Applications/Transmission.app/Contents/MacOS/Transmission"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export email client
if [ -f "$(command -v thunderbird 2>/dev/null)" ]; then
  export EMAIL="thunderbird"
elif [ -f "$(command -v evolution 2>/dev/null)" ]; then
  export EMAIL="evolution"
elif [ -f "$(command -v clawsmail 2>/dev/null)" ]; then
  export EMAIL="clawsmail"
elif [ -f "$(command -v geary 2>/dev/null)" ]; then
  export EMAIL="geary"
elif [ -f "$(command -v neomutt 2>/dev/null)" ]; then
  export EMAIL="myterminal -e neomutt"
elif [ -f "$(command -v mutt 2>/dev/null)" ]; then
  export EMAIL="myterminal -e mutt"
elif [ -f "$(command -v kmail 2>/dev/null)" ]; then
  export EMAIL="kmail"
elif [ -f "$(command -v emacs 2>/dev/null)" ]; then
  export EMAIL="emacs"
elif [ -f "$(command -v gmail 2>/dev/null)" ]; then
  EMAIL="mybrowser https://gmail.com"
elif [ -f "$(command -v sylpheed 2>/dev/null)" ]; then
  export EMAIL="sylpheed"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export editor
if [ -f "$(command -v code 2>/dev/null)" ]; then
  export EDITOR="code"
elif [ -f "$(command -v vscode 2>/dev/null)" ]; then
  export EDITOR="vscode"
elif [ -f "$(command -v vim 2>/dev/null)" ]; then
  export EDITOR="vim"
elif [ -f "$(command -v nvim 2>/dev/null)" ]; then
  export EDITOR="nvim"
elif [ -f "$(command -v geany 2>/dev/null)" ]; then
  export EDITOR="geany"
elif [ -f "$(command -v gedit 2>/dev/null)" ]; then
  export EDITOR="gedit"
elif [ -f "$(command -v atom 2>/dev/null)" ]; then
  export EDITOR="atom"
elif [ -f "$(command -v brackets 2>/dev/null)" ]; then
  export EDITOR="brackets"
elif [ -f "$(command -v emacs 2>/dev/null)" ]; then
  export EDITOR="emacs"
elif [ -f "$(command -v mousepad 2>/dev/null)" ]; then
  export EDITOR="mousepad"
elif [ -f "$(command -v nano 2>/dev/null)" ]; then
  export EDITOR="nano"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export todo config
export TODO_DIR="$HOME/.local/share/editors/todos"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export todo.sh config
export TODOSH_DIR="$HOME/.local/share/todo"
export TODOTXT_CFG_FILE="$HOME/.config/todo/config"
export TODOTXT_FILE="$HOME/.local/share/todo/todo.txt"
export TODOTXT_DONE_FILE="$HOME/.local/share/todo/done.txt"
export TODOTXT_REPORT_FILE="$HOME/.local/share/todo/report.txt"

if [ ! -f "$TODOTXT_CFG_FILE" ]; then
  touch "$TODOTXT_CFG_FILE"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export notes dir
export NOTES_DIRECTORY="$HOME/.local/share/editors/notes"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# export color
export CLICOLOR=1
export GREP_COLORS="mt=37;45"

if [ -f "$HOME/.dircolors" ]; then
  export DIRCOLOR="$HOME/.dircolors"
elif [ -f "$HOME/.config/dircolors/dracula" ]; then
  export DIRCOLOR="$HOME/.config/dircolors/dracula"
elif [ -f "$(command -v dircolors 2>/dev/null)" ]; then
  dircolors --print-database >"$HOME/.dircolors" 2>/dev/null
  export DIRCOLOR="$HOME/.dircolors"
elif [ -f "$(command -v gdircolors 2>/dev/null)" ]; then
  gdircolors --print-database >"$HOME/.dircolors" 2>/dev/null
  export DIRCOLOR="$HOME/.dircolors"
fi

case "$(uname -s)" in
Linux)
  #Load default colors
  if [ -f "$(command -v dircolors 2>/dev/null)" ]; then dircolors "$DIRCOLOR" &>/dev/null; fi
  ;;
Darwin)
  export LSCOLORS=exfxcxdxbxegedabagacad
  if [ -f "$(command -v gdircolors 2>/dev/null)" ]; then gdircolors "$DIRCOLOR" &>/dev/null; fi
  ;;
esac

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Setup wallpaper directory
export WALLPAPERS="$HOME/.local/share/wallpapers"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lf file manager icons
if [ -f "$(command -v lf 2>/dev/null)" ]; then
  export LF_ICONS="di=:fi=:ln=:or=:ex=:*.c=:*.cc=:*.clj=:*.coffee=:*.cpp=:*.css=:*.d=:*.dart=:*.erl=:*.exs=:*.fs=:*.go=:*.h=:*.hh=:*.hpp=:*.hs=:*.html=:*.java=:*.jl=:*.js=:*.json=:*.lua=:*.md=:*.php=:*.pl=:*.pro=:*.py=:*.rb=:*.rs=:*.scala=:*.ts=:*.vim=:*.cmd=:*.ps1=:*.sh=:*.bash=:*.zsh=:*.fish=:*.tar=:*.tgz=:*.arc=:*.arj=:*.taz=:*.lha=:*.lz4=:*.lzh=:*.lzma=:*.tlz=:*.txz=:*.tzo=:*.t7z=:*.zip=:*.z=:*.dz=:*.gz=:*.lrz=:*.lz=:*.lzo=:*.xz=:*.zst=:*.tzst=:*.bz2=:*.bz=:*.tbz=:*.tbz2=:*.tz=:*.deb=:*.rpm=:*.jar=:*.war=:*.ear=:*.sar=:*.rar=:*.alz=:*.ace=:*.zoo=:*.cpio=:*.7z=:*.rz=:*.cab=:*.wim=:*.swm=:*.dwm=:*.esd=:*.jpg=:*.jpeg=:*.mjpg=:*.mjpeg=:*.gif=:*.bmp=:*.pbm=:*.pgm=:*.ppm=:*.tga=:*.xbm=:*.xpm=:*.tif=:*.tiff=:*.png=:*.svg=:*.svgz=:*.mng=:*.pcx=:*.mov=:*.mpg=:*.mpeg=:*.m2v=:*.mkv=:*.webm=:*.ogm=:*.mp4=:*.m4v=:*.mp4v=:*.vob=:*.qt=:*.nuv=:*.wmv=:*.asf=:*.rm=:*.rmvb=:*.flc=:*.avi=:*.fli=:*.flv=:*.gl=:*.dl=:*.xcf=:*.xwd=:*.yuv=:*.cgm=:*.emf=:*.ogv=:*.ogx=:*.aac=:*.au=:*.flac=:*.m4a=:*.mid=:*.midi=:*.mka=:*.mp3=:*.mpc=:*.ogg=:*.ra=:*.wav=:*.oga=:*.opus=:*.spx=:*.xspf=:*.pdf="
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set term type
export TERM="screen-256color"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# logging
export DEFAULT_LOG="apps"
export DEFAULT_LOG_DIR="${LOGDIR:-$HOME/.local/log}"
export LOGDIR="${DEFAULT_LOG_DIR:-$HOME/.local/log}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set PATH so it includes user's private bin if it exists
if [ -d ~/.local/bin ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

# Set scripts path if installed manually
if [ -d ~/.local/share/scripts/bin ]; then
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
# passmgr settings - add your passmgr setup here
if [ -f "$HOME/.config/secure/passmgr.txt" ]; then
  . "$HOME/.config/secure/passmgr.txt"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# github settings - add github settings here
if [ -f "$HOME/.config/secure/github.txt" ]; then
  . "$HOME/.config/secure/github.txt"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# gitlab settings - add gitlab settings here
if [ -f "$HOME/.config/secure/gitlab.txt" ]; then
  . "$HOME/.config/secure/gitlab.txt"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# your private git - add your private git here
if [ -f "$HOME/.config/secure/gitpriv.txt" ]; then
  . "$HOME/.config/secure/gitpriv.txt"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# add your personal dotfiles repo here
if [ -f "$HOME/.config/secure/personal.txt" ]; then
  . "$HOME/.config/secure/personal.txt"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# store API keys here
if [ -f "$HOME/.config/secure/apikeys.txt" ]; then
  . "$HOME/.config/secure/apikeys.txt"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# import local profile
if [ -f "$HOME/.config/local/profile.local" ]; then
  . "$HOME/.config/local/profile.local"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# import specific profiles for systems
if [ -f "$HOME/.config/local/servers/$(hostname -s).local" ]; then
  . "$HOME/.config/local/servers/$(hostname -s).local"
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
# MacOS fix
if [[ "$OSTYPE" =~ ^darwin ]]; then
  export HOMEBREW_INSTALL_BADGE="☕️ 🐸"
  export HOMEBREW_CASK_OPTS="--appdir=/Applications"
  export PATH="/usr/local/bin:$PATH:/usr/local/sbin:/usr/bin:/sbin"
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# fix PATH
export PATH="$(echo $PATH | tr ':' '\n' | awk '!seen[$0]++' | tr '\n' ':' | sed 's#::#:#g')"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# set profile as sourced
export PROFILERCSRC="$HOME/.profile"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# end
