# Gonzalo Peci

## Base config
limit coredumpsize 0

# Exit if called from vim
[[ -n $VIMRUNTIME ]] && return


HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
# ===== Basics
setopt no_beep # don't beep on error
setopt interactive_comments # Allow comments even in interactive shells (especially for Muness)

# ===== Changing Directories
setopt auto_cd # If you type foo, and it isn't a command, and it is a directory in your cdpath, go there
setopt cdablevarS # if argument to cd is the name of a parameter whose value is a valid directory, it will become the current directory
setopt pushd_ignore_dups # don't push multiple copies of the same directory onto the directory stack

# ===== Expansion and Globbing
setopt extendedglob # treat #, ~, and ^ as part of patterns for filename generation

# ===== History
setopt append_history # Allow multiple terminal sessions to all append to one zsh command history
setopt extended_history # save timestamp of command and duration
setopt inc_append_history # Add comamnds as they are typed, don't wait until shell exit
setopt hist_expire_dups_first # when trimming history, lose oldest duplicates first
setopt hist_ignore_dups # Do not write events to history that are duplicates of previous events
setopt hist_ignore_space # remove command line from history list when first character on the line is a space
setopt hist_find_no_dups # When searching history don't display results already cycled through twice
setopt hist_reduce_blanks # Remove extra blanks from each command line being added to history
setopt hist_verify # don't execute, just expand history
setopt share_history # imports new commands and appends typed commands to history

# ===== Completion 
setopt always_to_end # When completing from the middle of a word, move the cursor to the end of the word    
setopt auto_menu # show completion menu on successive tab press. needs unsetop menu_complete to work
setopt auto_name_dirs # any parameter that is set to the absolute name of a directory immediately becomes a name for that directory
setopt complete_in_word # Allow completion from within a word/phrase
setopt auto_list           # Automatically list choices on ambiguous completion.
unsetopt menu_complete # do not autoselect the first completion entry

# ===== Correction
setopt correct # spelling correction for commands
setopt correct_all # spelling correction for arguments  

# ===== Prompt
setopt prompt_subst # Enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt transient_rprompt # only show the rprompt on the current prompt

# ===== Scripts and Functions
setopt multios # perform implicit tees or cats when multiple redirections are attempted

# ZSH Completion config

zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path "$HOME/.zsh/cache"

# Key bindings
# Emacs mode
bindkey -e
# Bind ctrl-left / ctrl-right
bindkey "\e[1;5D" backward-word
bindkey "\e[1;5C" forward-word

# make less accept color codes and re-output them
alias less="less -R"
# gitg no output
alias gitg="gitg >> /dev/null 2>&1"
# Run glances in a container
alias glances="docker run -v /var/run/docker.sock:/var/run/docker.sock:ro --pid host -it docker.io/nicolargo/glances"

# urlencode text
function urlencode {
  print "${${(j: :)@}//(#b)(?)/%$[[##16]##${match[1]}]}"
}

# Zenmate Chef Environment Switchs
alias knife_stage="export CHEF_ENV=staging; bundle exec knife"

alias knife_prod="export CHEF_ENV=production; bundle exec knife"

# Git tool
alias gitlog="git log --oneline --all --graph --decorate -n 30"

############################################################################################

# The following lines were added by compinstall

# zstyle ':completion:*' completer _complete _ignored _approximate
# zstyle ':completion:*' matcher-list '' '' '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
# zstyle :compinstall filename '/home/gonzalop/.zshrc'

# autoload -Uz compinit
# compinit
# End of lines added by compinstall

############################################################################################

## START Zplug config
zstyle :omz:plugins:ssh-agent identities id_rsa Github_pecigonzalo

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"
# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Check if zplug is installed
[[ -d ~/.zplug ]] || {
  git clone https://github.com/b4b4r07/zplug ~/.zplug
  source ~/.zplug/zplug && zplug update --self
}

# Load ZPLUG
source ~/.zplug/zplug

# Oh My ZSH Workaround
zplug "robbyrussell/oh-my-zsh", use:"lib/*.zsh", nice:-19

# Add zplug plugins
zplug "plugins/common-aliases", from:oh-my-zsh
zplug "plugins/gnu-utils", from:oh-my-zsh
zplug "plugins/sudo",   from:oh-my-zsh
zplug "plugins/ssh-agent",   from:oh-my-zsh, if:"which ssh-agent"
zplug "plugins/tmuxinator", from:oh-my-zsh

zplug "plugins/dnf",   from:oh-my-zsh, if:"which dnf"
zplug "plugins/ubuntu",   from:oh-my-zsh, if:"which apt"
zplug "plugins/systemd", from:oh-my-zsh, if:"which systemctl"

zplug "plugins/git",   from:oh-my-zsh, if:"which git"
zplug "plugins/gitfast",   from:oh-my-zsh, if:"which git"
zplug "plugins/git-extras", from:oh-my-zsh, if:"which git-extras"

zplug "plugins/npm",   from:oh-my-zsh, if:"which npm"

zplug "plugins/ruby",   from:oh-my-zsh, if:"which ruby"
zplug "plugins/gem",   from:oh-my-zsh, if:"which gem"
zplug "plugins/chruby",   from:oh-my-zsh, if:"which chruby-exec"
zplug "rhysd/zsh-bundle-exec", if:"which bundle"

zplug "plugins/vagrant",   from:oh-my-zsh, if:"which vagrant"
zplug "plugins/docker",   from:oh-my-zsh, if:"which docker"

zplug "plugins/sublime",   from:oh-my-zsh

zplug "plugins/go",   from:oh-my-zsh, if:"which go"
zplug "plugins/golang",   from:oh-my-zsh, if:"which go"

zplug "plugins/python",   from:oh-my-zsh, if:"which python"
zplug "plugins/pip",   from:oh-my-zsh, if:"which pip"
zplug "plugins/virtualenv",   from:oh-my-zsh, if:"which virtualenv"
zplug "plugins/virtualenvwrapper",   from:oh-my-zsh, if:"which virtualenvwrapper.sh"

zplug "plugins/knife",   from:oh-my-zsh
zplug "plugins/knife_ssh",   from:oh-my-zsh
zplug "plugins/kitchen",   from:oh-my-zsh

zplug "rimraf/k", from:github, as:plugin
zplug "Russell91/sshrc", from:github, as:command, use:"sshrc"

zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions", \
    nice:11
# zplug "zsh-users/zsh-autosuggestions", \
#    nice:-1
# zsh-syntax-highlighting must be loaded after executing compinit command and sourcing other plugins
zplug "zsh-users/zsh-syntax-highlighting", \
    nice:11

# Set Theme
zplug "denysdovhan/spaceship-zsh-theme"

# And load
# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

## FINISH Zplug config

