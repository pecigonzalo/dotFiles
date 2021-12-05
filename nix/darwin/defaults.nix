{ ... }:
{
  system.defaults.dock = {
    autohide = true;
    orientation = "left";
    tilesize = 45;
    show-recents = true;
  };

  system.defaults.NSGlobalDomain = {
    KeyRepeat = 2;
    InitialKeyRepeat = 15;
  };

  system.defaults.finder = {
    AppleShowAllExtensions = true;
    _FXShowPosixPathInTitle = true;
  };
}
