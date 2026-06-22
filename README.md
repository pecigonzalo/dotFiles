# Gonzalo's dotFiles

Personal development and productivity configuration, mostly managed with Nix and Home Manager. The flake supports this macOS machine, WSL2, and standalone Linux Home Manager targets.

![](https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExNWUwMG1wczdxeHJycHVrOGdmZnZ3M2hoM2V6dXgwYXcwbHE1eXp6ayZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/9r75ILTJtiDACKOKoY/giphy.gif)

## Development

```sh
nix develop
nix flake check --all-systems --no-build
```

## Apply configurations

```sh
# macOS
sudo darwin-rebuild switch --flake .#pecigonzalo

# WSL2 NixOS
sudo nixos-rebuild switch --flake .#wsl

# Standalone Home Manager targets
home-manager switch --flake .#wslfish
home-manager switch --flake .#revel
home-manager switch --flake .#devel
```
