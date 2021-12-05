final: prev:
{
  teleport = prev.teleport.overrideAttrs (oldAttrs: rec {
    # TODO: Re-enable checks
    # Checks try to edit /var/empty (the nix build user home) which fails
    # This should not happen as preCheck sets HOME to a tmp
    doCheck = false;
  });
}
