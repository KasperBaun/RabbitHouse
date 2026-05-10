// v3 build — top-level dispatcher.
// Composes the per-system modules from the role-based files. Each system
// has its own file (fundament, vaegge, tagkonstruktion, beklaedning,
// aabninger, inventar) so the user can review one building system at a
// time. See README.md in this folder for the role of each file.

include <../../lib/defaults.scad>
include <config.scad>

use <fundament.scad>
use <konstruktions-skelet.scad>
use <vaegge.scad>
use <tagkonstruktion.scad>
use <beklaedning.scad>
use <aabninger.scad>
use <inventar.scad>
use <../../lib/bom.scad>

module build_v3(show_cladding = true, show_ground = true, roof_cover = "tagpap") {
    bom_header();
    pal  = DEFAULT_PALETTE;
    clad = DEFAULT_CLAD;
    mesh = mesh_spec(spacing = V3_MESH_SPACING,
                     bar     = V3_MESH_BAR,
                     frame   = V3_MESH_FRAME,
                     depth   = V3_MESH_DEPTH);
    stud = DEFAULT_STUD;

    v3_fundament(show_ground, pal);
    v3_konstruktions_skelet(pal);
    v3_vaegge(stud, mesh, pal);
    v3_tagkonstruktion(roof_cover, pal);
    if (show_cladding) v3_beklaedning(clad, pal);
    if (show_cladding) v3_aabninger(mesh, pal);
    v3_inventar(show_cladding, show_ground, pal);
}

