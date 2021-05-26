#!/usr/bin/zsh

# ZSH profiling
zmodload zsh/zprof
autoload -U colors && colors

# Direnv
eval "$(direnv hook zsh)"

# Load zinit
source ~/.zinit/bin/zinit.zsh
source "$HOME/dotFiles/zsh/zinit.zsh"

# Load shared aliases
source "$HOME/dotFiles/zsh/aliases.zsh"

# Get funtions
source "$HOME/dotFiles/zsh/functions.zsh"

# If on WSL, load
if [[ -n "$WSL_DISTRO_NAME" ]]; then
  source "$HOME/dotFiles/wsl/wslrc.zsh"
fi

if [[ $(uname) == "Darwin" ]]; then
  source "$HOME/dotFiles/macOS/macosrc.zsh"
fi

# ZSH profiling save
zprof >/tmp/zprof

# Set ZSH opts
source "$HOME/dotFiles/zsh/opts.zsh"

# Set ZSH zstyle
source "$HOME/dotFiles/zsh/zstyle.zsh"

# Set Keyboard
source "$HOME/dotFiles/zsh/keyboard.zsh"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
