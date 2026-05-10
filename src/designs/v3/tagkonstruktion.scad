// tagkonstruktion.scad — v3 roof: spær + cover-system + sternbræt + tagrende.
//
// To cover-systemer kan vælges via `roof_cover` (sat i build.scad):
//
//   "tagpap_osb"  — 18 mm OSB plader + 3 mm underpap + 4 mm tagpap +
//                   2 mm aluinddækning. Min hældning 2,5°. Passer til
//                   v3's 4,6° (8 % fald). DETTE ER DEFAULT.
//
//   "eternit_b7"  — 1 mm undertag + 25×50 afstandsliste på hver spær +
//                   38×73 lægter c/c 500 mm + 8 mm Cembrit B7 bølgeplade.
//                   Min hældning 10° (extended overlap) eller 14° (standard).
//                   v3's 4,6° er FOR FLAT — vises kun til layout-sammenligning.

include <../../lib/defaults.scad>
include <config.scad>
use <../../lib/primitives/roof.scad>
use <../../lib/primitives/beslag.scad>

// ============================================================================
// Spær — bærende lag, samme uanset cover.
// V3_SPAER_W/H/C2C kommer fra config.scad. Spær-bunden flugter med
// toprem-toppen (= v3_roof_under_for - V3_SPAER_H), spær-toppen er på
// roof underside (= cover bund). Spær spænder fra front-eave til bag-eave.
// Hvor spær krydser V1+V2 toprem er det bird's-mouth (CSG-overlap).
// ============================================================================
SPAER_W   = V3_SPAER_W;
SPAER_H   = V3_SPAER_H;
SPAER_C2C = V3_SPAER_C2C;
module v3_spaer(eh_back, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH;
    sd = 95;  // wall depth (matcher konstruktions-skelet's STUD_DEPTH)

    y_start = -V3_OH_FRONT;
    y_end   = ww + V3_OH_BACK;
    z_start = v3_roof_under_for(eh_back, y_start) - SPAER_H;
    z_end   = v3_roof_under_for(eh_back, y_end)   - SPAER_H;

    // Bracket-konstanter (vinkelbeslag på hver side af spæret ved V1 og V2)
    z_v1_top = V3_BASE_H + V3_EH_FRONT;     // 2520
    z_v2_top = V3_BASE_H + V3_EH_BACK;      // 2320
    y_brk_f  = sd / 2;                      // 47.5 — V1 bearing midte
    y_brk_b  = ww - sd / 2;                 // 2452.5 — V2 bearing midte
    BRK_W    = 50; BRK_LEG = 90; BRK_T = 2;

    // Spær-X-positioner. V1+V2 toprem er forlænget V3_OH_SIDE i hver ende
    // (i konstruktions-skelet.scad), så barge raftren bærer direkte på den
    // forlængede toprem — præcis som de regulære spær. Ingen lookouts behøves.
    //
    //   Barge venstre (X=-220) — bracket kun på +X side (yderside er i luften)
    //   Gable V3       (X=0)    — 2 brackets, plus hviler på V3 toprem
    //   Indre regulære (X=600, 1200, ..., 5400) — 2 brackets pr. bearing
    //   Gable V4       (X=5955) — 2 brackets, plus hviler på V4 toprem
    //   Barge højre    (X=6175) — bracket kun på -X side
    spaer_xs = concat(
        [-V3_OH_SIDE],                          // venstre barge
        [for (i = [0 : 9]) i * SPAER_C2C],      // 0, 600, ..., 5400
        [ll - SPAER_W],                          // V4 gable
        [ll + V3_OH_SIDE - SPAER_W]              // højre barge
    );
    n_spaer = len(spaer_xs);

    for (i = [0 : n_spaer-1]) {
        x = spaer_xs[i];
        is_left_barge  = (i == 0);
        is_right_barge = (i == n_spaer - 1);

        color(pal_post(palette))
        hull() {
            translate([x, y_start, z_start])
                cube([SPAER_W, 0.01, SPAER_H]);
            translate([x, y_end - 0.01, z_end])
                cube([SPAER_W, 0.01, SPAER_H]);
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
            vinkelbeslag([x + SPAER_W, y_brk_f - BRK_W/2, z_v1_top],
                         leg=BRK_LEG, thick=BRK_T, width=BRK_W, orientation="+x+z");
            vinkelbeslag([x + SPAER_W, y_brk_b - BRK_W/2, z_v2_top],
                         leg=BRK_LEG, thick=BRK_T, width=BRK_W, orientation="+x+z");
        }
    }
}

// ============================================================================
// Helper — flad sloped slab parallelt med tagets underside, ved en
// vertikal offset over spær-top, med en given tykkelse og farve.
// Bruges til alle cover-lag (membran, OSB, tagpap, eternit, ...).
// ============================================================================
module _v3_roof_layer(eh_back, offset_z, thick, color_rgb) {
    ll = V3_LENGTH; ww = V3_WIDTH;
    drop_full = v3_total_drop_for(eh_back);
    roof_oz   = v3_roof_oz_for(eh_back);
    color(color_rgb)
    polyhedron(
        points = [
            [-V3_OH_SIDE, -V3_OH_FRONT,           roof_oz + offset_z],
            [ll + V3_OH_SIDE, -V3_OH_FRONT,       roof_oz + offset_z],
            [ll + V3_OH_SIDE, ww + V3_OH_BACK,    roof_oz - drop_full + offset_z],
            [-V3_OH_SIDE, ww + V3_OH_BACK,        roof_oz - drop_full + offset_z],
            [-V3_OH_SIDE, -V3_OH_FRONT,           roof_oz + offset_z + thick],
            [ll + V3_OH_SIDE, -V3_OH_FRONT,       roof_oz + offset_z + thick],
            [ll + V3_OH_SIDE, ww + V3_OH_BACK,    roof_oz - drop_full + offset_z + thick],
            [-V3_OH_SIDE, ww + V3_OH_BACK,        roof_oz - drop_full + offset_z + thick]
        ],
        faces = [[0,1,2,3], [4,7,6,5], [0,4,5,1], [1,5,6,2], [2,6,7,3], [3,7,4,0]]
    );
}

// ============================================================================
// COVER A — tagpap_osb
// Lag-stak fra spær-top og opefter:
//   0..18 mm    OSB plader (bærer hele coveret, sømmes på spær)
//   18..21 mm   Underpap (mekanisk fastgjort til OSB)
//   21..25 mm   Tagpap (svejset til underpap)
//   + 2 mm aluinddækning ved tagskæg (front+bag)
// Total cover-tykkelse ~25 mm (over spær-top).
// ============================================================================

OSB_T      = 18;
UNDERPAP_T = 3;
TAGPAP_T   = 4;

OSB_COLOR      = [0.78, 0.66, 0.42];
UNDERPAP_COLOR = [0.18, 0.16, 0.14];
TAGPAP_COLOR   = [0.08, 0.08, 0.08];
ALU_COLOR      = [0.78, 0.78, 0.80];

module v3_osb_daek(eh_back, palette = DEFAULT_PALETTE) {
    _v3_roof_layer(eh_back, 0, OSB_T, OSB_COLOR);
}

module v3_underpap(eh_back, palette = DEFAULT_PALETTE) {
    _v3_roof_layer(eh_back, OSB_T, UNDERPAP_T, UNDERPAP_COLOR);
}

module v3_tagpap_overlag(eh_back, palette = DEFAULT_PALETTE) {
    _v3_roof_layer(eh_back, OSB_T + UNDERPAP_T, TAGPAP_T, TAGPAP_COLOR);
}

// Aluinddækning ved tagskæg: L-profil 2 mm, 80 mm topflange + 60 mm dryp-kant.
// Anvendes ved alle 4 eaves (front, bag, venstre, højre). cover_top_offset
// er vertikal afstand fra spær-top (= roof_oz) til toppen af det vandtætte
// dækningslag — for tagpap_osb 25 mm, for eternit_b7 72 mm.
module v3_aluinddaekning(eh_back, cover_top_offset, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH;
    drop_full = v3_total_drop_for(eh_back);
    roof_oz   = v3_roof_oz_for(eh_back);
    z_front_eave = roof_oz + cover_top_offset;                  // z @ y=-OH_FRONT
    z_back_eave  = roof_oz - drop_full + cover_top_offset;      // z @ y=ww+OH_BACK
    ALU_T = 2; FACE_H = 60; TOP_W = 80;

    color(ALU_COLOR) {
        // FRONT eave (y=-V3_OH_FRONT) — flat (alu profil ligger vandret langs X)
        translate([-V3_OH_SIDE, -V3_OH_FRONT, z_front_eave])
            cube([ll + 2*V3_OH_SIDE, TOP_W, ALU_T]);
        translate([-V3_OH_SIDE, -V3_OH_FRONT - ALU_T, z_front_eave - FACE_H])
            cube([ll + 2*V3_OH_SIDE, ALU_T, FACE_H + ALU_T]);

        // BAG eave (y=ww+V3_OH_BACK) — flat (alu profil ligger vandret langs X)
        translate([-V3_OH_SIDE, ww + V3_OH_BACK - TOP_W, z_back_eave])
            cube([ll + 2*V3_OH_SIDE, TOP_W, ALU_T]);
        translate([-V3_OH_SIDE, ww + V3_OH_BACK, z_back_eave - FACE_H])
            cube([ll + 2*V3_OH_SIDE, ALU_T, FACE_H + ALU_T]);

        // VENSTRE side (x=-V3_OH_SIDE) — sloper med taget (z_front_eave→z_back_eave)
        // Topflange (vandret bredde TOP_W langs +X)
        hull() {
            translate([-V3_OH_SIDE, -V3_OH_FRONT, z_front_eave])
                cube([TOP_W, 0.01, ALU_T]);
            translate([-V3_OH_SIDE, ww + V3_OH_BACK - 0.01, z_back_eave])
                cube([TOP_W, 0.01, ALU_T]);
        }
        // Dryp-kant (vertikal flange hænger nedad ved x=-V3_OH_SIDE)
        hull() {
            translate([-V3_OH_SIDE - ALU_T, -V3_OH_FRONT, z_front_eave - FACE_H])
                cube([ALU_T, 0.01, FACE_H + ALU_T]);
            translate([-V3_OH_SIDE - ALU_T, ww + V3_OH_BACK - 0.01, z_back_eave - FACE_H])
                cube([ALU_T, 0.01, FACE_H + ALU_T]);
        }

        // HØJRE side (x=ll+V3_OH_SIDE) — sloper med taget
        // Topflange
        hull() {
            translate([ll + V3_OH_SIDE - TOP_W, -V3_OH_FRONT, z_front_eave])
                cube([TOP_W, 0.01, ALU_T]);
            translate([ll + V3_OH_SIDE - TOP_W, ww + V3_OH_BACK - 0.01, z_back_eave])
                cube([TOP_W, 0.01, ALU_T]);
        }
        // Dryp-kant
        hull() {
            translate([ll + V3_OH_SIDE, -V3_OH_FRONT, z_front_eave - FACE_H])
                cube([ALU_T, 0.01, FACE_H + ALU_T]);
            translate([ll + V3_OH_SIDE, ww + V3_OH_BACK - 0.01, z_back_eave - FACE_H])
                cube([ALU_T, 0.01, FACE_H + ALU_T]);
        }
    }
}

module v3_cover_tagpap_osb(eh_back, palette = DEFAULT_PALETTE) {
    v3_osb_daek(eh_back, palette);
    v3_underpap(eh_back, palette);
    v3_tagpap_overlag(eh_back, palette);
    v3_aluinddaekning(eh_back, OSB_T + UNDERPAP_T + TAGPAP_T, palette);
}

// ============================================================================
// COVER B — eternit_b7
// Lag-stak fra spær-top og opefter:
//   0..1 mm     Undertag-membran (vapor-permeable, lagt over spær)
//   1..26 mm    Afstandsliste 25×50 langs hver spær (skaber luftspalte)
//   26..64 mm   Lægter 38×73 perpendikulært på spær (langs X), c/c 500 mm
//   64..72 mm   Cembrit B7 bølgeplade 8 mm
// Total cover-tykkelse ~72 mm.
// ============================================================================

UNDERTAG_T     = 1;
AFSTANDS_T     = 25;     // højde over undertag
AFSTANDS_W     = 50;     // bredde langs X (samme som spær, men kun 50 mm)
LAGTE_T        = 38;     // højde
LAGTE_W        = 73;     // bredde langs Y
LAGTE_C2C      = 500;    // c/c langs Y (B7 plate-overlap-tilpasset)
ETERNIT_T      = 8;      // Cembrit B7 plade-tykkelse

UNDERTAG_COLOR = [0.40, 0.40, 0.42];
ETERNIT_COLOR  = [0.85, 0.85, 0.83];

module v3_undertag(eh_back, palette = DEFAULT_PALETTE) {
    _v3_roof_layer(eh_back, 0, UNDERTAG_T, UNDERTAG_COLOR);
}

// Afstandslister: små 25×50 langs hver spær, oven på undertag.
// Sloper med taget. Bredden 50 ligger inden for spær-bredden 45 + 5 mm.
module v3_afstandsliste(eh_back, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH;
    y_start = -V3_OH_FRONT; y_end = ww + V3_OH_BACK;
    z_start = v3_roof_under_for(eh_back, y_start) + UNDERTAG_T;
    z_end   = v3_roof_under_for(eh_back, y_end)   + UNDERTAG_T;

    n = floor((ll - 2 * 100) / SPAER_C2C) + 1;
    color(pal_post(palette))
    for (i = [0 : n-1]) {
        x = 100 + i * SPAER_C2C - 2.5;  // centreret over 45 mm spær
        hull() {
            translate([x, y_start, z_start])
                cube([AFSTANDS_W, 0.01, AFSTANDS_T]);
            translate([x, y_end - 0.01, z_end])
                cube([AFSTANDS_W, 0.01, AFSTANDS_T]);
        }
    }
}

// Lægter: 38×73 perpendikulært på spær, langs X på tværs af hele tagfladen.
// Hælder med taget — z varierer langs Y. Spacing langs Y = LAGTE_C2C.
module v3_laegter_eternit(eh_back, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH;
    drop_full = v3_total_drop_for(eh_back);
    roof_oz   = v3_roof_oz_for(eh_back);
    span_y    = ww + V3_OH_FRONT + V3_OH_BACK;
    z_offset  = UNDERTAG_T + AFSTANDS_T;  // 26 mm over spær-top

    n = floor(span_y / LAGTE_C2C) + 1;
    color(pal_post(palette))
    for (i = [0 : n-1]) {
        y = -V3_OH_FRONT + i * LAGTE_C2C;
        // z på tagets underside ved denne y, plus offset
        z = roof_oz - (V3_OH_FRONT + y) * drop_full / span_y + z_offset;
        translate([-V3_OH_SIDE, y - LAGTE_W/2, z])
            cube([ll + 2*V3_OH_SIDE, LAGTE_W, LAGTE_T]);
    }
}

module v3_eternit_b7(eh_back, palette = DEFAULT_PALETTE) {
    _v3_roof_layer(eh_back,
                   UNDERTAG_T + AFSTANDS_T + LAGTE_T,   // 64 mm
                   ETERNIT_T,                            // 8 mm
                   ETERNIT_COLOR);
}

module v3_cover_eternit_b7(eh_back, palette = DEFAULT_PALETTE) {
    v3_undertag(eh_back, palette);
    v3_afstandsliste(eh_back, palette);
    v3_laegter_eternit(eh_back, palette);
    v3_eternit_b7(eh_back, palette);
    v3_aluinddaekning(eh_back,
                      UNDERTAG_T + AFSTANDS_T + LAGTE_T + ETERNIT_T,
                      palette);
}

// ============================================================================
// Top-level — vælger cover-system og tilføjer fælles sternbræt + tagrende.
// ============================================================================
module v3_tagkonstruktion(roof_cover = "tagpap_osb", palette = DEFAULT_PALETTE) {
    eh_back = v3_eh_back_for(roof_cover);

    v3_spaer(eh_back, palette);

    if (roof_cover == "tagpap_osb")          v3_cover_tagpap_osb(eh_back, palette);
    else if (roof_cover == "eternit_b7")     v3_cover_eternit_b7(eh_back, palette);
    else if (roof_cover == "tagpap")         v3_cover_tagpap_osb(eh_back, palette);  // legacy alias
    else if (roof_cover == "eternit_10"
          || roof_cover == "eternit_14")     v3_cover_eternit_b7(eh_back, palette);  // legacy alias
    else assert(false, str("unknown roof_cover: ", roof_cover));

    // Sternbræt + tagrende — samme på begge cover-systemer.
    fascia_and_gutter_mono([0, 0, v3_roof_oz_for(eh_back)],
                           V3_LENGTH, V3_WIDTH, v3_total_drop_for(eh_back),
                           150, 22, V3_OH_FRONT, V3_OH_BACK, V3_OH_SIDE,
                           110, 65, V3_BASE_H, palette);
}
