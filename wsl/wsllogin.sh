#!/bin/bash

# X Forwarding
# DISPLAY="$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0"
# export DISPLAY

# (vcxsrv.exe :0 -silent-dup-error -ac -nowgl -dpms -terminate -lesspointer -multiwindow -clipboard &>/dev/null &)

# Theme
# NOTE: Use lxappearance to set fonts/etc
export GTK_THEME="windows-10-dark"
export QT_STYLE_OVERRRIDE="windows-10-dark"

sudo prlimit -p "$$" --nofile=10000:10000
