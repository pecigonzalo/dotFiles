final: prev:
{
  pythonEnv = prev.buildEnv {
    name = "pythonEnv";
    paths = [
      (final.python3.withPackages (
        ps: with ps; [
          pip
          isort
          black
          mypy
          flake8
          pytest
          virtualenv
          pipx
          leveldb
        ]
      ))
      final.poetry
      final.pipenv
    ];
  };
}
