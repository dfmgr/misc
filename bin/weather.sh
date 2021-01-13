#!/usr/bin/env bash

SCRIPTNAME="$(basename $0)"
SCRIPTDIR="$(dirname "${BASH_SOURCE[0]}")"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# @Author      : Jason
# @Contact     : casjaysdev@casjay.net
# @File        : weather.sh
# @Created     : Mon, Dec 31, 2019, 00:00 EST
# @License     : WTFPL
# @Copyright   : Copyright (c) CasjaysDev
# @Description : weather tool for conky
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Set functions

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
if [[ -f "$DIR/functions.bash" ]]; then
    source "$DIR/functions.bash"
else
    echo "\t\tCouldn't source the functions file"
    exit 1
fi

[ ! "$1" = "--help" ] || printf_help "Usage: weather.sh"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Specify langauge
LANG="$(echo $LANG | sed 's#_.*##g')"

# Should be u for f or m for c
METRIC="u"

# Options - curl http://wttr.in/:help?A
[ ! -z "$1" ] && OPTS="$1" || OPTS="A$METRIC"

# Location ID
[ ! -z "$2" ] && LOC="$2" || LOC="${MYLOCATIONID:-alb}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ "$1" = "--help" ]; then
    printf_green "USAGE: weather.sh <options> <locationcode>"
    printf_green "See curl http://wttr.in/:help?A for all options"
    printf_green "IE: weather.sh Au0 mian"
    exit 0
fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

curl -H "Accept-Language: $LANG" -Ls "http://wttr.in/$LOC?$OPTS" | sed -n '3,7{s/\d27\[[0-9;]*m//g;s/^..//;s/ *$//;p}'
curl -H "Accept-Language: $LANG" -Ls "http://wttr.in/$LOC?$OPTS" | grep "Weather report"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# end
