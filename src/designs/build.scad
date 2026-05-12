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

module RenderHouse() {
    pal = DEFAULT_PALETTE;
    RenderFoundation(show_ground, pal);
    RenderFraming(pal);
    RenderOpenings(RH_MESH, pal);
    RenderRoofStructure(roof_cover, show_cladding, pal);
    if (show_cover)    RenderRoofPlates(roof_cover, pal);
    if (show_cladding) RenderCladding(RH_CLAD, pal);
    // RenderInterior(show_cladding, show_ground, pal);
}

RenderHouse();
