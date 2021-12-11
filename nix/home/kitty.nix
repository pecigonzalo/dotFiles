{ config, pkgs, ... }:

let
  dracula-colors = {
    "foreground" =            "#f8f8f2";
    "background" =            "#282a36";
    "selection_foreground" =  "#ffffff";
    "selection_background" =  "#44475a";

    "url_color" = "#8be9fd";

    # black
    "color0" =  "#21222c";
    "color8" =  "#6272a4";

    # red
    "color1" =  "#ff5555";
    "color9" =  "#ff6e6e";

    # green
    "color2" =  "#50fa7b";
    "color10" = "#69ff94";

    # yellow
    "color3" =  "#f1fa8c";
    "color11" = "#ffffa5";

    # blue
    "color4" =  "#bd93f9";
    "color12" = "#d6acff";

    # magenta
    "color5" =  "#ff79c6";
    "color13" = "#ff92df";

    # cyan
    "color6" =  "#8be9fd";
    "color14" = "#a4ffff";

    # white
    "color7" =  "#f8f8f2";
    "color15" = "#ffffff";

    # Cursor colors
    "cursor" =            "#f8f8f2";
    "cursor_text_color" = "background";

    # Tab bar colors
    "active_tab_foreground" =   "#282a36";
    "active_tab_background" =   "#f8f8f2";
    "inactive_tab_foreground" = "#282a36";
    "inactive_tab_background" = "#6272a4";

    # Marks
    "mark1_foreground" = "#282a36";
    "mark1_background" = "#ff5555";

  };
in
{
  programs.kitty = {
    enable = true;

    font.name = "FiraCode Nerd Font";

    settings = {
      term = "xterm-256color";
      scrollback_lines = 10000;
      background_opacity = "0.98";

      font_size = 14;
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      strip_trailing_spaces = "smart";

      enable_audio_bell = true;

      macos_option_as_alt = true;
      macos_quit_when_last_window_closed = true;

      allow_hyperlinks = true;

      enabled_layouts = "splits";
    } // dracula-colors;

    keybindings = {
      # jump to beginning and end of word
      "alt+left" = "send_text all \x1b\x62";
      "alt+right" = "send_text all \x1b\x66";
      # jump to beginning and end of line
      "cmd+left" = "send_text all \x01";
      "cmd+right" = "send_text all \x05";
    };
  };
}
