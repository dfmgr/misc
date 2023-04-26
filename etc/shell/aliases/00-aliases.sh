#!/usr/bin/env sh
# shellcheck shell=sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202303022155-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : LICENSE.md
# @ReadME        : README.md
# @Copyright     : Copyright: (c) 2023 Jason Hempstead, CasjaysDev
# @Created       : Thursday, Mar 02, 2023 21:54 EDT
# @File          : 00-aliases.sh
# @Description   :
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Aliases for all OSes
[ -n "$(which "nvim" 2>/dev/null)" ] && [ -z "$(which "neovim" 2>/dev/null)" ] && alias neovim='nvim '
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
