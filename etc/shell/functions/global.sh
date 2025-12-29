#!/usr/bin/env sh
# shellcheck shell=sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202304232359-git
# @@Author           :  Jason Hempstead
# @@Contact          :  git-admin@casjaysdev.pro
# @@License          :  LICENSE.md
# @@ReadME           :  global.sh --help
# @@Copyright        :  Copyright: (c) 2023 Jason Hempstead, Casjays Developments
# @@Created          :  Monday, Apr 24, 2023 00:10 EDT
# @@File             :  global.sh
# @@Description      :  Global functions
# @@Changelog        :  newScript
# @@TODO             :  Refactor code
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  shell/sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
geany() { command geany --socket-file="/tmp/geany.sock" "$@" >/dev/null 2>&1 & }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__tar_create() { tar cfvz "$@"; }
__tar_extract() { tar xfvz "$@"; }
__count_lines() { wc -l < "$1"; }
__while_loop() { while :; do "${@}" && sleep .3; done; }
__broken_symlinks() { find -L "$@" -type l -exec rm -f {} \;; }
__rm_rf() { if [ -e "$1" ]; then rm -Rf "$@" || return 0; fi; }
__readline() { while read -r line; do echo "$line"; done <"$1"; }
__mv_f() { if [ -e "$1" ]; then mv -f "$1" "$2" || return 0; fi; }
__cp_rf() { if [ -e "$1" ]; then cp -Rf "$1" "$2" || return 0; fi; }
__for_each() { for item in ${1}; do ${2} ${item} && sleep .1; done; }
__symlink() { if [ -e "$1" ]; then __ln_sf "${1}" "${2}" || return 0; fi; }
__setcursor() { printf '\e[5 q\e]12;cyan\a' 2>/dev/null; }
# Optimized: Check directory exists before find operation
__ln_rm() { [ -d "$1" ] && find "$1" -mindepth 1 -maxdepth 1 -type l -delete 2>/dev/null; }
__count_dir() { find -L "${1:-./}" -maxdepth "${2:-1}" -not -path "${1:-./}/.git/*" -type d | wc -l; }
__count_files() { find -L "${1:-./}" -maxdepth "${2:-1}" -not -path "${1:-./}/.git/*" -type l,f | wc -l; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__git_top_dir() { git -C "${1:-.}" rev-parse --show-toplevel 2>/dev/null || echo "${1:-$PWD}"; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__git_clone() { printf '%s' "Cloning repo to $2: " && git clone "$1" "${2:-$(basename "$1" 2>/dev/null)}" -q 2>/dev/null && printf '\n' || return 1; }
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
__git_update() {
  gitDir="$(__git_top_dir "${CDD_INTO_CUR:-$PWD}")" remote_repo=""
  gitOldDir="${CDD_OLD_PWD:-$gitDir}"
  repo_status="${CDD_REPO_UPDATED:-no}"
  local_remote_repo="local repo"
  local_remote_icon="🤷"
  remote_icon="🚀"
  git_message=""
  if [ -d "${gitDir}" ]; then
    git status --porcelain -s 2>&1 | grep -q '^' && return 0
    remote_repo="$([ -f "${gitDir}/.git/config" ] && awk -F'= ' '/url = / {print $2; exit}' "${gitDir}/.git/config" || echo '')"
    if [ -z "$remote_repo" ]; then
      remote_icon="$local_remote_icon"
      remote_repo="$local_remote_repo"
      git_message="$remote_icon $remote_repo $remote_icon"
    fi
    if [ "$repo_status" = "yes" ] && [ "$gitDir" != "$CDD_OLD_PWD" ]; then
      printf_green "${git_message:-🎆 Updating the git repo from: $remote_repo $remote_icon}"
      git -C "$gitDir" pull -q >/dev/null 2>&1
      CDD_REPO_UPDATED="yes"
      CDD_OLD_PWD="$gitOldDir"
    fi
  fi
  export CDD_REPO_UPDATED CDD_OLD_PWD
  return 0
}
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
