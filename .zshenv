#!/usr/bin/zsh

# Skip the not really helpfull Ubuntu global compinit
skip_global_compinit=1

# Linuxbrew or Homebrew
if [[ -d /home/linuxbrew/.linuxbrew ]]; then
  export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
elif [[ -d /opt/homebrew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
fi

if [[ -n $HOMEBREW_PREFIX ]]; then
  export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
  export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
  export path=("${HOMEBREW_PREFIX}/binss" "${HOMEBREW_PREFIX}/bin" "${HOMEBREW_PREFIX}/sbin" $path)
  export MANPATH="${HOMEBREW_PREFIX}/share/man${MANPATH+:$MANPATH}:"
  export INFOPATH="${HOMEBREW_PREFIX}/share/info:${INFOPATH}"
  FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}"
fi
# Homebrew gnubins
if [[ -d /opt/homebrew ]]; then
  for gnubin in ${HOMEBREW_PREFIX}/opt/*/libexec/gnubin; do
    export path=($gnubin $path)
  done
  for gnuman in ${HOMEBREW_PREFIX}/opt/*/libexec/gnuman; do
    export manpath=($gnuman $manpath)
  done
  # excl=("/opt/homebrew/opt/findutils/libexec/gnubin" "/opt/homebrew/opt/coreutils/libexec/gnubin")
  # path=${path:|excl}
fi

# Nix
if [[ -f "/etc/profile.d/nix.sh" ]]; then
  source /etc/profile.d/nix.sh
elif [[ -f "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]]; then
  source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
  source "${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh"
  FPATH="${HOME}/.nix-profile/share/zsh/site-functions:${FPATH}"
  FPATH="${HOME}/.nix-profile/share/zsh/vendor-completions:${FPATH}"
fi

# Set LS_COLORS
eval $(dircolors)

# Golang
export GOPATH="$HOME/Workspace/go"
path=($GOPATH/bin $path)

# Base config
declare -U path

# User Bin
path=($HOME/.local/bin $path)

# ssh-agent SOCK
# export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
# export SSH_ASKPASS="/usr/bin/ksshaskpass"

# History config
export HISTFILE=$HOME/.histfile
export HISTSIZE=100000
export SAVEHIST=200000

# Ignore Command History
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"
export HISTORY_IGNORE='(awsvl *|ls|cd -|cd|pwd|exit|date|man *|* --help|)'

# Editor
export EDITOR='nvim'
export VISUAL='nvim'

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

# Disable virtualenv in prompt autoconfig
export VIRTUAL_ENV_DISABLE_PROMPT=1

# TLDR Colors
export TLDR_COLOR_BLANK="white"
export TLDR_COLOR_NAME="cyan"
export TLDR_COLOR_DESCRIPTION="white"
export TLDR_COLOR_EXAMPLE="green"
export TLDR_COLOR_COMMAND="red"
export TLDR_COLOR_PARAMETER="white"

# Generated completions path
export GENCOMPL_FPATH="$HOME/.zsh/complete"

# Pipenv
export PIPENV_VENV_IN_PROJECT=true

# OMZ
export DISABLE_UPDATE_PROMPT="true"
export DISABLE_AUTO_UPDATE="true"

# fzf
export FZF_DEFAULT_COMMAND="fd --type file --color=always ."
export FZF_DEFAULT_OPTS="--multi --ansi --height=50% --min-height=15 --reverse --color=bg:-1,fg:-1,prompt:1,info:3,hl:2,hl+:2"
## Search with preview
export FZF_CTRL_T_OPTS="--preview '(bat --color=always {} || tree -C {}) 2> /dev/null' --select-1 --exit-0"
## Search history
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
## Search Folders
export FZF_ALT_C_COMMAND="fd --type directory --color=always . $HOME"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

# Tipz
export TIPZ_TEXT='💡'

# zsh-autosuggestions
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC="true"

# zsh-z, fz
export ZSHZ_CMD="zshz"
export ZSHZ_NO_RESOLVE_SYMLINKS=1
export FZ_HISTORY_CD_CMD="zshz"
export FZ_SUBDIR_TRAVERSAL=0

# Docker
export DOCKER_BUILDKIT=1

# K8s Krew
path=($path $HOME/.krew/bin)

# github.com/oz/tz
export TZ_LIST="Europe/Madrid;Home,US/Pacific;PDT"
