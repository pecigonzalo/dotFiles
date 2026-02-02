{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.golang;
  neovimCfg = config.my.neovim;
  shellCfg = config.my.shell;
  pathsCfg = config.my.paths;
in
{
  options.my.golang = {
    enable = mkEnableOption "Go development environment" // {
      default = true;
    };

    package = mkOption {
      type = types.package;
      default = pkgs.go;
      description = "Go package to use";
    };

    includeTools = mkOption {
      type = types.bool;
      default = true;
      description = "Include Go development tools (golangci-lint, mockery, etc.)";
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      # GOPATH using workspace directory
      GOPATH = "${pathsCfg.workspaceDir}/go";
    };

    home.sessionPath = [
      "${pathsCfg.workspaceDir}/go/bin"
    ];

    home.packages =
      with pkgs;
      [
        # Go
        cfg.package
        gopls
      ]
      ++ optionals cfg.includeTools [
        ginkgo
        go-mockery
        golangci-lint
        gomodifytags
        goreleaser
        gotools
        iferr
        impl
        reftools
        gomplate
      ];

    # Add golang OMZ plugin if shell is enabled
    my.shell.omzPlugins = mkIf shellCfg.enable [
      { name = "golang"; }
    ];

    # Add gopls to neovim if enabled
    my.neovim.extraPackages = mkIf neovimCfg.enable [
      pkgs.gopls
    ];
  };
}
