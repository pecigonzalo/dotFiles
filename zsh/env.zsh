#!/usr/bin/zsh

# Linuxbrew or Homebrew
# if [[ -d /home/linuxbrew/.linuxbrew ]]; then
#   export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
# elif [[ -d /opt/homebrew ]]; then
#   export HOMEBREW_PREFIX="/opt/homebrew"
# fi

# if [[ -n $HOMEBREW_PREFIX ]]; then
#   export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
#   export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew"
#   export path=("${HOMEBREW_PREFIX}/bin" "${HOMEBREW_PREFIX}/sbin" $path)
#   export MANPATH="${HOMEBREW_PREFIX}/share/man${MANPATH+:$MANPATH}:"
#   export INFOPATH="${HOMEBREW_PREFIX}/share/info:${INFOPATH}"
#   FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}"
# fi
# Homebrew gnubins
# if [[ -d /opt/homebrew ]]; then
# for gnubin in ${HOMEBREW_PREFIX}/opt/*/libexec/gnubin; do
#   export path=($gnubin $path)
# done
# for gnuman in ${HOMEBREW_PREFIX}/opt/*/libexec/gnuman; do
#   export manpath=($gnuman $manpath)
# done
# excl=("/opt/homebrew/opt/findutils/libexec/gnubin" "/opt/homebrew/opt/coreutils/libexec/gnubin")
# path=${path:|excl}
# export LDFLAGS="-L${HOMEBREW_PREFIX}/opt/zlib/lib -L${HOMEBREW_PREFIX}/opt/bzip2/lib"
# export CPPFLAGS="-I${HOMEBREW_PREFIX}/opt/zlib/include -I${HOMEBREW_PREFIX}/opt/bzip2/include"
# export PKG_CONFIG_PATH="${HOMEBREW_PREFIX}/opt/zlib/lib/pkgconfig"
# fi

# Nix
# if [[ -f "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]]; then
#   source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
#   source "${HOME}/.nix-profile/etc/profile.d/hm-session-vars.sh"
#   FPATH="${HOME}/.nix-profile/share/zsh/site-functions:${FPATH}"
#   FPATH="${HOME}/.nix-profile/share/zsh/vendor-completions:${FPATH}"
# fi

# if [[ -d ${HOME}/.nix-profile ]]; then
#   export PKG_CONFIG_PATH="${HOME}/.nix-profile/lib/pkgconfig"
#   export CFLAGS="-I${HOME}/.nix-profile/include"
#   export CPPFLAGS="-I${HOME}/.nix-profile/include"
#   export CPATH="${HOME}/.nix-profile/include"
#   export LIBRARY_PATH="${HOME}/.nix-profile/lib"
#   export LDFLAGS="-L${HOME}/.nix-profile/lib"
#   export LD_LIBRARY_PATH="${HOME}/.nix-profile/lib"
#   export QTDIR="${HOME}/.nix-profile"
# fi

# Set LS_COLORS
eval $(dircolors)

# ssh-agent SOCK
# export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"
# export SSH_ASKPASS="/usr/bin/ksshaskpass"

# LESS man page colors (makes Man pages more readable).
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[00;44;37m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# zsh-syntax-highlighting
export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
