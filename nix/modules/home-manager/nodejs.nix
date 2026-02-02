{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.nodejs;
  neovimCfg = config.my.neovim;
  shellCfg = config.my.shell;
in
{
  options.my.nodejs = {
    enable = mkEnableOption "Node.js development environment" // {
      default = true;
    };

    package = mkOption {
      type = types.package;
      default = pkgs.nodejs;
      description = "Node.js package to use";
    };

    packageManager = mkOption {
      type = types.enum [
        "all"
        "npm"
        "yarn"
        "pnpm"
      ];
      default = "yarn";
      description = "Package manager(s) to install";
    };

    includeTypeScript = mkOption {
      type = types.bool;
      default = true;
      description = "Include TypeScript and related tools";
    };

    includeDeno = mkOption {
      type = types.bool;
      default = true;
      description = "Include Deno runtime";
    };

    includeBun = mkOption {
      type = types.bool;
      default = true;
      description = "Include Bun runtime";
    };

    includeLinters = mkOption {
      type = types.bool;
      default = true;
      description = "Include ESLint and Prettier";
    };
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        # Node.js
        cfg.package
      ]
      ++ (
        if cfg.packageManager == "all" then
          [
            yarn
            nodePackages.pnpm
          ]
        else if cfg.packageManager == "yarn" then
          [ yarn ]
        else if cfg.packageManager == "pnpm" then
          [ nodePackages.pnpm ]
        else
          [ ] # npm is included with nodejs
      )
      ++ optionals cfg.includeTypeScript [
        nodePackages.typescript
        nodePackages_latest.typescript-language-server
        vtsls
      ]
      ++ optional cfg.includeDeno deno
      ++ optional cfg.includeBun bun
      ++ optionals cfg.includeLinters [
        nodePackages_latest.eslint
        eslint_d
        nodePackages_latest.prettier
        prettierd
      ];

    # Add node/npm/yarn OMZ plugins if shell is enabled
    my.shell.omzPlugins = mkIf shellCfg.enable (
      [ { name = "node"; } ]
      ++ optional (cfg.packageManager == "npm" || cfg.packageManager == "all") { name = "npm"; }
      ++ optional (cfg.packageManager == "yarn" || cfg.packageManager == "all") { name = "yarn"; }
    );

    # Add TypeScript LSPs, ESLint, Prettier to neovim if enabled
    my.neovim.extraPackages = mkIf neovimCfg.enable (
      with pkgs;
      optionals cfg.includeTypeScript [
        nodePackages_latest.typescript-language-server
        vtsls
      ]
      ++ optionals cfg.includeLinters [
        nodePackages_latest.eslint
        eslint_d
        nodePackages_latest.prettier
        prettierd
      ]
      ++ [
        # Additional language servers
        nodePackages.vscode-json-languageserver
      ]
    );
  };
}
