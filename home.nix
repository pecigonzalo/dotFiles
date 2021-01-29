{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager = {
    enable = true;
  };

  home.packages = with pkgs; [
    # Nix
    rnix-lsp

    # Misc
    neofetch
    nmap
    htop
    tree
    jq
    yq
    tldr
    exa
    bat
    fzf
    fd
    httpie
    ripgrep
    mkcert
    rclone
    restic
    sshuttle
    socat
    watchman
    direnv
    go-task # taskfile.dev
    caddy
    dos2unix
    zstd

    # Dhall
    dhall

    # Dev
    tmux
    neovim

    # Load testing
    k6
    vegeta

    # jsonnet
    jsonnet
    jsonnet-bundler

    # Config Mgmt
    ansible

    # Python
    poetry
    pipenv
    python39Packages.pipx
    black

    # Bash
    shfmt

    # Hashi
    # vagrant
    packer
    terraform
    terraform-ls
    tflint

    # Docker
    docker-compose
    podman

    # AWS
    aws-vault
    chamber

    # GCP
    berglas

    starship

    # Node
    nodejs
    yarn

    # Deno
    deno

    # Git
    gitAndTools.hub
    gitAndTools.gh
    gitAndTools.pre-commit
    gitAndTools.delta
    gitAndTools.diff-so-fancy

    # K8s
    kube3d # k3d
    kind
    krew
    k9s
    kail
    kubectl
    kustomize
    minikube
    skaffold

    # Elm
    elmPackages.elm

    # Go
    go
    gopls
  ];
}
