{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.dotnet;
  neovimCfg = config.my.neovim;
  shellCfg = config.my.shell;
in
{
  options.my.dotnet = {
    enable = mkEnableOption ".NET development environment" // {
      default = true;
    };

    package = mkOption {
      type = types.package;
      default = pkgs.dotnet-sdk;
      description = ".NET SDK package to use";
    };

    includeTools = mkOption {
      type = types.bool;
      default = true;
      description = "Include .NET development tools (fsautocomplete, fantomas)";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [
      cfg.package
    ]
    ++ optionals cfg.includeTools [
      pkgs.fsautocomplete
      pkgs.fantomas
    ];

    # Add dotnet OMZ plugin if shell is enabled
    my.shell.omzPlugins = mkIf shellCfg.enable [
      { name = "dotnet"; }
    ];

    # Add LSP and formatter to neovim if enabled
    my.neovim.extraPackages = mkIf neovimCfg.enable (
      optionals cfg.includeTools [
        pkgs.fsautocomplete
        pkgs.fantomas
      ]
    );
  };
}
