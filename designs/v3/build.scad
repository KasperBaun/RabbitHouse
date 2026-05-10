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

    // --- Yard interior: lush grass at grade ---------------------------
    // Yard grass starts at the slab's east edge (hl+ct) so it doesn't
    // overlap the partition slab strip. Gated on show_ground.
    if (show_ground) {
        v3_yard_grass(hl + ct, rl - ct, ww);
        v3_outdoor_dressing(ll, ww, bh);
    }

    // --- All walls: house framing + yard structure + yard mesh --------
    v3_vaegge(stud, mesh, pal);

    // --- House cladding (front, back, left, partition) ----------------
    if (show_cladding) {
        v3_beklaedning(clad, pal);

        // --- Partition: human door + rabbit pet door ------------------
        v3_partition_door(hl, ct, V3_HOUSE_DOOR_Y, V3_HOUSE_DOOR_W,
                          V3_HOUSE_DOOR_H, bh, pal);
        rabbit_pet_door_yz(hl - wt, V3_PET_DOOR_Y, bh + 60,
                           V3_PET_DOOR_W, V3_PET_DOOR_H, wt, pal);
        // Stone threshold inside the yard at the partition human door —
        // sits on the yard sokkel (top of fundablok ring at Z=bh) plus
        // bracket+sill height, matching the new yard floor level.
        color([0.55, 0.50, 0.40])
        translate([hl + ct + 20, V3_HOUSE_DOOR_Y - 50,
                   bh + V3_SILL_H + 18])
            cube([200, V3_HOUSE_DOOR_W + 100, 12]);

        // --- Side window with trim on left exterior wall (faces -X) ---
        window_with_trim_xneg(0, V3_SIDE_WIN_Y, bh + V3_SIDE_WIN_Z,
                              V3_SIDE_WIN_W, V3_SIDE_WIN_H, ct, pal, true);
    }

    // --- House interior decor (only with cladding shown) ---------------
    if (show_cladding) {
        nest_box_insulated([V3_NEST_X, V3_NEST_Y, bh + 20],
                           V3_NEST_W, V3_NEST_D, V3_NEST_H, pal);
        // Hay/bedding storage cubes (front-left)
        color([0.78, 0.72, 0.40])
        translate([wt + 50, wt + 30, bh + 20])
            cube([400, 600, 700]);
        color(pal_panel1(pal))
        translate([wt + 500, wt + 30, bh + 20])
            cube([400, 600, 900]);
    }

    // --- Yard mesh-and-frame entry door (front, Y=0) -----------------
    v3_yard_door(V3_YARD_DOOR_X, V3_YARD_DOOR_W, V3_YARD_DOOR_H,
                 bh + V3_SILL_H + 18, pal, mesh);

    // --- Unified mono-pitch roof (corrected origin so wall tops align)
    v3_tagkonstruktion(pal);

    // --- Hay rack on house back wall (interior, cladding-mode only) --
    if (show_cladding)
        hay_rack(400, ww - wt, bh + 250, 500, 400, pal);

    // --- Yard amenities: bowls only --------------------------------
    // Yard floor is at Z=bh (sokkel top) + 8 mm grass; bowls and rabbits
    // sit on the grass surface.
    water_bowl(hl + 600, 1500, bh + 8);
    food_bowl(hl + 850, 1500, bh + 8);

    // --- Two rabbits in the yard grass --------------------------------
    translate([hl + rl/2 - 100, ww/2 - 350, bh + 18])  rabbit(angle = 30);
    translate([hl + 700, V3_PET_DOOR_Y - 450, bh + 18]) rabbit_loaf(angle = -10);
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

// Human door in the partition (X=hl outer face, faces +X into yard).
module v3_partition_door(hl, ct, door_y, door_w, door_h, bh, pal) {
    leaf_t = 40;
    leaf_x = hl + ct/2 - leaf_t/2;
    architrave_w = 70;
    architrave_t = 20;
    arch_x = hl + ct + 2;

    color(pal_door(pal))
    translate([leaf_x, door_y, bh])
        cube([leaf_t, door_w, door_h]);
    color(pal_trim(pal))
    for (i = [0 : 3])
        translate([leaf_x + leaf_t - 1, door_y + 50, bh + 200 + i * 400])
            cube([2, door_w - 100, 30]);

    color(pal_trim(pal)) {
        translate([arch_x, door_y - architrave_w + 10, bh + door_h])
            cube([architrave_t, door_w + 2*architrave_w - 20, architrave_w]);
        translate([arch_x, door_y - architrave_w + 10, bh])
            cube([architrave_t, architrave_w, door_h]);
        translate([arch_x, door_y + door_w - 10, bh])
            cube([architrave_t, architrave_w, door_h]);
    }

    color([0.85, 0.85, 0.88]) {
        translate([arch_x + architrave_t, door_y + door_w - 100, bh + 1050])
            cube([25, 60, 25]);
        translate([arch_x + architrave_t + 3, door_y + door_w - 110, bh + 1000])
            cube([8, 80, 110]);
        translate([arch_x + architrave_t + 10, door_y + door_w - 90, bh + 1700])
            cube([15, 70, 22]);
    }
    color([0.30, 0.30, 0.32])
    for (zh = [bh + 200, bh + door_h - 300])
        translate([arch_x + architrave_t + 3, door_y - 5, zh])
            cube([8, 15, 100]);
}

// Yard mesh-and-frame entry door (front, Y=0, swings outward).
module v3_yard_door(door_x, door_w, door_h, sill_top, pal, mesh) {
    md  = ms_depth(mesh);
    sp  = ms_spacing(mesh);
    mb  = ms_bar(mesh);
    fr  = 50;
    z0  = sill_top;
    z1  = sill_top + door_h;

    z_mid = z0 + V3_MID_RAIL_Z_OFFSET;
    color(pal_post(pal)) {
        translate([door_x, -md, z0])               cube([door_w, md, fr]);
        translate([door_x, -md, z1 - fr])          cube([door_w, md, fr]);
        translate([door_x, -md, z0])               cube([fr, md, door_h]);
        translate([door_x + door_w - fr, -md, z0]) cube([fr, md, door_h]);
        translate([door_x, -md, z_mid - fr/2])     cube([door_w, md, fr]);
    }

    color(pal_mesh(pal)) {
        for (band_z = [[z0 + fr, z_mid - fr/2],
                       [z_mid + fr/2, z1 - fr]]) {
            zlo = band_z[0]; zhi = band_z[1];
            for (xx = [door_x + fr + sp/2 : sp : door_x + door_w - fr - sp/2])
                translate([xx - mb/2, -md + (md-mb)/2, zlo])
                    cube([mb, mb, zhi - zlo]);
            for (zz = [zlo + sp/2 : sp : zhi - sp/2])
                translate([door_x + fr, -md + (md-mb)/2, zz - mb/2])
                    cube([door_w - 2*fr, mb, mb]);
        }
    }

    color([0.85, 0.85, 0.88]) {
        translate([door_x + door_w - 90, -md - 25, z0 + 1050])
            cube([60, 25, 25]);
        translate([door_x + door_w - 100, -md - 6, z0 + 1000])
            cube([80, 8, 110]);
        translate([door_x + door_w - 90, -md - 14, z0 + 1700])
            cube([70, 14, 22]);
    }
    color([0.30, 0.30, 0.32])
    for (zh = [z0 + 200, z1 - 300])
        translate([door_x - 8, -md - 8, zh])
            cube([15, 8, 100]);
}

// Yard floor — stabilgrus filled to top of fundablok ring (Z=V3_BASE_H)
// per Phase 1 spec §3.3, with grass/jord on top. Inside the yard, the
// 8 mm grass surface therefore sits at Z=V3_BASE_H..V3_BASE_H+8.
module v3_yard_grass(yard_x0, yard_len, ww) {
    z0 = V3_BASE_H;
    color([0.32, 0.58, 0.22])
    translate([yard_x0, 0, z0])
        cube([yard_len, ww, 8]);
    color([0.40, 0.62, 0.28])
    for (cx = [yard_x0 + 350, yard_x0 + 1100, yard_x0 + 1900,
               yard_x0 + 2700, yard_x0 + 3400])
        for (cy = [350, 950, 1500, 2050])
            translate([cx, cy, z0 + 8])
                cube([280 + (cx % 90), 220 + (cy % 70), 4]);
    color([0.30, 0.50, 0.20])
    for (cx = [yard_x0 + 200, yard_x0 + 600])
        translate([cx, 1500 + cx % 200, z0 + 8])
            cube([180, 160, 3]);
}

// External landscape dressing.
module v3_outdoor_dressing(ll, ww, bh) {
    color([0.55, 0.55, 0.52])
    for (i = [0 : 3])
        translate([V3_YARD_DOOR_X + V3_YARD_DOOR_W/2 + 200*sin(i*60),
                   -2200 - i*420, -3])
            cylinder(h = 14, r = 230, $fn = 8);
}
