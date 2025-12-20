{ pkgs, lib, ... }:
{
  imports = [
    # Minimal config of Nix related options and shells
    ./bootstrap.nix
    ./nix.nix

    # Other nix-darwin configuration
    ./homebrew.nix
    ./system.nix
    ./cachix.nix
  ];

  programs.nix-index.enable = true;

  fonts.packages = with pkgs; [
    fira-code
    fira-mono
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
  ];

  environment.pathsToLink = [
    # "/sbin"
    "/lib"
    "/include"
    # Completions
    "/share/fish"
    "/share/bash-completion"
    "/share/zsh"
  ];

  programs.bash.enable = true;
  programs.zsh = {
    enable = true;
    promptInit = ""; # Disable default theme, we use a custom one
    enableCompletion = false;
    enableBashCompletion = false;
  };

  programs.tmux = {
    enable = true;
    enableFzf = true;
    enableMouse = true;
    enableSensible = true;
  };
}
