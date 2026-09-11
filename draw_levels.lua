-- draw_levels.lua

-- Ordered picture tasks, arranged as a ladder: stroke
-- counting, closed shapes, a repeating step pattern, the
-- first retracing, stepped slopes, then composite objects.
-- Each route starts at the declared cell and uses drawing
-- moves only, so every picture is one continuous trail with
-- the pen down. Repeated edges are part of the route where a
-- branched picture has to come back over itself.

DRAW_LEVELS = {
  -- Counting, one stroke at a time.
  {
    name = "Line",
    col = 2,
    row = 5,
    route = "5E",
    hint = true
  },
  {
    name = "Corner",
    col = 2,
    row = 2,
    route = "4S4E",
    hint = true
  },
  {
    name = "Bowl",
    col = 2,
    row = 2,
    route = "4S4E4N",
    hint = true
  },

  -- Closed shapes: the trail comes back to where it started.
  {
    name = "Square",
    col = 2,
    row = 2,
    route = "4E4S4W4N",
    hint = false
  },
  {
    name = "Boot",
    col = 3,
    row = 2,
    route = "6S4E2N2W4N2W",
    hint = false
  },
  {
    name = "Flag",
    col = 2,
    row = 8,
    route = "6N3E2S3W",
    hint = false
  },

  -- A repeating step pattern, then the first retracing.
  {
    name = "Steps",
    col = 2,
    row = 7,
    route = "NENENENE",
    hint = true
  },
  {
    name = "T",
    col = 6,
    row = 2,
    route = "4W2E5S",
    hint = true
  },
  {
    name = "Plus",
    col = 4,
    row = 6,
    route = "4N2S2W4E",
    hint = false
  },

  -- Sloped sides built from steps, and the first composites.
  {
    name = "Mountain",
    col = 1,
    row = 6,
    route = "NENENENESESESES7W",
    hint = true
  },
  {
    name = "Mug",
    col = 2,
    row = 3,
    route = "3ES2E2S2WS3W4N3E4S",
    hint = false
  },
  {
    name = "House",
    col = 4,
    row = 8,
    route = "2W4NENENESESE4S3W2NE2S",
    hint = true
  },

  -- Objects. Stroke count and retracing grow together.
  {
    name = "Arrow",
    col = 2,
    row = 4,
    route = "5ENWNWESE2SWSW",
    hint = false
  },
  {
    name = "Heart",
    col = 4,
    row = 3,
    route = "N2WSW2SESESESENENENE2NWN2WSW",
    hint = true
  },
  {
    name = "Car",
    col = 6,
    row = 7,
    route = "4WSEN2W2N2E2N3E2S2E2S2WSEN",
    hint = false
  },
  {
    name = "Fish",
    col = 1,
    row = 3,
    route = "ESENEN2ESESESWSWS2WNWNWSW3N",
    hint = true
  },
  {
    name = "Cat",
    col = 2,
    row = 2,
    route = "ES2ENE4SE2NE3S6WNE2NW2N",
    hint = false
  },
  {
    name = "Rocket",
    col = 4,
    row = 1,
    route = "ESE3SESES2WNW2SW2NWS2WNENE3NENSWS3E",
    hint = false
  },
  {
    name = "Boat",
    col = 3,
    row = 5,
    route = "5EN2WNWNWNW5S2WESES4ENEN5W",
    hint = false
  },
  {
    name = "Dog",
    col = 2,
    row = 4,
    route = "3E2N2ESESW2SW2SW2N2W2SW3NW2NES",
    hint = true
  }
}

TARGET_DELTA = {
  N = { col = 0, row = -1 },
  S = { col = 0, row = 1 },
  E = { col = 1, row = 0 },
  W = { col = -1, row = 0 }
}

function targetEdgeKey(c1, r1, c2, r2)
  local a = c1 .. ":" .. r1
  local b = c2 .. ":" .. r2
  if b < a then
    a, b = b, a
  end
  return a .. "-" .. b
end

function addTargetStep(level, col, row, dir)
  local d = TARGET_DELTA[dir]
  local nc = col + d.col
  local nr = row + d.row
  local key = targetEdgeKey(col, row, nc, nr)
  if not level.edges[key] then
    table.insert(level.edge_list, {
      c1 = col,
      r1 = row,
      c2 = nc,
      r2 = nr
    })
  end
  level.edges[key] = true
  table.insert(level.points, { col = nc, row = nr })
  return nc, nr
end

function expandTargetRoute(level)
  local col, row = level.col, level.row
  local parsed = ""
  level.points = { { col = col, row = row } }
  level.edges = { }
  level.edge_list = { }
  for count, dir in level.route:gmatch("(%d*)([NSEW])") do
    local steps = tonumber(count) or 1
    parsed = parsed .. count .. dir
    for _ = 1, steps do
      col, row = addTargetStep(level, col, row, dir)
    end
  end
  level.dir = level.route:match("[NSEW]") or "N"
  level.route_valid = parsed == level.route
end

function measureTargetBounds(level)
  local first = level.points[1]
  level.min_col = first.col
  level.max_col = first.col
  level.min_row = first.row
  level.max_row = first.row
  for _, point in ipairs(level.points) do
    level.min_col = math.min(level.min_col, point.col)
    level.max_col = math.max(level.max_col, point.col)
    level.min_row = math.min(level.min_row, point.row)
    level.max_row = math.max(level.max_row, point.row)
  end
end

function prepareDrawLevels()
  for _, level in ipairs(DRAW_LEVELS) do
    expandTargetRoute(level)
    measureTargetBounds(level)
  end
end

function targetPointInBounds(point)
  local col_ok = 1 <= point.col and point.col <= 8
  local row_ok = 1 <= point.row and point.row <= 8
  return col_ok and row_ok
end

function drawLevelIsValid(level)
  if not level.route_valid or type(level.hint) ~= "boolean" then
    return false
  end
  if #level.edge_list == 0 then
    return false
  end
  for _, point in ipairs(level.points) do
    if not targetPointInBounds(point) then
      return false
    end
  end
  return true
end

function traceEdgeSet(traces)
  local edges = { }
  for _, trace in ipairs(traces) do
    local key = targetEdgeKey(
      trace.c1, trace.r1, trace.c2, trace.r2
    )
    edges[key] = true
  end
  return edges
end

function edgeSetsEqual(a, b)
  for key in pairs(a) do
    if not b[key] then
      return false
    end
  end
  for key in pairs(b) do
    if not a[key] then
      return false
    end
  end
  return true
end

function tracesMatchTarget(traces, level)
  return edgeSetsEqual(traceEdgeSet(traces), level.edges)
end

function clampDrawLevelIndex(index)
  return math.max(1, math.min(#DRAW_LEVELS, index))
end
