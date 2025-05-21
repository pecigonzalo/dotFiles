{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.direnv;
  homeDir = config.home.homeDirectory;
in
{
  options.my.direnv = {
    enable = mkEnableOption "DirEnv tools";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;

      config = {
        global = {
          strict_env = true;
        };

        whitelist = {
          prefix = [
            "${homeDir}/Workspace/"
          ];
        };
      };

      stdlib = ''
        layout_poetry() {
          if [[ ! -f pyproject.toml ]]; then
            log_error 'No pyproject.toml found. Use `poetry new` or `poetry init` to create one first.'
            exit 2
          fi

          # Create venv if it doesn't exist
          poetry env use python

          export VIRTUAL_ENV=$(poetry env info --path)
          export POETRY_ACTIVE=1
          PATH_add "$VIRTUAL_ENV/bin"
        }
      '';
    };
  };
}
