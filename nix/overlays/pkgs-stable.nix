{ inputs, nixpkgsConfig }:
# Prefer stable for packages where latest unstable is unnecessary or expensive to build.
_final: prev:
let
  pkgs-stable = import inputs.nixpkgs-stable {
    inherit (prev.stdenv) system;
    inherit (nixpkgsConfig) config;
  };
in
{
  inherit pkgs-stable;

  inherit (pkgs-stable)
    pre-commit
    # Stable avoids large source builds on Darwin; latest is not needed.
    watchman
    ;
}
