hs.alert("Loading the Hammer")
-- Generate annotations
-- hs.loadSpoon("EmmyLua")

-- Configure the grid
require("grid")

local hyper = { "cmd", "alt", "ctrl", "shift" }
local keymap = require("keymap")

-- Hyper shortcuts
for _, value in ipairs(keymap.hyper) do
  local key, fn = table.unpack(value)
  hs.hotkey.bind(hyper, key, fn)
end

-- Application Launcher
for key, app in pairs(keymap.applications) do
  print("binding=" .. key .. " app=" .. app)
  hs.hotkey.bind(hyper, key, function()
    print("Launching App: " .. app)
    hs.application.launchOrFocus(app)
  end)
end

hs.hotkey.bind(hyper, "tab", function()
  local win = hs.window.focusedWindow()
  local nextScreen = win:screen():next()
  win:moveToScreen(nextScreen)
end)
