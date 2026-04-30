// Default ctx values. Each library file `include`s this so its module
// signatures can reference DEFAULT_* as default arg values.

include <ctx.scad>

DEFAULT_PALETTE = palette();
DEFAULT_CLAD    = clad_spec();
DEFAULT_MESH    = mesh_spec();
DEFAULT_STUD    = stud_spec();
