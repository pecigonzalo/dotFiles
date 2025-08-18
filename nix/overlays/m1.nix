final: prev:
let
  isSillicon = prev.stdenv.isDarwin && prev.stdenv.hostPlatform.isAarch64;
in
if isSillicon then
  {
    # inherit (final.pkgs-x86)
    #   # https://github.com/vic/mk-darwin-system/blob/main/nix/overlays/intel-pkgs.nix
    #   llvmPackages_6
    #   llvmPackages_7
    #   llvmPackages_8
    #   llvmPackages_9
    #   llvmPackages_10
    #   ;
    # inherit (final.pkgs-x86-stable)
    #   ;
    # hubble = prev.hubble.overrideAttrs (self: {
    #   meta = self.meta // {
    #     broken = false;
    #   };
    # });
    # # Use binary lima in macOS to support macOS advanced features
    # lima = prev.lima;
    # colima = prev.colima.override {
    #   lima = prev.lima;
    # };
  }
else
  { }
