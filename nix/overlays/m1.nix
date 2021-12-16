final: prev:
let
  isSillicon = prev.stdenv.hostPlatform.isDarwin
    && prev.stdenv.hostPlatform.isAarch64;
in if isSillicon then {
  inherit (final.pkgs-x86)
    packer
    asdf-vm
    nix-index;
} else {}
