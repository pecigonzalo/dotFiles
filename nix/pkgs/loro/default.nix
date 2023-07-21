{ buildGoModule
, fetchFromGitHub
, installShellFiles
}:
buildGoModule rec {
  pname = "loro";
  version = "0.3.0";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "pecigonzalo";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-GzXJyEUS6CWJBg+0yPpFPOPxUb9kilo8BPpJqJUt2TU=";
  };

  vendorSha256 = "sha256-DYOUxdxACiCX5i4HZAdf3F9lGC5+OHT6pa2RfdKQ4J0=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  ldflags = [
    "-X main.Version=v${version}"
  ];

  # postInstall = ''
  #   installShellCompletion --cmd loro \
  #     --bash $src/contrib/completions/bash/loro.bash \
  #     --fish $src/contrib/completions/fish/loro.fish \
  #     --zsh $src/contrib/completions/zsh/loro.zsh
  # '';

  installCheckPhase = ''
    $out/bin/loro --version 2>&1 | grep ${version} > /dev/null
  '';
}
