// Rabbit-house build.
include <../lib/defaults.scad>
include <config.scad>

use <ground.scad>
use <foundation.scad>
use <framing.scad>
use <openings.scad>
use <cladding.scad>
use <roof_structure.scad>
use <roof_plates.scad>
// use <interior.scad>

roof_cover = "eternit_b7";   // tagpap_osb | eternit_b7 | eternit_10 | eternit_14

RenderGround();
RenderFoundation();
RenderFraming();
RenderOpenings();
RenderRoofStructure("eternit_b7");
RenderRoofPlates(roof_cover);
RenderCladding();
// RenderInterior();
