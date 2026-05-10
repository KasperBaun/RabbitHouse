# Skæreliste — Konstruktions-skelet

> Implementeret i `src/designs/v3/konstruktions-skelet.scad`. Materialeliste i [konstruktions-skelet.md](konstruktions-skelet.md).

Skæreliste pr. væg. Mål er millimeter; positioner er i bygningens koordinatsystem (X = længde-akse, Y = front→bag).

## Konventioner

- `flad` = vinkelret savsnit (uanset orientering).
- `skrå` / `top 4,6°` = savsnit med 4,6° vinkel på toppen. På V3/V4/V5 ligger HØJ side mod front (lav y); over reglarens 45 mm bredde løfter HØJ side sig 3,6 mm over LAV side.
- Studs på V3, V4, V5: ALLE har skrå top — toprem hælder med taget og hviler fladt på hver stud.
- Længden i tabellen = **HØJ side** (mark ved den side der vender mod front; sav skråner ned mod bag).
- Bundrem og toprem på V1+V2 er flade. Bundrem på V3/V4/V5 er flad (hviler på sokkel-niveau). Toprem på V3/V4/V5 sloper.

## Sammendrag (matcher [materialeliste](konstruktions-skelet.md#materialeliste))

| Vare                       | Antal | Brug                                            |
| -------------------------- | ----- | ----------------------------------------------- |
| Reglar 45×95×3600 mm gran  | 2     | Toprem på V1 + V2 (splejset)                    |
| Reglar 45×95×2400 mm gran  | 42    | Studs (37) + skrå toprem V3/V4/V5 (5)           |
| Reglar 45×95×3600 mm PT    | 2     | Bundrem på V1 + V2 (splejset)                   |
| Reglar 45×95×2400 mm PT    | 5     | Bundrem V3/V4/V5 + splejs på V1+V2              |
| Bitumentape 100 mm         | 1     | Murpap mellem sokkel og bundrem                 |

Headers, cripples og rough sill (i alt ~5,6 m) skæres af spild fra studs (~7,2 m spild fra 2400-stokken efter studs er klippet til).

---

## V1 — front (flat HØJ z=2,52 m)

Yderste front-væg, hele 6 m. Indeholder yard-dør (rough opening 1070×2120 mm) ved x=3000..4070.

| Element             | Antal | Længde (mm) | Position                                          |
| ------------------- | ----- | ----------- | ------------------------------------------------- |
| Bundrem (PT)        | 1     | 3600 flad   | x=0..3600 (splejs ved 3600)                       |
| Bundrem (PT)        | 1     | 2400 flad   | x=3600..6000                                      |
| Stud — grid+end     | 8     | 2308 flad   | x = 0, 600, 1200, 1800, 2400, 4800, 5400, 5955    |
| Stud — junction     | 1     | 2308 flad   | x = 1477,5 (V5-partition lander her)              |
| Stud — yard-jamb    | 2     | 2308 flad   | x = 2955 og 4070 (begge sider af yard-dør)        |
| Header — yard-dør   | 1     | 1070 flad   | x=3000..4070, z=2287..2332                        |
| Cripple over header | 2     | 143 flad    | over yard-dør, c/c 300 i åbningen                 |
| Toprem (gran)       | 1     | 3600 flad   | flat z=2520, x=0..3600 (splejs ved 3600)          |
| Toprem (gran)       | 1     | 2400 flad   | flat z=2520, x=3600..6000                         |

---

## V2 — bag (flat LAV z=2,32 m)

Yderste bag-væg, hele 6 m. Ingen åbninger.

| Element            | Antal | Længde (mm) | Position                                                              |
| ------------------ | ----- | ----------- | --------------------------------------------------------------------- |
| Bundrem (PT)       | 1     | 3600 flad   | x=0..3600 (splejs)                                                    |
| Bundrem (PT)       | 1     | 2400 flad   | x=3600..6000                                                          |
| Stud — grid+end    | 11    | 2108 flad   | x = 0, 600, 1200, 1800, 2400, 3000, 3600, 4200, 4800, 5400, 5955      |
| Stud — junction    | 1     | 2108 flad   | x = 1477,5 (V5 lander her)                                            |
| Toprem (gran)      | 1     | 3600 flad   | flat z=2320, x=0..3600 (splejs)                                       |
| Toprem (gran)      | 1     | 2400 flad   | flat z=2320, x=3600..6000                                             |

---

## V3 — venstre side (skrå HØJ→LAV, 2,52→2,33 m)

Buttet mellem V1 og V2 inderfladser (y=95..2405). Skrår med taget. Indeholder vindue (rough opening 700×600 mm) ved y=900..1600, z=1267..1867.

| Element              | Antal | Længde (mm)      | Position                                                |
| -------------------- | ----- | ---------------- | ------------------------------------------------------- |
| Bundrem (PT)         | 1     | 2310 flad        | y=95..2405                                              |
| Stud — front-hjørne  | 1     | 2300 (top 4,6°)  | y=95 (HØJ side mod front)                               |
| Stud — vindue jamb V | 1     | 2240 (top 4,6°)  | y=855                                                   |
| Stud — vindue jamb H | 1     | 2180 (top 4,6°)  | y=1600                                                  |
| Stud — bag-hjørne    | 1     | 2119 (top 4,6°)  | y=2360                                                  |
| Header (gran)        | 1     | 700 flad         | y=900..1600, z=1867..1912                               |
| Rough sill (gran)    | 1     | 700 flad         | y=900..1600, z=1222..1267                               |
| Cripple over header  | 1     | 469 (top 4,6°)   | y=1177,5, z=1912..~2381                                 |
| Cripple under sill   | 1     | 1055 flad        | y=1177,5, z=167..1222                                   |
| Toprem (gran)        | 1     | 2317 (top 4,6°)  | y=95..2405, sloper z=2467 (front) → z=2283 (bag)        |

---

## V4 — højre side (skrå HØJ→LAV, 2,52→2,33 m)

Buttet mellem V1 og V2 inderfladser. Skrår med taget. Ingen åbninger.

| Element             | Antal | Længde (mm)      | Position           |
| ------------------- | ----- | ---------------- | ------------------ |
| Bundrem (PT)        | 1     | 2310 flad        | y=95..2405         |
| Stud — front-hjørne | 1     | 2300 (top 4,6°)  | y=95               |
| Stud — grid 1       | 1     | 2252 (top 4,6°)  | y=695              |
| Stud — grid 2       | 1     | 2204 (top 4,6°)  | y=1295             |
| Stud — grid 3       | 1     | 2156 (top 4,6°)  | y=1895             |
| Stud — bag-hjørne   | 1     | 2119 (top 4,6°)  | y=2360             |
| Toprem (gran)       | 1     | 2317 (top 4,6°)  | y=95..2405         |

---

## V5 — partition (skrå HØJ→LAV, 2,52→2,33 m)

Tværgående væg ved x=1452,5..1547,5 (centreret på x=1500). Hus/yard-skel. To åbninger:
- **Hus-dør** (rough opening 870×2050 mm) ved y=200..1070, z=167..2217.
- **Dyre-dør** (rough opening 250×300 mm) ved y=1500..1750, z=180..480 (15 mm over gulv).

V5 har kun én "grid"-stud (bag-hjørnet) — de øvrige grid-positioner er udelukket af jamb-buffer omkring de to døre.

| Element                  | Antal | Længde (mm)      | Position                                          |
| ------------------------ | ----- | ---------------- | ------------------------------------------------- |
| Bundrem (PT)             | 1     | 2310 flad        | y=95..2405 (cross-wall)                           |
| Stud — hus-dør jamb V    | 1     | 2296 (top 4,6°)  | y=155                                             |
| Stud — hus-dør jamb H    | 1     | 2222 (top 4,6°)  | y=1070                                            |
| Stud — dyre-dør jamb V   | 1     | 2192 (top 4,6°)  | y=1455                                            |
| Stud — dyre-dør jamb H   | 1     | 2168 (top 4,6°)  | y=1750                                            |
| Stud — bag-hjørne        | 1     | 2119 (top 4,6°)  | y=2360                                            |
| Header — hus-dør         | 1     | 870 flad         | y=200..1070, z=2217..2262                         |
| Header — dyre-dør        | 1     | 250 flad         | y=1500..1750, z=480..525                          |
| Cripple over hus-dør     | 1     | 175 (top 4,6°)   | y=477,5, z=2262..~2437                            |
| Toprem (gran)            | 1     | 2317 (top 4,6°)  | y=95..2405, sloper z=2467 → z=2283                |

Dyre-døren får ingen cripples (åbningen er kun 250 mm bred, så c/c-600-grid-rummet falder uden for åbningen). Heller ingen rough sill — dyre-døren sidder kun 13 mm over bundrem-toppen, så bundremmen selv lukker spalten under.

---

## Tjek

- Stud-tællingen i tabellerne summerer til **37** (8+1+2 = 11 i V1, 11+1 = 12 i V2, 4 i V3, 5 i V4, 5 i V5) — matcher materialelistens 37 studs.
- Headers + cripples + sill: 1070 + 700 + 700 + 870 + 250 + 2×143 + 469 + 1055 + 175 = **5575 mm ≈ 5,6 m**, dækkes af spild fra 37×2400-stokken (~7,2 m spild i alt → ~1,7 m netto-spild efter headers er klippet).
