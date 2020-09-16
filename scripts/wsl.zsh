#!/usr/bin/zsh

# Manually set PATH for Windows folders we want
path=(
  $path
  "/mnt/c/Windows/system32"
  "/mnt/c/Windows"
  # /mnt/c/Windows/System32/Wbem
  "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/"
  "/mnt/c/Windows/System32/OpenSSH/"
  "/mnt/c/Program Files/Microsoft VS Code/bin"
  "/mnt/c/Users/pecigonzalo/go/bin"
  "/mnt/c/Users/pecigonzalo/scoop/shims"
  "/mnt/c/Users/pecigonzalo/AppData/Local/Microsoft/WindowsApps"
  "/mnt/c/Users/pecigonzalo/bin"
)

# Remove .dll and other crap from autocomp
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*.dll' '*.DLL'
