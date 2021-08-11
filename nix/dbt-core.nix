# { fetchFromGitHub, python3Packages }:
with import <nixpkgs> { };
with pkgs.python3Packages;

let
  mashumaro = buildPythonApplication
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
    };
in

buildPythonApplication
rec {
  pname = "dbt-core";
  version = "0.20.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a6e2545d7a1fd4196c2872a50a3406ca1ec8be62c02180210a9e7d13d4616fbd";
  };

  buildInputs = [
    json-rpc
    Logbook
    jinja2
    werkzeug
    idna
    networkxd
    requests
    sqlparse
    colorama
    mashumaro
  ];

  meta = with pkgs.lib; {
    homepage = "https://www.getdbt.com/";
  };
}
