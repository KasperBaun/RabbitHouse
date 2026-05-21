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
use <designs/roof_plates.scad>
use <designs/interior.scad>

// house
use <designs/house/foundation.scad>
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

// House gets a real roof. "skifer" gives a saddeltag (gable) with ridge
// along Y — water sheds onto V3 (left) and V5 (partition). All other
// covers keep the original mono-pitch front-to-back slope.
//   tagpap_osb | eternit_b7 | eternit_10 | eternit_14 | polycarb | shingles | skifer
house_roof_cover = "skifer";

// Yard gets a transparent, lower roof — polycarb direct on rafters.
yard_roof_cover  = "polycarb";

// klink | board_on_board
cladding_type    = "klink";

// shared
//RenderGround();

// house
RenderHouseFoundation();
RenderHouseFraming();
//RenderHouseOpenings();
RenderHouseRoof(house_roof_cover);
RenderHouseRoofPlates(house_roof_cover);
RenderHouseCladding(cladding_type);

// yard (uses lower RH_YARD_EH_* eave heights — separate structure)
RenderYardFoundation();
RenderYardFraming();
RenderYardOpenings();
RenderYardRoof(yard_roof_cover);
RenderYardRoofPlates(yard_roof_cover);
RenderYardMesh();

//RenderInterior();
