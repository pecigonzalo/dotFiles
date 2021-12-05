{ config
, lib
, pkgs
, ...
}:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  user = "gonzalopeci";
  homedir = "/Users/${user}";
in
{
  news.display = "silent";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports =
    [
      ./zsh.nix
      ./fzf.nix
      ./direnv.nix
      ./git.nix
      ./editor.nix
      ./tmux.nix
      ./starship.nix
    ];

  fonts.fontconfig.enable = true;

  home = {
    username = user;
    homeDirectory = homedir;

    sessionVariables =
      let
        preSessionPath = [
          "${homedir}/.local/bin"
          # Go
          "${homedir}/Workspace/go/bin"
          # K8s Krew
          "${homedir}/.krew/bin"
          # Snowflake SnowSQL
          "/Applications/SnowSQL.app/Contents/MacOS"
          # Brew
          "/opt/homebrew/bin"
          # System
          "$PATH"
        ];
        userPath = "${builtins.concatStringsSep ":" preSessionPath}";
      in
      {
        # Path
        PATH = userPath;

        # Editor
        EDITOR = "nvim";
        VISUAL = "code";

        # Pager
        PAGER = "less";
        LESS = "-FRSX";

        # Go
        GOPATH = "${homedir}/Workspace/go";

        # Disable virtualenv in prompt autoconfig
        VIRTUAL_ENV_DISABLE_PROMPT = 1;
        # Pipenv
        PIPENV_VENV_IN_PROJECT = true;

        # Docker
        DOCKER_BUILDKIT = 1;
      };
  };

  home.file = {
    ".xprofile".source = mkOutOfStoreSymlink "${homedir}/dotFiles/.xprofile";

    ".asdfrc".source = mkOutOfStoreSymlink "${homedir}/dotFiles/.asdfrc";
    ".tool-versions".source = mkOutOfStoreSymlink "${homedir}/dotFiles/.tool-versions";
    ".default-cloud-sdk-components".source = mkOutOfStoreSymlink "${homedir}/dotFiles/.default-cloud-sdk-components";

    ".terraformrc".source = mkOutOfStoreSymlink "${homedir}/dotFiles/.terraformrc";

    ".gemrc".source = mkOutOfStoreSymlink "${homedir}/dotFiles/.gemrc";

    ".numpy-site.cfg".source = mkOutOfStoreSymlink "${homedir}/dotFiles/.numpy-site.cfg";
  };

  xdg.configFile = {
    "pypoetry/config.toml".source = mkOutOfStoreSymlink ".config/pypoetry/config.toml";
  };

  programs.bash.enable = true;

  programs.alacritty.enable = true;

  programs.ssh = {
    enable = true;

    serverAliveInterval = 120;
    compression = true;

    controlMaster = "auto";
    controlPersist = "10m";
    controlPath = "~/.ssh/%C.control";

    extraConfig = "Include *.config";
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
    };
  };

  home.packages = with pkgs; [
    # Misc
    jq
    yq-go
    tldr
    exa
    fd
    httpie
    ripgrep
    mkcert
    rclone
    restic
    sshuttle
    socat
    watchman
    go-task # taskfile.dev
    dos2unix
    pandoc
    zstd
    m4
    vale # Prose linter
    zsh-completions

    # ASDF
    asdf-vm

    # Buildkite
    buildkite-agent
    buildkite-cli

    # Kafka
    kcli

    # Elm
    elmPackages.elm

    # Dhall
    dhall

    # Load testing
    k6
    vegeta

    # jsonnet
    jsonnet
    jsonnet-bundler

    # Python
    pythonEnv

    # DBT
    # (callPackage "${homedir}/dotFiles/nix/dbt.nix" { })

    # snyk
    # (callPackage "${homedir}/dotFiles/nix/snyk" { })

    # hostess
    # (callPackage "../nix/nixpkgs/hostess" { })

    # Local
    loro
    iamlive
    shell-functools

    # Bash
    shfmt

    # Hashi
    # vagrant
    terraform
    terraform-ls
    tflint
    packer

    # AWS
    aws-vault
    chamber
    awscli2
    aws-nuke
    awless
    eksctl

    # GCP
    berglas

    # Node
    nodejs
    yarn

    # Deno
    deno

    # Git
    gitAndTools.pre-commit
    git-filter-repo

    # Docker
    docker
    docker-compose
    podman
    dive

    # K8s
    kube3d # k3d
    kind
    krew
    k9s
    kail
    kubectl
    kubectl-example
    kustomize
    minikube
    skaffold
    kubeval
    kompose
    kubernetes-helm

    # Go
    go
    gopls
    goreleaser
    golangci-lint

    # Java
    gradle
    gradle-completion

    # Ansible
    ansible_2_9
    # ansible-lint

    # CLIs
    _1password
    # teleport

    # Fonts
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    fira-code
    fira-mono
  ];
}
