final: prev:
{
  inherit (final.pkgs-21-05)
    dnsutils# https://github.com/NixOS/nixpkgs/issues/152056
    sshuttle
    ;
  inherit (final.pkgs-21-11)
    pre-commit
    ;
  inherit (final.pkgs-stable)
    kcli
    ansible
    curlie
    starship
    teleport
    procs
    unrar
    _1password
    dive
    kail
    kompose
    kubeval
    yabai
    ;
}
