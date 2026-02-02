{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.nix-tools;
  neovimCfg = config.my.neovim;
in
{
  options.my.nix-tools = {
    enable = mkEnableOption "Nix development tools" // {
      default = true;
    };

    includeLSP = mkOption {
      type = types.bool;
      default = true;
      description = "Include nixd language server";
    };

    includeFormatter = mkOption {
      type = types.bool;
      default = true;
      description = "Include nixfmt formatter";
    };

    includeCachix = mkOption {
      type = types.bool;
      default = true;
      description = "Include cachix for binary caching";
    };

    includeAgenix = mkOption {
      type = types.bool;
      default = true;
      description = "Include agenix for secrets management";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [ ]
      ++ optional cfg.includeLSP nixd
      ++ optional cfg.includeFormatter nixfmt
      ++ optional cfg.includeCachix cachix
      ++ optional cfg.includeAgenix inputs.agenix.packages.${pkgs.stdenv.system}.agenix;

    # Add nixd and nixfmt to neovim if enabled
    my.neovim.extraPackages = mkIf neovimCfg.enable (
      with pkgs; optionals cfg.includeLSP [ nixd ] ++ optionals cfg.includeFormatter [ nixfmt ]
    );
  };
}
