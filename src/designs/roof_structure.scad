// Roof structure: rafters + lookouts + soffit + fascia + gutter.
// Shared across all roof covers. Cover-aware Z geometry via
// back_eave_height_for(cover) and fascia_top_offset_for(cover).
//
// Fascia caps (aluminium edge profiles) are part of the tagpap cover
// package and live in roof_plates_tagpap.scad.

include <../lib/defaults.scad>
include <config.scad>
use <../lib/primitives/beslag.scad>
use <../lib/primitives/roof.scad>

// ============================================================================
// Rafters — 45x95 c/c 600. Rafter bottom flushes with top-plate top
// (= roof_underside_for - RAFTER_H); rafter top is the cover bottom. Where
// a rafter crosses V1+V2 top plate is a bird's-mouth (CSG-overlap).
// ============================================================================
module render_rafters(eh_back, palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; ww = RH_WIDTH;
    sd = 95;   // wall depth (matches framing.scad STUD_DEPTH)

    y_start = -RH_OH_FRONT;
    y_end   = ww + RH_OH_BACK;
    z_start = roof_underside_for(eh_back, y_start) - RH_RAFTER_H;
    z_end   = roof_underside_for(eh_back, y_end)   - RH_RAFTER_H;

    // Bracket positions at V1 (high) and V2 (low) bearing centrelines.
    z_v1_top = RH_BASE_H + RH_EH_FRONT;
    z_v2_top = RH_BASE_H + RH_EH_BACK;
    y_brk_f  = sd / 2;
    y_brk_b  = ww - sd / 2;
    BRK_W    = 50; BRK_LEG = 90; BRK_T = 2;

    // V1+V2 top plates stop at the building line (X=0..ll); barge rafters
    // are held laterally to V3/V4 gable rafters via 3 lookouts per side
    // (see render_lookouts). Cantilever moment over the side overhang is
    // carried by the OSB diaphragm (tagpap) or by the battens (eternit) —
    // standard Danish carpentry.
    //
    //   Left barge   (X=-220)  — bracket only on +X side (open air); held
    //                            by lookouts to V3
    //   V3 gable     (X=0)     — 2 brackets, plus rests on V3 top plate
    //   Inner reglar (X=600..5400) — 2 brackets per bearing
    //   V4 gable     (X=5955)  — 2 brackets, plus rests on V4 top plate
    //   Right barge  (X=6175)  — bracket only on -X side; held by lookouts
    rafter_xs = concat(
        [-RH_OH_SIDE],
        [for (i = [0 : 9]) i * RH_RAFTER_C2C],
        [ll - RH_RAFTER_W],
        [ll + RH_OH_SIDE - RH_RAFTER_W]
    );
    n_rafters = len(rafter_xs);

    for (i = [0 : n_rafters-1]) {
        x = rafter_xs[i];
        is_left_barge  = (i == 0);
        is_right_barge = (i == n_rafters - 1);

        color(pal_post(palette))
        hull() {
            translate([x, y_start, z_start])
                cube([RH_RAFTER_W, 0.01, RH_RAFTER_H]);
            translate([x, y_end - 0.01, z_end])
                cube([RH_RAFTER_W, 0.01, RH_RAFTER_H]);
        }

        if (!is_left_barge) {
            vinkelbeslag([x, y_brk_f - BRK_W/2, z_v1_top],
                         leg=BRK_LEG, thick=BRK_T, width=BRK_W, orientation="-x+z");
            vinkelbeslag([x, y_brk_b - BRK_W/2, z_v2_top],
                         leg=BRK_LEG, thick=BRK_T, width=BRK_W, orientation="-x+z");
        }
        if (!is_right_barge) {
            vinkelbeslag([x + RH_RAFTER_W, y_brk_f - BRK_W/2, z_v1_top],
                         leg=BRK_LEG, thick=BRK_T, width=BRK_W, orientation="+x+z");
            vinkelbeslag([x + RH_RAFTER_W, y_brk_b - BRK_W/2, z_v2_top],
                         leg=BRK_LEG, thick=BRK_T, width=BRK_W, orientation="+x+z");
        }
    }
}

// ============================================================================
// Lookouts — 175 mm lateral blockings between barge and V3/V4 gable rafters.
// 3 per side, 45x95, at Y=47.5 / 1250 / 2452.5. They sit in the 175 mm
// space between the two outermost rafters and hold the barge rafter
// laterally to the gable rafter.
// ============================================================================
LOOKOUT_LEN = RH_OH_SIDE - RH_RAFTER_W;   // 175
LOOKOUT_YS  = [47.5, RH_WIDTH/2, RH_WIDTH - 47.5];

module render_lookouts(eh_back, palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH;
    color(pal_post(palette))
    for (yc = LOOKOUT_YS) {
        z_top = roof_underside_for(eh_back, yc);
        z_bot = z_top - RH_RAFTER_H;
        y_min = yc - RH_RAFTER_W/2;
        translate([-RH_OH_SIDE + RH_RAFTER_W, y_min, z_bot])
            cube([LOOKOUT_LEN, RH_RAFTER_W, RH_RAFTER_H]);
        translate([ll, y_min, z_bot])
            cube([LOOKOUT_LEN, RH_RAFTER_W, RH_RAFTER_H]);
    }
}

// ============================================================================
// Soffit — 18 mm plywood closing the eave undersides on all 4 sides.
// Sloped (follows rafter / lookout bottom). Front + back span the full
// eave width (incl. side bargeboards); sides end at the wall lines to
// avoid double coverage.
// ============================================================================
SOFFIT_T = 18;

module _soffit_panel(x0, x1, y0, y1, eh_back, palette) {
    z_top_y0 = roof_underside_for(eh_back, y0) - RH_RAFTER_H;
    z_top_y1 = roof_underside_for(eh_back, y1) - RH_RAFTER_H;
    color(pal_panel1(palette))
    polyhedron(
        points = [
            [x0, y0, z_top_y0 - SOFFIT_T],
            [x1, y0, z_top_y0 - SOFFIT_T],
            [x1, y1, z_top_y1 - SOFFIT_T],
            [x0, y1, z_top_y1 - SOFFIT_T],
            [x0, y0, z_top_y0],
            [x1, y0, z_top_y0],
            [x1, y1, z_top_y1],
            [x0, y1, z_top_y1]
        ],
        faces = [[0,1,2,3], [4,7,6,5], [0,4,5,1], [1,5,6,2], [2,6,7,3], [3,7,4,0]]
    );
}

module render_soffit(eh_back, palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; ww = RH_WIDTH;
    x_left  = -RH_OH_SIDE - RH_FASCIA_T;
    x_right = ll + RH_OH_SIDE + RH_FASCIA_T;
    _soffit_panel(x_left, x_right, -RH_OH_FRONT, 0, eh_back, palette);
    _soffit_panel(x_left, x_right, ww, ww + RH_OH_BACK, eh_back, palette);
    _soffit_panel(x_left, 0,       0, ww, eh_back, palette);
    _soffit_panel(ll,     x_right, 0, ww, eh_back, palette);
}

// ============================================================================
// Sloped slab parallel to roof underside — vertical offset above rafter top,
// given thickness and colour. Used by cover layers (OSB, felt, etc.).
// ============================================================================
module _roof_layer(eh_back, offset_z, thick, color_rgb) {
    ll = RH_LENGTH; ww = RH_WIDTH;
    drop_full = total_drop_for(eh_back);
    roof_oz   = roof_oz_for(eh_back);
    color(color_rgb)
    polyhedron(
        points = [
            [-RH_OH_SIDE, -RH_OH_FRONT,           roof_oz + offset_z],
            [ll + RH_OH_SIDE, -RH_OH_FRONT,       roof_oz + offset_z],
            [ll + RH_OH_SIDE, ww + RH_OH_BACK,    roof_oz - drop_full + offset_z],
            [-RH_OH_SIDE, ww + RH_OH_BACK,        roof_oz - drop_full + offset_z],
            [-RH_OH_SIDE, -RH_OH_FRONT,           roof_oz + offset_z + thick],
            [ll + RH_OH_SIDE, -RH_OH_FRONT,       roof_oz + offset_z + thick],
            [ll + RH_OH_SIDE, ww + RH_OH_BACK,    roof_oz - drop_full + offset_z + thick],
            [-RH_OH_SIDE, ww + RH_OH_BACK,        roof_oz - drop_full + offset_z + thick]
        ],
        faces = [[0,1,2,3], [4,7,6,5], [0,4,5,1], [1,5,6,2], [2,6,7,3], [3,7,4,0]]
    );
}

// ============================================================================
// Fascia-top offset above roof_oz, per cover. The fascia top sits at this
// offset so the cover plate either laps over (tagpap) or drips past
// (eternit) the fascia edge.
//   tagpap:  cover_thick (OSB 18 + underlay 3 + felt 4 = 25) + STERN_LIP 7
//   eternit: BATTEN_T (38) - clearance (8) = 30  — fascia top just under
//            the corrugation trough so B7 drips past freely
// ============================================================================
function fascia_top_offset_for(cover) =
      cover == "tagpap_osb" || cover == "tagpap" ?
        (18 + 3 + 4) + 7
    : cover == "eternit_b7" || cover == "eternit_10" || cover == "eternit_14" ?
        (38 - 8)
    : 0;

// ============================================================================
// Entry point — rafters + lookouts always; fascia + gutter + soffit when
// show_finish=true.
// ============================================================================
module RenderRoofStructure(roof_cover, show_finish = true,
                           palette = DEFAULT_PALETTE) {
    eh_back = back_eave_height_for(roof_cover);

    render_rafters(eh_back, palette);
    render_lookouts(eh_back, palette);

    if (show_finish) {
        fascia_origin_z = roof_oz_for(eh_back) + fascia_top_offset_for(roof_cover);
        fascia_and_gutter_mono([0, 0, fascia_origin_z],
                               RH_LENGTH, RH_WIDTH, total_drop_for(eh_back),
                               125, RH_FASCIA_T,
                               RH_OH_FRONT + RH_FASCIA_T,
                               RH_OH_BACK  + RH_FASCIA_T,
                               RH_OH_SIDE  + RH_FASCIA_T,
                               110, 65, RH_BASE_H, palette);
        render_soffit(eh_back, palette);
    }
}
