#!/usr/bin/env sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##@Version           :  202304261931-git
# @@Author           :  Jason Hempstead
# @@Contact          :  git-admin@casjaysdev.pro
# @@License          :  LICENSE.md
# @@ReadME           :  set-resolution.sh --help
# @@Copyright        :  Copyright: (c) 2023 Jason Hempstead, Casjays Developments
# @@Created          :  Wednesday, Apr 26, 2023 20:04 EDT
# @@File             :  set-resolution.sh
# @@Description      :  X server init file
# @@Changelog        :  newScript
# @@TODO             :  Refactor code
# @@Other            :
# @@Resource         :
# @@Terminal App     :  no
# @@sudo/root        :  no
# @@Template         :  shell
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# get resolution
if which xrandr >/dev/null 2>&1; then
  export RESOLUTION="$(xrandr --current 2>/dev/null | grep '\*' | uniq | awk '{print $1}')"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# fix screen resolution
if [ -n "$RESOLUTION" ] && [ -x "$HOME/.config/screenlayout/$RESOLUTION.sh" ]; then
  . "$HOME/.config/screenlayout/$RESOLUTION.sh"
elif [ -x "$HOME/.config/screenlayout/default.sh" ]; then
  . "$HOME/.config/screenlayout/default.sh"
fi
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# end
true
