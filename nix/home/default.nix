{
  config,
  pkgs,
  inputs,
  ...
}:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;

  homeDir = config.home.homeDirectory;
  dotFilesDir = "${homeDir}/dotFiles";
in
{
  news.display = "silent";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./ssh.nix
    ./terminal.nix
    ./fonts.nix
    ./karabiner.nix
  ];

  xdg.enable = true;
  my = {
    neovim.enable = true;
    tmux.enable = true;
    starship.enable = true;
    terraform.enable = true;
    aws.enable = true;
    gcp.enable = true;
    git.enable = true;
    shell.enable = true;
    direnv.enable = true;
    fzf.enable = true;
    kubernetes.enable = true;
    python.enable = true;
    nodejs.enable = true;
    golang.enable = true;
    nix-tools.enable = true;
  };

  home = {
    shellAliases = {
      # Follow tail
      "tailf" = "tail -f";

      # eza
      "exa" = "eza --icons --color=always";
      "ls" = "eza";
      "tree" = "eza --tree";
      "l" = "eza -lh";
      "la" = "eza -la";
      "ll" = "eza -l";
      "lS" = "eza -1";
      "lt" = "tree --level=2";

      # bat
      "cat" = "bat -p";
    };

    sessionVariables = {
      # Editor
      EDITOR = "nvim";
      # VISUAL = "code";

      # Pager
      PAGER = "less";
      LESS = "-FRSX";

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
    };
  };

  home.file = {
    ".xprofile".source = mkOutOfStoreSymlink "${dotFilesDir}/.xprofile";
    ".tool-versions".source = mkOutOfStoreSymlink "${dotFilesDir}/.tool-versions";
    ".gemrc".source = mkOutOfStoreSymlink "${dotFilesDir}/.gemrc";

    ".asdfrc".text = ''
      legacy_version_file = yes
    '';

    ".parallel/will-cite".text = ""; # Stop `parallel` from displaying citation warning
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
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
  };

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--smart-case"
      "--follow"
    ];
  };

  home.packages = with pkgs; [
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
    eza # ls
    fd # find
    # httpie # curl
    curlie # curl
    tealdeer # TLDR
    dust # du
    htop # top
    procs # ps
    doggo # dig
    gping # ping with a graph
    sad # CLI search and replace | Space Age seD
    glow # Markdown reader
    jo # JSON objects made easy https://github.com/jpmens/jo

    # Package managers
    asdf-vm
    devbox

    # Elm
    elmPackages.elm

    # Dhall
    dhall

    # Load testing / Benchmarking
    k6
    vegeta
    hyperfine # CLI benchmarking

    # Local
    jl # JSON structured logs parser
    loro
    iamlive
    # shell-functools # a collection of functional programming tools for the shell

    # Bash
    shellcheck
    shfmt

    # Hashi
    # vagrant
    packer

    # Docker
    docker
    docker-compose
    podman
    dive

    # DB tools
    postgresql
    redis
    duckdb

    # Graph
    graphviz

    # Debug
    pprof

    # Java
    jdk17_headless
    # gradle
    # gradle-completion

    # Markdown
    glow

    # Ansible
    ansible
    # ansible-lint

    # Other CLIs
    _1password-cli

    # Container runtimes
    lima
    colima

    # WSL
    wslu

    # Security
    # nodePackages.snyk # Snyk CLI
    cilium-cli
    hubble
    cloudflared
    teleport
  ];
}
