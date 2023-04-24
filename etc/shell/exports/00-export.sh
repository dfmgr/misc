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
# @File          : 00-export.sh
# @Description   :
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# exports for all OSes

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# import
case "$(uname -s)" in
Linux) [ -f "$HOME/.config/misc/shell/exports/00-default.lin" ] && . "$HOME/.config/misc/shell/exports/00-default.lin" ;;
Darwin) [ -f "$HOME/.config/misc/shell/exports/00-default.lin" ] && . "$HOME/.config/misc/shell/exports/00-default.mac" ;;
Windows*) [ -f "$HOME/.config/misc/shell/exports/00-default.lin" ] && . "$HOME/.config/misc/shell/exports/00-default.win" ;;
esac
