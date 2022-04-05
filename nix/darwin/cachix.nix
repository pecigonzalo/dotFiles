{ config, ... }:
{
  services.cachix-agent = {
    enable = true;
    name = config.networking.hostName;
    # credentialsFile = "${config.home.homeDirectory}/.cachix.agent";
  };
}
