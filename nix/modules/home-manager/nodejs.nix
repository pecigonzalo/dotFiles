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

  minimumReleaseAgeDays = cfg.minimumReleaseAgeDays;
  minimumReleaseAgeMinutes = minimumReleaseAgeDays * 24 * 60;
  minimumReleaseAgeSeconds = minimumReleaseAgeMinutes * 60;
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

    minimumReleaseAgeDays = mkOption {
      type = types.ints.positive;
      default = 1;
      description = "Minimum npm package release age to configure user-wide, in days";
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
            pnpm
          ]
        else if cfg.packageManager == "yarn" then
          [ yarn ]
        else if cfg.packageManager == "pnpm" then
          [ pnpm ]
        else
          [ ] # npm is included with nodejs
      )
      ++ optionals cfg.includeTypeScript [
        typescript
        typescript-language-server
        svelte-language-server
        vtsls
      ]
      ++ optional cfg.includeDeno deno
      ++ optional cfg.includeBun bun
      ++ optionals cfg.includeLinters [
        eslint
        eslint_d
        prettier
        prettierd
      ];

    home.file = {
      # Shared by npm and Deno (2.8+) for npm registry installs.
      ".npmrc".text = ''
        min-release-age=${toString minimumReleaseAgeDays}
      '';

      ".yarnrc.yml".text = ''
        npmMinimalAgeGate: ${toString minimumReleaseAgeMinutes}
      '';

      ".bunfig.toml".text = ''
        [install]
        minimumReleaseAge = ${toString minimumReleaseAgeSeconds}
      '';
    };

    xdg.configFile."pnpm/config.yaml".text = ''
      minimumReleaseAge: ${toString minimumReleaseAgeMinutes}
    '';

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
        typescript-language-server
        svelte-language-server
        vtsls
      ]
      ++ optionals cfg.includeLinters [
        eslint
        eslint_d
        prettier
        prettierd
      ]
      ++ [
        # Additional language servers
        vscode-json-languageserver
      ]
    );
  };
}
