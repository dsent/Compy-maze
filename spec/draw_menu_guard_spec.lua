-- The menu key echoes into the widget it opens unless a
-- one-time textinput guard swallows it (draw_menu.lua;
-- doc/input_api.md, "Worked example: the trigger key echoes
-- into the widget it showed"). These pin the guard's contract
-- headless: arming installs one per menu key, and the first to
-- fire consumes and clears the whole set so none survives into
-- the mode as a typed command.

local here = arg[0]:match("^(.*)/[^/]*$") or "."
dofile(here .. "/support.lua")

-- The only runtime surface the guard touches: one writable
-- leaf table under compy.input.shortcuts.textinput.
compy = { input = { shortcuts = { textinput = { } } } }

dofile(here .. "/../draw_menu.lua")

local function guards()
  return compy.input.shortcuts.textinput
end

print("== Draw menu echo guard ==")

T.it("arming installs a guard for every menu key", function()
  compy.input.shortcuts.textinput = { }
  armDrawMenuGuards()
  for _, choice in ipairs(DRAW_MODES) do
    T.eq(type(guards()[choice.key]), "function", choice.key)
  end
end)

T.it("a fired guard consumes the echo", function()
  compy.input.shortcuts.textinput = { }
  armDrawMenuGuards()
  T.eq(guards()["1"](), true)
end)

T.it("the first fire clears every guard", function()
  compy.input.shortcuts.textinput = { }
  armDrawMenuGuards()
  guards()["1"]()
  for _, choice in ipairs(DRAW_MODES) do
    T.eq(guards()[choice.key], nil, choice.key)
  end
end)

T.it("clearing on its own leaves no guard", function()
  compy.input.shortcuts.textinput = { }
  armDrawMenuGuards()
  clearDrawMenuGuards()
  for _, choice in ipairs(DRAW_MODES) do
    T.eq(guards()[choice.key], nil, choice.key)
  end
end)

T.run()
