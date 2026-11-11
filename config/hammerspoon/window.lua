local M = {}

hs.window.animationDuration = 0

local function half(x)
  return math.floor(x / 2)
end

function M.isFrame(frame, target, tolerance)
  tolerance = tolerance or 2

  return math.abs(frame.x - target.x) <= tolerance
    and math.abs(frame.y - target.y) <= tolerance
    and math.abs(frame.w - target.w) <= tolerance
    and math.abs(frame.h - target.h) <= tolerance
end

-- +-----------------+
-- |        |        |
-- |  HERE  |        |
-- |        |        |
-- +-----------------+
function M.left(win)
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = half(max.w)
  f.h = max.h
  return f
end

-- +-----------------+
-- |        |        |
-- |        |  HERE  |
-- |        |        |
-- +-----------------+
function M.right(win)
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  local leftWidth = half(max.w)
  f.x = max.x + leftWidth
  f.y = max.y
  f.w = max.w - leftWidth
  f.h = max.h
  return f
end

-- +-----------------+
-- |      HERE       |
-- +-----------------+
-- |                 |
-- +-----------------+
function M.up(win)
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w
  f.h = half(max.h)
  return f
end

-- +-----------------+
-- |                 |
-- +-----------------+
-- |      HERE       |
-- +-----------------+
function M.down(win)
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  local topHeight = half(max.h)
  f.x = max.x
  f.y = max.y + topHeight
  f.w = max.w
  f.h = max.h - topHeight
  return f
end

-- +-----------------+
-- |  HERE  |        |
-- +--------+        |
-- |                 |
-- +-----------------+
function M.upLeft(win)
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = half(max.w)
  f.h = half(max.h)
  return f
end

-- +-----------------+
-- |                 |
-- +--------+        |
-- |  HERE  |        |
-- +-----------------+
function M.downLeft(win)
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  local topHeight = half(max.h)
  f.x = max.x
  f.y = max.y + topHeight
  f.w = half(max.w)
  f.h = max.h - topHeight
  return f
end

-- +-----------------+
-- |                 |
-- |        +--------|
-- |        |  HERE  |
-- +-----------------+
function M.downRight(win)
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  local leftWidth = half(max.w)
  local topHeight = half(max.h)
  f.x = max.x + leftWidth
  f.y = max.y + topHeight
  f.w = max.w - leftWidth
  f.h = max.h - topHeight
  return f
end

-- +-----------------+
-- |        |  HERE  |
-- |        +--------|
-- |                 |
-- +-----------------+
function M.upRight(win)
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  local leftWidth = half(max.w)
  f.x = max.x + leftWidth
  f.y = max.y
  f.w = max.w - leftWidth
  f.h = half(max.h)
  return f
end

return M
