// v3 build 
include <../../lib/defaults.scad>
include <config.scad>

use <fundament.scad>
use <konstruktions-skelet.scad>
use <vaegge.scad>
use <tagkonstruktion.scad>
use <beklaedning.scad>
use <aabninger.scad>
use <inventar.scad>

show_cladding = true;
show_ground = true;
roof_cover = "tagpap";

module build_v3() {
    pal = DEFAULT_PALETTE;

    // === Aktivt indhold ===
    v3_fundament(show_ground, pal);
    v3_konstruktions_skelet(pal);

    // === Inaktivt — slå til når de er rettet til (uncomment) ===
    //
    // todo.md #3: aabninger (døre + vinduer)
    // if (show_cladding) v3_aabninger(_default_mesh(), pal);
    //
    // todo.md #4: beklaedning (vindpap, klemmelister, klink, voliernet)
    // if (show_cladding) v3_beklaedning(DEFAULT_CLAD, pal);
    //
    // todo.md #5: tagkonstruktion (spær + dækning)
    // v3_tagkonstruktion(roof_cover, pal);
    //
    // Legacy — vil blive foldet ind i konstruktions-skelet/beklaedning:
    // v3_vaegge(DEFAULT_STUD, _default_mesh(), pal);
    // v3_inventar(show_cladding, show_ground, pal);
}

// Helper for re-aktivering af systemer der bruger mesh-spec.
function _default_mesh() = mesh_spec(spacing = V3_MESH_SPACING,
                                      bar     = V3_MESH_BAR,
                                      frame   = V3_MESH_FRAME,
                                      depth   = V3_MESH_DEPTH);

build_v3();
