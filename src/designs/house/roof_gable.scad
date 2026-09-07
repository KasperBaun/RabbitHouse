// HOUSE gable roof — gavlspær + vindskeder. Selve spæret ligger i
// roof/haneband.scad. Skiferen rager G_OH_RAKE ud forbi gavlene, båret af
// taglægter der krager ud forbi gavlspærene; vindskeden sømmes på
// lægte-enderne.

include <../../lib/defaults.scad>
include <../config.scad>
use <roof/haneband.scad>

// Deles med skiferens afstandslister, der skal ligge direkte over spærene.
// Hvert spær er 45 mm og vokser +Y, så gavlspærene ligger flush INDE i
// vægfladerne: V1 Y=0..45, V2 (ww-45)..ww.
_GR_TRUSS_YS = G_TRUSS_YS;

// Vindskedens overkant: lige under skiferen (−1 mm, så flader ikke falder
// sammen), så den lukker lægte-enderne.
_GR_ROOF_STACK = G_ROOF_STACK_T - 1;
// Underbrættet er lige så højt som sternen og måles fra samme toplinje, så
// underkanterne flugter i tagfodshjørnet (G_STERN_H = 200: dækker spærende +
// sofitlamel). Overliggeren er 25×150 — den sidder forskudt op.
// Løber RH_FASCIA_T forbi tagfodslinjen og dækker sternens endetræ; enden
// kappes lodret ved sternens forside.
_GR_VS_TIP = RH_FASCIA_T;
// Overliggerens overkant: tagopbygning + skifer (8) + rejsning over fladen.
// Skiferen støder op mod den i stedet for at rage ud.
_GR_VS_OVER_TOP = G_ROOF_STACK_T + 8 + G_VS_OVER_RISE;

// Ét vindskedebræt langs begge rake-flader; bruges to gange pr. gavl
// (underbræt + overligger). `y_hi` = brættets indre Y-flade (ekstruderes
// G_VS_T udad), `z_top` = overkantens løft over spærplanet, `h` = bræddehøjde.
module _gable_vindskede(y_hi, z_top, h, palette) {
    x_el = -G_OH_EAVE;                  // eave line, left
    x_er = RH_HOUSE_LEN + G_OH_EAVE;    // eave line, right
    x_tl = x_el - _GR_VS_TIP;           // tip = stern front face, left
    x_tr = x_er + _GR_VS_TIP;           // tip = stern front face, right
    color(pal_barge(palette))
    translate([0, y_hi, 0])
        rotate([90, 0, 0])
            linear_extrude(height = G_VS_T)
                polygon(points = [
                    // top edge follows the roof plane tip-to-tip
                    [x_tl,      g_rafter_top_z(x_tl)      + z_top],
                    [G_RIDGE_X, g_rafter_top_z(G_RIDGE_X) + z_top],
                    [x_tr,      g_rafter_top_z(x_tr)      + z_top],
                    // plumb end cut at the stern front face...
                    [x_tr,      g_rafter_top_z(x_er) + z_top - h],
                    // ...level back to the eave line along the bottom line
                    [x_er,      g_rafter_top_z(x_er) + z_top - h],
                    // bottom edge parallel to the roof plane
                    [G_RIDGE_X, g_rafter_top_z(G_RIDGE_X) + z_top - h],
                    [x_el,      g_rafter_top_z(x_el) + z_top - h],
                    // level out to the tip + plumb cut closes the loop
                    [x_tl,      g_rafter_top_z(x_el) + z_top - h]
                ]);
}

// Spær only — arbejdsplan trin 4 ("Rejs spær m. hanebånd").
module RenderHouseGableSpaer(palette = DEFAULT_PALETTE) {
    for (y0 = _GR_TRUSS_YS) spaer_med_haneband(y0, palette);
}

// Klodser mellem gavlspær og udhængsspær. Firkantkappede 45×95-afkort — de
// skal IKKE tilpasses tagfladen, så overkanten sættes efter den laveste af
// klodsens to kanter; så stikker den aldrig op gennem spærplanet.
module _gable_udh_klodser(y0_klods, palette) {
    color(pal_post(palette))
    for (side = [-1, +1])
        for (s = G_UDH_KLODS_SS) {
            x0 = side < 0
                 ? -G_OH_EAVE + s * cos(G_PITCH_DEG)
                 : RH_HOUSE_LEN + G_OH_EAVE - s * cos(G_PITCH_DEG) - RH_RAFTER_W;
            z_top = min(g_rafter_top_z(x0), g_rafter_top_z(x0 + RH_RAFTER_W));
            translate([x0, y0_klods, z_top - RH_RAFTER_H])
                cube([RH_RAFTER_W, G_UDH_KLODS_L, RH_RAFTER_H]);
        }
}

// Gavludhæng — arbejdsplan trin 1a. Ét udhængsspær pr. gavl (begge halvtage,
// uden hanebånd) G_OH_RAKE_STRUCT ude forbi gavlspæret, holdt på plads af
// klodser ind til gavlspæret. Det er dem der bærer undertaget og gavlsofitten
// ud i udhænget; taglægterne ligger 28 mm højere og kan ikke.
module RenderHouseGableUdhaeng(palette = DEFAULT_PALETTE) {
    for (y0 = G_UDH_SPAER_YS) udhaengsspaer(y0, palette);
    _gable_udh_klodser(-G_UDH_KLODS_L,   palette);   // forgavl,  Y = -100..0
    _gable_udh_klodser(RH_HOUSE_DEPTH,        palette);   // baggavl,  Y = 3000..3100
}

// Dobbelt vindskede on both gable ends, mounted AFTER lægtning (arbejdsplan
// trin 5): underbræt nailed to the lægte ends (front Y=-170..-145, back
// Y=3145..3170) with its top just under the slate, then overligger on the
// underbræt's outer face (front Y=-195..-170, back Y=3170..3195) rising
// G_VS_OVER_RISE above the slate surface. The slate stops against the
// overligger's inner face.
module RenderHouseGableVindskeder(palette = DEFAULT_PALETTE) {
    // underbræt 25×200 — sømmes på BÅDE lægte- og udhængsspær-enderne
    _gable_vindskede(-G_OH_RAKE_STRUCT,                     _GR_ROOF_STACK,  G_STERN_H,   palette);  // V1 front
    _gable_vindskede(RH_HOUSE_DEPTH + G_VS_OUTER,           _GR_ROOF_STACK,  G_STERN_H,   palette);  // V2 back
    // overligger 25×150
    _gable_vindskede(-G_VS_OUTER,                           _GR_VS_OVER_TOP, G_VS_OVER_H, palette);  // V1 front
    _gable_vindskede(RH_HOUSE_DEPTH + G_VS_OUTER + G_VS_T,  _GR_VS_OVER_TOP, G_VS_OVER_H, palette);  // V2 back
}
