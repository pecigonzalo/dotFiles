{ config, pkgs, lib, ... }:
{
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];
  environment.loginShell = "${pkgs.zsh}/bin/zsh -l";
  environment.variables.SHELL = "${pkgs.zsh}/bin/zsh";

  nix = {
    extraOptions = ''
      extra-platforms = aarch64-darwin x86_64-darwin

      keep-outputs = true
      keep-derivations = true
    '';
  };
}
