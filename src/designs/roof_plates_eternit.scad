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
//
// Two entry forms:
//   render_roof_plates_eternit(cover)                       — full footprint
//   render_roof_plates_eternit_segment(cover, x_lo, x_hi, ...) — zone segment
//
// NOTE: previous hl=1500 + RH_OH_SIDE=220 gav 1720 = 10*B7_PITCH og perfekt
// fase-alignment ved X=hl. Med hl=2000 + RH_OH_SIDE=220 = 2220 mm passer
// ikke længere som heltal × B7_PITCH (172) — fasen springer en lille smule
// ved partition-linjen i combined view. Acceptabel da hus pt. bruger skifer
// (gable roof); B7-eternit kan stadig vælges som yard-cover.

include <../lib/defaults.scad>
include <config.scad>
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

B7_COLOR     = [0.10, 0.13, 0.18];
SCREW_HEAD_D = 20;
SCREW_HEAD_H = 6;
SCREW_COLOR  = [0.20, 0.21, 0.24];

// ============================================================================
// Battens — one per plate top edge. Restricted to [x_lo..x_hi].
// ============================================================================
module _render_battens_segment(eh_front, eh_back, depth, y_offset,
                                x_lo, x_hi, palette) {
    y_back_eave    = y_offset + depth + RH_OH_BACK + RH_FASCIA_T;
    y_front_eave   = y_offset - RH_OH_FRONT - RH_FASCIA_T;
    y_first_batten = y_back_eave - B7_A_MAAL;
    n_intervals    = floor((y_first_batten - y_front_eave) / BATTEN_C2C);

    color(pal_post(palette))
    for (i = [0 : n_intervals]) {
        y_i = y_first_batten - i * BATTEN_C2C;
        z   = _roof_underside(eh_front, eh_back, depth, y_offset, y_i);
        translate([x_lo, y_i - BATTEN_W/2, z])
            cube([x_hi - x_lo, BATTEN_W, BATTEN_T]);
    }
}

// ============================================================================
// One plate strip across [x_lo..x_hi] × [y_start..y_end].
// ============================================================================
module _eternit_strip_segment(eh_front, eh_back, depth, y_offset,
                               y_start, y_end, z_offset, x_lo, x_hi) {
    if (y_end > y_start) {
        drop_full = _roof_drop(eh_front, eh_back, depth);
        span_y    = _span_total(depth);
        strip_len = y_end - y_start;

        total_x    = x_hi - x_lo;
        n_per_wave = 12;
        n_waves    = floor(total_x / B7_PITCH);
        n_total    = n_waves * n_per_wave;

        top_pts = [for (i = [0 : n_total])
            let (x = x_lo + i * (total_x / n_total),
                 t = 360 * i / n_per_wave,
                 z = B7_THICK + B7_AMP * (1 + cos(t)) / 2)
            [x, z]
        ];
        bot_pts = [for (i = [n_total : -1 : 0])
            let (x = x_lo + i * (total_x / n_total),
                 t = 360 * i / n_per_wave,
                 z = B7_AMP * (1 + cos(t)) / 2)
            [x, z]
        ];

        z_base = _roof_underside(eh_front, eh_back, depth, y_offset, y_start)
                 + BATTEN_T + z_offset;

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

module _render_eternit_plates_segment(eh_front, eh_back, depth, y_offset,
                                       x_lo, x_hi, palette) {
    y_back_eave    = y_offset + depth + RH_OH_BACK + RH_FASCIA_T;
    y_front_eave   = y_offset - RH_OH_FRONT - RH_FASCIA_T;
    y_first_batten = y_back_eave - B7_A_MAAL;
    n_intervals    = floor((y_first_batten - y_front_eave) / BATTEN_C2C);

    y_p1_top = y_first_batten;
    y_p1_bot = y_back_eave + B7_EAVE_OVERHANG;
    _eternit_strip_segment(eh_front, eh_back, depth, y_offset,
                            y_p1_top, y_p1_bot, 0, x_lo, x_hi);

    for (i = [1 : n_intervals]) {
        y_top  = y_first_batten - i * BATTEN_C2C;
        y_kink = y_top + BATTEN_C2C;
        y_bot  = y_top + B7_PLATE_LEN;
        _eternit_strip_segment(eh_front, eh_back, depth, y_offset,
                                y_top,  y_kink, 0,        x_lo, x_hi);
        _eternit_strip_segment(eh_front, eh_back, depth, y_offset,
                                y_kink, y_bot,  B7_THICK, x_lo, x_hi);
    }

    y_last_batten = y_first_batten - n_intervals * BATTEN_C2C;
    _eternit_strip_segment(eh_front, eh_back, depth, y_offset,
                            y_front_eave,
                            y_last_batten + B7_OVERLAP, B7_THICK, x_lo, x_hi);
}

module _render_screws_segment(eh_front, eh_back, depth, y_offset,
                               x_lo, x_hi, palette) {
    y_back_eave    = y_offset + depth + RH_OH_BACK + RH_FASCIA_T;
    y_front_eave   = y_offset - RH_OH_FRONT - RH_FASCIA_T;
    y_first_batten = y_back_eave - B7_A_MAAL;
    n_intervals    = floor((y_first_batten - y_front_eave) / BATTEN_C2C);
    n_crests = floor((x_hi - x_lo) / B7_PITCH);

    color(SCREW_COLOR)
    for (i = [0 : n_intervals]) {
        y_i = y_first_batten - i * BATTEN_C2C;
        z_top = _roof_underside(eh_front, eh_back, depth, y_offset, y_i)
                + BATTEN_T + 2*B7_THICK + B7_AMP;
        for (j = [0 : 2 : n_crests]) {
            x_j = x_lo + j * B7_PITCH;
            translate([x_j, y_i, z_top])
                cylinder(d = SCREW_HEAD_D, h = SCREW_HEAD_H, $fn = 14);
        }
    }
}

// Segment renderer — used by zone dispatchers.
module render_roof_plates_eternit_segment(cover, x_lo, x_hi,
                                           eh_front = RH_EH_FRONT,
                                           eh_back  = undef,
                                           depth    = RH_HOUSE_DEPTH,
                                           y_offset = 0,
                                           palette  = DEFAULT_PALETTE) {
    eh_b = is_undef(eh_back) ? back_eave_height_for(cover) : eh_back;
    _render_battens_segment(eh_front, eh_b, depth, y_offset,
                             x_lo, x_hi, palette);
    _render_eternit_plates_segment(eh_front, eh_b, depth, y_offset,
                                    x_lo, x_hi, palette);
    _render_screws_segment(eh_front, eh_b, depth, y_offset,
                            x_lo, x_hi, palette);
}

// Full-footprint renderer — backward-compat for `RenderRoofPlates`.
module render_roof_plates_eternit(cover, palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH;
    render_roof_plates_eternit_segment(cover, -RH_OH_SIDE, ll + RH_OH_SIDE,
                                        palette = palette);
}
