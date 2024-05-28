{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.my.shell;

  homeDir = config.home.homeDirectory;
  dotFilesDir = "${homeDir}/dotFiles";
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isSillicon = pkgs.stdenv.hostPlatform.isDarwin
    && pkgs.stdenv.hostPlatform.isAarch64;

  omzRev = "4586808f86bf3bfdf97685380472b63597ce43c0";
  omzPlugin = { name, rev ? omzRev }: {
    name = "ohmyzsh-plugin-${name}";
    src = builtins.fetchGit {
      inherit rev;
      url = "https://github.com/ohmyzsh/ohmyzsh";
    };
    file = "plugins/${name}/${name}.plugin.zsh";
  };
  omzLib = { name, rev ? omzRev }: {
    name = "ohmyzsh-lib-${name}";
    src = builtins.fetchGit {
      inherit rev;
      url = "https://github.com/ohmyzsh/ohmyzsh";
    };
    file = "lib/${name}.zsh";
  };
  gitHubPlugin = { name, owner, rev, file ? null }: {
    inherit name;
    file = if file == null then "${name}.plugin.zsh" else file;
    src = builtins.fetchGit {
      inherit rev;
      url = "https://github.com/${owner}/${name}";
    };
  };
in
{
  options.my.shell = {
    enable = mkEnableOption "Super Shell";
    gitHubPlugins = mkOption {
      type = types.listOf
        (types.submodule {
          options = {
            name = mkOption {
              type = types.str;
            };
            owner = mkOption {
              type = types.str;
            };
            rev = mkOption {
              type = types.str;
            };
            file = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
          };
        });
      default = [ ];
    };
    omzLibs = mkOption {
      type = types.listOf (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
          };
          rev = mkOption {
            type = types.str;
            default = omzRev;
          };
        };
      });
      default = [ ];
    };
    omzPlugins = mkOption {
      type = types.listOf (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
          };
          rev = mkOption {
            type = types.str;
            default = omzRev;
          };
        };
      });
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      defaultKeymap = "emacs";

      # This is taken care of by zinit
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      envExtra = "skip_global_compinit=1";

      dotDir = ".config/zsh";

      initExtraFirst = ''
        zmodload zsh/zprof

        ## SSH
        zstyle :omz:plugins:ssh-agent identities pecigonzalo_ed25519 pecigonzalo_rsa
      '' + pkgs.lib.optionalString
        isDarwin "zstyle :omz:plugins:ssh-agent ssh-add-args --apple-use-keychain # NOTE: OSX Only";


      initExtra = ''
        # ZSH profiling
        autoload -U colors && colors

        # Load env
        source "${dotFilesDir}/zsh/env.zsh"

        # Get funtions
        source "${dotFilesDir}/zsh/functions.zsh"

        # If on WSL, load
        if [[ -n "$WSL_DISTRO_NAME" ]]; then
          source "${dotFilesDir}/wsl/wslrc.zsh"
        fi
      '' + pkgs.lib.optionalString isDarwin ''
        source "${dotFilesDir}/macOS/macosrc.zsh"
      '' + ''
        # Set ZSH opts
        source "${dotFilesDir}/zsh/opts.zsh"

        # Set ZSH zstyle
        source "${dotFilesDir}/zsh/zstyle.zsh"

        # Set Keyboard
        source "${dotFilesDir}/zsh/keyboard.zsh"

        # Set Local
        source "${dotFilesDir}/zsh/local.zsh"
      '' + ''
        # ZSH profiling save
        zprof >/tmp/zprof
      '';

      history = {
        size = 5000000;
        save = 5000000;
        path = "${homeDir}/.histfile";
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
            "${homeDir}/.local/bin"
            # Go
            "${homeDir}/Workspace/go/bin"
            # K8s Krew
            "${homeDir}/.krew/bin"
            # Snowflake SnowSQL
            "/Applications/SnowSQL.app/Contents/MacOS"
            # Brew
            "/opt/homebrew/bin"
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
          "functions"
          "key-bindings"
          "clipboard"
          "termsupport"
        ]) ++
        (map omzLib cfg.omzLibs) ++
        (map (name: omzPlugin { name = name; }) [
          "aws"
          "common-aliases"
          "docker-compose"
          "rsync"
          "ssh-agent"
          "urltools"
          "vscode"
        ]) ++
        (map omzPlugin cfg.omzPlugins) ++
        [
          (gitHubPlugin {
            name = "zsh-z";
            owner = "agkozak";
            rev = "b5e61d03a42a84e9690de12915a006b6745c2a5f";
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
        ] ++
        (map gitHubPlugin cfg.gitHubPlugins);
    };
  };
}
