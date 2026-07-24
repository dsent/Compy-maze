-- spec/draw_levels_spec.lua

-- Critical content invariants for the picture-task data.
-- The ordered route is the proof that every target can be
-- drawn as one continuous trail without the B command.

local here = arg[0]:match("^(.*)/[^/]*$") or "."
dofile(here .. "/support.lua")
dofile(here .. "/../draw_levels.lua")

prepareDrawLevels()

print("== Draw picture-task data ==")

T.it("contains exactly 20 ordered tasks", function()
  T.eq(#DRAW_LEVELS, 20)
end)

T.it("starts with single strokes and ends with Dog", function()
  T.eq(DRAW_LEVELS[1].name, "Line")
  T.eq(DRAW_LEVELS[2].name, "Corner")
  T.eq(DRAW_LEVELS[3].name, "Bowl")
  T.eq(DRAW_LEVELS[4].name, "Square")
  T.eq(DRAW_LEVELS[5].name, "Boot")
  T.eq(DRAW_LEVELS[20].name, "Dog")
end)

T.it("the first seven tasks never retrace an edge", function()
  for index = 1, 7 do
    local level = DRAW_LEVELS[index]
    T.eq(#level.edge_list, #level.points - 1,
      "retrace in early draw level " .. index .. ": " .. level.name)
  end
end)

T.it("retracing starts at T and is never needed earlier", function()
  T.eq(DRAW_LEVELS[8].name, "T")
  local level = DRAW_LEVELS[8]
  T.eq(#level.edge_list < #level.points - 1, true)
end)

T.it("every task is a valid in-bounds trail", function()
  for index, level in ipairs(DRAW_LEVELS) do
    T.eq(drawLevelIsValid(level), true,
      "invalid draw level " .. index .. ": " .. level.name)
  end
end)

T.it("every route uses drawing directions only", function()
  for index, level in ipairs(DRAW_LEVELS) do
    local trail_only = not level.route:find("[^0-9NSEW]")
    T.eq(trail_only, true,
      "pen-up token in draw level " .. index)
  end
end)

function tracesFromRoute(level)
  local traces = { }
  for index = 2, #level.points do
    local from = level.points[index - 1]
    local to = level.points[index]
    table.insert(traces, {
      c1 = from.col,
      r1 = from.row,
      c2 = to.col,
      r2 = to.row
    })
  end
  return traces
end

-- Walking a task's own route must complete it. This is the
-- proof that no picture needs the pen lifted: the route is a
-- single trail, so every target is reachable with N/S/E/W
-- alone and never with B.

T.it("every task completes by walking its own route", function()
  for index, level in ipairs(DRAW_LEVELS) do
    local traces = tracesFromRoute(level)
    T.eq(tracesMatchTarget(traces, level), true,
      "route does not complete draw level " .. index ..
      ": " .. level.name)
  end
end)

T.it("repeated target traversal still matches", function()
  local level = DRAW_LEVELS[9]
  T.eq(level.name, "Plus")
  local traces = tracesFromRoute(level)
  T.eq(#level.edge_list < #traces, true)
  T.eq(tracesMatchTarget(traces, level), true)
end)

T.it("an extra edge prevents completion", function()
  local level = DRAW_LEVELS[3]
  local traces = { }
  for _, edge in ipairs(level.edge_list) do
    table.insert(traces, edge)
  end
  table.insert(traces, { c1 = 1, r1 = 1, c2 = 2, r2 = 1 })
  T.eq(tracesMatchTarget(traces, level), false)
end)

T.it("picture navigation clamps to the first and last task", function()
  T.eq(clampDrawLevelIndex(-4), 1)
  T.eq(clampDrawLevelIndex(8), 8)
  T.eq(clampDrawLevelIndex(24), 20)
end)

T.run()
