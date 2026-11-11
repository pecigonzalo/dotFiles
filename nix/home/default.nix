{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.my.paths) mkDotFileLink;

  treeSitterGrammarSources = pkgs.linkFarm "tree-sitter-grammar-sources" (
    pkgs.lib.mapAttrsToList (name: grammar: {
      inherit name;
      path = grammar.src;
    }) pkgs.tree-sitter.grammars
  );
in
{
  news.display = "silent";

  imports = [
    ./ssh.nix
    ./terminal.nix
    ./fonts.nix
    ./karabiner.nix
    ./colima.nix
    ./packages
  ];

  xdg.enable = true;
  xdg.configFile."tree-sitter/config.json".text = builtins.toJSON {
    parser-directories = [ "${treeSitterGrammarSources}" ];
  };

  services.syncthing = lib.mkIf pkgs.stdenv.isDarwin {
    enable = true;
    overrideDevices = false;
    overrideFolders = false;
    settings.options.urAccepted = -1;
    settings.options = {
      globalAnnounceEnabled = false;
      localAnnounceEnabled = true;
      relaysEnabled = false;
      natEnabled = false;
    };

  };

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
    dotnet.enable = true;
    zig.enable = true;
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

    file = {
      ".tool-versions".source = mkDotFileLink ".tool-versions";
      ".gemrc".source = mkDotFileLink ".gemrc";

      ".psqlrc".source = mkDotFileLink ".psqlrc";
      ".textlintrc".source = mkDotFileLink ".textlintrc";

      ".asdfrc".text = ''
        legacy_version_file = yes
      '';

      ".parallel/will-cite".text = ""; # Stop `parallel` from displaying citation warning
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
      ".hammerspoon".source = mkDotFileLink ".hammerspoon";
    };
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    bash.enable = true;

    htop = {
      enable = true;
      settings.show_program_path = true;
    };

    bat = {
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

    ripgrep = {
      enable = true;
      arguments = [
        "--smart-case"
        "--follow"
      ];
    };
  };
}
