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
  hs.hotkey.bind(hyper, key, function() hs.application.launchOrFocus(app) end)
end

hs.hotkey.bind(hyper, "tab", function()
  local win = hs.window.focusedWindow()
  local nextScreen = win:screen():next()
  win:moveToScreen(nextScreen)
end)

-- Remaps
-- for _, value in ipairs(keymap.remap) do
--   local from, to, shouldEnable = table.unpack(value)
--
--   local fromMod, fromKey = table.unpack(from)
--   local toMod, toKey = table.unpack(to)
--
--   local function wrapper()
--     if shouldEnable and shouldEnable() then
--       keymap.keyPress(toMod, toKey)
--     else
--       keymap.keyPress(fromMod, fromKey)
--     end
--   end
--
--   hs.hotkey.bind(fromMod, fromKey, nil, wrapper)
--w end
