{ config, ... }:
{
  services.cachix-agent = {
    enable = true;
    name = config.networking.hostName;
    credentialsFile = "/etc/cachix-agent.token";
  };
}
