// Welded-wire mesh primitives. Frameless "voliere" runs stretched directly
// across structural reglar — the studs ARE the frame, so no inner wooden
// border. Bars are rendered with bar-thickness mb only; no frame strips.

include <../defaults.scad>

// X-axis run (wall normal = ±Y). Net plane sits at y = y_pos.
//   x_start, length = horizontal extent (along X)
//   z_base, height  = vertical extent (along Z)
//   y_pos           = Y coordinate of the net plane (centre of bar thickness)
module voliere_x(x_start, length, z_base, height, y_pos,
                 palette=DEFAULT_PALETTE, mesh=DEFAULT_MESH) {
    sp = ms_spacing(mesh);
    mb = ms_bar(mesh);
    color(pal_mesh(palette)) {
        for (xx = [x_start + sp/2 : sp : x_start + length - sp/2])
            translate([xx - mb/2, y_pos - mb/2, z_base])
                cube([mb, mb, height]);
        for (zz = [z_base + sp/2 : sp : z_base + height - sp/2])
            translate([x_start, y_pos - mb/2, zz - mb/2])
                cube([length, mb, mb]);
    }
}

// Y-axis run (wall normal = ±X). Net plane sits at x = x_pos.
module voliere_y(y_start, length, z_base, height, x_pos,
                 palette=DEFAULT_PALETTE, mesh=DEFAULT_MESH) {
    sp = ms_spacing(mesh);
    mb = ms_bar(mesh);
    color(pal_mesh(palette)) {
        for (yy = [y_start + sp/2 : sp : y_start + length - sp/2])
            translate([x_pos - mb/2, yy - mb/2, z_base])
                cube([mb, mb, height]);
        for (zz = [z_base + sp/2 : sp : z_base + height - sp/2])
            translate([x_pos - mb/2, y_start, zz - mb/2])
                cube([mb, length, mb]);
    }
}

// Y-axis run with a sloped top following two corner Z values. Net is
// rendered at full max height then trimmed by an `intersection()` against
// a wedge whose top face linearly interpolates from z_top_y0 (at y_start)
// to z_top_y1 (at y_start + length). Bars below the slope survive; bars
// above are clipped.
module voliere_y_sloped(y_start, length, z_base, z_top_y0, z_top_y1, x_pos,
                        palette=DEFAULT_PALETTE, mesh=DEFAULT_MESH) {
    z_max = max(z_top_y0, z_top_y1);
    intersection() {
        voliere_y(y_start, length, z_base, z_max - z_base, x_pos,
                  palette=palette, mesh=mesh);
        // Sloped wedge: solid from z_base to the linearly interpolated top.
        // 200 mm thick along X, centred on x_pos so it always envelopes the bars.
        hull() {
            translate([x_pos - 100, y_start, z_base])
                cube([200, 0.01, z_top_y0 - z_base]);
            translate([x_pos - 100, y_start + length - 0.01, z_base])
                cube([200, 0.01, z_top_y1 - z_base]);
        }
    }
}
