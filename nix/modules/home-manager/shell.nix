{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.shell;

  homeDir = config.home.homeDirectory;
  dotFilesDir = "${homeDir}/dotFiles";
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isSillicon = pkgs.stdenv.hostPlatform.isDarwin && pkgs.stdenv.hostPlatform.isAarch64;

  omzRev = "9114853500ea66cff7c803b0e951754833946f3d";
  omzPlugin =
    {
      name,
      rev ? omzRev,
    }:
    {
      name = "ohmyzsh-plugin-${name}";
      src = builtins.fetchGit {
        inherit rev;
        url = "https://github.com/ohmyzsh/ohmyzsh";
      };
      file = "plugins/${name}/${name}.plugin.zsh";
    };
  omzLib =
    {
      name,
      rev ? omzRev,
    }:
    {
      name = "ohmyzsh-lib-${name}";
      src = builtins.fetchGit {
        inherit rev;
        url = "https://github.com/ohmyzsh/ohmyzsh";
      };
      file = "lib/${name}.zsh";
    };
  gitHubPlugin =
    {
      name,
      owner,
      rev,
      file ? null,
    }:
    {
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
      type = types.listOf (
        types.submodule {
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
        }
      );
      default = [ ];
    };
    omzLibs = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            name = mkOption {
              type = types.str;
            };
            rev = mkOption {
              type = types.str;
              default = omzRev;
            };
          };
        }
      );
      default = [ ];
    };
    omzPlugins = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            name = mkOption {
              type = types.str;
            };
            rev = mkOption {
              type = types.str;
              default = omzRev;
            };
          };
        }
      );
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    home.shell.enableZshIntegration = true;
    home.shell.enableFishIntegration = true;
    home.shell.enableNushellIntegration = true;

    programs.fish = {
      enable = true;
    };
    programs.nushell = {
      enable = true;
      plugins = with pkgs.nushellPlugins; [
        formats
        query
      ];
      settings = {
        show_banner = false;
        completions.external = {
          enable = true;
          max_results = 200;
        };
      };
      # Override aliases
      shellAliases = lib.mkForce { };
    };
    programs.zsh = {
      enable = true;

      defaultKeymap = "viins";

      # This is taken care of by zinit
      enableCompletion = true;
      autosuggestion = {
        enable = true;
      };
      syntaxHighlighting.enable = true;
      envExtra = "skip_global_compinit=1";

      initContent = lib.mkMerge [
        (lib.mkBefore ''
          if [[ -n "$ZSH_DEBUG_RC" ]]; then
            zmodload zsh/zprof
          fi

          ## SSH
          zstyle :omz:plugins:ssh-agent identities pecigonzalo_ed25519 pecigonzalo_rsa
        '')
        (lib.mkBefore (
          optionalString isDarwin ''
            zstyle :omz:plugins:ssh-agent ssh-add-args --apple-use-keychain # NOTE: OSX Only
          ''
        ))

        ''
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
        ''

        (pkgs.lib.optionalString isDarwin ''
          source "${dotFilesDir}/zsh/macosrc.zsh"
        '')

        ''
          # Set ZSH opts
          source "${dotFilesDir}/zsh/opts.zsh"

          # Set ZSH zstyle
          source "${dotFilesDir}/zsh/zstyle.zsh"

          # Set Keyboard
          source "${dotFilesDir}/zsh/keyboard.zsh"

          # Set Local
          source "${dotFilesDir}/zsh/local.zsh"
        ''

        (lib.mkAfter ''
          # ZSH profiling save
          if [[ -n "$ZSH_DEBUG_RC" ]]; then
            zprof >/tmp/zprof
          fi
        '')
      ];

      history = {
        size = 5000000;
        save = 5000000;
        path = "${homeDir}/.histfile";
        ignorePatterns = [
          "ls"
          "cd *"
          "cd -"
          "pwd"
          "exit"
          "date"
          "* --help"
          "man *"
          "zstyle *"
          "chamber *"
          "rm *"
          "pkill *"
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

          # Faster vim change
          KEYTIMEOUT = 1;
        };

      plugins =
        (map (name: omzLib { name = name; }) [
          "functions"
          "key-bindings"
          "clipboard"
          "termsupport"
        ])
        ++ (map omzLib cfg.omzLibs)
        ++ (map (name: omzPlugin { name = name; }) [
          "aws"
          "common-aliases"
          "docker-compose"
          "rsync"
          "ssh-agent"
          "urltools"
          "vscode"
          "vi-mode"
        ])
        ++ (map omzPlugin cfg.omzPlugins)
        ++ [
          (gitHubPlugin {
            name = "zsh-z";
            owner = "agkozak";
            rev = "cf9225feebfae55e557e103e95ce20eca5eff270";
          })
          (gitHubPlugin {
            name = "jq-zsh-plugin";
            owner = "reegnz";
            rev = "ded47a1e51303fb2cb331288e134e18f637274a6";
            file = "jq.plugin.zsh";
          })
        ]
        ++ (map gitHubPlugin cfg.gitHubPlugins);
    };
  };
}
