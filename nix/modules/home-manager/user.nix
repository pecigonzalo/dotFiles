{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.user;

  # Find the first ed25519 key for signing, if available
  findSigningKey =
    keys:
    let
      ed25519Keys = filter (k: k.type == "ed25519") keys;
    in
    if (length ed25519Keys) > 0 then "~/.ssh/${(head ed25519Keys).name}.pub" else null;
in
{
  options.my.user = {
    name = mkOption {
      type = types.str;
      default = "Gonzalo Peci";
      description = "User's full name";
    };

    email = mkOption {
      type = types.str;
      default = "pecigonzalo@users.noreply.github.com";
      description = "User's email address";
    };

    githubUsername = mkOption {
      type = types.str;
      default = "pecigonzalo";
      description = "User's GitHub username";
    };

    sshKeys = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            name = mkOption {
              type = types.str;
              description = "SSH key name (without path or extension)";
            };
            type = mkOption {
              type = types.str;
              description = "SSH key type (e.g., ed25519, rsa)";
            };
          };
        }
      );
      default = [
        {
          name = "pecigonzalo_ed25519";
          type = "ed25519";
        }
        {
          name = "pecigonzalo_rsa";
          type = "rsa";
        }
      ];
      description = "List of SSH keys with their names and types";
    };

    signingKey = mkOption {
      type = types.nullOr types.str;
      default = findSigningKey cfg.sshKeys;
      description = "SSH key path for signing commits (computed from first ed25519 key if not set)";
    };
  };
}
