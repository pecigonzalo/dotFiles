{ pkgs, lib, ... }:
let
  mapper = map (x:
    if (x ? plugin) then
      nonVSCodePlugin
        {
          plugin = x.plugin;
          type = x.type;
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
  programs.neovim =
    {
      enable = true;
      viAlias = true;
      vimAlias = true;
      withNodeJs = true;
      withPython3 = true;

      plugins = with pkgs.vimPlugins; [
        vim-commentary
        dracula-vim
      ] ++ mapper [
        editorconfig-nvim
        # Treesitter
        {
          plugin = nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars);
          type = "lua";
          config = builtins.readFile ./neovim/treesitter.lua;
        }
        # LSP
        nvim-lspconfig
        cmp-buffer
        cmp-path
        cmp-cmdline
        cmp-vsnip
        vim-vsnip
        cmp-nvim-lsp
        {
          plugin = nvim-cmp;
          type = "lua";
          config = builtins.readFile ./neovim/cmp.lua;
        }

        vim-visual-multi # Multiple cursors

        vim-nix

        # Treexplorer
        nvim-web-devicons
        {
          plugin = nvim-tree-lua;
          type = "lua";
          config = builtins.readFile ./neovim/explorer.lua;
        }
      ];

      extraPackages = with pkgs; [
        gcc
        tree-sitter

        # LSPs
        gopls
        shfmt
        rnix-lsp
        terraform-ls
        kotlin-language-server
      ];

      extraConfig = builtins.readFile ./neovim/.vimrc;
    };
}
