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
        # nvim-treesitter
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
