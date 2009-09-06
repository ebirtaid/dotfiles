#!/bin/bash

#NOTE: it's the job of the script that inserts bookmarks to make sure there are no dupes.

file=${XDG_DATA_HOME:-$HOME/.local/share}/uzbl/bookmarks
[ -r "$file" ] || exit
COLORS=" -nb #000000 -nf white -sb #141414 -sf #ffffff"
FONT="-*-dejavu sans-medium-r-*-*-11-*-*-*-*-*-*-*"
if dmenu --help 2>&1 | grep -q '\[-rs\] \[-ni\] \[-nl\] \[-xs\]'
then
	DMENU="dmenu -i -xs -rs -l 10" # vertical patch
	# show tags as well
	goto=`$DMENU $COLORS < $file | awk '{print $1}'`
else
	DMENU="dmenu -i"
	# because they are all after each other, just show the url, not their tags.
	goto=`awk '{print $1}' $file | $DMENU $COLORS`
fi

#[ -n "$goto" ] && echo "uri $goto" > $4
[ -n "$goto" ] && uzblctrl -s $5 -c "uri $goto"
