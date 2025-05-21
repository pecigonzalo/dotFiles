{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.aws;
in
{
  options.my.aws = {
    enable = mkEnableOption "AWS Tools";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      AWS_PAGER = "${pkgs.bat}/bin/bat -p --color=always -l json";
    };
    home.packages = with pkgs; [
      aws-vault
      chamber
      awscli2
      ssm-session-manager-plugin
      aws-nuke
      eksctl
      steampipe
    ];
  };
}
