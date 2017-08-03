#!/bin/bash
# -------------------------------------------------------------------
# compressed file expander
# (from https://github.com/myfreeweb/zshuery/blob/master/zshuery.sh)
# -------------------------------------------------------------------
ex() {
    if [[ -f $1 ]]; then
        case $1 in
          *.tar.bz2) tar xvjf "$1";;
          *.tar.gz) tar xvzf "$1";;
          *.tar.xz) tar xvJf "$1";;
          *.tar.lzma) tar --lzma xvf "$1";;
          *.bz2) bunzip "$1";;
          *.rar) unrar "$1";;
          *.gz) gunzip "$1";;
          *.tar) tar xvf "$1";;
          *.tbz2) tar xvjf "$1";;
          *.tgz) tar xvzf "$1";;
          *.zip) unzip "$1";;
          *.Z) uncompress "$1";;
          *.7z) 7z x "$1";;
          *.dmg) hdiutul mount "$1";; # mount OS X disk images
          *) echo "'$1' cannot be extracted via >ex<";;
    esac
    else
        echo "'$1' is not a valid file"
    fi
}

# -------------------------------------------------------------------
# display a neatly formatted path
# -------------------------------------------------------------------
path() {
  echo "$PATH" | tr ":" "\n" | \
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
function nicemount() { (echo "DEVICE PATH TYPE FLAGS" && mount | awk '$2="";1') | column -t ; }

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
