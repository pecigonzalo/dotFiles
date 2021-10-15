self: super:
let
  pkgs_x86_64 = import <nixpkgs> { localSystem = "x86_64-darwin"; overlays = [ ]; };
in
{
  neovim-unwrapped = pkgs_x86_64.neovim-unwrapped;
  elmPackages.elm = pkgs_x86_64.elmPackages.elm;
  packer = pkgs_x86_64.packer;
  asdf-vm = pkgs_x86_64.asdf-vm;
  nix-index = pkgs_x86_64.nix-index;
  fsharp = pkgs_x86_64.fsharp;
  dotnetCorePackages = pkgs_x86_64.dotnetCorePackages;
}
