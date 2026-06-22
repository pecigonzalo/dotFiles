{ pkgs, lib, ... }:
{
  home.packages =
    import ./common.nix { inherit pkgs; }
    ++ lib.optionals pkgs.stdenv.isLinux (import ./linux.nix { inherit pkgs; });
}
