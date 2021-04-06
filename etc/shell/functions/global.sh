#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
APPNAME="$(basename "$0")"
VERSION="202104050844-git"
USER="${SUDO_USER:-${USER}}"
HOME="${USER_HOME:-${HOME}}"
SRC_DIR="${BASH_SOURCE%/*}"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#set opts

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202104050844-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : LICENSE.md
# @ReadME        : global.sh --help
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Tuesday, Apr 06, 2021 04:09 EDT
# @File          : global.sh
# @Description   : Global functions
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__setcursor() { echo -e -n "\x1b[\x35 q" "\e]12;cyan\a" 2>/dev/null; }
__tar_create() { tar cfvz "$@"; }
__tar_extract() { tar xfvz "$@"; }
__while_loop() { while :; do "${@}" && sleep .3; done; }
__for_each() { for item in ${1}; do ${2} ${item} && sleep .1; done; }
__readline() { while read -r line; do echo "$line"; done <"$1"; }
__count_lines() { wc -l "$1" | awk '${print $1}'; }
__count_files() { find -L "${1:-./}" -maxdepth "${2:-1}" -not -path "${1:-./}/.git/*" -type l,f | wc -l; }
__count_dir() { find -L "${1:-./}" -maxdepth "${2:-1}" -not -path "${1:-./}/.git/*" -type d | wc -l; }
__symlink() { if [ -e "$1" ]; then __ln_sf "${1}" "${2}" || return 0; fi; }
__mv_f() { if [ -e "$1" ]; then mv -f "$1" "$2" || return 0; fi; }
__cp_rf() { if [ -e "$1" ]; then cp -Rf "$1" "$2" || return 0; fi; }
__rm_rf() { if [ -e "$1" ]; then rm -Rf "$@" || return 0; fi; }
__ln_rm() { if [ -e "$1" ]; then find -L $1 -mindepth 1 -maxdepth 1 -type l -exec rm -f {} \;; fi; }
__broken_symlinks() { find -L "$@" -type l -exec rm -f {} \;; }
