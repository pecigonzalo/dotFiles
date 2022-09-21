{ pkgs, ... }:
{
  programs.ssh = {
    enable = true;

    compression = true;

    serverAliveInterval = 60;
    
    controlMaster = "no";
    controlPersist = "1m";
    controlPath = "~/.ssh/control/%C.control";

    includes = [
      "*.config"
    ];
  };

  # TODO: We have to disable openssh as ssh-add does not work with macOS
  # home.packages = with pkgs; [ openssh ];
}
