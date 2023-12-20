final: prev:
{
  inherit (final.pkgs-stable)
    dnsutils# https://github.com/NixOS/nixpkgs/issues/152056
    _1password
    ansible
    curlie
    dive
    kail
    kompose
    kubeval
    pre-commit
    procs
    sshuttle
    starship
    teleport
    unrar
    yabai
    deno
    nushell
    ;
}
