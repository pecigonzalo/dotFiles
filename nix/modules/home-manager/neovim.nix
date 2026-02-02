{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.neovim;
  pathsCfg = config.my.paths;
in
{
  options.my.neovim = {
    enable = mkEnableOption "Neovim text editor" // {
      default = true;
    };

    withNodeJs = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Node.js support in Neovim";
    };

    withPython3 = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Python 3 support in Neovim";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Additional packages to make available to Neovim";
    };
  };

  config = mkIf cfg.enable {
    editorconfig = {
      enable = true;
      settings = {
        "*" = {
          indent_size = 2;
          indent_style = "space";
          end_of_line = "lf";
          trim_trailing_whitespace = true;
          insert_final_newline = true;
        };
        "*.md" = {
          trim_trailing_whitespace = false;
        };
        "*.{fs,cs}" = {
          indent_size = 4;
        };
        "*.{csproj,vcxproj,vcxproj.user}" = {
          indent_style = "space";
          indent_size = 2;
        };
        "*.{yml,yaml}" = {
          indent_style = "space";
          indent_size = 2;
        };
        "{Makefile,*.mak}" = {
          indent_style = "tab";
        };
        "*.py" = {
          indent_style = "space";
          indent_size = 4;
          trim_trailing_spaces = true;
        };
      };
    };

    # Link NVIM lua config
    xdg.configFile."nvim/lua" = {
      source = pathsCfg.mkDotFileLink "nvim/lua";
      recursive = true;
    };
    # Link lock file
    xdg.configFile."nvim/lazy-lock.json" = {
      source = pathsCfg.mkDotFileLink "nvim/lazy-lock.json";
      recursive = true;
    };

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = cfg.withNodeJs;
      withPython3 = cfg.withPython3;

      plugins = with pkgs.vimPlugins; [
        {
          plugin = lazy-nvim;
          type = "lua";
          config = ''
            require("config")
            require("config.lazy")
          '';
        }
      ];

      extraPackages =
        with pkgs;
        [
          # NodeJS (for plugins)
          nodejs

          # Treesitter
          cmake
          gcc
          tree-sitter

          # Formatters and Linters
          selene
          shfmt
          nufmt
          stylua

          # LSPs
          jdt-language-server
          # kotlin-language-server
          nodePackages.vscode-langservers-extracted
          nodePackages.yaml-language-server
          dockerfile-language-server
          nodePackages.bash-language-server
          lua-language-server
        ]
        ++ cfg.extraPackages;
    };
  };
}
