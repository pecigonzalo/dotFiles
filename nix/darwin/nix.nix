{ config, pkgs, lib, ... }:
{
  nix.settings.trusted-users = [
    "@admin"
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon = {
    enable = true;
  };

  nix = {
    useDaemon = true;
    daemonIOLowPriority = true;
    configureBuildUsers = true;
  };
}
