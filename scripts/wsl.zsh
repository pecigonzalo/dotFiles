#!/usr/bin/zsh

# If not under WSL, return
if [[ -z "$WSL_DISTRO_NAME" ]]; then
  return
fi

services=(
  cron
  rsyslog
)

for service in "${services[@]}"; do
  if [[ "$(service $service status)" =~ '.*is not running' ]]; then
    sudo service "$service" start
  fi
done
