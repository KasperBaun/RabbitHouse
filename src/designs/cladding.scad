// Cladding dispatcher — routes to the chosen variant renderer. Each variant
// owns its full wall-surface stack (housewrap + counter-battens + boards +
// corner trim) since direction and dimensions of every layer depend on the
// cladding type.

include <../lib/defaults.scad>
include <config.scad>
use <cladding_klink.scad>
use <cladding_board_on_board.scad>

module RenderCladding(cladding_type = "klink",
                      palette = DEFAULT_PALETTE) {
    if (cladding_type == "klink")
        render_cladding_klink(RH_CLAD, palette);
    else if (cladding_type == "board_on_board")
        render_cladding_board_on_board(RH_CLAD_BOB, palette);
    else
        assert(false, str("Unknown cladding_type: ", cladding_type));
}
