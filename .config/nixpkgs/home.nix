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
  programs.zsh = {
    enable = true;

    # This is taken care of by zinit
    enableCompletion = false;
    enableAutosuggestions = false;
    enableSyntaxHighlighting = false;
    envExtra = "skip_global_compinit=1";

    dotDir = ".config/zsh";

    initExtraFirst = "zmodload zsh/zprof";

    initExtraBeforeCompInit = "source ~/.zinit/bin/zinit.zsh";

    initExtra = ''
      # ASDF
      source "${home}/.nix-profile/etc/profile.d/asdf-prepare.sh"

      # Dynamic load
      source ${home}/dotFiles/zsh/zshrc

      # ZSH profiling save
      zprof >/tmp/zprof
    '';

    history = {
      size = 5000000;
      save = 5000000;
      path = ".histfile";
      ignorePatterns = [
        "ls"
        "cd"
        "cd -"
        "pwd"
        "exit"
        "date"
        "* --help"
        "man *"
      ];
    };

    shellAliases = {
      # Snowsql
      "snowsql" = "/Applications/SnowSQL.app/Contents/MacOS/snowsql";

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

      # Reload
      "reshell!" = "exec $SHELL -l";

      # Kubectl
      "k" = "kubectl";
    };

    sessionVariables = {
      # Correction settings
      CORRECT_IGNORE = "_*";
      CORRECT_IGNORE_FILE = ".*";

      # Uncomment the following line if you want to disable marking untracked files
      # under VCS as dirty. This makes repository status check for large repositories
      # much, much faster.
      DISABLE_UNTRACKED_FILES_DIRTY = "true";

      # TLDR Colors
      TLDR_COLOR_BLANK = "white";
      TLDR_COLOR_NAME = "cyan";
      TLDR_COLOR_DESCRIPTION = "white";
      TLDR_COLOR_EXAMPLE = "green";
      TLDR_COLOR_COMMAND = "red";
      TLDR_COLOR_PARAMETER = "white";

      # OMZ
      DISABLE_UPDATE_PROMPT = "true";
      DISABLE_AUTO_UPDATE = "true";

      # Tipz
      TIPZ_TEXT = "💡";

      # zsh-autosuggestions
      ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE = 20;
      ZSH_AUTOSUGGEST_USE_ASYNC = "true";

      # zsh-z, fz
      ZSHZ_CMD = "zshz";
      ZSHZ_NO_RESOLVE_SYMLINKS = 1;
      FZ_HISTORY_CD_CMD = "zshz";
      FZ_SUBDIR_TRAVERSAL = 0;

      # github.com/oz/tz
      TZ_LIST = "Europe/Madrid;Home,US/Pacific;PDT";

      # AWS
      AWS_PAGER = "bat -p --color=always -l json";
      SHOW_AWS_PROMPT = "false"; # Disable OMZ prompt
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;

    defaultCommand = "fd --type f --hidden --follow --exclude .git --color=always";
    defaultOptions = [
      "--multi"
      "--ansi"
      "--height=50%"
      "--min-height=15"
      "--reverse"
      "--color=bg:-1,fg:-1,prompt:1,info:3,hl:2,hl+:2"
    ];

    historyWidgetOptions = [
      "--preview 'echo {}'"
      "--preview-window down:3:hidden:wrap"
      "--bind '?:toggle-preview'"
    ];

    # fileWidgetCommand = "";
    fileWidgetOptions = [
      "--preview '(bat --style=numbers --color=always --line-range :500 {} || exa --tree --level=4 {}) 2> /dev/null'"
      "--select-1"
      "--exit-0"
    ];

    changeDirWidgetCommand = "fd --type directory --color=always . ${home}";
    changeDirWidgetOptions = [
      "--preview 'exa --tree --level=4 {} | head -200'"
    ];
  };

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

    # Hostess
    (callPackage "${home}/dotFiles/nix/hostess.nix" { })

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
