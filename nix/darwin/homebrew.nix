{ config, lib, pkgs, ... }:
{
  environment.systemPath = [
    config.homebrew.brewPrefix
  ];
  homebrew = {
    enable = true;
    onActivation = {
      upgrade = true;
      autoUpdate = true;
      cleanup = "zap";
    };
    global = {
      autoUpdate = false;
      brewfile = true;
    };

    taps = [
      "homebrew/bundle"
    ];

    casks = [
      "dozer"
      "hammerspoon"
      "kap"
      "karabiner-elements"
      "keycastr"
      "microsoft-remote-desktop"
      "scroll-reverser"
      "snowflake-snowsql"
      "wireshark"
      "parsec"
      "obsidian"
      "tailscale"
      "visual-studio-code"
      "intellij-idea"
      "spotify"
    ];
  };
}
