// Rabbit-house — top-level dispatcher. Toggles og byggetrin er beskrevet i
// CLAUDE.md og designs/README.md.
$fn = 48;

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

// toggles
house_roof_cover = "skifer";     // skifer | tagpap | eternit
yard_roof_cover  = "mesh";       // mesh | polycarb | tagpap | eternit
cladding_type    = "klink";      // klink | board_on_board

// Huset er sortmalet. Konstruktionstræ (pal_post) står ubehandlet.
PALETTE = palette(panel1 = [0.13, 0.13, 0.14],   // beklædning
                  panel2 = [0.10, 0.10, 0.11],
                  trim   = [0.09, 0.09, 0.10],   // indfatning, hjørner
                  wall   = [0.12, 0.12, 0.13],
                  door   = [0.80, 0.68, 0.42],   // bar krydsfiner
                  soffit = [0.13, 0.13, 0.14],   // sofit
                  barge  = [0.09, 0.09, 0.10]);  // vindskede

// shared
RenderGround();

// house
RenderHouseFoundation(PALETTE);
RenderHouseBasementFloor(PALETTE);
RenderHouseFloorJoists(PALETTE);
RenderHouseFloorHangers();
RenderHouseFloorDeck(PALETTE);
//RenderHouseStairs(PALETTE);
RenderHouseFraming(PALETTE);
RenderHouseOpenings(PALETTE);
RenderHouseV4Doors(PALETTE);   // hus-dør mod løbegården — ikke bygget

// tag, trin for trin (arbejdsplan trin 4-5) — kommentér ud nedefra
if (house_roof_cover == "skifer") {
    RenderHouseRoofSpaer(PALETTE);           // spær m. hanebånd
    RenderHouseRoofUdhaeng(PALETTE);         // udhængsspær + klodser (gavl)
    //RenderHouseRoofSofit(PALETTE);           // sofit
    //RenderHouseRoofUndertag();               // undertag
    //RenderHouseRoofAfstandslister(PALETTE);  // afstandslister 25×50
    //RenderHouseRoofLaegter(PALETTE);         // taglægter 38×73
    //RenderHouseRoofStern(PALETTE);           // stern
    //RenderHouseRoofFodblik();                // fodblik
    //RenderHouseRoofSkifer();                 // skifer 30×60
    //RenderHouseRoofVindskeder(PALETTE);      // vindskeder
    //RenderHouseRoofRygning();                // rygning
} else {
    RenderHouseRoof(house_roof_cover, PALETTE);
    RenderHouseRoofPlates(house_roof_cover, palette = PALETTE);
}
RenderHouseCladding(cladding_type, PALETTE);

// yard — ikke bygget endnu
//RenderYardFoundation();
//RenderYardFraming();
//RenderYardOpenings();
//if (yard_roof_cover != "mesh") RenderYardRoof(yard_roof_cover);
//RenderYardRoofPlates(yard_roof_cover);
//RenderYardMesh();
