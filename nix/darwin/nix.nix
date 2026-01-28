{ ... }:
{
  nix.settings.trusted-users = [
    "@admin"
  ];

  nix = {
    enable = false;
    daemonIOLowPriority = true;
  };
}
