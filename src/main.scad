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

// tagpap_osb | eternit_b7 | eternit_10 | eternit_14
roof_cover    = "eternit_b7";

// klink | board_on_board
cladding_type = "klink";

// shared
RenderGround();

// house — standalone view (yard block commented out below). Pass
// standalone=true to RenderHouseRoofPlates so the cover gets its full right
// overhang + side fascia cap (in combined builds yard provides those).
RenderHouseFoundation();
RenderHouseFraming();
RenderHouseOpenings();
RenderHouseRoof(roof_cover);
RenderHouseRoofPlates(roof_cover, standalone = true);
RenderHouseCladding(cladding_type);

// yard — uncomment to render the full combined build.
//RenderYardFoundation();
//RenderYardFraming();
//RenderYardOpenings();
//RenderYardRoof(roof_cover);
//RenderYardRoofPlates(roof_cover);
//RenderYardMesh();

//RenderInterior();
