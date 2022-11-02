{ config
, lib
, pkgs
, ...
}:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  tomlFormat = pkgs.formats.toml { };

  homeDir = config.home.homeDirectory;
  dotFilesDir = "${homeDir}/dotFiles";
in
{
  news.display = "silent";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports =
    [
      ./ssh.nix
      ./editor.nix
      ./tmux.nix
      ./starship.nix
      ./kitty.nix
      ./fonts.nix
    ];

  xdg.enable = true;
  my = {
    terraform.enable = true;
    aws.enable = true;
    gcp.enable = true;
    git.enable = true;
    betterShell.enable = true;
  };

  home = {
    shellAliases = {
      # Follow tail
      "tailf" = "tail -f";

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
      GOPATH = "${homeDir}/Workspace/go";

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
      KUBECONFIG = "${homeDir}/.kube/config:${homeDir}/.kube/direct-config";
    };
  };

  home.file = {
    ".xprofile".source = mkOutOfStoreSymlink "${dotFilesDir}/.xprofile";
    ".tool-versions".source = mkOutOfStoreSymlink "${dotFilesDir}/.tool-versions";
    ".gemrc".source = mkOutOfStoreSymlink "${dotFilesDir}/.gemrc";

    ".numpy-site.cfg".text = ''
      [ALL]
      library_dirs = ${homeDir}/.nix-profile/lib
      include_dirs = ${homeDir}/.nix-profile/include

      [DEFAULT]
      library_dirs = ${homeDir}/.nix-profile/lib
      include_dirs = ${homeDir}/.nix-profile/include
    '';

    ".asdfrc".text = ''
      legacy_version_file = yes
    '';

    ".parallel/will-cite".text = ""; # Stop `parallel` from displaying citation warning
  };

  xdg.configFile = {
    "pypoetry/config.toml".source = tomlFormat.generate "config.toml" {
      virtualenvs = {
        in-project = true;
      };
    };
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
    pkg-config
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
    goaccess # Access log analyzer
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
    jl # JSON structured logs parser
    loro
    iamlive
    shell-functools # a collection of functional programming tools for the shell

    # Bash
    shellcheck
    shfmt

    # Hashi
    # vagrant
    packer

    # Node
    nodejs
    yarn
    nodePackages.typescript

    # Deno
    deno

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
    ansible
    # ansible-lint

    # Other CLIs
    _1password
    teleport

    # Container runtimes
    lima
    colima

    # WSL
    wslu

    # Security
    nodePackages.snyk # Snyk CLI
  ];
}
