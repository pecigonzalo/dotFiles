{ config, pkgs, lib, ... }:
{
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  users.nix.configureBuildUsers = true;

  nix =
    {
      package = pkgs.nixUnstable;
      useDaemon = true;
      buildCores = 0;
      maxJobs = "auto";
      extraOptions = ''
        auto-optimise-store = true
        experimental-features = nix-command flakes

        extra-platforms = aarch64-darwin x86_64-darwin
      '';
    };

  # Dynamically generate a list of overlays
  nixpkgs.overlays =
      let path = ../overlays; in
      with builtins;
      map (n: import (path + ("/" + n)))
        (filter
          (n: match ".*\\.nix" n != null ||
            pathExists (path + ("/" + n + "/default.nix")))
          (attrNames (readDir path)));

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];
}
