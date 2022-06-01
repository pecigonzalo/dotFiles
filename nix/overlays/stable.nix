final: prev:
{
  inherit (final.pkgs-21-05)
    sshuttle
    dnsutils# https://github.com/NixOS/nixpkgs/issues/152056
    ;
  inherit (final.pkgs-21-11)
    ansible_2_9
    starship
    neovim
    deno
    httpie
    procs
    awscli2
    pre-commit
    ;
}
