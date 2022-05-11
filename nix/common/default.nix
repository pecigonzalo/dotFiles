{ config, pkgs, lib, ... }:
{
  nix = {
    package = pkgs.nix;

    extraOptions = "experimental-features = nix-command flakes";

    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };

    binaryCaches = [
      "https://cache.nixos.org/"
      "https://pecigonzalo.cachix.org"
    ];

    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "pecigonzalo.cachix.org-1:KIojNF24XoRSCGsQu+fwzY/fJhEtANoxKB1Tu45hid8="
    ];
  };
}
