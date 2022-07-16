final: prev:
{
  inherit (final.pkgs-21-05)
    sshuttle
    dnsutils# https://github.com/NixOS/nixpkgs/issues/152056
    ;
  inherit (final.pkgs-21-11)
    ansible_2_9
    awscli2
    httpie
    pre-commit
    ;
  inherit (final.pkgs-stable)
    starship
    neovim
    deno
    procs
    ;
}
