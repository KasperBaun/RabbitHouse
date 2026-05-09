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

// Toggle wall cladding/door/window trim on or off. With cladding off, all
// stud walls, posts, plates, and beams are visible — useful for auditing the
// frame against TIMBER-FRAMING.md and counting timber for a shopping list.
// (Currently honoured by v3 only.)
show_cladding = false;

// Toggle outdoor grass / gravel path / yard grass. With ground off, the
// buried fundablok strip foundation (Z<0) becomes visible from above.
// (Honoured by v3 only.)
show_ground = true;

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
if (design == "v3") build_v3(show_cladding=show_cladding, show_ground=show_ground);
