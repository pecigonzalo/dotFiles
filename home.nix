{ pkgs, ... }:
let
  username = builtins.getEnv "USER";
  homeDirectory = builtins.getEnv "HOME";
in {
  home.username = username;
  home.homeDirectory = homeDirectory;
  # Let Home Manager install and manage itself.
  programs.home-manager = {
    enable = true;
  };

  news.display = "silent";

  home.file = {
    ".profile".source = "${homeDirectory}/dotFiles/.profile";

    ".zlogin".source = "${homeDirectory}/dotFiles/.zlogin";
    ".zshenv".source = "${homeDirectory}/dotFiles/.zshenv";
    ".zshrc".source = "${homeDirectory}/dotFiles/.zshrc";

    ".bash_profile".source = "${homeDirectory}/dotFiles/.bash_profile";
    ".bashrc".source = "${homeDirectory}/dotFiles/.bashrc";

    ".vimrc".source = "${homeDirectory}/dotFiles/.vimrc";

    ".tmux.conf".source = "${homeDirectory}/dotFiles/.tmux.conf";

    ".asdfrc".source = "${homeDirectory}/dotFiles/.asdfrc";
    ".tool-versions".source = "${homeDirectory}/dotFiles/.tool-versions";
    ".default-cloud-sdk-components".source = "${homeDirectory}/dotFiles/.default-cloud-sdk-components";

    ".terraformrc".source = "${homeDirectory}/dotFiles/.terraformrc";

    ".gemrc".source = "${homeDirectory}/dotFiles/.gemrc";
  };

  programs.gh = {
    enable = true;
    editor = "nvim";
    gitProtocol = "ssh";
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
      help.autocorrect = true;
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
    # Local
    (callPackage "${homeDirectory}/dotFiles/nix/loro.nix" {})

    # Buildkite
    buildkite-agent
    buildkite-cli

    # Kafka
    kcli

    # Nix
    rnix-lsp

    # Misc
    neofetch
    nmap
    htop
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
    ansible-lint

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
    awscli2
    aws-nuke
    awless
    eksctl

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

    # Elm
    elmPackages.elm

    # Go
    go
    gopls
    goreleaser
    golangci-lint
  ];
}
