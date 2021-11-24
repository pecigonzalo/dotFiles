{ pkgs, lib, ... }:
{
  imports = [
    # Minimal config of Nix related options and shells
    ./bootstrap.nix

    # Other nix-darwin configuration
    ./homebrew.nix
    ./defaults.nix
  ];

  programs.nix-index.enable = true;
  services = {
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
