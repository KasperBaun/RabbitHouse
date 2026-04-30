// House-yard v2 build — gabled solid house on the left + mesh-walled run with
// polycarbonate roof on the right. Entry point: build_house_yard_v2()

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

module build_house_yard_v2() {
    pal  = DEFAULT_PALETTE;
    clad = DEFAULT_CLAD;
    mesh = DEFAULT_MESH;
    stud = DEFAULT_STUD;

    ll = V2_LENGTH;
    ww = V2_WIDTH;
    bh = V2_BASE_H;
    wt = V2_WALL_T;
    hl = V2_HOUSE_LEN;
    rl = V2_RUN_LEN;
    eh = V2_EAVE_H;
    rh = V2_RIDGE_H;
    rhi = V2_RUN_H_HI;
    rlo = V2_RUN_H_LO;

    ct = cs_thick(clad);

    // --- Landscaping & foundation ----------------------------------------
    ground_grass([ll/2, ww/2]);
    gravel_path_y([V2_DOOR_X + V2_DOOR_W/2, 0]);

    slab([0, 0], [ll, ww], bh, pal);
    interior_floor([wt, wt], [hl - 2*wt, ww - 2*wt], bh, 20, pal);  // house floor
    // run floor (paver-style, slightly different tone)
    color([0.74, 0.71, 0.66])
    translate([hl, wt, bh])
        cube([rl - wt, ww - 2*wt, 25]);
    rabbit_floor_grass([wt, wt], [hl - 2*wt, ww - 2*wt], bh);  // grass inside house

    // --- House structural framing ----------------------------------------
    v2_house_framing(hl, ww, eh, rh, bh, wt, stud, pal);

    // --- House cladding (4 exterior sides + 2 gable triangles) -----------
    v2_house_cladding(hl, ww, eh, rh, bh, ct, pal, clad);

    // --- House gable roof + fascia + gutter + ridge cap -----------------
    // Ridge runs along X at Y = ww/2, so gable end walls (X=0 and X=hl)
    // align with the gable triangles in the cladding.
    roof_gable_x([0, 0, bh], hl, ww, bh + eh, bh + rh, 80, 120, 180, pal);
    fascia_and_gutter_gable_x([0, 0, bh], hl, ww, bh + eh, bh + rh,
                              120, 22, 120, 180, 90, 55, bh, pal);
    ridge_cap_x([0, 0, bh], hl, ww, bh + rh + 80, 140, 18, 180, pal);

    // --- Interior airlock divider + doors --------------------------------
    v2_airlock_walls(hl, ww, bh, wt, eh, ct, pal, stud);

    // --- House openings: outer door, inner door, pet door, vent ----------
    human_door([V2_DOOR_X, 0, bh], V2_DOOR_W, V2_DOOR_H, ct, pal);
    entrance_step(V2_DOOR_X, 0, V2_DOOR_W, bh, pal);
    // Inner door — sits in the airlock-to-house wall at Y=V2_AIRLOCK_D
    v2_inner_door(hl, ww, bh, wt, pal);
    // Rabbit pet door in the partition wall at X=V2_HOUSE_LEN
    rabbit_pet_door_yz(hl - wt, V2_PET_DOOR_Y, bh + 60,
                       V2_PET_DOOR_W, V2_PET_DOOR_H, wt, pal);
    // High gable vent on the X=0 face
    v2_gable_vent(hl, ww, eh, rh, bh, ct, pal);

    // --- Insulated nest box ---------------------------------------------
    nest_box_insulated([V2_NEST_X, V2_NEST_Y, bh + 20],
                       V2_NEST_W, V2_NEST_D, V2_NEST_H, pal);

    // --- Run structural frame -------------------------------------------
    v2_run_framing(hl, rl, ww, bh, wt, rhi, rlo, stud, pal);

    // --- Run mesh panels ------------------------------------------------
    v2_run_mesh(hl, rl, ww, bh, wt, rhi, rlo, pal, mesh);

    // --- Run back cladding (solid back for prevailing wind) -------------
    v2_run_back_cladding(hl, rl, ww, eh, bh, rhi, rlo, pal, clad);

    // --- Run polycarbonate roof + purlins + trim + gutter ---------------
    // Polycarb origin = (hl + ct, 0) so it starts at the partition
    // cladding's outer face — no left overhang clipping into the wall.
    poly_x0 = hl + ct;
    poly_len = rl - ct;
    roof_polycarb_mono([poly_x0, 0, bh + rhi], poly_len, ww, rhi - rlo,
                       12, 120, 80, 0,
                       V2_RUN_PURLIN_SP, 60, 70, pal);
    polycarb_trim_and_gutter([poly_x0, 0, bh + rhi], poly_len, ww, rhi - rlo,
                             12, 120, 80, 0, 70, 22, 90, 55, bh, pal);

    // --- Predator-proof apron skirt around run perimeter ----------------
    apron_skirt([hl, 0, ll, ww], V2_APRON_W,
                ["front", "back", "right"], pal);

    // --- Run furniture: lookout, dig tray, hay rack, hide, ramp, bowls --
    v2_run_furniture(hl, rl, ww, bh, wt, pal);

    // --- The rabbits -----------------------------------------------------
    // One sitting up near the front mesh, well visible
    translate([hl + 1300, 500, bh + 25]) rabbit(angle = -60);
    // One loafing on the lookout platform's upper deck
    translate([hl + rl/2 - 200, ww - 600, bh + 25 + 645]) rabbit_loaf(angle = 200);
    // Inside the house, near the pet door, peeking out
    translate([hl - 350, V2_PET_DOOR_Y - 100, bh + 25]) rabbit(angle = 100);
}

// ---------------------------------------------------------------------------
// V2 helper modules
// ---------------------------------------------------------------------------

// House structural framing: stud walls on all 4 sides plus the two gable
// end walls (left at X=0, partition at X=hl). For OpenSCAD purposes the
// "framing" is mostly the outline studs that the cladding hangs on.
module v2_house_framing(hl, ww, eh, rh, bh, wt, stud, pal) {
    // Front wall (Y=0..wt)
    stud_wall([0, 0, bh], hl, eh, "X", stud, pal);
    // Back wall (Y=ww-wt..ww)
    stud_wall([0, ww - ss_d(stud), bh], hl, eh, "X", stud, pal);
    // Left wall (X=0..wt) — gable, but stud frame goes up to eave_h here
    stud_wall([0, 0, bh], ww, eh, "Y", stud, pal);
    // Partition wall (X=hl-wt..hl) — gable, frame to eave_h
    stud_wall([hl - ss_d(stud), 0, bh], ww, eh, "Y", stud, pal);

    // Ridge beam runs along X at Y = ww/2 (matches roof_gable_x ridge)
    color(pal_post(pal))
    translate([0, ww/2 - 50, bh + rh - 80])
        cube([hl, 100, 80]);
}

// House cladding: rectangular eave walls + two gable-triangle end walls.
// Cladding always sits OUTSIDE the structural framing. Outer faces:
//   front Y=0:  thickness extends -Y, so origin Y = -ct
//   back  Y=ww: thickness extends +Y, so origin Y = ww
//   left  X=0:  gable, thickness extends -X, so origin X = -ct
//   right X=hl: gable, thickness extends +X (faces into run), origin X = hl
module v2_house_cladding(hl, ww, eh, rh, bh, ct, pal, clad) {
    // Front eave wall (Y=0)
    clad_wall_with_cutout([0, -ct, bh], hl, eh, "X", pal, clad,
        [V2_DOOR_X, V2_DOOR_X + V2_DOOR_W, 0, V2_DOOR_H]);
    // Back eave wall (Y=ww)
    clad_wall_rect([0, ww, bh], hl, eh, "X", pal, clad);
    // Left gable end wall (X=0) — cut out the high gable louver vent AND
    // a window in the lower gable triangle.
    difference() {
        clad_wall_gable([-ct, 0, bh], ww, eh, rh, "Y", pal, clad);
        // High vent cutout
        vent_y = ww/2 - V2_VENT_HIGH_W/2;
        vent_z = bh + (eh + rh)/2 + V2_VENT_HIGH_Z_OFFSET;
        translate([-ct - 5, vent_y, vent_z])
            cube([ct + 10, V2_VENT_HIGH_W, V2_VENT_HIGH_H]);
        // Window cutout
        translate([-ct - 5, V2_GABLE_WIN_Y, bh + V2_GABLE_WIN_Z])
            cube([ct + 10, V2_GABLE_WIN_W, V2_GABLE_WIN_H]);
    }
    v2_subtract_gable_vent_left(ww, eh, rh, bh, ct, pal);
    // Window with full trim on the X=0 face
    window_with_trim_xneg(0, V2_GABLE_WIN_Y, bh + V2_GABLE_WIN_Z,
                          V2_GABLE_WIN_W, V2_GABLE_WIN_H, ct, pal, true);
    // Right gable end wall (partition, X=hl, faces +X into the run)
    difference() {
        clad_wall_gable([hl, 0, bh], ww, eh, rh, "Y", pal, clad);
        translate([hl - 10, V2_PET_DOOR_Y, bh + 60])
            cube([ct + 20, V2_PET_DOOR_W, V2_PET_DOOR_H]);
    }
}

// Louvre slats for the high gable vent (cladding cutout handled by the
// caller). Renders the slats inside the now-empty cutout.
module v2_subtract_gable_vent_left(ww, eh, rh, bh, ct, pal) {
    vent_y = ww/2 - V2_VENT_HIGH_W/2;
    vent_z = bh + (eh + rh)/2 + V2_VENT_HIGH_Z_OFFSET;
    // Louvre frame
    color(pal_trim(pal)) {
        translate([-ct - 4, vent_y - 12, vent_z - 12])
            cube([4, V2_VENT_HIGH_W + 24, 12]);
        translate([-ct - 4, vent_y - 12, vent_z + V2_VENT_HIGH_H])
            cube([4, V2_VENT_HIGH_W + 24, 12]);
        translate([-ct - 4, vent_y - 12, vent_z])
            cube([4, 12, V2_VENT_HIGH_H]);
        translate([-ct - 4, vent_y + V2_VENT_HIGH_W, vent_z])
            cube([4, 12, V2_VENT_HIGH_H]);
    }
    // Louvre slats — angled
    color(pal_post(pal))
    for (i = [0 : 3]) {
        translate([-ct - 5, vent_y + 5, vent_z + 8 + i * 38])
            rotate([15, 0, 0])
                cube([8, V2_VENT_HIGH_W - 10, 12]);
    }
}

// Airlock interior wall at Y = V2_AIRLOCK_D running from X=0 to V2_AIRLOCK_W.
// Splits the airlock vestibule from the rest of the house.
module v2_airlock_walls(hl, ww, bh, wt, eh, ct, pal, stud) {
    // Interior wall along X (at Y = V2_AIRLOCK_D)
    stud_wall([0, V2_AIRLOCK_D, bh], V2_AIRLOCK_W, eh, "X", stud, pal);
    // Interior panel skin on the airlock side (S face)
    color(pal_wall(pal))
    translate([wt, V2_AIRLOCK_D - 14, bh + 20])
        cube([V2_AIRLOCK_W - wt, 12, eh - 60]);
    // Storage bin shapes inside the airlock (hay/bedding visualisation)
    color([0.78, 0.72, 0.40])
    translate([100, 100, bh + 20])
        cube([400, 600, 700]);
    color(pal_panel1(pal))
    translate([550, 200, bh + 20])
        cube([400, 600, 900]);
}

// Inner airlock-to-house door (faces -Y, swings into airlock).
module v2_inner_door(hl, ww, bh, wt, pal) {
    leaf_t = 38;
    door_w = V2_INNER_DOOR_W;
    door_h = V2_INNER_DOOR_H;
    dx = V2_INNER_DOOR_X;
    dy = V2_AIRLOCK_D;
    color(pal_door(pal))
    translate([dx, dy - leaf_t, bh])
        cube([door_w, leaf_t, door_h]);
    // Single-stage latch (the door is the second stage of the airlock —
    // its outer door is the first stage)
    color([0.85, 0.85, 0.88]) {
        translate([dx + door_w - 100, dy - leaf_t - 25, bh + 1050])
            cube([60, 25, 25]);
        translate([dx + door_w - 110, dy - leaf_t - 5, bh + 1000])
            cube([80, 8, 110]);
    }
}

// High gable louver vent on the X=0 face — already cut out by
// v2_subtract_gable_vent_left, but also add a low vent on the back eave.
module v2_gable_vent(hl, ww, eh, rh, bh, ct, pal) {
    // Low vent on the back wall (Y=ww), small slot near the floor.
    low_w = 600; low_h = 80;
    low_x = hl/2 - low_w/2;
    low_z = bh + 250;
    color(pal_trim(pal))
    translate([low_x, ww + ct - 1, low_z])
        cube([low_w, 3, low_h]);
    color(pal_post(pal))
    for (i = [0 : 5])
        translate([low_x + i * (low_w / 5), ww + ct - 2, low_z])
            cube([6, 5, low_h]);
}

// Run framing: front and right corner posts, top beams, partition is already
// in the house framing.
module v2_run_framing(hl, rl, ww, bh, wt, rhi, rlo, stud, pal) {
    fpw = 100;
    color(pal_post(pal)) {
        // Front-right corner post (full height to run roof)
        translate([hl + rl - fpw, 0, bh])
            cube([fpw, fpw, rhi]);
        // Back-right corner post (shorter, to the lower roof line)
        translate([hl + rl - fpw, ww - fpw, bh])
            cube([fpw, fpw, rlo]);
        // Front-left run corner post sits against the partition; it's the
        // partition stud already, but render an explicit post for visual.
        translate([hl, 0, bh])
            cube([fpw, fpw, rhi]);
        translate([hl, ww - fpw, bh])
            cube([fpw, fpw, rlo]);

        // Bottom sill plate along front (Y=0), from house to run end
        translate([hl + fpw, 0, bh])
            cube([rl - 2*fpw, fpw, wt]);
        // Bottom sill along right (X=hl+rl-fpw)
        translate([hl + rl - fpw, fpw, bh])
            cube([fpw, ww - 2*fpw, wt]);
    }

    // Sloping top beam along front (Y=0..fpw): goes from rhi at front-left to
    // rhi at front-right (it stays at run roof's high edge — front is high).
    color(pal_post(pal))
    translate([hl + fpw, 0, bh + rhi - 180])
        cube([rl - 2*fpw, fpw, 180]);
    // Sloping top beam along back (Y=ww-fpw): rlo full length
    color(pal_post(pal))
    translate([hl + fpw, ww - fpw, bh + rlo - 180])
        cube([rl - 2*fpw, fpw, 180]);
    // Right side sloping beam (front high to back low)
    top_beam_sloped_y(hl + rl - fpw, fpw, ww - 2*fpw, bh + rhi, bh + rlo,
                      fpw, 180, pal);
}

// Run mesh: full front (Y=0) face, full right (X=hl+rl) face, partial back
// (above clad strip).
module v2_run_mesh(hl, rl, ww, bh, wt, rhi, rlo, pal, mesh) {
    fpw = 100;
    md = ms_depth(mesh);
    z_lo = bh + wt;

    // Front mesh (Y=0): rectangular below the high beam (rhi - 180)
    front_h = rhi - 180 - wt;
    mesh_panel_x(hl + fpw, rl - 2*fpw, z_lo, front_h, -md, pal, mesh);

    // Right side mesh (X=hl+rl): from y=fpw to y=ww-fpw, sloped top from
    // rhi at y=0 down to rlo at y=ww. Use lowest full height + spandrel.
    right_full_h = rlo - 180 - wt;
    mesh_panel_y(fpw, ww - 2*fpw, z_lo, right_full_h, hl + rl, pal, mesh);
    // Right-side spandrel — wood wedge filling triangle above the mesh up to
    // the sloped beam.
    color(pal_post(pal))
    hull() {
        translate([hl + rl - md, fpw, z_lo + right_full_h])
            cube([md, 0.01, rhi - rlo]);
        translate([hl + rl - md, ww - fpw - 0.01, z_lo + right_full_h])
            cube([md, 0.01, 0.01]);
    }

    // Back mesh strip — high vent on back wall (above the back cladding)
    // The back wall is mostly clad; mesh sits in a high band just below the
    // back top beam (rlo - 180). Clad upper z = bh + rlo - 350; mesh band 250mm.
    back_clad_top_z = bh + rlo - 350;
    back_mesh_h = 250;
    mesh_panel_x(hl + fpw + 200, rl - 2*fpw - 400, back_clad_top_z, back_mesh_h,
                 ww - md, pal, mesh);
}

// Run back wall cladding (solid, prevailing-wind side).
module v2_run_back_cladding(hl, rl, ww, eh, bh, rhi, rlo, pal, clad) {
    ct = cs_thick(clad);
    // Full-width clad up to a high band (where the vent mesh sits)
    back_clad_top_z = bh + rlo - 350;
    wall_h = back_clad_top_z - bh;
    clad_wall_rect([hl, ww, bh], rl, wall_h, "X", pal, clad);
}

// Run interior furniture: lookout platform, dig tray, hay rack, hide, ramp.
// Bias placement toward the front mesh wall so accessories are visible from
// outside.
module v2_run_furniture(hl, rl, ww, bh, wt, pal) {
    fz = bh + 25;
    // Two-tier lookout platform against the back wall, centered in run.
    lp_x = hl + rl/2 - 700;
    lp_y = ww - 900;
    lookout_platform([lp_x, lp_y, fz], [1400, 700, 600], pal);
    // Upper deck on top
    color([0.55, 0.42, 0.22])
    translate([lp_x + 350, lp_y + 100, fz + 615])
        cube([700, 500, 30]);
    // Ramp from floor up to lookout platform — angled forward into the run
    ramp([lp_x + 200, lp_y - 1000, fz],
         [lp_x + 200, lp_y, fz + 600], 350, 30);

    // Dig tray near the front-right corner — visible through front mesh
    dig_tray([hl + rl - 1100, 200, fz], 800, 700, 130);
    // Hay rack on the back wall
    hay_rack(hl + 400, ww - wt, fz + 250, 500, 400, pal);
    // Water bowl + food bowl, mid-front
    water_bowl(hl + 700, 700, fz);
    food_bowl(hl + 950, 700, fz);
    // Hide tunnel (woven willow), near front-left of run
    play_tunnel(hl + 250, 1000, fz, 600);
    // Toys + chew items spread out
    willow_ball(hl + 1500, 350, fz + 50);
    chew_log(hl + 2400, 600, fz + 30);
    toss_toy(hl + 1900, 1200, fz + 20);

    // Small wooden hidey-cube near front-right
    color([0.58, 0.44, 0.24]) {
        translate([hl + rl - 700, 1500, fz])
            cube([400, 400, 350]);
    }
    // Hide entrance hole carved out
    color([0.05, 0.05, 0.05])
    translate([hl + rl - 720, 1600, fz + 30])
        cube([20, 200, 250]);
}
