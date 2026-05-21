// Vertical board-and-batten cladding with horizontal seam cover.
// Wide vertical main boards (25×150) stacked in 1200 mm courses with raw
// savskåret look; narrow cover boards (25×100) sit on every vertical seam
// and on the horizontal kurs-seam at Z = bh + 1200.
//
// Iteration 1: renders V3 (left wall) only. Other walls (V1, V2, V5) get
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
// Clad up to flat eave Z = G_EAVE_Z (= bh + RH_EH_FRONT = 2520) — gable
// roof has flat eave on V3, so the cladding plane is rectangular.
// Side window cutout at (RH_SIDE_WIN_Y, RH_SIDE_WIN_Z) in the wall.
// ============================================================================
module render_cladding_vertical_120_v3(palette = DEFAULT_PALETTE) {
    ww     = RH_HOUSE_DEPTH;
    bh     = RH_BASE_H;
    z_top  = G_EAVE_Z;            // 2520
    h_wall = z_top - bh;          // 2400 = 2 × 1200
    z_seam = bh + V120_COURSE_H;  // 1320

    s_back = RH_HOUSEWRAP_T + RH_COUNTER_BATTEN_T;   // 23 — to main-board back
    x_main = -s_back - V120_BOARD_T;                  // -48
    x_cover = x_main - V120_COVER_T;                  // -73

    win_z_lo = RH_FLOOR_TOP + RH_SIDE_WIN_Z;
    win_z_hi = win_z_lo + RH_SIDE_WIN_H;
    win_y_lo = RH_SIDE_WIN_Y;
    win_y_hi = win_y_lo + RH_SIDE_WIN_W;

    n_boards = floor(ww / V120_BOARD_W);   // 20

    // --- Housewrap (with window cutout) ---
    difference() {
        render_housewrap([-RH_HOUSEWRAP_T, 0, bh], ww, h_wall, "Y");
        translate([-RH_HOUSEWRAP_T - 1, win_y_lo, win_z_lo])
            cube([RH_HOUSEWRAP_T + 2, RH_SIDE_WIN_W, RH_SIDE_WIN_H]);
    }

    // --- Horizontal counter-battens (boards run vertical → battens
    //     horizontal at c/c 600). Skip the window band.
    render_horizontal_battens(
        [-s_back, 0, bh], ww, h_wall, "Y",
        c2c = 600,
        skip_zs = [[win_z_lo, win_z_hi]]);

    // --- Main vertical boards (2 stacked courses), minus window cutout.
    color(V120_BOARD_COLOR)
    difference() {
        union() {
            for (i = [0 : n_boards - 1]) {
                y0 = i * V120_BOARD_W;
                // Lower course
                translate([x_main, y0, bh])
                    cube([V120_BOARD_T, V120_BOARD_W, V120_COURSE_H]);
                // Upper course
                translate([x_main, y0, z_seam])
                    cube([V120_BOARD_T, V120_BOARD_W, h_wall - V120_COURSE_H]);
            }
        }
        // Window cutout
        translate([x_main - 1, win_y_lo, win_z_lo])
            cube([V120_BOARD_T + 2, RH_SIDE_WIN_W, RH_SIDE_WIN_H]);
    }

    // --- Vertical cover boards on every bord-bord-samling. 19 seams
    //     between 20 boards at Y = 150, 300, ..., 2850. Cover board
    //     centered on the seam (covers ±50 mm of each board edge).
    color(V120_COVER_COLOR)
    difference() {
        union() {
            for (i = [1 : n_boards - 1]) {
                y_seam = i * V120_BOARD_W;
                translate([x_cover,
                           y_seam - V120_COVER_W/2, bh])
                    cube([V120_COVER_T, V120_COVER_W, h_wall]);
            }
        }
        // Window cutout — cover boards crossing the window opening are
        // interrupted at the window frame.
        translate([x_cover - 1, win_y_lo, win_z_lo])
            cube([V120_COVER_T + 2, RH_SIDE_WIN_W, RH_SIDE_WIN_H]);
    }

    // --- Horizontal cover board at the kurs-samling (Z = z_seam),
    //     split around the window if it intersects.
    color(V120_COVER_COLOR) {
        z_h_lo = z_seam - V120_COVER_W/2;
        z_h_hi = z_seam + V120_COVER_W/2;
        crosses_window = (z_h_lo < win_z_hi) && (z_h_hi > win_z_lo);
        if (crosses_window) {
            // Left of window
            if (win_y_lo > 0)
                translate([x_cover, 0, z_h_lo])
                    cube([V120_COVER_T, win_y_lo, V120_COVER_W]);
            // Right of window
            if (win_y_hi < ww)
                translate([x_cover, win_y_hi, z_h_lo])
                    cube([V120_COVER_T, ww - win_y_hi, V120_COVER_W]);
        } else {
            translate([x_cover, 0, z_h_lo])
                cube([V120_COVER_T, ww, V120_COVER_W]);
        }
    }
}

// Entry point — currently only V3 is implemented.
module render_cladding_vertical_120(palette = DEFAULT_PALETTE) {
    render_cladding_vertical_120_v3(palette);
}
