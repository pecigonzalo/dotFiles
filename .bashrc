#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# added by travis gem
[ -f /home/gonzalop/.travis/travis.sh ] && source /home/gonzalop/.travis/travis.sh

alias gam="/home/gonzalop/bin/gam/gam"
