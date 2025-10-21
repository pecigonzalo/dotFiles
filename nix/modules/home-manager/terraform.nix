{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.terraform;
in
{
  options.my.terraform = {
    enable = mkEnableOption "Terraform";
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      "tf" = "terraform";
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
      tfsec
      # nodePackages.cdktf-cli
    ];
  };
}
