{ pkgs, ... }:
{
  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm/config.lua;
  };

  programs.zsh = {
    initContent  = ''
      source "${pkgs.wezterm}/etc/profile.d/wezterm.sh"
    '';
  };
}
