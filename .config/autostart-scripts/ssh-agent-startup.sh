#!/bin/bash
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-/tmp}/ssh-agent.socket"

if [[ -f /usr/bin/ksshaskpass ]]; then
  export SSH_ASKPASS="/usr/bin/ksshaskpass"
fi

ssh-add </dev/null
ssh-add "$HOME/.ssh/pecigonzalo_ed25519" </dev/null
ssh-add "$HOME/.ssh/pecigonzalo_rsa" </dev/null
ssh-add "$HOME/.ssh/blessid" </dev/null
