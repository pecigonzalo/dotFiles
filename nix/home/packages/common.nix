{ pkgs }:
with pkgs;
[
  # Common
  htop
  nano
  nmap
  ngrep
  fastfetch
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
  tree-sitter
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

  # Security
  # nodePackages.snyk # Snyk CLI
  cilium-cli
  hubble
  cloudflared
  teleport
]
