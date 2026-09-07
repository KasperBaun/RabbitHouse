// Spær med hanebånd — som bygget. To spær mødes i kippen med et lodret
// stødsnit, intet kipbræt; hanebåndet binder parret mod udspredning.
// Skæremål og afsætning: docs/arbejdsplan/skiffertag/01-spaer-tegninger.html

include <../../../lib/defaults.scad>
include <../../config.scad>

SH_MEMBER_T = 45;   // perpendicular to truss plane (along Y)
SH_MEMBER_H = 95;   // in the truss plane

// Hanebånd top — 2/3 of the bottom-edge rise from eave to ridge.
SH_COLLAR_Z_TOP = G_EAVE_Z + 2 * (g_ridge_bottom_z() - G_EAVE_Z) / 3;

// X hvor spærets underkant krydser SH_COLLAR_Z_TOP — hanebåndets anlæg.
function _sh_collar_x_attach() =
    (SH_COLLAR_Z_TOP - G_EAVE_Z) / tan(G_PITCH_DEG);

// Ét spær fra x_outer til x_inner; parret mødes i G_RIDGE_X.
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

// Hanebånd — 45×95 med enderne skåret i spærets hældning, så hele endefladen
// ligger an mod spærets underside. Nederste hjørne forskydes derfor
// H / tan(hældning) mod tagfoden i forhold til det øverste.
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

// Ét spærfag ved Y = y0.
module spaer_med_haneband(y0, palette = DEFAULT_PALETTE) {
    x_left  = -G_OH_EAVE;
    x_right = RH_HOUSE_LEN + G_OH_EAVE;
    _sh_top_chord(x_left,    G_RIDGE_X, y0, palette);
    _sh_top_chord(G_RIDGE_X, x_right,   y0, palette);
    _sh_collar(y0, palette);
}
