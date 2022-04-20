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
      if !exists('g:vscode')
        packadd ${plugin.pname}
        ${config}
      endif
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
      ] ++ mapper [
        {
          plugin = dracula-vim;
          type = "viml";
          config = ''
            " NERD Tree auto-open
            autocmd StdinReadPre * let s:std_in=1
            autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
            " Open NERD Tree with CTRL+\
            map <C-\> :NERDTreeToggle<CR>
            " NERD Tree auto-close
            autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
            " NERD Tree config
            let NERDTreeShowHidden=1
          '';
        }
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

        # Tree explorer
        nerdtree
      ];

      coc = {
        enable = false;
      };

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
