#!/bin/bash

# USER SETTINGS

# refresh rate on progress
SECS=1

# download location
DIR="$HOME/incoming"

open() {
  case "$1" in
    *.pdf)  apvlv"$1" & ;;
    *.txt) urxvt -e vim "$1" &  ;;
    *.jpg|*.png|*.jpeg) feh "$1" & ;;
    *.mov|*.avi|*.mpeg|*.mpg) mplayer "$1" & ;;
    *) : ;;
  esac
}

# PROGRAM 

# download link
URL="$8"

# State file for wget
STAT="/tmp/dl_progress.$$"

# get file name
FILETEMP="$(echo $URL | awk -F '/' '{print $NF}')"

# start downloading and write status to $STAT
wget -O "$DIR/$FILETEMP" --user-agent=Firefox "$URL" > $STAT 2>&1 &

# get pid
pid=$!

# cut the file name
FILE=$(echo $FILETEMP | cut -c -25) 

# REM = remainder
# PROG = progress
# shows the progress and remainder in the uzbl bar
(while ps -A | grep -q $pid; do

	REM="$(awk '/s$/ {print $NF}' $STAT | tail -n1)"
	PROG=$(grep -Eo " [0-9]{1,3}%" $STAT | tail -n1 )
	echo "set status_message = Downloading $FILE  $REM $PROG" > $4 
	sleep "$SECS"
done; echo "set status_message = Download $FILE to $DIR" > $4; sleep 3)

# clean up
kill $pid
rm -rf "$STAT"

# auto start an program with an specific file
# open "$DIR"/"$FILE"


exit 0
