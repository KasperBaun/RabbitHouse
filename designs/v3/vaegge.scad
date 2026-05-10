// vaegge.scad — All vertical stud walls (house + yard)
// Part of the v3 build pipeline; included from build.scad.

include <../../lib/defaults.scad>
include <config.scad>
use <../../lib/primitives/framing.scad>
use <../../lib/primitives/mesh.scad>
use <../../lib/bom.scad>

module v3_house_framing(hl, ww, ehf, ehb, bh, wt, fpw, stud, pal) {
    sd       = ss_d(stud);
    sw       = ss_w(stud);
    air_gap  = 10;                   // 5–10 mm drainage / capillary-break gap
    // Wall sill rests on top of the fundablok ring (Z=0). 10 mm air gap
    // between bundrem and ring per TIMBER-FRAMING.md (drainage / capillary
    // break). Was previously bh+air_gap when the wall sat on a slab.
    z_sill   = 10;
    z_bp_top = z_sill + sw;          // bundrem top — door rough-opening floor

    // Front and back walls — top plate slopes across the wall thickness so
    // the toprem follows the roof underside instead of clipping it. Both
    // ends use v3_roof_under(y) to derive heights at the outer (oy) and
    // inner (oy+sd) wall faces.
    stud_wall([0, 0, z_sill], hl,
              v3_roof_under(0)      - z_sill, "X", stud, pal,
              h_inner = v3_roof_under(sd)        - z_sill);
    v3_wall_bats([0, sd, z_sill], hl, v3_roof_under(0) - z_sill, "X");
    stud_wall([0, ww - sd, z_sill], hl,
              v3_roof_under(ww - sd) - z_sill, "X", stud, pal,
              h_inner = v3_roof_under(ww)        - z_sill);
    v3_wall_bats([0, ww - sd, z_sill], hl, v3_roof_under(ww - sd) - z_sill, "X");

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
    v3_wall_bats([sd, 0, z_sill], ww, min(ehf - air_gap, ehb - air_gap), "Y",
                 skip_ranges = left_skip);
    stud_wall_sloped([hl - sd, 0, z_sill], ww, ehf - air_gap, ehb - air_gap,
                     "Y", stud, pal, partition_skip);
    v3_wall_bats([hl - sd, 0, z_sill], ww, min(ehf - air_gap, ehb - air_gap), "Y",
                 skip_ranges = partition_skip);

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
               ww - 2*sd, "interior_collar_tie", system="vaegge");
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
//   bracket (18 mm) directly on the fundablok ring top at sokkel level
//   Z=bh per Phase 1 spec ("bundrem af alle vægge sidder her").
module v3_yard_posts_and_sills(hl, rl, ww, bh, fpw, ct, pal) {
    reglar_t = 45;          // thin dimension along X (the "45" of 45×95)
    bracket_h = 18;

    corner_reglar = [
        [hl + rl - reglar_t, 0,        v3_roof_under(0)],
        [hl + rl - reglar_t, ww - fpw, v3_roof_under(ww - fpw)]
    ];

    // Steel post-base brackets sized to the 45×95 reglar, sitting on
    // the fundablok ring top at Z=bh (sokkel level).
    for (p = corner_reglar)
        bom_member("bracket", "steel-galv", reglar_t + 16, fpw + 16,
                   bracket_h, "yard_corner_post_base", system="vaegge");

    color([0.30, 0.30, 0.32])
    for (p = corner_reglar)
        translate([p[0] - 8, p[1] - 8, bh])
            cube([reglar_t + 16, fpw + 16, bracket_h]);

    // Yard corner reglar (bracket top → roof underside).
    z0 = bh + bracket_h;
    for (p = corner_reglar)
        bom_member("reglar", "pt-pine", reglar_t, fpw, p[2] - z0,
                   "yard_corner_reglar", system="vaegge");

    color(pal_post(pal))
    for (p = corner_reglar) {
        translate([p[0], p[1], z0])
            cube([reglar_t, fpw, p[2] - z0]);
    }

    sill_z = bh + bracket_h;

    // BOM — yard sills (4 segments)
    front_left_len  = V3_YARD_DOOR_X - (hl + ct);
    front_right_len = (hl + rl - fpw) - (V3_YARD_DOOR_X + V3_YARD_DOOR_W);
    if (front_left_len > 0)
        bom_member("sill", "pt-pine", fpw, V3_SILL_H, front_left_len,
                   "yard_front_sill_left", system="vaegge");
    if (front_right_len > 0)
        bom_member("sill", "pt-pine", fpw, V3_SILL_H, front_right_len,
                   "yard_front_sill_right", system="vaegge");
    bom_member("sill", "pt-pine", fpw, V3_SILL_H, rl - ct - fpw,
               "yard_back_sill", system="vaegge");
    bom_member("sill", "pt-pine", fpw, V3_SILL_H, ww - 2*fpw,
               "yard_right_sill", system="vaegge");

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

    bom_member("beam", "limtree", fpw, V3_BEAM_H, blen, "yard_front_beam", system="vaegge");
    bom_member("beam", "limtree", fpw, V3_BEAM_H, blen, "yard_back_beam", system="vaegge");

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
    // Yard sills sit on top of an 18 mm bracket on top of the fundablok
    // ring whose top is at sokkel level Z=V3_BASE_H per Phase 1 spec.
    sill_top = V3_BASE_H + V3_SILL_H + 18;

    front_xs = [hl + 3000];
    front_beam_top = v3_roof_under(0) - V3_BEAM_H;
    for (xs = front_xs)
        bom_member("stile", "spruce", sw, sw,
                   front_beam_top - sill_top, "yard_front_stile", system="vaegge");
    color(pal_post(pal))
    for (xs = front_xs)
        translate([xs - sw/2, 0, sill_top])
            cube([sw, sw, front_beam_top - sill_top]);

    back_xs = [hl + 1000, hl + 2000, hl + 3000];
    back_beam_top = v3_roof_under(ww) - V3_BEAM_H;
    for (xs = back_xs)
        bom_member("stile", "spruce", sw, sw,
                   back_beam_top - sill_top, "yard_back_stile", system="vaegge");
    color(pal_post(pal))
    for (xs = back_xs)
        translate([xs - sw/2, ww - sw, sill_top])
            cube([sw, sw, back_beam_top - sill_top]);

    right_ys = [fpw + 1000, fpw + 2000];
    color(pal_post(pal))
    for (ys = right_ys) {
        beam_top = v3_roof_under(ys) - V3_BEAM_H;
        bom_member("stile", "spruce", sw, sw,
                   beam_top - sill_top, "yard_right_stile", system="vaegge");
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
    sill_top = V3_BASE_H + V3_SILL_H + 18;
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
    sill_top = V3_BASE_H + V3_SILL_H + 18;
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
    sill_top = V3_BASE_H + V3_SILL_H + 18;
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

module v3_vaegge(stud = DEFAULT_STUD, mesh = DEFAULT_MESH,
                 palette = DEFAULT_PALETTE) {
    ll  = V3_LENGTH; ww  = V3_WIDTH; bh  = V3_BASE_H; wt  = V3_WALL_T;
    hl  = V3_HOUSE_LEN; rl  = V3_RUN_LEN;
    ehf = V3_EH_FRONT; ehb = V3_EH_BACK;
    fpw = V3_POST_W;
    ct  = 22;  // klink thickness — placeholder, used by yard helpers

    v3_house_framing(hl, ww, ehf, ehb, bh, wt, fpw, stud, palette);
    v3_yard_posts_and_sills(hl, rl, ww, bh, fpw, ct, palette);
    v3_yard_top_beams(hl, rl, ww, fpw, ct, palette);
    v3_yard_stiles(hl, rl, ww, fpw, palette);
    v3_yard_mesh_front(hl, rl, ww, fpw, ct, palette, mesh);
    v3_yard_mesh_back(hl, rl, ww, fpw, ct, palette, mesh);
    v3_yard_mesh_right(hl, rl, ww, fpw, palette, mesh);
}

// ---------------------------------------------------------------------------
// Wall bats (E1) — 95 mm Rockwool slabs in stud bays
// ---------------------------------------------------------------------------

BATS_COLOR_VAL = [0.92, 0.84, 0.55, 0.70];  // muted yellow with alpha
BATS_T         = 95;

function _v3_in_skip(c, ranges) =
    len([for (r = ranges) if (c >= r[0] && c <= r[1]) 1]) > 0;

// Insulation bats inside a length-by-h stud wall; orientation matches the
// wall's stud-wall axis. Skips bays that are part of openings.
module v3_wall_bats(origin, length, height, axis, sw=45, sd=95, sp=600,
                    skip_ranges=[]) {
    bom_member("bats_95mm", "rockwool", BATS_T, height - 2*sw,
               length, "wall_bats", system="vaegge");
    color(BATS_COLOR_VAL)
    if (axis == "X") {
        for (x = [sw : sp : length - sw - sp])
            if (!_v3_in_skip(x + sp/2, skip_ranges))
                translate([origin[0] + x, origin[1], origin[2] + sw])
                    cube([sp - sw, sd, height - 2*sw]);
    } else {
        for (y = [sw : sp : length - sw - sp])
            if (!_v3_in_skip(y + sp/2, skip_ranges))
                translate([origin[0], origin[1] + y, origin[2] + sw])
                    cube([sd, sp - sw, height - 2*sw]);
    }
}
