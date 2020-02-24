#!/usr/bin/zsh
source ~/.zinit/bin/zinit.zsh

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

## SSH
zstyle :omz:plugins:ssh-agent identities pecigonzalo_ed25519 pecigonzalo_rsa
zinit snippet OMZ::plugins/ssh-agent/ssh-agent.plugin.zsh

## Programs
# Load asdf
zinit ice wait lucid blockf
zinit snippet OMZ::plugins/asdf/asdf.plugin.zsh

# Direnv
zinit ice as"null" atinit'direnv hook zsh > zhook.zsh' src"zhook.zsh"
zinit snippet "$(brew --prefix)/bin/direnv"

## OMZ Config
zinit snippet OMZ::lib/key-bindings.zsh
zinit snippet OMZ::lib/git.zsh
zinit snippet OMZ::lib/clipboard.zsh
zinit snippet OMZ::lib/termsupport.zsh

## Completions
zinit ice wait lucid blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

zinit ice as"completion"
zinit snippet OMZ::plugins/terraform/_terraform

## Others
# fzf
zinit snippet "$(brew --prefix fzf)/shell/key-bindings.zsh"
zinit snippet "$(brew --prefix fzf)/shell/completion.zsh"

# Git
zinit ice wait atload"unalias grv" lucid
zinit snippet OMZ::plugins/git/git.plugin.zsh

zinit snippet OMZ::plugins/git-auto-fetch/git-auto-fetch.plugin.zsh
zinit snippet OMZ::plugins/gitignore/gitignore.plugin.zsh

# Python
zinit ice wait lucid blockf
zinit snippet OMZ::plugins/pip/pip.plugin.zsh

zinit ice as"completion"
zinit snippet OMZ::plugins/pip/_pip

# Docker
zinit snippet OMZ::plugins/docker-compose/docker-compose.plugin.zsh

zinit ice wait as"completion" lucid
zinit snippet OMZ::plugins/docker/_docker

# Utils
zinit snippet OMZ::plugins/common-aliases/common-aliases.plugin.zsh
zinit snippet OMZ::plugins/sudo/sudo.plugin.zsh
zinit snippet OMZ::plugins/rsync/rsync.plugin.zsh
zinit snippet OMZ::plugins/urltools/urltools.plugin.zsh

# K
zinit ice blockf
zinit light rimraf/k

# Z
zinit ice blockf
zinit light rupa/z
zinit ice blockf
zinit light changyuheng/fz

# Tipz
zinit ice wait lucid
zinit light "molovo/tipz"

# Interactive CD
zinit ice wait lucid
zinit light "changyuheng/zsh-interactive-cd"

# forgit
zinit ice wait lucid
zinit light "wfxr/forgit"

## Theme
zinit light denysdovhan/spaceship-prompt

## Last
# Load completions with highlighting
zinit ice wait lucid atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay"
zinit light zsh-users/zsh-syntax-highlighting
# zini light zdharma/fast-syntax-highlighting

zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# Fish like search
zinit ice wait lucid atload' \
  [ -n "${terminfo[kcuu1]}" ] && bindkey "${terminfo[kcuu1]}" history-substring-search-up; \
  [ -n "${terminfo[kcud1]}" ] && bindkey "${terminfo[kcud1]}" history-substring-search-down; \
  bindkey -M emacs "^P" history-substring-search-up; \
  bindkey -M emacs "^N" history-substring-search-down; \
  bindkey -M vicmd "k" history-substring-search-up; \
  bindkey -M vicmd "j" history-substring-search-down; \
'
zinit light zsh-users/zsh-history-substring-search