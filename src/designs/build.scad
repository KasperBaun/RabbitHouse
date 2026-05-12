// Rabbit-house build orchestrator.
include <../lib/defaults.scad>
include <config.scad>

use <foundation.scad>
use <framing.scad>
use <openings.scad>
use <cladding.scad>
use <roof_structure.scad>
use <roof_plates.scad>
// use <interior.scad>

show_cladding = true;
show_ground   = true;
show_cover    = true;
roof_cover    = "eternit_b7";   // tagpap_osb | eternit_b7 | eternit_10 | eternit_14

// Local klink profile: 25x125 mm spruce/larch boards, 25 mm overlap, step
// 100 mm. Standard Stark/Bauhaus stock in 4200 mm lengths. Overrides
// DEFAULT_CLAD (24x150 with 40 mm overlap).
RH_CLAD = clad_spec(board_h=125, overlap=25, thick=25, lip=20);

module RenderHouse() {
    pal = DEFAULT_PALETTE;
    RenderFoundation(show_ground, pal);
    RenderFraming(pal);
    RenderOpenings(default_mesh(), pal);
    RenderRoofStructure(roof_cover, show_cladding, pal);
    if (show_cover)    RenderRoofPlates(roof_cover, pal);
    if (show_cladding) RenderCladding(RH_CLAD, pal);
    // RenderInterior(show_cladding, show_ground, pal);
}

function default_mesh() = mesh_spec(spacing=RH_MESH_SPACING, bar=RH_MESH_BAR,
                                     frame=RH_MESH_FRAME, depth=RH_MESH_DEPTH);

RenderHouse();
