final: prev:
{
  pythonEnv = prev.python3.withPackages (ps: with ps; [
    pip

    isort
    black
    mypy
    flake8

    pytest

    virtualenv

    ipython

    pyyaml

    boto3
  ]);
}
