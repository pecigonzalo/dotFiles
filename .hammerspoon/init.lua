hs.alert("Loading the Hammer")

-- Load EmmyLua
-- hs.loadSpoon("EmmyLua")

local hyper = require("hyper")
local keymap = require("keymap")

for _, value in ipairs(keymap.hyper) do
  local mod, key, fn = table.unpack(value)
  hyper.bind(mod, key, fn)
end
