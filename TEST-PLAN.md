# Maze And Draw Device Test Plan

Use the Compy device harness so the deployed project has a
recorded source identity and the previous project is backed up.

## A. Maze Regression

1. Launch Maze and confirm the three-item maze menu appears.
2. Open Drive the robot and complete one direct-control level.
3. Toggle the grid with the Menu key in both directions.
4. Return to the menu with Shift+Esc.
5. Open Plan a path, enter a short plan, run it, and retry it.
6. Open All mazes, run one editor command, and confirm the
   robot, trail, compass, command echo, sound, and timing.
7. Leave through Ctrl+Q and confirm the console is usable.

## B. Draw Acceptance

1. Launch Draw and confirm the menu lists Free draw first and
   Draw the picture second.
2. Open Free draw. Run commands in separate submissions,
   confirm the trail and robot persist, then run C followed by
   a movement in the same program.
3. Confirm Free draw has the original 8x8 canvas, right-side
   compass, cumulative trail, bottom-left start, and soft edge.
4. Return to the menu during a running program with Shift+Esc.
5. Open Draw the picture. Confirm Picture 1/20 is L and its
   target appears on an 8x8 grid above the compass with a green
   start marker at the same coordinates as the playing field.
6. Toggle the faint field hint off and on with the Menu key.
7. Complete L with `4S4E`; confirm its route never retraces and
   the completion stripe shows the Tab key glyph.
8. Press Tab. Confirm Picture 2/20 starts with its declared hint
   default and a fresh trail at its own start point.
9. Run `.` and `,` to confirm next/previous navigation, then
   use a counted jump and confirm first/last clamping.
10. Confirm Pictures 1-5 complete without retracing. Complete
   Plus with `2S2W4E2W2S` and confirm retracing is accepted.
11. On a hint-off task, toggle the hint on, draw an extra edge,
    and confirm it does not complete; run C and confirm reset.
12. Exercise a middle task and Picture 20/20 Dog, checking target
    readability, smooth animation, quiet sounds, and editor use.
13. Complete Dog, press Tab, and confirm Draw returns to its menu.
14. Leave through Ctrl+Q and confirm the console is usable.
