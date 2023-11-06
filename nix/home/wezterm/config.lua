local wezterm = require("wezterm")
local act = wezterm.action

local key_tables = {
  neovim = {
    { key = "h", action = act.ActivatePaneDirection("Left") },
    { key = "l", action = act.ActivatePaneDirection("Right") },
    { key = "j", action = act.ActivatePaneDirection("Down") },
    { key = "k", action = act.ActivatePaneDirection("Up") },
    {
      key = "r",
      action = act.ActivateKeyTable({
        name = "resize",
        one_shot = false,
      }),
    },
    { key = "Escape", action = act.PopKeyTable },
  },
  resize = {
    { key = "h", action = act.AdjustPaneSize({ "Left", 5 }) },
    { key = "l", action = act.AdjustPaneSize({ "Right", 5 }) },
    { key = "j", action = act.AdjustPaneSize({ "Down", 5 }) },
    { key = "k", action = act.AdjustPaneSize({ "Up", 5 }) },
    { key = "Escape", action = act.PopKeyTable },
  },
}

local keys = {
  {
    key = "w",
    mods = "CTRL",
    action = wezterm.action_callback(function(window, pane)
      local isVim = pane:get_foreground_process_name():find("n?vim") ~= nil
      if isVim then
        window:perform_action(act.SendKey({ key = "w", mods = "CTRL" }), pane)
      else
        window:perform_action(
          act.ActivateKeyTable({
            name = "neovim",
            timeout_milliseconds = 500,
          }),
          pane
        )
      end
    end),
  },
  {
    key = "c",
    mods = "CTRL",
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ""
      if has_selection then
        window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)

        window:perform_action(act.ClearSelection, pane)
      else
        window:perform_action(act.SendKey({ key = "c", mods = "CTRL" }), pane)
      end
    end),
  },
  { key = "Enter", mods = "CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "Enter", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "l", mods = "CTRL|SHIFT", action = act.ShowDebugOverlay },
  {
    key = "p",
    mods = "CTRL|SHIFT",
    action = act({
      QuickSelectArgs = {
        patterns = {
          "https?://\\S+",
        },
        action = wezterm.action_callback(function(window, pane)
          local url = window:get_selection_text_for_pane(pane)
          wezterm.log_info("opening: " .. url)
          wezterm.open_with(url)
        end),
      },
    }),
  },
}

local quick_select_patterns = {
  "sha256-[0-9a-zA-Z+=]{44}",
}

local main_font = wezterm.font({ family = "FiraCode Nerd Font" })

return {
  color_scheme = "Dracula (Official)",
  font = main_font,
  font_size = 14,
  scrollback_lines = 10000,
  keys = keys,
  key_tables = key_tables,
  -- Window options
  adjust_window_size_when_changing_font_size = false,
  use_fancy_tab_bar = true,
  tab_max_width = 24,
  tab_bar_at_bottom = false,
  window_frame = {
    font = main_font,
    font_size = 14,
  },
  window_decorations = "RESIZE",
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  quick_select_patterns = quick_select_patterns,
}
