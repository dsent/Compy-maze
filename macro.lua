-- macro.lua

-- Keyboard macro recording and playback

macro_state = {
  recording = false,
  name = nil,
  body = { }
}

-- Start recording: Shift + key pressed

function start_recording(key)
  local name = key:upper()
  if PRIMITIVES[name] then
    sfx.wrong()
    return
  end
  macro_state.recording = true
  macro_state.name = name
  macro_state.body = { }
  sfx.beep()
end

-- Add a key to macro body

function record_key(key)
  if MAX_MACRO_LEN <= #(macro_state.body) then
    return
  end
  local upper = key:upper()
  if PRIMITIVES[upper] or macros[upper] then
    table.insert(macro_state.body, upper)
    sfx.toggle()
  end
end

-- Finish recording: expand and save

function finish_recording()
  if not macro_state.recording then
    return
  end
  macro_state.recording = false
  local text = table.concat(macro_state.body)
  local result = expand_macros(text)
  macros[macro_state.name] = 0 < #result and result or nil
end

-- Execute a key: expand macro if defined

function execute_key(key)
  local upper = key:upper()
  local cmds = macros[upper]
  if cmds then
    for i = 1, #cmds do
      ping_cmd(cmds:sub(i, i))
    end
  else
    ping_cmd(upper)
  end
end

-- Handle non-escape key presses

-- Whether Shift is down is asked of the keyboard, not
-- remembered from its press. A remembered flag survives a
-- release that never arrives -- a window losing focus with
-- the key down -- and then every later key starts a
-- recording instead of running, dimmed for the rest of the
-- session with no way back but a restart.
--
-- With both Shift keys: holding two and releasing one keeps
-- the keyboard's answer true, so the next key still names a
-- macro, which is what the dimmed screen is showing.

function handle_key(k)
  if Key.is_shift(k) then
    return
  elseif macro_state.recording then
    record_key(k)
  elseif Key.shift() then
    start_recording(k)
  else
    execute_key(k)
  end
end

-- Handle shift release

-- The release still ends a recording: that is a genuine
-- edge, not a piece of remembered state, and letting go is
-- how a child says the macro is done.

function release_shift(k)
  if Key.is_shift(k) then
    finish_recording()
  end
end
