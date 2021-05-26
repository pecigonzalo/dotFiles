#!/usr/bin/zsh

## SSH
zstyle :omz:plugins:ssh-agent ssh-add-args -K # NOTE: OSX Only
zstyle :omz:plugins:ssh-agent identities pecigonzalo_ed25519 pecigonzalo_rsa
zinit snippet OMZ::plugins/ssh-agent/ssh-agent.plugin.zsh

## Programs
# Load asdf
zinit light-mode for \
  @asdf-vm/asdf

# zinit is-snippet for \
#   blockf "${HOME}/.nix-profile/google-cloud-sdk/completion.zsh.inc"

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

zinit wait lucid for \
  OMZ::lib/git.zsh \
  atload:"unalias grv" OMZ::plugins/git/git.plugin.zsh \
  OMZ::plugins/git-auto-fetch/git-auto-fetch.plugin.zsh \
  OMZ::plugins/gitignore/gitignore.plugin.zsh \
  OMZ::plugins/git-flow/git-flow.plugin.zsh \
  wfxr/forgit \
  wfxr/emoji-cli

# Terraform
zinit ice as:"completion"
zinit snippet OMZ::plugins/terraform/_terraform

# Docker
zinit wait lucid for \
  OMZ::plugins/docker-compose/docker-compose.plugin.zsh \
  as:"completion" OMZ::plugins/docker/_docker

# Utils
zinit for \
  OMZ::plugins/common-aliases/common-aliases.plugin.zsh \
  OMZ::plugins/sudo/sudo.plugin.zsh \
  OMZ::plugins/rsync/rsync.plugin.zsh \
  OMZ::plugins/urltools/urltools.plugin.zsh

# Z, Tipz
zinit wait lucid blockf light-mode for \
  agkozak/zsh-z \
  changyuheng/fz \
  Aloxaf/fzf-tab \
  molovo/tipz

## Theme
eval "$(starship init zsh)"

## Last
# Load completions with highlighting
zinit wait lucid atload:"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" blockf for \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-completions \
  zsh-users/zsh-syntax-highlighting
