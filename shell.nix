{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  packages = with pkgs; [
    cachix
    deadnix
    git
    hyperfine
    lefthook
    nixd
    nixfmt
    statix
    stylua
  ];
}
