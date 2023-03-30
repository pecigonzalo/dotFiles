local wezterm = require("wezterm")
local act = wezterm.action

local keys = {
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
  { key = "Enter", mods = "CTRL",       action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "Enter", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  {
    key = "P",
    mods = "CTRL",
    action = wezterm.action({
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

return {
  color_scheme = "Dracula (Official)",
  window_frame = {
    font = wezterm.font({ family = "FiraCode Nerd Font" }),
    font_size = 14,
  },
  font = wezterm.font({ family = "FiraCode Nerd Font" }),
  font_size = 14,
  scrollback_lines = 10000,
  keys = keys,
}
