{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  packages = with pkgs; [
    cachix
    git
    nixd
    nixfmt
  ];
}
