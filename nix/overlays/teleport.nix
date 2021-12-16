final: prev:
let
  isSillicon = prev.stdenv.hostPlatform.isDarwin
    && prev.stdenv.hostPlatform.isAarch64;
in if isSillicon then {
  teleport = prev.teleport.overrideAttrs (oldAttrs: rec {
    # TODO: Re-enable checks
    # Checks try to edit /var/empty (the nix build user home) which fails
    # This should not happen as preCheck sets HOME to a tmp
    doCheck = false;
  });
} else {}
