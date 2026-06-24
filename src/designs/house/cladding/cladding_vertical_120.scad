// Vertical board-and-batten cladding with horizontal seam cover.
// Wide vertical main boards (25×150) stacked in 1200 mm courses with raw
// savskåret look; narrow cover boards (25×100) sit on every vertical seam
// and on the horizontal kurs-seam at Z = bh + 1200.
//
// Iteration 1: renders V3 (left wall) only. Other walls (V1, V2, V4) get
// added once V3 is approved.
//
// Stickout: housewrap 1 + horizontal counter-batten 22 + main board 25 +
// cover board 25 = 73 mm (same total as board-on-board).

include <../../../lib/defaults.scad>
include <../../config.scad>
use <cladding_common.scad>

V120_BOARD_W      = 150;   // hovedbræt bredde
V120_BOARD_T      = 25;    // hovedbræt tykkelse
V120_COURSE_H     = 1200;  // bræthøjde pr. kurs
V120_COVER_W      = 100;   // dækbræt bredde
V120_COVER_T      = 25;    // dækbræt tykkelse
V120_BOARD_COLOR  = [0.62, 0.50, 0.36];  // rå savskåret gran
V120_COVER_COLOR  = [0.50, 0.40, 0.28];  // mørkere dækbræt for kontrast

// Total stickout from stud outer face.
function v120_stickout() =
    RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T + V120_BOARD_T + V120_COVER_T;

// ============================================================================
// V3 — left exterior wall (X = 0, outer face faces -X, Y = 0..ww).
// Clad up to flat eave Z = G_EAVE_Z — gable roof has flat eave on V3, so
// the cladding plane is rectangular. No window.
// ============================================================================
module render_cladding_vertical_120_v3(palette = DEFAULT_PALETTE) {
    ww     = RH_HOUSE_DEPTH;
    bh     = RH_BASE_H;
    z_top  = G_EAVE_Z;
    h_wall = z_top - bh;
    z_seam = bh + V120_COURSE_H;
    upper_h = h_wall - V120_COURSE_H;   // top course (shorter than lower)

    s_back = RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T;   // 23 — to main-board back
    x_main = -s_back - V120_BOARD_T;
    x_cover = x_main - V120_COVER_T;

    n_boards = floor(ww / V120_BOARD_W);

    // --- Housewrap ---
    render_housewrap([-RH_HOUSEWRAP_T, 0, bh], ww, h_wall, "Y");

    // --- Horizontal counter-battens (boards run vertical → battens
    //     horizontal at c/c 600).
    render_horizontal_battens(
        [-s_back, 0, bh], ww, h_wall, "Y", c2c = 600);

    // --- Main vertical boards (2 stacked courses).
    color(V120_BOARD_COLOR)
    for (i = [0 : n_boards - 1]) {
        y0 = i * V120_BOARD_W;
        translate([x_main, y0, bh])
            cube([V120_BOARD_T, V120_BOARD_W, V120_COURSE_H]);
        translate([x_main, y0, z_seam])
            cube([V120_BOARD_T, V120_BOARD_W, upper_h]);
    }

    // --- Vertical cover boards on every bord-bord-samling. n-1 seams
    //     between n boards, centered on the seam.
    color(V120_COVER_COLOR)
    for (i = [1 : n_boards - 1]) {
        y_seam = i * V120_BOARD_W;
        translate([x_cover, y_seam - V120_COVER_W/2, bh])
            cube([V120_COVER_T, V120_COVER_W, h_wall]);
    }

    // --- Horizontal cover board at the kurs-samling (Z = z_seam).
    color(V120_COVER_COLOR)
    translate([x_cover, 0, z_seam - V120_COVER_W/2])
        cube([V120_COVER_T, ww, V120_COVER_W]);
}

// Entry point — currently only V3 is implemented.
module render_cladding_vertical_120(palette = DEFAULT_PALETTE) {
    render_cladding_vertical_120_v3(palette);
}
