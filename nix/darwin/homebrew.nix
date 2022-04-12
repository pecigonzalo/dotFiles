{ config, ... }:
{
  environment.shellInit = ''
    eval "$(${config.homebrew.brewPrefix}/brew shellenv)"
  '';
  homebrew = {
    enable = true;
    autoUpdate = false;
    cleanup = "zap";
    global.brewfile = true;
    global.noLock = true;

    taps = [
      "fishtown-analytics/dbt"
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
    ];

    brews = [
      "fishtown-analytics/dbt/dbt" # TODO: Replace with Docker
      "snyk/tap/snyk"
    ];

    masApps = {
      # "Xcode" = 497799835;
      "Amphetamine" = 937984704;
      "Steam Link" = 1246969117;
    };
  };
}
