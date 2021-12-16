final: prev:
let
  isSillicon = prev.stdenv.hostPlatform.isDarwin
    && prev.stdenv.hostPlatform.isAarch64;
in if isSillicon then {
  inherit (final.pkgs-21-05)
    sshuttle;
} else {}
