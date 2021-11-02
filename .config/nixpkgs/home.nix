{ lib
, pkgs
, ...
}:
let
  username = builtins.getEnv "USER";
  home = builtins.getEnv "HOME";
in
{
  news.display = "silent";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports =
    [
      (import ./home/zsh.nix { inherit home pkgs; })
      (import ./home/fzf.nix { inherit home pkgs; })
      ./home/git.nix
      ./home/editor.nix
      ./home/tmux.nix
      ./home/starship.nix
    ];

  fonts.fontconfig.enable = true;

  home = {
    username = username;
    homeDirectory = home;

    sessionVariables =
      let
        preSessionPath = [
          "${home}/.local/bin"
          # Go
          "${home}/Workspace/go/bin"
          # K8s Krew
          "${home}/.krew/bin"
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
        GOPATH = "${home}/Workspace/go";

        # Disable virtualenv in prompt autoconfig
        VIRTUAL_ENV_DISABLE_PROMPT = 1;
        # Pipenv
        PIPENV_VENV_IN_PROJECT = true;

        # Docker
        DOCKER_BUILDKIT = 1;
      };
  };

  home.file = {
    ".xprofile".source = "${home}/dotFiles/.xprofile";

    ".asdfrc".source = "${home}/dotFiles/.asdfrc";
    ".tool-versions".source = "${home}/dotFiles/.tool-versions";
    ".default-cloud-sdk-components".source = "${home}/dotFiles/.default-cloud-sdk-components";

    ".terraformrc".source = "${home}/dotFiles/.terraformrc";

    ".gemrc".source = "${home}/dotFiles/.gemrc";

    ".numpy-site.cfg".source = "${home}/dotFiles/.numpy-site.cfg";
  };

  xdg.configFile = {
    "pypoetry/config.toml".source = "${home}/dotFiles/.config/pypoetry/config.toml";
  };

  programs.bash.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;

    config = {
      global = {
        strict_env = true;
      };

      whitelist = {
        prefix = [
          "${home}/Workspace/"
        ];
      };
    };

    stdlib = ''
      layout_poetry() {
        if [[ ! -f pyproject.toml ]]; then
          log_error 'No pyproject.toml found. Use `poetry new` or `poetry init` to create one first.'
          exit 2
        fi

        # create venv if it doesn't exist
        poetry run true

        export VIRTUAL_ENV=$(poetry env info --path)
        export POETRY_ACTIVE=1
        PATH_add "$VIRTUAL_ENV/bin"
      }

      layout_node() {
        PATH_add node_modules/.bin
      }

      # if [[ -f pyproject.toml ]]; then
      #   layout_poetry
      # fi

      # if [[ -f node_modules ]]; then
      #   layout_node
      # fi
    '';
  };

  programs.ssh = {
    enable = true;

    serverAliveInterval = 120;
    compression = true;

    controlMaster = "auto";
    controlPersist = "10m";

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
    snzip
    pandoc
    zstd
    m4
    vale # Prose linter
    zsh-completions
    nix-zsh-completions

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
    # (callPackage "${home}/dotFiles/nix/dbt.nix" { })

    # snyk
    # (callPackage "${home}/dotFiles/nix/snyk" { })

    # iamlive
    (callPackage "${home}/dotFiles/nix/iamlive" { })

    # Hostess
    (callPackage "${home}/dotFiles/nix/hostess" { })

    # Loro
    # (callPackage "${home}/dotFiles/nix/loro.nix" { })

    # Bash
    shfmt

    # Hashi
    # vagrant
    terraform
    terraform-ls
    nodePackages.cdktf-cli
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
    nodePackages.node2nix

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
    teleport

    # Fonts
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
    fira-code
    fira-mono

    # TA-Lib
    # (callPackage "${home}/dotFiles/nix/ta-lib.nix" {})

    # General Libs
    # openssl_1_1
    # openssl_1_1.dev
    # zlib
    # zlib.dev
    # readline
    # readline.dev
    # libffi
    # libffi.dev
    # bzip2
    # bzip2.dev
    # xz
    # xz.dev

    # Math Libs
    # openblas
    # openblas.dev

    # Compiler
    # gfortran
  ];
}
