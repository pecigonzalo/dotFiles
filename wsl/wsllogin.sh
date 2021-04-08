#!/bin/bash
services=(
  cron
  rsyslog
  docker
)

for service in "${services[@]}"; do
  if [[ $(service "$service" status) =~ .*"is not running" ]]; then
    sudo service "$service" start
  fi
done

# X Forwarding
DISPLAY="$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0"
export DISPLAY

(vcxsrv.exe :0 -silent-dup-error -ac -nowgl -dpms -terminate -lesspointer -multiwindow -clipboard &>/dev/null &)

# Theme
export GTK_THEME="windows-10-dark"
export QT_STYLE_OVERRRIDE="windows-10-dark"
# NOTE: Use lxappearance to set fonts/etc

sudo prlimit -p "$$" --nofile=10000:10000
