# All bin
#export PATH="/sbin:/usr/sbin:/usr/local/sbin:$PATH"

# User Bin
export PATH="$HOME/.local/bin:$PATH"

# Golang
export GOPATH="$HOME/Workspace/Go"
export PATH="$GOPATH/bin:$PATH"

# Editor
export EDITOR=atom
export CVSEDITOR="${EDITOR}"
export SVN_EDITOR="${EDITOR}"
export GIT_EDITOR="${EDITOR}"

# Load shared aliases
[[ -f $HOME/.aliases ]] && source $HOME/.aliases

# Load default virtualenv
[[ -f $HOME/src/python2.7/bin/activate ]] && source $HOME/src/python2.7/bin/activate
