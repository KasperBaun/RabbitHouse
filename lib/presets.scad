// Preset size lookups. v1 (lean_to) uses these; v2 (house_yard) currently
// hard-codes its 6×3 footprint inside its own config.

// [length, width, eave_h, rabbit_len]
function preset_dims_v1(name) =
    name == "6x3" ? [6000, 3000, 2500, 3300] :
    name == "7x3" ? [7000, 3000, 2500, 4000] :
    name == "8x4" ? [8000, 4000, 2500, 4500] :
                    [7000, 3000, 2500, 4000];
