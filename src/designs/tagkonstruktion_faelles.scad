// tagkonstruktion_faelles.scad — delt struktur og helpers for v3 tag.
//
// Bærende træværk + sofitt + helper for cover-lag. Disse moduler er
// IDENTISKE uanset roof_cover-valg og bruges af både
// tagkonstruktion_tagpap.scad og tagkonstruktion_eternit.scad.
//
// Indhold:
//   rh_spaer        — 45×95 spær c/c 600 + vinkelbeslag ved V1/V2 toprem
//   rh_lookouts     — 175 mm tværblokering mellem barge og V3/V4 gable
//   rh_sofitt       — 18 mm krydsfiner under tagskæg på alle 4 sider
//   _rh_roof_layer  — privat helper: sloped slab parallelt med tag-underside
//   _rh_sofitt_panel — privat helper for rh_sofitt

include <../lib/defaults.scad>
include <config.scad>
use <../lib/primitives/beslag.scad>

// ============================================================================
// Spær — bærende lag, samme uanset cover.
// Spær-bunden flugter med toprem-toppen (= rh_roof_under_for - RH_SPAER_H),
// spær-toppen er på roof underside (= cover bund). Spær spænder fra
// front-eave til bag-eave. Hvor spær krydser V1+V2 toprem er det bird's-mouth
// (CSG-overlap).
// ============================================================================
module rh_spaer(eh_back, palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; ww = RH_WIDTH;
    sd = 95;  // wall depth (matcher konstruktions-skelet's STUD_DEPTH)

    y_start = -RH_OH_FRONT;
    y_end   = ww + RH_OH_BACK;
    z_start = rh_roof_under_for(eh_back, y_start) - RH_SPAER_H;
    z_end   = rh_roof_under_for(eh_back, y_end)   - RH_SPAER_H;

    // Bracket-konstanter (vinkelbeslag på hver side af spæret ved V1 og V2)
    z_v1_top = RH_BASE_H + RH_EH_FRONT;     // 2520
    z_v2_top = RH_BASE_H + RH_EH_BACK;      // 2320
    y_brk_f  = sd / 2;                      // 47.5 — V1 bearing midte
    y_brk_b  = ww - sd / 2;                 // 2452.5 — V2 bearing midte
    BRK_W    = 50; BRK_LEG = 90; BRK_T = 2;

    // Spær-X-positioner. V1+V2 toprem stopper ved byggelinjen (X=0..ll);
    // barge-spæret lateral-fastholdes til V3/V4-gable-spæret via 3 tvær-
    // blokeringer pr. side (se rh_lookouts) ved Y=47,5 / 1250 / 2452,5.
    // Kantilever-moment over side-overhang bæres af OSB-diaphragm (tagpap)
    // eller af lægter (eternit).
    //
    //   Barge venstre (X=-220) — bracket kun på +X side (yderside i luft);
    //                            holdt af tværblokering til V3
    //   Gable V3       (X=0)    — 2 brackets, plus hviler på V3 toprem
    //   Indre regulære (X=600, 1200, ..., 5400) — 2 brackets pr. bearing
    //   Gable V4       (X=5955) — 2 brackets, plus hviler på V4 toprem
    //   Barge højre    (X=6175) — bracket kun på -X side; holdt af tværblokering
    spaer_xs = concat(
        [-RH_OH_SIDE],                                  // venstre barge
        [for (i = [0 : 9]) i * RH_SPAER_C2C],           // 0, 600, ..., 5400
        [ll - RH_SPAER_W],                              // V4 gable
        [ll + RH_OH_SIDE - RH_SPAER_W]                  // højre barge
    );
    n_spaer = len(spaer_xs);

    for (i = [0 : n_spaer-1]) {
        x = spaer_xs[i];
        is_left_barge  = (i == 0);
        is_right_barge = (i == n_spaer - 1);

        color(pal_post(palette))
        hull() {
            translate([x, y_start, z_start])
                cube([RH_SPAER_W, 0.01, RH_SPAER_H]);
            translate([x, y_end - 0.01, z_end])
                cube([RH_SPAER_W, 0.01, RH_SPAER_H]);
        }

        // Venstre side af spæret (bracket peger -X) — droppes for venstre barge
        // hvor toprem-forlængelsen ender ved spærets venstre kant.
        if (!is_left_barge) {
            vinkelbeslag([x, y_brk_f - BRK_W/2, z_v1_top],
                         leg=BRK_LEG, thick=BRK_T, width=BRK_W, orientation="-x+z");
            vinkelbeslag([x, y_brk_b - BRK_W/2, z_v2_top],
                         leg=BRK_LEG, thick=BRK_T, width=BRK_W, orientation="-x+z");
        }
        // Højre side af spæret (bracket peger +X) — droppes for højre barge.
        if (!is_right_barge) {
            vinkelbeslag([x + RH_SPAER_W, y_brk_f - BRK_W/2, z_v1_top],
                         leg=BRK_LEG, thick=BRK_T, width=BRK_W, orientation="+x+z");
            vinkelbeslag([x + RH_SPAER_W, y_brk_b - BRK_W/2, z_v2_top],
                         leg=BRK_LEG, thick=BRK_T, width=BRK_W, orientation="+x+z");
        }
    }
}

// ============================================================================
// Lookouts / tværblokering mellem barge-spær og V3/V4-gable-spær.
// 3 stk pr. side i spær-planet, 45×95, ved Y=47,5 / 1250 / 2452,5.
//
// Geometri: blokken sidder i den 175 mm brede tomgang mellem de to
// yderste spær — yder-flade mod barge-rafterens inder-face, inder-flade
// mod V3/V4-gable-spærets yder-face. Længde = RH_OH_SIDE − RH_SPAER_W.
//
// Struktur: tværblokkene fastholder barge-spæret lateralt mod V3/V4-
// gable-spæret. Kantilever-moment over side-overhang bæres primært af
// OSB-pladen (tagpap) eller af lægterne (eternit) som diaphragm —
// standard dansk småhus-konstruktion.
// ============================================================================
LOOKOUT_LEN = RH_OH_SIDE - RH_SPAER_W;   // 175 = 220 − 45
LOOKOUT_YS  = [47.5, RH_WIDTH/2, RH_WIDTH - 47.5];

module rh_lookouts(eh_back, palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH;
    color(pal_post(palette))
    for (yc = LOOKOUT_YS) {
        z_top = rh_roof_under_for(eh_back, yc);
        z_bot = z_top - RH_SPAER_H;
        y_min = yc - RH_SPAER_W/2;
        // Venstre: mellem barge (X=-220..-175) og V3-gable (X=0..45).
        translate([-RH_OH_SIDE + RH_SPAER_W, y_min, z_bot])
            cube([LOOKOUT_LEN, RH_SPAER_W, RH_SPAER_H]);
        // Højre: mellem V4-gable (X=5955..6000) og barge (X=6175..6220).
        translate([ll, y_min, z_bot])
            cube([LOOKOUT_LEN, RH_SPAER_W, RH_SPAER_H]);
    }
}

// ============================================================================
// Sofitt — 18 mm krydsfiner der lukker undersiden af tagskægget på alle
// 4 sider. Sloped (følger spær-/lookout-bund). Farve pal_panel1 (= klink).
// Front + bag dækker hele eave-bredden (inkl. side-vindskede-yder-flader);
// sider slutter ved væglinjerne (Y=0..ww) for at undgå dobbelt-dækning.
// ============================================================================
SOFITT_T = 18;

module _rh_sofitt_panel(x0, x1, y0, y1, eh_back, palette) {
    z_top_y0 = rh_roof_under_for(eh_back, y0) - RH_SPAER_H;
    z_top_y1 = rh_roof_under_for(eh_back, y1) - RH_SPAER_H;
    color(pal_panel1(palette))
    polyhedron(
        points = [
            [x0, y0, z_top_y0 - SOFITT_T],
            [x1, y0, z_top_y0 - SOFITT_T],
            [x1, y1, z_top_y1 - SOFITT_T],
            [x0, y1, z_top_y1 - SOFITT_T],
            [x0, y0, z_top_y0],
            [x1, y0, z_top_y0],
            [x1, y1, z_top_y1],
            [x0, y1, z_top_y1]
        ],
        faces = [[0,1,2,3], [4,7,6,5], [0,4,5,1], [1,5,6,2], [2,6,7,3], [3,7,4,0]]
    );
}

module rh_sofitt(eh_back, palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; ww = RH_WIDTH;
    x_left  = -RH_OH_SIDE - RH_STERN_T;
    x_right = ll + RH_OH_SIDE + RH_STERN_T;
    // Front (dækker hjørner)
    _rh_sofitt_panel(x_left, x_right, -RH_OH_FRONT, 0, eh_back, palette);
    // Bag (dækker hjørner)
    _rh_sofitt_panel(x_left, x_right, ww, ww + RH_OH_BACK, eh_back, palette);
    // Venstre (mellem væglinjer)
    _rh_sofitt_panel(x_left, 0, 0, ww, eh_back, palette);
    // Højre
    _rh_sofitt_panel(ll, x_right, 0, ww, eh_back, palette);
}

// ============================================================================
// Helper — flad sloped slab parallelt med tagets underside, ved en
// vertikal offset over spær-top, med en given tykkelse og farve.
// Bruges til alle cover-lag (membran, OSB, tagpap, eternit, ...).
// ============================================================================
module _rh_roof_layer(eh_back, offset_z, thick, color_rgb) {
    ll = RH_LENGTH; ww = RH_WIDTH;
    drop_full = rh_total_drop_for(eh_back);
    roof_oz   = rh_roof_oz_for(eh_back);
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
