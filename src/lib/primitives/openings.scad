// Window, human door, and rabbit pet door primitives.

include <../defaults.scad>

// Window with full carpenter trim — frame, muntins, sill, architrave, drip cap.
// Wall plane: the window lives at X=`x` looking outward (clad on the +X side
// of the wall). `win_y0` and `win_z0` are the bottom-front corner; `win_w`,
// `win_h` are the opening size.
//   clad_t = thickness of the cladding for trim offset
module window_with_trim(x, win_y0, win_z0, win_w, win_h,
                        clad_t=24, palette=DEFAULT_PALETTE,
                        muntin=true) {
    architrave_w = 70;
    architrave_t = 20;
    sill_depth = 45;
    sill_t = 55;
    sill_drip = 8;
    muntin_w = 25;
    muntin_t = 18;

    // Glass pane
    color(pal_glass(palette))
    translate([x + architrave_t/2, win_y0, win_z0])
        cube([6, win_w, win_h]);

    // Window frame (karm)
    color(pal_post(palette)) {
        frame_t = 45;
        frame_w = 30;
        translate([x - frame_t/2, win_y0, win_z0])
            cube([frame_t, win_w, frame_w]);
        translate([x - frame_t/2, win_y0, win_z0 + win_h - frame_w])
            cube([frame_t, win_w, frame_w]);
        translate([x - frame_t/2, win_y0, win_z0])
            cube([frame_t, frame_w, win_h]);
        translate([x - frame_t/2, win_y0 + win_w - frame_w, win_z0])
            cube([frame_t, frame_w, win_h]);
    }

    // Muntins
    if (muntin) {
        color(pal_post(palette)) {
            translate([x - muntin_t/2, win_y0 + 30, win_z0 + win_h/2 - muntin_w/2])
                cube([muntin_t, win_w - 60, muntin_w]);
            translate([x - muntin_t/2, win_y0 + win_w/2 - muntin_w/2, win_z0 + 30])
                cube([muntin_t, muntin_w, win_h - 60]);
        }
    }

    // Sill
    color(pal_trim(palette))
    hull() {
        translate([x, win_y0 - sill_drip, win_z0 - sill_t])
            cube([0.1, win_w + 2*sill_drip, sill_t]);
        translate([x + sill_depth, win_y0 - sill_drip, win_z0 - sill_t - 5])
            cube([0.1, win_w + 2*sill_drip, sill_t - 5]);
    }

    // Architrave
    color(pal_trim(palette)) {
        translate([x + clad_t - 2, win_y0 - architrave_w + 10, win_z0 + win_h])
            cube([architrave_t, win_w + 2*architrave_w - 20, architrave_w]);
        translate([x + clad_t - 2, win_y0 - architrave_w + 10, win_z0])
            cube([architrave_t, architrave_w, win_h]);
        translate([x + clad_t - 2, win_y0 + win_w - 10, win_z0])
            cube([architrave_t, architrave_w, win_h]);
    }

    // Drip cap
    color(pal_trim(palette))
    hull() {
        translate([x + clad_t - 2, win_y0 - architrave_w, win_z0 + win_h + architrave_w])
            cube([architrave_t + 8, win_w + 2*architrave_w, 3]);
        translate([x + clad_t + architrave_t + 5, win_y0 - architrave_w, win_z0 + win_h + architrave_w - 8])
            cube([0.1, win_w + 2*architrave_w, 3]);
    }
}

// Window facing -X (cladding extends in -X from the wall plane at X=x).
// Mirror of window_with_trim. Useful for gable end walls where the
// outward normal is -X.
module window_with_trim_xneg(x, win_y0, win_z0, win_w, win_h,
                             clad_t=24, palette=DEFAULT_PALETTE,
                             muntin=true) {
    architrave_w = 70;
    architrave_t = 20;
    sill_depth = 45;
    sill_t = 55;
    sill_drip = 8;
    muntin_w = 25;
    muntin_t = 18;

    color(pal_glass(palette))
    translate([x - architrave_t/2 - 6, win_y0, win_z0])
        cube([6, win_w, win_h]);

    color(pal_post(palette)) {
        frame_t = 45;
        frame_w = 30;
        translate([x - frame_t/2, win_y0, win_z0])
            cube([frame_t, win_w, frame_w]);
        translate([x - frame_t/2, win_y0, win_z0 + win_h - frame_w])
            cube([frame_t, win_w, frame_w]);
        translate([x - frame_t/2, win_y0, win_z0])
            cube([frame_t, frame_w, win_h]);
        translate([x - frame_t/2, win_y0 + win_w - frame_w, win_z0])
            cube([frame_t, frame_w, win_h]);
    }

    if (muntin) {
        color(pal_post(palette)) {
            translate([x - muntin_t/2, win_y0 + 30, win_z0 + win_h/2 - muntin_w/2])
                cube([muntin_t, win_w - 60, muntin_w]);
            translate([x - muntin_t/2, win_y0 + win_w/2 - muntin_w/2, win_z0 + 30])
                cube([muntin_t, muntin_w, win_h - 60]);
        }
    }

    color(pal_trim(palette))
    hull() {
        translate([x, win_y0 - sill_drip, win_z0 - sill_t])
            cube([0.1, win_w + 2*sill_drip, sill_t]);
        translate([x - sill_depth, win_y0 - sill_drip, win_z0 - sill_t - 5])
            cube([0.1, win_w + 2*sill_drip, sill_t - 5]);
    }

    color(pal_trim(palette)) {
        translate([x - clad_t - architrave_t + 2, win_y0 - architrave_w + 10, win_z0 + win_h])
            cube([architrave_t, win_w + 2*architrave_w - 20, architrave_w]);
        translate([x - clad_t - architrave_t + 2, win_y0 - architrave_w + 10, win_z0])
            cube([architrave_t, architrave_w, win_h]);
        translate([x - clad_t - architrave_t + 2, win_y0 + win_w - 10, win_z0])
            cube([architrave_t, architrave_w, win_h]);
    }

    color(pal_trim(palette))
    hull() {
        translate([x - clad_t - architrave_t + 2, win_y0 - architrave_w, win_z0 + win_h + architrave_w])
            cube([architrave_t + 8, win_w + 2*architrave_w, 3]);
        translate([x - clad_t - architrave_t - 5, win_y0 - architrave_w, win_z0 + win_h + architrave_w - 8])
            cube([0.1, win_w + 2*architrave_w, 3]);
    }
}

// Solid human door with two-stage latch hardware. Sits in a wall facing -Y
// (outward toward Y=0). `origin` = lower-outside corner.
//   door_w x door_h = leaf size; clad_t for trim offset
module human_door(origin, door_w, door_h, clad_t=24,
                  palette=DEFAULT_PALETTE) {
    ox = origin[0]; oy = origin[1]; oz = origin[2];
    leaf_t = 40;
    // Door leaf
    color(pal_door(palette))
    translate([ox, oy - leaf_t, oz])
        cube([door_w, leaf_t, door_h]);

    // 4 horizontal panel grooves on the leaf
    color(pal_trim(palette))
    for (i = [0 : 3]) {
        translate([ox + 50, oy - leaf_t - 1, oz + 200 + i * 400])
            cube([door_w - 100, 2, 30]);
    }

    // Architrave
    architrave_w = 70;
    architrave_t = 20;
    color(pal_trim(palette)) {
        translate([ox - architrave_w + 10, oy - leaf_t - 2, oz + door_h])
            cube([door_w + 2*architrave_w - 20, architrave_t, architrave_w]);
        translate([ox - architrave_w + 10, oy - leaf_t - 2, oz])
            cube([architrave_w, architrave_t, door_h]);
        translate([ox + door_w - 10, oy - leaf_t - 2, oz])
            cube([architrave_w, architrave_t, door_h]);
    }

    // Two-stage latch (handle + barrel bolt above) — small chrome cubes
    color([0.85, 0.85, 0.88]) {
        // Handle
        translate([ox + door_w - 100, oy - leaf_t - 25, oz + 1050])
            cube([60, 25, 25]);
        // Latch plate
        translate([ox + door_w - 110, oy - leaf_t - 5, oz + 1000])
            cube([80, 8, 110]);
        // Barrel bolt (upper, the second stage)
        translate([ox + door_w - 90, oy - leaf_t - 15, oz + 1700])
            cube([70, 15, 22]);
    }

    // Hinges on the left edge
    color([0.30, 0.30, 0.32])
    for (zh = [oz + 200, oz + door_h - 300]) {
        translate([ox - 5, oy - leaf_t - 5, zh])
            cube([15, 8, 100]);
    }
}

// Small low rabbit door (pet flap) cut into a wall.
// `axis_normal` describes which way the wall faces. For a partition wall at
// X=x_wall facing +X, set wall_face_x=x_wall.
//   This module renders the door FRAME and a translucent flap; the actual
//   wall cutout is the caller's responsibility (e.g. via difference()).
module rabbit_pet_door_yz(x_wall, y, z, w, h, wall_t=100,
                          palette=DEFAULT_PALETTE) {
    frame_t = 25;
    // Frame around the opening (both faces of the wall)
    color(pal_post(palette)) {
        // Outside (X = x_wall + wall_t)
        translate([x_wall + wall_t - 5, y - frame_t, z - frame_t])
            cube([15, w + 2*frame_t, frame_t]);
        translate([x_wall + wall_t - 5, y - frame_t, z + h])
            cube([15, w + 2*frame_t, frame_t]);
        translate([x_wall + wall_t - 5, y - frame_t, z])
            cube([15, frame_t, h]);
        translate([x_wall + wall_t - 5, y + w, z])
            cube([15, frame_t, h]);
        // Inside (X = x_wall - 5)
        translate([x_wall - 10, y - frame_t, z - frame_t])
            cube([15, w + 2*frame_t, frame_t]);
        translate([x_wall - 10, y - frame_t, z + h])
            cube([15, w + 2*frame_t, frame_t]);
        translate([x_wall - 10, y - frame_t, z])
            cube([15, frame_t, h]);
        translate([x_wall - 10, y + w, z])
            cube([15, frame_t, h]);
    }
    // Flap (semi-translucent rubber)
    color([0.20, 0.18, 0.16, 0.7])
    translate([x_wall + wall_t/2 - 1, y, z])
        cube([3, w, h]);
}

// A simple stone entrance step / threshold board pair, sitting just outside
// a door at Y = y_face (Y=0 face of a wall).
module entrance_step(x, y_face, w, base_h=120, palette=DEFAULT_PALETTE) {
    color([0.70, 0.68, 0.64])
    translate([x, y_face - 400, base_h - 80])
        cube([w, 400, 80]);
    color(pal_trim(palette))
    translate([x, y_face - 50, base_h])
        cube([w, 55, 25]);
    color([0.45, 0.40, 0.30])
    translate([x + w/2 - 300, y_face - 350, base_h - 2])
        cube([600, 400, 10]);
    color([0.55, 0.50, 0.40])
    translate([x + w/2 - 200, y_face - 300, base_h + 8])
        cube([400, 300, 2]);
}
