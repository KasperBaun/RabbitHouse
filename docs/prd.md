# Rabbit House — Product Requirements Document

## 1. Vision

A garden structure that gives a bonded pair of pet rabbits a safe, enriched,
all-weather home.

The build is modelled in OpenSCAD (`main.scad`) and parameterised across three
size presets in `presets.scad`. This PRD defines the *why* behind the model;
the atomic *what* lives in [`requirements.md`](requirements.md) as `REQ-NNN`
items, cited from this document.

## 2. Goals

- **G1.** Rabbits express natural behaviours 24/7 — hopping, standing upright,
  digging, hiding, jumping up — without ever being shut into a small hutch.
  (REQ-001, REQ-002, REQ-005, REQ-006, REQ-007)
- **G2.** A bonded pair (or two pairs) live safely outdoors year-round in a
  Nordic climate. (REQ-015 to REQ-021)
- **G3.** The structure looks intentional in the garden — built shell,
  cladded back wall, gutter line — not a wire mess on the lawn.
- **G4.** Maintenance fits a 15-minute daily routine for one adult.
  (REQ-034 to REQ-037)

## 3. Non-goals

- Indoor / inside-the-house rabbit housing.
- Breeding or multi-litter colony housing.
- Commercial or farm-scale rabbit production.
- Permanent isolation pens for sick or quarantined animals (a vet trip and a
  carrier handle that case).
- A hutch that only gets opened for "exercise time" — RWAF guidance is
  explicit that this is no longer acceptable.
- A human seating, lounge, or co-occupied space sharing the structure. That
  was v1 scope and has been removed; the v2 right-side zone is a rabbit run.

## 4. Users

| User | Primary needs |
|------|---------------|
| **Garden owner with one bonded pair**, mid-skill DIY | Safe rabbits, easy daily care, garden that still looks like a garden |
| **Rabbit sitter** during owner absence | Walk-in access, obvious feeding/cleaning routine, predator-proof perimeter she can verify by eye |
| **Vet** doing a home visit | Possible to capture and inspect a rabbit without dismantling anything |

## 5. Size presets

Defined in `presets.scad` and selected in `config.scad` via `preset`.

| Preset | Length × Width × Height | Rabbit-zone length | Notes |
|--------|-------------------------|--------------------|-------|
| `6x3` | 6.0 × 3.0 × 2.5 m | 3.3 m | Tight gardens, 1 bonded pair |
| `7x3` | 7.0 × 3.0 × 2.5 m | 4.0 m | **Default.** 1 bonded pair, generous interior space |
| `8x4` | 8.0 × 4.0 × 2.5 m | 4.5 m | Largest preset; room to scale toward two bonded pairs |

All three presets give the rabbit zone alone more than the RWAF
3.0 × 2.0 × 1.0 m absolute minimum (REQ-001), with substantial vertical
clearance for standing upright (REQ-002).

## 6. Layout principles

Two designs now coexist in the model — `lean_to_v1` (the original) and
`house_yard_v2` (the gabled-house + polycarb-run redesign). Both share these
directional decisions, with design-specific zoning overlaid on top.

- **Front** (`Y = 0`) is the open mesh face onto the garden / human entry.
- **Back** (`Y = width`) is the solid cladded wall, taking prevailing-wind
  and driving-rain duty (REQ-016).
- **Left** (`X = 0`), **Right** (`X = length`).

### `lean_to_v1` zoning

- Mono-pitch roof; left side X=0..`rabbit_len` is the rabbit zone, right
  side is a human seating area. Sluice sits on the divider between rabbit
  zone and seating zone.

### `house_yard_v2` zoning

- Left X=0..2000 is a solid gabled rabbit shelter:
  - Front-left corner (X=0..1000, Y=0..1000) is the airlock + bedding
    storage cell, with the only outside human door on its Y=0 face.
  - Insulated nest box against the back wall in the rest-of-house space.
  - High gable louver vent (X=0 face) + low back vent for cross-ventilation.
- Right X=2000..6000 is a mesh-walled rabbit run with a translucent
  polycarbonate roof:
  - Mesh on front (Y=0) and right (X=length) walls; back wall solid clad
    with a high vent strip; left wall is the partition gable.
  - Run roof slopes front-high to back-low, draining to the back gutter.
  - Buried apron skirt 500 mm wide on the three exterior sides for dig
    defeat.
- House↔run rabbit pet door at X=2000, low at Y≈1500 — permanently passable
  so the combined enclosure satisfies REQ-001.
- The two-stage human airlock (outer door on the front, inner door at
  Y=`airlock_d`) is the only human entry into the rabbit zone (REQ-011).

## 7. Constraints

- **Climate:** northern European temperate; design points: winter low ≈ −10 °C,
  summer high ≈ 30 °C, snow load ≥ 1.0 kN/m². (REQ-018, REQ-019, REQ-020)
- **Construction:** hobbyist DIY tools; lumber sized to standard metric stock
  (so wall_thickness, base_height, etc. round to buildable numbers).
- **Materials:** must satisfy the toxicity rules in section F of
  `requirements.md` — no pressure-treated wood in chew range, GAW or
  vinyl-coated mesh, cured paints only.
- **Site:** assumes a private garden. The rabbit zone must function even with
  no power available.

## 8. Success criteria

The build is "done" — by the standards this PRD cares about — when:

1. The rabbits have continuous access to ≥ 3 × 2 × 1 m and can demonstrably
   take 3 hops + stand upright. (REQ-001, REQ-002)
2. The perimeter survives a deliberate fox / cat / rat probe test:
   no aperture > 12 mm, no dig-under, no reach-through. (REQ-008 to REQ-013)
3. The sleeping-zone interior stays between 5 °C and 25 °C across the year
   with seasonal bedding adjustment. (REQ-019, REQ-020)
4. One adult cleans the rabbit zone in ≤ 15 minutes from a cold start.
   (REQ-036)

## 9. Risks & mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Predator digs under the perimeter | Medium | Fatal | Buried skirt or 500 mm apron — REQ-009 |
| Summer heat stroke (rabbits decline > 25 °C) | Medium | Fatal | Shade + cross-ventilation — REQ-019, REQ-022, REQ-023 |
| Mesh too coarse; rat or cat reaches in | Low if specced right | Fatal | 25 × 13 mm × 19 g hardware cloth — REQ-008 |
| Wood-treatment poisoning | Low if specced right | Severe | Material spec — REQ-029, REQ-030 |
| Snow load on lean-to roof | Low | Severe | Engineered to 1.0 kN/m² — REQ-018 |
| Owner absence | Certain (holidays) | Mild | Sitter-friendly walk-in + 15-min routine — REQ-034, REQ-036 |
| Mesh tacker staples pulled by fox | Medium | Fatal | Screwed staples / wire ties — REQ-014 |
| Building permit issue post-build | Medium for `8x4` (32 m²) | Severe | Confirm permit before pouring foundation — REQ-046, REQ-047 |

## 10. Open questions

- **Site orientation:** which façade faces the prevailing wind on the actual
  plot? That decides which side stays solid-cladded vs. meshed.
- **Headcount growth:** is the long-term plan one bonded pair, or two? If
  two, the `8x4` preset is the safer default.
- ~~**Right-zone purpose (v2):** what replaces the v1 human seating area?~~
  Resolved 2026-04-29 — the v2 right-side zone is a 4 m × 3 m mesh-walled
  rabbit run with a translucent polycarbonate roof, attached to a 2 m × 3 m
  gabled solid shelter. See `docs/superpowers/specs/2026-04-29-multi-design-refactor-and-house-yard-v2.md`.
- **Power:** is mains routed to the structure, or is lighting on a solar /
  battery loop? Affects routing in `modules/lighting.scad`.
- **Foundation:** slab, piers, or paver-on-gravel? Drives REQ-021 and
  REQ-027.
- **Run extension:** does the rabbit zone exit into a larger fenced run on
  the lawn for daytime grazing? If yes, REQ-008..REQ-013 apply to that run
  too.

## 11. References

- RWAF — Space Recommendations: https://rabbitwelfare.co.uk/space-recommendations/
- RWAF — Outdoor Housing: https://rabbitwelfare.co.uk/outdoor-housing/
- RSPCA — Rabbits' Housing Needs (2018): https://www.rspca.org.uk/documents/1494939/7712578/RSPCA+Rabbit+housing+advice+-+updated+May+2018+(on+website).pdf
- The Rabbit House — Wire Mesh Guide: https://www.therabbithouse.com/outdoor/rabbit-mesh.asp
- RSPCA Australia — Where should I keep my rabbits?: https://kb.rspca.org.au/knowledge-base/where-should-i-keep-my-rabbits/
