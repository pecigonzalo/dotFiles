{
  homebrew = {
    enable = true;
    autoUpdate = false;

    cleanup = "none";
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
      "1password-cli"
      "aws-vault"
      "dozer"
      "font-fira-code-nerd-font"
      "font-fira-code"
      "hammerspoon"
      "kap"
      "karabiner-elements"
      "keycastr"
      "microsoft-remote-desktop"
      "scroll-reverser"
      "signal"
      "snowflake-snowsql"
      "wireshark"
      # "intellij-idea-ce"
    ];

    brews = [
      "dbt" # TODO: Replace with Docker
      "dive"
      "git-filter-repo"
      "iamlive"
      "snyk"
      "sshuttle"
      "teleport"
    ];

    masApps = {
      # "Xcode" = 497799835;
      "Amphetamine" = 937984704;
    };
  };
}
