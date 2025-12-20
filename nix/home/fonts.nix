{ pkgs, ... }:
{
  xdg.configFile.fontconfig = {
    source = ../../.config/fontconfig;
    recursive = true;
  };
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    fira-code
    fira-mono
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
  ];
}
