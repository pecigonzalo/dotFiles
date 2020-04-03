#!/usr/bin/zsh

# Skip the not really helping Ubuntu global compinit
skip_global_compinit=1

# Base config
declare -U path

# User Bin
path=($HOME/.local/bin $path)

# ssh-agent SOCK
export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
export SSH_ASKPASS="/usr/bin/ksshaskpass"

# History config
export HISTFILE=$HOME/.histfile
export HISTSIZE=100000
export SAVEHIST=20000

# Ignore Command History
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help"
export HISTORY_IGNORE='(awsvl *|ls|cd -|cd|pwd|exit|date|man *|* --help)'

# Editor
export VISUAL='vim'
export EDITOR="${VISUAL}"
export CVSEDITOR="${VISUAL}"
export SVN_EDITOR="${VISUAL}"
export GIT_EDITOR="${VISUAL}"

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

# Set aws-vault backend
export AWS_VAULT_BACKEND=kwallet

# Set BK backend
export BUILDKITE_CLI_KEYRING_BACKEND=kwallet

# Spaceship Theme Config
export SPACESHIP_PROMPT_ORDER=(
  time # Time stamps section
  user # Username section
  dir  # Current directory section
  host # Hostname section
  git  # Git section (git_branch + git_status)
  #   node          # Node.js section
  #   ruby          # Ruby section
  golang # Go section
  docker # Docker section
  #   aws           # Amazon Web Services section
  venv  # virtualenv section
  pyenv # Pyenv section
  #   dotnet        # .NET section
  #   kubecontext   # Kubectl context section
  #   terraform     # Terraform workspace section
  exec_time # Execution time
  line_sep  # Line break
  #   vi_mode       # Vi-mode indicator
  jobs      # Background jobs indicator
  exit_code # Exit code section
  char      # Prompt character
)
export SPACESHIP_GIT_BRANCH_COLOR="$(tput setaf 240)"
export SPACESHIP_DIR_COLOR="blue"
export SPACESHIP_CHAR_SYMBOL="❯"
export SPACESHIP_CHAR_SUFFIX=" "
export SPACESHIP_DIR_TRUNC=0
export SPACESHIP_DIR_TRUNC_REPO=false

# Generated completions path
export GENCOMPL_FPATH="$HOME/.zsh/complete"

# PyEnv
export PYENV_ROOT="$HOME/.pyenv"
path=($PYENV_ROOT/bin $path)

# Pipenv
export PIPENV_VENV_IN_PROJECT=true

# Golang
export GOPATH="$HOME/Workspace/go"
path=($GOPATH/bin $path)

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

# z
export ZSHZ_CMD="_z"
