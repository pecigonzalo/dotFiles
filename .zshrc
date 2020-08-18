#!/usr/bin/zsh
############################################################################################
# Gonzalo Peci
############################################################################################
zmodload zsh/zprof

autoload -U colors && colors

# Load zinit
source ~/.zinit/bin/zinit.zsh

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

source "$HOME/dotFiles/scripts/zinit.zsh"
# Load shared aliases
source "$HOME/dotFiles/scripts/aliases.zsh"
# Get funtions
source "$HOME/dotFiles/scripts/functions.zsh"
# Get wsl
# If under WSL, load
if [[ -n "$WSL_DISTRO_NAME" ]]; then
  source "$HOME/dotFiles/scripts/wsl.zsh"
fi

if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
  zcompile "$zcompdump"
fi

zprof >/tmp/zprof

# ############################################################################################

# ===== Basics
unsetopt bg_nice              # do NOT nice bg commands
setopt no_beep                # don't beep on error
setopt interactive_comments   # Allow comments even in interactive shells (especially for Muness)
setopt prompt_subst           # Prompt string is first subjected to parameter expansion, command substitution and arithmetic expansion.

# ===== Changing Directories
setopt auto_cd                # If you type foo, and it isn't a command, and it is a directory in your cdpath, go there
setopt cdablevars             # if argument to cd is the name of a parameter whose value is a valid directory, it will become the current directory
setopt pushd_ignore_dups      # don't push multiple copies of the same directory onto the directory stack
setopt auto_pushd             # make cd push the old directory onto the directory stack
setopt pushdminus             # swapped the meaning of cd +1 and cd -1; we want them to mean the opposite of what they mean im csh

# ===== Expansion and Globbing
setopt extendedglob           # treat #, ~, and ^ as part of patterns for filename generation

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
setopt always_to_end     # when completing from the middle of a word, move the cursor to the end of the word
setopt auto_menu         # show completion menu on successive tab press. needs unsetop menu_complete to work
setopt auto_name_dirs    # any parameter that is set to the absolute name of a directory immediately becomes a name for that directory
setopt complete_in_word  # allow completion from within a word/phrase
setopt auto_list         # automatically list choices on ambiguous completion.
unsetopt completealiases # an alias of a command should complete to the command completion
unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol     # do not freezes output to the terminal until you type ^q

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
zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
# Speed up autocomplete, force prefix mapping
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh"
#
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:default' list-colors 'repsly=("${PREFIX:+=(#bi)($PREFIX:t)*==34=34}:${(s.:.)LS_COLORS}")'

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select=1 _complete _ignored _approximate

# Process completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

# disable named-directories autocompletion
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
  clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
  gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
  ldap lp mail mailman mailnull man messagebus mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
  operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
  usbmux uucp vcsa wwwrun xfs '_*'

############################################################################################

# Keyboard

bindkey -e # Use emacs key bindings

# Ctrl+W uses bash style delimiters
# https://unix.stackexchange.com/a/594305
# http://info2html.sourceforge.net/cgi-bin/info2html-demo/info2html?(zsh)ZLE%2520Functions
autoload -Uz backward-kill-word-match
zle -N backward-kill-word-match
bindkey '^W' backward-kill-word-match

zstyle :zle:backward-kill-word-match word-style standard
zstyle :zle:backward-kill-word-match word-chars ''


# Nix
if [[ -f "/etc/profile.d/nix.sh" ]]; then
  source /etc/profile.d/nix.sh
fi
