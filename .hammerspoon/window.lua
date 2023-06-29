local M = {}

hs.window.animationDuration = 0

function half(x)
  return math.floor(x / 2)
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

  f.x = max.x + half(max.w)
  f.y = max.y
  f.w = half(max.w)
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

  f.x = max.x
  f.y = max.y + half(max.h)
  f.w = max.w
  f.h = half(max.h)
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

  f.x = max.x
  f.y = max.y + half(max.h)
  f.w = half(max.w)
  f.h = half(max.h)
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

  f.x = max.x + half(max.w)
  f.y = max.y + half(max.h)
  f.w = half(max.w)
  f.h = half(max.h)
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

  f.x = max.x + half(max.w)
  f.y = max.y
  f.w = half(max.w)
  f.h = half(max.h)
  return f
end

return M
