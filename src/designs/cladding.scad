// Cladding: housewrap + counter-battens + klink boards + corner trim +
// yard mesh.
//
// Layer stack stepping outward from the stud face:
//   1. housewrap         (RH_HOUSEWRAP_T = 1 mm)
//   2. counter-batten    (RH_COUNTER_BATTEN_T = 22 mm) — 22x45 vertical, c/c 600
//   3. klink             (cs_thick(clad) — typically 24 mm)
// Total = RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T + cs_thick(clad). Klink
// butts straight against door frames in openings (no separate architrave).

include <../lib/defaults.scad>
include <config.scad>
use <../lib/primitives/cladding.scad>
use <../lib/primitives/mesh.scad>

HOUSEWRAP_COLOR = [0.50, 0.50, 0.52];

module render_housewrap(origin, length, height, axis) {
    color(HOUSEWRAP_COLOR)
    if (axis == "X")
        translate(origin) cube([length, RH_HOUSEWRAP_T, height]);
    else
        translate(origin) cube([RH_HOUSEWRAP_T, length, height]);
}

// Sloped housewrap for walls following the roof pitch (V3, V5). Top z
// interpolates linearly from h_high (at origin) to h_low (at the far end).
// Bottom is flat at origin.z. Used so the membrane has no flat-top gap at
// the HIGH end.
module render_housewrap_sloped(origin, length, h_high, h_low, axis) {
    ox = origin[0]; oy = origin[1]; oz = origin[2];
    color(HOUSEWRAP_COLOR)
    if (axis == "X") {
        hull() {
            translate([ox, oy, oz])
                cube([0.01, RH_HOUSEWRAP_T, h_high]);
            translate([ox + length - 0.01, oy, oz])
                cube([0.01, RH_HOUSEWRAP_T, h_low]);
        }
    } else {
        hull() {
            translate([ox, oy, oz])
                cube([RH_HOUSEWRAP_T, 0.01, h_high]);
            translate([ox, oy + length - 0.01, oz])
                cube([RH_HOUSEWRAP_T, 0.01, h_low]);
        }
    }
}

// Wall height from sokkel-top to top-plate TOP at any y. Linear between
// RH_EH_FRONT (y=0) and RH_EH_BACK (y=RH_WIDTH).
function wall_height_at(y) =
    RH_EH_FRONT - (RH_EH_FRONT - RH_EH_BACK) * y / RH_WIDTH;

// ---------------------------------------------------------------------------
// Klink cladding on the 4 house walls.
// Klink origin sits s = RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T mm outward
// from the stud face, so klink lands OUTSIDE housewrap + counter-batten.
// The partition is clad on its YARD side only.
// ---------------------------------------------------------------------------
module render_house_cladding(hl, ww, ehf, ehb, bh, ct, pal, clad) {
    s = RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T;   // 23
    part_outer_x = hl + RH_POST_W/2;            // yard-side stud face

    // Front (Y=0). axis="X", thickness +Y. Klink occupies Y = -(s+ct)..-s.
    clad_wall_rect([0, -(s + ct), bh], hl, ehf, "X", pal, clad);

    // Back (Y=ww). axis="X", thickness +Y. Klink occupies Y = ww+s..ww+s+ct.
    clad_wall_rect([0, ww + s, bh], hl, ehb, "X", pal, clad);

    // Left exterior (X=0, side-window cutout). axis="Y", thickness +X.
    // Klink occupies X = -(s+ct)..-s.
    clad_wall_mono_pitch_with_cutout([-(s + ct), 0, bh], ww, ehf, ehb, "Y",
        pal, clad,
        [RH_SIDE_WIN_Y, RH_SIDE_WIN_Y + RH_SIDE_WIN_W,
         RH_SIDE_WIN_Z, RH_SIDE_WIN_Z + RH_SIDE_WIN_H]);

    // Partition yard-side (X = part_outer_x). V5 butts between V1+V2's
    // inner faces (Y = RH_POST_W..ww-RH_POST_W) so klink must not stick
    // into V1/V2's footprint. Heights matched to wall_top_z at the butted
    // positions so klink top exactly meets the sloped top plate.
    klink_in    = part_outer_x + s;
    butt_y0     = RH_POST_W;
    butt_len    = ww - 2 * RH_POST_W;
    v5_h_high   = wall_height_at(butt_y0);
    v5_h_low    = wall_height_at(butt_y0 + butt_len);
    difference() {
        clad_wall_mono_pitch([klink_in, butt_y0, bh], butt_len,
                             v5_h_high, v5_h_low, "Y", pal, clad);
        // Pet door cutout — z=RH_FLOOR_TOP+15 (15 mm above floor)
        translate([klink_in - 10, RH_PET_DOOR_Y, RH_FLOOR_TOP + 15])
            cube([ct + 20, RH_PET_DOOR_W, RH_PET_DOOR_H]);
        // Human door cutout — z=RH_FLOOR_TOP (floor level, NOT bh)
        translate([klink_in - 10, RH_HOUSE_DOOR_Y, RH_FLOOR_TOP])
            cube([ct + 20, RH_HOUSE_DOOR_W, RH_HOUSE_DOOR_H]);
    }
}

// External corner trim posts (45x45 vertical) at the four house cladding
// corners. Each post overlaps both cladding faces at the corner so the raw
// klink board end-grain is covered.
module render_corner_trims(hl, ww, ehf, ehb, bh, ct, pal) {
    tw = 45;
    s = RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T;
    o = s + ct;
    color(pal_trim(pal)) {
        translate([-o,           -o,           bh]) cube([tw, tw, ehf]);
        translate([hl + o - tw,  -o,           bh]) cube([tw, tw, ehf]);
        translate([-o,           ww + o - tw,  bh]) cube([tw, tw, ehb]);
        translate([hl + o - tw,  ww + o - tw,  bh]) cube([tw, tw, ehb]);
    }
}

// True if centre coordinate c falls within any [lo, hi] range.
function _in_any_skip(c, ranges) =
    len([for (r = ranges) if (c >= r[0] && c <= r[1]) 1]) > 0;

// ---------------------------------------------------------------------------
// Counter-battens — 22x45 vertical, sit between housewrap and klink:
// outer offset RH_HOUSEWRAP_T, extending RH_COUNTER_BATTEN_T outward.
// c2c = centre-to-centre along wall (default 600 mm).
// h_far = height of the last batten; intermediates interpolate linearly
//         from `height` (i=0) to `h_far` (i=n-1). Default h_far=height
//         (flat top on V1/V2). Sloped walls V3/V5 pass h_far=ehb so the
//         battens follow the top plate's fall.
// skip_ranges = absolute coords; battens whose centre is in any range are
//         omitted (used for openings).
// ---------------------------------------------------------------------------
module render_counter_battens(origin, length, height, axis, c2c=600,
                              h_far=undef, skip_ranges=[]) {
    n = floor(length / c2c) + 1;
    h_end = is_undef(h_far) ? height : h_far;
    color([0.78, 0.65, 0.45])
    for (i = [0 : n-1]) {
        center = (axis == "X" ? origin[0] : origin[1]) + i*c2c + 22.5;
        if (!_in_any_skip(center, skip_ranges)) {
            // Interpolate height at the batten's FAR edge so it never
            // pokes through the top plate on a sloped wall.
            far_edge = i * c2c + 45;
            h_i = (length > 0)
                ? height + (h_end - height) * far_edge / length
                : height;
            if (axis == "X")
                translate([origin[0] + i*c2c, origin[1], origin[2]])
                    cube([45, RH_COUNTER_BATTEN_T, h_i]);
            else
                translate([origin[0], origin[1] + i*c2c, origin[2]])
                    cube([RH_COUNTER_BATTEN_T, 45, h_i]);
        }
    }
}

// ---------------------------------------------------------------------------
// Yard mesh — frameless welded wire stretched on the OUTER face of the
// 45x95 yard reglar. 1/2" x 1" ~ 13 mm x 1 mm wire (RH_MESH_*). Three walls:
//   front (Y=0)  — two bands, one on each side of the yard door
//   back  (Y=ww) — single band, flat LOW
//   right (X=ll) — sloped top, HIGH (Y=0) to LOW (Y=ww)
// Mesh stops at top-plate underside; anything above (between rafters) is
// the roof's territory.
// ---------------------------------------------------------------------------
module render_yard_mesh(palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; ww = RH_WIDTH; hl = RH_HOUSE_LEN;
    bh = RH_BASE_H;

    yard_mesh = mesh_spec(spacing = RH_MESH_SPACING,
                          bar     = RH_MESH_BAR,
                          frame   = RH_MESH_FRAME,
                          depth   = RH_MESH_DEPTH);

    OUT = 1;   // mesh plane 1 mm outside the stud face
    z_base = RH_YARD_SILL_TOP;

    PLATE_H = RH_SILL_H;
    z_top_front = bh + RH_EH_FRONT - PLATE_H;
    z_top_back  = bh + RH_EH_BACK  - PLATE_H;
    h_front = z_top_front - z_base;
    h_back  = z_top_back  - z_base;

    // Front (faces -Y) — two bands around the yard door
    door_x0 = RH_YARD_DOOR_X;
    door_x1 = RH_YARD_DOOR_X + RH_YARD_DOOR_W;
    voliere_x(hl,      door_x0 - hl, z_base, h_front, -OUT,
              palette=palette, mesh=yard_mesh);
    voliere_x(door_x1, ll - door_x1, z_base, h_front, -OUT,
              palette=palette, mesh=yard_mesh);

    // Back (faces +Y) — single band, flat LOW
    voliere_x(hl, ll - hl, z_base, h_back, ww + OUT,
              palette=palette, mesh=yard_mesh);

    // Right (faces +X) — sloped top HIGH -> LOW. Studs butt between
    // Y=95..ww-95 but mesh stretches the full Y=0..ww along the outside.
    voliere_y_sloped(0, ww, z_base, z_top_front, z_top_back, ll + OUT,
                     palette=palette, mesh=yard_mesh);
}

// ---------------------------------------------------------------------------
// Entry point — housewrap + klink + corner trim + counter-battens + yard mesh.
// ---------------------------------------------------------------------------
module RenderCladding(clad = DEFAULT_CLAD, palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; ww = RH_WIDTH; bh = RH_BASE_H;
    hl = RH_HOUSE_LEN;
    ehf = RH_EH_FRONT; ehb = RH_EH_BACK;
    ct = cs_thick(clad);
    s  = RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T;

    // Wall-cap heights (klink tops at top-plate underside = wall_top - PLATE_H).
    PLATE_H = RH_SILL_H;
    cap_h_front = ehf - PLATE_H;
    cap_h_back  = ehb - PLATE_H;

    // Housewrap starts at sokkel-top (RH_BASE_H = 120) where the timber
    // begins. Bottom z=120 means the membrane covers the sill plate's
    // outer face (122..167) and laps onto the DPC at sokkel-top.
    z_sill = RH_BASE_H;
    part_outer_x = hl + RH_POST_W/2;

    // V5 partition is INTERIOR and butts between V1+V2's inner faces.
    // Housewrap, klink and battens all stay inside the butted range so
    // they don't poke into V1/V2's footprint.
    butt_y0  = RH_POST_W;
    butt_len = RH_WIDTH - 2 * RH_POST_W;

    // V5 wall heights at the butted positions — used by klink, housewrap
    // and battens so they meet the sloped top plate without a gap.
    v5_h_high_battens = wall_height_at(butt_y0);
    v5_h_low_battens  = wall_height_at(butt_y0 + butt_len);

    // Housewrap on each wall. Sloped walls use cap_h_back (LOW) as flat
    // height so the membrane never pokes above the top plate at the LOW
    // end. The upper triangle is covered by klink + roof overhang anyway.
    render_housewrap([0, -RH_HOUSEWRAP_T, z_sill], hl, cap_h_front, "X");
    render_housewrap([0, ww,              z_sill], hl, cap_h_back,  "X");

    // V3 left wall: sloped top + side-window cutout. V3 is EXTERIOR and
    // wraps Y=0..ww (no Y-butting; just slope and cutout).
    difference() {
        render_housewrap_sloped([-RH_HOUSEWRAP_T, 0, z_sill], ww,
                                cap_h_front, cap_h_back, "Y");
        translate([-RH_HOUSEWRAP_T - 1, RH_SIDE_WIN_Y, RH_FLOOR_TOP + RH_SIDE_WIN_Z])
            cube([RH_HOUSEWRAP_T + 2, RH_SIDE_WIN_W, RH_SIDE_WIN_H]);
    }

    // V5 partition: butted Y-extent + sloped top + door cutouts.
    v5_cap_h_high = wall_height_at(butt_y0) - PLATE_H;
    v5_cap_h_low  = wall_height_at(butt_y0 + butt_len) - PLATE_H;
    difference() {
        render_housewrap_sloped([part_outer_x, butt_y0, z_sill], butt_len,
                                v5_cap_h_high, v5_cap_h_low, "Y");
        translate([part_outer_x - 1, RH_HOUSE_DOOR_Y, RH_FLOOR_TOP])
            cube([RH_HOUSEWRAP_T + 2, RH_HOUSE_DOOR_W, RH_HOUSE_DOOR_H]);
        translate([part_outer_x - 1, RH_PET_DOOR_Y, RH_FLOOR_TOP + 15])
            cube([RH_HOUSEWRAP_T + 2, RH_PET_DOOR_W, RH_PET_DOOR_H]);
    }

    render_house_cladding(hl, ww, ehf, ehb, bh, ct, palette, clad);
    render_corner_trims(hl, ww, ehf, ehb, bh, ct, palette);

    // Counter-battens. Sloped walls pass h_far=ehb so battens follow the
    // top plate's fall and never poke through the roof.
    render_counter_battens([0, -s, bh], hl, ehf, "X");
    render_counter_battens([0, ww + RH_HOUSEWRAP_T, bh], hl, ehb, "X");
    render_counter_battens([-s, 0, bh], ww, ehf, "Y", 600, ehb,
                           skip_ranges = [[RH_SIDE_WIN_Y, RH_SIDE_WIN_Y + RH_SIDE_WIN_W]]);
    render_counter_battens([part_outer_x + RH_HOUSEWRAP_T, butt_y0, bh],
                           butt_len, v5_h_high_battens, "Y", 600, v5_h_low_battens,
                           skip_ranges = [
                               [RH_HOUSE_DOOR_Y, RH_HOUSE_DOOR_Y + RH_HOUSE_DOOR_W],
                               [RH_PET_DOOR_Y,   RH_PET_DOOR_Y   + RH_PET_DOOR_W]
                           ]);

    render_yard_mesh(palette);
}
