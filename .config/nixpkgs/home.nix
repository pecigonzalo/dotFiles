{ pkgs
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

  # Create /etc/bashrc that loads the nix-darwin environment.
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

  programs.tmux = {
    enable = true;

    terminal = "screen-256color";

    prefix = "C-Space";
    shortcut = "Space";

    shell = "${pkgs.zsh}/bin/zsh";

    newSession = true;
    baseIndex = 1;
    historyLimit = 100000;
    aggressiveResize = true;
    secureSocket = true;

    sensibleOnTop = true;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
    ];

    extraConfig = ''
      # Enable mouse mode
      set -g mouse on

      #-------------------------------------------------------#
      # Pane colours

      # set inactive/active window styles
      setw -g window-active-style bg=terminal
      setw -g window-style bg=black

      #-------------------------------------------------------#
      # PANE NAVIGATION/MANAGEMENT
      # splitting panes
      bind '\' split-window -h -c '#{pane_current_path}'
      bind - split-window -v -c '#{pane_current_path}'
      unbind '"'
      unbind %

      # open new panes in current path
      bind c new-window -c ' #{pane_current_path}'

      # Use Alt-arrow keys WITHOUT PREFIX KEY to switch panes
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
      bind -n S-Left previous-window
      bind -n S-Right next-window
      bind -n C-T new-window

      #-------------------------------------------------------#
      # Set window name to folder name
      set-option -g status-interval 5
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{b:pane_current_path}'
    '';
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;

    plugins = with pkgs.vimPlugins; [
      dracula-vim
      nerdtree
    ];

    coc = {
      enable = true;
    };

    extraConfig = builtins.readFile "${home}/dotFiles/.vimrc";
  };

  programs.gh = {
    enable = true;
    editor = "nvim";
    gitProtocol = "ssh";
    aliases = {
      co = "pr checkout";
      pv = "pr view";
      prs = "pr list -A pecigonzalo";
    };
  };

  programs.git = {
    enable = true;

    userName = "Gonzalo Peci";
    userEmail = "pecigonzalo@users.noreply.github.com";

    delta = {
      enable = true;
      options = {
        side-by-side = false;
      };
    };

    extraConfig = {
      init = {
        templatedir = "~/dotFiles/.git_template/template";
        defaultBranch = "main";
      };

      status.showuntrackedfiles = "all";
      push.default = "current";
      pull.rebase = true;
      fetch.prune = true;
      help.autocorrect = "true";
      difftool.prompt = false;

      core = {
        editor = "code --wait";
        whitespace = "trailing-space,space-before-tab";
      };

      color = {
        branch = "auto";
        diff = "auto";
        interactive = "auto";
        pager = true;
        status = "auto";
        ui = "auto";
      };

      "color \"status\"" = {
        added = "green";
        changed = "yellow";
        untracked = "red";
      };

      diff = {
        algorithm = "minimal";
        compactionHeuristic = true;
        renames = "copies";
        mnemonicprefix = true;
        tool = "vscode";
      };

      "difftool \"vscode\"".cmd = "cmd = code --wait --diff $LOCAL $REMOTE";

      merge.tool = "vscode";
      mergetool.keepBackup = false;
      "mergetool \"vscode\"".cmd = "code --wait $MERGED";

      rebase = {
        autoSquash = true;
        autoStash = true;
      };
    };

    aliases = {
      gist = "log --graph --oneline --all --decorate --date-order";
      find = "log --graph --oneline --all --decorate --date-order --regexp-ignore-case --extended-regexp --grep";
      rfind = "log --graph --oneline --all --decorate --date-order --regexp-ignore-case --extended-regexp --invert-grep --grep";
      search = "grep --line-number --ignore-case -E -I";
      changelog = "!f() { git log $1 $2 --no-merges --pretty=format:\"* [%H] - %s\"; }; f";
    };

    ignores = [
      # Created by https://www.gitignore.io/api/code,windows,linux,osx,direnv
      # Edit at https://www.gitignore.io/?templates=code,windows,linux,osx,direnv

      ### Code ###
      ".vscode/*"

      ### direnv ###
      ".direnv"
      ".envrc"

      ### Linux ###
      "*~"

      # temporary files which can be created if a process still has a handle open of a deleted file
      ".fuse_hidden*"

      # KDE directory preferences
      ".directory"

      # Linux trash folder which might appear on any partition or disk
      ".Trash-*"

      # .nfs files are created when an open file is removed but is still being accessed
      ".nfs*"

      ### OSX ###
      # General
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"

      # Icon must end with two \r
      "Icon"

      # Thumbnails
      "._*"

      # Files that might appear in the root of a volume
      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"

      # Directories potentially created on remote AFP share
      ".AppleDB"
      ".AppleDesktop"
      "Network Trash Folder"
      "Temporary Items"
      ".apdisk"

      ### Windows ###
      # Windows thumbnail cache files
      "Thumbs.db"
      "Thumbs.db:encryptable"
      "ehthumbs.db"
      "ehthumbs_vista.db"

      # Dump file
      "*.stackdump"

      # Folder config file
      "[Dd]esktop.ini"

      # Recycle Bin used on file shares
      "$RECYCLE.BIN/"

      # Windows Installer files
      "*.cab"
      "*.msi"
      "*.msix"
      "*.msm"
      "*.msp"

      # Windows shortcuts
      "*.lnk"

      # End of https://www.gitignore.io/api/code,windows,linux,osx,direnv
    ];
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

    # TA-Lib
    # (callPackage "${home}/dotFiles/nix/ta-lib.nix" {})

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
    tflint
    packer

    # Docker
    docker
    docker-compose
    podman

    # AWS
    aws-vault
    chamber
    awscli2
    aws-nuke
    awless
    eksctl

    # GCP
    berglas

    # Console
    starship

    # Node
    nodejs
    yarn

    # Deno
    deno

    # Git
    gitAndTools.pre-commit

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

    # Libs
    openssl_1_1
    openssl_1_1.dev
    zlib
    zlib.dev
    readline
    readline.dev
    libffi
    libffi.dev
    bzip2
    bzip2.dev

    # Math Libs
    openblas
    openblas.dev

    # Compiler
    gfortran
  ];
}
