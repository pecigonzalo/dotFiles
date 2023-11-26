final: prev:
{
  xo = prev.buildNpmPackage rec {
    pname = "xo";
    version = "0.56.0";
    src = prev.fetchFromGitHub {
      owner = "xojs";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-vbIBjxHb2LyL3OED7+h9zLtWSJ9NJAz67aXI+wbgYrs=";
    };

    postPatch = "
      cp ${./xo.package-lock.json} ./package-lock.json
    ";
    npmDepsHash = "sha256-HAMtA9HmNkw20yo1F0JLdeTPEwwA2ut4vwFqte3mw3U=";

    dontNpmBuild = true;
    dontNpmPrune = true;

    meta = {
      description = "❤️ JavaScript/TypeScript linter (ESLint wrapper) with great defaults";
      homepage = "https://github.com/xojs/xo";
    };
  };
}
