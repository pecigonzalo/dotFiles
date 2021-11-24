{ pkgs, ... }:
let
  home = builtins.getEnv "HOME";
in
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

    extraConfig = builtins.readFile "${home}/dotFiles/.vimrc";
  };
}
