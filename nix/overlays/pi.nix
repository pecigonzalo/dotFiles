{ inputs, nixpkgsConfig }:

final: _prev: {
  pi = inputs.pi.packages.${final.stdenv.hostPlatform.system}.default;
}
