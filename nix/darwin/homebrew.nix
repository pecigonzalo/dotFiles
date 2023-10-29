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
      # Security
      "1password"
      "wireshark"
      "tailscale"
      # Browsers
      "microsoft-edge"
      "firefox"
      "google-chrome"
      # Remoting
      "microsoft-remote-desktop"
      "parsec"
      # Communication
      "slack"
      "discord"
      # macOS Tooling
      "dozer"
      "hammerspoon"
      "kap"
      "karabiner-elements"
      "keycastr"
      "scroll-reverser"
      # Notes
      "obsidian"
      "notion"
      # Media
      "spotify"
      # Editor
      "visual-studio-code"
    ];
  };
}
