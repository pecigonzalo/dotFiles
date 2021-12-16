#!/bin/bash

sysctl --system

services=(
  cron
  rsyslog
  docker
)

for service in "${services[@]}"; do
  if [[ $(service "$service" status) =~ .*"is not running" ]]; then
    service "$service" start
  fi
done
