#!/bin/bash

# Google Apps CLI
alias gam="/home/gonzalo.peci/bin/gam/gam"

# Follow tail
alias tailf="tail -f"

# gitg remove console output
alias gitg="gitg >> /dev/null 2>&1"

# ls
alias ls='ls --color=always'

# exa
alias exa='exa --color=always'
alias l='exa -lF'
alias ll='exa -l'
alias la='exa -la'

# bat
alias cat="bat -p"

# terraform
alias tf="terraform"

# Reload
alias reshell!="exec $SHELL -l"

# Neovim
alias vim="nvim"

# Kubectl
alias k="kubectl"
