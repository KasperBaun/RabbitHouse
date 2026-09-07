// Skifer cover on the gable roof (cover == "skifer") — genbrugs-naturskifer
// 30×60 cm i dobbelt dækning (guide-naturskifertag.md). Stack from rafter
// top upward:
//   0..3   mm  diffusion-open underlay (banevare, OK from 25°; pitch is 35°)
//   3..28  mm  25×50 afstandslister along each spær (drainage gap, §4.1B)
//   28..66 mm  38×73 T1 taglægter parallel to the ridge
//   66..74 mm  slate courses (~8 mm visual thickness)
//
// Sten 30×60 i halv-forbandt. Lægter, rækkelinjer og skiferforkant følger
// sætteplanen i docs/arbejdsplan/skiffertag/04-laegter.md (SK_LAEGTE_TOP /
// SK_COURSE_TAIL nedenfor), så renderet kan bruges som kontrol af planen.
// Begynderrækken er ikke modelleret — den er skjult i den færdige flade.

include <../lib/defaults.scad>
include <config.scad>

SK_UNDERLAY_T   = 3;
SK_CBATTEN_T    = 25;           // afstandsliste 25×50 (thickness above underlay)
SK_CBATTEN_W    = 50;           // afstandsliste width along Y (over each spær)
SK_BATTEN_T     = 38;           // taglægte T1 38×73
SK_BATTEN_W     = 73;
SK_PLATE_L      = 600;          // stone length up the slope
SK_PLATE_W      = 300;          // stone width along the ridge (Y)
// ---- Sætteplan. Én kilde til sandhed, identisk med tabellen i
// docs/arbejdsplan/skiffertag/04-laegter.md. Alle mål er PÅ SKRÅFLADEN,
// målt fra spærenden (s = 0) op mod kip (s = SK_SLOPE). Skiferens forkant
// stikker SK_EAVE_PROJ forbi spærenden, så vandet drypper fri af sternen.
//
//   s = (x + G_OH_EAVE) / cos(35°) på venstre halvtag
//   hver rækkes OVERKANT flugter en lægtes OVERKANT, så sømmene
//   (25–40 mm under stenens overkant) altid rammer lægten.
SK_SLOPE        = 1500;   // spærende -> kip = (G_RIDGE_X+G_OH_EAVE)/cos(35°)
SK_GAUGE        = 225;    // lægteafstand på skråfladen = (600 - 150) / 2
SK_EAVE_PROJ    = 60;     // skiferforkant forbi spærenden
SK_LAEGTE_TOP   = [0, 315, 540, 765, 990, 1215, 1440];  // L1..L7 overkanter
SK_COURSE_TAIL  = [-60, 165, 390, 615, 840, 1065];      // synlige rækkers underkant

// Skråflade-position -> X på hvert halvtag.
function _sk_xl(s) = -G_OH_EAVE + s * cos(G_PITCH_DEG);
function _sk_xr(s) = RH_HOUSE_LEN + G_OH_EAVE - s * cos(G_PITCH_DEG);
SK_SLATE_T      = 8;            // visible stone thickness (read as slate)
SK_STACK_T      = SK_UNDERLAY_T + SK_CBATTEN_T + SK_BATTEN_T + SK_SLATE_T;

// Seams and grooves run all the way to the slate edge (incl. the rake
// overhang) — the stones are laid out to the barge line.
SK_RAKE_INSET   = 0;

SK_UNDERLAY_COLOR = [0.14, 0.13, 0.12];
SK_SLATE_COLOR    = [0.20, 0.22, 0.26];
SK_SEAM_COLOR     = [0.03, 0.04, 0.06];
SK_RIDGE_COLOR    = [0.11, 0.12, 0.15];
SK_ZINC_COLOR     = [0.72, 0.75, 0.78];

// One tilted slab along the gable plane on [x_lo..x_hi] × [y_lo..y_hi].
module _sk_half_slab(x_lo, x_hi, y_lo, y_hi, offset_z, thick, color_rgb) {
    z00 = g_rafter_top_z(x_lo) + offset_z;
    z10 = g_rafter_top_z(x_hi) + offset_z;
    color(color_rgb)
    polyhedron(
        points = [
            [x_lo, y_lo, z00],
            [x_hi, y_lo, z10],
            [x_hi, y_hi, z10],
            [x_lo, y_hi, z00],
            [x_lo, y_lo, z00 + thick],
            [x_hi, y_lo, z10 + thick],
            [x_hi, y_hi, z10 + thick],
            [x_lo, y_hi, z00 + thick]
        ],
        faces = [[0, 1, 2, 3], [4, 7, 6, 5],
                 [0, 4, 5, 1], [1, 5, 6, 2],
                 [2, 6, 7, 3], [3, 7, 4, 0]]
    );
}

// Diffusion-open underlay (undertag) — a thin membrane draped on the rafter
// tops, following the roof plane. One tilted slab per half-slope.
module _sk_underlay(y_lo, y_hi) {
    _sk_half_slab(-G_OH_EAVE, G_RIDGE_X,               y_lo, y_hi, 0, SK_UNDERLAY_T, SK_UNDERLAY_COLOR);
    _sk_half_slab(G_RIDGE_X,  RH_HOUSE_LEN + G_OH_EAVE, y_lo, y_hi, 0, SK_UNDERLAY_T, SK_UNDERLAY_COLOR);
}

// Afstandslister — 25×50 trykimprægneret, on the underlay directly over each
// spær, running the full slope of each half. They lift the taglægter off the
// underlay so water on the membrane can drain to the eave (guide §4.1B).
module _sk_counter_battens(palette) {
    for (y = G_TRUSS_YS) {
        y_mid = y + 45/2;   // centre the 50 mm list on the 45 mm truss
        _sk_half_slab(-G_OH_EAVE, G_RIDGE_X,
                      y_mid - SK_CBATTEN_W/2, y_mid + SK_CBATTEN_W/2,
                      SK_UNDERLAY_T - 0.5, SK_CBATTEN_T, pal_post(palette));
        _sk_half_slab(G_RIDGE_X, RH_HOUSE_LEN + G_OH_EAVE,
                      y_mid - SK_CBATTEN_W/2, y_mid + SK_CBATTEN_W/2,
                      SK_UNDERLAY_T - 0.5, SK_CBATTEN_T, pal_post(palette));
    }
}

// Taglægter — T1 38×73, parallel to the ridge, at c/c up each half-slope,
// on top of the afstandslister. They cantilever out past the gable trusses
// to carry the rake overhang; ends stop at the vindskede inner face. Each is
// a slope-following slab (a flat cube would diverge from the 35° plane and
// poke up through the slate at its up-slope edge).
module _sk_battens(y_lo, y_hi, palette) {
    z0 = SK_UNDERLAY_T + SK_CBATTEN_T - 0.5;
    for (t = SK_LAEGTE_TOP) {
        // Venstre halvtag: lægten spænder s = t-73 .. t.
        _sk_half_slab(_sk_xl(t - SK_BATTEN_W), _sk_xl(t), y_lo, y_hi,
                      z0, SK_BATTEN_T, pal_post(palette));
        // Højre halvtag: spejlet om kippen.
        _sk_half_slab(_sk_xr(t), _sk_xr(t - SK_BATTEN_W), y_lo, y_hi,
                      z0, SK_BATTEN_T, pal_post(palette));
    }
}

// Course grooves and plate seams are rendered as thin tilted slabs that
// follow the slate plane (via _sk_half_slab) — NOT as axis-aligned cubes.
// An axis-aligned cube spanning a wide X range would diverge from the
// slate plane by up to (Δx × tan(pitch)) at its ends, leaving the cube
// sticking up into thin air at one corner and buried inside the slab at
// the other. The tilted slabs sit flush on the slate top all along their
// length.
SK_GROOVE_W = 10;            // X-extent of course-edge groove
SK_SEAM_W   = 7;             // Y-extent of plate seam
SK_GROOVE_H = 0.5;           // raised-above-slate height (vertical)

// Horizontal course grooves — one per course bottom on each half-slope.
// Each groove is a thin tilted slab (groove_w along slope) running the
// full Y depth.
module _sk_course_grooves(y_lo, y_hi) {
    yd_lo = y_lo + SK_RAKE_INSET;
    yd_hi = y_hi - SK_RAKE_INSET;
    for (t = SK_COURSE_TAIL) {
        xl = _sk_xl(t);
        _sk_half_slab(xl - SK_GROOVE_W/2, xl + SK_GROOVE_W/2, yd_lo, yd_hi,
                      SK_STACK_T - 0.2, SK_GROOVE_H, SK_SEAM_COLOR);
        xr = _sk_xr(t);
        _sk_half_slab(xr - SK_GROOVE_W/2, xr + SK_GROOVE_W/2, yd_lo, yd_hi,
                      SK_STACK_T - 0.2, SK_GROOVE_H, SK_SEAM_COLOR);
    }
}

// Vertical plate seams — between adjacent plates within each course.
// Adjacent courses are staggered by half a plate width (halv-forbandt).
// Each seam is a thin tilted slab spanning one course (c2c along slope)
// at the plate boundary along Y.
// `side` = -1 venstre halvtag, +1 højre. Hver rækkes synlige bånd går fra
// rækkens underkant til den næste rækkes underkant (øverste række: til kip).
module _sk_plate_seams_one_half(side, y_lo, y_hi) {
    yd_lo = y_lo + SK_RAKE_INSET;
    yd_hi = y_hi - SK_RAKE_INSET;
    n = len(SK_COURSE_TAIL);
    for (i = [0 : n - 1]) {
        s_lo  = SK_COURSE_TAIL[i];
        s_hi  = (i < n - 1) ? SK_COURSE_TAIL[i + 1] : SK_SLOPE;
        x_a   = (side < 0) ? _sk_xl(s_lo) : _sk_xr(s_lo);
        x_b   = (side < 0) ? _sk_xl(s_hi) : _sk_xr(s_hi);
        y_off = (i % 2 == 0) ? 0 : SK_PLATE_W / 2;
        for (y = [yd_lo + y_off : SK_PLATE_W : yd_hi])
            _sk_half_slab(min(x_a, x_b), max(x_a, x_b),
                          y - SK_SEAM_W/2, y + SK_SEAM_W/2,
                          SK_STACK_T - 0.2, SK_GROOVE_H, SK_SEAM_COLOR);
    }
}

module _sk_plate_seams(y_lo, y_hi) {
    _sk_plate_seams_one_half(-1, y_lo, y_hi);
    _sk_plate_seams_one_half(+1, y_lo, y_hi);
}

module _sk_ridge_cap(y_lo, y_hi) {
    cap_half_w = 90;       // each leg of the cap reaches this far from ridge
    cap_lift   = 32;       // apex height above slate top at the ridge
    cap_t      = 14;       // perpendicular thickness of the cap "tile"

    x_left  = G_RIDGE_X - cap_half_w;
    x_right = G_RIDGE_X + cap_half_w;
    z_outer_l = g_rafter_top_z(x_left)  + SK_STACK_T;
    z_outer_r = g_rafter_top_z(x_right) + SK_STACK_T;
    z_apex_b  = g_rafter_top_z(G_RIDGE_X) + SK_STACK_T;
    z_apex_t  = z_apex_b + cap_lift;
    // The top edge offset is along z (vertical lift) for simplicity.
    //
    // Orientering: polygonen er tegnet i verdens (x, z). rotate([90,0,0])
    // sender polygonens y → verdens +z og ekstruderingen → verdens −y, så
    // der translateres til y_hi og ekstruderes tilbage til y_lo.
    // (rotate([-90,0,0]) spejler i stedet polygonen til NEGATIV z og lægger
    // hele rygningen ~3,1 m under terræn — det var fejlen her.)
    color(SK_RIDGE_COLOR)
    translate([0, y_hi, 0])
    rotate([90, 0, 0])
    linear_extrude(height = y_hi - y_lo)
        polygon(points = [
            [x_left,    z_outer_l],                 // 0: bottom-left
            [G_RIDGE_X, z_apex_b],                  // 1: bottom-apex
            [x_right,   z_outer_r],                 // 2: bottom-right
            [x_right,   z_outer_r + cap_t],         // 3: top-right
            [G_RIDGE_X, z_apex_t  + cap_t * 0.3],   // 4: top-apex (raised)
            [x_left,    z_outer_l + cap_t]          // 5: top-left
        ]);
}

// Per-layer entries — one per arbejdsplan work step, so main.scad can render
// the build-up step by step. Each layer occupies its own band of the stack
// so nothing z-fights; the slate is only the top SK_SLATE_T (the underlay +
// lister + lægter are visible at the eave edge and from the underside).

// Undertag — stops at the gable walls (does not run into the rake overhang).
module render_skifer_undertag() {
    _sk_underlay(0, RH_HOUSE_DEPTH);
}

// Klemme-/afstandslister 25×50 over hvert spær.
module render_skifer_afstandslister(palette = DEFAULT_PALETTE) {
    _sk_counter_battens(palette);
}

// Taglægter 38×73 — cantilever 200 mm past the gable trusses to carry the
// rake overhang, ending at the vindskede inner face (vindskede caps the ends).
module render_skifer_laegter(palette = DEFAULT_PALETTE) {
    _sk_battens(-(G_VS_OUTER - G_VS_T),
                RH_HOUSE_DEPTH + (G_VS_OUTER - G_VS_T), palette);
}

// Naturskifer — the two slate slabs plus course grooves and stone seams.
// Only the top SK_SLATE_T of the stack, lapping ~1 mm over the lægte tops
// so no faces coincide.
module render_skifer_sten() {
    // The slate runs out over the vindskede-underbræt and stops flush with
    // its outer face, butting against the overligger that rises above it.
    y_lo = -G_VS_OUTER;
    y_hi = RH_HOUSE_DEPTH + G_VS_OUTER;
    // Forkanten stikker SK_EAVE_PROJ ud forbi spærenden (drypkant).
    x_lo = _sk_xl(-SK_EAVE_PROJ);
    x_hi = _sk_xr(-SK_EAVE_PROJ);
    slate_z0 = SK_UNDERLAY_T + SK_CBATTEN_T + SK_BATTEN_T - 1;
    _sk_half_slab(x_lo, G_RIDGE_X, y_lo, y_hi,
                  slate_z0, SK_STACK_T - slate_z0, SK_SLATE_COLOR);
    _sk_half_slab(G_RIDGE_X, x_hi, y_lo, y_hi,
                  slate_z0, SK_STACK_T - slate_z0, SK_SLATE_COLOR);
    _sk_course_grooves(y_lo, y_hi);
    _sk_plate_seams(y_lo, y_hi);
}

// Fodblik — zinc drip flashing at both eaves. A strip tucked in under the
// slate edge, folded out over the stern's top edge and ~45 mm down its face,
// so water off the undertag and the slate drips clear of the stern (no
// gutter in this build). Runs between the vindskede inner faces,
// like the lægter. The stern must match this in height: stern top = stack
// top, so the fold lands exactly on the stern's upper front edge.
module render_skifer_fodblik() {
    y0   = -(G_VS_OUTER - G_VS_T);
    y1   = RH_HOUSE_DEPTH + (G_VS_OUTER - G_VS_T);
    drop = 45;    // visible fold-down over the stern face
    tuck = 20;    // how far the top leg reaches in under the slate
    t    = 2;
    for (side = [0, 1]) {
        x_e  = side == 0 ? -G_OH_EAVE : RH_HOUSE_LEN + G_OH_EAVE;
        z_hi = g_rafter_top_z(x_e) + G_ROOF_STACK_T;
        x_lo = side == 0 ? x_e - RH_FASCIA_T - t : x_e - tuck;
        color(SK_ZINC_COLOR) {
            // top leg: from under the slate out over the stern top
            translate([x_lo, y0, z_hi - t])
                cube([tuck + RH_FASCIA_T + t, y1 - y0, t]);
            // front leg: down over the stern face
            translate([side == 0 ? x_e - RH_FASCIA_T - t : x_e + RH_FASCIA_T,
                       y0, z_hi - drop])
                cube([t, y1 - y0, drop]);
        }
    }
}

// Zink-rygning over kippen — runs between the vindskede-overliggere.
module render_skifer_rygning() {
    _sk_ridge_cap(-G_VS_OUTER, RH_HOUSE_DEPTH + G_VS_OUTER);
}

// Top-level entry — the full build-up in one call (back-compat for the
// house/roof_plates.scad dispatcher and render scripts).
module render_roof_plates_skifer_gable(palette = DEFAULT_PALETTE) {
    render_skifer_undertag();
    render_skifer_afstandslister(palette);
    render_skifer_laegter(palette);
    render_skifer_fodblik();
    render_skifer_sten();
    render_skifer_rygning();
}
