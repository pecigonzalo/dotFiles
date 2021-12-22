final: prev:
let
  inherit (prev) lib;
  callPackage = lib.callPackageWith (
    prev // prev.python3.pkgs
  );
in
{
  shell-functools = callPackage ./shell-functools { };
  loro = callPackage ./loro { };
  iamlive = callPackage ./iamlive { };
}
