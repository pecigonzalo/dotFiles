{ config
, lib
, pkgs
, ...
}:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  homedir = config.home.homeDirectory;
  dotfiles = "${config.home.homeDirectory}/dotFiles";
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
      ./aws.nix
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
      # TODO: REMOVE ME
      GODEBUG="asyncpreemptoff=1";

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

      # TLDR Colors
      TLDR_COLOR_BLANK = "white";
      TLDR_COLOR_NAME = "cyan";
      TLDR_COLOR_DESCRIPTION = "white";
      TLDR_COLOR_EXAMPLE = "green";
      TLDR_COLOR_COMMAND = "red";
      TLDR_COLOR_PARAMETER = "white";

      # github.com/oz/tz
      TZ_LIST = "Europe/Madrid;Home,US/Pacific;PDT";

      # Kubeconfig
      KUBECONFIG = "${homedir}/.kube/config:${homedir}/.kube/direct-config";
    };
  };

  home.file = {
    ".xprofile".source = mkOutOfStoreSymlink "${dotfiles}/.xprofile";

    ".asdfrc".source = mkOutOfStoreSymlink "${dotfiles}/.asdfrc";
    ".tool-versions".source = mkOutOfStoreSymlink "${dotfiles}/.tool-versions";
    ".default-cloud-sdk-components".source = mkOutOfStoreSymlink "${dotfiles}/.default-cloud-sdk-components";

    ".terraformrc".source = mkOutOfStoreSymlink "${dotfiles}/.terraformrc";

    ".gemrc".source = mkOutOfStoreSymlink "${dotfiles}/.gemrc";

    ".numpy-site.cfg".source = mkOutOfStoreSymlink "${dotfiles}/.numpy-site.cfg";

    ".parallel/will-cite".text = ""; # Stop `parallel` from displaying citation warning
  };

  xdg.configFile = {
    "pypoetry/config.toml".source = mkOutOfStoreSymlink "${dotfiles}/.config/pypoetry/config.toml";
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

    # Common
    htop
    nano
    nmap
    ngrep
    neofetch
    netcat-gnu
    wget
    curl
    which
    ldns
    dnsutils
    unixtools.watch

    # Build tools
    pkgconfig
    autoconf
    coreutils
    findutils
    diffutils
    binutils
    gnumake
    gnugrep
    gnused
    gnutar
    gnupg
    gawk

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
    gzip

    # CLI Replacements
    bat # cat
    ripgrep # grep
    exa # ls
    fd # find
    httpie # curl
    curlie # curl
    tealdeer # TLDR
    du-dust # du
    htop # top
    procs # ps
    dogdns # dig
    gping # ping with a graph

    jo # JSON objects made easy https://github.com/jpmens/jo

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
    python-with-env
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
    terraform-docs
    tflint
    packer
    nodePackages.cdktf-cli

    # GCP
    berglas

    # GitHub
    act

    # Node
    nodejs
    yarn
    nodePackages.typescript

    # Deno
    deno

    # Git
    pre-commit
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
    kubeseal

    # DB tools
    postgresql

    # Go
    go
    gopls
    goreleaser
    # golangci-lint

    # Java
    gradle
    gradle-completion

    # Ansible
    ansible_2_9
    # ansible-lint

    # Other CLIs
    _1password
    teleport

    # Container runtimes
    lima
    colima

    # parquet
    # parquet-tools

    # # Libs
    # openblas
  ];
}
