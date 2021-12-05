{ config, pkgs, lib, ... }:
{
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.nix.configureBuildUsers = true;

  nix = {
    package = pkgs.nix;

    buildCores = 0;
    maxJobs = "auto";

    useDaemon = true;
    daemonIONice = true;
    daemonNiceLevel = 19;

    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes

      extra-platforms = aarch64-darwin x86_64-darwin
    '';
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];
}
