{
  config,
  lib,
  pkgs,
  ...
}:
let
  userCfg = config.my.user;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

  # EC2 Instance Connect needs a public key to authorise on the instance.
  ec2Key = lib.findFirst (key: key.type == "ed25519") (builtins.head userCfg.sshKeys) userCfg.sshKeys;

  # `Host *.ssm` carries the instance id in the first label, e.g. `i-0123456789abcdef0.ssm`.
  instanceId = "$(echo %h | rev | cut -d . -f 2- | rev)";

  aws = lib.getExe' pkgs.awscli2 "aws";

  ssmProxyCommand =
    "sh -c \""
    + "${aws} ec2-instance-connect send-ssh-public-key"
    + " --instance-os-user %r --instance-id ${instanceId}"
    + " --ssh-public-key file://~/.ssh/${ec2Key.name}.pub"
    + " && ${aws} ssm start-session --target ${instanceId}"
    + " --document-name AWS-StartSSHSession --parameters 'portNumber=%p'\"";
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*" = {
        Compression = true;
        ServerAliveInterval = 60;
        ControlMaster = "no";
        ControlPath = "~/.ssh/control/%C.control";

        # Only offer known keys: skips agent-only keys and the ~/.ssh default
        # identities, which otherwise get probed on every host.
        IdentitiesOnly = true;
        IdentityFile = map (key: "~/.ssh/${key.name}") userCfg.sshKeys;
        AddKeysToAgent = true;
      }
      // lib.optionalAttrs isDarwin {
        UseKeychain = true;
      };

      # SSH through AWS Systems Manager, `<instance-id>.ssm`.
      "*.ssm" = {
        User = "ssm-user";
        ProxyCommand = ssmProxyCommand;
      };
    };

    includes = [
      "*.config"
    ];
  };

  # `ControlPath` needs the directory to exist; ssh does not create it.
  home.file.".ssh/control/.keep".text = "";

  # Don't install openssh in MacOS as it does not support `UseKeychain`
  home.packages = if !isDarwin then with pkgs; [ openssh ] else [ ];
}
