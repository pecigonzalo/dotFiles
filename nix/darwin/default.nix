{ config, pkgs, ... }:
let
  userHome = "/Users/${config.system.primaryUser}";
in
{
  imports = [
    # Minimal config of Nix related options and shells
    ./bootstrap.nix
    ./nix.nix

    # Other nix-darwin configuration
    ./homebrew.nix
    ./system.nix
    ./spotlight.nix
    ./cachix.nix
  ];

  custom.spotlight = {
    enable = true;
    exclusions = [
      "/Library/Developer"
      "${userHome}/.bun"
      "${userHome}/.cache"
      "${userHome}/.cargo"
      "${userHome}/.gradle"
      "${userHome}/.local"
      "${userHome}/.m2"
      "${userHome}/.npm"
      "${userHome}/.pnpm-store"
      "${userHome}/.rustup"
      "${userHome}/Library/Caches"
      "${userHome}/Library/Developer"
      "${userHome}/Workspace"
      "${userHome}/dotFiles"
    ];
  };

  programs = {
    nix-index.enable = true;

    bash.enable = true;
    zsh = {
      enable = true;
      promptInit = ""; # Disable default theme, we use a custom one
      enableCompletion = false;
      enableBashCompletion = false;
    };

    tmux = {
      enable = true;
      enableFzf = true;
      enableMouse = true;
      enableSensible = true;
    };
  };

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
}
