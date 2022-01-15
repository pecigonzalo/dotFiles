{ pkgs, lib, ... }:
{
  home.sessionVariables = {
    # AWS
    AWS_PAGER = "bat -p --color=always -l json";
  };
  home.packages = with pkgs; [
    # AWS
    aws-vault
    chamber
    awscli2
    # ssm-session-manager-plugin
    aws-nuke
    awless
    eksctl
  ];
}
