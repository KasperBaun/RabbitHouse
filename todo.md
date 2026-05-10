# Todo

1. ~~fundament.scad og fundament.md~~
2. ~~konstruktions-skelet.scad og konstruktions-skelet.md (murpap, bundrem, reglar, toprem)~~
3. ~~aabninger.scad og aabninger.md (døre og vinduer)~~
4. beklaedning.scad og beklaedning.md (vindpap, klemmelister, klink beklædning i huset, voliernet i løbegården)
5. ~~tagkonstruktion.scad og tagkonstruktion.md~~ (to cover-systemer: tagpap_osb + eternit_b7)

## Senere

- Slet `src/designs/v3/vaegge.scad` når #3 (aabninger) og #4 (beklaedning) er færdige —
  først der har vi trukket alt vi har brug for ud (framed_opening_y, mesh-paneler, bats, etc.).
  Indtil da ligger filen urørt på disk men kaldes ikke fra build.scad.
- Strøer-gulv (floor joists inde i huset) — egen fil eller del af konstruktions-skelet?
- "yard" → "løbegård" rename på tværs af kodebasen.
- Eternit_b7 ved 14°/10° hældning — kræver at WALL_TOP_LOW reduceres (V3_EH_BACK ~1780/1960).
  Det betyder at konstruktions-skelet skal parameteriseres pr. cover, og hus-dør (z_header_top=2262)
  rykker op over LAV-toprem. Større refactor — udskudt til vi beslutter cover endegyldigt.
- BR18-højde: efter spær-fix sidder cover-toppen 95 mm højere end før. Total højde over jord
  ved front: 2,66 m (tagpap) / 2,70 m (eternit) — ca. 16-20 cm over BR18-skelet-grænsen 2,5 m.
  Mulige løsninger: reducer V3_EH_FRONT med ~150 mm (kræver re-fit af yard-dør header), eller
  acceptér at sheden klassificeres som "small building" (ikke skel) hvor reglerne er løsere.
- beklaedning.scad bruger v3_roof_under(0) der nu returnerer 2615 i stedet for 2520 (efter
  spær-shift). Indvendig collar-tie og vindpapir er 95 mm højere end før — tjek når #4 (beklaedning)
  aktiveres igen.



Vi har beregnet at der skal købes ca. én rulle 10 meter og én rulle af 25 meter voliernet i målene ½ tomme x 1 tomme med 1,2mm trådtykkelse.
Det koster hhv. 400 og 950 kr. så ca. 1350 kr. i alt for det net der skal bruges i løbegården.