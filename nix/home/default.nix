{ config
, lib
, pkgs
, homeDirectory
, ...
}:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  news.display = "silent";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports =
    [
      ./ssh.nix
      ./zsh.nix
      ./fzf.nix
      ./direnv.nix
      ./git.nix
      ./editor.nix
      ./tmux.nix
      ./starship.nix
      ./kitty.nix
      ./fonts.nix
    ];

  home = {
    shellAliases = {
      # Google Apps CLI
      "gam" = "/home/gonzalo.peci/bin/gam/gam";

      # Follow tail
      "tailf" = "tail -f";

      # gitg remove console output
      "gitg" = "gitg >> /dev/null 2>&1";

      # exa
      "exa" = "exa --icons --color=always";
      "ls" = "exa";
      "tree" = "exa --tree";
      "l" = "exa -lFh";
      "la" = "exa -la";
      "ll" = "exa -l";
      "lS" = "exa -1";
      "lt" = "tree --level=2";

      # bat
      "cat" = "bat -p";

      # terraform
      "tf" = "terraform";

      # Kubectl
      "k" = "kubectl";
    };

    sessionVariables = {
      # Editor
      EDITOR = "nvim";
      VISUAL = "code";

      # Pager
      PAGER = "less";
      LESS = "-FRSX";

      # Go
      GOPATH = "${config.home.homeDirectory}/Workspace/go";

      # Disable virtualenv in prompt autoconfig
      VIRTUAL_ENV_DISABLE_PROMPT = 1;

      # Pipenv
      PIPENV_VENV_IN_PROJECT = true;

      # Docker
      DOCKER_BUILDKIT = 1;

      # TLDR Colors
      TLDR_COLOR_BLANK = "white";
      TLDR_COLOR_NAME = "cyan";
      TLDR_COLOR_DESCRIPTION = "white";
      TLDR_COLOR_EXAMPLE = "green";
      TLDR_COLOR_COMMAND = "red";
      TLDR_COLOR_PARAMETER = "white";

      # AWS
      AWS_PAGER = "bat -p --color=always -l json";

      # github.com/oz/tz
      TZ_LIST = "Europe/Madrid;Home,US/Pacific;PDT";
    };
  };

  home.file = {
    ".xprofile".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotFiles/.xprofile";

    ".asdfrc".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotFiles/.asdfrc";
    ".tool-versions".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotFiles/.tool-versions";
    ".default-cloud-sdk-components".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotFiles/.default-cloud-sdk-components";

    ".terraformrc".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotFiles/.terraformrc";

    ".gemrc".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotFiles/.gemrc";

    ".numpy-site.cfg".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotFiles/.numpy-site.cfg";

    ".parallel/will-cite".text = ""; # Stop `parallel` from displaying citation warning
  };

  xdg.configFile = {
    "pypoetry/config.toml".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotFiles/.config/pypoetry/config.toml";
  };

  programs.bash.enable = true;

  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };

  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
    };
  };

  home.packages = with pkgs; [
    # Nix
    nixpkgs-fmt
    rnix-lsp
    comma # Run without installing by using ,

    # Misc
    parallel
    jq
    yq-go
    mkcert
    rclone
    restic
    sshuttle
    socat
    watchman
    go-task # taskfile.dev
    dos2unix
    pandoc
    vale # Prose linter
    zsh-completions

    # Compression
    m4
    xz
    unrar
    zstd

    # CLI Replacements
    ripgrep # grep
    exa # ls
    fd # find
    httpie # curl
    tealdeer # TLDR
    du-dust # du
    htop # top
    procs # ps

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

    # Load testing / Benchmarking
    k6
    vegeta
    hyperfine # CLI benchmarking

    # jsonnet
    jsonnet
    jsonnet-bundler

    # Python
    pythonEnv
    poetry
    pipenv

    # Local
    loro
    iamlive
    shell-functools # a collection of functional programming tools for the shell

    # Bash
    shellcheck
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
    nodePackages.typescript

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

    # Other CLIs
    _1password
    teleport
  ];
}
