{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.tmux;
  shellCfg = config.my.shell;
in
{
  options.my.tmux = {
    enable = mkEnableOption "Tmux terminal multiplexer" // {
      default = true;
    };

    prefix = mkOption {
      type = types.str;
      default = "C-Space";
      description = "Tmux prefix key combination";
    };

    shell = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Shell to use in tmux sessions. If null, uses the system shell.";
    };

    plugins = mkOption {
      type = types.listOf types.package;
      default = with pkgs.tmuxPlugins; [ vim-tmux-navigator ];
      description = "Tmux plugins to install";
    };

    extraConfig = mkOption {
      type = types.str;
      default = "";
      description = "Additional tmux configuration";
    };
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;

      terminal = "screen-256color";

      prefix = cfg.prefix;
      shortcut = builtins.replaceStrings [ "C-" ] [ "" ] cfg.prefix;

      shell = if cfg.shell != null then cfg.shell else "${pkgs.zsh}/bin/zsh";

      newSession = true;
      baseIndex = 1;
      historyLimit = 100000;
      aggressiveResize = true;
      secureSocket = true;

      sensibleOnTop = true;
      plugins = cfg.plugins;

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
        bind c new-window -c '#{pane_current_path}'

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
      ''
      + cfg.extraConfig;
    };
  };
}
