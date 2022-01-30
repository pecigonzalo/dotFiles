{ config, pkgs, ... }:
let
  homedir = config.home.homeDirectory;
in
{
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
          "${homedir}/Workspace/"
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
}
