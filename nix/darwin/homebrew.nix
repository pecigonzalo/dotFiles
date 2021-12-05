{ config, lib, pkgs, ... }:
let
  brewPrefix = "/opt/homebrew/bin";
in
{
  environment.shellInit = ''
    eval "$(${brewPrefix}/brew shellenv)"
  '';
  homebrew = {
    enable = true;
    autoUpdate = true;

    cleanup = "zap";
    brewPrefix = brewPrefix;

    global.brewfile = true;
    global.noLock = true;

    taps = [
      "aws/tap"
      "fishtown-analytics/dbt"
      "hashicorp/tap"
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/cask-fonts"
      "homebrew/core"
      "homebrew/services"
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
    ];

    brews = [
      "fishtown-analytics/dbt/dbt" # TODO: Replace with Docker
      "snyk/tap/snyk"
    ];

    masApps = {
      # "Xcode" = 497799835;
      "Amphetamine" = 937984704;
    };
  };
}
