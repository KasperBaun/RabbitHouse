// Skifer cover on the gable roof (cover == "skifer"). Stack from rafter
// top upward:
//   0..3   mm  diffusion-open underlay
//   3..28  mm  25x38 mm taglægter parallel to the ridge
//   28..36 mm  Cembrit-style fiber-cement skifer plates (~8 mm visual thickness)
//
// 30×60 cm plates in halv-forbandt: 5 courses per half-slope, plate width
// 300 mm along the ridge (Y), plate length 600 mm up-slope. Slope is
// dimensioned so the math goes up exactly:
//   slope = 4 × gauge(225 slope) + 600 = 1500 mm
//   horizontal pitch = 225 × cos(35°) ≈ 184 mm — see SK_BATTEN_C2C
//   lap = 600 − 2 × 225 = 150 mm (≥ 70 mm min for 35° pitch)
// Plate seams are rendered as shallow grooves on the slate surface so the
// roof reads as slate rather than a painted slab.

include <../lib/defaults.scad>
include <config.scad>

SK_UNDERLAY_T   = 3;
SK_BATTEN_T     = 25;
SK_BATTEN_W     = 38;
SK_PLATE_L      = 600;          // plate length up the slope
SK_PLATE_W      = 300;          // plate width along the ridge (Y)
SK_BATTEN_C2C   = 184;          // horizontal projection of slope-gauge 225 mm
SK_SLATE_T      = 8;            // visible plate thickness (read as slate)
SK_STACK_T      = SK_UNDERLAY_T + SK_BATTEN_T + SK_SLATE_T;

// No rake overhang — slate slab terminates at the gable walls, so seams
// and grooves run all the way to the edge.
SK_RAKE_INSET   = 0;

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

// Diffusion-open underlay (undertag) — a thin membrane draped on the rafter
// tops, following the roof plane. One tilted slab per half-slope.
module _sk_underlay(y_lo, y_hi) {
    _sk_half_slab(-G_OH_EAVE, G_RIDGE_X,               y_lo, y_hi, 0, SK_UNDERLAY_T, SK_UNDERLAY_COLOR);
    _sk_half_slab(G_RIDGE_X,  RH_HOUSE_LEN + G_OH_EAVE, y_lo, y_hi, 0, SK_UNDERLAY_T, SK_UNDERLAY_COLOR);
}

// Taglægter — 25×38, parallel to the ridge (run the full Y depth), at c/c up
// each half-slope. Each is a slope-following slab (a flat cube would diverge
// from the 35° plane and poke up through the slate at its up-slope edge).
module _sk_battens(y_lo, y_hi, palette) {
    for (x = [-G_OH_EAVE + SK_BATTEN_W/2 :
               SK_BATTEN_C2C : G_RIDGE_X - SK_BATTEN_W])
        _sk_half_slab(x - SK_BATTEN_W/2, x + SK_BATTEN_W/2, y_lo, y_hi,
                      SK_UNDERLAY_T - 0.5, SK_BATTEN_T, pal_post(palette));
    for (x = [G_RIDGE_X + SK_BATTEN_W/2 :
               SK_BATTEN_C2C : RH_HOUSE_LEN + G_OH_EAVE - SK_BATTEN_W])
        _sk_half_slab(x - SK_BATTEN_W/2, x + SK_BATTEN_W/2, y_lo, y_hi,
                      SK_UNDERLAY_T - 0.5, SK_BATTEN_T, pal_post(palette));
}

// Course grooves and plate seams are rendered as thin tilted slabs that
// follow the slate plane (via _sk_half_slab) — NOT as axis-aligned cubes.
// An axis-aligned cube spanning a wide X range would diverge from the
// slate plane by up to (Δx × tan(pitch)) at its ends, leaving the cube
// sticking up into thin air at one corner and buried inside the slab at
// the other. The tilted slabs sit flush on the slate top all along their
// length.
SK_GROOVE_W = 10;            // X-extent of course-edge groove
SK_SEAM_W   = 7;             // Y-extent of plate seam
SK_GROOVE_H = 0.5;           // raised-above-slate height (vertical)
SK_N_COURSES = 5;            // courses per half-slope (slope = 1500 mm = 4G+600)

// ============================================================================
// Horizontal course grooves — one per course bottom on each half-slope.
// Each groove is a thin tilted slab (groove_w along slope) running the
// full Y depth.
// ============================================================================
module _sk_course_grooves(y_lo, y_hi) {
    yd_lo = y_lo + SK_RAKE_INSET;
    yd_hi = y_hi - SK_RAKE_INSET;
    for (i = [0 : SK_N_COURSES - 1]) {
        x_l = -G_OH_EAVE + SK_BATTEN_C2C/2 + i * SK_BATTEN_C2C;
        _sk_half_slab(x_l - SK_GROOVE_W/2, x_l + SK_GROOVE_W/2,
                      yd_lo, yd_hi,
                      SK_STACK_T - 0.2, SK_GROOVE_H, SK_SEAM_COLOR);
        x_r = G_RIDGE_X + SK_BATTEN_C2C/2 + i * SK_BATTEN_C2C;
        _sk_half_slab(x_r - SK_GROOVE_W/2, x_r + SK_GROOVE_W/2,
                      yd_lo, yd_hi,
                      SK_STACK_T - 0.2, SK_GROOVE_H, SK_SEAM_COLOR);
    }
}

// ============================================================================
// Vertical plate seams — between adjacent plates within each course.
// Adjacent courses are staggered by half a plate width (halv-forbandt).
// Each seam is a thin tilted slab spanning one course (c2c along slope)
// at the plate boundary along Y.
// ============================================================================
module _sk_plate_seams_one_half(x_start, y_lo, y_hi) {
    yd_lo = y_lo + SK_RAKE_INSET;
    yd_hi = y_hi - SK_RAKE_INSET;
    for (i = [0 : SK_N_COURSES - 1]) {
        x_mid    = x_start + (i + 0.5) * SK_BATTEN_C2C;
        y_offset = (i % 2 == 0) ? 0 : SK_PLATE_W / 2;
        for (y = [yd_lo + y_offset : SK_PLATE_W : yd_hi]) {
            _sk_half_slab(x_mid - SK_BATTEN_C2C/2, x_mid + SK_BATTEN_C2C/2,
                          y - SK_SEAM_W/2, y + SK_SEAM_W/2,
                          SK_STACK_T - 0.2, SK_GROOVE_H, SK_SEAM_COLOR);
        }
    }
}

module _sk_plate_seams(y_lo, y_hi) {
    _sk_plate_seams_one_half(-G_OH_EAVE,  y_lo, y_hi);
    _sk_plate_seams_one_half(G_RIDGE_X,   y_lo, y_hi);
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
// Top-level entry. Draws the full roof build-up as separate slope-following
// layers on the rafters: undertag (diffusion-open underlay) → taglægter
// 25×38 → skifer plates. Each layer occupies its own band of the stack so
// nothing z-fights; the slate plates are only the top SK_SLATE_T (the
// underlay + lægter are visible at the eave edge and from the underside).
// ============================================================================
module render_roof_plates_skifer_gable(palette = DEFAULT_PALETTE) {
    y_lo = -G_OH_RAKE;
    y_hi = RH_HOUSE_DEPTH + G_OH_RAKE;
    x_lo = -G_OH_EAVE;
    x_hi = RH_HOUSE_LEN + G_OH_EAVE;

    // Underlay + lægter run only between the gable walls (not into the rake
    // overhang), so their ends stay hidden behind the vindskede — the barge
    // overhang reads as clean slate.
    _sk_underlay(0, RH_HOUSE_DEPTH);
    _sk_battens(0, RH_HOUSE_DEPTH, palette);

    // Slate plates — only the top SK_SLATE_T of the stack, lapping ~1 mm over
    // the lægte tops so no faces coincide.
    slate_z0 = SK_UNDERLAY_T + SK_BATTEN_T - 1;
    _sk_half_slab(x_lo, G_RIDGE_X, y_lo, y_hi,
                  slate_z0, SK_STACK_T - slate_z0, SK_SLATE_COLOR);
    _sk_half_slab(G_RIDGE_X, x_hi, y_lo, y_hi,
                  slate_z0, SK_STACK_T - slate_z0, SK_SLATE_COLOR);

    _sk_course_grooves(y_lo, y_hi);
    _sk_plate_seams(y_lo, y_hi);
    _sk_ridge_cap(y_lo, y_hi);
}
