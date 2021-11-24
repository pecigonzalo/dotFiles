{ pkgs }:

let
  mashumaro = pkgs.python39Packages.buildPythonPackage
    rec {
      pname = "mashumaro";
      version = "2.5";

      src = pkgs.python39Packages.fetchPypi {
        inherit pname version;
        sha256 = "0m8kbnjz4mm15prbqidphdswskwmyh5akgqy5aqxkdf6pk5jwh7c";
      };

      propagatedBuildInputs = [
        pkgs.python39Packages.pyyaml
        pkgs.python39Packages.msgpack
        pkgs.python39Packages.typing-extensions
      ];
    };

  dbt-extractor = pkgs.python39Packages.buildPythonPackage rec {
    pname = "dbt-extractor";
    version = "0.4.0";

    src = fetchTarball {
      url = "https://files.pythonhosted.org/packages/a7/5c/609f02383178208612d6ac21228ca256337d3c18afb13b29f122720a26ad/dbt_extractor-0.4.0.tar.gz";
      sha256 = "0dhpskpzvk77mpyajvmf7km3m1gfvfd8brpk02raswvn6p9pqjnz";
    };

    cargoDeps = pkgs.rustPlatform.fetchCargoTarball {
      inherit src;
      name = "${pname}-${version}";
      hash = "sha256-UbfjQiyivKl6iTY6QvF3LmXWovxPoV5k4Cr8fx115S0=";
    };
    format = "pyproject";
    buildInputs = [ pkgs.libiconv ];
    nativeBuildInputs = with pkgs.rustPlatform; [ cargoSetupHook maturinBuildHook ];

  };
  jinja2 = pkgs.python39Packages.buildPythonPackage rec {
    pname = "Jinja2";
    version = "2.11.3";

    src = pkgs.python39Packages.fetchPypi {
      inherit pname version;
      sha256 = "1iiklf3wns67y5lfcacxma5vxfpb7h2a67xbghs01s0avqrq9md6";
    };

    propagatedBuildInputs = [
      pkgs.python39Packages.Babel
      pkgs.python39Packages.markupsafe
    ];

    # Multiple tests run out of stack space on 32bit systems with python2.
    # See https://github.com/pallets/jinja/issues/1158
    doCheck = !stdenv.is32bit;

    checkInputs = [
    ];

    meta = with lib; {
      homepage = "http://jinja.pocoo.org/";
      description = "Stand-alone template engine";
    };
  };
  minimal-snowplow-tracker = pkgs.python39Packages.buildPythonPackage rec {
    pname = "minimal-snowplow-tracker";
    version = "0.0.2";

    src = pkgs.python39Packages.fetchPypi {
      inherit pname version;
      sha256 = "acabf7572db0e7f5cbf6983d495eef54081f71be392330eb3aadb9ccb39daaa4";
    };

    buildInputs = [
      pkgs.python39Packages.requests
      pkgs.python39Packages.six
    ];

    meta = with lib; { };
  };
  jsonschema = pkgs.python39Packages.buildPythonPackage rec {
    pname = "jsonschema";
    version = "3.1.1";

    src = pkgs.python39Packages.fetchPypi {
      inherit pname version;
      sha256 = "2fa0684276b6333ff3c0b1b27081f4b2305f0a36cf702a23db50edb141893c3f";
    };

    propagatedBuildInputs = [
      pkgs.python39Packages.attrs
      pkgs.python39Packages.pyrsistent
      pkgs.python39Packages.importlib-metadata
    ];

    doCheck = false;
  };
  hologram = pkgs.python39Packages.buildPythonPackage rec {
    pname = "hologram";
    version = "0.0.14";

    src = pkgs.python39Packages.fetchPypi {
      inherit pname version;
      sha256 = "fd67bd069e4681e1d2a447df976c65060d7a90fee7f6b84d133fd9958db074ec";
    };

    propagatedBuildInputs = [
      jsonschema
      pkgs.python39Packages.python-dateutil
    ];

    doCheck = false;
  };
  sqlparse = pkgs.python39Packages.buildPythonPackage rec {
    pname = "sqlparse";
    version = "0.3.1";

    src = pkgs.python39Packages.fetchPypi {
      inherit pname version;
      sha256 = "e162203737712307dfe78860cc56c8da8a852ab2ee33750e33aeadf38d12c548";
    };

    nativeBuildInputs = [ installShellFiles ];

    checkInputs = [ ];

    doCheck = false;

    postInstall = ''
      installManPage docs/sqlformat.1
    '';

    meta = with lib; { };
  };

in
pkgs.python39Packages.buildPythonApplication rec {
  pname = "dbt-core";
  version = "0.21.0";

  src = pkgs.python39Packages.fetchPypi {
    inherit pname version;
    sha256 = "74626c1e32acfc3f49112b77029dac8dd6902c13dbfee184e74e659fe28ce51b";
  };

  propagatedBuildInputs = [
    dbt-extractor
    jinja2
    minimal-snowplow-tracker
    hologram
    sqlparse
    mashumaro

    pkgs.python39Packages.json-rpc
    pkgs.python39Packages.Logbook
    pkgs.python39Packages.werkzeug
    pkgs.python39Packages.networkx
    pkgs.python39Packages.requests
    pkgs.python39Packages.colorama
    pkgs.python39Packages.isodate
    pkgs.python39Packages.pyyaml
    pkgs.python39Packages.packaging
    pkgs.python39Packages.agate
    pkgs.python39Packages.typing-extensions

  ];

  doCheck = false;

  meta = with pkgs.lib; {
    homepage = "https://www.getdbt.com/";
  };
}
