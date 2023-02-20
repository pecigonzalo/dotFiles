final: prev:
let
  isSillicon = prev.stdenv.isDarwin
    && prev.stdenv.hostPlatform.isAarch64;
in
if isSillicon then {
  pkgs-stable = prev.pkgs-stable //
    {
      python3 = prev.pkgs-stable.python3.override {
        packageOverrides = python-final: python-prev: {
          pyopenssl = python-prev.pyopenssl.overrideAttrs (oldAttrs: {
            meta.broken = false;
          });
        };
      };
    };
  inherit (final.pkgs-x86)
    # https://github.com/vic/mk-darwin-system/blob/main/nix/overlays/intel-pkgs.nix
    llvmPackages_6 llvmPackages_7 llvmPackages_8 llvmPackages_9 llvmPackages_10
    ;
  inherit (final.pkgs-x86-stable)
    ;
  hubble = prev.hubble.overrideAttrs (self: {
    meta = self.meta // { broken = false; };
  });
  lima = prev.lima-bin;
  colima = prev.colima.override
    {
      lima = prev.lima-bin;
    };
} else { }
