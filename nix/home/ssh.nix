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

    # TODO: Remove and move to per-host
    extraConfig = ''
      HostkeyAlgorithms +ssh-rsa-cert-v01@openssh.com
      PubkeyAcceptedAlgorithms +ssh-rsa-cert-v01@openssh.com
    '';
  };

  home.packages = with pkgs; [ openssh ];
}
