// Welded-wire mesh panels with wooden frames. Already parametric in v1 —
// this version takes palette + mesh_spec instead of reading globals.

include <../defaults.scad>

// Mesh panel oriented along the X axis (wall faces +/-Y).
//   panel_x, panel_z = lower-left corner (in X,Z)
//   panel_w, panel_h = panel size
//   y_pos            = Y of the panel face
module mesh_panel_x(panel_x, panel_w, panel_z, panel_h, y_pos,
                    palette=DEFAULT_PALETTE, mesh=DEFAULT_MESH) {
    md = ms_depth(mesh);
    mf = ms_frame(mesh);
    mb = ms_bar(mesh);
    sp = ms_spacing(mesh);

    color(pal_trim(palette)) {
        translate([panel_x, y_pos, panel_z])
            cube([panel_w, md, mf]);
        translate([panel_x, y_pos, panel_z + panel_h - mf])
            cube([panel_w, md, mf]);
        translate([panel_x, y_pos, panel_z])
            cube([mf, md, panel_h]);
        translate([panel_x + panel_w - mf, y_pos, panel_z])
            cube([mf, md, panel_h]);
    }

    color(pal_mesh(palette)) {
        for (xx = [panel_x + mf : sp : panel_x + panel_w - mf]) {
            translate([xx - mb/2, y_pos + (md-mb)/2, panel_z + mf])
                cube([mb, mb, panel_h - 2*mf]);
        }
        for (zz = [panel_z + mf : sp : panel_z + panel_h - mf]) {
            translate([panel_x + mf, y_pos + (md-mb)/2, zz - mb/2])
                cube([panel_w - 2*mf, mb, mb]);
        }
    }
}

// Mesh panel oriented along the Y axis (wall faces +/-X).
module mesh_panel_y(panel_y, panel_w, panel_z, panel_h, x_pos,
                    palette=DEFAULT_PALETTE, mesh=DEFAULT_MESH) {
    md = ms_depth(mesh);
    mf = ms_frame(mesh);
    mb = ms_bar(mesh);
    sp = ms_spacing(mesh);

    color(pal_trim(palette)) {
        translate([x_pos, panel_y, panel_z])
            cube([md, panel_w, mf]);
        translate([x_pos, panel_y, panel_z + panel_h - mf])
            cube([md, panel_w, mf]);
        translate([x_pos, panel_y, panel_z])
            cube([md, mf, panel_h]);
        translate([x_pos, panel_y + panel_w - mf, panel_z])
            cube([md, mf, panel_h]);
    }

    color(pal_mesh(palette)) {
        for (yy = [panel_y + mf : sp : panel_y + panel_w - mf]) {
            translate([x_pos + (md-mb)/2, yy - mb/2, panel_z + mf])
                cube([mb, mb, panel_h - 2*mf]);
        }
        for (zz = [panel_z + mf : sp : panel_z + panel_h - mf]) {
            translate([x_pos + (md-mb)/2, panel_y + mf, zz - mb/2])
                cube([mb, panel_w - 2*mf, mb]);
        }
    }
}

// Mesh door, oriented in the YZ plane (i.e. the face normal is along X).
module mesh_door_yz(x, y, z, w, h, angle_deg=0, frame=35,
                    palette=DEFAULT_PALETTE, mesh=DEFAULT_MESH) {
    sp = ms_spacing(mesh);
    mb = ms_bar(mesh);
    rotate([0,0,angle_deg])
    translate([x, y, z]) {
        color(pal_trim(palette)) {
            cube([18, w, frame]);
            translate([0, 0, h - frame]) cube([18, w, frame]);
            cube([18, frame, h]);
            translate([0, w - frame, 0]) cube([18, frame, h]);
        }
        color(pal_mesh(palette)) {
            for (yy = [frame : sp : w - frame])
                translate([5, yy, frame])
                    cube([8, mb, h - 2*frame]);
            for (zz = [frame : sp : h - frame])
                translate([5, frame, zz])
                    cube([8, w - 2*frame, mb]);
        }
    }
}
