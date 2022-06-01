final: prev:
let
  isSillicon = prev.stdenv.hostPlatform.isDarwin
    && prev.stdenv.hostPlatform.isAarch64;
in
if isSillicon then {
  inherit (final.pkgs-x86)
    # https://github.com/vic/mk-darwin-system/blob/main/modules/intel-overlay.nix#L13
    llvmPackages_5 llvmPackages_6 llvmPackages_7 llvmPackages_8 llvmPackages_9 llvmPackages_10
    asdf-vm
    nix-index
    ;
  inherit (final.pkgs-x86-stable)
    packer
    ;
} else { }
