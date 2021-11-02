{ config, pkgs, lib, ... }:
let
  user = "gonzalopeci";
  home = builtins.getEnv "HOME";
  nix-darwin-config = "${home}/.config/nixpkgs/darwin/configuration.nix";
  home-manager-config = import "${home}/dotFiles/.config/nixpkgs/home.nix";
in
{
  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = nix-darwin-config;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  imports = [
    <home-manager/nix-darwin>
    ./homebrew.nix
  ];

  system.defaults = {
    dock = {
      autohide = true;
      orientation = "left";
      tilesize = 45;
      show-recents = true;
    };
    NSGlobalDomain = {
      KeyRepeat = 2;
      InitialKeyRepeat = 15;
    };
    finder = {
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
    };
  };

  nix =
    {
      package = pkgs.nix;
      useDaemon = false;
      buildCores = 6;
      maxJobs = 6;
      extraOptions = ''
        auto-optimise-store = true

        system = aarch64-darwin
        extra-platforms = aarch64-darwin x86_64-darwin
      '';
    };

  nixpkgs = {
    system = "aarch64-darwin";

    config = {
      allowUnfree = true;
      allowBroken = false;
      allowInsecure = false;
      allowUnsupportedSystem = true;
    };

    # Dynamically generate a list of overlays
    overlays =
      let path = "${home}/dotFiles/.config/nixpkgs/overlays"; in
      with builtins;
      map (n: import (path + ("/" + n)))
        (filter
          (n: match ".*\\.nix" n != null ||
            pathExists (path + ("/" + n + "/default.nix")))
          (attrNames (readDir path)));
  };

  programs.nix-index.enable = true;
  services = {
    nix-daemon.enable = false;
    lorri = {
      enable = true;
      logFile = "/tmp/lorri.log";
    };
  };

  environment.pathsToLink = [
    # "/sbin"
    "/lib"
    "/include"
    "/libexec"
  ];

  environment.shells = [ pkgs.zsh ];
  users = {
    users.gonzalopeci = {
      name = user;
      home = "/Users/${user}";
      shell = pkgs.zsh;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = false;
    verbose = false;
    users.gonzalopeci = home-manager-config;
  };

  programs.bash.enable = true;
  programs.zsh = {
    enable = true;
    promptInit = ""; # Disable default theme, we use a custom one
    enableCompletion = false;
    enableBashCompletion = false;
  };

  environment.systemPackages = with pkgs; [
    # Nix
    nixpkgs-fmt
    rnix-lsp

    # Common
    htop
    nano
    nmap
    ngrep
    neofetch
    netcat-gnu
    wget
    curl
    which
    ldns
    dnsutils
    unixtools.watch

    # Build tools
    pkgconfig
    autoconf
    coreutils
    findutils
    diffutils
    binutils
    gnumake
    gnugrep
    gnused
    gnutar
    gnupg
    gawk
  ];
}
