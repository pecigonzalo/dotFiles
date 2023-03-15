final: prev:
{
  inherit (final.pkgs-21-11)
    kcli
    ;
  inherit (final.pkgs-stable)
    dnsutils# https://github.com/NixOS/nixpkgs/issues/152056
    _1password
    ansible
    curlie
    dive
    kail
    kompose
    kubeval
    pre-commit
    procs
    sshuttle
    starship
    teleport
    unrar
    yabai
    ;
  # Build latest Teleport 9 version
  teleport-9 =
    let
      version = "9.3.26";
      src = prev.pkgs-22-05.fetchFromGitHub {
        owner = "gravitational";
        repo = "teleport";
        rev = "v${version}";
        sha256 = "sha256-5FUjWPNttI7kHy2JfZjI6LIPUe35+6mMEppe1qwA6iA=";
      };
    in
    (prev.pkgs-22-05.teleport.override rec {
      withRdpClient = false;
      withRoleTester = false;
      buildGoModule = args: prev.pkgs-22-05.buildGoModule.override
        {
          go = prev.pkgs-22-05.go_1_17;
        }
        (args // {
          inherit src version;
          vendorSha256 = "sha256-2P2uxC0cZaptrTpK6OGIGJEf6itwOmJg63uih1gjmJ8";
          # Only build tsh on client machines
          subPackages = [ "tool/tsh" ];
          installCheckPhase = ''
            $out/bin/tsh version | grep ${version} > /dev/null
            $client/bin/tsh version | grep ${version} > /dev/null
          '';
        });
    });
}
