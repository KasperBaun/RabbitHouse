// House cladding dispatcher. Cladding is house-only; yard walls are mesh.

include <../../../lib/defaults.scad>
include <../../config.scad>
use <cladding_klink.scad>
use <cladding_board_on_board.scad>
use <cladding_vertical_120.scad>

module RenderHouseCladding(cladding_type = "klink",
                           palette = DEFAULT_PALETTE) {
    if (cladding_type == "klink")
        render_cladding_klink(RH_CLAD, palette);
    else if (cladding_type == "board_on_board")
        render_cladding_board_on_board(RH_CLAD_BOB, palette);
    else if (cladding_type == "vertical_120")
        render_cladding_vertical_120(palette);
    else
        assert(false, str("Unknown cladding_type: ", cladding_type));
}
