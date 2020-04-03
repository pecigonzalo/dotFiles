#!/usr/bin/zsh

# If not under WSL, return
if [[ -z "$WSL_DISTRO_NAME" ]]; then
  return
fi

services=(
  cron
  rsyslog
  docker
)

for service in "${services[@]}"; do
  if [[ "$(service $service status)" =~ '.*is not running' ]]; then
    sudo service "$service" start
  fi
done

# X Forwarding
export DISPLAY="$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0"
export LIBGL_ALWAYS_INDIRECT="1"
