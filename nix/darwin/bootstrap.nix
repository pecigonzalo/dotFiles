{ config, pkgs, lib, ... }:
{
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.nix.configureBuildUsers = true;
  nix.trustedUsers = [
    "@admin"
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];
  environment.loginShell = "${pkgs.zsh}/bin/zsh -l";
  environment.variables.SHELL = "${pkgs.zsh}/bin/zsh";

  nix = {
    useDaemon = true;

    extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin

      auto-optimise-store = true
      keep-outputs = true
      keep-derivations = true
    '';
  };
}
