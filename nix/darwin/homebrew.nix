{ config, lib, pkgs, ... }:
{
  environment.systemPath = [
    config.homebrew.brewPrefix
  ];
  homebrew = {
    enable = true;
    autoUpdate = false;

    cleanup = "zap";

    global.brewfile = true;
    global.noLock = true;

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
      "docker"
      "parsec"
    ];

    brews = [
      "snyk/tap/snyk"
    ];
  };
}
