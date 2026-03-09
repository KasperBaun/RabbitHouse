module mesh_panel_x(panel_x, panel_w, panel_z, panel_h, y_pos) {
    color(col_trim) {
        translate([panel_x, y_pos, panel_z])
            cube([panel_w, mesh_depth, mesh_frame]);

        translate([panel_x, y_pos, panel_z + panel_h - mesh_frame])
            cube([panel_w, mesh_depth, mesh_frame]);

        translate([panel_x, y_pos, panel_z])
            cube([mesh_frame, mesh_depth, panel_h]);

        translate([panel_x + panel_w - mesh_frame, y_pos, panel_z])
            cube([mesh_frame, mesh_depth, panel_h]);
    }

    color(col_mesh) {
        for (xx = [panel_x + mesh_frame : mesh_spacing : panel_x + panel_w - mesh_frame]) {
            translate([xx - mesh_bar/2, y_pos + (mesh_depth-mesh_bar)/2, panel_z + mesh_frame])
                cube([mesh_bar, mesh_bar, panel_h - 2*mesh_frame]);
        }
        for (zz = [panel_z + mesh_frame : mesh_spacing : panel_z + panel_h - mesh_frame]) {
            translate([panel_x + mesh_frame, y_pos + (mesh_depth-mesh_bar)/2, zz - mesh_bar/2])
                cube([panel_w - 2*mesh_frame, mesh_bar, mesh_bar]);
        }
    }
}

module mesh_panel_y(panel_y, panel_w, panel_z, panel_h, x_pos) {
    color(col_trim) {
        translate([x_pos, panel_y, panel_z])
            cube([mesh_depth, panel_w, mesh_frame]);

        translate([x_pos, panel_y, panel_z + panel_h - mesh_frame])
            cube([mesh_depth, panel_w, mesh_frame]);

        translate([x_pos, panel_y, panel_z])
            cube([mesh_depth, mesh_frame, panel_h]);

        translate([x_pos, panel_y + panel_w - mesh_frame, panel_z])
            cube([mesh_depth, mesh_frame, panel_h]);
    }

    color(col_mesh) {
        for (yy = [panel_y + mesh_frame : mesh_spacing : panel_y + panel_w - mesh_frame]) {
            translate([x_pos + (mesh_depth-mesh_bar)/2, yy - mesh_bar/2, panel_z + mesh_frame])
                cube([mesh_bar, mesh_bar, panel_h - 2*mesh_frame]);
        }
        for (zz = [panel_z + mesh_frame : mesh_spacing : panel_z + panel_h - mesh_frame]) {
            translate([x_pos + (mesh_depth-mesh_bar)/2, panel_y + mesh_frame, zz - mesh_bar/2])
                cube([mesh_bar, panel_w - 2*mesh_frame, mesh_bar]);
        }
    }
}

module mesh_door_yz(x, y, z, w, h, angle_deg=0, frame=35) {
    rotate([0,0,angle_deg])
    translate([x, y, z]) {
        color(col_trim) {
            cube([18, w, frame]);
            translate([0, 0, h - frame]) cube([18, w, frame]);
            cube([18, frame, h]);
            translate([0, w - frame, 0]) cube([18, frame, h]);
        }

        color(col_mesh) {
            for (yy = [frame : mesh_spacing : w - frame]) {
                translate([5, yy, frame])
                    cube([8, mesh_bar, h - 2*frame]);
            }
            for (zz = [frame : mesh_spacing : h - frame]) {
                translate([5, frame, zz])
                    cube([8, w - 2*frame, mesh_bar]);
            }
        }
    }
}
