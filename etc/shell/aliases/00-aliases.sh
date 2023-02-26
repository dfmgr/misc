#!/usr/bin/env bash
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version       : 202103251632-git
# @Author        : Jason Hempstead
# @Contact       : jason@casjaysdev.com
# @License       : LICENSE.md
# @ReadME        : README.md
# @Copyright     : Copyright: (c) 2021 Jason Hempstead, CasjaysDev
# @Created       : Thursday, Mar 25, 2021 16:36 EDT
# @File          : 00-aliases.lin
# @Description   : Aliases for all OSes
# @TODO          :
# @Other         :
# @Resource      :
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Aliases for all OSes
alias bork='printf "😂 🐕\n\n" '
alias please='printf "😂 Well shit 😂\n\n" '
alias shit='echo -n "😠 Well that didnt work: " && sudo '
alias gcm='git add . && git commit -am "🗃️ Committing everything that changed 🗃️ " '
alias copy-templates='gen-header --copy;gen-html --copy;gen-readme --copy;gen-script --copy;echo'
alias update-system='printf_blue "Updating your system. This may take a while......" && pkmgr silent upgrade && sudo systemmgr update &>/dev/null && dfmgr update &>/dev/null && printf_green "Your system has been updated" || printf_red "Failed to update your system"'
