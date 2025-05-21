{
  config,
  pkgs,
  lib,
  ...
}:
{
  nix = {
    package = pkgs.nix;

    extraOptions = "experimental-features = nix-command flakes";

    gc = {
      automatic = false;
      options = "--delete-older-than 3d";
    };

    settings = {
      substituters = [
        "https://cache.nixos.org/"
        "https://pecigonzalo.cachix.org"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "pecigonzalo.cachix.org-1:KIojNF24XoRSCGsQu+fwzY/fJhEtANoxKB1Tu45hid8="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];

      # TODO: https://github.com/NixOS/nix/issues/7273
      auto-optimise-store = false;
    };
  };
}
