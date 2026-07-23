-- draw_levels.lua

-- Ordered picture tasks. Each route starts at the declared
-- cell and uses drawing moves only. Repeated edges are part
-- of the route when a branched picture needs backtracking.

DRAW_LEVELS = {
  {
    name = "L",
    col = 2,
    row = 2,
    route = "4S4E",
    hint = true
  },
  {
    name = "U",
    col = 2,
    row = 2,
    route = "4S4E4N",
    hint = true
  },
  {
    name = "Square",
    col = 2,
    row = 2,
    route = "4E4S4W4N",
    hint = false
  },
  {
    name = "Rectangle",
    col = 2,
    row = 3,
    route = "4E2S4W2N",
    hint = false
  },
  {
    name = "Flag",
    col = 2,
    row = 6,
    route = "4N4E2S4W",
    hint = false
  },
  {
    name = "Plus",
    col = 4,
    row = 2,
    route = "2S2W4E2W2S",
    hint = true
  },
  {
    name = "T",
    col = 2,
    row = 2,
    route = "4E2W4S",
    hint = true
  },
  {
    name = "Arrow",
    col = 2,
    row = 4,
    route = "4ENWNWESESSWSW",
    hint = true
  },
  {
    name = "House",
    col = 2,
    row = 6,
    route = "2NENENESE3S4W",
    hint = true
  },
  {
    name = "Tree",
    col = 4,
    row = 2,
    route = "SWSWSE2S2E2NENWNWN",
    hint = false
  },
  {
    name = "Glasses",
    col = 1,
    row = 3,
    route = "2E2S2W2N2ES2EN2E2S2WN",
    hint = true
  },
  {
    name = "Fish",
    col = 2,
    row = 3,
    route = "3ESENENSWSWESESNWNWS3W2N",
    hint = false
  },
  {
    name = "Boat",
    col = 2,
    row = 5,
    route = "4EWS2WWN2E4N2E3S2WS",
    hint = false
  },
  {
    name = "Car",
    col = 2,
    row = 5,
    route = "2N4E2SESWN3WSWN",
    hint = true
  },
  {
    name = "Rocket",
    col = 4,
    row = 7,
    route = "6NESE3SES2WSWWN2WNE3NENE",
    hint = false
  },
  {
    name = "Crown",
    col = 2,
    row = 6,
    route = "4NE2SE2NE2SE2NE4S5W",
    hint = false
  },
  {
    name = "Snail",
    col = 1,
    row = 6,
    route = "5EENNW2N3W3S2E2NWS",
    hint = true
  },
  {
    name = "Cat",
    col = 2,
    row = 6,
    route = "4NESENESE3SENWS2WNWSW",
    hint = false
  },
  {
    name = "Butterfly",
    col = 4,
    row = 2,
    route = "2S2W2NESES2E2NWSWS2W2SENEN2E2SWNWN3S",
    hint = false
  },
  {
    name = "Dog",
    col = 1,
    row = 4,
    route = "ES2N3ENENE2SESW2SWN2W2SW2NW",
    hint = false
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
