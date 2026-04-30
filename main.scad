// Rabbit-house — top-level dispatcher.
//
// Pick a design by name; the matching `build_<design>` module is called below.
// Available designs:
//   "house_yard_v2" — gabled solid house + polycarb-roofed mesh run (current).
//   "lean_to_v1"    — original mono-pitch shed with rabbit zone + human seating.
//
// For lean_to_v1, also pick a preset: "6x3", "7x3", or "8x4".

design = "house_yard_v2";
v1_preset = "7x3";

$fn = 48;

use <designs/lean_to_v1/build.scad>
use <designs/house_yard_v2/build.scad>

if (design == "lean_to_v1")    build_lean_to_v1(v1_preset);
if (design == "house_yard_v2") build_house_yard_v2();
