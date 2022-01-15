final: prev:
let
  isSillicon = prev.stdenv.hostPlatform.isDarwin
    && prev.stdenv.hostPlatform.isAarch64;
in
if isSillicon then {
  inherit (final.pkgs-x86)
    asdf-vm
    nix-index;
  inherit (final.pkgs-x86-stable)
    packer;
} else { }
