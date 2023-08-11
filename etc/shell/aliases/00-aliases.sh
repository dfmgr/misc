#!/usr/bin/env sh
# shellcheck shell=sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202303022155-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.pro
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
if which "nvim" >/dev/null 2>&1 && ! which "neovim" >/dev/null 2>&1; then
  alias neovim='nvim '
fi
if which mongod >/dev/null 2>&1; then
  alias mongod='mkdir -p $HOME/.local/share/mongodb/db;\mongod --dbpath $HOME/.local/share/mongodb/db --nounixsocket'
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
true
