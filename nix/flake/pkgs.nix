{
  inputs,
  nixpkgs,
}:
let
  namedOverlays = [
    (import ../pkgs)
  ];

  dynamicOverlays =
    let
      path = ../overlays;
      stableOverlay = "pkgs-stable.nix";
      isOverlay =
        overlay:
        builtins.match ".*\\.nix" overlay != null
        || builtins.pathExists (path + ("/" + overlay + "/default.nix"));
      overlayNames = builtins.filter isOverlay (builtins.attrNames (builtins.readDir path));
      orderedOverlayNames =
        builtins.filter (overlay: overlay == stableOverlay) overlayNames
        ++ builtins.filter (overlay: overlay != stableOverlay) overlayNames;
    in
    map (
      overlay: import (path + ("/" + overlay)) { inherit inputs nixpkgsConfig; }
    ) orderedOverlayNames;

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
          hyperfine
          lefthook
          nixd
          nixfmt
          statix
          stylua
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
