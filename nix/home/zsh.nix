{ config, pkgs, ... }:

let
  homedir = config.home.homeDirectory;

  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;

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

    defaultKeymap = "emacs";

    # This is taken care of by zinit
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    envExtra = "skip_global_compinit=1";

    dotDir = ".config/zsh";

    initExtraFirst = ''
      zmodload zsh/zprof

      ## SSH
      zstyle :omz:plugins:ssh-agent identities pecigonzalo_ed25519 pecigonzalo_rsa
    '' + pkgs.lib.optionalString
      isDarwin "zstyle :omz:plugins:ssh-agent ssh-add-args --apple-use-keychain # NOTE: OSX Only";


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
      source "${homedir}/dotFiles/zsh/zshrc"

      # ZSH profiling save
      zprof >/tmp/zprof
    '';

    history = {
      size = 5000000;
      save = 5000000;
      path = "${homedir}/.histfile";
      ignorePatterns = [
        "ls"
        "cd"
        "cd -"
        "pwd"
        "exit"
        "date"
        "* --help"
        "man *"
        "zstyle *"
      ];
    };

    shellAliases = {
      # Reload
      "reshell!" = "exec $SHELL -l";
    };

    sessionVariables =
      let
        preSessionPath = [
          "${homedir}/.local/bin"
          # Go
          "${homedir}/Workspace/go/bin"
          # K8s Krew
          "${homedir}/.krew/bin"
          # Snowflake SnowSQL
          "/Applications/SnowSQL.app/Contents/MacOS"
          # System
          "$PATH"
        ];
        userPath = builtins.concatStringsSep ":" preSessionPath;
      in
      {
        # Path
        PATH = userPath;

        # Correction settings
        CORRECT_IGNORE = "_*";
        CORRECT_IGNORE_FILE = ".*";

        # Uncomment the following line if you want to disable marking untracked files
        # under VCS as dirty. This makes repository status check for large repositories
        # much, much faster.
        DISABLE_UNTRACKED_FILES_DIRTY = "true";

        # OMZ
        DISABLE_UPDATE_PROMPT = "true";
        DISABLE_AUTO_UPDATE = "true";
        SHOW_AWS_PROMPT = "false"; # Disable OMZ prompt

        # Tipz
        TIPZ_TEXT = "💡";

        # zsh-autosuggestions
        ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE = 20;
        ZSH_AUTOSUGGEST_USE_ASYNC = "true";

        # zsh-z, fz
        ZSHZ_NO_RESOLVE_SYMLINKS = 1;
        ZSHZ_TILDE = 1;
        ZSHZ_TRAILING_SLASH = 1;
        ZSHZ_UNCOMMON = 1;
      };

    plugins =
      (map (name: omzLib { name = name; }) [
        "git"
        "key-bindings"
        "clipboard"
        "termsupport"
      ]) ++
      (map (name: omzPlugin { name = name; }) [
        "aws"
        "common-aliases"
        "docker-compose"
        "git-auto-fetch"
        "git-flow"
        "git"
        "rsync"
        "ssh-agent"
        "urltools"
        "vscode"
      ]) ++
      [
        (gitHubPlugin {
          name = "zsh-z";
          owner = "agkozak";
          rev = "b5e61d03a42a84e9690de12915a006b6745c2a5f";
        })
        (gitHubPlugin {
          name = "emoji-cli";
          owner = "b4b4r07";
          rev = "0fbb2e48e07218c5a2776100a4c708b21cb06688";
        })
        (gitHubPlugin {
          name = "fzf-tab";
          owner = "Aloxaf";
          rev = "103330fdbeba07416d5f90b391eee680cd20d2d6";
        })
        (gitHubPlugin {
          name = "forgit";
          owner = "wfxr";
          rev = "eed197948cc58b5bc388c1ebb1559431898a6221";
        })
        (gitHubPlugin {
          name = "jq-zsh-plugin";
          owner = "reegnz";
          rev = "9de99b0bc6dd33b1a560ce9cfe755c52f4217f72";
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
