{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "davyjones";
  home.homeDirectory = "/home/davyjones";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.03";

  home.packages = with pkgs; [
    rnix-lsp

    htop
    tree

    tldr
    exa
    bat
    fzf
    fd
    httpie

    vagrant
    packer
    terraform

    starship

    yarn
    yq
  ];
}
