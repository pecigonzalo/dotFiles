{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.zig;
  neovimCfg = config.my.neovim;
in
{
  options.my.zig = {
    enable = mkEnableOption "Zig development environment" // {
      default = true;
    };

    package = mkOption {
      type = types.package;
      default = pkgs.zig;
      description = "Zig compiler/toolchain package to use";
    };

    includeLSP = mkOption {
      type = types.bool;
      default = true;
      description = "Include zls language server";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ]
    ++ optional cfg.includeLSP pkgs.zls;

    my.neovim.extraPackages = mkIf neovimCfg.enable (
      [
        cfg.package
      ]
      ++ optional cfg.includeLSP pkgs.zls
    );
  };
}
