// Roof plates dispatcher — chooses the cover stack based on roof_cover.

include <../lib/defaults.scad>
use <roof_plates_tagpap.scad>
use <roof_plates_eternit.scad>

module RenderRoofPlates(cover, palette = DEFAULT_PALETTE) {
    if (cover == "tagpap_osb" || cover == "tagpap")
        render_roof_plates_tagpap(palette);
    else if (cover == "eternit_b7" || cover == "eternit_10" || cover == "eternit_14")
        render_roof_plates_eternit(cover, palette);
    else
        assert(false, str("Unknown roof_cover: ", cover));
}
