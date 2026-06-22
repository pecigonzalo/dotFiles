{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.gcp;
in
{
  options.my.gcp = {
    enable = mkEnableOption "GCP Tools";
  };

  config = mkIf cfg.enable {
    home = {
      file = {
        ".default-cloud-sdk-components".text = ''
          alpha
          beta
          cloud_sql_proxy
        '';
      };
      packages = with pkgs; [
        berglas
        google-cloud-sdk
      ];
      shellAliases = {
        # Google Apps CLI
        "gam" = "${config.home.homeDirectory}/bin/gam/gam";
      };
    };
  };
}
