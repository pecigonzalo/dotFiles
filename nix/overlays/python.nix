final: prev:

let
  stable = final.pkgs-21-11;
in
{
  python-with-env = stable.python3.withPackages (ps: with ps;
    [
      pip

      isort
      black
      mypy
      flake8

      pytest

      wheel
      setuptools
      virtualenv

      ipython

      pipx
    ]);
}
