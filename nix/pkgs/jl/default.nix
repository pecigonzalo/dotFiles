{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
buildGoModule rec {
  pname = "jl";
  version = "v1.4.0";

  subPackages = [ "." ];

  src = fetchFromGitHub {
    owner = "koenbollen";
    repo = pname;
    rev = "${version}";
    sha256 = "sha256-cEFbCvOkYNbYxQC6q4Jrl1jR48gXskBts9OTUEgnXoY=";
  };

  vendorHash = "sha256-mRyMZq+MhPLplrZCR/AzWb48VhVEYBKftwlDZFIU7ug=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  ldflags = [
    "-X main.version=${version}"
  ];

  installCheckPhase = ''
    $out/bin/jl --version 2>&1 | grep ${version} > /dev/null
  '';
}
