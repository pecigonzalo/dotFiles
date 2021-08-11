# { fetchFromGitHub, python3Packages }:
with import <nixpkgs> { };
with pkgs.python3Packages;

buildPythonApplication
rec {
  pname = "mashumaro";
  version = "2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ec402ecbbcc6b5d9b12a1ebfa90af4954fcd7583b745bcf22da156f2a55d1355";
  };

  buildInputs = [
    pyyaml
    msgpack
    typing-extensions
  ];

  meta = with pkgs.lib; { };
}
