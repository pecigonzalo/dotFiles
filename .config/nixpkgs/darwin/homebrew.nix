{
  homebrew = {
    enable = true;
    autoUpdate = false;

    cleanup = "uninstall";
    brewPrefix = "/opt/homebrew/bin";

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
      "iann0036/iamlive"
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
      "iann0036/iamlive/iamlive"
      "snyk/tap/snyk"
    ];

    masApps = {
      # "Xcode" = 497799835;
      "Amphetamine" = 937984704;
    };
  };
}
