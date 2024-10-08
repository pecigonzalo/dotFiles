local M = {}

-- A global variable for the Hyper Mode
M.trigger = "F18"
M.key = "F17"
M.hyper = hs.hotkey.modal.new({}, M.key)

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
function M.enterHyperMode()
  M.hyper.triggered = false
  M.hyper:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
-- send ESCAPE if no other keys are pressed.
function M.exitHyperMode()
  M.hyper:exit()
  if not M.hyper.triggered then
    hs.eventtap.keyStroke({}, "ESCAPE", 0)
  end
end

function M.bind(modifiers, key, pressedFn, releasedFn)
  M.hyper:bind(modifiers, key, pressedFn, releasedFn)
end

function M.bindPassThrough(app, key)
  M.bind({}, key, nil, function()
    if hs.application.frontmostApplication():name() == app then
      hs.eventtap.keyStroke({ "shift", "ctrl", "cmd", "alt" }, key, 0)
    end
  end)
end

-- Bind the Hyper key
hs.hotkey.bind({}, M.trigger, M.enterHyperMode, M.exitHyperMode)

return M
