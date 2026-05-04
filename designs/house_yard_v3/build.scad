// House-yard v3 build — solid mono-pitch house on a slab + mesh-only yard
// on ground plugs, all under one continuous mono-pitch roof.
// Entry point: build_house_yard_v3()
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
use <../../lib/primitives/openings.scad>
use <../../lib/decor/landscape.scad>
use <../../lib/decor/lighting.scad>
use <../../lib/decor/rabbit.scad>

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

module build_house_yard_v3() {
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

    // --- Outdoor ground & path ------------------------------------------
    ground_grass([ll/2, ww/2]);
    gravel_path_y([V3_YARD_DOOR_X + V3_YARD_DOOR_W/2, 0]);
    v3_outdoor_dressing(ll, ww, bh);

    // --- Foundation: house only ----------------------------------------
    slab([0, 0], [hl, ww], bh, pal);
    interior_floor([wt, wt], [hl - 2*wt, ww - 2*wt], bh, 20, pal);
    rabbit_floor_grass([wt, wt], [hl - 2*wt, ww - 2*wt], bh);

    // --- Yard interior: lush grass at grade ---------------------------
    v3_yard_grass(hl, rl, ww);

    // --- House structural framing -------------------------------------
    v3_house_framing(hl, ww, ehf, ehb, bh, wt, fpw, stud, pal);

    // --- House cladding (front, back, left, partition) ----------------
    v3_house_cladding(hl, ww, ehf, ehb, bh, ct, pal, clad);

    // --- Partition: human door + rabbit pet door ----------------------
    v3_partition_door(hl, ct, V3_HOUSE_DOOR_Y, V3_HOUSE_DOOR_W,
                      V3_HOUSE_DOOR_H, bh, pal);
    rabbit_pet_door_yz(hl - wt, V3_PET_DOOR_Y, bh + 60,
                       V3_PET_DOOR_W, V3_PET_DOOR_H, wt, pal);
    // Stone threshold inside the yard at the partition human door
    color([0.55, 0.50, 0.40])
    translate([hl + ct + 20, V3_HOUSE_DOOR_Y - 50,
               V3_PLUG_H + 18 + 80])
        cube([200, V3_HOUSE_DOOR_W + 100, 12]);

    // --- Side window with trim on left exterior wall (faces -X) -------
    window_with_trim_xneg(0, V3_SIDE_WIN_Y, bh + V3_SIDE_WIN_Z,
                          V3_SIDE_WIN_W, V3_SIDE_WIN_H, ct, pal, true);

    // --- Insulated nest box --------------------------------------------
    nest_box_insulated([V3_NEST_X, V3_NEST_Y, bh + 20],
                       V3_NEST_W, V3_NEST_D, V3_NEST_H, pal);

    // --- Hay/bedding storage cubes inside the house (front-left) ------
    color([0.78, 0.72, 0.40])
    translate([wt + 50, wt + 30, bh + 20])
        cube([400, 600, 700]);
    color(pal_panel1(pal))
    translate([wt + 500, wt + 30, bh + 20])
        cube([400, 600, 900]);

    // --- Yard structure: ground plugs + corner posts + sloped beams ----
    v3_yard_plugs_and_posts(hl, rl, ww, bh, fpw, pal);
    v3_yard_top_beams(hl, rl, ww, fpw, pal);
    v3_yard_stiles(hl, rl, ww, fpw, pal);

    // --- Yard mesh on three exterior sides ---------------------------
    v3_yard_mesh_front(hl, rl, ww, fpw, pal, mesh);
    v3_yard_mesh_back(hl, rl, ww, fpw, pal, mesh);
    v3_yard_mesh_right(hl, rl, ww, fpw, pal, mesh);

    // --- Yard mesh-and-frame entry door (front, Y=0) -----------------
    v3_yard_door(V3_YARD_DOOR_X, V3_YARD_DOOR_W, V3_YARD_DOOR_H,
                 V3_PLUG_H + 18 + 80, pal, mesh);
    entrance_step(V3_YARD_DOOR_X, 0, V3_YARD_DOOR_W,
                  V3_PLUG_H + 18 + 80, pal);

    // --- Unified mono-pitch roof (corrected origin so wall tops align)
    roof_mono_pitch([0, 0, roof_oz], ll, ww, drop_full, V3_ROOF_THICK,
                    V3_OH_FRONT, V3_OH_BACK, V3_OH_SIDE, pal);
    fascia_and_gutter_mono([0, 0, roof_oz], ll, ww, drop_full,
                           150, 22, V3_OH_FRONT, V3_OH_BACK, V3_OH_SIDE,
                           110, 65, pal);
    rafter_eave_h = v3_roof_under(wt);
    rafter_drop = v3_roof_under(wt) - v3_roof_under(ww - wt);
    ceiling_rafters_mono([0, 0, 0], ll, ww, rafter_drop, rafter_eave_h,
                         900, 45, 140, wt, pal);

    // --- Predator-proof buried apron skirt around yard ---------------
    apron_skirt([hl, 0, ll, ww], V3_APRON_W,
                ["front", "back", "right"], pal);

    // --- Hay rack on house back wall (interior) ----------------------
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

module v3_yard_grass(hl, rl, ww) {
    color([0.32, 0.58, 0.22])
    translate([hl, 0, 0])
        cube([rl, ww, 8]);
    color([0.40, 0.62, 0.28])
    for (cx = [hl + 350, hl + 1100, hl + 1900, hl + 2700, hl + 3400])
        for (cy = [350, 1050, 1700, 2350])
            translate([cx, cy, 8])
                cube([280 + (cx % 90), 220 + (cy % 70), 4]);
    color([0.30, 0.50, 0.20])
    for (cx = [hl + 200, hl + 600])
        translate([cx, 1800 + cx % 200, 8])
            cube([180, 160, 3]);
}

module v3_house_framing(hl, ww, ehf, ehb, bh, wt, fpw, stud, pal) {
    stud_wall([0, 0, bh], hl, ehf, "X", stud, pal);
    stud_wall([0, ww - ss_d(stud), bh], hl, ehb, "X", stud, pal);
    stud_wall([0, 0, bh], ww, ehb, "Y", stud, pal);
    stud_wall([hl - ss_d(stud), 0, bh], ww, ehb, "Y", stud, pal);

    // Sloped top beams on side and partition (top edge follows the roof
    // underside line on the wall plane).
    top_beam_sloped_y(0,        0, ww, bh + ehf, bh + ehb, fpw, 180, pal);
    top_beam_sloped_y(hl - fpw, 0, ww, bh + ehf, bh + ehb, fpw, 180, pal);

    // Interior collar tie at hl/2 — slope-matched.
    color(pal_post(pal))
    hull() {
        translate([hl/2 - 40, 0, bh + ehf - 180])
            cube([80, 0.01, 180]);
        translate([hl/2 - 40, ww - 0.01, bh + ehb - 180])
            cube([80, 0.01, 180]);
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
    difference() {
        clad_wall_mono_pitch([hl, 0, bh], ww, ehf, ehb, "Y", pal, clad);
        translate([hl - 10, V3_PET_DOOR_Y, bh + 60])
            cube([ct + 20, V3_PET_DOOR_W, V3_PET_DOOR_H]);
        translate([hl - 10, V3_HOUSE_DOOR_Y, bh])
            cube([ct + 20, V3_HOUSE_DOOR_W, V3_HOUSE_DOOR_H]);
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

    color(pal_post(pal)) {
        translate([door_x, -md, z0])               cube([door_w, md, fr]);
        translate([door_x, -md, z1 - fr])          cube([door_w, md, fr]);
        translate([door_x, -md, z0])               cube([fr, md, door_h]);
        translate([door_x + door_w - fr, -md, z0]) cube([fr, md, door_h]);
        translate([door_x, -md, (z0 + z1)/2 - fr/2]) cube([door_w, md, fr]);
    }

    color(pal_mesh(pal)) {
        for (band_z = [[z0 + fr, (z0+z1)/2 - fr/2],
                       [(z0+z1)/2 + fr/2, z1 - fr]]) {
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

// Yard plugs + corner posts + partition pseudo-posts + sill plates
// (sills broken around the yard mesh door at Y=0).
module v3_yard_plugs_and_posts(hl, rl, ww, bh, fpw, pal) {
    plug_posts = [
        [hl + rl - fpw, 0,        v3_roof_under(0)],
        [hl + rl - fpw, ww - fpw, v3_roof_under(ww - fpw)]
    ];

    color([0.74, 0.72, 0.69])
    for (p = plug_posts)
        translate([p[0] - (V3_PLUG_W - fpw)/2,
                   p[1] - (V3_PLUG_W - fpw)/2,
                   -V3_PLUG_BURY])
            cube([V3_PLUG_W, V3_PLUG_W, V3_PLUG_H + V3_PLUG_BURY]);
    color([0.30, 0.30, 0.32])
    for (p = plug_posts)
        translate([p[0] - 8, p[1] - 8, V3_PLUG_H])
            cube([fpw + 16, fpw + 16, 18]);

    color(pal_post(pal))
    for (p = plug_posts) {
        z0 = V3_PLUG_H + 18;
        translate([p[0], p[1], z0])
            cube([fpw, fpw, p[2] - z0]);
    }
    color(pal_post(pal)) {
        translate([hl, 0, bh])
            cube([fpw, fpw, v3_roof_under(0) - bh]);
        translate([hl, ww - fpw, bh])
            cube([fpw, fpw, v3_roof_under(ww - fpw) - bh]);
    }

    sill_z = V3_PLUG_H + 18;
    color(pal_post(pal)) {
        if (V3_YARD_DOOR_X > hl + fpw)
            translate([hl + fpw, 0, sill_z])
                cube([V3_YARD_DOOR_X - (hl + fpw), fpw, 80]);
        if (V3_YARD_DOOR_X + V3_YARD_DOOR_W < hl + rl - fpw)
            translate([V3_YARD_DOOR_X + V3_YARD_DOOR_W, 0, sill_z])
                cube([(hl + rl - fpw) - (V3_YARD_DOOR_X + V3_YARD_DOOR_W),
                      fpw, 80]);
        translate([hl + fpw, ww - fpw, sill_z])
            cube([rl - 2*fpw, fpw, 80]);
        translate([hl + rl - fpw, fpw, sill_z])
            cube([fpw, ww - 2*fpw, 80]);
    }
}

// Sloped front and back top beams (top face follows the roof underside).
module v3_yard_top_beams(hl, rl, ww, fpw, pal) {
    color(pal_post(pal))
    hull() {
        translate([hl, 0, v3_roof_under(0) - 180])
            cube([rl, 0.01, 180]);
        translate([hl, fpw - 0.01, v3_roof_under(fpw) - 180])
            cube([rl, 0.01, 180]);
    }
    color(pal_post(pal))
    hull() {
        translate([hl, ww - fpw, v3_roof_under(ww - fpw) - 180])
            cube([rl, 0.01, 180]);
        translate([hl, ww - 0.01, v3_roof_under(ww) - 180])
            cube([rl, 0.01, 180]);
    }
    top_beam_sloped_y(hl + rl - fpw, fpw, ww - 2*fpw,
                      v3_roof_under(0), v3_roof_under(ww),
                      fpw, 180, pal);
}

// 1 m wood vertical stiles along yard mesh walls.
//   Front: one stile past the door's right frame (door's own L/R frames
//          act as the 1 m stiles around the door opening).
//   Back:  every 1 m from partition.
//   Right: every 1 m from the front corner.
module v3_yard_stiles(hl, rl, ww, fpw, pal) {
    sw = V3_STILE_W;
    sill_top = V3_PLUG_H + 18 + 80;

    front_xs = [hl + 3000];
    color(pal_post(pal))
    for (xs = front_xs) {
        beam_top = v3_roof_under(0) - 180;
        translate([xs - sw/2, -sw/2, sill_top])
            cube([sw, sw, beam_top - sill_top]);
    }

    back_xs = [hl + 1000, hl + 2000, hl + 3000];
    color(pal_post(pal))
    for (xs = back_xs) {
        beam_top = v3_roof_under(ww) - 180;
        translate([xs - sw/2, ww - sw/2, sill_top])
            cube([sw, sw, beam_top - sill_top]);
    }

    right_ys = [fpw + 1000, fpw + 2000];
    color(pal_post(pal))
    for (ys = right_ys) {
        beam_top = v3_roof_under(ys) - 180;
        translate([hl + rl - sw/2, ys - sw/2, sill_top])
            cube([sw, sw, beam_top - sill_top]);
    }
}

// Front mesh — three rectangular panels (left of door, between door and
// stile at hl+3000, between stile and right corner).
module v3_yard_mesh_front(hl, rl, ww, fpw, pal, mesh) {
    md = ms_depth(mesh);
    sill_top = V3_PLUG_H + 18 + 80;
    h = (v3_roof_under(0) - 180) - sill_top;
    seg_xs = [
        [hl + fpw,                         V3_YARD_DOOR_X],
        [V3_YARD_DOOR_X + V3_YARD_DOOR_W,  hl + 3000],
        [hl + 3000,                        hl + rl - fpw]
    ];
    for (s = seg_xs)
        if (s[1] - s[0] > 100)
            mesh_panel_x(s[0], s[1] - s[0], sill_top, h, -md, pal, mesh);
}

// Back mesh — four rectangular panels broken by stiles every 1 m.
module v3_yard_mesh_back(hl, rl, ww, fpw, pal, mesh) {
    md = ms_depth(mesh);
    sill_top = V3_PLUG_H + 18 + 80;
    h = (v3_roof_under(ww) - 180) - sill_top;
    breaks = [hl + fpw, hl + 1000, hl + 2000, hl + 3000, hl + rl - fpw];
    for (i = [0 : len(breaks) - 2]) {
        x0 = breaks[i]; x1 = breaks[i + 1];
        if (x1 - x0 > 100)
            mesh_panel_x(x0, x1 - x0, sill_top, h, ww - md, pal, mesh);
    }
}

// Right end mesh — sloped top via difference() against a sloped wedge,
// broken into three rectangular full-height panels by stiles.
module v3_yard_mesh_right(hl, rl, ww, fpw, pal, mesh) {
    md = ms_depth(mesh);
    sill_top = V3_PLUG_H + 18 + 80;
    z_top_max = v3_roof_under(0) - 180;
    z_top_y0 = v3_roof_under(0) - 180;
    z_top_y1 = v3_roof_under(ww) - 180;
    x_pos = hl + rl;
    breaks = [fpw, fpw + 1000, fpw + 2000, ww - fpw];

    difference() {
        union() {
            for (i = [0 : len(breaks) - 2]) {
                y0 = breaks[i]; y1 = breaks[i + 1];
                if (y1 - y0 > 100)
                    mesh_panel_y(y0, y1 - y0, sill_top, z_top_max - sill_top,
                                 x_pos, pal, mesh);
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

    for (s = [[-220, 400], [-260, 1700], [-240, 2600]]) {
        color([0.30, 0.45, 0.22])
        translate([s[0], s[1], 0])
            scale([1.1, 1, 0.8]) sphere(r = 220);
        color([0.36, 0.52, 0.28])
        translate([s[0] - 30, s[1] + 80, 100])
            scale([0.9, 0.9, 0.7]) sphere(r = 170);
    }
    for (s = [[ll + 280, ww + 360], [ll + 460, ww + 700]]) {
        color([0.34, 0.48, 0.24])
        translate([s[0], s[1], 0])
            scale([1, 1.1, 0.9]) sphere(r = 280);
    }
    color([0.62, 0.60, 0.56])
    for (c = [[-380, 1100, 0], [-420, 1350, 0], [-500, 1250, 0],
              [-460, 1480, 0], [-380, 1550, 0]])
        translate(c) sphere(r = 90 + (c[1] % 60));
}
