{ pkgs, lib, ... }:
{
  imports = [
    # Minimal config of Nix related options and shells
    ./bootstrap.nix
    ./nix.nix

    # Other nix-darwin configuration
    ./homebrew.nix
    ./system.nix
    ./cachix.nix
  ];

  programs.nix-index.enable = true;

  environment.pathsToLink = [
    # "/sbin"
    "/lib"
    "/include"
    # Completions
    "/share/fish"
    "/share/bash-completion"
    "/share/zsh"
  ];

  services.yabai = {
    enable = false;
    package = pkgs.yabai;
    config = {
      # layout
      layout = "bsp";
      auto_balance = "on";
      split_ratio = "0.50";
      window_placement = "second_child";
      # Gaps
      window_gap = 16;
      top_padding = 24 + 16;
      bottom_padding = 16;
      left_padding = 16;
      right_padding = 16;
      # shadows and borders
      window_shadow = "on";
      window_border = "off";
      window_border_width = 3;
      window_opacity = "on";
      window_opacity_duration = "0.1";
      active_window_opacity = "1.0";
      normal_window_opacity = "1.0";
      # mouse
      # mouse_modifier = "cmd";
      # mouse_action1 = "move";
      # mouse_action2 = "resize";
      mouse_drop_action = "swap";
    };
  };

  services.spacebar = {
    enable = false;
    package = pkgs.spacebar;
    config = {
      position = "top";
      height = 24;
      title = "on";
      spaces = "on";
      power = "on";
      clock = "on";
      right_shell = "off";
      padding_left = 16;
      padding_right = 16;
      spacing_left = 24;
      spacing_right = 24;
      text_font = ''"FiraCode Nerd Font:16.0"'';
      icon_font = ''"FiraCode Nerd Font:16.0"'';
      background_color = "0xFF282A36";
      foreground_color = "0xFFF8F8F2";
      space_icon_color = "0xFF44475A";
      power_icon_strip = " ";
      space_icon_strip = "一 二 三 四 五 六 七 八 九 十";
      spaces_for_all_displays = "on";
      display_separator = "on";
      display_separator_icon = "|";
      clock_format = ''"%d/%m/%y %R"'';
      right_shell_icon = " ";
      right_shell_command = "whoami";
    };
  };

  programs.bash.enable = true;
  programs.zsh = {
    enable = true;
    promptInit = ""; # Disable default theme, we use a custom one
    enableCompletion = false;
    enableBashCompletion = false;
  };

  programs.tmux = {
    enable = true;
    enableFzf = true;
    enableMouse = true;
    enableSensible = true;
  };
}
