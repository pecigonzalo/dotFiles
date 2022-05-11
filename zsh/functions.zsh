#!/bin/zsh
# -------------------------------------------------------------------
# compressed file expander
# (from https://github.com/myfreeweb/zshuery/blob/master/zshuery.sh)
# -------------------------------------------------------------------
ex() {
  if [[ -f $1 ]]; then
    case $1 in
    *.tar.bz2) tar xvjf "$1" ;;
    *.tar.gz) tar xvzf "$1" ;;
    *.tar.xz) tar xvJf "$1" ;;
    *.tar.lzma) tar --lzma xvf "$1" ;;
    *.bz2) bunzip "$1" ;;
    *.rar) unrar "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xvf "$1" ;;
    *.tbz2) tar xvjf "$1" ;;
    *.tgz) tar xvzf "$1" ;;
    *.zst) tar --zstd -xvf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *.xz) xz -dkv "$1" ;;
    *.dmg) hdiutul mount "$1" ;; # mount OS X disk images
    *) echo "'$1' cannot be extracted via >ex<" && return 1;;
    esac
  else
    echo "'$1' is not a valid file"
    return 1
  fi
}

# -------------------------------------------------------------------
# display a neatly formatted path
# ------------------------------>
path() {
  echo "$PATH" | tr ":" "\n" |
    awk "{ sub(\"/usr\",   \"$fg_no_bold[green]/usr$reset_color\"); \
           sub(\"/bin\",   \"$fg_no_bold[blue]/bin$reset_color\"); \
           sub(\"/opt\",   \"$fg_no_bold[cyan]/opt$reset_color\"); \
           sub(\"/sbin\",  \"$fg_no_bold[magenta]/sbin$reset_color\"); \
           sub(\"/local\", \"$fg_no_bold[yellow]/local$reset_color\"); \
           print }"
}

# -------------------------------------------------------------------
# nice mount (http://catonmat.net/blog/another-ten-one-liners-from-commandlingfu-explained)
# displays mounted drive information in a nicely formatted manner
# -------------------------------------------------------------------
nicemount() { (echo "DEVICE PATH TYPE FLAGS" && mount | awk '$2="";1') | column -t; }

# -------------------------------------------------------------------
# shell function to define words
# http://vikros.tumblr.com/post/23750050330/cute-little-function-time
# -------------------------------------------------------------------
givedef() {
  if [[ $# -ge 2 ]]; then
    echo "givedef: too many arguments" >&2
    return 1
  else
    curl "dict://dict.org/d:$1"
  fi
}

# Clean merged git branches
gitclean() {
  git branch --merged | grep -v "\*" | grep -v master | xargs -n1 git branch -d
}

# Remove entry from hosts
rm-known-host() {sed -i "$($arg1)d" ~/.ssh/known_hosts}

# ExplainShell on CLI
explain() {
  command="$@"
  tool="$(echo $@ | cut -d' ' -f1)"
  params="$(echo $@ | cut -d' ' -f2-)"
  w3m -dump "https://explainshell.com/explain?cmd=${command}" |
    sed '/'"$tool"'/,$!d'
}

# Short aws-vault
awsve() {
  aws-vault exec --duration=3h $@
}

# Short aws-vault login
awsvl() {
  if [[ $# -eq 0 ]]; then
    local TOKEN="$(aws-vault list | grep '\-vault' | cut -d' ' -f1| fzf | xargs aws-vault login -d 1h -s)"
  else
    local TOKEN="$(aws-vault login -d 1h -s $@)"
  fi

  if [[ $TOKEN =~ "signin.aws.amazon.com" ]]; then
    local cache=$(mktemp -d /tmp/google-chrome-XXXXXX)
    local data=$(mktemp -d /tmp/google-chrome-XXXXXX)
    open -na "Google Chrome" --args \
     --no-first-run \
     --disk-cache-dir=$cache \
     --user-data-dir=$data \
     $TOKEN
    rm -rf $cache $data
  else
    echo $TOKEN
  fi
}

# Login to ECR repositories
ecr-login() {
  region=${1:-eu-central-1}
  id=${2}
  while read -r registry; do
    eval "$registry"
  done <<<$(
    aws ecr get-login \
      --no-include-email \
      --region "$region" \
      --registry-ids $id
  )
}

# TMUX
tmx() {
  if [[ $DISPLAY && ! $- != *i* ]]; then
    if [[ -z "$TMUX" && -z "$EMACS" && -z "$VIM" ]]; then
      # Only first run will be able to list windows
      # after it creates the session
      if ! tmux has-session -t "default"; then
        tmux new-session -s "default"
      else
        tmux new-session -t "default" \; set-option destroy-unattached \; new-window
      fi
    fi
  fi
}

# WSL2 clipcopy
clipcopy() {
  emulate -L zsh
  local file=$1
  if [[ $OSTYPE == darwin* ]]; then
    if [[ -z $file ]]; then
      pbcopy
    else
      cat $file | pbcopy
    fi
  elif [[ $OSTYPE == (cygwin|msys)* ]]; then
    if [[ -z $file ]]; then
      cat > /dev/clipboard
    else
      cat $file > /dev/clipboard
    fi
  elif [[ $OSTYPE == (linux-gnu)* ]]; then
    if [[ -z $file ]]; then
      cat | clip.exe
    else
      cat $file | clip.exe
    fi
  else
    if (( $+commands[xclip] )); then
      if [[ -z $file ]]; then
        xclip -in -selection clipboard
      else
        xclip -in -selection clipboard $file
      fi
    elif (( $+commands[xsel] )); then
      if [[ -z $file ]]; then
        xsel --clipboard --input
      else
        cat "$file" | xsel --clipboard --input
      fi
    else
      print "clipcopy: Platform $OSTYPE not supported or xclip/xsel not installed" >&2
      return 1
    fi
  fi
}

# Quick Install download folder in path
# letmetry $URL
letmetry() {
  # set -x
  URL="${1:-}"
  if [[ -z $URL ]]; then
    echo "Please specify a URL"
    return 1
  fi

  FILE="${URL##*/}"
  TMP="$(mktemp -d)"
  OUT="${TMP}/${FILE}"

  # Run on a subshell so we dont need to manage PWD
  (
    cd "$TMP"
    wget -q --show-progress --https-only --timestamping "$URL" -O "${OUT}"
  )
  ex "${OUT}" > /dev/null 2>&1 || NOEX=true
  if [[ "$NOEX" ]]; then
    PATH="${TMP}:${PATH}"
    chmod +x ${TMP}/*
  else
    PATH="${TMP}/bin:${PATH}"
    chmod +x ${TMP}/bin/*
  fi
}

# Move binary to user path
# userinstall $LOCAL_SRC $NAME
userinstall() {
  # set -x
  SRC="${1:-}"
  NAME="${2:-${SRC##*/}}"
  if [[ -z $SRC ]]; then
    echo "Please specify a SRC"
    return 1
  fi

  echo "Installing ${NAME} from ${SRC}"
  if type install >/dev/null 2>&1; then
    echo install -T "${SRC}" "${HOME}/.local/bin/${NAME}"
  else
    echo cp "${SRC}" "${HOME}/.local/bin/${NAME}"
    echo chmod +x "${HOME}/.local/bin/${NAME}"
  fi
}

config() {
  git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

# Scratch dir
mkt() {
  cd $(mktemp -d)
}

# Git Clean Squashed
gitcleansquash() {
  currentBranch=$(git rev-parse --abbrev-ref HEAD)
  git checkout -q master
  git for-each-ref refs/heads/ "--format=%(refname:short)" | while read branch; do
    mergeBase=$(git merge-base master $branch)
    if [[ $(git cherry master $(git commit-tree $(git rev-parse $branch\^{tree}) -p $mergeBase -m _)) == "-"* ]]; then
      if [[ $1 == "now" ]]; then
        git branch -D $branch
      else
        echo "$branch is merged into master and can be deleted"
      fi
    fi
  done
  git checkout -q ${currentBranch}
}
