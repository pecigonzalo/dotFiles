{ config, pkgs, lib, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;

  homeDir = config.home.homeDirectory;
  dotFilesDir = "${homeDir}/dotFiles";

  mapper = map (x:
    if (x ? plugin) then
      nonVSCodePlugin
        {
          plugin = x.plugin;
          type = if x ? type then x.type else "lua";
          config = x.config;
        }
    else
      nonVSCodePlugin {
        plugin = x;
      }
  );
  nonVSCodePlugin = { plugin, type ? "lua", config ? "" }: {
    plugin = plugin;
    optional = true;
    type = type;
    config = ''
      if not vim.g.vscode then
        vim.cmd('packadd ${plugin.pname}')
        ${config}
      end
    '';
  };
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
        max_line_length = 80;
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

  programs.neovim =
    {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;

      plugins = with pkgs.vimPlugins; [
        {
          plugin = lazy-nvim;
          type = "lua";
          config = ''
            require("core")

            require("lazy").setup({ { import = "plugins" } }, {
              install = {
                colorscheme = { "dracula" },
              },
              checker = {
                enabled = true,
                notify = false,
              },
              change_detection = {
                notify = false,
              },
            })
          '';
        }


      extraPackages = with pkgs; [
        gcc
        tree-sitter

        # Formatters and Linters
        selene
        shfmt
        stylua

        # LSPs
        ansible-language-server
        gopls
        jdt-language-server
        kotlin-language-server
        nodePackages.prettier
        nodePackages.pyright
        nodePackages.vscode-langservers-extracted
        nodePackages.yaml-language-server
        nodePackages.dockerfile-language-server-nodejs
        nodePackages.bash-language-server
        rnix-lsp
        sumneko-lua-language-server
        terraform-ls
      ];
    };
}

