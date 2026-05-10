// fundament.scad — Foundation: ring + floor + apron + ground/path
// Part of the v3 build pipeline; included from build.scad.

include <../../lib/defaults.scad>
include <config.scad>
use <../../lib/primitives/fundablok.scad>
use <../../lib/primitives/foundation.scad>
use <../../lib/primitives/beslag.scad>
use <../../lib/decor/landscape.scad>
use <../../lib/decor/rabbit.scad>
use <../../lib/bom.scad>

// Strøer floor inside the house portion of the fundablok ring.
// Ledger bolted to ring's inner face; 45×95 strøer hang in stroesko;
// 18 mm krydsfiner deck on top.
module v3_stroer_floor(palette = DEFAULT_PALETTE) {
    hl = V3_HOUSE_LEN; ww = V3_WIDTH; ring_w = 150;  // FUNDABLOK_W
    inner_x0 = ring_w/2;
    inner_x1 = hl - ring_w/2;
    inner_y0 = ring_w/2;
    inner_y1 = ww - ring_w/2;
    inner_w  = inner_x1 - inner_x0;
    inner_d  = inner_y1 - inner_y0;
    z_ledger = V3_FLOOR_LEDGER_Z;

    // Two ledger bjælker along Y faces (X=inner_x0 and X=inner_x1).
    bom_member("ledger", "pt-pine", V3_FLOOR_LEDGER_W, V3_FLOOR_LEDGER_H,
               inner_d, "floor_ledger", system="fundament", count=2);
    color(pal_post(palette)) {
        translate([inner_x0 - V3_FLOOR_LEDGER_W, inner_y0, z_ledger])
            cube([V3_FLOOR_LEDGER_W, inner_d, V3_FLOOR_LEDGER_H]);
        translate([inner_x1, inner_y0, z_ledger])
            cube([V3_FLOOR_LEDGER_W, inner_d, V3_FLOOR_LEDGER_H]);
    }

    // Strøer span X between ledgers; spaced along Y at V3_FLOOR_JOIST_C2C.
    n_joists = floor(inner_d / V3_FLOOR_JOIST_C2C) + 1;
    joist_z = z_ledger;
    for (i = [0 : n_joists - 1]) {
        y = inner_y0 + i * V3_FLOOR_JOIST_C2C;
        if (y < inner_y1 - V3_FLOOR_JOIST_W/2) {
            bom_member("joist", "pt-pine", V3_FLOOR_JOIST_W, V3_FLOOR_JOIST_H,
                       inner_w, "floor_joist", system="fundament");
            color(pal_post(palette))
            translate([inner_x0, y - V3_FLOOR_JOIST_W/2, joist_z])
                cube([inner_w, V3_FLOOR_JOIST_W, V3_FLOOR_JOIST_H]);
        }
    }

    // 18 mm krydsfiner deck.
    bom_member("krydsfiner", "ply-18mm", inner_w, inner_d, V3_FLOOR_DECK_T,
               "floor_deck", system="fundament");
    color(pal_floor(palette))
    translate([inner_x0, inner_y0, V3_FLOOR_DECK_Z])
        cube([inner_w, inner_d, V3_FLOOR_DECK_T]);
}

// `show_ground=false` hides the ground / gravel path so the buried fundablok
// ring foundation (Z<0) is visible from above.
module v3_fundament(show_ground = true, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; bh = V3_BASE_H; wt = V3_WALL_T;
    hl = V3_HOUSE_LEN; rl = V3_RUN_LEN;
    ct = 22;  // klink thickness — Sub-phase D may rebase this when slab is replaced

    if (show_ground) {
        ground_grass([ll/2, ww/2]);
        gravel_path_y([V3_YARD_DOOR_X + V3_YARD_DOOR_W/2, 0]);
    }

    // Top at Z=bh (sokkel-niveau per Phase 1 spec — "Top af ring =
    // sokkel-niveau (= base h), bundrem af alle vægge sidder her"); the
    // ring stands 120 mm proud of grade and extends 480 mm below into
    // the frostfri grøft (600 mm total). This is what makes the ring
    // visible around the yard — without `top_z`, the whole ring sits
    // at/below grade and the surrounding grass plane buries it.
    fundablok_ring(ll, ww, 3, [hl], top_z = bh);

    // Ankerskruer M10 c/c 1000 mm along the perimeter ring + partition cross-wall.
    // Head sits at Z=bh (top of ring = sokkel level); shaft sinks 120 mm into ring.
    for (x = [500 : 1000 : ll - 500]) {
        ankerskrue_m10([x, 0]);    // front sill line
        ankerskrue_m10([x, ww]);   // back sill line
    }
    for (y = [500 : 1000 : ww - 500]) {
        ankerskrue_m10([0, y]);    // left sill line
        ankerskrue_m10([ll, y]);   // right sill line
        ankerskrue_m10([hl, y]);   // partition cross-wall
    }

    v3_stroer_floor(palette);
    rabbit_floor_grass([wt, wt], [hl - 2*wt, ww - 2*wt], bh);

    apron_skirt([hl, 0, ll, ww], V3_APRON_W,
                ["front", "back", "right"], palette);
}
