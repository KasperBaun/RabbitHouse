// tagkonstruktion_tagpap.scad — v3 tag: tagpap_osb cover + sternkapsler.
//
// Cover-stak fra spær-top og opefter:
//   0..18 mm    OSB plader (bærer hele coveret, sømmes på spær)
//   18..21 mm   Underpap (mekanisk fastgjort til OSB)
//   21..25 mm   Tagpap (svejset til underpap)
//   + 2 mm aluinddækning (sternkapsler) på alle 4 eaves.
// Total cover-tykkelse ~25 mm (over spær-top). Min hældning 2,5°. Passer
// til v3's 4,6° (8 % fald). DETTE ER DEFAULT-coveret.
//
// Bærende træværk (rh_spaer, rh_lookouts, rh_sofitt) og det fælles
// _rh_roof_layer-helper kommer fra tagkonstruktion_faelles.scad.

include <../lib/defaults.scad>
include <config.scad>
use <tagkonstruktion_faelles.scad>
use <../lib/primitives/roof.scad>

// ============================================================================
// Cover-lag konstanter — kun tagpap_osb.
// ============================================================================
OSB_T      = 18;
UNDERPAP_T = 3;
TAGPAP_T   = 4;

OSB_COLOR      = [0.78, 0.66, 0.42];
UNDERPAP_COLOR = [0.18, 0.16, 0.14];
TAGPAP_COLOR   = [0.08, 0.08, 0.08];
ALU_COLOR      = [0.78, 0.78, 0.80];

module rh_osb_daek(eh_back, palette = DEFAULT_PALETTE) {
    _rh_roof_layer(eh_back, 0, OSB_T, OSB_COLOR);
}

module rh_underpap(eh_back, palette = DEFAULT_PALETTE) {
    _rh_roof_layer(eh_back, OSB_T, UNDERPAP_T, UNDERPAP_COLOR);
}

module rh_tagpap_overlag(eh_back, palette = DEFAULT_PALETTE) {
    _rh_roof_layer(eh_back, OSB_T + UNDERPAP_T, TAGPAP_T, TAGPAP_COLOR);
}

// Sternkapsel cap-profil 35×25 mm i aluminium: glides over sternbræt-toppen
// + den oprullede tagpap-kant. 25 mm topflange matcher sternbræt-tykkelsen
// (RH_STERN_T = 25); 35 mm drop hænger ned udvendigt forbi sternbrædet.
//
// Anvendes ved alle 4 eaves. Lige profil på horisontalt front/bag,
// skrå profil på sloped venstre/højre.
//
// Sternbræt-placering (efter at rh_tagkonstruktion_tagpap kalder fascia med
// overhang_* + RH_STERN_T): sternbrædderne sidder UDVENDIGT på spær-endefladerne.
//   • Front sternbræt outer face = Y = -RH_OH_FRONT - RH_STERN_T,
//                       inner face = Y = -RH_OH_FRONT (spær-endeflade).
//   • Bag sternbræt   outer face = Y = ww + RH_OH_BACK + RH_STERN_T.
//   • Venstre sternbræt outer face = X = -RH_OH_SIDE - RH_STERN_T.
//   • Højre sternbræt   outer face = X = ll + RH_OH_SIDE + RH_STERN_T.
//
//   sternbraet_top_offset = z-offset fra rh_roof_oz_for(eh_back) til
//                           sternbræt-toppen (= cover_thick + lip).
//                           Sternbræt-toppen sidder altid over cover-toppen
//                           med en lille kant (lip) på 7 mm.
module rh_sternkapsler(eh_back, sternbraet_top_offset, palette = DEFAULT_PALETTE) {
    ll = RH_LENGTH; ww = RH_WIDTH;
    drop_full = rh_total_drop_for(eh_back);
    roof_oz   = rh_roof_oz_for(eh_back);
    z_front = roof_oz + sternbraet_top_offset;                  // z @ y=-OH_FRONT
    z_back  = roof_oz - drop_full + sternbraet_top_offset;      // z @ y=ww+OH_BACK

    CAP_W    = RH_STERN_T;  // 25 mm cap-bredde (matcher sternbræt-top)
    CAP_DROP = 35;          // 35 mm drop udvendigt
    CAP_T    = 2;           // alu-tykkelse

    // Sternbræt yder-flader (= cap topflange yder-kanter).
    y_front_outer = -RH_OH_FRONT - RH_STERN_T;
    y_back_outer  = ww + RH_OH_BACK + RH_STERN_T;
    x_left_outer  = -RH_OH_SIDE - RH_STERN_T;
    x_right_outer = ll + RH_OH_SIDE + RH_STERN_T;

    color(ALU_COLOR) {
        // FRONT eave — topflange ligger over sternbræt-top (Y= y_front_outer..-RH_OH_FRONT).
        // Strækker sig over hele front-sternbrættets X-spænd (inkl. de sidevendte
        // sternbrædders bredde) så hjørnerne er dækkede.
        translate([x_left_outer, y_front_outer, z_front])
            cube([x_right_outer - x_left_outer, RH_STERN_T, CAP_T]);
        // Outer drop hænger udvendigt forbi sternbræt-front-fladen.
        translate([x_left_outer, y_front_outer - CAP_T, z_front - CAP_DROP])
            cube([x_right_outer - x_left_outer, CAP_T, CAP_DROP + CAP_T]);

        // BAG eave
        translate([x_left_outer, ww + RH_OH_BACK, z_back])
            cube([x_right_outer - x_left_outer, RH_STERN_T, CAP_T]);
        translate([x_left_outer, y_back_outer, z_back - CAP_DROP])
            cube([x_right_outer - x_left_outer, CAP_T, CAP_DROP + CAP_T]);

        // VENSTRE side (skrå cap der følger tagets hældning).
        // Topflange dækker sternbræt-top i X=[x_left_outer, -RH_OH_SIDE].
        hull() {
            translate([x_left_outer, y_front_outer, z_front])
                cube([RH_STERN_T, 0.01, CAP_T]);
            translate([x_left_outer, y_back_outer - 0.01, z_back])
                cube([RH_STERN_T, 0.01, CAP_T]);
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
            translate([ll + RH_OH_SIDE, y_front_outer, z_front])
                cube([RH_STERN_T, 0.01, CAP_T]);
            translate([ll + RH_OH_SIDE, y_back_outer - 0.01, z_back])
                cube([RH_STERN_T, 0.01, CAP_T]);
        }
        hull() {
            translate([x_right_outer, y_front_outer, z_front - CAP_DROP])
                cube([CAP_T, 0.01, CAP_DROP + CAP_T]);
            translate([x_right_outer, y_back_outer - 0.01, z_back - CAP_DROP])
                cube([CAP_T, 0.01, CAP_DROP + CAP_T]);
        }
    }
}

module rh_cover_tagpap_osb(eh_back, palette = DEFAULT_PALETTE) {
    rh_osb_daek(eh_back, palette);
    rh_underpap(eh_back, palette);
    rh_tagpap_overlag(eh_back, palette);
    // Sternkapsler kaldes fra rh_tagkonstruktion_tagpap (de sidder på sternbræt-top,
    // ikke direkte på coveret).
}

// ============================================================================
// Top-level — tagpap-variant. Bærende træværk + cover-lag + sternbræt + tagrende
// + alu-sternkapsler.
//
// Toggles:
//   show_cover  — OSB + underpap + tagpap (cover-lag). false → bare spær+lookouts.
//   show_finish — sternbræt + sternkapsel + sofitt (visuel finish/trim).
//                 false → ingen trim, så framing kan inspiceres rent.
// ============================================================================
module rh_tagkonstruktion_tagpap(show_cover  = true,
                                 show_finish = true,
                                 palette     = DEFAULT_PALETTE) {
    eh_back = RH_EH_BACK;   // tagpap kører på default-hældning (4,6°).

    // Bærende træværk — altid synligt.
    rh_spaer(eh_back, palette);
    rh_lookouts(eh_back, palette);

    // Cover-tykkelse over spær — bruges til at løfte sternbræt + sternkapsel
    // op over cover-toppen med en lille kant.
    cover_thick = OSB_T + UNDERPAP_T + TAGPAP_T;
    STERN_LIP = 7;   // sternbræt-top stikker 7 mm over cover-top

    if (show_cover) rh_cover_tagpap_osb(eh_back, palette);

    // Visuel finish: sternbræt + sternkapsel + sofitt. Toggles sammen
    // med cladding via show_finish — så show_cladding=false skjuler
    // alle trim-stykker, og framing kan inspiceres rent.
    if (show_finish) {
        // Sternbræt 25×125 imprægneret gran. Toppen sidder cover_thick +
        // STERN_LIP (typisk 30 mm) over spær-top, dvs. ~7 mm over tagpap.
        // Sternkapslen glider derefter ned over toppen som beskyttelse.
        //
        // Sternbrædderne sidder UDVENDIGT på spær-endefladerne — dvs. de
        // skal ligge UDEN FOR det eave-spænd der svarer til spær-yder-
        // positionerne (X=-RH_OH_SIDE..ll+RH_OH_SIDE, Y=-RH_OH_FRONT..
        // ww+RH_OH_BACK). fascia_and_gutter_mono placerer brædderne PÅ
        // INDERSIDEN af de overhangs den får. Derfor passerer vi
        // overhang_* + RH_STERN_T, så bræddernes INDER-flader lander præcist
        // på spær-endefladerne.
        fascia_origin_z = rh_roof_oz_for(eh_back) + cover_thick + STERN_LIP;
        fascia_and_gutter_mono([0, 0, fascia_origin_z],
                               RH_LENGTH, RH_WIDTH, rh_total_drop_for(eh_back),
                               125, RH_STERN_T,
                               RH_OH_FRONT + RH_STERN_T,
                               RH_OH_BACK  + RH_STERN_T,
                               RH_OH_SIDE  + RH_STERN_T,
                               110, 65, RH_BASE_H, palette);

        // Sternkapsler (alu cap-profiler) ovenpå sternbræt-toppen.
        rh_sternkapsler(eh_back, cover_thick + STERN_LIP, palette);

        // Sofitt — lukker tagskæg-undersiden på alle 4 sider.
        rh_sofitt(eh_back, palette);
    }
}
