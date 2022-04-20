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
        editorconfig-nvim
      ] ++ mapper [
        vim-lsp
        nvim-lspconfig

        vim-nix
        {
          plugin = nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars);
          type = "lua";
          config = builtins.readFile ./neovim/treesitter.lua;
        }
        async-vim
        asyncomplete-lsp-vim
        asyncomplete-vim

        # Treexplorer
        {
          plugin = nerdtree;
          type = "lua";
          config = builtins.readFile ./neovim/nerdtree.lua;
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
      ];

      extraConfig = builtins.readFile ./neovim/.vimrc;
    };
}
