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
use <../../lib/bom.scad>

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
    bom_header();
    pal  = DEFAULT_PALETTE;
    clad = DEFAULT_CLAD;
    mesh = mesh_spec(spacing = V3_MESH_SPACING,
                     bar     = V3_MESH_BAR,
                     frame   = V3_MESH_FRAME,
                     depth   = V3_MESH_DEPTH);
    stud = DEFAULT_STUD;

    v3_fundament(show_ground, pal);
    v3_konstruktions_skelet(pal);
    v3_vaegge(stud, mesh, pal);
    v3_tagkonstruktion(roof_cover, pal);
    if (show_cladding) v3_beklaedning(clad, pal);
    if (show_cladding) v3_aabninger(mesh, pal);
    v3_inventar(show_cladding, show_ground, pal);
}

build_v3();
