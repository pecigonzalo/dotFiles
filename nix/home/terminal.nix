{ pkgs, ... }:
{
  programs.wezterm = {
    enable = true;
    extraConfig = builtins.readFile ./wezterm/config.lua;
  };
}
