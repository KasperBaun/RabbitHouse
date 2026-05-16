// Rabbit-house
$fn = 48;

// Initial GUI viewport.
$vpt = [3000, 1250, 1300];
$vpr = [55, 0, 25];
$vpd = 16000;

include <lib/defaults.scad>
include <designs/config.scad>

use <designs/ground.scad>
use <designs/foundation.scad>
use <designs/framing.scad>
use <designs/openings.scad>
use <designs/cladding.scad>
use <designs/mesh.scad>
use <designs/roof_structure.scad>
use <designs/roof_plates.scad>
use <designs/interior.scad>

// tagpap_osb | eternit_b7 | eternit_10 | eternit_14
roof_cover    = "eternit_b7";

// klink | board_on_board
cladding_type = "klink";

RenderGround();
RenderFoundation();
RenderFraming();
RenderOpenings();
RenderRoofStructure("eternit_b7");
//RenderRoofPlates(roof_cover);
//RenderCladding(cladding_type);
//RenderMesh();
//RenderInterior();
