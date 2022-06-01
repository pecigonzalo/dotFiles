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

  environment.pathsToLink = [
    # "/sbin"
    "/lib"
    "/include"
    "/libexec"
    "/share/zsh" # Completions
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

  # https://github.com/nix-community/home-manager/issues/423
  environment.variables = {
    # TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
  };
}
