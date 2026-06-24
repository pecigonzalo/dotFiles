{
  config,
  lib,
  pkgs,
  ...
}:
let
  brewPrefix = if pkgs.stdenv.hostPlatform.isAarch64 then "/opt/homebrew" else "/usr/local";
in
{
  environment.systemPath = lib.optionals config.homebrew.enable [
    "${brewPrefix}/bin"
  ];
  homebrew = {
    enable = lib.mkDefault true;
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
      "obsidian"
      # "notion"
      # Media
      "spotify"
      # Editor
      "visual-studio-code"
      # Files
      "google-drive"
    ];
  };
}
