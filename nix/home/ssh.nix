{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings."*" = {
      Compression = true;
      ServerAliveInterval = 60;
      ControlMaster = "no";
      ControlPersist = "1m";
      ControlPath = "~/.ssh/control/%C.control";
    };

    includes = [
      "*.config"
    ];
  };

  # Don't install openssh in MacOS as it does not support `UseKeychain`
  home.packages = if !pkgs.stdenv.isDarwin then with pkgs; [ openssh ] else [ ];
}
