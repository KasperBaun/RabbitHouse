// v3 build — solid mono-pitch house on a slab + mesh-only yard
// on ground plugs, all under one continuous mono-pitch roof.
// Entry point: build_v3()
//
// Spatial layout (see config.scad). Human entry: garden → yard front
// mesh door (Y=0) → yard → partition human door (X=hl) → house.

include <../../lib/defaults.scad>
include <config.scad>

use <../../lib/primitives/cladding.scad>
use <../../lib/primitives/mesh.scad>
use <../../lib/primitives/roof.scad>
use <../../lib/primitives/framing.scad>
use <../../lib/primitives/foundation.scad>
use <../../lib/primitives/fundablok.scad>
use <../../lib/primitives/openings.scad>
use <../../lib/decor/landscape.scad>
use <../../lib/decor/lighting.scad>
use <../../lib/decor/rabbit.scad>
use <../../lib/bom.scad>
use <fundament.scad>
use <vaegge.scad>
use <tagkonstruktion.scad>
use <beklaedning.scad>
use <aabninger.scad>
use <inventar.scad>

// Roof-geometry helpers (v3_span_total, v3_total_drop, v3_roof_oz,
// v3_roof_under) live in config.scad so per-system files like vaegge.scad
// see them via `include <config.scad>` (use-imported files don't share
// build.scad's lexical scope, so functions defined here would be undef
// inside their callees).

// `show_cladding=false` hides the wall cladding, doors, and window trim so the
// structural frame (studs, plates, beams, posts) is visible — useful for
// auditing framing against TIMBER-FRAMING.md and counting timber.
// `show_ground=false` hides the grass / gravel path / outdoor dressing so
// the buried fundablok strip foundation (Z<0) is visible from above.
module build_v3(show_cladding=true, show_ground=true) {
    bom_header();
    pal  = DEFAULT_PALETTE;
    clad = DEFAULT_CLAD;
    mesh = mesh_spec(spacing = V3_MESH_SPACING,
                     bar     = V3_MESH_BAR,
                     frame   = V3_MESH_FRAME,
                     depth   = V3_MESH_DEPTH);
    stud = DEFAULT_STUD;

    ll  = V3_LENGTH;
    ww  = V3_WIDTH;
    bh  = V3_BASE_H;
    wt  = V3_WALL_T;
    hl  = V3_HOUSE_LEN;
    rl  = V3_RUN_LEN;
    ehf = V3_EH_FRONT;
    ehb = V3_EH_BACK;
    ct  = cs_thick(clad);
    fpw = V3_POST_W;

    roof_oz = v3_roof_oz();
    drop_full = v3_total_drop();

    // --- Foundation: ring + floor + apron + ground/path ---------------
    v3_fundament(show_ground, pal);

    // --- All walls: house framing + yard structure + yard mesh --------
    v3_vaegge(stud, mesh, pal);

    // --- House cladding (front, back, left, partition) ----------------
    if (show_cladding) {
        v3_beklaedning(clad, pal);
        v3_aabninger(mesh, pal);
    }

    // --- Unified mono-pitch roof (corrected origin so wall tops align)
    v3_tagkonstruktion(pal);

    // --- Inventar: grass, nest box, hay rack, bowls, rabbits, dressing -
    v3_inventar(show_cladding, show_ground, pal);
}

