{ config, pkgs, lib, ... }:
{
  users.nix.configureBuildUsers = true;
  nix.trustedUsers = [
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
