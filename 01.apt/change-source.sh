#!/bin/bash

SCRIPTPATH=$(dirname "$0")
APT_LIST="/etc/apt/sources.list"
MY_APT_LIST="$SCRIPTPATH/data/sources.list"
ORIGINAL_LIST="/etc/apt/sources.list.orig"

if [ ! -f $ORIGINAL_LIST ]; then
	cp $APT_LIST $ORIGINAL_LIST
fi

cp $MY_APT_LIST $APT_LIST
apt update
