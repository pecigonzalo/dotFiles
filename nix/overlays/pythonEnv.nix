self: super:
{
  pythonEnv = super.buildEnv {
    name = "pythonEnv";
    paths = [
      (self.python3.withPackages (
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
      self.poetry
      self.pipenv
    ];
  };
}
