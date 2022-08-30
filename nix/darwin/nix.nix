{ config, pkgs, lib, ... }:
{
  nix.configureBuildUsers = true;
  nix.settings.trusted-users = [
    "@admin"
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon = {
    enable = true;
    enableSocketListener = true;
  };

  nix = {
    useDaemon = true;
  };
}
