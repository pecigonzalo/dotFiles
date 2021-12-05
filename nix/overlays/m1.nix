self: super:
let
  x86_64 = import <nixpkgs> { localSystem = "x86_64-darwin"; overlays = [ ]; };
in
{
  # elmPackages.elm = x86_64.elmPackages.elm;
  packer = x86_64.packer;
  asdf-vm = x86_64.asdf-vm;
  nix-index = x86_64.nix-index;
  # fsharp = x86_64.fsharp;
  # dotnetCorePackages = x86_64.dotnetCorePackages;
}
