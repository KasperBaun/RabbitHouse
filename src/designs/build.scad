// Rabbit-house build — composes fundament, skelet, tag, beklædning, åbninger
include <../lib/defaults.scad>
include <config.scad>

use <fundament.scad>
use <konstruktions-skelet.scad>
use <tagkonstruktion_faelles.scad>
use <tagkonstruktion_tagpap.scad>
use <tagkonstruktion_eternit.scad>
use <beklaedning.scad>
use <aabninger.scad>
use <inventar.scad>

show_cladding = true;       // false = skjul klink + sternbræt + sternkapsel/vindskede + sofitt (= alle trim-stykker)
show_ground = true;
show_cover = true;           // false = skjul cover-lag (vis kun framing)
// "tagpap_osb" | "tagpap" (legacy alias for tagpap_osb)
// "eternit_b7" (flad — kun til layout) | "eternit_10" (10°) | "eternit_14" (14°)
roof_cover = "eternit_b7";

// v3-specifik klink-profil: 25×125 mm gran/lærk klink-brædder, 25 mm
// overlap → step 100 mm. Standard profil hos Stark/Bauhaus i 4200 mm
// længder. Erstatter DEFAULT_CLAD (24×150 m. 40 mm overlap) som er
// v1's profil.
RH_CLAD = clad_spec(board_h=125, overlap=25, thick=25, lip=20);

module build_house() {
    pal = DEFAULT_PALETTE;

    // === Aktivt indhold ===
    rh_fundament(show_ground, pal);
    rh_konstruktions_skelet(pal);
    rh_aabninger(_default_mesh(), pal);
    if (show_cladding) rh_beklaedning(RH_CLAD, pal);

   
    


}

// Helper for re-aktivering af systemer der bruger mesh-spec.
function _default_mesh() = mesh_spec(spacing = RH_MESH_SPACING,
                                      bar     = RH_MESH_BAR,
                                      frame   = RH_MESH_FRAME,
                                      depth   = RH_MESH_DEPTH);

build_house();
