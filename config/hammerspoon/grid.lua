local M = {}

hs.grid.setMargins(hs.geometry.size(0, 0))
hs.grid.setGrid("6x4")
hs.grid.HINTS = {
  -- Fake
  { "x", "c", "v", "m", ",", "." },
  -- Real
  { "2", "3", "4", "7", "8", "9" },
  { "w", "e", "r", "u", "i", "o" },
  { "s", "d", "f", "j", "k", "l" },
  { "x", "c", "v", "m", ",", "." },
}

return M
