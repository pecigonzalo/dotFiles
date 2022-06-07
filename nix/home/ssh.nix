{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;

    compression = true;

    controlMaster = "auto";
    controlPersist = "1m";
    controlPath = "~/.ssh/%C.control";

    includes = [
      "*.config"
    ];
  };

  # TODO: We have to disable openssh as ssh-add does not work with macOS
  # home.packages = with pkgs; [ openssh ];
}
