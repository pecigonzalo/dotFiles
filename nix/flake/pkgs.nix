{
  inputs,
  nixpkgs,
}:
let
  inherit (nixpkgs.lib) attrValues;

  namedOverlays = attrValues {
    stable = _final: prev: {
      pkgs-stable = import inputs.nixpkgs-stable {
        inherit (prev.stdenv) system;
        inherit (nixpkgsConfig) config;
      };
    };

    packages = import ../pkgs;
  };

  dynamicOverlays =
    let
      path = ../overlays;
    in
    with builtins;
    map (overlay: import (path + ("/" + overlay))) (
      filter (
        overlay: match ".*\\.nix" overlay != null || pathExists (path + ("/" + overlay + "/default.nix"))
      ) (attrNames (readDir path))
    );

  nixpkgsConfig = {
    config = {
      allowUnfree = true;
      allowInsecure = false;
      allowUnsupportedSystem = true;
      # NOTE: Fixes unfree problem, remove when
      # https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _pkg: true;
      allowBroken = false;
    };
    # Dynamic list of overlays
    overlays = namedOverlays ++ dynamicOverlays;
  };

  pkgsFor =
    system:
    import nixpkgs {
      inherit system;
      inherit (nixpkgsConfig) config overlays;
    };

  mkDevShell =
    system:
    let
      pkgs = pkgsFor system;
    in
    pkgs.mkShell {
      packages =
        with pkgs;
        [
          cachix
          git
          deadnix
          lefthook
          nixd
          nixfmt
          statix
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          inputs.darwin.packages.${system}.darwin-rebuild
        ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [
          inputs.home-manager.packages.${system}.home-manager
        ];
    };
in
{
  inherit
    nixpkgsConfig
    pkgsFor
    mkDevShell
    ;
}
