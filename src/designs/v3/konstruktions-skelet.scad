// konstruktions-skelet.scad — Wood structural skeleton on top of fundament.
// Part of the v3 build pipeline; included from build.scad.
//
// Currently holds the parts of the træ-skelet that are clearly NOT
// foundation (concrete) but sit at the boundary between sokkel and walls:
//   - Murpap (DPC bitumen tape) on top of the fundablok ring
//   - Continuous bundrem (45×95 PT) above the murpap
//
// Over time, the rest of the structural frame currently scattered across
// vaegge.scad (stolper, toprem, losholter, vindkryds, beams) will move
// here too so "konstruktions-skelet" really means the complete wood
// skeleton.

include <../../lib/defaults.scad>
include <config.scad>

MURPAP_COLOR = [0.10, 0.10, 0.12];
MURPAP_T     = 2;          // mm thickness — bitumen DPC tape (visual only)
MURPAP_W     = 100;        // mm width — slightly wider than bundrem (95)

// Continuous murpap (bitumen DPC tape) on top of the fundablok sokkel ring,
// between concrete and the wood bundrem above. Hele vejen rundt + partition.
module v3_murpap_ring() {
    ll = V3_LENGTH; ww = V3_WIDTH; hl = V3_HOUSE_LEN;
    z = V3_BASE_H;
    color(MURPAP_COLOR) {
        translate([0, 0, z])             cube([ll, MURPAP_W, MURPAP_T]);  // front
        translate([0, ww - MURPAP_W, z]) cube([ll, MURPAP_W, MURPAP_T]);  // back
        translate([0, 0, z])             cube([MURPAP_W, ww, MURPAP_T]);  // left
        translate([ll - MURPAP_W, 0, z]) cube([MURPAP_W, ww, MURPAP_T]);  // right
        translate([hl - MURPAP_W/2, 0, z]) cube([MURPAP_W, ww, MURPAP_T]); // partition
    }
}

// Continuous perimeter bundrem on top of the murpap, on top of the ring.
// Visual fill — actual bundrem with full BOM is currently emitted by
// stud_wall calls in vaegge.scad. The two overlap in z (only 2 mm) which
// is invisible inside the bundrem volume.
module v3_bundrem_ring(palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; hl = V3_HOUSE_LEN;
    sd = V3_POST_W;             // 95
    sw = V3_SILL_H;             // 45
    z  = V3_BASE_H + MURPAP_T;  // 122

    color(pal_post(palette)) {
        translate([0, 0, z])           cube([ll, sd, sw]);  // front
        translate([0, ww - sd, z])     cube([ll, sd, sw]);  // back
        translate([0, 0, z])           cube([sd, ww, sw]);  // left
        translate([ll - sd, 0, z])     cube([sd, ww, sw]);  // right
        translate([hl - sd/2, 0, z])   cube([sd, ww, sw]);  // partition
    }
}

// Strøer-gulv inde i hus-delen af fundablok-ringen.
// Ledger fastgjort til ringens inderside; 45×95 strøer hænger i strøsko;
// 18 mm krydsfiner-dæk ovenpå. Flyttet hertil fra fundament.scad — dette
// er træ-skelet, ikke beton-fundament.
module v3_stroer_floor(palette = DEFAULT_PALETTE) {
    hl = V3_HOUSE_LEN; ww = V3_WIDTH; ring_w = 150;  // FUNDABLOK_W
    inner_x0 = ring_w/2;
    inner_x1 = hl - ring_w/2;
    inner_y0 = ring_w/2;
    inner_y1 = ww - ring_w/2;
    inner_w  = inner_x1 - inner_x0;
    inner_d  = inner_y1 - inner_y0;
    z_ledger = V3_FLOOR_LEDGER_Z;

    color(pal_post(palette)) {
        translate([inner_x0 - V3_FLOOR_LEDGER_W, inner_y0, z_ledger])
            cube([V3_FLOOR_LEDGER_W, inner_d, V3_FLOOR_LEDGER_H]);
        translate([inner_x1, inner_y0, z_ledger])
            cube([V3_FLOOR_LEDGER_W, inner_d, V3_FLOOR_LEDGER_H]);
    }

    n_joists = floor(inner_d / V3_FLOOR_JOIST_C2C) + 1;
    joist_z = z_ledger;
    for (i = [0 : n_joists - 1]) {
        y = inner_y0 + i * V3_FLOOR_JOIST_C2C;
        if (y < inner_y1 - V3_FLOOR_JOIST_W/2) {
            color(pal_post(palette))
            translate([inner_x0, y - V3_FLOOR_JOIST_W/2, joist_z])
                cube([inner_w, V3_FLOOR_JOIST_W, V3_FLOOR_JOIST_H]);
        }
    }

    color(pal_floor(palette))
    translate([inner_x0, inner_y0, V3_FLOOR_DECK_Z])
        cube([inner_w, inner_d, V3_FLOOR_DECK_T]);
}

module v3_konstruktions_skelet(palette = DEFAULT_PALETTE) {
    v3_murpap_ring();
    v3_bundrem_ring(palette);
    // v3_stroer_floor(palette);  // aktiveres når vi gennemgår strøer i todo.md #2
}
