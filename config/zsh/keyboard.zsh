# Set ctrl+w to use bash style delimiters
# https://unix.stackexchange.com/a/594305
# http://info2html.sourceforge.net/cgi-bin/info2html-demo/info2html?(zsh)ZLE%2520Functions
autoload -Uz backward-kill-word-match
zle -N backward-kill-word-match
bindkey '^W' backward-kill-word-match
bindkey '^[^?' backward-kill-word-match

zstyle :zle:backward-kill-word-match word-style standard
zstyle :zle:backward-kill-word-match word-chars ''

bindkey '^o' edit-command-line
