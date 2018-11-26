#!/bin/bash
## place in ~/.config/plasma-workspace/env/ssh-agent-startup.sh
## exec order: "kde pre-startup"
export SSH_ASKPASS="/usr/bin/ksshaskpass"

if ! pgrep -u "$USER" ssh-agent >/dev/null; then
  ssh-agent >~/.ssh-agent
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
  eval "$(<~/.ssh-agent)"
fi
