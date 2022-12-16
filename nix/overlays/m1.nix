final: prev:
let
  isSillicon = prev.stdenv.hostPlatform.isDarwin
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
  # colima = (prev.colima.override { buildGoModule = prev.buildGoModule; }).overrideAttrs
  #   (old: rec {
  #     version = "1c742bc5a2715af5727a5a5f2926187abfbe9f76";
  #     src = prev.fetchFromGitHub {
  #       owner = "abiosoft";
  #       repo = "colima";
  #       rev = "${version}";
  #       sha256 = "sha256-N2uKw2B1FkkRlSUA/aIK42XPpkT+qhIYbda2JMKXMhE=";
  #       leaveDotGit = true;
  #       postFetch = ''
  #         git -C $out rev-parse --short HEAD > $out/.git-revision
  #         rm -rf $out/.git
  #       '';
  #     };
  #   });

} else { }
