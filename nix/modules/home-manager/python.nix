{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.python;
  neovimCfg = config.my.neovim;
  shellCfg = config.my.shell;

  tomlFormat = pkgs.formats.toml { };

  minimumPackageAge = "P${toString cfg.minimumPackageAgeDays}D";

  packageManagerPackages =
    if cfg.packageManager == "all" then
      [
        pkgs.pipenv
        pkgs.rye
        pkgs.uv
      ]
    else if cfg.packageManager == "pip" then
      [ ] # pip is included with python
    else if cfg.packageManager == "poetry" then
      [ ] # handled separately with config
    else if cfg.packageManager == "pipenv" then
      [ pkgs.pipenv ]
    else if cfg.packageManager == "rye" then
      [ pkgs.rye ]
    else if cfg.packageManager == "uv" then
      [ pkgs.uv ]
    else
      [ ];
in
{
  options.my.python = {
    enable = mkEnableOption "Python development environment" // {
      default = true;
    };

    version = mkOption {
      type = types.str;
      default = "python3";
      description = "Python version to use (e.g., python3, python311)";
    };

    packageManager = mkOption {
      type = types.enum [
        "all"
        "pip"
        "poetry"
        "pipenv"
        "rye"
        "uv"
      ];
      default = "all";
      description = "Python package manager(s) to install";
    };

    includeLinters = mkOption {
      type = types.bool;
      default = true;
      description = "Include linters and formatters (ruff)";
    };

    minimumPackageAgeDays = mkOption {
      type = types.ints.positive;
      default = 1;
      description = "Minimum Python package upload age to configure user-wide, in days";
    };
  };

  config = mkIf cfg.enable {
    home = {
      sessionVariables = {
        # Disable virtualenv in prompt autoconfig
        VIRTUAL_ENV_DISABLE_PROMPT = 1;
        # Pipenv - create venv in project directory
        PIPENV_VENV_IN_PROJECT = "true";
      };

      file.".numpy-site.cfg".text = ''
        [ALL]
        library_dirs = ${config.my.paths.homeDir}/.nix-profile/lib
        include_dirs = ${config.my.paths.homeDir}/.nix-profile/include

        [DEFAULT]
        library_dirs = ${config.my.paths.homeDir}/.nix-profile/lib
        include_dirs = ${config.my.paths.homeDir}/.nix-profile/include
      '';

      packages =
        with pkgs;
        [
          # Python interpreter
          (if cfg.version == "python3" then python-with-env else pkgs.${cfg.version})
        ]
        ++ packageManagerPackages
        ++ optionals cfg.includeLinters [ ruff ];
    };

    xdg.configFile = {
      "uv/uv.toml".source = tomlFormat.generate "uv.toml" {
        exclude-newer = minimumPackageAge;
        pip.exclude-newer = minimumPackageAge;
      };

      "pypoetry/config.toml" = mkIf (cfg.packageManager == "poetry" || cfg.packageManager == "all") {
        source = tomlFormat.generate "config.toml" {
          virtualenvs = {
            in-project = true;
          };
        };
      };
    };

    # Add python/pip OMZ plugins if shell is enabled
    my.shell.omzPlugins = mkIf shellCfg.enable [
      { name = "python"; }
      { name = "pip"; }
    ];

    # Add pyright and ruff to neovim if enabled
    my.neovim.extraPackages = mkIf neovimCfg.enable (
      with pkgs; [ pyright ] ++ optionals cfg.includeLinters [ ruff ]
    );
  };
}
