{ config, pkgs, ... }:

let
  homedir = config.home.homeDirectory;
in
{
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

    changeDirWidgetCommand = "fd --type directory --color=always . ${homedir}";
    changeDirWidgetOptions = [
      "--preview 'exa --tree --level=4 {} | head -200'"
    ];
  };
}
