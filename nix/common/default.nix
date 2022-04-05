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
      "https://pecigonzalo.cachix.org"
    ];

    binaryCachePublicKeys = [
      "pecigonzalo.cachix.org-1:KIojNF24XoRSCGsQu+fwzY/fJhEtANoxKB1Tu45hid8="
    ];
  };
}
