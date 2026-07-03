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
// 'skifer', 'tagpap' or 'eternit'
house_roof_cover = "skifer";

// Gable-roof truss pattern.
// 'haneband' or 'gitterspaer'
house_truss      = "haneband";

// Yard is an open-top run — welded-wire lid stretched across the rafters
// (predator-proof, no weather barrier). Other options: "polycarb",
// "tagpap", "eternit".
yard_roof_cover  = "mesh";

// klink | board_on_board
cladding_type    = "klink";

// shared
RenderGround();

// house
RenderHouseFoundation();
RenderHouseBasementFloor(); 
RenderHouseFloorJoists();
RenderHouseFloorHangers();
RenderHouseFloorDeck();
//RenderHouseStairs();
RenderHouseFraming();
RenderHouseOpenings();
// Tag — trin-for-trin, matcher arbejdsplan.md trin 4 + 5. Kommentér kald
// ind/ud for at se hvert byggetrin oven på det forrige. Kun for "skifer";
// tagpap/eternit renderes samlet via else-grenen (så scripts der sætter
// -D house_roof_cover=... stadig virker).
if (house_roof_cover == "skifer") {
    RenderHouseRoofSpaer(house_truss);   // 4: rejs spær m. hanebånd
    RenderHouseRoofUndertag();           // 5: undertag (banevare)
    RenderHouseRoofAfstandslister();     // 5: klemme-/afstandslister 25×50 over spær
    RenderHouseRoofLaegter();            // 5: taglægter 38×73, gauge 225
    RenderHouseRoofStern();              // 5: sternbrædder ved tagfod (overkant flugter lægte-overside)
    RenderHouseRoofFodblik();            // 5: fodblik (zink) over sternen, ud i renden
    RenderHouseRoofSkifer();             // 5: naturskifer 30×60, dobbelt dækning
    RenderHouseRoofVindskeder();         // 5: vindskeder på lægte-enderne
    RenderHouseRoofRygning();            // 5: zink-rygning over kip (sidste trin)
} else {
    RenderHouseRoof(house_roof_cover, house_truss);
    RenderHouseRoofPlates(house_roof_cover);
}
RenderHouseCladding(cladding_type);

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
