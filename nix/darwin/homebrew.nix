{
  config,
  lib,
  pkgs,
  ...
}:
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

    brews = [
      # AI
      "anomalyco/tap/opencode"
    ];

    casks = [
      # Security
      "1password"
      "tailscale-app"
      # Browsers
      "microsoft-edge"
      "firefox"
      # "zen-browser"
      # "google-chrome"
      # Remoting
      "windows-app"
      "parsec"
      "moonlight"
      # Communication
      # "slack"
      # "discord"
      # macOS Tooling
      "jordanbaird-ice"
      "hammerspoon"
      "kap"
      "karabiner-elements"
      "keycastr"
      "scroll-reverser"
      # Notes
      # "obsidian"
      # "notion"
      # Media
      "spotify"
      # Editor
      "visual-studio-code"
      # Files
      # "google-drive"
    ];
  };
}
