{ pkgs, lib, ... }:
with lib;
let
  accounts = {
    tf-state = {
      ssoRoleName = "TerraformStateAccessBI";
      ssoAccountId = "261359505706";
    };
    data-development = {
      ssoRoleName = "AdminAccess";
      ssoAccountId = "059943995018";
    };
    data-staging = {
      ssoRoleName = "AdminAccess";
      ssoAccountId = "744556994719";
    };
    data-production = {
      ssoRoleName = "AdminAccess";
      ssoAccountId = "263932266204";
    };
    data-dwh = {
      ssoRoleName = "AdminAccess";
      ssoAccountId = "701101817323";
    };
    data-playground = {
      ssoRoleName = "AdminAccess";
      ssoAccountId = "756549092616";
    };
    app-dev = {
      ssoRoleName = "ViewerAccess";
      ssoAccountId = "676736170286";
    };
    app-stg = {
      ssoRoleName = "ViewerAccess";
      ssoAccountId = "590211171383";
    };
    app-prd = {
      ssoRoleName = "ViewerAccess";
      ssoAccountId = "830006442260";
    };
    compute-ml-development = {
      ssoRoleName = "AdminAccess";
      ssoAccountId = "494881968505";
    };
    compute-ml-staging = {
      ssoRoleName = "AdminAccess";
      ssoAccountId = "130470223684";
    };
    compute-ml-production = {
      ssoRoleName = "AdminAccess";
      ssoAccountId = "020765180495";
    };
  };

  mkVaultProfile =
    { ssoRoleName
    , ssoAccountId
    , ssoStartUrl ? "https://traderepublic.awsapps.com/start"
    , ssoRegion ? "eu-central-1"
    , region ? "eu-central-1"
    ,
    }:
    {
      sso_role_name = ssoRoleName;
      sso_account_id = ssoAccountId;
      sso_start_url = ssoStartUrl;
      sso_region = ssoRegion;
      region = region;
    };
  mkCliProfile =
    { vaultProfileName
    , region ? "eu-central-1"
    ,
    }: {
      credential_process = "aws-vault exec ${vaultProfileName} --json";
      region = "eu-central-1";
    };


  mkProfileCombo = profileName: ssoRoleName: ssoAccountId:
    let
      vaultProfileName = "${profileName}-vault";
    in
    [
      {
        name = "profile ${vaultProfileName}";
        value = mkVaultProfile { inherit ssoRoleName ssoAccountId; };
      }
      {
        name = "profile ${profileName}";
        value = mkCliProfile { inherit vaultProfileName; };
      }
    ];

  awsConfig = builtins.listToAttrs
    (lists.flatten (
      attrsets.mapAttrsToList
        (name: value:
          mkProfileCombo name value.ssoRoleName value.ssoAccountId
        )
        accounts
    ));
in
{
  home.file.".aws/config".text = generators.toINI { } awsConfig;
  home.sessionVariables = {
    # AWS
    AWS_PAGER = "bat -p --color=always -l json";
  };
  home.packages = with pkgs; [
    # AWS
    aws-vault
    chamber
    awscli2
    # ssm-session-manager-plugin
    aws-nuke
    awless
    eksctl
  ];
}
