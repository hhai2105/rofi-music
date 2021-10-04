#!/usr/bin/env zsh
set -euo pipefail

add(){
    TYPE="all\nalbum\nany\nartist\ncomment\ncomposer\ndate\ndisc\nfilename\ngenre\nname\nperformer\ntitle\ntrack"
    TYPE=$(echo "$TYPE" | rofi -dmenu -p "Search by")
    if [ "$TYPE" =  "all" ];
    then
	mpc add /
    else
	CHOICE=$(mpc list $TYPE | rofi -dmenu -p "Search")
	mpc findadd $TYPE $CHOICE
    fi
    mpc toggle;
    add;
}
delete(){
    SONG=$(mpc playlist -f "%id% %artist%-%title%" | rofi -dmenu -p "Songs")
    mpc del $SONG;
    delete;
}
mainMenu(){
    CURRENT="$(mpc current)"
    ACTIONS="add\ndelete\nclear"
    OPTIONS="$(mpc status | grep -Po "volume:[0-9]*%")\n$(mpc status | grep -Po "repeat: [a-z]*")\n$(mpc status | grep -Po "random: [a-z]*")\n$(mpc status | grep -Po "single: [a-z]*")\n$(mpc status | grep -Po "consume: [a-z]*")"
    CHOICE="$(echo "$CURRENT\n--------------------------\n$OPTIONS\n--------------------------\n$ACTIONS" | rofi -dmenu -p "mpc")"
    if [ "$CHOICE" = "$CURRENT" ];
    then
	mpc toggle;
    elif echo "$CHOICE" | grep "volume:";
    then
	volume;
    elif echo "$CHOICE" | grep "repeat: ";
    then
	mpc repeat;
    elif echo "$CHOICE" | grep "random: ";
    then
	mpc random;
    elif echo "$CHOICE" | grep "single: ";
    then
	mpc single;
    elif echo "$CHOICE" | grep "consume: ";
    then
	mpc consume;
    elif echo "$CHOICE" | grep "^add$";
    then
	add;
    elif echo "$CHOICE" | grep "^delete$";
    then
	delete;
    elif echo "$CHOICE" | grep "^clear$";
    then
	mpc clear;
    fi
}
mainMenu
