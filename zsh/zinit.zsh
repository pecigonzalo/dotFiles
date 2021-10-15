#!/usr/bin/zsh

## SSH
zstyle :omz:plugins:ssh-agent ssh-add-args -K # NOTE: OSX Only
zstyle :omz:plugins:ssh-agent identities pecigonzalo_ed25519 pecigonzalo_rsa

zinit snippet OMZP::ssh-agent/ssh-agent.plugin.zsh

## OMZ Config
zinit for \
  OMZL::key-bindings.zsh \
  OMZL::clipboard.zsh \
  OMZL::termsupport.zsh

# fzf
zinit is-snippet for \
  "${HOME}/.nix-profile/share/fzf/key-bindings.zsh" \
  "${HOME}/.nix-profile/share/fzf/completion.zsh"

## Others
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

zinit wait lucid for \
  OMZL::git.zsh \
  atload:"unalias grv" OMZP::git/git.plugin.zsh \
  OMZP::git-auto-fetch/git-auto-fetch.plugin.zsh \
  OMZP::gitignore/gitignore.plugin.zsh \
  OMZP::git-flow/git-flow.plugin.zsh \
  wfxr/forgit \
  b4b4r07/emoji-cli

# # Terraform
# zinit ice as:"completion"
# zinit snippet OMZP::terraform/_terraform

# Docker
zinit wait lucid for \
  OMZP::docker-compose/docker-compose.plugin.zsh
#   as:"completion" OMZP::docker/_docker

# Utils
zinit for \
  OMZP::common-aliases/common-aliases.plugin.zsh \
  OMZP::sudo/sudo.plugin.zsh \
  OMZP::rsync/rsync.plugin.zsh \
  OMZP::urltools/urltools.plugin.zsh \
  OMZP::aws/aws.plugin.zsh

# Z, Tipz
# b4b4r07/enhancd \ # TODO: Review
zinit wait lucid blockf for \
  Aloxaf/fzf-tab \
  agkozak/zsh-z \
  changyuheng/fz \
  reegnz/jq-zsh-plugin \
  molovo/tipz

## Theme
eval "$(starship init zsh)"

## Last
# Load completions with highlighting
zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-completions \
  zsh-users/zsh-syntax-highlighting
