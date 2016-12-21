#!/bin/zsh
# Gonzalo Peci

############################################################################################

# # Exit if called from vim
[[ -n $VIMRUNTIME ]] && return

# # Exit if called from atom
[[ -n $ATOM_HOME ]] && return

## START Zplug config
zstyle :omz:plugins:ssh-agent identities id_rsa Github_pecigonzalo

# Check if zplug is installed
if [[ ! -f ~/.zplug/init.zsh ]]; then
  git clone https://github.com/b4b4r07/zplug ~/.zplug
  source ~/.zplug/init.zsh
else
  # Load ZPLUG
  source ~/.zplug/init.zsh
fi

# Add zplug plugins
# OMZ Libs
zplug "lib/compfix", from:oh-my-zsh, defer:0
zplug "lib/clipboard", from:oh-my-zsh, defer:0
zplug "lib/directories", from:oh-my-zsh, defer:0
zplug "lib/grep", from:oh-my-zsh, defer:0
zplug "lib/key-bindings", from:oh-my-zsh, defer:0
zplug "lib/misc", from:oh-my-zsh, defer:0
zplug "lib/termsupport", from:oh-my-zsh, defer:0
zplug "lib/theme-and-appearance", from:oh-my-zsh, defer:0

# Basic utils
zplug "plugins/common-aliases", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/ssh-agent", from:oh-my-zsh, if:"which ssh-agent"
# zplug "plugins/tmux", from:oh-my-zsh
zplug "plugins/z", from:oh-my-zsh
# zplug "rimraf/k", from:github, as:plugin
zplug "Russell91/sshrc", from:github, as:command, use:"sshrc"

# System
# zplug "plugins/archlinux", from:oh-my-zsh, if:"which pacman"
zplug "plugins/systemd", from:oh-my-zsh, if:"which systemctl"

# GIT
zplug "plugins/git", from:oh-my-zsh
# zplug "pecigonzalo/gitfast-zsh-plugin", from:github
# zplug "plugins/git-extras", from:oh-my-zsh

# Node
zplug "plugins/nvm", from:oh-my-zsh

# Ruby
zplug "plugins/ruby", from:oh-my-zsh
zplug "plugins/gem", from:oh-my-zsh
zplug "plugins/chruby", from:oh-my-zsh
zplug "plugins/bundler", from:oh-my-zsh

# Python
zplug "plugins/python", from:oh-my-zsh
zplug "plugins/pip", from:oh-my-zsh
zplug "plugins/virtualenvwrapper", from:oh-my-zsh
zplug "plugins/django", from:oh-my-zsh

# GoLang
zplug "plugins/golang", from:oh-my-zsh

# Containers/Virtual
zplug "plugins/vagrant", from:oh-my-zsh, if:"which vagrant"
zplug "plugins/docker", from:oh-my-zsh, if:"which docker"
zplug "plugins/docker-compose", from:oh-my-zsh, if:"which docker-compose"

#  Chef
zplug "plugins/knife", from:oh-my-zsh
zplug "plugins/knife_ssh", from:oh-my-zsh
zplug "plugins/kitchen", from:oh-my-zsh

# Misc
# zsh-syntax-highlighting must be loaded after executing compinit command and sourcing other plugins
zplug "zsh-users/zsh-syntax-highlighting", defer:3
zplug "zsh-users/zsh-history-substring-search", defer:3

# Set Theme
zplug "mafredri/zsh-async", from:github, defer:0  # Load this first
zplug "~/Workspace/src/pure", use:pure.zsh, from:local, as:theme
#zplug "denysdovhan/spaceship-zsh-theme", as:theme, defer:3

# And load
# Install plugins if there are plugins that have not been installed
if ! zplug check; then
  printf "Install plugins? [y/N] "
  if read -q; then
    echo
    zplug install
  else
    echo
  fi
fi

# Then, source plugins and add commands to $PATH
zplug load

## FINISH Zplug config

############################################################################################

# ===== Basics
setopt no_beep              # don't beep on error
setopt interactive_comments # Allow comments even in interactive shells (especially for Muness)

# ===== Changing Directories
setopt auto_cd           # If you type foo, and it isn't a command, and it is a directory in your cdpath, go there
setopt cdablevarS        # if argument to cd is the name of a parameter whose value is a valid directory, it will become the current directory
setopt pushd_ignore_dups # don't push multiple copies of the same directory onto the directory stack
setopt auto_pushd        # make cd push the old directory onto the directory stack
setopt pushdminus        # swapped the meaning of cd +1 and cd -1; we want them to mean the opposite of what they mean im csh

# ===== Expansion and Globbing
setopt extendedglob # treat #, ~, and ^ as part of patterns for filename generation

# ===== History
setopt append_history         # Allow multiple terminal sessions to all append to one zsh command history
setopt extended_history       # save timestamp of command and duration
setopt inc_append_history     # Add comamnds as they are typed, don't wait until shell exit
setopt hist_expire_dups_first # when trimming history, lose oldest duplicates first
setopt hist_ignore_dups       # do not write events to history that are duplicates of previous events
setopt hist_ignore_all_dups   # delete old recorded entry if new entry is a duplicate.
setopt hist_ignore_space      # remove command line from history list when first character on the line is a space
setopt hist_find_no_dups      # when searching history don't display results already cycled through twice
setopt hist_reduce_blanks     # remove extra blanks from each command line being added to history
setopt hist_verify            # don't execute, just expand history
setopt share_history          # imports new commands and appends typed commands to history
setopt hist_no_store          # remove the history (fc -l) command from the history list when invoked
setopt long_list_jobs         # list jobs in the long format by default

# ===== Completion
setopt always_to_end      # when completing from the middle of a word, move the cursor to the end of the word
setopt auto_menu          # show completion menu on successive tab press. needs unsetop menu_complete to work
setopt auto_name_dirs     # any parameter that is set to the absolute name of a directory immediately becomes a name for that directory
setopt complete_in_word   # allow completion from within a word/phrase
setopt auto_list          # automatically list choices on ambiguous completion.
unsetopt complete_aliases   # an alias of a command should complete to the command completion
unsetopt menu_complete    # do not autoselect the first completion entry
unsetopt flowcontrol      # do not freezes output to the terminal until you type ^q

# ===== Correction
# setopt correct # spelling correction for commands
# setopt correct_all # spelling correction for arguments

# ===== Prompt
setopt prompt_subst      # enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt transient_rprompt # only show the rprompt on the current prompt
unsetopt auto_name_dirs  # do not set auto_name_dirs because it messes up prompts

# ===== Scripts and Functions
setopt multios # perform implicit tees or cats when multiple redirections are attempted

# ZSH Completion config
zstyle '*' single-ignored show
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'

# Process completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path "$HOME/.zsh/cache"

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'

# Key bindings
# Emacs mode
bindkey -e
# Bind ctrl-left / ctrl-right
bindkey "\e[1;5D" backward-word
bindkey "\e[1;5C" forward-word
# Bind home / end
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line

############################################################################################

# # # Load default virtualenv
source /usr/bin/virtualenvwrapper.sh
workon 2.7
# # Load default chruby
source /usr/local/share/chruby/chruby.sh
chruby ruby-2.2.5

# TMP DotEnv loader
#source_env() {
#   if [[ -f .env ]]; then
#	source .env
#   fi
#}

# make less accept color codes and re-output them
alias less="less -R"
# gitg no output
alias gitg="gitg >> /dev/null 2>&1"
# Run glances in a container
alias glances="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock:ro --pid host -it docker.io/nicolargo/glances"
# Git tool
alias gitlog="git log --oneline --all --graph --decorate -n 30"
function gitclean {
 git branch --merged | grep -v "\*" | grep -v master | xargs -n1 git branch -d
}

# urlencode text
function urlencode {
  print "${${(j: :)@}//(#b)(?)/%$[[##16]##${match[1]}]}"
}

# Remove entry from hosts
func remove_from_hosts() {sed -i "$($arg1)d" ~/.ssh/known_hosts}
