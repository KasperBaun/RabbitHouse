# Konstruktions-skelet

> Implementeret i `src/designs/v3/konstruktions-skelet.scad`.

Træ-skelettet sidder oven på fundamentet og består af 4 lag.

1. DPC (murpap)
2. Bundrem
3. Reglar
4. Toprem  

Bygningen har 5 vægge.

- Front (V1)
- Bag(V2)
- Venstre(V3)
- Højre(V4)
- Tværgående(V5).  
  Tag-hældning er 4,6° (8 % fald).

```
                    V2 (bag, LAV — 2,2 m)
        ┌────────────┬────────────────────────────────────┐
        │            │                                    │
        │            │                                    │
   V3   │  hus-rum   │           yard-rum                 │   V4
   2,2m │  X=0..1500 │        X=1500..6000                │  2,2m
        │            │                                    │
        │       V5 (partition, LAV)                       │
        │            │                                    │
        └────────────┴──────────────────[ yard-dør ]──────┘
                    V1 (front, HØJ — 2,4 m)
        ←── 1500 ───→ ←───────────── 4500 ────────────────→
                              (set ovenfra)
```

```
        ┌─── toprem 45×95 ───┐  z=2,52 m (V1) / 2,32 m (V2) / 2,52→2,32 m (V3-V5)
        │                    │
        │                    │
        │  reglar 45×95      │  studs 2108-2308 mm (skåret til hver position)
        │  c/c 600 mm        │
        │                    │
        │                    │
        ├─── bundrem 45×95 ──┤  z=0,17 m (= gulv-top)
        ├═══ murpap (DPC) ═══┤  z=0,12 m
        ▒▒▒▒▒ sokkel-ring ▒▒▒▒
                              (lag-stak gennem en væg)
```

## Mål

| Egenskab       | Værdi                                                          |
| -------------- | -------------------------------------------------------------- |
| V1 (front)     | 2,4 m flat (rummer std 95×205 udhusdør)                        |
| V2 (bag)       | 2,2 m flat                                                     |
| V3, V4, V5     | 2,4 → 2,2 m skrå (følger taget; V5 rummer std 80×200 hus-dør)  |
| Tag-hældning   | 4,6° / 8 % fald (drop 200 over 2500 mm)                        |
| Reglar-afstand | 600 mm c/c                                                     |

## Konstruktion

V1 (front) og V2 (bag) løber kontinuert hele bygningens 6 m længde.  
V3, V4 (sidemæg) og V5 (partition) BUTTER mod V1/V2's inderflade.  
Reglar 45 × 95 mm c/c 600 mm med jamb-reglar ved hver dør/vindue og junction-reglar i V1+V2 hvor V5 møder dem.  
Header (vandret 45 × 95) over hver dør/vindue. V3-vinduet har også rough sill under sig.

V3, V4 og V5 løber parallelt med tagets hældning. Deres toprem skrår fra HØJ ved front til LAV ved bag, og hver stud er skåret til varierende højde (2108-2308 mm) så toprem hviler fladt på alle studs — ingen separat gavlfyld.

## Materialeliste

Maks længde 3600 mm — V1 og V2 (6 m hver) splejses af ét 3600 + ét 2400 stykke. Stykkevis skæreliste pr. væg: [skaereliste-skelet.md](skaereliste-skelet.md).

| #   | Vare                     | Beskrivelse                                                              | Antal | Enhed      | Pris/enh  | I alt   |
| --- | ------------------------ | ------------------------------------------------------------------------ | ----- | ---------- | --------- | ------- |
| 1   | Reglar 45 × 95 × 2400 mm | Gran C24 — studs (37 stk, skæres 2108-2308 mm) + skrå toprem til V3/V4/V5 (5) | 42    | stk        |           |         |
| 2   | Reglar 45 × 95 × 3600 mm | Gran C24 — toprem til V1 + V2 (splejses med 2400-stykker fra #1)         | 2     | stk        |           |         |
| 3   | Reglar 45 × 95 × 2400 mm | PT NTR-AB — bundrem til V3/V4/V5 + splejs-stykker på V1+V2               | 5     | stk        |           |         |
| 4   | Reglar 45 × 95 × 3600 mm | PT NTR-AB — bundrem til V1 + V2 (splejses med 2400-stykker fra #3)       | 2     | stk        |           |         |
| 5   | Bitumen-tape 100 mm bred | Murpap mellem sokkel og bundrem                                          | 1     | rulle 25 m |           |         |
|     |                          |                                                                          |       |            | **Total** | **kr.** |

Header, cripples og rough sill (~5,6 m i alt) skæres af spild fra studs (~7,2 m fra 2400-stokken).

## Bygge-rækkefølge

1. Læg murpap-tape oven på sokkel — hele perimeteren + cross-wall under partition
2. Bor gennemgangshuller i bundrem-plankerne til ankerskruerne; læg på plads og spænd møtrikkerne
3. Sæt corner-reglar og jamb-reglar lodret med vinkelbeslag
4. Sæt grid-reglar c/c 600 mm + junction-reglar i V1/V2 hvor V5 møder dem
5. Sæt header over hver åbning + rough sill under V3-vinduet
6. Læg toprem oven på studs — V1 flat HØJ, V2 flat LAV, V3/V4/V5 skrå (følger taget)

## Rendering / verificering

```powershell
pwsh src/scripts/audit_renders.ps1
# → _renders/v3/audit/02_konstruktions-skelet.png
```
