{ config, pkgs, ... }:
{
  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm/config.lua;
  };

  programs.zsh = {
    initExtra = ''
      source "${pkgs.wezterm}/etc/profile.d/wezterm.sh"
    '';
  };

  programs.fish = {
    enable = true;
  };
}
