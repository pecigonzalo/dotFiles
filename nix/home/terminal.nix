{ config, ... }:
let
  inherit (config.my.paths) mkDotFileLink;
in
{
  programs.wezterm = {
    enable = true;
  };

  # Symlink wezterm config to dotfiles for dynamic reloading
  xdg.configFile."wezterm/wezterm.lua".source = mkDotFileLink "config/wezterm/config.lua";
}
