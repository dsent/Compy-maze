-- levels.lua

-- Each level is an array of strings with attributes.

-- Level 1: straight line, 2-3 moves

intro = {
  "####",
  "#* #",
  "#  #",
  "#N #",
  "####",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  grid = true,
  background = bg1
}

-- Level 2: one turn

one_turn = {
  "#####",
  "#  *#",
  "#   #",
  "#N  #",
  "#####",
  legend = LEGEND_FULL,
  background = bg2
}

-- Level 3: two turns, longer path

two_turns = {
  "#####",
  "#*  #",
  "# ###",
  "#   #",
  "### #",
  "#  N#",
  "#####",
  legend = LEGEND_FULL,
  background = bg3
}

two_turns2 = {
  "#####",
  "#*  #",
  "# ###",
  "#   #",
  "### #",
  "#  N#",
  "#####",
  controls = editor,
  progression = portal,
  legend = LEGEND_FULL,
  background = bg4
}

-- Level 4: longer path with dead ends

dead_ends = {
  "######",
  "# # *#",
  "#    #",
  "## # #",
  "#    #",
  "#N## #",
  "######",
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg2
}


maze5 = {
  "#########",
  "#   #   #",
  "# # # # #",
  "# #   # #",
  "# ### # #",
  "#N    #*#",
  "#########",
  legend = LEGEND_FULL,
  background = bg3
}

maze6 = {
  "#########",
  "#E      #",
  "### ### #",
  "#   #   #",
  "# ### ###",
  "#     * #",
  "#########",
  legend = LEGEND_FULL,
  background = bg5
}

maze7 = {
  "##########",
  "#   #    #",
  "# # # ## #",
  "# #   #W #",
  "# ########",
  "#       *#",
  "##########",
  legend = LEGEND_FULL,
  background = bg3
}

maze8 = {
  "##########",
  "#E   #   #",
  "# ## ### #",
  "#        #",
  "#### # ###",
  "#    # * #",
  "##########",
  legend = LEGEND_FULL,
  background = bg2
}

maze9 = {
  "###########",
  "#   #     #",
  "# # # ### #",
  "# #   #*  #",
  "# ### ### #",
  "#N  #     #",
  "###########",
  grid = false,
  controls = editor,
  legend = LEGEND_FULL,
  background = bg1
}

maze10 = {
  "############",
  "#   #      #",
  "# # # #### #",
  "# #   #    #",
  "# ##### ####",
  "#E    #   *#",
  "############",
  legend = LEGEND_FULL,
  background = bg4
}

maze11 = {
  "################",
  "#       #      #",
  "# ##### # #### #",
  "#     # #    # #",
  "##### # #### # #",
  "#E    #      #*#",
  "################",
  legend = LEGEND_FULL,
  background = bg1
}

maze12 = {
  "###############",
  "#      #      #",
  "# #### # #### #",
  "#    # #    # #",
  "#### # #### # #",
  "#E B        #*#",
  "###############",
  legend = LEGEND_FULL,
  background = bg3
}

maze13 = {
  "########",
  "###G####",
  "### ####",
  "###B BG#",
  "#G BN###",
  "####B###",
  "####G###",
  "########",
  legend = LEGEND_FULL,
  progression = celebrate,
  background = bg2
}

maze14 = {
  "#########",
  "#E  #####",
  "# BB#####",
  "# B ###G#",
  "### ###G#",
  "###    G#",
  "##   #  #",
  "##   ####",
  "#########",
  legend = LEGEND_FULL,
  progression = celebrate,
  background = bg4
}

maze15 = {
  "##########",
  "##     ###",
  "##B###   #",
  "# N B  B #",
  "# GG# B ##",
  "##GG#   ##",
  "##########",
  legend = LEGEND_FULL,
  background = bg1
}

sandbox = {
  intro,
  one_turn,
  two_turns,
  two_turns2,
  dead_ends,
  maze5,
  maze6,
  maze7,
  maze8,
  maze9,
  maze10,
  maze11,
  maze12,
  maze13,
  maze14,
  maze15
}

-- Lesson-tailored tracks. Spec-compliant: <= 8x8, one
-- control mode each, no wrong-mode drops.

-- Track 1: drive the robot (direct control).

-- D1: a straight run up.
direct1 = {
  "###",
  "#*#",
  "# #",
  "# #",
  "#N#",
  "###",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg1
}

-- D2: one turn (up, then right).
direct2 = {
  "#####",
  "#  *#",
  "# ###",
  "# ###",
  "#N###",
  "#####",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg2
}

-- D3: two turns (a short staircase).
direct3 = {
  "######",
  "###*##",
  "### ##",
  "#   ##",
  "# ####",
  "#N####",
  "######",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg3
}

-- D4: a U-turn (up, across, back down).
direct4 = {
  "######",
  "#    #",
  "# ## #",
  "# ## #",
  "#N##*#",
  "######",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg4
}

-- D5: a longer winding path.
direct5 = {
  "######",
  "#   *#",
  "### ##",
  "#   ##",
  "# ####",
  "#N####",
  "######",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg5
}

-- D6: 8 moves and three turns.
direct6 = {
  "########",
  "###  *##",
  "### ####",
  "#   ####",
  "# ######",
  "#N######",
  "########",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg1
}

-- D7: a 9-move hook with three turns.
direct7 = {
  "########",
  "#### *##",
  "#    ###",
  "# ######",
  "# ######",
  "# ######",
  "#N######",
  "########",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg2
}

-- D8: 9 moves and four turns.
direct8 = {
  "########",
  "#####*##",
  "####  ##",
  "#### ###",
  "#    ###",
  "# ######",
  "#N######",
  "########",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg3
}

-- D9: 10 moves and the first shallow dead end.
direct9 = {
  "########",
  "##*#####",
  "## #####",
  "##   ###",
  "#### ###",
  "#    ###",
  "#N# ####",
  "########",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg4
}

-- D10: 10 moves with two wrong choices.
direct10 = {
  "########",
  "####*###",
  "#### ###",
  "#    ###",
  "## ## ##",
  "##    ##",
  "#####N##",
  "########",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg5
}

-- D11: 11 moves through a branching route.
direct11 = {
  "########",
  "##*#####",
  "#  #####",
  "# #N   #",
  "# ## ###",
  "#      #",
  "########",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg1
}

-- D12: 12 moves with two dead ends.
direct12 = {
  "########",
  "##     #",
  "#  # # #",
  "# ## # #",
  "# *###N#",
  "# ######",
  "#  #####",
  "########",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg2
}

-- D13: 12 moves, six turns, three decisions.
direct13 = {
  "########",
  "#   #* #",
  "# ## # #",
  "#      #",
  "## ## ##",
  "##  ####",
  "### N###",
  "########",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg3
}

-- D14: 13 moves and three dead ends.
direct14 = {
  "########",
  "#    ###",
  "# ##   #",
  "# #  # #",
  "#  # *##",
  "## N####",
  "## #####",
  "########",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg4
}

-- D15: 14 moves and seven turns.
direct15 = {
  "########",
  "# ###*##",
  "# ##   #",
  "# ## # #",
  "# N# # #",
  "# # #  #",
  "#     ##",
  "########",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg5
}

-- D16: a 15-move route with three decoys.
direct16 = {
  "#######",
  "#    *#",
  "# # ###",
  "#  ####",
  "##  #N#",
  "#  #  #",
  "##   ##",
  "#######",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg1
}

-- D17: 16 moves and eight turns.
direct17 = {
  "########",
  "#   #  #",
  "# #   ##",
  "#  ## *#",
  "# ### ##",
  "#   ####",
  "###  N##",
  "########",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg2
}

-- D18: a 17-move weave with three decoys.
direct18 = {
  "########",
  "##   ###",
  "#  #  ##",
  "# ##*###",
  "# # ##N#",
  "#    # #",
  "# ##   #",
  "########",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg3
}

-- D19: 18 moves and nine turns.
direct19 = {
  "########",
  "#     ##",
  "### #  #",
  "#   ## #",
  "## #   #",
  "#  ### #",
  "#*#N   #",
  "########",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg4
}

-- D20: 19 moves, ten turns, and three decoys.
direct20 = {
  "########",
  "#  #*  #",
  "# # ## #",
  "#   #  #",
  "# # N# #",
  "#  ##  #",
  "##    ##",
  "########",
  controls = keys,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg5
}

direct_levels = {
  direct1,
  direct2,
  direct3,
  direct4,
  direct5,
  direct6,
  direct7,
  direct8,
  direct9,
  direct10,
  direct11,
  direct12,
  direct13,
  direct14,
  direct15,
  direct16,
  direct17,
  direct18,
  direct19,
  direct20
}

-- Track 2: plan a path (editor). The long straight runs
-- (plan2, plan3, plan5) make the repeat shorthand pay off.

-- P1: a short straight to learn type-then-run.
plan1 = {
  "#####",
  "# * #",
  "#   #",
  "# N #",
  "#####",
  controls = editor,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg1
}

-- P2: a long vertical run (motivates the shorthand).
plan2 = {
  "###",
  "#*#",
  "# #",
  "# #",
  "# #",
  "# #",
  "#N#",
  "###",
  controls = editor,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg2
}

-- P3: a long horizontal run.
plan3 = {
  "########",
  "#N    *#",
  "########",
  controls = editor,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg3
}

-- P4: a long L (up, then across).
plan4 = {
  "######",
  "#   *#",
  "# ####",
  "# ####",
  "# ####",
  "#N####",
  "######",
  controls = editor,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg4
}

-- P5: a long U (across, down, back across).
plan5 = {
  "########",
  "#N     #",
  "###### #",
  "#*     #",
  "########",
  controls = editor,
  progression = celebrate,
  legend = LEGEND_FULL,
  background = bg5
}

plan_levels = {
  plan1,
  plan2,
  plan3,
  plan4,
  plan5
}

TRACKS = {
  {
    key = "1",
    name = "Drive the robot",
    levels = direct_levels
  },
  {
    key = "2",
    name = "Plan a path",
    levels = plan_levels
  },
  {
    key = "3",
    name = "All mazes",
    levels = sandbox
  }
}

levels = sandbox
