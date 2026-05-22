// Spær med hanebånd — traditional rafter-pair with collar tie.
//
//        /\
//       /  \
//      /    \
//     /------\      hanebånd at 2/3 of bottom-edge rise (eave to ridge)
//    /        \
//   /          \
//  /            \
// /              \
//
// Two top chords meet at the apex with a clean butt joint. NO ridge
// board — the hanebånd ties the rafter pair against spreading and the
// pair meets directly at X = G_RIDGE_X. Headroom is clear from floor to
// hanebånd top across the full span, and clear from hanebånd to apex in
// the middle 1/3 of the span.

include <../../../lib/defaults.scad>
include <../../config.scad>

SH_MEMBER_T = 45;   // perpendicular to truss plane (along Y)
SH_MEMBER_H = 95;   // in the truss plane

// Hanebånd top — 2/3 of the bottom-edge rise from eave to ridge.
SH_COLLAR_Z_TOP = G_EAVE_Z + 2 * (g_ridge_bottom_z() - G_EAVE_Z) / 3;

// X where each rafter's bottom edge crosses SH_COLLAR_Z_TOP — the
// attach point for the hanebånd end face.
//   Left rafter bottom edge: z = G_EAVE_Z + x * tan(pitch)
//   z = SH_COLLAR_Z_TOP  =>  x = (SH_COLLAR_Z_TOP − G_EAVE_Z)/tan(pitch)
function _sh_collar_x_attach() =
    (SH_COLLAR_Z_TOP - G_EAVE_Z) / tan(G_PITCH_DEG);

// ============================================================================
// One sloped top chord (rafter) from x_outer to x_inner — both rafters
// of a pair meet at X = G_RIDGE_X with a vertical butt joint.
// ============================================================================
module _sh_top_chord(x_outer, x_inner, y0, palette) {
    z_outer = g_rafter_bottom_z(x_outer);
    z_inner = g_rafter_bottom_z(x_inner);
    color(pal_post(palette))
    hull() {
        translate([x_outer, y0, z_outer])
            cube([0.01, SH_MEMBER_T, SH_MEMBER_H]);
        translate([x_inner - 0.01, y0, z_inner])
            cube([0.01, SH_MEMBER_T, SH_MEMBER_H]);
    }
}

// ============================================================================
// Hanebånd (collar tie) — horizontal 45×95 reglar. ENDS ARE ANGLE-CUT at
// the rafter pitch so the entire end face sits flush against the rafter
// underside — not just the top corner.
//
// Geometry in the X-Z plane (left half):
//   top corner    @ (x_top_l, z_top) — touches rafter underside
//   bottom corner @ (x_bot_l, z_bot) — also on rafter underside, offset
//                                       toward the eave by H / tan(pitch)
//
// The end-cut line from top to bottom corner has the same slope as the
// rafter underside, so the cut surface lies in the rafter plane.
// ============================================================================
module _sh_collar(y0, palette) {
    x_top_l = _sh_collar_x_attach();
    x_top_r = RH_HOUSE_LEN - x_top_l;
    x_bot_l = x_top_l - SH_MEMBER_H / tan(G_PITCH_DEG);
    x_bot_r = RH_HOUSE_LEN - x_bot_l;
    z_top   = SH_COLLAR_Z_TOP;
    z_bot   = SH_COLLAR_Z_TOP - SH_MEMBER_H;
    y_lo = y0;
    y_hi = y0 + SH_MEMBER_T;
    color(pal_post(palette))
    polyhedron(
        points = [
            [x_bot_l, y_lo, z_bot],  // 0
            [x_bot_r, y_lo, z_bot],  // 1
            [x_top_r, y_lo, z_top],  // 2
            [x_top_l, y_lo, z_top],  // 3
            [x_bot_l, y_hi, z_bot],  // 4
            [x_bot_r, y_hi, z_bot],  // 5
            [x_top_r, y_hi, z_top],  // 6
            [x_top_l, y_hi, z_top]   // 7
        ],
        faces = [
            [0, 1, 2, 3],   // -Y face
            [4, 7, 6, 5],   // +Y face
            [0, 4, 5, 1],   // bottom face (z=z_bot)
            [3, 2, 6, 7],   // top face    (z=z_top)
            [0, 3, 7, 4],   // left angled end
            [1, 5, 6, 2]    // right angled end
        ]
    );
}

// ============================================================================
// Entry — one full rafter pair with hanebånd at Y position y0.
// ============================================================================
module spaer_med_haneband(y0, palette = DEFAULT_PALETTE) {
    x_left  = -G_OH_EAVE;
    x_right = RH_HOUSE_LEN + G_OH_EAVE;
    _sh_top_chord(x_left,    G_RIDGE_X, y0, palette);
    _sh_top_chord(G_RIDGE_X, x_right,   y0, palette);
    _sh_collar(y0, palette);
}
