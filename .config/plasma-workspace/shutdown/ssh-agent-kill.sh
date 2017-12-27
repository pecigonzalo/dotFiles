#!/bin/bash
## place in ~/.config/plasma-workspace/shutdown/ssh-agent-shutdown.sh
## exec order: "kde shutdown"
if [ "$SSH_AGENT_PID" ]; then
    eval "$(ssh-agent -k)"
fi
