local window = require("window")

local M = {}
local expose = hs.expose.new(nil, { showThumbnails = true, includeOtherSpaces = false })

M.applications = {
  T = "WezTerm.app",
  S = "Slack",
  P = "Microsoft Edge.app",
  B = "Google Chrome.app",
  C = "Google Calendar.app",
  E = "Google Mail.app",
  M = "Spotify.app",
  W = "WhatsApp Web.app",
}

M.hyper = {
  { "R", hs.reload },

  -- Expose
  {
    "Return",
    function() expose:toggleShow() end,
  },

  -- Grid
  { "Space", hs.grid.show },

  -- Simple Tiling
  {
    "Left",
    function()
      local win = hs.window.focusedWindow()
      if not win then return end

      local f = win:frame()

      if window.isFrame(f, window.up(win)) then
        win:setFrame(window.upLeft(win))
        return
      elseif window.isFrame(f, window.upRight(win)) then
        win:setFrame(window.up(win))
        return
      elseif window.isFrame(f, window.down(win)) then
        win:setFrame(window.downLeft(win))
        return
      elseif window.isFrame(f, window.downRight(win)) then
        win:setFrame(window.down(win))
        return
      end

      win:setFrame(window.left(win))
    end,
  },

  {
    "Right",
    function()
      local win = hs.window.focusedWindow()
      if not win then return end

      local f = win:frame()

      if window.isFrame(f, window.up(win)) then
        win:setFrame(window.upRight(win))
        return
      elseif window.isFrame(f, window.upLeft(win)) then
        win:setFrame(window.up(win))
        return
      elseif window.isFrame(f, window.down(win)) then
        win:setFrame(window.downRight(win))
        return
      elseif window.isFrame(f, window.downLeft(win)) then
        win:setFrame(window.down(win))
        return
      end

      win:setFrame(window.right(win))
    end,
  },

  {
    "Up",
    function()
      local win = hs.window.focusedWindow()
      if not win then return end

      local f = win:frame()

      if window.isFrame(f, window.up(win)) then
        win:maximize()
        return
      elseif window.isFrame(f, window.left(win)) then
        win:setFrame(window.upLeft(win))
        return
      elseif window.isFrame(f, window.right(win)) then
        win:setFrame(window.upRight(win))
        return
      elseif window.isFrame(f, window.downRight(win)) then
        win:setFrame(window.right(win))
        return
      elseif window.isFrame(f, window.downLeft(win)) then
        win:setFrame(window.left(win))
        return
      end

      win:setFrame(window.up(win))
    end,
  },

  {
    "Down",
    function()
      local win = hs.window.focusedWindow()
      if not win then return end

      local f = win:frame()

      if window.isFrame(f, window.left(win)) then
        win:setFrame(window.downLeft(win))
        return
      elseif window.isFrame(f, window.right(win)) then
        win:setFrame(window.downRight(win))
        return
      elseif window.isFrame(f, window.upRight(win)) then
        win:setFrame(window.right(win))
        return
      elseif window.isFrame(f, window.upLeft(win)) then
        win:setFrame(window.left(win))
        return
      end

      win:setFrame(window.down(win))
    end,
  },

  -- Debug hotkey
  {
    "`",
    function()
      local win = hs.window.focusedWindow()
      if not win then return end

      print("x: " .. win:frame().x)
      print("y: " .. win:frame().y)
      print("w: " .. win:frame().w)
      print("h: " .. win:frame().h)
      -- print("left: x: " .. window.left(win).x .. " y: " .. window.left(win).y .. " w: " .. window.left(win).w .. "  h: " .. window.left(win).h)
      -- print("right: x: " .. window.right(win).x .. " y: " .. window.right(win).y .. " w: " .. window.right(win).w ..  " h: " .. window.right(win).h)
      -- print("up: x: " .. window.up(win).x .. " y: " .. window.up(win).y .. " w: " .. window.up(win).w .. "h:   " .. window.up(win).h)
      -- print("down: x: " .. window.down(win).x .. " y: " .. window.down(win).y .. " w: " .. window.down(win).w .. "  h: " .. window.down(win).h)
      -- print("upLeft: ")
      -- print(window.upLeft(win))
      -- print("upRight: ")
      -- print(window.upRight(win))
    end,
  },
}

return M
