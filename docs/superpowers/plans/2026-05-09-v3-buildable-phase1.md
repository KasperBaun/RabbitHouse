# v3 Buildable — Phase 1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn `designs/v3/` into a buildable construction-drawing source: split into role-based files, add the missing structural carpentry (insulation, wind bracing, losholter, real rafters with sheathing/lægter/cover), introduce a beslag library and BOM system column, and provide audit renders + a roof-cover comparison script.

**Architecture:** Refactor `build.scad` into per-system files (`fundament.scad`, `vaegge.scad`, `tagkonstruktion.scad`, `beklaedning.scad`, `aabninger.scad`, `inventar.scad`) so the user can review one building system at a time. New `lib/primitives/beslag.scad` for connectors. Pluggable `roof_cover` parameter ("tagpap" | "stål" | "eternit_10" | "eternit_14") swaps out roof layers and BOM lines.

**Tech Stack:** OpenSCAD 2021+ on Windows. PowerShell for build scripts. No traditional unit-test framework — verification is `assert()` statements + render-and-eyeball + BOM CSV introspection.

**Spec source:** `docs/superpowers/specs/2026-05-09-v3-buildable-phase1-design.md`

---

## Verification convention for this plan

OpenSCAD has no `pytest` equivalent. "Tests" in this plan mean:

1. **Compile-clean render** — running `openscad -o out.png main.scad` exits 0 with no `WARNING:`/`ERROR:` lines on stderr.
2. **`assert(cond, msg)`** — OpenSCAD aborts compile if `cond` is false. Use for invariants like "spær count > 0" or "slope ≥ 2°".
3. **BOM CSV introspection** — render with `$bom_mode=true` and grep the resulting CSV for expected lines.
4. **Visual regression** — capture a baseline render before a refactor task; after the task, render the same camera and verify the file size / pixel diff is small (~identical).

The standard render command used throughout (call it `RENDER`):

```powershell
$env:Path += ";C:\Program Files\OpenSCAD"
& openscad -o "_renders/<name>.png" --imgsize=1600,1100 --colorscheme=Tomorrow `
    --camera=3000,1250,1300,55,0,25,16000 `
    -D 'design="v3"' -D show_cladding=true -D show_ground=true main.scad 2>&1 | Select-Object -Last 2
```

The standard BOM extract command (call it `BOM`):

```powershell
& openscad -o _renders/bom.png -D 'design="v3"' -D '$bom_mode=true' main.scad 2>&1 |
    Select-String '"BOM,' |
    ForEach-Object { ($_.Line -replace 'ECHO: "', '' -replace '"$', '') } |
    Out-File -Encoding utf8 _renders/v3_bom.csv
```

---

## File structure (target)

```
main.scad                                 # dispatcher (gains roof_cover param)
designs/v3/
├── README.md                             # role of each file + build order
├── config.scad                           # constants (gains floor + roof presets)
├── build.scad                            # top dispatcher: build_<system>() in order
├── fundament.scad                        # ring + ledger + strøer + krydsfiner + apron
├── vaegge.scad                           # all stud walls + bats + vindpapir + losholter + vindkryds
├── tagkonstruktion.scad                  # spær + pluggable cover layers + sternbrædder
├── beklaedning.scad                      # klink + afstandsliste + hjørnetrim
├── aabninger.scad                        # 4 openings (human dør, pet, yard, vindue)
└── inventar.scad                         # nest box, hay rack, bowls, rabbits, dressing
lib/primitives/
└── beslag.scad                           # ankerskrue, vinkelbeslag, spærsko, bjælkesko, strøsko
scripts/
├── audit_renders.ps1                     # render all 10 per-system audit views
└── compare_roof_options.ps1              # render & BOM-diff the 4 roof covers
```

`v1` and `v2` are untouched.

---

## Sub-phase A — File reorganisation (zero behavior change)

The single `designs/v3/build.scad` becomes 8 small files. After Sub-phase A, renders must be **identical** to the baseline captured in Task A1.

### Task A1: Capture baseline renders

**Files:**
- Create: `_renders/baseline_phase1/iso_clad.png`
- Create: `_renders/baseline_phase1/iso_frame.png`
- Create: `_renders/baseline_phase1/no_ground.png`

- [ ] **Step 1: Run baseline renders**

```powershell
mkdir -Force _renders/baseline_phase1
$env:Path += ";C:\Program Files\OpenSCAD"
foreach ($cfg in @(
    @{name="iso_clad";    clad="true";  gnd="true"},
    @{name="iso_frame";   clad="false"; gnd="true"},
    @{name="no_ground";   clad="false"; gnd="false"}
)) {
    & openscad -o "_renders/baseline_phase1/$($cfg.name).png" `
        --imgsize=1600,1100 --colorscheme=Tomorrow `
        --camera=3000,1250,1300,55,0,25,16000 `
        -D 'design="v3"' -D "show_cladding=$($cfg.clad)" -D "show_ground=$($cfg.gnd)" main.scad
}
```

Expected: 3 PNG files in `_renders/baseline_phase1/` of similar size to existing audit renders (~150-300 KB).

- [ ] **Step 2: Commit baseline**

```bash
git add _renders/baseline_phase1/
git commit -m "v3: capture pre-refactor baseline renders for Phase 1"
```

---

### Task A2: Create empty role-based files with module stubs

**Files:**
- Create: `designs/v3/fundament.scad`
- Create: `designs/v3/vaegge.scad`
- Create: `designs/v3/tagkonstruktion.scad`
- Create: `designs/v3/beklaedning.scad`
- Create: `designs/v3/aabninger.scad`
- Create: `designs/v3/inventar.scad`

- [ ] **Step 1: Create each stub file**

Each file gets the same skeleton:

```scad
// <Role>.scad — <one-line description>
// Part of the v3 build pipeline; included from build.scad.

include <../../lib/defaults.scad>
include <config.scad>
use <../../lib/bom.scad>

module v3_<system>(palette = DEFAULT_PALETTE) {
    // populated by Task A3..A8
}
```

Replace `<Role>`/`<system>` per file:

| File | Role | Module name |
|---|---|---|
| `fundament.scad` | Foundation: ring + floor + apron | `v3_fundament` |
| `vaegge.scad` | All vertical stud walls (house + yard) | `v3_vaegge` |
| `tagkonstruktion.scad` | Spær + cover layers + sternbrædder | `v3_tagkonstruktion` |
| `beklaedning.scad` | Klink + afstandsliste + trim | `v3_beklaedning` |
| `aabninger.scad` | Doors + window + framed openings | `v3_aabninger` |
| `inventar.scad` | Nest box + hay rack + bowls + rabbits | `v3_inventar` |

- [ ] **Step 2: Verify the files compile in isolation**

```powershell
foreach ($f in "fundament","vaegge","tagkonstruktion","beklaedning","aabninger","inventar") {
    & openscad -o "_renders/check_$f.png" --imgsize=200,200 "designs/v3/$f.scad" 2>&1 |
        Select-String 'ERROR|WARNING'
}
```

Expected: no output (no errors/warnings).

- [ ] **Step 3: Commit stubs**

```bash
git add designs/v3/fundament.scad designs/v3/vaegge.scad designs/v3/tagkonstruktion.scad designs/v3/beklaedning.scad designs/v3/aabninger.scad designs/v3/inventar.scad
git commit -m "v3: add empty per-system file stubs (fundament/vaegge/tagkonstruktion/...)"
```

---

### Task A3: Move foundation calls to `fundament.scad`

**Files:**
- Modify: `designs/v3/fundament.scad`
- Modify: `designs/v3/build.scad:65-79` (current foundation block)

- [ ] **Step 1: Move foundation logic into `v3_fundament` module**

Replace `fundament.scad`'s stub body with the foundation block from `build.scad` (currently lines that call `fundablok_ring`, `slab`, `interior_floor`, `rabbit_floor_grass`, `dpc_strip`, `apron_skirt`, ground/grass when `show_ground`, plus the path/dressing). Pass through `show_ground` and `pal`.

```scad
include <../../lib/defaults.scad>
include <config.scad>
use <../../lib/primitives/fundablok.scad>
use <../../lib/primitives/foundation.scad>
use <../../lib/decor/landscape.scad>
use <../../lib/bom.scad>

module v3_fundament(show_ground = true, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; bh = V3_BASE_H; wt = V3_WALL_T;
    hl = V3_HOUSE_LEN; rl = V3_RUN_LEN;
    ct = 22;  // klink thickness — TODO replace with cs_thick after vaegge introduces clad

    if (show_ground) {
        ground_grass([ll/2, ww/2]);
        gravel_path_y([V3_YARD_DOOR_X + V3_YARD_DOOR_W/2, 0]);
    }

    fundablok_ring(ll, ww, 3, [hl]);

    // Slab + interior floor (will be replaced by strøer floor in Sub-phase D).
    slab([-ct, -ct], [hl + 2*ct, ww + 2*ct], bh, palette,
         edge_thicken_h = 200, edge_thicken_w = 250);
    interior_floor([wt, wt], [hl - 2*wt, ww - 2*wt], bh, 20, palette);
    rabbit_floor_grass([wt, wt], [hl - 2*wt, ww - 2*wt], bh);

    dpc_strip([0, 0, bh], hl, "X", 95);
    dpc_strip([0, ww - 95, bh], hl, "X", 95);
    dpc_strip([0, 0, bh], ww, "Y", 95);
    dpc_strip([hl - 95, 0, bh], ww, "Y", 95);

    apron_skirt([hl, 0, ll, ww], V3_APRON_W, ["front", "back", "right"], palette);
}
```

- [ ] **Step 2: Stub the move out of `build.scad`**

In `build.scad`, replace the foundation block (the `slab(...)`, `interior_floor(...)`, `rabbit_floor_grass(...)`, `dpc_strip(...)`, `apron_skirt(...)`, `ground_grass`, `gravel_path_y` calls) with a single call:

```scad
v3_fundament(show_ground, pal);
```

Add `use <fundament.scad>` near the top of `build.scad`.

- [ ] **Step 3: Render and diff against baseline**

```powershell
RENDER -name="post_a3_iso_clad" -clad=true -gnd=true
```

Compare visually to `_renders/baseline_phase1/iso_clad.png`. Should be identical (foundation moved, no behavior change).

- [ ] **Step 4: Commit**

```bash
git add designs/v3/build.scad designs/v3/fundament.scad
git commit -m "v3: extract foundation block into fundament.scad (no behavior change)"
```

---

### Task A4: Move wall framing to `vaegge.scad`

**Files:**
- Modify: `designs/v3/vaegge.scad`
- Modify: `designs/v3/build.scad`

- [ ] **Step 1: Move `v3_house_framing`, `v3_yard_posts_and_sills`, `v3_yard_top_beams`, `v3_yard_stiles`, `v3_yard_mesh_front`, `v3_yard_mesh_back`, `v3_yard_mesh_right` from `build.scad` into `vaegge.scad`**

Wrap the calls inside a single `v3_vaegge(stud, mesh, palette)` module:

```scad
include <../../lib/defaults.scad>
include <config.scad>
use <../../lib/primitives/framing.scad>
use <../../lib/primitives/mesh.scad>
use <../../lib/bom.scad>

// Helpers v3_house_framing, v3_yard_posts_and_sills, etc. (paste from build.scad)
// ... (full module bodies copied verbatim)

module v3_vaegge(stud = DEFAULT_STUD, mesh = DEFAULT_MESH, palette = DEFAULT_PALETTE) {
    ll  = V3_LENGTH; ww  = V3_WIDTH; bh  = V3_BASE_H; wt  = V3_WALL_T;
    hl  = V3_HOUSE_LEN; rl  = V3_RUN_LEN;
    ehf = V3_EH_FRONT; ehb = V3_EH_BACK;
    ct  = 22; fpw = V3_POST_W;

    v3_house_framing(hl, ww, ehf, ehb, bh, wt, fpw, stud, palette);
    v3_yard_posts_and_sills(hl, rl, ww, bh, fpw, ct, palette);
    v3_yard_top_beams(hl, rl, ww, fpw, ct, palette);
    v3_yard_stiles(hl, rl, ww, fpw, palette);
    v3_yard_mesh_front(hl, rl, ww, fpw, ct, palette, mesh);
    v3_yard_mesh_back(hl, rl, ww, fpw, ct, palette, mesh);
    v3_yard_mesh_right(hl, rl, ww, fpw, palette, mesh);
}
```

Keep the helper modules verbatim — no logic changes.

- [ ] **Step 2: Replace those calls in `build.scad` with a single `v3_vaegge(stud, mesh, pal);`**

Add `use <vaegge.scad>` near the top of `build.scad`. Remove the helper-module bodies that moved.

- [ ] **Step 3: Render and verify against baseline**

```powershell
RENDER -name="post_a4_iso_frame" -clad=false -gnd=true
```

Compare to `_renders/baseline_phase1/iso_frame.png`. Identical.

- [ ] **Step 4: Commit**

```bash
git add designs/v3/build.scad designs/v3/vaegge.scad
git commit -m "v3: extract wall framing (house + yard) into vaegge.scad"
```

---

### Task A5: Move roof + ceiling rafters to `tagkonstruktion.scad`

**Files:**
- Modify: `designs/v3/tagkonstruktion.scad`
- Modify: `designs/v3/build.scad`

- [ ] **Step 1: Move `roof_mono_pitch`, `fascia_and_gutter_mono`, `ceiling_rafters_mono` calls into `v3_tagkonstruktion`**

Pass `palette` only; pull dimensions from config. Helper functions `v3_span_total`, `v3_total_drop`, `v3_roof_oz`, `v3_roof_under` remain in `build.scad` for now (Sub-phase F will rework).

```scad
include <../../lib/defaults.scad>
include <config.scad>
use <../../lib/primitives/roof.scad>
use <../../lib/bom.scad>

// Re-declare roof helper functions here so the module is self-contained.
function v3_span_total() = V3_OH_FRONT + V3_WIDTH + V3_OH_BACK;
function v3_total_drop() =
    (V3_EH_FRONT - V3_EH_BACK) * v3_span_total() / V3_WIDTH;
function v3_roof_oz() =
    V3_BASE_H + V3_EH_FRONT + V3_OH_FRONT * v3_total_drop() / v3_span_total();
function v3_roof_under(y) =
    v3_roof_oz() - (V3_OH_FRONT + y) * v3_total_drop() / v3_span_total();

module v3_tagkonstruktion(palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; wt = V3_WALL_T;
    roof_oz = v3_roof_oz();
    drop_full = v3_total_drop();
    rafter_eave_h = v3_roof_under(wt);
    rafter_drop = v3_roof_under(wt) - v3_roof_under(ww - wt);

    roof_mono_pitch([0, 0, roof_oz], ll, ww, drop_full, V3_ROOF_THICK,
                    V3_OH_FRONT, V3_OH_BACK, V3_OH_SIDE, palette);
    fascia_and_gutter_mono([0, 0, roof_oz], ll, ww, drop_full,
                           150, 22, V3_OH_FRONT, V3_OH_BACK, V3_OH_SIDE,
                           110, 65, 0, palette);
    ceiling_rafters_mono([0, 0, 0], ll, ww, rafter_drop, rafter_eave_h,
                         900, 45, 140, wt, palette,
                         x_inset = wt + 55);
}
```

- [ ] **Step 2: Update `build.scad`**

Replace the roof/fascia/rafter block in `build_v3()` with `v3_tagkonstruktion(pal);`. Remove the duplicate function declarations now that they live in `tagkonstruktion.scad`. Add `use <tagkonstruktion.scad>` (functions don't transit through `use`, so other files that need `v3_roof_under` will need their own copy — but for now only this file uses them).

Other files that referenced `v3_roof_under` (vaegge.scad after task A4): keep their own re-declaration of these helper functions, OR move the functions to `config.scad` so they're `include`d. **Move them to `config.scad`** — they're configuration-derived constants:

In `config.scad`, append:

```scad
// Roof geometry helpers (derived from V3_* constants).
function v3_span_total() = V3_OH_FRONT + V3_WIDTH + V3_OH_BACK;
function v3_total_drop() =
    (V3_EH_FRONT - V3_EH_BACK) * v3_span_total() / V3_WIDTH;
function v3_roof_oz() =
    V3_BASE_H + V3_EH_FRONT + V3_OH_FRONT * v3_total_drop() / v3_span_total();
function v3_roof_under(y) =
    v3_roof_oz() - (V3_OH_FRONT + y) * v3_total_drop() / v3_span_total();
```

Remove the duplicate declarations from `tagkonstruktion.scad` and `build.scad`.

- [ ] **Step 3: Render and verify**

```powershell
RENDER -name="post_a5_iso_clad" -clad=true -gnd=true
```

Compare to baseline.

- [ ] **Step 4: Commit**

```bash
git add designs/v3/build.scad designs/v3/tagkonstruktion.scad designs/v3/config.scad
git commit -m "v3: extract roof + rafters into tagkonstruktion.scad; move roof helpers to config"
```

---

### Task A6: Move cladding to `beklaedning.scad`

**Files:**
- Modify: `designs/v3/beklaedning.scad`
- Modify: `designs/v3/build.scad`

- [ ] **Step 1: Move `v3_house_cladding` and `v3_house_corner_trims` into `v3_beklaedning`**

```scad
include <../../lib/defaults.scad>
include <config.scad>
use <../../lib/primitives/cladding.scad>
use <../../lib/bom.scad>

// helpers v3_house_cladding, v3_house_corner_trims (paste verbatim)

module v3_beklaedning(clad = DEFAULT_CLAD, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; bh = V3_BASE_H;
    hl = V3_HOUSE_LEN;
    ehf = V3_EH_FRONT; ehb = V3_EH_BACK;
    ct = cs_thick(clad);

    v3_house_cladding(hl, ww, ehf, ehb, bh, ct, palette, clad);
    v3_house_corner_trims(hl, ww, ehf, ehb, bh, ct, palette);
}
```

- [ ] **Step 2: Update `build.scad`**

Replace the `if (show_cladding) { v3_house_cladding(...); v3_house_corner_trims(...); }` block with `if (show_cladding) v3_beklaedning(clad, pal);`.

- [ ] **Step 3: Render and verify**

```powershell
RENDER -name="post_a6_iso_clad" -clad=true -gnd=true
```

- [ ] **Step 4: Commit**

```bash
git add designs/v3/build.scad designs/v3/beklaedning.scad
git commit -m "v3: extract klink cladding + corner trims into beklaedning.scad"
```

---

### Task A7: Move openings to `aabninger.scad`

**Files:**
- Modify: `designs/v3/aabninger.scad`
- Modify: `designs/v3/build.scad`

- [ ] **Step 1: Move `v3_partition_door`, `v3_yard_door`, `rabbit_pet_door_yz` placement, `window_with_trim_xneg` placement, and the threshold cube into `v3_aabninger`**

```scad
include <../../lib/defaults.scad>
include <config.scad>
use <../../lib/primitives/openings.scad>
use <../../lib/primitives/mesh.scad>
use <../../lib/bom.scad>

// helpers v3_partition_door, v3_yard_door (paste verbatim)

module v3_aabninger(mesh = DEFAULT_MESH, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; bh = V3_BASE_H; wt = V3_WALL_T;
    hl = V3_HOUSE_LEN;
    ct = 22;

    v3_partition_door(hl, ct, V3_HOUSE_DOOR_Y, V3_HOUSE_DOOR_W,
                      V3_HOUSE_DOOR_H, bh, palette);
    rabbit_pet_door_yz(hl - wt, V3_PET_DOOR_Y, bh + 60,
                       V3_PET_DOOR_W, V3_PET_DOOR_H, wt, palette);

    // Stone threshold inside the yard at the partition human door
    color([0.55, 0.50, 0.40])
    translate([hl + ct + 20, V3_HOUSE_DOOR_Y - 50,
               V3_PLUG_H + 18 + V3_SILL_H])
        cube([200, V3_HOUSE_DOOR_W + 100, 12]);

    window_with_trim_xneg(0, V3_SIDE_WIN_Y, bh + V3_SIDE_WIN_Z,
                          V3_SIDE_WIN_W, V3_SIDE_WIN_H, ct, palette, true);

    v3_yard_door(V3_YARD_DOOR_X, V3_YARD_DOOR_W, V3_YARD_DOOR_H,
                 V3_PLUG_H + 18 + V3_SILL_H, palette, mesh);
}
```

**Note:** `V3_PLUG_H` was removed in commit `3b1dc40`. Replace `V3_PLUG_H + 18` with `0 + 18 = 18` (bracket level, the new sill_top reference) in the threshold and yard door calls.

- [ ] **Step 2: Update `build.scad`**

Replace the openings block with `if (show_cladding) v3_aabninger(mesh, pal);`.

- [ ] **Step 3: Render and verify** — note: pet/yard door positions may shift slightly down (V3_PLUG_H was 100 mm). Verify visually that doors land on the sill plate.

- [ ] **Step 4: Commit**

```bash
git add designs/v3/build.scad designs/v3/aabninger.scad
git commit -m "v3: extract doors + window into aabninger.scad; drop V3_PLUG_H references"
```

---

### Task A8: Move inventar to `inventar.scad`

**Files:**
- Modify: `designs/v3/inventar.scad`
- Modify: `designs/v3/build.scad`

- [ ] **Step 1: Move `nest_box_insulated` placement, hay/bedding storage cubes, `hay_rack`, `water_bowl`, `food_bowl`, `rabbit`, `rabbit_loaf`, `v3_outdoor_dressing`, `v3_yard_grass` into `v3_inventar`**

```scad
include <../../lib/defaults.scad>
include <config.scad>
use <../../lib/decor/rabbit.scad>
use <../../lib/decor/lighting.scad>
use <../../lib/decor/landscape.scad>
use <../../lib/bom.scad>

// helpers v3_yard_grass, v3_outdoor_dressing (paste verbatim)

module v3_inventar(show_cladding = true, show_ground = true,
                   palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; bh = V3_BASE_H;
    hl = V3_HOUSE_LEN; rl = V3_RUN_LEN; wt = V3_WALL_T;
    ct = 22;

    if (show_ground) {
        v3_yard_grass(hl + ct, rl - ct, ww);
        v3_outdoor_dressing(ll, ww, bh);
    }

    if (show_cladding) {
        nest_box_insulated([V3_NEST_X, V3_NEST_Y, bh + 20],
                           V3_NEST_W, V3_NEST_D, V3_NEST_H, palette);
        color([0.78, 0.72, 0.40])
        translate([wt + 50, wt + 30, bh + 20])
            cube([400, 600, 700]);
        color(pal_panel1(palette))
        translate([wt + 500, wt + 30, bh + 20])
            cube([400, 600, 900]);
        hay_rack(400, ww - wt, bh + 250, 500, 400, palette);
    }

    water_bowl(hl + 600, 1500, 8);
    food_bowl(hl + 850, 1500, 8);
    translate([hl + rl/2 - 100, ww/2 - 350, 18])  rabbit(angle = 30);
    translate([hl + 700, V3_PET_DOOR_Y - 450, 18]) rabbit_loaf(angle = -10);
}
```

- [ ] **Step 2: Replace inventar block in `build.scad` with `v3_inventar(show_cladding, show_ground, pal);`**

- [ ] **Step 3: Render and verify**

- [ ] **Step 4: Commit**

```bash
git add designs/v3/build.scad designs/v3/inventar.scad
git commit -m "v3: extract nest box, bowls, rabbits, dressing into inventar.scad"
```

---

### Task A9: Slim `build.scad` to dispatcher; final baseline match

**Files:**
- Modify: `designs/v3/build.scad`

- [ ] **Step 1: Reduce `build.scad` to a clean dispatcher**

```scad
// v3 build — top-level dispatcher.
// Composes the per-system modules from the role-based files. Each system
// has its own file (fundament, vaegge, tagkonstruktion, beklaedning,
// aabninger, inventar) so the user can review one building system at a
// time. See README.md in this folder for the role of each file.

include <../../lib/defaults.scad>
include <config.scad>

use <fundament.scad>
use <vaegge.scad>
use <tagkonstruktion.scad>
use <beklaedning.scad>
use <aabninger.scad>
use <inventar.scad>
use <../../lib/bom.scad>

module build_v3(show_cladding = true, show_ground = true) {
    bom_header();
    pal  = DEFAULT_PALETTE;
    clad = DEFAULT_CLAD;
    mesh = DEFAULT_MESH;
    stud = DEFAULT_STUD;

    v3_fundament(show_ground, pal);
    v3_vaegge(stud, mesh, pal);
    v3_tagkonstruktion(pal);
    if (show_cladding) v3_beklaedning(clad, pal);
    if (show_cladding) v3_aabninger(mesh, pal);
    v3_inventar(show_cladding, show_ground, pal);
}
```

That's the entire file. ~30 lines.

- [ ] **Step 2: Render all 3 baseline configurations and diff sizes**

```powershell
RENDER -name="post_a9_iso_clad"   -clad=true  -gnd=true
RENDER -name="post_a9_iso_frame"  -clad=false -gnd=true
RENDER -name="post_a9_no_ground"  -clad=false -gnd=false

# Compare file sizes — should be within ~5% of baselines
foreach ($n in "iso_clad","iso_frame","no_ground") {
    $base = (Get-Item "_renders/baseline_phase1/$n.png").Length
    $post = (Get-Item "_renders/post_a9_$n.png").Length
    "$n  baseline=$base  post=$post  delta=$([math]::Round(($post-$base)*100/$base, 1))%"
}
```

Expected: all three deltas within ±5%.

- [ ] **Step 3: Commit**

```bash
git add designs/v3/build.scad
git commit -m "v3: slim build.scad to a pure dispatcher (file split complete)"
```

---

### Task A10: Add `designs/v3/README.md`

**Files:**
- Create: `designs/v3/README.md`

- [ ] **Step 1: Write README**

```markdown
# v3 — Source Layout

Build a 6 × 2.5 m rabbit house + run with a continuous mono-pitch roof.
Each file below covers ONE building system so it can be reviewed alone.

## Build order

```
config.scad                 # constants — read first
build.scad                  # composes the systems below

fundament.scad              # ↓ what the tømrer builds first
vaegge.scad                 # ↓ then this
tagkonstruktion.scad        # ↓ then this
beklaedning.scad            # ↓ then this (visual layer)
aabninger.scad              # ↓ then this (doors / window)
inventar.scad               # last — nest box, bowls, decor
```

## Files

| File | Building system | Key materials |
|---|---|---|
| `config.scad` | Constants & geometry helpers | — |
| `build.scad` | Top dispatcher (~30 lines) | — |
| `fundament.scad` | Fundablok ring + cross-wall + slab/strøer floor + apron | Fundablok 50×20×15, beton, 45×95 PT, 18 mm krydsfiner |
| `vaegge.scad` | All stud walls (house solid + yard mesh frame) | 45×95 reglar, 95 mm bats, vindpapir, 22×95 vindkryds, 45×95 losholter |
| `tagkonstruktion.scad` | Spær + cover layers + sternbrædder + tagrende | 45×95 spær, varies by `roof_cover` |
| `beklaedning.scad` | Klink cladding + afstandsliste + hjørnetrim | 22 mm klinkbrædder + 22×45 lægter |
| `aabninger.scad` | 4 openings: human dør (partition), pet dør, yard dør, sidevindue | Trä karm, hængsler, beslag |
| `inventar.scad` | Nest box, hay rack, bowls, rabbits, outdoor dressing | — |

## Toggles in `main.scad`

- `show_cladding=false` — hide klink, doors, window so the framing is visible
- `show_ground=false` — hide grass / path / yard fill so the foundation is visible
- `roof_cover="tagpap"` — switch tag-dækning between `tagpap`, `stål`, `eternit_10`, `eternit_14`

## Phase 1 spec

`docs/superpowers/specs/2026-05-09-v3-buildable-phase1-design.md`
```

- [ ] **Step 2: Commit**

```bash
git add designs/v3/README.md
git commit -m "v3: add README explaining role of each per-system file"
```

---

## Sub-phase B — BOM `system` column

### Task B1: Add `system` parameter to `bom_member` and `bom_header`

**Files:**
- Modify: `lib/bom.scad`

- [ ] **Step 1: Update signatures**

```scad
module bom_header() {
    if ($bom_mode == true)
        echo("BOM,system,category,species,width_mm,height_mm,length_mm,count,name");
}

module bom_member(category, species, w, h, length, name="", count=1, system="other") {
    if ($bom_mode == true)
        echo(str("BOM,", system, ",", category, ",", species, ",",
                 w, ",", h, ",", length, ",", count, ",", name));
}
```

- [ ] **Step 2: Update the comment block at top**

Replace example CSV column list with the new ordering: `system,category,species,width_mm,height_mm,length_mm,count,name`.

- [ ] **Step 3: Verify v3 BOM still extracts (system column will be "other" for everything)**

```powershell
BOM
Get-Content _renders/v3_bom.csv | Select-Object -First 5
```

Expected: header line ends with `,system,category,...`; rows have `other` in the system column.

- [ ] **Step 4: Commit**

```bash
git add lib/bom.scad
git commit -m "bom: add 'system' column (default 'other') to bom_member"
```

---

### Task B2: Pass `system="fundament"` from `fundament.scad`

**Files:**
- Modify: `designs/v3/fundament.scad`

- [ ] **Step 1: Wrap the bom calls in `v3_fundament` with system tag**

Add after the module's `module v3_fundament(...) {` opening line:

```scad
$_bom_system = "fundament";  // documentation only; not used by bom_member
```

(OpenSCAD's special variables don't propagate through module calls cleanly. The cleanest pattern is to **wrap each bom_member call** in places we control — but since `slab(...)`, `apron_skirt(...)`, etc. are library primitives that emit BOM internally, we can't tag them.)

**Pragmatic fix:** Add a `system=...` parameter to the foundation primitives `slab(...)`, `apron_skirt(...)`, `dpc_strip(...)`, `fundablok_ring(...)` and thread it through. Default to `"fundament"` since these are foundation primitives — BOM rows from these naturally belong to the foundation system.

In `lib/primitives/foundation.scad`, change every `bom_member(...)` call inside `slab`, `apron_skirt`, `dpc_strip`, `interior_floor` to add `system="fundament"`.

In `lib/primitives/fundablok.scad`, do the same.

```scad
// Example: in slab(...)
bom_member("slab", "concrete", sx, sy, base_h, "slab_main", system="fundament");
```

- [ ] **Step 2: Re-extract BOM and verify**

```powershell
BOM
Import-Csv _renders/v3_bom.csv | Group-Object system | Format-Table Name, Count
```

Expected: rows in system "fundament" for all foundation members.

- [ ] **Step 3: Commit**

```bash
git add lib/primitives/foundation.scad lib/primitives/fundablok.scad
git commit -m "bom: tag foundation primitives with system='fundament'"
```

---

### Task B3: Tag wall framing with `system="vaegge"`

**Files:**
- Modify: `lib/primitives/framing.scad`

- [ ] **Step 1:** Add `system="vaegge"` (default) to every `bom_member` call inside `stud_wall`, `stud_wall_sloped`, `framed_opening_y`, `post`, `top_beam_sloped_y`, `top_beam_sloped_x`.

```scad
bom_member("bundrem", "pt-pine", sd, sw, length, "stud_wall", system="vaegge");
```

(Default to "vaegge" since these are wall primitives. v1 and v2 will also tag their walls correctly without further changes.)

- [ ] **Step 2: Tag yard wall calls in `vaegge.scad`** — the `bom_member` calls in `v3_yard_posts_and_sills`, `v3_yard_top_beams`, `v3_yard_stiles` need `system="vaegge"`.

- [ ] **Step 3: Verify**

```powershell
BOM
Import-Csv _renders/v3_bom.csv | Group-Object system | Format-Table Name, Count
```

Expected: most timber rows now in system "vaegge".

- [ ] **Step 4: Commit**

```bash
git add lib/primitives/framing.scad designs/v3/vaegge.scad
git commit -m "bom: tag wall framing primitives + yard placements with system='vaegge'"
```

---

### Task B4: Tag roof primitives with `system="tagkonstruktion"`

**Files:**
- Modify: `lib/primitives/roof.scad`

- [ ] **Step 1:** Add `system="tagkonstruktion"` to every `bom_member` call in `roof_mono_pitch`, `roof_gable_y`, `roof_gable_x`, `ceiling_rafters_mono`, `roof_polycarb_mono`.

(Note: `roof_mono_pitch` doesn't currently emit BOM — that's the polyhedron slab, no real materials. We add BOM in Sub-phase F when the roof becomes layered. For now just tag what exists.)

In `ceiling_rafters_mono`:
```scad
bom_member("rafter", "spruce", rafter_w, rafter_h, rafter_len,
           "ceiling_rafter", system="tagkonstruktion");
```

- [ ] **Step 2: Verify**

```powershell
BOM
Import-Csv _renders/v3_bom.csv | Where-Object system -eq 'tagkonstruktion' | Format-Table
```

Expected: rafter rows tagged.

- [ ] **Step 3: Commit**

```bash
git add lib/primitives/roof.scad
git commit -m "bom: tag roof primitives with system='tagkonstruktion'"
```

---

## Sub-phase C — Beslag library

### Task C1: Create `lib/primitives/beslag.scad` with `ankerskrue_m10`

**Files:**
- Create: `lib/primitives/beslag.scad`

- [ ] **Step 1: Write the file**

```scad
// Beslag (steel connectors) primitives.
//
// Each module renders a simplified galvanised-grey shape and emits a BOM
// row tagged with the appropriate system. The geometry is approximate —
// the primary purpose is to make the connector visible at audit time so
// the user can see WHERE every bracket goes and HOW MANY are needed for
// the shopping list.

include <../defaults.scad>
use <../bom.scad>

BESLAG_COLOR = [0.62, 0.62, 0.66];

// M10 anchor screw, ~120 mm long, head at z=0 (top of fundablok ring),
// shaft sinking into the ring. p = [x, y] on the ring's centerline.
module ankerskrue_m10(p, system="fundament") {
    bom_member("ankerskrue_m10", "steel-galv", 10, 10, 120, "anchor_M10x120", system=system);
    color(BESLAG_COLOR) {
        translate([p[0], p[1], -120]) cylinder(h=120, r=5, $fn=12);          // shaft
        translate([p[0], p[1], 0])    cylinder(h=8,  r1=10, r2=8, $fn=12);   // head
    }
}
```

- [ ] **Step 2: Sanity render**

```powershell
echo "use <lib/primitives/beslag.scad>;`nankerskrue_m10([0,0]);" > _renders/check_beslag.scad
& openscad -o _renders/check_beslag.png _renders/check_beslag.scad 2>&1 | Select-String 'ERROR|WARNING'
```

Expected: no errors.

- [ ] **Step 3: Commit**

```bash
git add lib/primitives/beslag.scad
git commit -m "lib/beslag: add ankerskrue_m10 primitive"
```

---

### Task C2: Add `vinkelbeslag` to `beslag.scad`

**Files:**
- Modify: `lib/primitives/beslag.scad`

- [ ] **Step 1: Append `vinkelbeslag` module**

```scad
// 90×90 mm perforated angle bracket. Two perpendicular legs, 2 mm steel.
// orientation = "+x+z" means leg-1 along +X face, leg-2 along +Z face.
// Origin = inside corner.
module vinkelbeslag(p, leg=90, thick=2, orientation="+x+z", system="vaegge") {
    bom_member("vinkelbeslag", "steel-galv", leg, leg, thick, "BMF90", system=system);
    color(BESLAG_COLOR)
    translate(p)
    if (orientation == "+x+z") {
        cube([leg, thick, thick]);
        cube([thick, thick, leg]);
    } else if (orientation == "-x+z") {
        translate([-leg, 0, 0]) cube([leg, thick, thick]);
        translate([-thick, 0, 0]) cube([thick, thick, leg]);
    } else if (orientation == "+y+z") {
        cube([thick, leg, thick]);
        cube([thick, thick, leg]);
    } else if (orientation == "-y+z") {
        translate([0, -leg, 0]) cube([thick, leg, thick]);
        translate([0, -thick, 0]) cube([thick, thick, leg]);
    }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/primitives/beslag.scad
git commit -m "lib/beslag: add vinkelbeslag (90x90 angle bracket)"
```

---

### Task C3: Add `spaersko` to `beslag.scad`

**Files:**
- Modify: `lib/primitives/beslag.scad`

- [ ] **Step 1: Append `spaersko` module**

```scad
// Sloping rafter shoe (Simpson-type) for 45×W spær on a top plate.
// Origin = bottom-front-left of the rafter at the bearing point.
//   rafter_w   = rafter cross-section thin dimension (typ 45)
//   rafter_h   = rafter cross-section deep dimension (typ 95-145)
//   slope      = rafter slope angle in degrees (negative for falling)
module spaersko(p, rafter_w=45, rafter_h=95, slope=0, system="tagkonstruktion") {
    bom_member("spaersko", "steel-galv", rafter_w + 4, rafter_h, 2,
               "rafter_shoe", system=system);
    color(BESLAG_COLOR)
    translate(p)
    rotate([slope, 0, 0]) {
        // U-cradle: two side cheeks + bottom strap
        translate([-1, 0, 0])              cube([2, rafter_h, rafter_h * 0.6]);  // left cheek
        translate([rafter_w-1, 0, 0])      cube([2, rafter_h, rafter_h * 0.6]);  // right cheek
        translate([-1, 0, 0])              cube([rafter_w + 2, rafter_h, 2]);    // bottom
    }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/primitives/beslag.scad
git commit -m "lib/beslag: add spaersko (rafter shoe)"
```

---

### Task C4: Add `bjaelkesko` to `beslag.scad`

**Files:**
- Modify: `lib/primitives/beslag.scad`

- [ ] **Step 1: Append `bjaelkesko` module**

```scad
// Joist hanger for a beam bearing on a post / partition top plate.
// Origin = bottom-front of the beam at the bearing post.
//   beam_w/h = beam cross-section
module bjaelkesko(p, beam_w=95, beam_h=180, system="vaegge") {
    bom_member("bjaelkesko", "steel-galv", beam_w + 4, beam_h, 2,
               "beam_hanger", system=system);
    color(BESLAG_COLOR)
    translate(p) {
        translate([-1, 0, 0])         cube([2, beam_h, beam_h]);          // left cheek
        translate([beam_w-1, 0, 0])   cube([2, beam_h, beam_h]);          // right cheek
        translate([-1, 0, 0])         cube([beam_w + 2, beam_h, 2]);      // bottom strap
        translate([-1, 0, beam_h])    cube([beam_w + 2, 60, 2]);          // back nail flange
    }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/primitives/beslag.scad
git commit -m "lib/beslag: add bjaelkesko (beam joist hanger)"
```

---

### Task C5: Add `stroesko` to `beslag.scad`

**Files:**
- Modify: `lib/primitives/beslag.scad`

- [ ] **Step 1: Append `stroesko` module**

```scad
// Joist hanger for a 45×95 strø bearing on a ledger or ring face.
// Origin = bottom-front of the strø at the bearing point.
module stroesko(p, joist_w=45, joist_h=95, system="fundament") {
    bom_member("stroesko", "steel-galv", joist_w + 4, joist_h, 2,
               "joist_hanger", system=system);
    color(BESLAG_COLOR)
    translate(p) {
        translate([-1, 0, 0])         cube([2, joist_h, joist_h]);
        translate([joist_w-1, 0, 0])  cube([2, joist_h, joist_h]);
        translate([-1, 0, 0])         cube([joist_w + 2, joist_h, 2]);
    }
}
```

- [ ] **Step 2: Commit**

```bash
git add lib/primitives/beslag.scad
git commit -m "lib/beslag: add stroesko (joist hanger for floor strøer)"
```

---

## Sub-phase D — Strøer floor (replace slab inside ring)

### Task D1: Add floor-system constants to `config.scad`

**Files:**
- Modify: `designs/v3/config.scad`

- [ ] **Step 1: Append constants**

```scad
// House floor (strøer + krydsfiner inside the fundablok ring).
V3_FLOOR_LEDGER_W   = 95;     // ledger bjælke wide along Y/X (face of ring)
V3_FLOOR_LEDGER_H   = 45;     // ledger bjælke height (Z)
V3_FLOOR_LEDGER_Z   = -45;    // top of ledger (= bottom of strøer)
V3_FLOOR_JOIST_W    = 45;
V3_FLOOR_JOIST_H    = 95;
V3_FLOOR_JOIST_C2C  = 600;
V3_FLOOR_DECK_T     = 18;     // krydsfiner thickness
V3_FLOOR_DECK_Z     = V3_FLOOR_LEDGER_Z + V3_FLOOR_JOIST_H;  // top of krydsfiner = +50
```

- [ ] **Step 2: Commit**

```bash
git add designs/v3/config.scad
git commit -m "v3/config: add floor-system constants for strøer + krydsfiner"
```

---

### Task D2: Add `v3_strøer_floor` helper to `fundament.scad`

**Files:**
- Modify: `designs/v3/fundament.scad`

- [ ] **Step 1: Append helper module**

```scad
// Strøer floor inside the house portion of the fundablok ring.
// Ledger bolted to ring's inner face; 45×95 strøer hang in stroesko;
// 18 mm krydsfiner deck on top.
module v3_stroer_floor(palette = DEFAULT_PALETTE) {
    hl = V3_HOUSE_LEN; ww = V3_WIDTH; ring_w = 150;  // FUNDABLOK_W
    inner_x0 = ring_w/2;
    inner_x1 = hl - ring_w/2;
    inner_y0 = ring_w/2;
    inner_y1 = ww - ring_w/2;
    inner_w  = inner_x1 - inner_x0;
    inner_d  = inner_y1 - inner_y0;
    z_ledger = V3_FLOOR_LEDGER_Z;

    // Two ledger bjælker along Y faces (X=inner_x0 and X=inner_x1).
    bom_member("ledger", "pt-pine", V3_FLOOR_LEDGER_W, V3_FLOOR_LEDGER_H,
               inner_d, "floor_ledger", system="fundament", count=2);
    color(pal_post(palette)) {
        translate([inner_x0 - V3_FLOOR_LEDGER_W, inner_y0, z_ledger])
            cube([V3_FLOOR_LEDGER_W, inner_d, V3_FLOOR_LEDGER_H]);
        translate([inner_x1, inner_y0, z_ledger])
            cube([V3_FLOOR_LEDGER_W, inner_d, V3_FLOOR_LEDGER_H]);
    }

    // Strøer span X between ledgers; spaced along Y at V3_FLOOR_JOIST_C2C.
    n_joists = floor(inner_d / V3_FLOOR_JOIST_C2C) + 1;
    joist_z = z_ledger;
    for (i = [0 : n_joists - 1]) {
        y = inner_y0 + i * V3_FLOOR_JOIST_C2C;
        if (y < inner_y1 - V3_FLOOR_JOIST_W/2) {
            bom_member("joist", "pt-pine", V3_FLOOR_JOIST_W, V3_FLOOR_JOIST_H,
                       inner_w, "floor_joist", system="fundament");
            color(pal_post(palette))
            translate([inner_x0, y - V3_FLOOR_JOIST_W/2, joist_z])
                cube([inner_w, V3_FLOOR_JOIST_W, V3_FLOOR_JOIST_H]);
        }
    }

    // 18 mm krydsfiner deck.
    bom_member("krydsfiner", "ply-18mm", inner_w, inner_d, V3_FLOOR_DECK_T,
               "floor_deck", system="fundament");
    color(pal_floor(palette))
    translate([inner_x0, inner_y0, V3_FLOOR_DECK_Z])
        cube([inner_w, inner_d, V3_FLOOR_DECK_T]);
}
```

- [ ] **Step 2: Commit**

```bash
git add designs/v3/fundament.scad
git commit -m "v3/fundament: add v3_stroer_floor helper (ledger + strøer + krydsfiner)"
```

---

### Task D3: Replace `slab` + `interior_floor` with `v3_stroer_floor`

**Files:**
- Modify: `designs/v3/fundament.scad`

- [ ] **Step 1: In `v3_fundament`, remove the `slab(...)`, `interior_floor(...)`, `dpc_strip(...)` calls and add `v3_stroer_floor(palette);`**

Before:
```scad
slab([-ct, -ct], [hl + 2*ct, ww + 2*ct], bh, palette,
     edge_thicken_h = 200, edge_thicken_w = 250);
interior_floor([wt, wt], [hl - 2*wt, ww - 2*wt], bh, 20, palette);
rabbit_floor_grass([wt, wt], [hl - 2*wt, ww - 2*wt], bh);
dpc_strip([0, 0, bh], hl, "X", 95);
... (3 more)
```

After:
```scad
// Floor: 45×95 strøer on ledgers inside the ring; 18 mm krydsfiner deck.
v3_stroer_floor(palette);
rabbit_floor_grass([V3_WALL_T, V3_WALL_T],
                   [hl - 2*V3_WALL_T, ww - 2*V3_WALL_T],
                   bh);  // for visual continuity inside house
```

(`dpc_strip` is no longer needed because the bundrem sits on the ring top, not on a slab.)

- [ ] **Step 2: Render frame view (no cladding) to inspect strøer**

```powershell
RENDER -name="post_d3_iso_frame" -clad=false -gnd=true
```

Expected: when zooming into the house, strøer visible at z≈-45..+50 inside the ring. Krydsfiner deck visible at z=50.

- [ ] **Step 3: Commit**

```bash
git add designs/v3/fundament.scad
git commit -m "v3/fundament: replace slab+interior_floor with strøer-on-ledger floor inside ring"
```

---

### Task D4: Adjust house wall sill / bundrem z-base to ring top

**Files:**
- Modify: `designs/v3/vaegge.scad`

- [ ] **Step 1: In `v3_house_framing`, change `z_sill` from `bh + air_gap` (= 130) to `0 + air_gap = 10`**

```scad
// Wall sill rests on top of the fundablok ring (Z=0). 10 mm air gap
// between bundrem and ring per TIMBER-FRAMING.md (drainage / capillary
// break). Was previously bh+air_gap when the wall sat on a slab.
z_sill   = 10;
z_bp_top = z_sill + sw;
```

- [ ] **Step 2: Render frame and verify wall start z**

```powershell
RENDER -name="post_d4_no_ground" -clad=false -gnd=false
```

Expected: walls start at z=10, with strøer floor at z=-45..+50 nearby. Wall bundrem flush above floor.

- [ ] **Step 3: Commit**

```bash
git add designs/v3/vaegge.scad
git commit -m "v3/vaegge: bundrem now sits on ring top (z=10) instead of slab top"
```

---

### Task D5: Yard sill / bracket z-base also rebases to ring top

**Files:**
- Modify: `designs/v3/vaegge.scad`

- [ ] **Step 1: In `v3_yard_posts_and_sills`, change `z0` (bracket-top) from `18` to `18` (unchanged — bracket already at z=0..18 on the ring)**

Verify `sill_z = 18` still aligns with bracket top. No change needed if values are already correct.

- [ ] **Step 2: In `v3_aabninger`, replace remaining `0 + 18 + V3_SILL_H` (= 63) sill-top reference with explicit constant `V3_YARD_SILL_TOP = 63` from `config.scad`**

Add to `config.scad`:
```scad
V3_YARD_SILL_TOP = 18 + V3_SILL_H;  // bracket top + sill plate height
```

Use it in `v3_aabninger` for door and threshold z-positioning.

- [ ] **Step 3: Render and verify door positions**

- [ ] **Step 4: Commit**

```bash
git add designs/v3/vaegge.scad designs/v3/aabninger.scad designs/v3/config.scad
git commit -m "v3: rebase yard sill/door z-references to V3_YARD_SILL_TOP"
```

---

## Sub-phase E — Wall framing additions

### Task E1: Add 95 mm bats visualisation in `vaegge.scad`

**Files:**
- Modify: `designs/v3/vaegge.scad`

- [ ] **Step 1: Add a `v3_wall_bats(...)` helper that renders a translucent muted-yellow rectangle for each stud bay**

```scad
BATS_COLOR = [0.92, 0.84, 0.55, 0.70];  // muted yellow with alpha
BATS_T     = 95;

// Insulation bats inside a length-by-h stud wall; orientation matches the
// wall's stud-wall axis. Skips bays that are part of openings.
module v3_wall_bats(origin, length, height, axis, sw=45, sd=95, sp=600,
                    skip_ranges=[]) {
    bom_member("bats_95mm", "rockwool", BATS_T, height - 2*sw,
               length, "wall_bats", system="vaegge");
    color(BATS_COLOR)
    if (axis == "X") {
        for (x = [sw : sp : length - sw - sp])
            if (!_in_skip(x + sp/2, skip_ranges))
                translate([origin[0] + x, origin[1], origin[2] + sw])
                    cube([sp - sw, sd, height - 2*sw]);
    } else {
        for (y = [sw : sp : length - sw - sp])
            if (!_in_skip(y + sp/2, skip_ranges))
                translate([origin[0], origin[1] + y, origin[2] + sw])
                    cube([sd, sp - sw, height - 2*sw]);
    }
}
```

(Reuses `_in_skip` from `framing.scad` — must be `use`d there.)

- [ ] **Step 2: Call `v3_wall_bats(...)` for each of the 4 house walls in `v3_house_framing`**

For the front wall:
```scad
v3_wall_bats([0, 0, z_sill], hl, v3_roof_under(0) - z_sill, "X");
```

(repeat for back, left, partition with appropriate dims and skip_ranges).

- [ ] **Step 3: Render with cladding off to inspect**

```powershell
RENDER -name="post_e1_iso_frame" -clad=false -gnd=true
```

Expected: yellow bats fill stud bays.

- [ ] **Step 4: Commit**

```bash
git add designs/v3/vaegge.scad
git commit -m "v3/vaegge: add 95mm bats visualisation in stud bays"
```

---

### Task E2: Add vindpapir layer

**Files:**
- Modify: `designs/v3/vaegge.scad`

- [ ] **Step 1: Add helper `v3_wind_paper(...)` rendering a thin grey membrane on the OUTER face of each wall**

```scad
WIND_PAPER_COLOR = [0.50, 0.50, 0.52];
WIND_PAPER_T     = 1;

module v3_wind_paper(origin, length, height, axis) {
    bom_member("vindpapir", "polyolefin", length, height, WIND_PAPER_T,
               "wind_membrane_m2", system="vaegge");
    color(WIND_PAPER_COLOR)
    if (axis == "X")
        translate(origin) cube([length, WIND_PAPER_T, height]);
    else
        translate(origin) cube([WIND_PAPER_T, length, height]);
}
```

Position outer-face origin at the stud's outer face (sd offset from inner) so the membrane sits between studs and afstandsliste.

- [ ] **Step 2: Call from `v3_house_framing` for each wall, outer side**

- [ ] **Step 3: Commit**

```bash
git add designs/v3/vaegge.scad
git commit -m "v3/vaegge: add vindpapir layer on wall outer faces"
```

---

### Task E3: Add 22×45 afstandsliste

**Files:**
- Modify: `designs/v3/beklaedning.scad` (afstandsliste is in the cladding stack)

- [ ] **Step 1: Add helper `v3_afstandslister(origin, length, height, axis)` that renders vertical 22×45 lægter at stud spacing on the outer face**

```scad
module v3_afstandsliste(origin, length, height, axis, c2c=600) {
    n = floor(length / c2c) + 1;
    bom_member("afstandsliste", "spruce", 22, 45, height,
               "vert_lægte", system="beklaedning", count=n);
    color([0.78, 0.65, 0.45])
    if (axis == "X") {
        for (i = [0 : n-1])
            translate([origin[0] + i*c2c, origin[1], origin[2]])
                cube([45, 22, height]);
    } else {
        for (i = [0 : n-1])
            translate([origin[0], origin[1] + i*c2c, origin[2]])
                cube([22, 45, height]);
    }
}
```

- [ ] **Step 2: Call from `v3_beklaedning` for each cladded wall, between vindpapir and klink**

- [ ] **Step 3: Commit**

```bash
git add designs/v3/beklaedning.scad
git commit -m "v3/beklaedning: add 22x45 vertical afstandsliste behind klink"
```

---

### Task E4: Add losholter (mid-height noggings) per stud bay

**Files:**
- Modify: `designs/v3/vaegge.scad`

- [ ] **Step 1: Add helper `v3_losholter(origin, length, axis, sw=45, sd=95, sp=600, z=1100, skip_ranges=[])`**

```scad
module v3_losholter(origin, length, axis, sw=45, sd=95, sp=600,
                    z_above_origin=1100, skip_ranges=[]) {
    n = floor(length / sp);
    bom_member("losholt", "spruce", sw, sd, sp - sw,
               "wall_nogging", system="vaegge", count=n);
    color([0.86, 0.74, 0.50])
    for (i = [0 : n-1]) {
        a = i * sp + sw;
        b = (i+1) * sp;
        if (!_in_skip((a+b)/2, skip_ranges)) {
            if (axis == "X")
                translate([origin[0] + a, origin[1], origin[2] + z_above_origin])
                    cube([b - a, sd, sw]);
            else
                translate([origin[0], origin[1] + a, origin[2] + z_above_origin])
                    cube([sd, b - a, sw]);
        }
    }
}
```

- [ ] **Step 2: Call from `v3_house_framing` for each house wall**

- [ ] **Step 3: Commit**

```bash
git add designs/v3/vaegge.scad
git commit -m "v3/vaegge: add losholter (45x95 mid-height noggings) per stud bay"
```

---

### Task E5: Add vindkryds (X-bracing) per house wall

**Files:**
- Modify: `designs/v3/vaegge.scad`

- [ ] **Step 1: Add helper `v3_vindkryds(origin, length, height, axis, t=22, w=95)`**

```scad
module v3_vindkryds(origin, length, height, axis, t=22, w=95) {
    diag_len = sqrt(length*length + height*height);
    bom_member("vindkryds", "spruce", t, w, diag_len,
               "x_brace", system="vaegge", count=2);
    color([0.65, 0.55, 0.40])
    translate(origin)
    if (axis == "X") {
        // Two crossing diagonals on the X-Z face, t thick along Y.
        rotate([0, atan2(height, length), 0])
            cube([sqrt(length*length + height*height), t, w], center=false);
        translate([length, 0, 0])
        rotate([0, 180 - atan2(height, length), 0])
            cube([sqrt(length*length + height*height), t, w], center=false);
    } else {
        // Y-Z face wall.
        rotate([atan2(height, length), 0, 0])
            cube([t, sqrt(length*length + height*height), w], center=false);
        translate([0, length, 0])
        rotate([180 - atan2(height, length), 0, 0])
            cube([t, sqrt(length*length + height*height), w], center=false);
    }
}
```

(Geometry is approximate — let-into-stud vs. surface-mounted is implementation choice. For visualisation, surface-mounted is fine.)

- [ ] **Step 2: Call from `v3_house_framing` for each of 5 walls**

- [ ] **Step 3: Render frame view** — should show X marks on each wall.

- [ ] **Step 4: Commit**

```bash
git add designs/v3/vaegge.scad
git commit -m "v3/vaegge: add vindkryds (22x95 X-bracing) per wall"
```

---

### Task E6: Add vinkelbeslag at stud-to-plate connections

**Files:**
- Modify: `designs/v3/vaegge.scad`

- [ ] **Step 1: After each stud is drawn in `v3_house_framing`, add 2 `vinkelbeslag` calls (top and bottom)**

For practicality: don't add to every stud (would clutter render). Add only at corners + jamb studs.

```scad
use <../../lib/primitives/beslag.scad>

// At each corner: 1 vinkelbeslag at bottom + 1 at top (4 corners × 2 = 8).
// Plus 2 at each jamb stud × 4 jambs = 8. Total ~16 in a typical wall.
for (corner_xy = [[0, 0], [hl-sd, 0], [0, ww-sd], [hl-sd, ww-sd]]) {
    vinkelbeslag([corner_xy[0], corner_xy[1], z_sill + sw],
                 orientation="+x+z");
    vinkelbeslag([corner_xy[0], corner_xy[1], v3_roof_under(corner_xy[1]) - sw - 90],
                 orientation="+x+z");
}
```

- [ ] **Step 2: Commit**

```bash
git add designs/v3/vaegge.scad
git commit -m "v3/vaegge: add vinkelbeslag at corner stud-to-plate connections"
```

---

### Task E7: Add ankerskruer M10 along bundrem c/c 1000

**Files:**
- Modify: `designs/v3/fundament.scad`

- [ ] **Step 1: After `fundablok_ring(...)` call, emit ankerskruer along the perimeter**

```scad
use <../../lib/primitives/beslag.scad>

// Ankerskruer M10 c/c 1000 along the perimeter ring's centerline.
// Front + back (X) edges:
for (x = [500 : 1000 : ll - 500]) {
    ankerskrue_m10([x, 0]);          // front
    ankerskrue_m10([x, ww]);         // back
}
// Left + right (Y) edges, plus partition cross-wall:
for (y = [500 : 1000 : ww - 500]) {
    ankerskrue_m10([0, y]);          // left
    ankerskrue_m10([ll, y]);         // right
    ankerskrue_m10([hl, y]);         // partition cross-wall
}
```

- [ ] **Step 2: BOM verify count**

```powershell
BOM
Import-Csv _renders/v3_bom.csv | Where-Object category -eq 'ankerskrue_m10' | Measure-Object | Select-Object Count
```

Expected count: ~17 (5 across front + 5 across back + 2 left + 2 right + 2 partition = 16, plus rounding).

- [ ] **Step 3: Commit**

```bash
git add designs/v3/fundament.scad
git commit -m "v3/fundament: add M10 ankerskruer c/c 1000 along ring + partition"
```

---

## Sub-phase F — Pluggable tagkonstruktion

### Task F1: Add `roof_cover` parameter to `main.scad` and `build_v3`

**Files:**
- Modify: `main.scad`
- Modify: `designs/v3/build.scad`

- [ ] **Step 1: In `main.scad`, add the parameter**

```scad
// Tag-dækning. "tagpap" og "stål" virker på v3's nuværende hældning (9°);
// "eternit_10" og "eternit_14" sænker eh_back automatisk så hældningen
// overholder Cembrit B6's profil.
roof_cover = "tagpap";
```

And update the dispatch:
```scad
if (design == "v3") build_v3(show_cladding=show_cladding, show_ground=show_ground,
                              roof_cover=roof_cover);
```

- [ ] **Step 2: In `build_v3`, accept and forward `roof_cover`**

```scad
module build_v3(show_cladding = true, show_ground = true, roof_cover = "tagpap") {
    ...
    v3_tagkonstruktion(roof_cover, pal);
    ...
}
```

- [ ] **Step 3: Commit**

```bash
git add main.scad designs/v3/build.scad
git commit -m "v3: thread roof_cover parameter from main.scad into v3_tagkonstruktion"
```

---

### Task F2: Add slope-by-cover preset function

**Files:**
- Modify: `designs/v3/config.scad`

- [ ] **Step 1: Add a function that returns the appropriate `eh_back` for a given cover**

```scad
function v3_eh_back_for(cover) =
      cover == "eternit_10" ? 2160     // drop 440, slope 10°
    : cover == "eternit_14" ? 1976     // drop 624, slope 14°
    : V3_EH_BACK;                      // tagpap, stål — keep configured 2200
```

(All other geometry helpers — `v3_total_drop`, `v3_roof_oz`, `v3_roof_under` — should accept eh_back as a parameter or read it via this function.)

For now, refactor the helpers to accept eh_back:
```scad
function v3_total_drop_for(eh_back) =
    (V3_EH_FRONT - eh_back) * v3_span_total() / V3_WIDTH;
function v3_roof_oz_for(eh_back) =
    V3_BASE_H + V3_EH_FRONT + V3_OH_FRONT * v3_total_drop_for(eh_back) / v3_span_total();
function v3_roof_under_for(eh_back, y) =
    v3_roof_oz_for(eh_back) - (V3_OH_FRONT + y) * v3_total_drop_for(eh_back) / v3_span_total();
```

Keep the original `v3_total_drop()`, `v3_roof_oz()`, `v3_roof_under(y)` as wrappers calling the cover-aware versions with `V3_EH_BACK` for backwards compat.

- [ ] **Step 2: Commit**

```bash
git add designs/v3/config.scad
git commit -m "v3/config: add cover-aware roof geometry helpers (v3_eh_back_for, etc.)"
```

---

### Task F3: Add real spær to `tagkonstruktion.scad`

**Files:**
- Modify: `designs/v3/tagkonstruktion.scad`

- [ ] **Step 1: Add `v3_spaer(eh_back, palette)` that emits 45×95 spær c/c 600 from front toprem to back toprem**

```scad
SPAER_W       = 45;
SPAER_H       = 95;
SPAER_C2C     = 600;

module v3_spaer(eh_back, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH; wt = V3_WALL_T;
    z_front = v3_roof_under_for(eh_back, wt) - SPAER_H;
    z_back  = v3_roof_under_for(eh_back, ww - wt) - SPAER_H;
    span_xy = ww - 2 * wt;
    span_3d = sqrt(span_xy * span_xy + (z_front - z_back) * (z_front - z_back));

    n = floor((ll - 2 * 100) / SPAER_C2C) + 1;
    for (i = [0 : n-1]) {
        x = 100 + i * SPAER_C2C;
        bom_member("spær", "spruce", SPAER_W, SPAER_H, span_3d,
                   "monopitch_rafter", system="tagkonstruktion");
        color(pal_post(palette))
        hull() {
            translate([x, wt, z_front])
                cube([SPAER_W, 0.01, SPAER_H]);
            translate([x, ww - wt - 0.01, z_back])
                cube([SPAER_W, 0.01, SPAER_H]);
        }
    }
}
```

- [ ] **Step 2: Commit**

```bash
git add designs/v3/tagkonstruktion.scad
git commit -m "v3/tagkonstruktion: add v3_spaer (45x95 c/c 600 mono-pitch rafters)"
```

---

### Task F4: Add tagpap layer stack

**Files:**
- Modify: `designs/v3/tagkonstruktion.scad`

- [ ] **Step 1: Add `v3_cover_tagpap(eh_back, palette)` that renders forskalling + tagpap on top of the spær**

```scad
module v3_cover_tagpap(eh_back, palette = DEFAULT_PALETTE) {
    ll = V3_LENGTH; ww = V3_WIDTH;
    drop_full = v3_total_drop_for(eh_back);
    roof_oz = v3_roof_oz_for(eh_back);
    area = (ll + V3_OH_SIDE*2) * sqrt(pow(ww + V3_OH_FRONT + V3_OH_BACK, 2) + pow(drop_full, 2)) / 1e6;

    // 22 mm forskalling (raw planks)
    bom_member("forskalling", "spruce", 22, ll + V3_OH_SIDE*2,
               ww + V3_OH_FRONT + V3_OH_BACK,
               str("tagpap_deck_", area, "_m2"), system="tagkonstruktion");
    color([0.74, 0.62, 0.40])
    polyhedron(
        points = [
            [-V3_OH_SIDE, -V3_OH_FRONT, roof_oz - 22],
            [ll + V3_OH_SIDE, -V3_OH_FRONT, roof_oz - 22],
            [ll + V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full - 22],
            [-V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full - 22],
            [-V3_OH_SIDE, -V3_OH_FRONT, roof_oz],
            [ll + V3_OH_SIDE, -V3_OH_FRONT, roof_oz],
            [ll + V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full],
            [-V3_OH_SIDE, ww + V3_OH_BACK, roof_oz - drop_full]
        ],
        faces = [[0,1,2,3], [4,7,6,5], [0,4,5,1], [1,5,6,2], [2,6,7,3], [3,7,4,0]]
    );

    // Tagpap (2-lag) — represented as the existing roof_mono_pitch black slab.
    bom_member("tagpap", "bitumen", 0, 0, 0,
               str("2lag_underpap_svejsepap_", area, "_m2"),
               system="tagkonstruktion");
    roof_mono_pitch([0, 0, roof_oz], ll, ww, drop_full, V3_ROOF_THICK,
                    V3_OH_FRONT, V3_OH_BACK, V3_OH_SIDE, palette);
}
```

- [ ] **Step 2: Commit**

```bash
git add designs/v3/tagkonstruktion.scad
git commit -m "v3/tagkonstruktion: add v3_cover_tagpap (forskalling + 2-lag pap)"
```

---

### Task F5: Add stål layer stack

**Files:**
- Modify: `designs/v3/tagkonstruktion.scad`

- [ ] **Step 1: Add `v3_cover_staal(eh_back, palette)` with undertag + afstandsliste + lægter c/c 600 + trapezstål**

(Mechanically similar to F4 — three thin layers above spær, sloped, with BOM rows for each.)

- [ ] **Step 2: Commit**

```bash
git add designs/v3/tagkonstruktion.scad
git commit -m "v3/tagkonstruktion: add v3_cover_staal (undertag + lægter + trapezstål)"
```

---

### Task F6: Add eternit layer stack

**Files:**
- Modify: `designs/v3/tagkonstruktion.scad`

- [ ] **Step 1: Add `v3_cover_eternit(eh_back, palette)` with undertag + afstandsliste + 38×73 lægter c/c 1085 + Cembrit B6 8 mm**

- [ ] **Step 2: Commit**

```bash
git add designs/v3/tagkonstruktion.scad
git commit -m "v3/tagkonstruktion: add v3_cover_eternit (undertag + lægter + Cembrit B6)"
```

---

### Task F7: Wire `v3_tagkonstruktion(roof_cover)` to dispatch covers

**Files:**
- Modify: `designs/v3/tagkonstruktion.scad`

- [ ] **Step 1: Replace `v3_tagkonstruktion(palette)` with cover-aware dispatch**

```scad
module v3_tagkonstruktion(roof_cover = "tagpap", palette = DEFAULT_PALETTE) {
    eh_back = v3_eh_back_for(roof_cover);

    // Spær — same regardless of cover.
    v3_spaer(eh_back, palette);

    // Cover layers.
    if (roof_cover == "tagpap")           v3_cover_tagpap(eh_back, palette);
    else if (roof_cover == "stål")        v3_cover_staal(eh_back, palette);
    else if (roof_cover == "eternit_10")  v3_cover_eternit(eh_back, palette);
    else if (roof_cover == "eternit_14")  v3_cover_eternit(eh_back, palette);
    else assert(false, str("unknown roof_cover: ", roof_cover));

    // Sternbrædder + tagrende.
    fascia_and_gutter_mono([0, 0, v3_roof_oz_for(eh_back)],
                           V3_LENGTH, V3_WIDTH, v3_total_drop_for(eh_back),
                           150, 22, V3_OH_FRONT, V3_OH_BACK, V3_OH_SIDE,
                           110, 65, 0, palette);

    // Loftspær (visible) inside the house.
    rafter_eave_h = v3_roof_under_for(eh_back, V3_WALL_T);
    rafter_drop = v3_roof_under_for(eh_back, V3_WALL_T)
                - v3_roof_under_for(eh_back, V3_WIDTH - V3_WALL_T);
    ceiling_rafters_mono([0, 0, 0], V3_LENGTH, V3_WIDTH,
                         rafter_drop, rafter_eave_h,
                         900, 45, 140, V3_WALL_T, palette,
                         x_inset = V3_WALL_T + 55);
}
```

- [ ] **Step 2: Render with each cover and verify**

```powershell
foreach ($c in "tagpap","stål","eternit_10","eternit_14") {
    & openscad -o "_renders/cover_$c.png" --imgsize=1600,1100 `
        --camera=3000,1250,1300,55,0,25,16000 `
        -D 'design="v3"' -D show_cladding=true -D show_ground=true `
        -D "roof_cover=`"$c`"" main.scad
}
```

Expected: 4 PNG files. tagpap and stål have identical eaves; eternit_10 and eternit_14 are progressively lower at the back.

- [ ] **Step 3: Commit**

```bash
git add designs/v3/tagkonstruktion.scad
git commit -m "v3/tagkonstruktion: dispatch cover layers by roof_cover parameter"
```

---

### Task F8: Add spaersko at each spær end

**Files:**
- Modify: `designs/v3/tagkonstruktion.scad`

- [ ] **Step 1: In `v3_spaer`, add `spaersko(...)` calls at front and back ends of each spær**

```scad
use <../../lib/primitives/beslag.scad>

// (inside the for-loop)
spaersko([x, wt - 2, z_front], SPAER_W, SPAER_H, slope=0);
spaersko([x, ww - wt - SPAER_H + 2, z_back], SPAER_W, SPAER_H, slope=0);
```

- [ ] **Step 2: Commit**

```bash
git add designs/v3/tagkonstruktion.scad
git commit -m "v3/tagkonstruktion: add spaersko at each spær bearing point"
```

---

## Sub-phase G — Audit renders + comparison script

### Task G1: Add `scripts/audit_renders.ps1`

**Files:**
- Create: `scripts/audit_renders.ps1`

- [ ] **Step 1: Write the script**

```powershell
# Render all per-system audit views into _renders/v3/audit/
# Usage: pwsh scripts/audit_renders.ps1

$ErrorActionPreference = "Stop"
$env:Path += ";C:\Program Files\OpenSCAD"
$out = "_renders/v3/audit"
New-Item -ItemType Directory -Force -Path $out | Out-Null

$renders = @(
    @{name="01_fundament";          clad="false"; gnd="false"; cam="3000,1250,400,75,0,25,12000"},
    @{name="02_vaegge_frame";       clad="false"; gnd="true";  cam="3000,1250,1300,55,0,25,16000"},
    @{name="03_vaegge_isolering";   clad="false"; gnd="false"; cam="3000,1250,1300,55,0,25,16000"},
    @{name="04_tagkonstruktion_pap"; cover="tagpap";  clad="false"; gnd="true";  cam="3000,1250,1500,235,0,25,16000"},
    @{name="05_tagkonstruktion_stål"; cover="stål";   clad="false"; gnd="true";  cam="3000,1250,1500,235,0,25,16000"},
    @{name="06_tagkonstruktion_eternit10"; cover="eternit_10"; clad="false"; gnd="true";  cam="3000,1250,1500,235,0,25,16000"},
    @{name="07_beklaedning";        clad="true";  gnd="true";  cam="3000,1250,1300,55,0,25,16000"},
    @{name="08_aabninger";          clad="true";  gnd="true";  cam="3000,1250,1300,55,0,160,8000"},
    @{name="09_inventar";           clad="true";  gnd="true";  cam="800,1250,1000,75,0,90,4000"},
    @{name="10_fuld_iso";           clad="true";  gnd="true";  cam="3000,1250,1300,55,0,25,16000"}
)

foreach ($r in $renders) {
    $args = @(
        "-o", "$out/$($r.name).png",
        "--imgsize=1600,1100",
        "--colorscheme=Tomorrow",
        "--camera=$($r.cam)",
        "-D", "design=`"v3`"",
        "-D", "show_cladding=$($r.clad)",
        "-D", "show_ground=$($r.gnd)"
    )
    if ($r.cover) { $args += "-D"; $args += "roof_cover=`"$($r.cover)`"" }
    $args += "main.scad"
    & openscad $args 2>&1 | Out-Null
    Write-Host "✓ $($r.name)"
}
```

- [ ] **Step 2: Run it**

```powershell
pwsh scripts/audit_renders.ps1
```

Expected: 10 PNG files in `_renders/v3/audit/`.

- [ ] **Step 3: Commit**

```bash
git add scripts/audit_renders.ps1
git commit -m "scripts: add audit_renders.ps1 for per-system v3 audit views"
```

---

### Task G2: Add `scripts/compare_roof_options.ps1`

**Files:**
- Create: `scripts/compare_roof_options.ps1`

- [ ] **Step 1: Write the script**

```powershell
# Render & BOM-extract for each roof_cover; print a comparison table.
$ErrorActionPreference = "Stop"
$env:Path += ";C:\Program Files\OpenSCAD"
$out = "_renders/v3/roof_compare"
New-Item -ItemType Directory -Force -Path $out | Out-Null

$covers = "tagpap","stål","eternit_10","eternit_14"

foreach ($c in $covers) {
    & openscad -o "$out/$c.png" --imgsize=1200,800 --colorscheme=Tomorrow `
        --camera=3000,1250,1300,55,0,25,16000 `
        -D 'design="v3"' -D show_cladding=false -D show_ground=true `
        -D "roof_cover=`"$c`"" main.scad 2>&1 | Out-Null

    & openscad -o "$out/$c.bom.png" -D 'design="v3"' -D '$bom_mode=true' `
        -D "roof_cover=`"$c`"" main.scad 2>&1 |
        Select-String '"BOM,' |
        ForEach-Object { ($_.Line -replace 'ECHO: "', '' -replace '"$', '') } |
        Out-File -Encoding utf8 "$out/$c.csv"
}

# Aggregate: count tagkonstruktion rows per cover
"`nRoof cover comparison"
"="*60
foreach ($c in $covers) {
    $bom = Import-Csv "$out/$c.csv" | Where-Object system -eq 'tagkonstruktion'
    "{0,-15} {1,3} BOM rows" -f $c, $bom.Count
}
```

- [ ] **Step 2: Run it**

```powershell
pwsh scripts/compare_roof_options.ps1
```

- [ ] **Step 3: Commit**

```bash
git add scripts/compare_roof_options.ps1
git commit -m "scripts: add compare_roof_options.ps1 to diff BOM across roof covers"
```

---

## Sub-phase H — Documentation updates

### Task H1: Update CLAUDE.md

**Files:**
- Modify: `CLAUDE.md`

- [ ] **Step 1: Update the v3 paragraph and Layout block**

In the Layout block, expand `v3/{config,build}.scad` to list the new files:
```
v3/{config,build,fundament,vaegge,tagkonstruktion,beklaedning,aabninger,inventar}.scad
```

In the v3 paragraph, mention:
- New `roof_cover` parameter ("tagpap" | "stål" | "eternit_10" | "eternit_14")
- Floor is now strøer + krydsfiner inside the ring (was slab)
- Yard right-end corners are 45×95 reglar (already done) on brackets on the ring

- [ ] **Step 2: Commit**

```bash
git add CLAUDE.md
git commit -m "docs: update CLAUDE.md for v3 file split + roof_cover + strøer floor"
```

---

### Task H2: Update TIMBER-FRAMING.md

**Files:**
- Modify: `TIMBER-FRAMING.md`

- [ ] **Step 1: Update the "Standard Dimensions" table**

Drop the 95×95 / 70×70 mentions; standardise on 45×95 reglar throughout. Add a row for the new spær 45×95 c/c 600.

Add a new section "Beslag (connectors)" listing the 5 beslag types from `lib/primitives/beslag.scad` with their typical Simpson/BMF part numbers.

- [ ] **Step 2: Commit**

```bash
git add TIMBER-FRAMING.md
git commit -m "docs: update TIMBER-FRAMING.md for 45x95-only convention + beslag list"
```

---

### Task H3: Mark Phase 1 spec as implemented

**Files:**
- Modify: `docs/superpowers/specs/2026-05-09-v3-buildable-phase1-design.md`

- [ ] **Step 1: Change `**Status:** Awaiting user review` to `**Status:** Implemented (commit <hash>)`**

Replace `<hash>` with the latest Sub-phase H commit hash after running `git log -1 --format=%h`.

- [ ] **Step 2: Commit**

```bash
git add docs/superpowers/specs/2026-05-09-v3-buildable-phase1-design.md
git commit -m "docs: mark v3 Phase 1 spec as implemented"
```

---

## Self-review

After writing the plan above, scanning for issues:

**1. Spec coverage** — every spec section has at least one task:

| Spec section | Tasks |
|---|---|
| §1 Geometry baseline | already done in commit `e1c68af` |
| §2 File reorganisation | A1–A10 |
| §3 Fundament | A3, B2, D1–D5, E7 |
| §4 Vægge | A4, B3, D4, E1, E2, E4, E5, E6 |
| §5 Tagkonstruktion | A5, B4, F1–F8 |
| §6 Beklædning | A6, E3 |
| §7 Åbninger | A7 |
| §8 Inventar | A8 |
| §9 Beslag library | C1–C5 |
| §10 BOM system column | B1–B4 |
| §11 Verifikation | G1, G2, all task render-checks, H3 |

**2. Placeholder scan** — looked for "TBD", "TODO", "implement later", "fill in details", "add appropriate", "similar to". The only "TODO" reference is one **explicit, intentional** marker in Task A3's code about replacing `ct = 22` with `cs_thick(clad)` later — left as the implementation engineer's note.

**3. Type/name consistency:**
- `bom_member` signature stable: `(category, species, w, h, length, name="", count=1, system="other")` once Task B1 lands
- Module names consistent: `v3_fundament`, `v3_vaegge`, `v3_tagkonstruktion`, `v3_beklaedning`, `v3_aabninger`, `v3_inventar`
- Roof helpers: `v3_eh_back_for(cover)`, `v3_total_drop_for(eh_back)`, `v3_roof_oz_for(eh_back)`, `v3_roof_under_for(eh_back, y)` — all `_for(eh_back)` suffix consistent

---
