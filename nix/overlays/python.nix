final: prev:
{
  # https://github.com/NixOS/nixpkgs/pull/162047
  python3 = prev.python3.override
    {
      packageOverrides = pySelf: pySuper: {
        ipython = pySuper.ipython.overridePythonAttrs (old: {
          disabledTests = [
            "test_clipboard_get" # uses pbpaste
          ];
        });
      };
    };
  pythonEnv = final.python39.withPackages (ps: with ps;
    [
      pip
      pipx

      isort
      black
      mypy
      flake8

      pytest

      setuptools
      virtualenv

      python-lsp-server

      ipython
    ]);
}
