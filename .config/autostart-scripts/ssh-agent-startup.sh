#!/bin/bash
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
export SSH_ASKPASS="/usr/bin/ksshaskpass"

ssh-add </dev/null
ssh-add "$HOME/.ssh/pecigonzalo_ed25519" </dev/null
ssh-add "$HOME/.ssh/pecigonzalo_rsa" </dev/null
ssh-add "$HOME/.ssh/blessid"

