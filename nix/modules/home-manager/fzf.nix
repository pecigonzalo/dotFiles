{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
# with pkgs.lib.my;
let
  homeDir = config.home.homeDirectory;
  cfg = config.my.fzf;
in
{
  options.my.fzf = {
    enable = mkEnableOption "FZF tools";
  };

  config = mkIf cfg.enable {
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
        "--preview '(bat --style=numbers --color=always --line-range :500 {} || eza --tree --level=4 {}) 2> /dev/null'"
        "--select-1"
        "--exit-0"
      ];

      changeDirWidgetCommand = "fd --type directory --color=always . ${homeDir}";
      changeDirWidgetOptions = [
        "--preview 'eza --tree --level=4 {} | head -200'"
      ];
    };
    programs.zsh = {
      initContent = ''
        ## Others
        _fzf_compgen_path() {
          fd --hidden --follow --exclude ".git" . "$1"
        }

        # Use fd to generate the list for directory completion
        _fzf_compgen_dir() {
          fd --type d --hidden --follow --exclude ".git" . "$1"
        }

        # ASDF
        source "${pkgs.asdf-vm}/etc/profile.d/asdf-prepare.sh"
      '';
    };

    my.shell.gitHubPlugins = [
      {
        name = "fzf-tab";
        owner = "Aloxaf";
        rev = "c2b4aa5ad2532cca91f23908ac7f00efb7ff09c9";
      }
    ];
  };
}
