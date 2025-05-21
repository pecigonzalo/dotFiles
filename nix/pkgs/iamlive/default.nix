{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "iamlive";
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "iann0036";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jqz19bj259ingl8q32ar3wsrcsg3g0h6nxr4dg3hfqikjym8xbl";
  };

  vendorHash = null;

  meta = with lib; {
    homepage = "https://github.com/iann0036/iamlive";
    description = "Generate an IAM policy from AWS calls using client-side monitoring (CSM) or embedded proxy";
    license = licenses.mit;
  };
}
