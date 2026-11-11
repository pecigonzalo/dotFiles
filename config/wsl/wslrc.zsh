#!/usr/bin/zsh

win_user_profile="$(wslpath $(wslvar USERPROFILE))"

# Manually set PATH for Windows folders we want
path=(
  $path
  "/mnt/c/Windows/system32"
  "/mnt/c/Windows"
  "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/"
  "/mnt/c/Program Files/Microsoft VS Code/bin"
  "${win_user_profile}/AppData/Local/Programs/Microsoft VS Code/bin"
  "${win_user_profile}/go/bin"
  "${win_user_profile}/scoop/shims"
  "${win_user_profile}/AppData/Local/Microsoft/WindowsApps"
  "${win_user_profile}/bin"
)

# Remove .dll and other crap from autocomp
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*.dll' '*.DLL'

# TODO: Remove
# Set aws-vault backend
export AWS_VAULT_BACKEND=file
export AWS_VAULT_FILE_PASSPHRASE='ABC123abc!'

# Set BK backend
export BUILDKITE_CLI_KEYRING_BACKEND=file
