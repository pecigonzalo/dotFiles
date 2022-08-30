{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.my.git;
  isSillicon = pkgs.stdenv.hostPlatform.isDarwin
    && pkgs.stdenv.hostPlatform.isAarch64;
in
{
  options.my.git = {
    enable = mkEnableOption "Git and Friends";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      pre-commit
      git-filter-repo

      # GitHub
      act
    ];

    home.shellAliases = {
      # gitg remove console output
      "gitg" = "gitg >> /dev/null 2>&1";
    };

    programs.ssh = {
      matchBlocks = {
        "github.com" = {
          serverAliveInterval = 60;
          extraOptions = {
            ControlMaster = "auto";
            ControlPersist = "yes";
          };
        };
      };
    };

    programs.gh = {
      enable = true;

      settings = {
        git_protocol = "ssh";
        editor = "nvim";

        aliases = {
          co = "pr checkout";
          pv = "pr view";
          prs = "pr list -A pecigonzalo";
        };
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

        branch = {
          # Automatic remote tracking.
          autoSetupMerge = "always";
          # Automatically use rebase for new branches.
          autoSetupRebase = "always";
        };

        status.showuntrackedfiles = "all";
        push.default = "current";
        pull.rebase = true;
        fetch.prune = true;
        help.autocorrect = 20;
        difftool.prompt = false;

        core = {
          editor = "code --wait";
          whitespace = "trailing-space,space-before-tab";
        };

        color = {
          branch = "auto";
          diff = "auto";
          interactive = "auto";
          status = "auto";
          pager = true;
          ui = "auto";
        };

        diff = {
          algorithm = "minimal";
          compactionHeuristic = true;
          renames = "copies";
          mnemonicprefix = true;
          tool = "vscode";
        };

        difftool = {
          vscode = {
            cmd = "code --wait --diff $LOCAL $REMOTE";
          };
        };

        merge.tool = "vscode";
        mergetool = {
          keepBackup = false;
          vscode = {
            cmd = "code --wait $MERGED";
          };
        };

        rebase = {
          # Support fixup and squash commits.
          autoSquash = "true";
          # Stash dirty worktree before rebase.
          autoStash = "true";
        };

        # Reuse recorded resolutions.
        rerere = {
          enabled = "true";
          autoUpdate = "true";
        };
      };

      aliases = {
        unstage = "reset HEAD";
        gist = "log --graph --oneline --all --decorate --date-order";
        find = "log --graph --oneline --all --decorate --date-order --regexp-ignore-case --extended-regexp --grep";
        rfind = "log --graph --oneline --all --decorate --date-order --regexp-ignore-case --extended-regexp --invert-grep --grep";
        search = "grep --line-number --ignore-case -E -I";
        changelog = "!f() { git log $1 $2 --no-merges --pretty=format:\"* [%H] - %s\"; }; f";
      };

      ignores = [
        # .NET
        ".ionide"

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
  };
}
