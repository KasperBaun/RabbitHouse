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

// Sternbræt-tykkelse (25×125 imprægneret gran). Bruges også af sternkapslen
// som topflange-bredde. Konstant her så fascia-kaldet og sternkapsel-modulet
// er enige om hvor sternbrædderne sidder.
STERN_T = 25;

// Sternkapsel cap-profil 35×25 mm i aluminium: glides over sternbræt-toppen
// + den oprullede tagpap-kant. 25 mm topflange matcher sternbræt-tykkelsen
// (25 mm); 35 mm drop hænger ned udvendigt forbi sternbrædet.
//
// Anvendes ved alle 4 eaves. Lige profil på horisontalt front/bag,
// skrå profil på sloped venstre/højre.
//
// Sternbræt-placering (efter at v3_tagkonstruktion kalder fascia med
// overhang_* + STERN_T): sternbrædderne sidder UDVENDIGT på spær-endefladerne.
//   • Front sternbræt outer face = Y = -V3_OH_FRONT - STERN_T,
//                       inner face = Y = -V3_OH_FRONT (spær-endeflade).
//   • Bag sternbræt   outer face = Y = ww + V3_OH_BACK + STERN_T.
//   • Venstre sternbræt outer face = X = -V3_OH_SIDE - STERN_T.
//   • Højre sternbræt   outer face = X = ll + V3_OH_SIDE + STERN_T.
//
//   sternbraet_top_offset = z-offset fra v3_roof_oz_for(eh_back) til
//                           sternbræt-toppen (= cover_thick + lip).
//                           Sternbræt-toppen sidder altid over cover-toppen
//                           med en lille kant (lip) på 7 mm.
module v3_sternkapsler(eh_back, sternbraet_top_offset, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH;
    drop_full = v3_total_drop_for(eh_back);
    roof_oz   = v3_roof_oz_for(eh_back);
    z_front = roof_oz + sternbraet_top_offset;                  // z @ y=-OH_FRONT
    z_back  = roof_oz - drop_full + sternbraet_top_offset;      // z @ y=ww+OH_BACK

    CAP_W    = STERN_T;     // 25 mm cap-bredde (matcher sternbræt-top)
    CAP_DROP = 35;          // 35 mm drop udvendigt
    CAP_T    = 2;           // alu-tykkelse

    // Sternbræt yder-flader (= cap topflange yder-kanter).
    y_front_outer = -V3_OH_FRONT - STERN_T;
    y_back_outer  = ww + V3_OH_BACK + STERN_T;
    x_left_outer  = -V3_OH_SIDE - STERN_T;
    x_right_outer = ll + V3_OH_SIDE + STERN_T;

    color(ALU_COLOR) {
        // FRONT eave — topflange ligger over sternbræt-top (Y= y_front_outer..-V3_OH_FRONT).
        // Strækker sig over hele front-sternbrættets X-spænd (inkl. de sidevendte
        // sternbrædders bredde) så hjørnerne er dækkede.
        translate([x_left_outer, y_front_outer, z_front])
            cube([x_right_outer - x_left_outer, STERN_T, CAP_T]);
        // Outer drop hænger udvendigt forbi sternbræt-front-fladen.
        translate([x_left_outer, y_front_outer - CAP_T, z_front - CAP_DROP])
            cube([x_right_outer - x_left_outer, CAP_T, CAP_DROP + CAP_T]);

        // BAG eave
        translate([x_left_outer, ww + V3_OH_BACK, z_back])
            cube([x_right_outer - x_left_outer, STERN_T, CAP_T]);
        translate([x_left_outer, y_back_outer, z_back - CAP_DROP])
            cube([x_right_outer - x_left_outer, CAP_T, CAP_DROP + CAP_T]);

        // VENSTRE side (skrå cap der følger tagets hældning).
        // Topflange dækker sternbræt-top i X=[x_left_outer, -V3_OH_SIDE].
        hull() {
            translate([x_left_outer, y_front_outer, z_front])
                cube([STERN_T, 0.01, CAP_T]);
            translate([x_left_outer, y_back_outer - 0.01, z_back])
                cube([STERN_T, 0.01, CAP_T]);
        }
        // Outer drop hænger udvendigt for venstre sternbræts yder-flade.
        hull() {
            translate([x_left_outer - CAP_T, y_front_outer, z_front - CAP_DROP])
                cube([CAP_T, 0.01, CAP_DROP + CAP_T]);
            translate([x_left_outer - CAP_T, y_back_outer - 0.01, z_back - CAP_DROP])
                cube([CAP_T, 0.01, CAP_DROP + CAP_T]);
        }

        // HØJRE side
        hull() {
            translate([ll + V3_OH_SIDE, y_front_outer, z_front])
                cube([STERN_T, 0.01, CAP_T]);
            translate([ll + V3_OH_SIDE, y_back_outer - 0.01, z_back])
                cube([STERN_T, 0.01, CAP_T]);
        }
        hull() {
            translate([x_right_outer, y_front_outer, z_front - CAP_DROP])
                cube([CAP_T, 0.01, CAP_DROP + CAP_T]);
            translate([x_right_outer, y_back_outer - 0.01, z_back - CAP_DROP])
                cube([CAP_T, 0.01, CAP_DROP + CAP_T]);
        }
    }
}

module v3_cover_tagpap_osb(eh_back, palette = DEFAULT_PALETTE) {
    v3_osb_daek(eh_back, palette);
    v3_underpap(eh_back, palette);
    v3_tagpap_overlag(eh_back, palette);
    // Sternkapsler kaldes fra v3_tagkonstruktion (de sidder på sternbræt-top,
    // ikke direkte på coveret).
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
    // Sternkapsler kaldes fra v3_tagkonstruktion.
}

// ============================================================================
// Top-level — vælger cover-system og tilføjer fælles sternbræt + tagrende.
// ============================================================================
module v3_tagkonstruktion(roof_cover = "tagpap_osb", palette = DEFAULT_PALETTE) {
    eh_back = v3_eh_back_for(roof_cover);

    v3_spaer(eh_back, palette);

    // Cover-tykkelse over spær — bruges til at løfte sternbræt + sternkapsel
    // op over cover-toppen med en lille kant.
    cover_thick =
          (roof_cover == "tagpap_osb" || roof_cover == "tagpap") ?
              OSB_T + UNDERPAP_T + TAGPAP_T
        : (roof_cover == "eternit_b7" || roof_cover == "eternit_10" || roof_cover == "eternit_14") ?
              UNDERTAG_T + AFSTANDS_T + LAGTE_T + ETERNIT_T
        : OSB_T + UNDERPAP_T + TAGPAP_T;
    STERN_LIP = 7;   // sternbræt-top stikker 7 mm over cover-top

    if (roof_cover == "tagpap_osb")          v3_cover_tagpap_osb(eh_back, palette);
    else if (roof_cover == "eternit_b7")     v3_cover_eternit_b7(eh_back, palette);
    else if (roof_cover == "tagpap")         v3_cover_tagpap_osb(eh_back, palette);  // legacy alias
    else if (roof_cover == "eternit_10"
          || roof_cover == "eternit_14")     v3_cover_eternit_b7(eh_back, palette);  // legacy alias
    else assert(false, str("unknown roof_cover: ", roof_cover));

    // Sternbræt 25×125 imprægneret gran. Toppen sidder cover_thick + STERN_LIP
    // (typisk 30 mm) over spær-top, dvs. ~7 mm over tagpap. Sternkapslen
    // glider derefter ned over toppen som beskyttelse.
    //
    // Sternbrædderne sidder UDVENDIGT på spær-endefladerne — dvs. de skal
    // ligge UDEN FOR det eave-spænd der svarer til spær-yder-positionerne
    // (X=-V3_OH_SIDE..ll+V3_OH_SIDE, Y=-V3_OH_FRONT..ww+V3_OH_BACK).
    // fascia_and_gutter_mono placerer brædderne PÅ INDERSIDEN af de overhangs
    // den får. Derfor passerer vi overhang_* + STERN_T, så bræddernes
    // INDER-flader lander præcist på spær-endefladerne.
    fascia_origin_z = v3_roof_oz_for(eh_back) + cover_thick + STERN_LIP;
    fascia_and_gutter_mono([0, 0, fascia_origin_z],
                           V3_LENGTH, V3_WIDTH, v3_total_drop_for(eh_back),
                           125, STERN_T,
                           V3_OH_FRONT + STERN_T,
                           V3_OH_BACK  + STERN_T,
                           V3_OH_SIDE  + STERN_T,
                           110, 65, V3_BASE_H, palette);

    // Sternkapsler (alu cap-profiler) ovenpå sternbræt-toppen.
    v3_sternkapsler(eh_back, cover_thick + STERN_LIP, palette);
}
