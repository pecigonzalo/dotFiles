{ pkgs, ... }:
{
  system.defaults.dock = {
    orientation = "left";
    autohide = true;
    tilesize = 64;
    show-recents = true;

    mineffect = "genie";
    minimize-to-application = true;

    mru-spaces = false;
  };

  system.defaults.spaces = {
    spans-displays = false;
  };

  system.defaults.NSGlobalDomain = {
    InitialKeyRepeat = 15;
    KeyRepeat = 2;

    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticDashSubstitutionEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    NSAutomaticQuoteSubstitutionEnabled = false;
    NSAutomaticSpellingCorrectionEnabled = true;

    NSScrollAnimationEnabled = true;

    AppleShowScrollBars = "Automatic";

    _HIHideMenuBar = false;

    AppleShowAllExtensions = true;
  };

  system.defaults.finder = {
    AppleShowAllExtensions = true;
    _FXShowPosixPathInTitle = true;
    FXEnableExtensionChangeWarning = false;
  };

  system.defaults.trackpad = {
    ActuationStrength = 1;
    Clicking  = true;
    FirstClickThreshold = 2;
    SecondClickThreshold = 2;
    TrackpadThreeFingerDrag = false;
    TrackpadRightClick      = true;
  };

  system.activationScripts.postActivation.text = ''
    # Stop iTunes from responding to the keyboard media keys
    launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2>/dev/null
  '';
}
