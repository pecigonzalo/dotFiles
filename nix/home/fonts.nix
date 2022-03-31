{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  xdg.configFile.fontconfig = {
    source = ../../.config/fontconfig;
    recursive = true;
  };
  home.packages = with pkgs; [
    # Fonts
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "FiraMono"
      ];
    })
    fira-code
    fira-mono
  ];
}
