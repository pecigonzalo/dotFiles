# Gonzalo's dotFiles

Personal development and productivity configuration, mostly managed with Nix and Home Manager. The flake supports this macOS machine, WSL2, and standalone Linux Home Manager targets.

![](https://media4.giphy.com/media/v1.Y2lkPTc5MGI3NjExNWUwMG1wczdxeHJycHVrOGdmZnZ3M2hoM2V6dXgwYXcwbHE1eXp6ayZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/9r75ILTJtiDACKOKoY/giphy.gif)

## Development

```sh
nix develop
lefthook install
nix flake check --all-systems --no-build
```

## Apply configurations

```sh
# macOS, including bootstrap before darwin-rebuild is installed
nix run .#darwin -- switch

# WSL2 NixOS
sudo nixos-rebuild switch --flake .#wsl

# Standalone Home Manager targets
home-manager switch --flake .#wslfish
home-manager switch --flake .#revel
home-manager switch --flake .#devel
```

## Layout

```
flake.nix, flake.lock    Flake entry point
nix/                     Nix code: flake helpers, modules, home, darwin, pkgs, overlays
config/                  Files edited live and symlinked into $HOME (via `my.paths.mkDotFileLink`)
  home/                  Home-directory dotfiles (gemrc, psqlrc, textlintrc, tool-versions)
  nvim/ zsh/ nushell/    Shell and editor config
  hammerspoon/ wezterm/  macOS and terminal config
  fontconfig/            Linked on every platform
  linux/ wsl/            Linux and WSL specific files
  k3d/ vscode/           Local cluster and editor settings
  git_template/          Git template directory (hooks)
  chrome-color-helper/   Browser extension used by the AWS console helpers
bin/                     Scripts linked into ~/.local/bin
stylua.toml, selene.toml, vim.toml, lefthook.yml   Linter and hook config (must stay at the root)
```

`config/` is symlinked out-of-store, so edits apply immediately without a rebuild. Everything under `nix/` needs a switch.
