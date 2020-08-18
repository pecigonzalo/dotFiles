#!/usr/bin/zsh

# If under WSL load wsl profiles
if [[ -n "$WSL_DISTRO_NAME" ]]; then
  source "$HOME/dotFiles/scripts/wsl_profile.sh"
fi
