# Speed up autocomplete
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh"

# # Set formatting
zstyle ':completion:*' format '[%d]'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:corrections' format '%F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:warnings' format '%F{red}-- No matches for:%f %d --'

# Display the name of tag for the matches will be used as the name of the group
zstyle ':completion:*' group-name ''

# Set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Don't complete uninteresting users
zstyle ':completion:*:users' ignored-patterns '_*'

# Ignore completion functions
zstyle ':completion:*:functions' ignored-patterns '_*'

# Preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# A prefix for fzf-tab completions
zstyle ':fzf-tab:*' prefix ''
# Show the color and name of the header for single groups
zstyle ':fzf-tab:*' single-group color header
# Disabling group headers
zstyle ':fzf-tab:*' show-group brief

# Disable sort when completing `git`
zstyle ':completion:*:git-*:*' sort false

# zstyle ':fzf-tab:*' fzf-bindings 'tab:toggle'
