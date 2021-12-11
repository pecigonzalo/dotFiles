{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # Fonts
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    fira-code
    fira-mono
  ];
}
