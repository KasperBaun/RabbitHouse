// Rabbit-house — top-level dispatcher.
//
// Pick a design by name; the matching `build_<design>` module is called below.
// Available designs:
//   "v3" — unified mono-pitch roof over slab-on-house + grass-on-plugs yard (current).
//   "v2" — gabled solid house + polycarb-roofed mesh run.
//   "v1" — original mono-pitch shed with rabbit zone + human seating.
//
// For v1, also pick a preset: "6x3", "7x3", or "8x4".

design = "v3";
v1_preset = "7x3";

$fn = 48;

// Initial GUI viewport. OpenSCAD reads these special variables on file
// open and uses them as the starting camera, so the 6 m structure frames
// correctly instead of appearing as a tiny dot in the corner.
// (CLI `--camera=...` flags override these for batch renders.)
$vpt = [3000, 1500, 1300];   // focal point ~ centre of all three designs
$vpr = [55, 0, 25];          // default 3/4 angle (degrees)
$vpd = 16000;                // camera distance — fits a 6 m × 3 m model

use <designs/v1/build.scad>
use <designs/v2/build.scad>
use <designs/v3/build.scad>

if (design == "v1") build_v1(v1_preset);
if (design == "v2") build_v2();
if (design == "v3") build_v3();
