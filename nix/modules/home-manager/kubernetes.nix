{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.kubernetes;
  neovimCfg = config.my.neovim;
  shellCfg = config.my.shell;
in
{
  options.my.kubernetes = {
    enable = mkEnableOption "Kubernetes tools and configuration" // {
      default = true;
    };

    includeLocalClusters = mkOption {
      type = types.bool;
      default = true;
      description = "Include local cluster tools (k3d, kind, minikube)";
    };

    includeHelm = mkOption {
      type = types.bool;
      default = true;
      description = "Include Helm package manager";
    };

    includeK9s = mkOption {
      type = types.bool;
      default = true;
      description = "Include k9s terminal UI";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Additional Kubernetes-related packages";
    };
  };

  config = mkIf cfg.enable {
    home.shellAliases = {
      k = "kubectl";
      kctx = "kubectl config use-context";
      kns = "kubectl config set-context --current --namespace";
    };

    home.sessionVariables = {
      # Multi-config support
      KUBECONFIG = "${config.my.paths.homeDir}/.kube/config:${config.my.paths.homeDir}/.kube/direct-config";
    };

    home.packages =
      with pkgs;
      [
        # Core tools
        kubectl
        kustomize
        kubeval
        krew
        skaffold
      ]
      ++ optionals cfg.includeLocalClusters [
        k3d
        kind
        minikube
      ]
      ++ optional cfg.includeHelm kubernetes-helm
      ++ optional cfg.includeK9s k9s
      ++ cfg.extraPackages;

    # Add kubectl OMZ plugin if shell is enabled
    my.shell.omzPlugins = mkIf shellCfg.enable [
      { name = "kubectl"; }
    ];

    # Add helm-ls to neovim if both helm and neovim are enabled
    my.neovim.extraPackages = mkIf (neovimCfg.enable && cfg.includeHelm) [
      pkgs.helm-ls
    ];
  };
}
