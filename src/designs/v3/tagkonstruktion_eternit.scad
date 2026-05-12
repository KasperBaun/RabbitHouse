// tagkonstruktion_eternit.scad — v3 tag: Cembrit/Swisspearl B7 bølgeplade.
//
// LAGSTAK (oppefra og ned):
//   • Swisspearl 100 Tagskruer       — 6×100 mm, 2 stk pr. plade
//   • B7 bølgeplade (sortblå)        — 1100×570 mm, 6,5 mm tyk, 65 mm bølge
//   • C18 taglægter 38×73            — c/c præcis 460 mm
//   • Spær 45×95                     — fra _faelles.scad
//
// PERIMETER:
//   • Sternbræt 25×125               — fra lib/primitives/roof.scad
//   • Tagrende på bag-sternbræt      — fra lib/primitives/roof.scad
//
// Per Swisspearl Montagevejledning Bølgeplader (rev. 02.2025):
//   • Plade-format:    1100 × 570 mm  (montagebredde 1022, montagehøjde 65)
//   • Lægte-dimension: 38×73 mm C18
//   • Lægteafstand:    PRÆCIS c/c 460 mm
//   • Min overlæg:     110 mm  (570 plade − 460 effektiv dækning)
//   • a-mål:           510 mm  (sternbræt yderkant → første lægte, ved tagfod)
//   • Tagrende:        bølgepladen hænger 60 mm ud over sternbræt-yderkant
//   • Skruer:          2 pr. plade i bølgetop ved øverste kant
//   • Min hældning:    14°  (v3's default 4,6° er IKKE buildbar; brug
//                      roof_cover = "eternit_14" for korrekt geometri)

include <../../lib/defaults.scad>
include <config.scad>
use <tagkonstruktion_faelles.scad>
use <../../lib/primitives/roof.scad>

// ============================================================================
// Lægter, plade og skrue-konstanter — alle fra Swisspearl B7 montagevejledning.
// ============================================================================
LAGTE_T   = 38;     // lægte-tykkelse (Z)
LAGTE_W   = 73;     // lægte-bredde (Y)
LAGTE_C2C = 460;    // præcis c/c per Cembrit B7 spec

B7_PLATE_LEN     = 570;       // langs slope (Y)
B7_PLATE_WIDTH   = 1100;      // langs eave (X) — bare til reference / BOM
B7_PITCH         = 172;       // bølge-pitch langs X
B7_AMP           = 65;        // montage-højde (peak-to-trough)
B7_THICK         = 6.5;       // plade-tykkelse
B7_OVERLAP       = 110;       // min overlæg mellem plader langs slope
B7_EAVE_OVERHANG = 60;        // bølgepladens drip over tagrenden
B7_A_MAAL        = 510;       // første lægte's afstand fra back-sternbræt yder

// Cembrit "Sortblå" — Cembrit B7 standard farve, dyb blå-sort som skifer.
B7_COLOR     = [0.10, 0.13, 0.18];

// Swisspearl 100 Tagskrue (6×100 mm, hærdet stål) m. EPDM-pakning.
// Visuel hoved-diameter inkl. EPDM ~20 mm — let synlig som mørk prik på bølgetop.
SCREW_HEAD_D = 20;
SCREW_HEAD_H = 6;
SCREW_COLOR  = [0.20, 0.21, 0.24];   // mørk grafit, lidt lysere end pladen

// ============================================================================
// C18 taglægter — placeret én pr. plade-top-kant. Bund-pladens nederste kant
// hænger 60 mm i tagrenden uden lægte; top-pladen ved front-eave skæres til
// pasning og bæres af næst-øverste lægte (kort overhang < 460 mm = OK).
//
// Resultat for v3: 6 lægter, c/c præcis 460 mm, første lægte 510 mm
// inde fra back-sternbræt yderkant.
// ============================================================================
module v3_laegter_eternit(eh_back, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH;
    x_start = -V3_OH_SIDE;
    x_end   = ll + V3_OH_SIDE;

    y_back_eave  = V3_WIDTH + V3_OH_BACK + V3_STERN_T;
    y_front_eave = -V3_OH_FRONT - V3_STERN_T;
    y_first_laegte = y_back_eave - B7_A_MAAL;

    n_intervals = floor((y_first_laegte - y_front_eave) / LAGTE_C2C);

    color(pal_post(palette))
    for (i = [0 : n_intervals]) {
        y_i = y_first_laegte - i * LAGTE_C2C;
        z   = v3_roof_under_for(eh_back, y_i);   // spær-top = lægte-bund
        translate([x_start, y_i - LAGTE_W/2, z])
            cube([x_end - x_start, LAGTE_W, LAGTE_T]);
    }
}

// ============================================================================
// B7 bølgeplade — modelleret som SEPARATE plade-rækker med synlige overlæg.
//
// Hver plade-række er 570 mm langs slope. Plade N+1 (højere på tag) sidder
// ovenpå plade N i overlap-zonen (=110 mm), så plade N+1's bund-110 mm
// ligger 6,5 mm (=plate-tykkelse) højere end plade N's top-110 mm. Dette
// giver SYNLIGE row-edges på taget — den visuelle signatur for B7-install.
//
// Hver plade (undtagen den nederste og top-cut) renderes som TO strips:
//   • Top-portion (460 mm) hviler på egen lægte (=z_offset=0)
//   • Bund-portion (110 mm) hviler på pladen nedenfor (=z_offset=B7_THICK)
// Transition mellem de to portioner er ved næste lægte's Y-position; det
// giver en lille "kink" + selve plade-kanten i overlap-zonen.
// ============================================================================

// Helper — renderer én corrugated strip fra y_start til y_end med trough z
// = lægte-top z (ved y_start) plus en eventuel z_offset (=B7_THICK når
// strippen ligger i overlap-zonen ovenpå pladen nedenfor).
module _v3_b7_strip(eh_back, y_start, y_end, z_offset) {
    if (y_end > y_start) {
        ll        = V3_LENGTH;
        drop_full = v3_total_drop_for(eh_back);
        span_y    = V3_WIDTH + V3_OH_FRONT + V3_OH_BACK;
        strip_len = y_end - y_start;

        x_start    = -V3_OH_SIDE;
        x_end      = ll + V3_OH_SIDE;
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

        z_base = v3_roof_under_for(eh_back, y_start) + LAGTE_T + z_offset;

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

module v3_eternit_b7(eh_back, palette = DEFAULT_PALETTE) {
    y_back_eave    = V3_WIDTH + V3_OH_BACK + V3_STERN_T;
    y_front_eave   = -V3_OH_FRONT - V3_STERN_T;
    y_first_laegte = y_back_eave - B7_A_MAAL;
    n_intervals    = floor((y_first_laegte - y_front_eave) / LAGTE_C2C);

    // Plade-rækker fra BOTTOM (tagfod = back) til TOP (front-eave).
    // Plade 1 (bund, ved tagrenden) — entire plate på slope_z (ingen plade
    // nedenfor at overlappe med). Hænger 60 mm forbi back-sternbræt yderkant.
    y_p1_top = y_first_laegte;
    y_p1_bot = y_back_eave + B7_EAVE_OVERHANG;   // = 2705 + 60 = 2765
    _v3_b7_strip(eh_back, y_p1_top, y_p1_bot, 0);

    // Plader 2 .. (n_intervals+1) — hver med top-portion på slope_z og
    // bund-portion (=overlap med pladen nedenfor) på slope_z + B7_THICK.
    for (i = [1 : n_intervals]) {
        y_top  = y_first_laegte - i * LAGTE_C2C;
        y_kink = y_top + LAGTE_C2C;                      // = top + 460 = næste lægte
        y_bot  = y_top + B7_PLATE_LEN;                   // = top + 570
        _v3_b7_strip(eh_back, y_top,  y_kink, 0);        // top-portion på egen lægte
        _v3_b7_strip(eh_back, y_kink, y_bot,  B7_THICK); // bund-portion på plade nedenfor
    }

    // Top-cut plade ved front-eave. Skæres til pasning; entire stykke i
    // overlap med plade nedenfor (= ligger 6,5 mm højere end plade 6).
    y_last_laegte = y_first_laegte - n_intervals * LAGTE_C2C;
    y_cut_top     = y_front_eave;
    y_cut_bot     = y_last_laegte + B7_OVERLAP;
    _v3_b7_strip(eh_back, y_cut_top, y_cut_bot, B7_THICK);
}

// ============================================================================
// Swisspearl 100 Tagskruer — 6×100 mm hærdet stål m. EPDM-pakning.
// Per spec: 2 stk pr. plade i bølgetop. I vores model: hver anden bølgetop
// pr. lægte = visuelt regelmæssigt mønster matchende realistic skrue-placering.
// ============================================================================
module v3_skruer(eh_back, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH;
    x_start = -V3_OH_SIDE;
    x_end   = ll + V3_OH_SIDE;

    y_back_eave  = V3_WIDTH + V3_OH_BACK + V3_STERN_T;
    y_front_eave = -V3_OH_FRONT - V3_STERN_T;
    y_first_laegte = y_back_eave - B7_A_MAAL;
    n_intervals = floor((y_first_laegte - y_front_eave) / LAGTE_C2C);

    n_crests = floor((x_end - x_start) / B7_PITCH);

    color(SCREW_COLOR)
    for (i = [0 : n_intervals]) {
        y_i = y_first_laegte - i * LAGTE_C2C;
        // Skruerne går igennem BOTH plader i overlap-zonen (= plade ovenfor +
        // plade nedenfor + ind i lægten). Hovedet sidder på TOP-pladen, der
        // ligger B7_THICK over lægte-top pga. overlap-kick-up.
        z_top = v3_roof_under_for(eh_back, y_i) + LAGTE_T + 2*B7_THICK + B7_AMP;
        for (j = [0 : 2 : n_crests]) {
            x_j = x_start + j * B7_PITCH;
            translate([x_j, y_i, z_top])
                cylinder(d = SCREW_HEAD_D, h = SCREW_HEAD_H, $fn = 14);
        }
    }
}

// ============================================================================
// Top-level — eternit B7 variant.
//
// Toggles:
//   show_cover  — lægter + B7 plader + skruer. false → bare spær+lookouts.
//   show_finish — sternbræt + tagrende.
// ============================================================================
module v3_tagkonstruktion_eternit(roof_cover  = "eternit_b7",
                                  show_cover  = true,
                                  show_finish = true,
                                  palette     = DEFAULT_PALETTE) {
    eh_back = v3_eh_back_for(roof_cover);

    // Bærende træværk — altid synligt.
    v3_spaer(eh_back, palette);
    v3_lookouts(eh_back, palette);

    // Cover-stak: lægter → B7 plader → skruer.
    if (show_cover) {
        v3_laegter_eternit(eh_back, palette);
        v3_eternit_b7(eh_back, palette);
        v3_skruer(eh_back, palette);
    }

    // Sternbræt + tagrende. Sternbræt-top placeres så den ligger LIGE UNDER
    // eternit-trough (= lægte-top) — det giver eternit-pladen frit drip past
    // sternbrættet ned i tagrenden ved bag-eaven. Lige under = ~lægte-top
    // minus en lille clearance, så sternbræt-bunden stadig dækker spær-enden.
    if (show_finish) {
        // STERN_OFFSET = LAGTE_T - clearance. Clearance på 8 mm vælges så
        // sternbræt-toppen ligger under eternit-trough også ved bag (hvor
        // slope-drop på 25 mm V3_STERN_T-spændet flytter trough ned).
        STERN_OFFSET = LAGTE_T - 8;
        fascia_origin_z = v3_roof_oz_for(eh_back) + STERN_OFFSET;
        fascia_and_gutter_mono([0, 0, fascia_origin_z],
                               V3_LENGTH, V3_WIDTH, v3_total_drop_for(eh_back),
                               125, V3_STERN_T,
                               V3_OH_FRONT + V3_STERN_T,
                               V3_OH_BACK  + V3_STERN_T,
                               V3_OH_SIDE  + V3_STERN_T,
                               110, 65, V3_BASE_H, palette);
    }
}
