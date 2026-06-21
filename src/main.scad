// Rabbit-house
$fn = 48;

// Initial GUI viewport.
$vpt = [3000, 1250, 1300];
$vpr = [55, 0, 25];
$vpd = 16000;

include <lib/defaults.scad>
include <designs/config.scad>

// shared
use <designs/ground.scad>

// house
use <designs/house/foundation.scad>
use <designs/house/basement.scad>
use <designs/house/floor.scad>
use <designs/house/framing.scad>
use <designs/house/openings.scad>
use <designs/house/roof.scad>
use <designs/house/roof_plates.scad>
use <designs/house/cladding/cladding.scad>

// yard
use <designs/yard/foundation.scad>
use <designs/yard/framing.scad>
use <designs/yard/openings.scad>
use <designs/yard/roof.scad>
use <designs/yard/roof_plates.scad>
use <designs/yard/mesh.scad>

// House roof.
// Choose between 'skifer', 'tagpap' or 'eternit'
house_roof_cover = "skifer";

// Gable-roof truss pattern (only used when house_roof_cover = "skifer"):
//   'haneband'    — spær med hanebånd, more loft space (recommended for 2 m span)
//   'gitterspaer' — engineered king-post truss with W-struts (reusable module)
house_truss      = "haneband";

// Yard is an open-top run — welded-wire lid stretched across the rafters
// (predator-proof, no weather barrier). Other options: "polycarb",
// "tagpap", "eternit".
yard_roof_cover  = "mesh";

// klink | board_on_board | vertical_120
cladding_type    = "vertical_120";

// shared
RenderGround();

// house — uncomment each step as it gets built
RenderHouseFoundation();
RenderHouseBasementFloor();  // concrete kælder slab (z=-680)
RenderHouseFloorJoists();    // bearing layer — strørem + strøer
//wRenderHouseFloorDeck();      // ~25 mm board deck (with hatches)
RenderHouseStairs();         // kælder staircases + hinged lids
//RenderHouseFraming();
//RenderHouseOpenings();
//RenderHouseRoof(house_roof_cover, house_truss);
//RenderHouseRoofPlates(house_roof_cover);
//RenderHouseCladding(cladding_type);

// yard (uses lower RH_YARD_EH_* eave heights — separate structure)
// RenderYardRoof builds spær/lookouts/soffit/sternbrædder — only needed
// for tagpap/eternit/polycarb covers. With cover="mesh" the lid sits
// straight on the top plates, so the whole roof skeleton is skipped.
//RenderYardFoundation();
//RenderYardFraming();
//RenderYardOpenings();
//if (yard_roof_cover != "mesh") RenderYardRoof(yard_roof_cover);
//RenderYardRoofPlates(yard_roof_cover);
//RenderYardMesh();
