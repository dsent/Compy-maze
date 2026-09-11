-- draw_menu.lua

-- Draw starts with the same calm numbered-choice model as
-- Maze. Each choice stays inside the single Draw project.

DRAW_MODES = {
  {
    key = "1",
    name = "Free draw",
    mode = "free"
  },
  {
    key = "2",
    name = "Draw the picture",
    mode = "picture"
  }
}

function setDrawMenuColor(alpha)
  local color = Color[Color.black]
  gfx.setColor(color[1], color[2], color[3], alpha)
end

function drawMenu()
  local w, h = gfx.getDimensions()
  gfx.setColor(Color[Color.white])
  gfx.rectangle("fill", 0, 0, w, h)
  setDrawMenuColor(0.55)
  gfx.printf("Choose a drawing game", 0, h * 0.2, w, "center")
  for i, choice in ipairs(DRAW_MODES) do
    local y = h * 0.38 + (i - 1) * h * 0.12
    local label = choice.key .. ".  " .. choice.name
    setDrawMenuColor(1)
    gfx.printf(label, 0, y, w, "center")
  end
end

function drawMenuKey(key)
  for _, choice in ipairs(DRAW_MODES) do
    if choice.key == key then
      startDrawMode(choice.mode)
      return
    end
  end
end

-- The menu reads its choice on keypressed, but a bare digit key
-- also arrives as textinput, and the choice shows the command
-- widget in the same press -- so without a guard the digit
-- echoes into the widget it just opened (doc/input_api.md,
-- "Worked example: the trigger key echoes into the widget it
-- showed"). A one-time textinput shortcut per menu key swallows
-- that echo whichever side of the show LÖVE delivers it, and the
-- first to fire clears the whole set so none lingers into the
-- mode to be typed as a command.

function clearDrawMenuGuards()
  for _, choice in ipairs(DRAW_MODES) do
    compy.input.shortcuts.textinput[choice.key] = nil
  end
end

function armDrawMenuGuards()
  for _, choice in ipairs(DRAW_MODES) do
    compy.input.shortcuts.textinput[choice.key] = function()
      clearDrawMenuGuards()
      return true
    end
  end
end
