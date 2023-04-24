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

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# import
case "$(uname -s)" in
Linux) [ -f "$HOME/.config/misc/shell/aliases/00-default.lin" ] && . "$HOME/.config/misc/shell/aliases/00-default.lin" ;;
Darwin) [ -f "$HOME/.config/misc/shell/aliases/00-default.lin" ] && . "$HOME/.config/misc/shell/aliases/00-default.mac" ;;
Windows*) [ -f "$HOME/.config/misc/shell/aliases/00-default.lin" ] && . "$HOME/.config/misc/shell/aliases/00-default.win" ;;
esac
