// Lean-to v1 — preset and constants.
//
// Preset names match the original v1: "6x3" / "7x3" / "8x4". Each preset
// yields [length, width, eave_h, rabbit_len].

include <../../lib/presets.scad>

function v1_dims_for(preset) =
    let(d = preset_dims_v1(preset))
    [d[0], d[1], d[2], d[3]];

function v1_rabbit_len_for(preset) = preset_dims_v1(preset)[3];

// Width-dependent v1 constants, computed from a width value.
function v1_roof_drop_back(width)      = width >= 4000 ? 220 : 180;
function v1_right_side_clad_h(width)   = width >= 4000 ? 1300 : 1200;
function v1_right_bench_y0(width)      = width >= 4000 ? 2000 : 1600;

V1_FRONT_POST_W      = 120;
V1_FRONT_TOP_BEAM_H  = 180;
V1_DOOR_W            = 850;
V1_DOOR_H            = 2100;
V1_SLUICE_SIZE       = 1000;
V1_SLUICE_OPEN_W     = 800;
V1_SLUICE_OPEN_H     = 2100;
