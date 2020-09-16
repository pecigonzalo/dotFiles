#!/usr/bin/zsh

## SSH
zstyle :omz:plugins:ssh-agent identities pecigonzalo_ed25519 pecigonzalo_rsa
zinit snippet OMZ::plugins/ssh-agent/ssh-agent.plugin.zsh

## Programs
# Load asdf
zinit light-mode for \
  @asdf-vm/asdf

zinit is-snippet for \
  blockf "$(asdf where gcloud)/completion.zsh.inc"

# Direnv
zinit ice wait lucid as"null" \
  atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' src"zhook.zsh"
zinit snippet "${HOMEBREW_PREFIX}/bin/direnv"

## OMZ Config
zinit for \
  OMZ::lib/key-bindings.zsh \
  OMZ::lib/clipboard.zsh \
  OMZ::lib/termsupport.zsh

## Others
# fzf
zinit is-snippet for \
  "${HOMEBREW_PREFIX}/opt/fzf/shell/key-bindings.zsh" \
  "${HOMEBREW_PREFIX}/opt/fzf/shell/completion.zsh"

# Git
zinit wait lucid for \
  OMZ::lib/git.zsh \
  atload:"unalias grv" OMZ::plugins/git/git.plugin.zsh \
  OMZ::plugins/git-auto-fetch/git-auto-fetch.plugin.zsh \
  OMZ::plugins/gitignore/gitignore.plugin.zsh \
  OMZ::plugins/git-flow/git-flow.plugin.zsh

# Terraform
zinit ice as:"completion"
zinit snippet OMZ::plugins/terraform/_terraform

# Python
zinit wait lucid for \
  blockf OMZ::plugins/pip/pip.plugin.zsh \
  as:"completion" OMZ::plugins/pip/_pip \
  OMZ::plugins/pyenv/pyenv.plugin.zsh

# Docker
zinit wait lucid for \
  OMZ::plugins/docker-compose/docker-compose.plugin.zsh \
  as:"completion" OMZ::plugins/docker/_docker

# Utils
zinit wait lucid for \
  atload:"unalias fd" OMZ::plugins/common-aliases/common-aliases.plugin.zsh \
  OMZ::plugins/sudo/sudo.plugin.zsh \
  OMZ::plugins/rsync/rsync.plugin.zsh \
  OMZ::plugins/urltools/urltools.plugin.zsh

# K, Z
zinit wait lucid blockf light-mode for \
  rimraf/k \
  rupa/z \
  changyuheng/fz \
  changyuheng/zsh-interactive-cd \
  wfxr/forgit \
  molovo/tipz

## Theme
# zinit light denysdovhan/spaceship-prompt
eval "$(starship init zsh)"

## Last
# Load completions with highlighting
zinit wait lucid for \
  atinit:"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" \
  zsh-users/zsh-syntax-highlighting \
  atload:"!_zsh_autosuggest_start" \
  zsh-users/zsh-autosuggestions \
  blockf \
  zsh-users/zsh-completions
