{
  config,
  ...
}:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  dotFilesDir = "${config.home.homeDirectory}/dotFiles";
in
{
  programs.wezterm = {
    enable = true;
  };

  # Symlink wezterm config to dotfiles for dynamic reloading
  home.file.".config/wezterm/wezterm.lua".source =
    mkOutOfStoreSymlink "${dotFilesDir}/nix/home/wezterm/config.lua";
}
