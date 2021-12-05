{ stdenv, fetchurl }:
stdenv.mkDerivation rec {
  baseName = "loro";
  version = "0.1.2";
  name="${baseName}-${version}";

  src = fetchurl {
    url = "https://github.com/pecigonzalo/${baseName}/releases/download/${version}/${baseName}";
    sha256 = "0m98dyff4r5id0n1652f8km1b1yl47idhqjip7qm2n4j623y38dv";
  };

  phases = ["installPhase"];

  installPhase = ''
    install -m755 -D $src $out/bin/loro
  '';
}
