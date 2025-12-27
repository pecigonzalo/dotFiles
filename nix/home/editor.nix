{
  config,
  pkgs,
  lib,
  ...
}:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;

  homeDir = config.home.homeDirectory;
  dotFilesDir = "${homeDir}/dotFiles";
in
{
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
    source = mkOutOfStoreSymlink "${dotFilesDir}/nvim/lua";
    recursive = true;
  };
  # Link lock file
  xdg.configFile."nvim/lazy-lock.json" = {
    source = mkOutOfStoreSymlink "${dotFilesDir}/nvim/lazy-lock.json";
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = false;
    withPython3 = true;

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

    extraPackages = with pkgs; [
      # NodeJS
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
      nixfmt-rfc-style

      # LSPs
      gopls
      helm-ls
      jdt-language-server
      # kotlin-language-server
      pyright
      nodePackages_latest.eslint
      eslint_d
      nodePackages_latest.prettier
      prettierd
      ruff
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server
      dockerfile-language-server
      nodePackages.bash-language-server
      nodePackages_latest.typescript-language-server
      lua-language-server
      nixd
      terraform-ls
    ];
  };
}
