// Eternit B7 cover stack — C18 battens + Cembrit B7 corrugated plates +
// Swisspearl tek screws.
//
// Per Swisspearl Installation Guide (rev. 02.2025):
//   plate format:  1100 x 570 mm (montage width 1022, montage height 65)
//   batten:        38 x 73 mm C18
//   batten c/c:    EXACTLY 460 mm
//   min overlap:   110 mm (570 plate - 460 effective coverage)
//   a-measurement: 510 mm (fascia outer face -> first batten, at eave)
//   eave drip:     plate hangs 60 mm past fascia outer face
//   screws:        2 per plate in wave crests at the top edge
//   min pitch:     14 deg (the default 4.6 deg is NOT buildable; use
//                  roof_cover = "eternit_14" for spec-correct geometry)

include <../lib/defaults.scad>
include <config.scad>
use <roof_structure.scad>
use <../lib/primitives/roof.scad>

BATTEN_T   = 38;
BATTEN_W   = 73;
BATTEN_C2C = 460;

B7_PLATE_LEN     = 570;
B7_PLATE_WIDTH   = 1100;
B7_PITCH         = 172;
B7_AMP           = 65;
B7_THICK         = 6.5;
B7_OVERLAP       = 110;
B7_EAVE_OVERHANG = 60;
B7_A_MAAL        = 510;

B7_COLOR     = [0.10, 0.13, 0.18];     // Cembrit "sortblå" (slate-blue)
SCREW_HEAD_D = 20;
SCREW_HEAD_H = 6;
SCREW_COLOR  = [0.20, 0.21, 0.24];

// ============================================================================
// Battens — one per plate top edge. Bottom plate hangs 60 mm in the gutter
// without a batten; top plate is cut to fit and rests on the next-to-top
// batten (short overhang < 460 mm, no separate top batten needed).
// Result for our geometry: 6 battens, c/c exactly 460 mm, first batten
// 510 mm inside the back fascia outer face.
// ============================================================================
module render_battens(eh_back, palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH;
    x_start = -RH_OH_SIDE;
    x_end   = ll + RH_OH_SIDE;

    y_back_eave    = RH_WIDTH + RH_OH_BACK + RH_FASCIA_T;
    y_front_eave   = -RH_OH_FRONT - RH_FASCIA_T;
    y_first_batten = y_back_eave - B7_A_MAAL;
    n_intervals    = floor((y_first_batten - y_front_eave) / BATTEN_C2C);

    color(pal_post(palette))
    for (i = [0 : n_intervals]) {
        y_i = y_first_batten - i * BATTEN_C2C;
        z   = roof_underside_for(eh_back, y_i);   // rafter top = batten bottom
        translate([x_start, y_i - BATTEN_W/2, z])
            cube([x_end - x_start, BATTEN_W, BATTEN_T]);
    }
}

// ============================================================================
// B7 plates — drawn as separate rows with visible overlaps.
//
// Each row spans 570 mm. Row N+1 (higher on roof) sits on top of row N in
// the overlap zone (110 mm), so row N+1's bottom 110 mm lies 6.5 mm
// (= plate thickness) higher than row N's top 110 mm. That gives the
// visible row edges that are characteristic of a B7 install.
//
// Each plate (except the bottom and top-cut) renders as two strips:
//   • top portion (460 mm) rests on its own batten   (z_offset = 0)
//   • bottom portion (110 mm) rests on the plate below (z_offset = B7_THICK)
// The transition between them lands at the next batten's Y position.
// ============================================================================
module _eternit_strip(eh_back, y_start, y_end, z_offset) {
    if (y_end > y_start) {
        ll        = RH_LENGTH;
        drop_full = total_drop_for(eh_back);
        span_y    = RH_WIDTH + RH_OH_FRONT + RH_OH_BACK;
        strip_len = y_end - y_start;

        x_start    = -RH_OH_SIDE;
        x_end      = ll + RH_OH_SIDE;
        total_x    = x_end - x_start;
        n_per_wave = 12;
        n_waves    = floor(total_x / B7_PITCH);
        n_total    = n_waves * n_per_wave;

        top_pts = [for (i = [0 : n_total])
            let (x = x_start + i * (total_x / n_total),
                 t = 360 * i / n_per_wave,
                 z = B7_THICK + B7_AMP * (1 + cos(t)) / 2)
            [x, z]
        ];
        bot_pts = [for (i = [n_total : -1 : 0])
            let (x = x_start + i * (total_x / n_total),
                 t = 360 * i / n_per_wave,
                 z = B7_AMP * (1 + cos(t)) / 2)
            [x, z]
        ];

        z_base = roof_underside_for(eh_back, y_start) + BATTEN_T + z_offset;

        color(B7_COLOR)
        translate([0, y_start, z_base])
        multmatrix([
            [1, 0,                    0, 0],
            [0, 1,                    0, 0],
            [0, -drop_full / span_y,  1, 0],
            [0, 0,                    0, 1]
        ])
        translate([0, strip_len, 0])
        rotate([90, 0, 0])
        linear_extrude(height = strip_len)
            polygon(concat(top_pts, bot_pts));
    }
}

module render_eternit_plates(eh_back, palette = DEFAULT_PALETTE) {
    y_back_eave    = RH_WIDTH + RH_OH_BACK + RH_FASCIA_T;
    y_front_eave   = -RH_OH_FRONT - RH_FASCIA_T;
    y_first_batten = y_back_eave - B7_A_MAAL;
    n_intervals    = floor((y_first_batten - y_front_eave) / BATTEN_C2C);

    // Plate 1 (bottom, at the gutter) — entire plate on slope_z. Hangs
    // 60 mm past the back fascia outer face.
    y_p1_top = y_first_batten;
    y_p1_bot = y_back_eave + B7_EAVE_OVERHANG;
    _eternit_strip(eh_back, y_p1_top, y_p1_bot, 0);

    // Plates 2..(n+1) — top portion on slope_z, bottom portion (= overlap
    // onto plate below) on slope_z + B7_THICK.
    for (i = [1 : n_intervals]) {
        y_top  = y_first_batten - i * BATTEN_C2C;
        y_kink = y_top + BATTEN_C2C;
        y_bot  = y_top + B7_PLATE_LEN;
        _eternit_strip(eh_back, y_top,  y_kink, 0);
        _eternit_strip(eh_back, y_kink, y_bot,  B7_THICK);
    }

    // Top-cut plate at the front eave — entirely in overlap with the
    // plate below (lies B7_THICK higher than plate n).
    y_last_batten = y_first_batten - n_intervals * BATTEN_C2C;
    y_cut_top     = y_front_eave;
    y_cut_bot     = y_last_batten + B7_OVERLAP;
    _eternit_strip(eh_back, y_cut_top, y_cut_bot, B7_THICK);
}

// ============================================================================
// Swisspearl 100 tek screws — 6x100 mm hardened steel with EPDM washer.
// Spec: 2 per plate in wave crests. Modelled here as one every other
// crest per batten — visually regular pattern matching real installation.
// ============================================================================
module render_screws(eh_back, palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH;
    x_start = -RH_OH_SIDE;
    x_end   = ll + RH_OH_SIDE;

    y_back_eave    = RH_WIDTH + RH_OH_BACK + RH_FASCIA_T;
    y_front_eave   = -RH_OH_FRONT - RH_FASCIA_T;
    y_first_batten = y_back_eave - B7_A_MAAL;
    n_intervals    = floor((y_first_batten - y_front_eave) / BATTEN_C2C);

    n_crests = floor((x_end - x_start) / B7_PITCH);

    color(SCREW_COLOR)
    for (i = [0 : n_intervals]) {
        y_i = y_first_batten - i * BATTEN_C2C;
        // Screws pass through both plates in the overlap zone (= plate
        // above + plate below + into the batten). Head sits on the TOP
        // plate, which is B7_THICK above batten top due to overlap kick-up.
        z_top = roof_underside_for(eh_back, y_i) + BATTEN_T + 2*B7_THICK + B7_AMP;
        for (j = [0 : 2 : n_crests]) {
            x_j = x_start + j * B7_PITCH;
            translate([x_j, y_i, z_top])
                cylinder(d = SCREW_HEAD_D, h = SCREW_HEAD_H, $fn = 14);
        }
    }
}

// Entry point — battens + plates + screws.
module render_roof_plates_eternit(cover, palette = DEFAULT_PALETTE) {
    eh_back = back_eave_height_for(cover);
    render_battens(eh_back, palette);
    render_eternit_plates(eh_back, palette);
    render_screws(eh_back, palette);
}
