{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      dracula-vim
      nerdtree
    ];

    coc = {
      enable = true;
    };

    extraPackages = with pkgs; [
      gopls
      shfmt
      rnix-lsp
    ];

    extraConfig = builtins.readFile ../../.vimrc;
  };
}
