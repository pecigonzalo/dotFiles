{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  packages = with pkgs; [
    cachix
    deadnix
    git
    lefthook
    nixd
    nixfmt
    statix
  ];
}
