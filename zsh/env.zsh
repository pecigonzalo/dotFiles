#!/usr/bin/zsh

# Set LS_COLORS
eval $(dircolors)

# ssh-agent SOCK
# export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
# export SSH_ASKPASS="/usr/bin/ksshaskpass"

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[00;44;37m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# zsh-syntax-highlighting
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

