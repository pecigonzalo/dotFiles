final: prev:
{
  inherit (final.pkgs-stable)
    # NodeJS on latest is not building
    nodejs
    nodePackages
    nodePackages_latest
    yarn
    eslint_d
    prettierd
    ;
}
