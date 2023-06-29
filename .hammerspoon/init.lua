hs.alert("Loading the Hammer")

-- Load EmmyLua
-- hs.loadSpoon("EmmyLua")

local hyper = require("hyper")
local keymap = require("keymap")

-- Hyper shortcuts
for _, value in ipairs(keymap.hyper) do
  local mod, key, fn = table.unpack(value)
  hyper.bind(mod, key, fn)
end

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
