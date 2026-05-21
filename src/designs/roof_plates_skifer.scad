// Skifer cover on the gable roof (cover == "skifer"). Stack from rafter
// top upward:
//   0..3   mm  diffusion-open underlay
//   3..28  mm  25x38 mm taglægter parallel to the ridge
//   28..36 mm  Cembrit-style fiber-cement skifer plates (~8 mm visual thickness)
//
// Each plate is ~300 (Y) x 220 (X projected) mm, laid in halv-forbandt with
// the next course offset by half a plate width. Plate seams are rendered as
// shallow grooves on the slate surface so the roof actually reads as slate
// rather than a painted slab.

include <../lib/defaults.scad>
include <config.scad>

SK_UNDERLAY_T   = 3;
SK_BATTEN_T     = 25;
SK_BATTEN_W     = 38;
SK_BATTEN_C2C   = 220;          // course pitch along slope (X)
SK_SLATE_T      = 8;            // visible plate thickness (read as slate)
SK_PLATE_W      = 300;          // plate width along the ridge (Y)
SK_STACK_T      = SK_UNDERLAY_T + SK_BATTEN_T + SK_SLATE_T;

SK_UNDERLAY_COLOR = [0.14, 0.13, 0.12];
SK_SLATE_COLOR    = [0.20, 0.22, 0.26];
SK_SEAM_COLOR     = [0.03, 0.04, 0.06];
SK_RIDGE_COLOR    = [0.11, 0.12, 0.15];

// ============================================================================
// One tilted slab along the gable plane on [x_lo..x_hi] × [y_lo..y_hi].
// ============================================================================
module _sk_half_slab(x_lo, x_hi, y_lo, y_hi, offset_z, thick, color_rgb) {
    z00 = g_rafter_top_z(x_lo) + offset_z;
    z10 = g_rafter_top_z(x_hi) + offset_z;
    color(color_rgb)
    polyhedron(
        points = [
            [x_lo, y_lo, z00],
            [x_hi, y_lo, z10],
            [x_hi, y_hi, z10],
            [x_lo, y_hi, z00],
            [x_lo, y_lo, z00 + thick],
            [x_hi, y_lo, z10 + thick],
            [x_hi, y_hi, z10 + thick],
            [x_lo, y_hi, z00 + thick]
        ],
        faces = [[0, 1, 2, 3], [4, 7, 6, 5],
                 [0, 4, 5, 1], [1, 5, 6, 2],
                 [2, 6, 7, 3], [3, 7, 4, 0]]
    );
}

module _sk_battens(y_lo, y_hi, palette) {
    color(pal_post(palette)) {
        for (x = [-G_OH_EAVE + SK_BATTEN_W/2 :
                   SK_BATTEN_C2C : G_RIDGE_X - SK_BATTEN_W]) {
            z = g_rafter_top_z(x) + SK_UNDERLAY_T;
            translate([x, y_lo, z])
                cube([SK_BATTEN_W, y_hi - y_lo, SK_BATTEN_T]);
        }
        for (x = [G_RIDGE_X + SK_BATTEN_W/2 :
                   SK_BATTEN_C2C : RH_HOUSE_LEN + G_OH_EAVE - SK_BATTEN_W]) {
            z = g_rafter_top_z(x) + SK_UNDERLAY_T;
            translate([x, y_lo, z])
                cube([SK_BATTEN_W, y_hi - y_lo, SK_BATTEN_T]);
        }
    }
}

// ============================================================================
// Horizontal course grooves — one per batten line, sitting just above the
// slate surface so it reads as the visible exposed plate edge of each row.
// ============================================================================
module _sk_course_grooves(y_lo, y_hi) {
    // Each course butt-edge: a wide darker band stepping ~3 mm above the
    // slate surface so it reads as the visible plate edge of each row.
    z_top = SK_STACK_T;
    groove_w = 8;     // wider so it shows from a distance
    groove_h = 3;     // raised above slate top so it catches contrast
    color(SK_SEAM_COLOR) {
        for (x = [-G_OH_EAVE + SK_BATTEN_C2C/2 :
                   SK_BATTEN_C2C : G_RIDGE_X - 10]) {
            z = g_rafter_top_z(x) + z_top - 0.5;
            translate([x - groove_w/2, y_lo, z])
                cube([groove_w, y_hi - y_lo, groove_h]);
        }
        for (x = [G_RIDGE_X + SK_BATTEN_C2C/2 :
                   SK_BATTEN_C2C : RH_HOUSE_LEN + G_OH_EAVE - 10]) {
            z = g_rafter_top_z(x) + z_top - 0.5;
            translate([x - groove_w/2, y_lo, z])
                cube([groove_w, y_hi - y_lo, groove_h]);
        }
    }
}

// ============================================================================
// Vertical plate seams — short grooves between adjacent plates within each
// course. Adjacent courses are staggered by half a plate width (halv-forbandt).
// ============================================================================
module _sk_plate_seams_one_half(x_start, x_end, y_lo, y_hi) {
    z_top     = SK_STACK_T;
    n_courses = floor((x_end - x_start) / SK_BATTEN_C2C);
    seam_w    = 5;
    seam_h    = 3;
    for (i = [0 : n_courses - 1]) {
        x_mid     = x_start + (i + 0.5) * SK_BATTEN_C2C;
        y_offset  = (i % 2 == 0) ? 0 : SK_PLATE_W / 2;
        z         = g_rafter_top_z(x_mid) + z_top - 0.5;
        for (y = [y_lo + y_offset : SK_PLATE_W : y_hi]) {
            translate([x_mid - SK_BATTEN_C2C/2, y - seam_w/2, z])
                cube([SK_BATTEN_C2C, seam_w, seam_h]);
        }
    }
}

module _sk_plate_seams(y_lo, y_hi) {
    color(SK_SEAM_COLOR) {
        _sk_plate_seams_one_half(-G_OH_EAVE, G_RIDGE_X, y_lo, y_hi);
        _sk_plate_seams_one_half(G_RIDGE_X, RH_HOUSE_LEN + G_OH_EAVE,
                                  y_lo, y_hi);
    }
}

// ============================================================================
// Ridge cap — slate-following V-tent. Cross-section in XZ is a thin tilted
// V that hugs the slate top on both sides of the ridge with a small apex
// rise, extruded along Y. Renders as a clean ridge tile line.
// ============================================================================
module _sk_ridge_cap(y_lo, y_hi) {
    cap_half_w = 90;       // each leg of the cap reaches this far from ridge
    cap_lift   = 32;       // apex height above slate top at the ridge
    cap_t      = 14;       // perpendicular thickness of the cap "tile"

    x_left  = G_RIDGE_X - cap_half_w;
    x_right = G_RIDGE_X + cap_half_w;
    z_outer_l = g_rafter_top_z(x_left)  + SK_STACK_T;
    z_outer_r = g_rafter_top_z(x_right) + SK_STACK_T;
    z_apex_b  = g_rafter_top_z(G_RIDGE_X) + SK_STACK_T;
    z_apex_t  = z_apex_b + cap_lift;
    // The top edge offset is along z (vertical lift) for simplicity.
    color(SK_RIDGE_COLOR)
    translate([0, y_lo, 0])
    rotate([-90, 0, 0])
    linear_extrude(height = y_hi - y_lo)
        polygon(points = [
            [x_left,    z_outer_l],                 // 0: bottom-left
            [G_RIDGE_X, z_apex_b],                  // 1: bottom-apex
            [x_right,   z_outer_r],                 // 2: bottom-right
            [x_right,   z_outer_r + cap_t],         // 3: top-right
            [G_RIDGE_X, z_apex_t  + cap_t * 0.3],   // 4: top-apex (raised)
            [x_left,    z_outer_l + cap_t]          // 5: top-left
        ]);
}

// ============================================================================
// Top-level entry. Renders one unified slate slab per gable half — the
// underlay + battens are buried under it in real construction, so they
// are not drawn (otherwise they z-fight at the slate underside and bleed
// through as visible wood-coloured stripes).
// ============================================================================
module render_roof_plates_skifer_gable(palette = DEFAULT_PALETTE) {
    y_lo = -G_OH_RAKE;
    y_hi = RH_WIDTH + G_OH_RAKE;
    x_lo = -G_OH_EAVE;
    x_hi = RH_HOUSE_LEN + G_OH_EAVE;

    // Slate slab pushed up 1 mm above the rafter top so it doesn't z-fight
    // with the rafter / barge-rafter top edges.
    _sk_half_slab(x_lo, G_RIDGE_X, y_lo, y_hi,
                  1, SK_STACK_T - 1, SK_SLATE_COLOR);
    _sk_half_slab(G_RIDGE_X, x_hi, y_lo, y_hi,
                  1, SK_STACK_T - 1, SK_SLATE_COLOR);

    _sk_course_grooves(y_lo, y_hi);
    _sk_plate_seams(y_lo, y_hi);
    _sk_ridge_cap(y_lo, y_hi);
}
