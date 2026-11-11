local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder and wezterm.config_builder() or {}
local FONT_SIZE = 14
local HYPER_MODS = "SUPER|ALT|CTRL|SHIFT"
local URL_QUICK_SELECT_PATTERN = 'https?://[^\\s<>"]+[^\\s<>",.)]'

local function get_process_name(path)
  if not path or path == "" then return "" end

  return path:match("([^/\\]+)$") or path
end

local function get_tab_title(tab)
  if tab.tab_title and tab.tab_title ~= "" then return tab.tab_title end

  if tab.active_pane and tab.active_pane.title then return tab.active_pane.title end

  return ""
end

local function is_vim(pane)
  local process_name = get_process_name(pane:get_foreground_process_name())
  return process_name == "vim" or process_name == "nvim"
end

local function open_selected_url(window, pane)
  local url = window:get_selection_text_for_pane(pane)
  if url == "" then return end

  wezterm.log_info("opening: " .. url)
  wezterm.open_with(url)
  window:perform_action(act.ClearSelection, pane)
end

wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
  local title = " " .. get_tab_title(tab)

  if tab.active_pane and tab.active_pane.is_zoomed then title = title .. " [Z]" end

  title = title .. " "

  if max_width and wezterm.truncate_right then title = wezterm.truncate_right(title, max_width) end

  return title
end)

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
  -- Open in current cwd
  { key = "t", mods = "CTRL", action = act.SpawnTab("CurrentPaneDomain") },
  -- Open in home
  {
    key = "t",
    mods = "SHIFT|CTRL",
    action = act.SpawnCommandInNewTab({ cwd = wezterm.home_dir, domain = "CurrentPaneDomain" }),
  },
  {
    key = "w",
    mods = "CTRL",
    action = wezterm.action_callback(function(window, pane)
      if is_vim(pane) then
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
  { key = "Enter", mods = "ALT", action = act.DisableDefaultAssignment },
  { key = "Enter", mods = "CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "Enter", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "l", mods = "CTRL|SHIFT", action = act.ShowDebugOverlay },
  { key = "k", mods = "SUPER", action = act.ActivateCommandPalette },
  {
    key = "o",
    mods = "CTRL|SHIFT",
    action = act({
      QuickSelectArgs = {
        patterns = {
          URL_QUICK_SELECT_PATTERN,
        },
        action = wezterm.action_callback(open_selected_url),
      },
    }),
  },
  { key = "z", mods = HYPER_MODS, action = act.TogglePaneZoomState },
}

local quick_select_patterns = {
  "sha256-[0-9a-zA-Z+=]{44}",
}

local MAIN_FONT = wezterm.font({ family = "FiraCode Nerd Font" })

config.color_scheme = "Dracula (Official)"
config.font = MAIN_FONT
config.font_size = FONT_SIZE
config.scrollback_lines = 100000
config.keys = keys
config.key_tables = key_tables

-- Window options
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "RESIZE"
config.animation_fps = 60
config.max_fps = 120
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.75,
}
config.audible_bell = "Disabled"
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.window_frame = {
  font = MAIN_FONT,
  font_size = FONT_SIZE,
}

-- Tab bar options
config.use_fancy_tab_bar = true
config.tab_max_width = 24
config.tab_bar_at_bottom = false

config.quick_select_patterns = quick_select_patterns

return config
