self: super:
{
  pythonEnv = super.buildEnv {
    name = "pythonEnv";
    paths = [
      (self.python3.withPackages (
        ps: with ps; [
          pip
          # ipython
          isort
          black
          mypy
          flake8
          # pyls-isort
          # pyls-black
          # pyls-mypy
          pytest
          virtualenv
          pipx
        ]
      ))
      self.poetry
      self.pipenv
    ];
  };
}
