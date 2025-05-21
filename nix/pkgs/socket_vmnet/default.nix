{
  stdenv,
  makeWrapper,
  fetchFromGitHub,
  lib,
  vmnet,
}:
stdenv.mkDerivation rec {
  pname = "socket_vmnet";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "lima-vm";
    repo = "socket_vmnet";
    rev = "v${version}";
    sha256 = "sha256-vdVDZtZ7mkhw2baWo07AsasChTMMyheAfqJI1S2MUUY=";
  };

  nativeBuildInputs = [
    makeWrapper
  ] ++ lib.optionals stdenv.isDarwin [ vmnet ];

  buildPhase = ''
    runHook preBuild
    make socket_vmnet
    make socket_vmnet_client
    runHook postBuild
  '';
  installPhase = ''
    mkdir -p $out/bin
    mv socket_vmnet $out/bin
    mv socket_vmnet_client $out/bin
  '';

  meta = with lib; {
    homepage = "https://github.com/lima-vm/socket_vmnet";
    description = "vmnet.framework support for unmodified rootless QEMU (no dependency on VDE)";
  };
}
