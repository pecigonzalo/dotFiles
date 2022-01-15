final: prev:
{
  pythonEnv = prev.python3.withPackages (ps: with ps; [
    pip
    pipx

    isort
    black
    mypy
    flake8

    pytest

    virtualenv

    ipython
  ]);
}
