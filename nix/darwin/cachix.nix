{ config, ... }:
{
  services.cachix-agent = {
    enable = false; # Something is not working with it
  };
}
