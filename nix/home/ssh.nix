{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;

    compression = true;

    controlMaster = "auto";
    controlPersist = "10m";
    controlPath = "~/.ssh/%C.control";

    includes = [
      "*.config"
    ];
  };

  home.packages = with pkgs; [ openssh ];
}
