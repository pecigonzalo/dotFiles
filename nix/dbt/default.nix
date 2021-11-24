with import <nixpkgs> { };
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
  dbt-core = pkgs.python39Packages.buildPythonApplication rec {
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
  };
  google-auth = pkgs.python39Packages.buildPythonPackage rec {
    pname = "google-auth";
    version = "1.35.0";

    src = pkgs.python39Packages.fetchPypi {
      inherit pname version;
      sha256 = "b7033be9028c188ee30200b204ea00ed82ea1162e8ac1df4aa6ded19a191d88e";
    };

    # propagatedBuildInputs = with pkgs.python39Packages; [  ];

    buildInputs = [
      pkgs.python39Packages.six
    ];

    propagatedBuildInputs = [
      pkgs.python39Packages.rsa
      pkgs.python39Packages.cachetools
      pkgs.python39Packages.pyasn1-modules
    ];

    doCheck = false;
  };
  protobuf = pkgs.python39Packages.buildPythonPackage rec {
    pname = "protobuf";
    version = "3.17.3";

    src = pkgs.python39Packages.fetchPypi {
      inherit pname version;
      sha256 = "0yyx9wf18gamyfm9gr2s5nv77chg50z820r81l4jmhm9xajlx03j";
    };

    buildInputs = [ pkgs.python39Packages.six ];

    doCheck = false;
  };
  google-api-core = pkgs.python39Packages.buildPythonPackage rec {
    pname = "google-api-core";
    version = "1.31.3";

    src = pkgs.python39Packages.fetchPypi {
      inherit pname version;
      sha256 = "4b7ad965865aef22afa4aded3318b8fa09b20bcc7e8dbb639a3753cf60af08ea";
    };

    # propagatedBuildInputs = with pkgs.python39Packages; [  ];

    propagatedBuildInputs = [
      pkgs.python39Packages.requests
      protobuf
      pkgs.python39Packages.setuptools
      pkgs.python39Packages.googleapis-common-protos
      pkgs.python39Packages.packaging
      pkgs.python39Packages.pytz
      google-auth
      pkgs.python39Packages.googleapis-common-protos
    ];

    doCheck = false;
  };
  google-cloud-core = pkgs.python39Packages.buildPythonPackage rec {
    pname = "google-cloud-core";
    version = "1.7.0";

    src = pkgs.python39Packages.fetchPypi {
      inherit pname version;
      sha256 = "2ab0cf260c11d0cc334573301970419abb6a1f3909c6cd136e4be996616372fe";
    };

    # propagatedBuildInputs = with pkgs.python39Packages; [  ];

    nativeBuildInputs = [ ];
    buildInputs = [
      pkgs.python39Packages.six
      google-auth
      google-api-core
    ];


    doCheck = false;
  };
  psycopg2-binary = pkgs.python39Packages.buildPythonPackage rec {
    pname = "psycopg2-binary";
    version = "2.8";

    src = pkgs.python39Packages.fetchPypi {
      inherit pname version;
      sha256 = "50647aa5f7171153a5f7fa667f99f55468b9b663b997927e4d2e83955b21aa9f";
    };

    # propagatedBuildInputs = with pkgs.python39Packages; [  ];

    nativeBuildInputs = [ pkgs.postgresql ];
    buildInputs = [
      pkgs.openssl
    ];


    doCheck = false;
  };
  dbt-bigquery = pkgs.python39Packages.buildPythonPackage rec {
    pname = "dbt_bigquery";
    version = "0.21.0";
    format = "wheel";

    src = pkgs.python39Packages.fetchPypi {
      inherit pname version format;
      sha256 = "b3ac21f8c32f5f9329e6bab243aa02106450ba9eb179fab95eecd5dcdf6c225a";
      python = "py3";
      dist = "py3";
    };


    propagatedBuildInputs = [
      google-cloud-core
      dbt-core
      pkgs.python39Packages.google-cloud-bigquery
    ];
    buildInputs = [ google-cloud-core ];

    doCheck = false;
  };
  dbt-postgres = pkgs.python39Packages.buildPythonPackage rec {
    pname = "dbt-postgres";
    version = "0.21.0";

    src = pkgs.python39Packages.fetchPypi {
      inherit pname version;
      sha256 = "00ccad11fce3e4d43f7e86c39b3e813924153189ed8288e9a721b20b3dc822a8";
    };


    propagatedBuildInputs = [
      pkgs.python39Packages.psycopg2
      psycopg2-binary
      dbt-core
    ];


    doCheck = false;
  };
  dbt-snowflake = pkgs.python39Packages.buildPythonPackage rec {
    pname = "dbt-snowflake";
    version = "0.21.0";

    src = pkgs.python39Packages.fetchPypi {
      inherit pname version;
      sha256 = "f635463bcfa276ac34d9603f2808daa3c3a44bb1f36209efff9cf35111d0014e";
    };

    buildInputs = [
      pkgs.python39Packages.cryptography
      pkgs.python39Packages.snowflake-connector-python
      dbt-core
    ];


    doCheck = false;
  };
  dbt-redshift = pkgs.python39Packages.buildPythonPackage rec {
    pname = "dbt-redshift";
    version = "0.21.0";

    src = pkgs.python39Packages.fetchPypi {
      inherit pname version;
      sha256 = "79c29f0c032741fdfeffb23f9388ebf659c9b82aa70b228886d79e763bdbecf2";
    };


    buildInputs = [
      pkgs.python39Packages.boto3
      pkgs.python39Packages.s3transfer
      dbt-postgres
    ];


    doCheck = false;
  };
in
pkgs.python39Packages.buildPythonApplication rec {
  pname = "dbt";
  version = "0.21.0";
  format = "wheel";

  src = pkgs.python39Packages.fetchPypi {
    inherit pname version format;
    sha256 = "4813183d42de787ac9cbddd6b55d9c2bfdc7947d21b0b73836d70e0d9b4f10a9";
    python = "py3";
    dist = "py3";
  };

  propagatedBuildInputs = [
    # dbt-core
    #   dbt-postgres
    dbt-bigquery
    #   dbt-snowflake
    #   dbt-redshift
  ];

  outputs = [ "out" ];
  doCheck = false;
}
