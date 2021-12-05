{ config, pkgs, ... }:

let
  homedir = config.home.homeDirectory;

  omzRev = "5e8905b4b22dfec9042590f3aa399935b8b83eed";
  omzPlugin = { name }: {
    name = "ohmyzsh-plugin-${name}";
    src = builtins.fetchGit {
      url = "https://github.com/ohmyzsh/ohmyzsh";
      rev = omzRev;
    };
    file = "plugins/${name}/${name}.plugin.zsh";
  };
  omzLib = { name }: {
    name = "ohmyzsh-lib-${name}";
    src = builtins.fetchGit {
      url = "https://github.com/ohmyzsh/ohmyzsh";
      rev = omzRev;
    };
    file = "lib/${name}.zsh";
  };
  gitHubPlugin = { name, owner, rev, file ? "${name}.plugin.zsh" }: {
    inherit name file;
    src = builtins.fetchGit {
      inherit rev;
      url = "https://github.com/${owner}/${name}";
    };
  };
in
{
  programs.zsh = {
    enable = true;

    # This is taken care of by zinit
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    envExtra = "skip_global_compinit=1";

    dotDir = ".config/zsh";

    initExtraFirst = ''
      zmodload zsh/zprof

      ## SSH
      zstyle :omz:plugins:ssh-agent ssh-add-args -K # NOTE: OSX Only
      zstyle :omz:plugins:ssh-agent identities pecigonzalo_ed25519 pecigonzalo_rsa
    '';

    initExtra = ''
      ## Others
      _fzf_compgen_path() {
        fd --hidden --follow --exclude ".git" . "$1"
      }

      # Use fd to generate the list for directory completion
      _fzf_compgen_dir() {
        fd --type d --hidden --follow --exclude ".git" . "$1"
      }

      # ASDF
      source "${homedir}/.nix-profile/etc/profile.d/asdf-prepare.sh"

      # Dynamic load
      source ${homedir}/dotFiles/zsh/zshrc

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

    plugins = [
      (omzLib { name = "git"; })
      (omzLib { name = "key-bindings"; })
      (omzLib { name = "clipboard"; })
      (omzLib { name = "termsupport"; })
      (omzPlugin { name = "ssh-agent"; })
      (omzPlugin { name = "git"; })
      (omzPlugin { name = "git-auto-fetch"; })
      (omzPlugin { name = "gitignore"; })
      (omzPlugin { name = "git-flow"; })
      (omzPlugin { name = "docker-compose"; })
      (omzPlugin { name = "common-aliases"; })
      (omzPlugin { name = "sudo"; })
      (omzPlugin { name = "rsync"; })
      (omzPlugin { name = "urltools"; })
      (omzPlugin { name = "aws"; })
      (gitHubPlugin {
        name = "zsh-z";
        owner = "agkozak";
        rev = "b1055fb773d5b4bf4756dca6f4c9a9a6779a0d63";
      })
      (gitHubPlugin {
        name = "emoji-cli";
        owner = "b4b4r07";
        rev = "0fbb2e48e07218c5a2776100a4c708b21cb06688";
      })
      (gitHubPlugin {
        name = "fzf-tab";
        owner = "Aloxaf";
        rev = "e3fae7478fc365a04a06b9972b04766ffed78c1c";
      })
      (gitHubPlugin {
        name = "forgit";
        owner = "wfxr";
        rev = "b727321f2bd3d79c1dae805441261c45888cbb41";
      })
      (gitHubPlugin {
        name = "fz";
        owner = "changyuheng";
        rev = "2a4c1bc73664bb938bfcc7c99f473d0065f9dbfd";
      })
      (gitHubPlugin {
        name = "jq-zsh-plugin";
        owner = "reegnz";
        rev = "79c0ebc6fd6dbacfc2244dace095af58f2d0cd58";
        file = "jq.plugin.zsh";
      })
      (gitHubPlugin {
        name = "tipz";
        owner = "molovo";
        rev = "594eab4642cc6dcfe063ecd51d76478bd84e2878";
        file = "tipz.zsh";
      })
    ];
  };
}
