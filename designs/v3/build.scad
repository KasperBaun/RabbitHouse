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

// roof_mono_pitch interprets eave_h/drop across the FULL overhang span.
// These helpers convert "wall-face eave heights" into the parameters that
// give an aligned roof underside at the wall faces (so wall tops don't
// poke through the roof at the inner edges).
function v3_span_total() = V3_OH_FRONT + V3_WIDTH + V3_OH_BACK;
function v3_total_drop() =
    (V3_EH_FRONT - V3_EH_BACK) * v3_span_total() / V3_WIDTH;
function v3_roof_oz() =
    V3_BASE_H + V3_EH_FRONT + V3_OH_FRONT * v3_total_drop() / v3_span_total();
// Roof underside z at any Y (in structure coords, where Y=0 is front face).
function v3_roof_under(y) =
    v3_roof_oz() - (V3_OH_FRONT + y) * v3_total_drop() / v3_span_total();

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

    // --- House structural framing -------------------------------------
    v3_house_framing(hl, ww, ehf, ehb, bh, wt, fpw, stud, pal);

    // --- House cladding (front, back, left, partition) ----------------
    if (show_cladding) {
        v3_house_cladding(hl, ww, ehf, ehb, bh, ct, pal, clad);
        v3_house_corner_trims(hl, ww, ehf, ehb, bh, ct, pal);

        // --- Partition: human door + rabbit pet door ------------------
        v3_partition_door(hl, ct, V3_HOUSE_DOOR_Y, V3_HOUSE_DOOR_W,
                          V3_HOUSE_DOOR_H, bh, pal);
        rabbit_pet_door_yz(hl - wt, V3_PET_DOOR_Y, bh + 60,
                           V3_PET_DOOR_W, V3_PET_DOOR_H, wt, pal);
        // Stone threshold inside the yard at the partition human door
        color([0.55, 0.50, 0.40])
        translate([hl + ct + 20, V3_HOUSE_DOOR_Y - 50,
                   V3_SILL_H + 18])
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

    // --- Yard structure: ground plugs + corner posts + sloped beams ----
    v3_yard_posts_and_sills(hl, rl, ww, bh, fpw, ct, pal);
    v3_yard_top_beams(hl, rl, ww, fpw, ct, pal);
    v3_yard_stiles(hl, rl, ww, fpw, pal);

    // --- Yard mesh on three exterior sides ---------------------------
    v3_yard_mesh_front(hl, rl, ww, fpw, ct, pal, mesh);
    v3_yard_mesh_back(hl, rl, ww, fpw, ct, pal, mesh);
    v3_yard_mesh_right(hl, rl, ww, fpw, pal, mesh);

    // --- Yard mesh-and-frame entry door (front, Y=0) -----------------
    v3_yard_door(V3_YARD_DOOR_X, V3_YARD_DOOR_W, V3_YARD_DOOR_H,
                 V3_SILL_H + 18, pal, mesh);

    // --- Unified mono-pitch roof (corrected origin so wall tops align)
    roof_mono_pitch([0, 0, roof_oz], ll, ww, drop_full, V3_ROOF_THICK,
                    V3_OH_FRONT, V3_OH_BACK, V3_OH_SIDE, pal);
    fascia_and_gutter_mono([0, 0, roof_oz], ll, ww, drop_full,
                           150, 22, V3_OH_FRONT, V3_OH_BACK, V3_OH_SIDE,
                           110, 65, 0, pal);
    rafter_eave_h = v3_roof_under(wt);
    rafter_drop = v3_roof_under(wt) - v3_roof_under(ww - wt);
    // x_inset shifts the rafter line east of the partition stud wall
    // (x=hl-sd..hl) so no rafter clips the wall — first rafter at x=155,
    // partition rafter lands at x=1955.
    ceiling_rafters_mono([0, 0, 0], ll, ww, rafter_drop, rafter_eave_h,
                         900, 45, 140, wt, pal, x_inset = wt + 55);

    // --- Hay rack on house back wall (interior, cladding-mode only) --
    if (show_cladding)
        hay_rack(400, ww - wt, bh + 250, 500, 400, pal);

    // --- Yard amenities: bowls only --------------------------------
    water_bowl(hl + 600, 1500, 8);
    food_bowl(hl + 850, 1500, 8);

    // --- Two rabbits in the yard grass --------------------------------
    translate([hl + rl/2 - 100, ww/2 - 350, 18])  rabbit(angle = 30);
    translate([hl + 700, V3_PET_DOOR_Y - 450, 18]) rabbit_loaf(angle = -10);
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

module v3_yard_grass(yard_x0, yard_len, ww) {
    color([0.32, 0.58, 0.22])
    translate([yard_x0, 0, 0])
        cube([yard_len, ww, 8]);
    color([0.40, 0.62, 0.28])
    for (cx = [yard_x0 + 350, yard_x0 + 1100, yard_x0 + 1900,
               yard_x0 + 2700, yard_x0 + 3400])
        for (cy = [350, 950, 1500, 2050])
            translate([cx, cy, 8])
                cube([280 + (cx % 90), 220 + (cy % 70), 4]);
    color([0.30, 0.50, 0.20])
    for (cx = [yard_x0 + 200, yard_x0 + 600])
        translate([cx, 1500 + cx % 200, 8])
            cube([180, 160, 3]);
}

module v3_house_framing(hl, ww, ehf, ehb, bh, wt, fpw, stud, pal) {
    sd       = ss_d(stud);
    sw       = ss_w(stud);
    air_gap  = 10;                   // 5–10 mm air gap per TIMBER-FRAMING.md
    z_sill   = bh + air_gap;         // bundrem bottom
    z_bp_top = z_sill + sw;          // bundrem top — door rough-opening floor

    // Damp-proof course (fugtspærre) directly on slab top, under each bundrem
    dpc_strip([0, 0, bh], hl, "X", sd);
    dpc_strip([0, ww - sd, bh], hl, "X", sd);
    dpc_strip([0, 0, bh], ww, "Y", sd);
    dpc_strip([hl - sd, 0, bh], ww, "Y", sd);

    // Front and back walls — top plate slopes across the wall thickness so
    // the toprem follows the roof underside instead of clipping it. Both
    // ends use v3_roof_under(y) to derive heights at the outer (oy) and
    // inner (oy+sd) wall faces.
    stud_wall([0, 0, z_sill], hl,
              v3_roof_under(0)      - z_sill, "X", stud, pal,
              h_inner = v3_roof_under(sd)        - z_sill);
    stud_wall([0, ww - sd, z_sill], hl,
              v3_roof_under(ww - sd) - z_sill, "X", stud, pal,
              h_inner = v3_roof_under(ww)        - z_sill);

    // Side and partition walls — sloped top plates that bear directly on
    // rafters; the top plate underside follows the roof line. No separate
    // top beam (the sloped top plate is the sole top member; 3 m span is
    // within single-plate capacity for the rabbit-house load).
    // skip_ranges removes regular studs that would land inside an opening
    // — jambs are emitted by framed_opening_y just below.
    left_skip      = [[V3_SIDE_WIN_Y, V3_SIDE_WIN_Y + V3_SIDE_WIN_W]];
    partition_skip = [
        [V3_HOUSE_DOOR_Y, V3_HOUSE_DOOR_Y + V3_HOUSE_DOOR_W],
        [V3_PET_DOOR_Y,   V3_PET_DOOR_Y   + V3_PET_DOOR_W]
    ];
    stud_wall_sloped([0, 0, z_sill], ww, ehf - air_gap, ehb - air_gap,
                     "Y", stud, pal, left_skip);
    stud_wall_sloped([hl - sd, 0, z_sill], ww, ehf - air_gap, ehb - air_gap,
                     "Y", stud, pal, partition_skip);

    // Framed openings — jamb studs, header, cripples (and rough sill for
    // the window). Wall heights mirror the parent stud_wall_sloped so the
    // top-plate slope interpolation matches.
    framed_opening_y([0, 0, z_sill], ww, ehf - air_gap, ehb - air_gap,
                     V3_SIDE_WIN_Y, V3_SIDE_WIN_W,
                     bh + V3_SIDE_WIN_Z, V3_SIDE_WIN_H,
                     has_sill = true, stud = stud, palette = pal);
    framed_opening_y([hl - sd, 0, z_sill], ww, ehf - air_gap, ehb - air_gap,
                     V3_HOUSE_DOOR_Y, V3_HOUSE_DOOR_W,
                     z_bp_top, V3_HOUSE_DOOR_H - air_gap - sw,
                     has_sill = false, stud = stud, palette = pal);
    framed_opening_y([hl - sd, 0, z_sill], ww, ehf - air_gap, ehb - air_gap,
                     V3_PET_DOOR_Y, V3_PET_DOOR_W,
                     bh + 60, V3_PET_DOOR_H,
                     has_sill = false, stud = stud, palette = pal);

    // Interior collar tie at hl/2 — 45×195 reglar tying the front-back
    // rafters across the centre. Y span is sd..ww-sd so the tie ends at
    // the inner faces of front and back walls (bearing on each toprem)
    // instead of passing through them. Top z follows the roof underside
    // at each end so the tie sits flush under the rafters.
    bom_member("collar_tie", "spruce", V3_COLLAR_TIE_W, V3_COLLAR_TIE_H,
               ww - 2*sd, "interior_collar_tie");
    color(pal_post(pal))
    hull() {
        translate([hl/2 - V3_COLLAR_TIE_W/2, sd,
                   v3_roof_under(sd) - V3_COLLAR_TIE_H])
            cube([V3_COLLAR_TIE_W, 0.01, V3_COLLAR_TIE_H]);
        translate([hl/2 - V3_COLLAR_TIE_W/2, ww - sd - 0.01,
                   v3_roof_under(ww - sd) - V3_COLLAR_TIE_H])
            cube([V3_COLLAR_TIE_W, 0.01, V3_COLLAR_TIE_H]);
    }
}

// External corner trim posts (45×45 vertical) at the four house cladding
// corners. Each post overlaps both cladding faces at the corner so the raw
// klink board end-grain is covered, matching standard Danish carpentry.
// Heights follow the wall: back corners use ehb, front corners use ehf.
module v3_house_corner_trims(hl, ww, ehf, ehb, bh, ct, pal) {
    tw = 45;
    color(pal_trim(pal)) {
        translate([-ct,           -ct,            bh]) cube([tw, tw, ehf]);
        translate([hl + ct - tw,  -ct,            bh]) cube([tw, tw, ehf]);
        translate([-ct,           ww + ct - tw,   bh]) cube([tw, tw, ehb]);
        translate([hl + ct - tw,  ww + ct - tw,   bh]) cube([tw, tw, ehb]);
    }
}

// House cladding: front (no door), back, left (with side window cutout),
// partition (with house door + pet door cutouts via inline difference()).
module v3_house_cladding(hl, ww, ehf, ehb, bh, ct, pal, clad) {
    clad_wall_rect([0, -ct, bh], hl, ehf, "X", pal, clad);
    clad_wall_rect([0, ww, bh], hl, ehb, "X", pal, clad);
    clad_wall_mono_pitch_with_cutout([-ct, 0, bh], ww, ehf, ehb, "Y",
        pal, clad,
        [V3_SIDE_WIN_Y, V3_SIDE_WIN_Y + V3_SIDE_WIN_W,
         V3_SIDE_WIN_Z, V3_SIDE_WIN_Z + V3_SIDE_WIN_H]);
    fpw = V3_POST_W;
    difference() {
        clad_wall_mono_pitch([hl, 0, bh], ww, ehf, ehb, "Y", pal, clad);
        translate([hl - 10, V3_PET_DOOR_Y, bh + 60])
            cube([ct + 20, V3_PET_DOOR_W, V3_PET_DOOR_H]);
        translate([hl - 10, V3_HOUSE_DOOR_Y, bh])
            cube([ct + 20, V3_HOUSE_DOOR_W, V3_HOUSE_DOOR_H]);
        // Yard front beam pass-through (sloped notch matching the beam).
        hull() {
            translate([hl - 10, 0, v3_roof_under(0) - V3_BEAM_H])
                cube([ct + 20, 0.01, V3_BEAM_H]);
            translate([hl - 10, fpw - 0.01,
                       v3_roof_under(fpw) - V3_BEAM_H])
                cube([ct + 20, 0.01, V3_BEAM_H]);
        }
        // Yard back beam pass-through.
        hull() {
            translate([hl - 10, ww - fpw,
                       v3_roof_under(ww - fpw) - V3_BEAM_H])
                cube([ct + 20, 0.01, V3_BEAM_H]);
            translate([hl - 10, ww - 0.01,
                       v3_roof_under(ww) - V3_BEAM_H])
                cube([ct + 20, 0.01, V3_BEAM_H]);
        }
    }
}

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

// Yard right-end corner reglar + sill plates.
//   The yard's LEFT corners (at the partition X=hl) are NOT separate
//   members — the partition wall and its cladding (X=hl..hl+ct) already
//   provide the structural corner, and putting wood at X=hl..hl+fpw would
//   either poke through the partition cladding or leave a visible gap
//   behind it. Sills/beams/mesh on the yard side start just east of the
//   partition cladding's outer face, at X = hl + ct.
//
//   Right-end corners are 45×95 reglar (was 95×95 stolper before the
//   continuous fundablok ring carried the load line — a thinner corner
//   reglar is sufficient). The reglar sits 45 mm thin along X with its
//   outer face flush at X=hl+rl, and 95 mm wide along Y matching the
//   adjacent sill / beam Y-envelope. It rests on a steel post-base
//   bracket (18 mm) directly on the fundablok ring top (Z=0).
module v3_yard_posts_and_sills(hl, rl, ww, bh, fpw, ct, pal) {
    reglar_t = 45;          // thin dimension along X (the "45" of 45×95)

    corner_reglar = [
        [hl + rl - reglar_t, 0,        v3_roof_under(0)],
        [hl + rl - reglar_t, ww - fpw, v3_roof_under(ww - fpw)]
    ];

    // Steel post-base brackets sized to the 45×95 reglar, sitting on the
    // fundablok ring top.
    for (p = corner_reglar)
        bom_member("bracket", "steel-galv", reglar_t + 16, fpw + 16, 18,
                   "yard_corner_post_base");

    color([0.30, 0.30, 0.32])
    for (p = corner_reglar)
        translate([p[0] - 8, p[1] - 8, 0])
            cube([reglar_t + 16, fpw + 16, 18]);

    // Yard corner reglar (bracket top → roof underside).
    z0 = 18;
    for (p = corner_reglar)
        bom_member("reglar", "pt-pine", reglar_t, fpw, p[2] - z0,
                   "yard_corner_reglar");

    color(pal_post(pal))
    for (p = corner_reglar) {
        translate([p[0], p[1], z0])
            cube([reglar_t, fpw, p[2] - z0]);
    }

    sill_z = 18;

    // BOM — yard sills (4 segments)
    front_left_len  = V3_YARD_DOOR_X - (hl + ct);
    front_right_len = (hl + rl - fpw) - (V3_YARD_DOOR_X + V3_YARD_DOOR_W);
    if (front_left_len > 0)
        bom_member("sill", "pt-pine", fpw, V3_SILL_H, front_left_len,
                   "yard_front_sill_left");
    if (front_right_len > 0)
        bom_member("sill", "pt-pine", fpw, V3_SILL_H, front_right_len,
                   "yard_front_sill_right");
    bom_member("sill", "pt-pine", fpw, V3_SILL_H, rl - ct - fpw,
               "yard_back_sill");
    bom_member("sill", "pt-pine", fpw, V3_SILL_H, ww - 2*fpw,
               "yard_right_sill");

    color(pal_post(pal)) {
        // Front sill, segment LEFT of the yard door
        if (V3_YARD_DOOR_X > hl + ct)
            translate([hl + ct, 0, sill_z])
                cube([front_left_len, fpw, V3_SILL_H]);
        // Front sill, segment RIGHT of the yard door
        if (V3_YARD_DOOR_X + V3_YARD_DOOR_W < hl + rl - fpw)
            translate([V3_YARD_DOOR_X + V3_YARD_DOOR_W, 0, sill_z])
                cube([front_right_len, fpw, V3_SILL_H]);
        // Back sill — continuous from partition cladding's outer face to
        // the right-end corner post.
        translate([hl + ct, ww - fpw, sill_z])
            cube([rl - ct - fpw, fpw, V3_SILL_H]);
        // Right end sill
        translate([hl + rl - fpw, fpw, sill_z])
            cube([fpw, ww - 2*fpw, V3_SILL_H]);
    }
}

// Sloped front and back top beams (top face follows the roof underside).
// Beams extend west to x=hl-fpw so they overlap the partition wall (its
// stud_wall_sloped's top plate at x=hl-sd..hl) — providing direct bearing
// onto the partition wall studs at the yard's left corners. The geometry
// represents a doubled top plate / notched-header detail at the corner.
module v3_yard_top_beams(hl, rl, ww, fpw, ct, pal) {
    bx0 = hl - fpw;            // beam west end
    blen = rl + fpw;           // beam length

    bom_member("beam", "limtree", fpw, V3_BEAM_H, blen, "yard_front_beam");
    bom_member("beam", "limtree", fpw, V3_BEAM_H, blen, "yard_back_beam");

    color(pal_post(pal))
    hull() {
        translate([bx0, 0, v3_roof_under(0) - V3_BEAM_H])
            cube([blen, 0.01, V3_BEAM_H]);
        translate([bx0, fpw - 0.01, v3_roof_under(fpw) - V3_BEAM_H])
            cube([blen, 0.01, V3_BEAM_H]);
    }
    color(pal_post(pal))
    hull() {
        translate([bx0, ww - fpw, v3_roof_under(ww - fpw) - V3_BEAM_H])
            cube([blen, 0.01, V3_BEAM_H]);
        translate([bx0, ww - 0.01, v3_roof_under(ww) - V3_BEAM_H])
            cube([blen, 0.01, V3_BEAM_H]);
    }
    top_beam_sloped_y(hl + rl - fpw, fpw, ww - 2*fpw,
                      v3_roof_under(fpw), v3_roof_under(ww - fpw),
                      fpw, V3_BEAM_H, pal);
}

// 1 m wood vertical stiles along yard mesh walls.
//   Front: one stile past the door's right frame (door's own L/R frames
//          act as the 1 m stiles around the door opening).
//   Back:  every 1 m from partition.
//   Right: every 1 m from the front corner.
module v3_yard_stiles(hl, rl, ww, fpw, pal) {
    sw = V3_STILE_W;
    sill_top = V3_SILL_H + 18;

    front_xs = [hl + 3000];
    front_beam_top = v3_roof_under(0) - V3_BEAM_H;
    for (xs = front_xs)
        bom_member("stile", "spruce", sw, sw,
                   front_beam_top - sill_top, "yard_front_stile");
    color(pal_post(pal))
    for (xs = front_xs)
        translate([xs - sw/2, 0, sill_top])
            cube([sw, sw, front_beam_top - sill_top]);

    back_xs = [hl + 1000, hl + 2000, hl + 3000];
    back_beam_top = v3_roof_under(ww) - V3_BEAM_H;
    for (xs = back_xs)
        bom_member("stile", "spruce", sw, sw,
                   back_beam_top - sill_top, "yard_back_stile");
    color(pal_post(pal))
    for (xs = back_xs)
        translate([xs - sw/2, ww - sw, sill_top])
            cube([sw, sw, back_beam_top - sill_top]);

    right_ys = [fpw + 1000, fpw + 2000];
    color(pal_post(pal))
    for (ys = right_ys) {
        beam_top = v3_roof_under(ys) - V3_BEAM_H;
        bom_member("stile", "spruce", sw, sw,
                   beam_top - sill_top, "yard_right_stile");
        translate([hl + rl - sw, ys - sw/2, sill_top])
            cube([sw, sw, beam_top - sill_top]);
    }
}

// Horizontal mid-rail in a mesh panel oriented along X (front/back walls).
module v3_mesh_midrail_x(panel_x, panel_w, y_pos, z_center, mesh, pal) {
    md = ms_depth(mesh);
    color(pal_trim(pal))
    translate([panel_x, y_pos, z_center - V3_MID_RAIL_H/2])
        cube([panel_w, md, V3_MID_RAIL_H]);
}

// Horizontal mid-rail in a mesh panel oriented along Y (right end).
module v3_mesh_midrail_y(panel_y, panel_w, x_pos, z_center, mesh, pal) {
    md = ms_depth(mesh);
    color(pal_trim(pal))
    translate([x_pos, panel_y, z_center - V3_MID_RAIL_H/2])
        cube([md, panel_w, V3_MID_RAIL_H]);
}

// Front mesh — three rectangular panels (left of door, between door and
// stile at hl+3000, between stile and right corner) PLUS a transom mesh
// panel above the yard door so the predator perimeter stays unbroken.
// Each panel gets a horizontal mid-rail at sill_top + V3_MID_RAIL_Z_OFFSET
// so the wood line is continuous across the whole front wall.
module v3_yard_mesh_front(hl, rl, ww, fpw, ct, pal, mesh) {
    md = ms_depth(mesh);
    sill_top = V3_SILL_H + 18;
    h = (v3_roof_under(0) - V3_BEAM_H) - sill_top;
    z_rail = sill_top + V3_MID_RAIL_Z_OFFSET;
    seg_xs = [
        [hl + ct,                          V3_YARD_DOOR_X],
        [V3_YARD_DOOR_X + V3_YARD_DOOR_W,  hl + 3000],
        [hl + 3000,                        hl + rl - fpw]
    ];
    for (s = seg_xs)
        if (s[1] - s[0] > 100) {
            mesh_panel_x(s[0], s[1] - s[0], sill_top, h, -md, pal, mesh);
            v3_mesh_midrail_x(s[0], s[1] - s[0], -md, z_rail, mesh, pal);
        }

    // Transom mesh above the yard door
    door_top_z = sill_top + V3_YARD_DOOR_H;
    transom_h = (sill_top + h) - door_top_z;
    if (transom_h > 50)
        mesh_panel_x(V3_YARD_DOOR_X, V3_YARD_DOOR_W, door_top_z, transom_h,
                     -md, pal, mesh);
}

// Back mesh — four rectangular panels broken by stiles every 1 m, starting
// at hl+ct so the panels meet the partition cladding flush.
module v3_yard_mesh_back(hl, rl, ww, fpw, ct, pal, mesh) {
    md = ms_depth(mesh);
    sill_top = V3_SILL_H + 18;
    h = (v3_roof_under(ww) - V3_BEAM_H) - sill_top;
    z_rail = sill_top + V3_MID_RAIL_Z_OFFSET;
    breaks = [hl + ct, hl + 1000, hl + 2000, hl + 3000, hl + rl - fpw];
    for (i = [0 : len(breaks) - 2]) {
        x0 = breaks[i]; x1 = breaks[i + 1];
        if (x1 - x0 > 100) {
            mesh_panel_x(x0, x1 - x0, sill_top, h, ww - md, pal, mesh);
            v3_mesh_midrail_x(x0, x1 - x0, ww - md, z_rail, mesh, pal);
        }
    }
}

// Right end mesh — sloped top via difference() against a sloped wedge,
// broken into three rectangular full-height panels by stiles. Mid-rails
// are inside the union so the wedge clips them too — but at z=sill+1000
// the rail is well below the slope (lowest slope point is at the back-low
// corner ~1900 mm above sill_top), so it's never actually clipped.
module v3_yard_mesh_right(hl, rl, ww, fpw, pal, mesh) {
    md = ms_depth(mesh);
    sill_top = V3_SILL_H + 18;
    z_top_max = v3_roof_under(0) - V3_BEAM_H;
    z_top_y0 = v3_roof_under(0) - V3_BEAM_H;
    z_top_y1 = v3_roof_under(ww) - V3_BEAM_H;
    z_rail = sill_top + V3_MID_RAIL_Z_OFFSET;
    x_pos = hl + rl;
    breaks = [fpw, fpw + 1000, fpw + 2000, ww - fpw];

    difference() {
        union() {
            for (i = [0 : len(breaks) - 2]) {
                y0 = breaks[i]; y1 = breaks[i + 1];
                if (y1 - y0 > 100) {
                    mesh_panel_y(y0, y1 - y0, sill_top, z_top_max - sill_top,
                                 x_pos, pal, mesh);
                    v3_mesh_midrail_y(y0, y1 - y0, x_pos, z_rail, mesh, pal);
                }
            }
        }
        hull() {
            translate([x_pos - 5, -10, z_top_y0])
                cube([md + 10, 10, 1500]);
            translate([x_pos - 5, ww, z_top_y1])
                cube([md + 10, 10, 1500]);
        }
    }
}

// External landscape dressing.
module v3_outdoor_dressing(ll, ww, bh) {
    color([0.55, 0.55, 0.52])
    for (i = [0 : 3])
        translate([V3_YARD_DOOR_X + V3_YARD_DOOR_W/2 + 200*sin(i*60),
                   -2200 - i*420, -3])
            cylinder(h = 14, r = 230, $fn = 8);
}
