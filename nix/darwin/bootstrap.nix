{ pkgs, ... }:
{
  # Used for backwards compatibility; do not bump just because inputs update.
  # Read the changelog before changing: darwin-rebuild changelog
  system.stateVersion = 5;

  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];

  nix = {
    extraOptions = ''
      extra-platforms = aarch64-darwin x86_64-darwin

      keep-outputs = true
      keep-derivations = true
    '';
  };
}
