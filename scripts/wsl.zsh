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


# If not under WSL, return
if [[ -z "$WSL_DISTRO_NAME" ]]; then
  return
fi

services=(
  cron
  rsyslog
  docker
)

for service in "${services[@]}"; do
  if [[ "$(service $service status)" =~ '.*is not running' ]]; then
    sudo service "$service" start
  fi
done

# X Forwarding
export DISPLAY="$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0"
export LIBGL_ALWAYS_INDIRECT="1"
