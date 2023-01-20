{ mkDerivation, fetchFromGitHub, lib }:
mkDerivation {
  pname = "shell-functools";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "socket_vmnet";
    rev = "v${version}";
    sha256 = "";
  };

  meta = with lib; {
    homepage = "https://github.com/lima-vm/socket_vmnet";
    description = "vmnet.framework support for unmodified rootless QEMU (no dependency on VDE)";
  };
}
