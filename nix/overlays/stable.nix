final: prev:
{
  inherit (final.pkgs-21-05)
    sshuttle
    dnsutils# https://github.com/NixOS/nixpkgs/issues/152056
    ;
  inherit (final.pkgs-21-11)
    pre-commit
    httpie
    ;
  inherit (final.pkgs-stable)
    ansible
    curlie
    starship
    # neovim
    # vimPlugins
    deno
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
