# { fetchFromGitHub, python3Packages }:
with import <nixpkgs> { };
with pkgs.python3Packages;

let
  dbt-core = buildPythonApplication
    rec {
      pname = "dbt-core";
      version = "0.20.2";

      src = fetchPypi {
        inherit pname version;
        sha256 = "a6e2545d7a1fd4196c2872a50a3406ca1ec8be62c02180210a9e7d13d4616fbd";
      };

      outputs = [ "out" ];

      buildInputs = [
        python39Packages.json-rpc
        python39Packages.Logbook
        python39Packages.jinja2
        python39Packages.werkzeug
        python39Packages.idna
        python39Packages.networkx
        python39Packages.requests
        python39Packages.sqlparse
        python39Packages.colorama
      ];

      meta = with pkgs.lib; {
        homepage = "https://www.getdbt.com/";
      };
    };

  dbt-postgres = buildPythonApplication
    rec {
      pname = "dbt-postgres";
      version = "0.20.2";

      src = fetchPypi {
        inherit pname version;
        sha256 = "738909960d69c36a934ce31f3f4cc12d2812a75a5914272e3fe7ab73703105f0";
      };

      outputs = [ "out" ];

      propagatedBuildInputs = [
        dbt-core
      ];

      meta = with pkgs.lib; {
        homepage = "https://www.getdbt.com/";
      };
    };

  dbt-bigquery = buildPythonApplication
    rec {
      pname = "dbt-bigquery";
      version = "0.20.2";

      src = fetchPypi {
        inherit pname version;
        sha256 = "18690ae3f0d54bc3a86f83b6261c98918cb6d9d1932deb833cfccae4e85af7e9";
      };

      outputs = [ "out" ];

      propagatedBuildInputs = [
        python39Packages.cffi
        python39Packages.idna
        python39Packages.googleapis-common-protos
        dbt-core
      ];

      meta = with pkgs.lib; {
        homepage = "https://www.getdbt.com/";
      };
    };

  dbt-extractor = buildPythonApplication
    rec {
      pname = "dbt-extractor";
      version = "0.4.0";

      src = fetchPypi {
        inherit pname version;
        sha256 = "58672e36fab988c849a693405920ee18421f27245c48e5f9ecf496369ed31a85";
      };

      outputs = [ "out" ];

      meta = with pkgs.lib; {
        homepage = "https://www.getdbt.com/";
      };
    };

in
buildPythonApplication rec {
  pname = "dbt";
  version = "0.20.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b4496a51288b60c612801a5c0a6eeda61edb2d5a9b10b1573d5491ceb07cc6a4";
  };

  outputs = [ "out" ];

  propagatedBuildInputs = [
    dbt-postgres
    dbt-bigquery
  ];

  meta = with pkgs.lib; {
    homepage = "https://www.getdbt.com/";
  };
}
