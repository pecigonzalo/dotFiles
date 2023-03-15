local wezterm = require("wezterm")
local act = wezterm.action

local keys = {
    {
        mods = "CTRL",
        key = "c",
        action = wezterm.action_callback(function(window, pane)
            local sel = window:get_selection_text_for_pane(pane)
            if not sel or sel == "" then
                window:perform_action(act.SendKey({ mods = "CTRL", key = "c" }), pane)
            else
                window:perform_action(act({ CopyTo = "ClipboardAndPrimarySelection" }), pane)
            end
        end),
    },
    { key = "Enter", mods = "CTRL", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
    { key = "Enter", mods = "CTRL|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
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
