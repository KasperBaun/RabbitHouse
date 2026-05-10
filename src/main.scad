// Rabbit-house — entry point.
// All toggles + composition live in src/designs/v3/build.scad.

$fn = 48;

// Initial GUI viewport. OpenSCAD reads these special variables on file
// open and uses them as the starting camera, so the 6 × 2,5 m model
// frames correctly instead of appearing as a tiny dot in the corner.
// (CLI `--camera=...` flags override these for batch renders.)
$vpt = [3000, 1250, 1300];   // focal point ~ centre of v3 footprint
$vpr = [55, 0, 25];          // 3/4 angle (degrees)
$vpd = 16000;                // distance fits a 6 m model

include <designs/v3/build.scad>
