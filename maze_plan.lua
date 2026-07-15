-- maze_plan.lua

-- Plan-a-path control mode: typed direction commands
-- collect as key tiles at the bottom of the screen and
-- Enter runs the pending tail. A middle step between
-- direct control (keys) and the editor.

-- Plan state lives in GS.plan: buf holds command chars,
-- done counts tiles already executed (shown green), exec
-- is the tile animating now, crash_at keeps the crash
-- display until the next edit or submit.

plan_held = { }

function plan_reset()
  GS.plan = {
    buf = { },
    done = 0
  }
  plan_held = { }
end

-- Any level reset sends the robot home, so the whole
-- buffer is pending again.

function plan_rewind()
  local p = GS.plan
  if p then
    p.done = 0
    p.exec = nil
  end
end

-- Input is locked while a run is in flight and during
-- the win pause.

function plan_locked()
  return GS.running or GS.celebrating or GS.won
end

-- An edit clears the previous run's crash display.

function plan_clear_marks()
  GS.plan.crash_at = nil
  GS.crash = nil
end

function plan_append(c)
  local p = GS.plan
  if MAX_PLAN_LEN <= #p.buf then
    return
  end
  table.insert(p.buf, c)
  plan_clear_marks()
  sfx.toggle()
end

function plan_backspace()
  local p = GS.plan
  if #p.buf <= p.done then
    return
  end
  table.remove(p.buf)
  plan_clear_marks()
  sfx.toggle()
end

function plan_enqueue(i)
  table.insert(player.queue, GS.plan.buf[i])
  table.insert(player.queue_refs, {
    line = i,
    col_from = i,
    col_to = i
  })
  sfx.ping()
end

-- Enter queues only the not-yet-run tiles, continuing
-- from where the robot stands; after a crash the level
-- was reset, so the whole plan runs again from the start.

function plan_submit()
  local p = GS.plan
  if #p.buf <= p.done then
    return
  end
  plan_clear_marks()
  GS.failed = nil
  for i = p.done + 1, #p.buf do
    plan_enqueue(i)
  end
  GS.running = true
end

-- Level navigation, a teacher aid as in keys mode.

function plan_jump(k)
  local delta = 1
  if k == "," then
    delta = -1
  end
  jump_level(delta)
end

PLAN_ACTS = {
  backspace = plan_backspace,
  ["return"] = plan_submit,
  ["."] = plan_jump,
  [","] = plan_jump
}

-- A tile key is a movement primitive; the silent
-- navigation commands never become tiles.

function plan_movement(c)
  local prim = PRIMITIVES[c]
  local nav = SILENT_CMDS[c]
  return prim and not nav
end

function plan_dispatch(k)
  local act = PLAN_ACTS[k]
  if act then
    act(k)
    return
  end
  local c = k:upper()
  if plan_movement(c) then
    plan_append(c)
  end
end

-- A held key repeats keypresses; act on the edge only.

function plan_key(k)
  if plan_held[k] then
    return
  end
  plan_held[k] = true
  if plan_locked() then
    return
  end
  plan_dispatch(k)
end

function plan_key_up(k)
  plan_held[k] = nil
end

-- Advance the green highlight as the queue drains.

function plan_track_exec()
  local a = player.anim
  local on = a and a.line
  if not on then
    return
  end
  local p = GS.plan
  p.exec = a.line
  if p.done < a.line - 1 then
    p.done = a.line - 1
  end
end

function plan_run_over()
  local busy = player.anim or 0 < #(player.queue)
  return GS.running and not busy
end

-- A run that ends short of the goal re-enables input:
-- the child appends more commands and runs again. A
-- crash was already handled by plan_after_crash.

function plan_update()
  plan_track_exec()
  if not plan_run_over() then
    return
  end
  GS.running = false
  local p = GS.plan
  if not GS.crash then
    p.done = p.exec or p.done
  end
  p.exec = nil
end

-- Crash: snapshot the failed tile for the display, then
-- reset the maze. The buffer is preserved so the child
-- can read which step failed, edit, and retry.

function plan_after_crash()
  local mark = GS.crash
  GS.plan.crash_at = mark and mark.line
  reset_level()
end

-- Reserved bottom band: a prompt line and two tile rows,
-- ten tiles each, at the keyboard game's natural key
-- size.

function plan_tile_w()
  return STD_W * SCALE
end

function plan_tile_h()
  return STD_H * SCALE
end

function plan_pad()
  return gfx.getFont():getHeight() / 2
end

function plan_band_h()
  local fh = gfx.getFont():getHeight()
  local rows = 2 * plan_tile_h() + SCALE
  return fh + rows + 3 * plan_pad()
end
