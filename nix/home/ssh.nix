{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      compression = true;

      serverAliveInterval = 60;

      controlMaster = "no";
      controlPersist = "1m";
      controlPath = "~/.ssh/control/%C.control";

    };

    includes = [
      "*.config"
    ];
  };

  # Don't install openssh in MacOS as it does not support `UseKeychain`
  home.packages = if !pkgs.stdenv.isDarwin then with pkgs; [ openssh ] else [ ];
}
