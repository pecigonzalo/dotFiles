{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.my.terraform;
  isSillicon = pkgs.stdenv.hostPlatform.isDarwin
    && pkgs.stdenv.hostPlatform.isAarch64;
in
{
  options.my.terraform = {
    enable = mkEnableOption "Terraform";
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      "tf" = "terraform";
    };
    home.sessionVariables = mkIf isSillicon {
      # TODO: REMOVE ME
      GODEBUG = "asyncpreemptoff=1";
    };
    home.file.".terraformrc".text = ''
       plugin_cache_dir   = "${config.xdg.cacheHome}/terraform/plugin-cache"
       disable_checkpoint = true
    '';
    home.packages = with pkgs; [
      terraform
      terraform-ls
      terraform-docs
      tflint
      nodePackages.cdktf-cli
    ];
  };
}
