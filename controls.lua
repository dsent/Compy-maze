-- controls.lua

-- Control mode initializers.
-- Each sets two optional callbacks:
-- ctrl_pressed(k) from love.keypressed
-- ctrl_update() from love.update

-- Keyboard controls

function keys()
  ctrl_pressed = handle_key
  ctrl_update = nil
end

-- Plan-a-path controls: keys collect as tiles at the
-- bottom of the screen, Enter runs the plan.

function plan()
  ctrl_pressed = plan_key
  ctrl_update = plan_update
  plan_reset()
end

-- Command line controls

-- Progression modes

function portal()
  next_level()
end

function celebrate()
  ctrl_update = nil
  GS.celebrating = true
end

function continue()
  GS.won = true
end
