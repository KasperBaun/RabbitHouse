// House-yard v3 — constants.
//
// Layout (mm):
//   X 0..2000    = solid mono-pitch house on a slab (rabbit shelter +
//                  insulated nest box). Human entry is from inside the yard.
//   X 2000..6000 = mesh-walled yard on concrete ground plugs. Human entry
//                  to the yard is via a mesh door on the front.
//   Y 0          = front (open garden face / human entry / high eave)
//   Y 3000       = back (prevailing-wind side / low eave / gutter)
//
// Roof: ONE continuous mono-pitch slab spans the entire 6 m × 3 m footprint,
// sloping front-to-back. Wall-face heights are eh_front=2600, eh_back=2200
// (drop 400 over 3000). The roof primitive interprets `eave_h` and `drop`
// across the FULL OVERHANG SPAN, so v3 derives a corrected origin Z and
// total drop (see V3_ROOF_*) so the wall tops align with the roof
// underside at the wall faces, not just at the overhang tips.

V3_LENGTH       = 6000;
V3_WIDTH        = 3000;
V3_BASE_H       = 120;
V3_WALL_T       = 100;
V3_HOUSE_LEN    = 2000;
V3_RUN_LEN      = 4000;

V3_EH_FRONT     = 2600;
V3_EH_BACK      = 2200;

// Roof overhangs
V3_OH_FRONT     = 220;
V3_OH_BACK      = 180;
V3_OH_SIDE      = 220;
V3_ROOF_THICK   = 80;

// Human door in the partition (X=V3_HOUSE_LEN, faces +X into the yard).
V3_HOUSE_DOOR_W = 850;
V3_HOUSE_DOOR_H = 2100;
V3_HOUSE_DOOR_Y = 200;       // along Y on the partition

// Rabbit pet door (partition at X=V3_HOUSE_LEN, faces +X into yard).
V3_PET_DOOR_W   = 250;
V3_PET_DOOR_H   = 300;
V3_PET_DOOR_Y   = 1500;

// Yard mesh door (front face Y=0, opens outward to garden).
V3_YARD_DOOR_W  = 850;
V3_YARD_DOOR_H  = 1900;
V3_YARD_DOOR_X  = 3000;      // X along front (left edge of the door)

// Insulated nest box (against back wall, in main house space).
V3_NEST_X       = 1100;
V3_NEST_Y       = 1900;
V3_NEST_W       = 800;
V3_NEST_D       = 900;
V3_NEST_H       = 600;

// Side window on left exterior wall (X=0, faces -X).
V3_SIDE_WIN_W   = 700;
V3_SIDE_WIN_H   = 600;
V3_SIDE_WIN_Y   = 1300;
V3_SIDE_WIN_Z   = 1100;

// Yard ground plugs.
V3_PLUG_W       = 280;
V3_PLUG_H       = 100;
V3_PLUG_BURY    = 40;

// Buried mesh apron around yard exterior (predator dig defence).
V3_APRON_W      = 500;

V3_POST_W       = 100;

// Mesh spec for the yard — fine welded wire (predator-proof per REQ-008).
//   13 mm aperture × 1 mm wire (≈ gauge 19 GAW)
V3_MESH_SPACING = 13;
V3_MESH_BAR     = 1;
V3_MESH_FRAME   = 40;
V3_MESH_DEPTH   = 20;

// Vertical wood stiles every ~1 m along yard mesh walls.
V3_STILE_W      = 60;
V3_STILE_SPACING = 1000;
