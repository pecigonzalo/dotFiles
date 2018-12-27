#!/bin/bash
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
export SSH_ASKPASS="/usr/bin/ksshaskpass"

ssh-add </dev/null
ssh-add "$HOME/.ssh/Github_pecigonzalo" </dev/null
