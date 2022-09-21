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
      "homebrew/cask"
      "homebrew/core"
      "snyk/tap"
    ];

    casks = [
      "dozer"
      "hammerspoon"
      "kap"
      "karabiner-elements"
      "keycastr"
      "microsoft-remote-desktop"
      "scroll-reverser"
      "signal"
      "snowflake-snowsql"
      "wireshark"
      "kitty"
      "parsec"
    ];

    brews = [
      "snyk/tap/snyk"
    ];
  };
}
