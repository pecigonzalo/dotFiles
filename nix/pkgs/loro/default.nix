{ buildGoModule
, fetchFromGitHub
, installShellFiles
}:
buildGoModule rec {
  pname = "loro";
  version = "0.2.3";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "pecigonzalo";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-6qZz1RddX2La+uKb0VFnTmH8DY5B/cKMV41uWHk4qy8=";
  };

  vendorSha256 = "sha256-xuJKybJNvsccZ/+JuTZF+yowJK6pNkLgViugM7e3CCE=";

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
