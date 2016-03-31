# All bin
#export PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH"
# /home/gonzalop/.zplug/bin:/home/gonzalop/.zplug/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

# User Bin
# export PATH="$HOME/.local/bin:$PATH"

# Golang
export GOPATH="$HOME/Workspace/Go"
export PATH="$GOBIN:$PATH"
export PATH="$GOPATH/bin:$PATH"

# Editor
export EDITOR=vim
export CVSEDITOR="${EDITOR}"
export SVN_EDITOR="${EDITOR}"
export GIT_EDITOR="${EDITOR}"

# Load shared aliases
source $HOME/.aliases
