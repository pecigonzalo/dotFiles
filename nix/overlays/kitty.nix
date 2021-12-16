final: prev:
let
  isSillicon = prev.stdenv.hostPlatform.isDarwin
    && prev.stdenv.hostPlatform.isAarch64;
in if isSillicon then {
  # TODO: Remove when Kitty is fixed in: https://github.com/NixOS/nixpkgs/pull/137512
  kitty = prev.kitty.overrideAttrs (oldAttrs: rec {
    buildInputs = oldAttrs.buildInputs ++ [prev.darwin.apple_sdk.frameworks.UserNotifications];
    patches = [
      (prev.fetchpatch {
        url = "https://raw.githubusercontent.com/NixOS/nixpkgs/9816857458874b4e0a9560f9296b3a6a341d3810/pkgs/applications/terminal-emulators/kitty/apple-sdk-11.patch";
        sha256 = "sha256-PQb1p5z1/GR9W3V/y8P02hYkAVj2ksPEoFUylkyV99s=";
      })
    ];
  });
} else {}
