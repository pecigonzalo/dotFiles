# Read-only, Nix-managed Colima config. Edit here, then restart Colima
# (`colima restart`) for changes to take effect. Don't use `colima start --edit`.
{ pkgs, lib, ... }:
let
  yaml = pkgs.formats.yaml { };
in
lib.mkIf pkgs.stdenv.isDarwin {
  xdg.configFile."colima/default/colima.yaml" = {
    # Replace the hand-written file Colima generated on first start.
    force = true;
    source = yaml.generate "colima.yaml" {
      cpu = 6;
      memory = 8;
      disk = 60;
      rootDisk = 20;
      arch = "aarch64";
      runtime = "docker";
      hostname = "colima";
      vmType = "vz";
      rosetta = true;
      # Rosetta handles amd64 images, no need for qemu binfmt emulation.
      binfmt = false;
      mountType = "virtiofs";
      mountInotify = true;
      portForwarder = "ssh";
      autoActivate = true;
      sshConfig = true;
      forwardAgent = false;
      network.address = true;
      kubernetes.enabled = false;
      mounts = [
        {
          location = "~/Workspace";
          writable = true;
        }
      ];
      docker = {
        features.buildkit = true;
        log-driver = "json-file";
        log-opts = {
          max-size = "10m";
          max-file = "3";
        };
      };
    };
  };
}
