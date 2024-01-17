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
  jl = callPackage ./jl { };
  socket_vmnet = callPackage ./socket_vmnet {
    inherit (prev.darwin.apple_sdk.frameworks) vmnet;
  };
  xo = callPackage ./xo { };
}
