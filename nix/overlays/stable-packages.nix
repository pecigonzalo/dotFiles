# Prefer stable for packages where latest unstable is unnecessary or expensive to build.
# Keep dynamic overlay discovery; this file depends on pkgs-stable from flake.nix.
final: _prev: {
  inherit (final.pkgs-stable)
    pre-commit
    # Stable avoids large source builds on Darwin; latest is not needed.
    watchman
    ;
}
