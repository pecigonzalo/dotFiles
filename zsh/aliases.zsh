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
alias exa='exa --icons --color=always'
alias ls='exa'
alias tree='exa --tree'
alias l='exa -lFh'
alias la='exa -la'
alias ll='exa -l'
alias lS='exa -1'
alias lt='tree --level=2'

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
