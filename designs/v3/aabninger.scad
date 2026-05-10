// aabninger.scad — Doors + window + framed openings
// Part of the v3 build pipeline; included from build.scad.

include <../../lib/defaults.scad>
include <config.scad>
use <../../lib/primitives/openings.scad>
use <../../lib/primitives/mesh.scad>
use <../../lib/decor/rabbit.scad>
use <../../lib/bom.scad>

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

module v3_aabninger(mesh = DEFAULT_MESH, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; bh = V3_BASE_H; wt = V3_WALL_T;
    hl = V3_HOUSE_LEN;
    ct = 22;

    v3_partition_door(hl, ct, V3_HOUSE_DOOR_Y, V3_HOUSE_DOOR_W,
                      V3_HOUSE_DOOR_H, bh, palette);
    rabbit_pet_door_yz(hl - wt, V3_PET_DOOR_Y, bh + 60,
                       V3_PET_DOOR_W, V3_PET_DOOR_H, wt, palette);
    color([0.55, 0.50, 0.40])
    translate([hl + ct + 20, V3_HOUSE_DOOR_Y - 50, bh + V3_YARD_SILL_TOP])
        cube([200, V3_HOUSE_DOOR_W + 100, 12]);
    window_with_trim_xneg(0, V3_SIDE_WIN_Y, bh + V3_SIDE_WIN_Z,
                          V3_SIDE_WIN_W, V3_SIDE_WIN_H, ct, palette, true);
    v3_yard_door(V3_YARD_DOOR_X, V3_YARD_DOOR_W, V3_YARD_DOOR_H,
                 bh + V3_YARD_SILL_TOP, palette, mesh);
}
