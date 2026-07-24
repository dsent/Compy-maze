-- draw_main.lua

-- Draw contains two mini-games on the shared command core:
-- the original cumulative free canvas and 20 picture tasks.

require("core_constants")
require("draw_constants")
require("core_sprites")
require("core_render")
require("draw_render")
require("core_editor")
require("player")
require("core_anim")
require("script")
require("keyboard_graphics")
require("draw_levels")
require("draw_menu")

sfx = compy.audio

echo_lines = { }
macros = { }
cur_controls = nil
cur_legend = DRAW_LEGEND

GS = {
  init = false,
  screen = "menu",
  draw_mode = nil,
  level_index = nil,
  hint = false,
  won = false,
  running = false,
  base_macros = { }
}

function currentDrawLevel()
  if GS.draw_mode ~= "picture" then
    return nil
  end
  return DRAW_LEVELS[GS.level_index]
end

function activeStart()
  local level = currentDrawLevel()
  if level then
    return level.col, level.row, level.dir
  end
  return START.col, START.row, START.dir
end

-- App hooks named by the shared editor and animation core.

function blocked(tc, tr)
  return tc < 1 or GRID.cols < tc or tr < 1 or GRID.rows < tr
end

function before_run()
end

function after_step()
end

function finish_run()
  GS.running = false
  local level = currentDrawLevel()
  local matched = level and
      tracesMatchTarget(player.traces, level)
  if not matched then
    return
  end
  GS.won = true
  ctrl_update = nil
  sfx.win()
end

function draw_move(cmd, ref)
  local tc, tr = move_cmd_target(cmd)
  if blocked(tc, tr) then
    return
  end
  start_forward(cmd, ref, tc, tr)
end

function clear_canvas()
  local col, row, dir = activeStart()
  reset_robot(col, row, dir)
  GS.won = false
end

function takeDrawLevelRepeats(cmd)
  local count = 1
  while player.queue[1] == cmd do
    table.remove(player.queue, 1)
    table.remove(player.queue_refs, 1)
    count = count + 1
  end
  return count
end

function jumpPictureLevel(delta)
  if GS.draw_mode ~= "picture" then
    return
  end
  local index = clampDrawLevelIndex(GS.level_index + delta)
  if index ~= GS.level_index then
    GS.base_macros = clone_macros(macros)
    GS.level_index = index
  end
  startPictureLevel()
end

function stepPictureLevel(cmd)
  local sign = (cmd == ",") and -1 or 1
  jumpPictureLevel(sign * takeDrawLevelRepeats(cmd))
end

-- TEMPORARY: the typed exit registered in draw_constants.lua.
-- Removed together with "<" when Shift+Esc reaches a program
-- from an active editor field.

function exitToDrawMenu()
  toDrawMenu()
end

CMD_HANDLERS = {
  ["."] = stepPictureLevel,
  [","] = stepPictureLevel,
  ["<"] = exitToDrawMenu,
  F = draw_move,
  B = draw_move,
  L = start_turn,
  R = start_turn,
  C = clear_canvas
}

-- Layout

function editor_band_h()
  return EDITOR_ROWS * gfx.getFont():getHeight()
end

function legend_band_w()
  local font = gfx.getFont()
  local wide = 0
  for line in (cur_legend .. "\n"):gmatch("(.-)\n") do
    wide = math.max(wide, font:getWidth(line))
  end
  return wide + 2 * font:getHeight()
end

function picturePanelWidth()
  local preview_w = gfx.getHeight() * PREVIEW_WIDTH_FRAC
  return math.max(legend_band_w(), preview_w)
end

function draw_layout()
  local right = legend_band_w()
  if GS.draw_mode == "picture" then
    right = picturePanelWidth()
  end
  return {
    pad_bottom = editor_band_h(),
    pad_right = right,
    margin = gfx.getFont():getHeight()
  }
end

-- Mini-game lifecycle

function resetDrawProgramState()
  echo_lines = { }
  GS.invalid = nil
  GS.program = nil
  GS.running = false
  GS.won = false
  cur_controls = editor
  cur_legend = DRAW_LEGEND
  macros = clone_macros(GS.base_macros)
end

function startFreeDraw()
  setPictureNavigationEnabled(false)
  GS.level_index = nil
  GS.hint = false
  GS.base_macros = { }
  resetDrawProgramState()
  init_grid(CANVAS.rows, CANVAS.cols, draw_layout())
  player_reset(START.col, START.row, START.dir)
  editor()
end

function startPictureLevel()
  local level = currentDrawLevel()
  resetDrawProgramState()
  GS.hint = level.hint
  init_grid(CANVAS.rows, CANVAS.cols, draw_layout())
  player_reset(level.col, level.row, level.dir)
  editor()
end

function startPictureTasks()
  setPictureNavigationEnabled(true)
  GS.level_index = 1
  GS.base_macros = { }
  startPictureLevel()
end

function startDrawMode(mode)
  GS.screen = "game"
  GS.draw_mode = mode
  if mode == "free" then
    startFreeDraw()
  else
    startPictureTasks()
  end
end

function toDrawMenu()
  setPictureNavigationEnabled(false)
  GS.screen = "menu"
  GS.draw_mode = nil
  GS.won = false
  player.queue = { }
  player.queue_refs = { }
  ctrl_update = nil
  ctrl_pressed = nil
end

function nextPictureLevel()
  GS.base_macros = clone_macros(macros)
  GS.level_index = GS.level_index + 1
  if #DRAW_LEVELS < GS.level_index then
    toDrawMenu()
    return
  end
  startPictureLevel()
end

-- Main loop and input

function ensure_init()
  if GS.init then
    return
  end
  prepareDrawLevels()
  GS.init = true
end

function stepDrawProgram(dt)
  if player.anim then
    advance_anim(dt)
  end
  if player.anim then
    update_track_offsets(dt)
  else
    execute_next()
  end
end

tab_was_down = false

function pollPictureProgression()
  local down = love.keyboard.isDown("tab")
  local edge = down and not tab_was_down
  if edge and GS.won then
    nextPictureLevel()
  end
  tab_was_down = down
end

function love.update(dt)
  ensure_init()
  if GS.screen ~= "game" then
    return
  end
  pollPictureProgression()
  stepDrawProgram(dt)
  if ctrl_update then
    ctrl_update(dt)
  end
end

function love.draw()
  ensure_init()
  if GS.screen == "menu" then
    drawMenu()
  else
    draw_scene()
  end
end

SYSTEM_KEYS = { }

function SYSTEM_KEYS.menu()
  if GS.draw_mode ~= "picture" then
    return
  end
  GS.hint = not GS.hint
  sfx.sword()
end

love.mousepressed = SYSTEM_KEYS.menu

function is_shift_down()
  local down = love.keyboard.isDown
  return down("lshift") or down("rshift")
end

function on_escape()
  if GS.screen == "game" then
    toDrawMenu()
  end
end

function drawGameKey(key)
  local fn = SYSTEM_KEYS[key]
  if fn then
    fn()
  elseif ctrl_pressed then
    ctrl_pressed(key)
  end
end

function love.keypressed(key)
  if key == "escape" then
    if is_shift_down() then
      on_escape()
    end
    return
  end
  if GS.screen == "menu" then
    drawMenuKey(key)
  else
    drawGameKey(key)
  end
end

function love.resize()
  local active = GS.init and GS.screen == "game"
  if active then
    init_grid(CANVAS.rows, CANVAS.cols, draw_layout())
  end
end
