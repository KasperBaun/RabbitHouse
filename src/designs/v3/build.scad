// v3 build — composes the per-system modules + toggles + the call.
// Open this file (or include from main.scad) to render the v3 model.
//
// File layout: see README.md. Each per-system file (fundament,
// konstruktions-skelet, vaegge, tagkonstruktion, beklaedning, aabninger,
// inventar) covers ONE building system. Toggles live here at the top of
// build.scad — flip them, save, re-render.

include <../../lib/defaults.scad>
include <config.scad>

use <fundament.scad>
use <konstruktions-skelet.scad>
use <vaegge.scad>
use <tagkonstruktion.scad>
use <beklaedning.scad>
use <aabninger.scad>
use <inventar.scad>

// ============================================================================
// Toggles — edit these, save, re-render.
// CLI override via `-D show_cladding=false` etc.
// ============================================================================

// Hide klink/doors/window so the wood frame, bats, vindkryds are visible.
show_cladding = true;

// Hide grass / gravel path / yard fill so the buried fundablok ring is
// visible from above. The 12 cm sokkel above grade stays visible regardless.
show_ground = true;

// Tag-dækning: "tagpap" | "stål" (eller ASCII "staal") | "eternit_10" | "eternit_14".
// "tagpap" og "stål" virker på v3's nuværende hældning (9°); eternit-varianterne
// sænker eh_back automatisk så hældningen overholder Cembrit B6's profil.
roof_cover = "tagpap";

// ============================================================================

module build_v3() {
    pal = DEFAULT_PALETTE;

    // === Aktivt indhold ===
    // Vi nedbryder modellen pr. todo.md — slå systemer til efterhånden
    // som de er rettet til. Lige nu ser vi KUN fundamentet.
    v3_fundament(show_ground, pal);

    // todo.md #2: konstruktions-skelet (DPC + sill plate + studs + top plate)
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
