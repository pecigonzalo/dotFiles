#!/bin/bash

# Base config
limit coredumpsize 0
export PATH=~/bin:$PATH

# History config
export HISTFILE=$HOME/.histfile
export HISTSIZE=10000
export SAVEHIST=100000

# User Bin
export PATH="$HOME/.local/bin:$PATH"

# Golang
export GOPATH="$HOME/Workspace/Go"
export PATH="$GOPATH/bin:$PATH"

# Editor
export EDITOR='vim'
export CVSEDITOR="${EDITOR}"
export SVN_EDITOR="${EDITOR}"
export GIT_EDITOR="${EDITOR}"

# Pager
export PAGER=less

# Less status line
export LESS='-R -f -X -i -P ?f%f:(stdin). ?lb%lb?L/%L.. [?eEOF:?pb%pb\%..]'
export LESSCHARSET='utf-8'

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[00;44;37m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# declare the environment variables
export CORRECT_IGNORE='_*'
export CORRECT_IGNORE_FILE='.*'

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
export DISABLE_UNTRACKED_FILES_DIRTY="true"

# zsh-syntax-highlighting
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# z
export _Z_NO_RESOLVE_SYMLINKS=1
export _Z_NO_COMPLETE_CD=1

# Disable virtualenv in prompt autoconfig
export VIRTUAL_ENV_DISABLE_PROMPT=1

# TLDR Colors
export TLDR_COLOR_BLANK="white"
export TLDR_COLOR_NAME="cyan"
export TLDR_COLOR_DESCRIPTION="white"
export TLDR_COLOR_EXAMPLE="green"
export TLDR_COLOR_COMMAND="red"
export TLDR_COLOR_PARAMETER="white"

# Load shared aliases
[[ -f $HOME/dotFiles/.aliases ]] && source $HOME/dotFiles/.aliases

# Get funtions
[[ -f $HOME/dotFiles/functions.zsh ]] && source $HOME/dotFiles/functions.zsh

# Load Travis
[ -f $HOME/.travis/travis.sh ] && source $HOME/.travis/travis.sh
