# Rabbit House — Requirements

One-line, ID-traceable requirements for the rabbit-house build modelled in this repo.
Each `REQ-NNN` is atomic so it can be cited from the PRD, code comments, or build notes.
Where a number is grounded in an external welfare standard, the source is cited inline.

Conventions:
- IDs are stable; never renumber. Add new ones at the end of their section.
- "Rabbit zone" = the meshed enclosure on the left/front (`rabbit_x0`..`rabbit_x1`).
- "Sleeping zone" = the insulated nest box / shelter inside the rabbit zone.

## A. Animal welfare & space

- **REQ-001** — The rabbit zone must give the rabbits continuous 24/7 access to a connected enclosure of at least 3.0 m × 2.0 m × 1.0 m. (src: RWAF minimum)
- **REQ-002** — The rabbit zone must allow each rabbit to take three full hops in a straight line and to stand fully upright on its hind legs without head contact. (src: RWAF)
- **REQ-003** — The structure must house at least one bonded pair; rabbits must never be kept singly in this build.
- **REQ-004** — The rabbit zone must provide separated functional areas for sleeping, eating, drinking, and toileting.
- **REQ-005** — At least one hiding shelter must be available per rabbit, plus one spare (the "n+1" rule), permanently accessible.
- **REQ-006** — The rabbit zone must include at least one elevated platform or lookout the rabbits can jump onto, for vertical enrichment.
- **REQ-007** — A safe digging substrate (sand pit or soil tray) must be available so the rabbits can dig without compromising the perimeter.

## B. Predator protection

- **REQ-008** — All boundaries between the rabbit zone and the outside world must be covered with welded wire mesh of aperture ≤ 25 mm × 13 mm and gauge ≥ 19 (≈ 1.0 mm wire). (src: The Rabbit House, RWAF)
- **REQ-009** — The rabbit-zone perimeter must defeat burrowing predators, either by a buried wire skirt ≥ 300 mm deep or a horizontal apron ≥ 500 mm wide pinned at ground level.
- **REQ-010** — Every gate, hatch, and door into the rabbit zone must use a two-stage lockable latch that resists raccoon, fox, and child opening.
- **REQ-011** — The sluice must operate as an airlock: the inner door and outer door must never be open simultaneously.
- **REQ-012** — The roof above the rabbit zone must fully enclose against aerial predators (hawks, owls) and climbing predators (cats, martens, rats).
- **REQ-013** — No mesh aperture, edge gap, or trim seam in the rabbit zone may exceed 12 mm at any point.
- **REQ-014** — Mesh must be fastened with screwed staples or wire, not stapled with a tacker, on faces a fox can pull at.

## C. Weather & climate (Nordic / temperate-maritime)

- **REQ-015** — The structure must shelter the rabbits from wind, driving rain, direct sun, and snow at all hours of the year.
- **REQ-016** — The sleeping zone must remain dry and draught-free during sustained west-/south-westerly wind and rain.
- **REQ-017** — The roof and overhangs must shed water away from every wall and away from the sleeping zone.
- **REQ-018** — The roof must support a snow load of at least 1.0 kN/m² without deflection, consistent with Nordic minimums.
- **REQ-019** — At least one shaded sub-zone with internal air temperature ≤ 25 °C must exist in the rabbit area at all summer hours; rabbits suffer heat stress above 25 °C.
- **REQ-020** — The build must include an insulated, draught-free nest box usable down to −10 °C ambient.
- **REQ-021** — The foundation must lift the floor ≥ 100 mm above finished grade to keep the floor dry in heavy rain. (existing: `base_height = 120 mm` — meets this.)

## D. Ventilation & air quality

- **REQ-022** — The rabbit zone must support continuous cross-ventilation without exposing the sleeping zone to direct draught. (src: RSPCA)
- **REQ-023** — High and low ventilation openings must exist on opposite walls so warm, ammonia-laden air can rise out and fresh air can replace it.
- **REQ-024** — No part of the rabbit zone may depend on a single closable opening as its only air exchange.

## E. Floor, drainage & substrate

- **REQ-025** — Surface water inside the rabbit zone must drain so no puddle persists more than 30 minutes after heavy rain.
- **REQ-026** — The site must slope (or be regraded to slope) away from the structure at ≥ 1:50 on all sides.
- **REQ-027** — The rabbit floor must be dig-proof: a solid slab, a buried mesh layer, or a wire base under any loose substrate.
- **REQ-028** — Every substrate in rabbit contact must be non-toxic, low-dust, and chew-safe.

## F. Materials & toxicity

- **REQ-029** — No pressure-treated, CCA-treated, or creosoted wood may be used anywhere a rabbit can chew, lick, or rub against it.
- **REQ-030** — All paints, stains, and sealants in the rabbit zone must be fully cured, food-safe, and free of lead, solvent VOCs, and zinc-rich primers in chew range.
- **REQ-031** — All mesh in the rabbit zone must be galvanised-after-welding (GAW) or vinyl-coated, with cut edges deburred or capped to remove zinc flakes and burrs.
- **REQ-032** — Any insulation reachable by rabbits must sit behind a chew-proof inner skin.
- **REQ-033** — No plant from the rabbit-toxic list (yew, oleander, foxglove, lily, ivy, rhododendron, laburnum) may grow within the rabbit zone or overhang it.

## G. Maintenance & human access

- **REQ-034** — A human must be able to walk fully upright into the rabbit zone through a door ≥ 800 mm wide and ≥ 1900 mm high. (existing sluice: 800 × 2100 mm — meets this.)
- **REQ-035** — Every surface inside the rabbit zone must tolerate hosing and standard pet-safe disinfectant for daily cleaning.
- **REQ-036** — Daily droppings clean-up and food/water refill must be achievable by one adult in ≤ 15 minutes.
- **REQ-037** — A removable or hinged-access tray, panel, or floor section must exist beneath any zone where droppings concentrate.
- **REQ-038** — All lighting fixtures and electrical cabling inside the rabbit zone must be either out of rabbit reach or shielded behind chew-proof conduit.

## H. Reserved (former human seating area)

The original Section H covered a human seating area included in the v1
design. That scope was removed in the v2 redesign. IDs `REQ-039` through
`REQ-042` remain reserved and will not be reused.

## H2. House-yard v2 (gabled shelter + polycarbonate run)

Added 2026-04-29 alongside the introduction of the `house_yard_v2` design.
The v2 right-side zone is no longer a human area — it is a 4 m × 3 m
mesh-walled rabbit run with a translucent roof, attached to a 2 m × 3 m
solid gabled rabbit shelter on the left.

- **REQ-049** — The airlock vestibule must double as bedding/hay storage and provide ≥ 0.5 m³ usable storage volume.
- **REQ-050** — The transparent run roof must be ≥ 10 mm twin-wall polycarbonate, UV-stable, and fixed with chew/pry-resistant fasteners that defeat the same predator load as REQ-008/REQ-012.
- **REQ-051** — The pet door in the house↔run partition must remain permanently passable; it is not a sluice and must not be lockable in service. The combined house+run is the rabbit zone of REQ-001.
- **REQ-052** — The house roof ridge runs along the X axis at Y=`width`/2; gable end walls are at X=0 and X=2000, both cladded as triangles. The X=2000 partition gable is the wind-bracing wall the run roof leans against. Eaves run along X at Y=0 (front) and Y=`width` (back).
- **REQ-053** — The run roof must drain to a gutter on the back (Y=`width`) edge; no water may discharge against the partition at X=2000.

## H3. House-yard v3 (unified mono-pitch + ground-plug yard)

Added 2026-05-03 alongside the introduction of the `house_yard_v3` design.
v3 keeps the v2 zoning (2 m × 3 m solid house + 4 m × 3 m mesh yard) but
replaces the gabled shelter and translucent run roof with **one continuous
mono-pitch roof** spanning the entire footprint, and replaces the v2 full
slab with a **slab-under-house-only + ground-plug-yard** foundation.

Updated 2026-05-04: human entry was rerouted through the yard (REQ-059..062),
and yard exterior siding was specified as mesh-only (no clad strip).

- **REQ-054** — A single mono-pitch roof must span the entire 6 m × 3 m
  footprint (house + yard) with no break at the partition. Drop runs
  front-to-back; the drainage gutter sits on the back (Y=`width`) eave.
- **REQ-055** — The concrete slab must extend ONLY under the house
  (X=0..`house_len`); the yard floor must remain natural ground.
- **REQ-056** — Yard corner posts must transfer load through concrete
  ground plugs (not the slab); each plug sits at least 40 mm below
  grade and 100 mm proud, with a steel post-base bracket isolating
  wood from soil moisture.
- **REQ-057** — The yard interior must be live grass at grade, with
  predator-proofing achieved by the perimeter buried apron skirt
  (REQ-009) — no buried mesh layer is required under the yard floor.
- **REQ-058** — Reserved (former back-wall driving-rain clad strip;
  removed in 2026-05-04 revision in favour of full-height mesh).
- **REQ-059** — The exterior of all three yard walls (front, back,
  right) must be welded-wire mesh only, with no klink-board cladding
  on any yard exterior face. Mesh must meet REQ-008 aperture/wire
  requirements (≤ 25 × 13 mm aperture, ≥ 1 mm wire).
- **REQ-060** — Vertical wood stiles (≈ 60 × 60 mm) must divide the
  mesh walls into approximately 1 m panels for structural rigidity
  and constructible mesh-stretching. The yard mesh door's own L/R
  frame stiles count toward this 1 m rhythm on the front wall.
- **REQ-061** — Human entry to the house must be through the yard:
  an exterior mesh door in the yard front (Y=0) leads into the yard,
  and a separate solid human door in the partition (X=`house_len`)
  leads from the yard into the house. The house has no door on its
  outside face (Y=0).
- **REQ-062** — REQ-011 (airlock semantics) is satisfied by the
  yard-as-vestibule: the yard mesh door is the "outer" stage and the
  partition human door is the "inner" stage, and they must not be
  open simultaneously when rabbits are unconfined in the yard.

## I. Safety

- **REQ-043** — No element reachable by rabbits or humans may have a sharp edge, exposed nail, splinter, or pinch point.
- **REQ-044** — All hinges, latches, and fasteners exposed to weather must be rated for outdoor use and remain free-moving for at least 5 years.
- **REQ-045** — No swallowable loose parts (screws, staples, wire offcuts) may be left in the rabbit zone after construction.

## J. Site, regulation & longevity

- **REQ-046** — Footprint and height must comply with the local jurisdiction's rules for unattached outbuildings before construction begins (in DK, sheds > 10 m² generally need a permit).
- **REQ-047** — The structure must respect the locally required setback distance from neighbouring property lines.
- **REQ-048** — The build must remain serviceable for ≥ 10 years with annual maintenance; every wear part (mesh, latches, lighting) must be replaceable without dismantling structural framing.

## References

- RWAF — Space Recommendations: https://rabbitwelfare.co.uk/space-recommendations/
- RWAF — Outdoor Housing: https://rabbitwelfare.co.uk/outdoor-housing/
- RSPCA — Rabbits' Housing Needs (2018): https://www.rspca.org.uk/documents/1494939/7712578/RSPCA+Rabbit+housing+advice+-+updated+May+2018+(on+website).pdf
- The Rabbit House — Wire Mesh Guide: https://www.therabbithouse.com/outdoor/rabbit-mesh.asp
- RSPCA Australia — Where should I keep my rabbits?: https://kb.rspca.org.au/knowledge-base/where-should-i-keep-my-rabbits/
