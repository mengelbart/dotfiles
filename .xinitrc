#!/bin/sh

if [ -f ~/.Xprfile ]; then
	. ~/.Xprofile
fi

xhost local:root

exec i3 -V >> ~/.i3/logfile 2>&1
