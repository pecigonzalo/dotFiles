{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
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
