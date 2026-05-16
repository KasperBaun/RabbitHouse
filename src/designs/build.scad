// Rabbit-house build.
include <../lib/defaults.scad>
include <config.scad>

use <ground.scad>
use <foundation.scad>
use <framing.scad>
use <openings.scad>
use <cladding.scad>
use <mesh.scad>
use <roof_structure.scad>
use <roof_plates.scad>
use <interior.scad>

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
