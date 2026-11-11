# textlint rules that are not packaged in nixpkgs.
# Mirrors the yarn-based packaging of `textlint-rule-write-good` in nixpkgs.
{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  nodejs,
  yarn,
  textlint,
}:
let
  mkTextlintRule =
    {
      pname,
      version,
      srcHash,
      yarnHash,
      description,
      # Some rules rely on peer dependencies that only appear in devDependencies
      # (e.g. @textlint/ast-node-types), so pruning them breaks loading.
      pruneDevDependencies ? true,
    }:
    stdenv.mkDerivation (finalAttrs: {
      inherit pname version;

      src = fetchFromGitHub {
        owner = "textlint-rule";
        repo = pname;
        tag = "v${version}";
        hash = srcHash;
      };

      offlineCache = fetchYarnDeps {
        yarnLock = "${finalAttrs.src}/yarn.lock";
        hash = yarnHash;
      };

      nativeBuildInputs = [
        fixup-yarn-lock
        nodejs
        yarn
      ];

      configurePhase = ''
        runHook preConfigure

        export HOME=$(mktemp -d)
        yarn config --offline set yarn-offline-mirror "$offlineCache"
        fixup-yarn-lock yarn.lock
        yarn --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive install
        patchShebangs node_modules

        runHook postConfigure
      '';

      buildPhase = ''
        runHook preBuild

        yarn --offline build

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        ${lib.optionalString pruneDevDependencies "yarn --offline --production install"}
        rm -r test
        mkdir -p $out/lib/node_modules/${pname}
        cp -r . $out/lib/node_modules/${pname}/

        runHook postInstall
      '';

      meta = {
        inherit description;
        homepage = "https://github.com/textlint-rule/${pname}";
        license = lib.licenses.mit;
        inherit (textlint.meta) platforms;
      };
    });
in
{
  textlint-rule-rousseau = mkTextlintRule {
    pname = "textlint-rule-rousseau";
    version = "1.4.8";
    srcHash = "sha256-jEuCP8nuF8hCq1VeirrPznQ9WWtHYeV1FmyyNQh5/48=";
    yarnHash = "sha256-FBUF2uau8FlWJGfPzqlKpvTIhFDr1+AmGqeRHiSruws=";
    description = "textlint rule that checks English prose with rousseau";
    pruneDevDependencies = false;
  };

  textlint-rule-en-capitalization = mkTextlintRule {
    pname = "textlint-rule-en-capitalization";
    version = "2.0.3";
    srcHash = "sha256-gTwO6C/Sniry4P94HCoJWPulgQIMwa1Nwk7ucpOkSGM=";
    yarnHash = "sha256-fh1gwpz4bZVejiZE74/kRyTOYyd3z4YdoGHjiTUEg+U=";
    description = "textlint rule that checks capitalization of English text";
  };
}
