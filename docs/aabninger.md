# Åbninger

> Implementeret i `src/designs/v3/aabninger.scad`.

Åbningerne fylder selve dør- og vindues-enhederne ind i de rough openings,
som konstruktions-skelettet allerede har bygget med jamb-reglar, header
og rough sill (kun vinduet).
Der er tre åbninger der bygges her — én udvendig udhusdør, én indvendig
dør og ét vindue. Pet-åbningen i partition-væggen står som en bar rough
opening fra skelettet og fyldes med en standard kattelem (eller lignende
kommercielt produkt), der monteres direkte i åbningen.

| Nr  | Åbning           | Væg              | Type                                  |
| --- | ---------------- | ---------------- | ------------------------------------- |
| Å1  | Yard udhusdør    | V1 (front, -Y)   | mesh-i-træramme, åbner udad           |
| Å2  | Indvendig dør    | V4 (partition)   | massiv 80×200 cm, åbner ind i yard    |
| Å3  | Side-vindue      | V3 (venstre, -X) | 6 mm plexiglas udenpå rough opening   |

Pet-åbningen står tom: skelet leverer 250 × 300 mm rough opening med
jamb-reglar og header — kattelem fyldes i bagefter.

```
                    V2 (bag) — ingen åbninger
        ┌────────────────────┬─────────────────────────────────────┐
        │                    │                                     │
        │                    │                                     │
   V3   │   hus-rum          │           yard-rum                  │   V5
   Å3 → │ ◾                  │                                     │   ingen
        │                    │                                     │
        │     V4 (partition) │                                     │
        │      Å2 ◾  ◽←pet-rough opening (bar)                     │
        │                    │                                     │
        └────────────────────┴───────────────────[ Å1 ]────────────┘
                    V1 (front) — Å1 udhusdør
        ←──── 1500 ─────────→ ←──────────── 4500 ──────────────────→
                              (set ovenfra — ◾ = bygges, ◽ = bar opening)
```

```
           ┌────── topkarm ──────┐    z=z1
           │                     │
           │       leaf          │
           │                     │
           │                     │
           └─── bundkarm/ingen ──┘    z=z0
        ────────────────────────────  outer wall plane (Y=0 / X=hl+47.5)
                  (snit gennem Å1 eller Å2)
        Klink butter direkte mod karm-yder; ingen separat arkitrav-liste.
```

```
                ┌────── plexi 6 mm ──────┐
                │  overlap 30 mm hele    │
        ┌───────┤  vejen rundt om rough  ├────────┐
        │ jamb  │  opening, skrues       │  jamb  │
        │ reg-  │  direkte gennem træ-   │  reg-  │
        │ lar   │  værket (rubber-       │  lar   │
        │       │  washer-skruer)        │        │
        └───────┴────────────────────────┴────────┘
        ─────────────────────────────────────────────  outer wall plane (X=0)
                  (snit gennem Å3 plexi)
```

## Mål

| Egenskab                              | Værdi                       |
| ------------------------------------- | --------------------------- |
| Karm-tykkelse Å1 + Å2 (4 stykker)     | 50 mm                       |
| Leaf-tykkelse Å1 + Å2                 | 40 mm                       |
| Bundkarm/dørtrin (kun Å1)             | 30 mm                       |
| Plexi-tykkelse Å3                     | 6 mm                        |
| Plexi-overlap omkring rough opening   | 30 mm hele vejen rundt      |
| Voliernet Å1                          | ½ × 1 tomme, 1,2 mm tråd    |

## Konstruktion

Yard-døren (Å1) er en mesh-i-træramme leaf med vandret midt-rigel ved
1000 mm højde — mesh i to bånd over og under. Karmen er 50 mm tømmer
hele vejen rundt om rough opening (top + 2 sider + bundkarm/dørtrin).
Døren åbner udad mod haven på 2 hængsler i venstre side.

Indvendig dør (Å2) er en standard 80 × 200 cm fyldningsdør med karm-pakke,
monteret i partition-væggens rough opening. Den åbner ind i yard på 2
hængsler. Karmen er top + 2 sider — ingen bundkarm, leafen bærer direkte
på bundremmen.

Side-vinduet (Å3) er bare et stykke 6 mm plexiglas skruet udenpå rough
opening. Plexien overlapper jamb-reglar + header + rough sill med 30 mm
hele vejen rundt så der er træværk at skrue igennem (med rubber-washer-skruer
for tæthed). Ingen karm, sprosser eller drypnæse — det er en kanin-stald,
ikke et danskvinduesnørden.
Eventuelt kan 4 små lister (22 × 22 mm) lægges udenpå som klemramme; ikke
modelleret her.

Klinken (#4) butter direkte mod karm-yderfladen rundt om åbningerne på
Å1 og Å2 — der er ingen separat arkitrav-/karmliste-pakke. I praksis
sættes en tynd klemmeliste på reglar+karm før klink, og klink skæres
til rundt om karmen til sidst så det flugter.

Hardware er beslag (hængsler) i HK-hærdet stål og greb i krom — to
hængsler pr. dør (200 mm fra top og bund), greb i 1050 mm højde.

Pet-åbningen i partition-væggen er bevidst tom: skelettet leverer en
rough opening på 250 × 300 mm med jamb-reglar og header. Indeni monteres
en standard kattelem eller lignende (Stadelmann, Petsafe, SureFlap eller
en simpel selvbygget gummi-flap) — tilpas med liste-stykker hvis
åbningen er for stor for det valgte produkt.

## Materialeliste

| #   | Vare                                          | Beskrivelse                                                            | Antal | Enhed       | Pris/enh  | I alt   |
| --- | --------------------------------------------- | ---------------------------------------------------------------------- | ----- | ----------- | --------- | ------- |
| 1   | Reglar 45 × 50 × 2400 mm                      | Karm-stykker til Å1 (skæres til top/bund/sider)                        | 3     | stk         |           |         |
| 2   | Udhusdør 95 × 205 cm m. mesh-leaf (egen-byg)  | Karm-pakke + voliernet til mesh-leaf — eller pre-hung pakke fra Stark  | 1     | sæt         |           |         |
| 3   | Indvendig dør 80 × 200 cm m. karm-pakke       | Standard fyldningsdør, hvid eller umalet — Stark/Bauhaus               | 1     | sæt         |           |         |
| 4   | Plexiglas 6 mm 760 × 660 mm                   | Skæres til side-vinduet, skrues direkte på rough opening               | 1     | stk         |           |         |
| 5   | Hængsler 80 mm 2-pak                          | Til Å1 og Å2 (i alt 4 stk)                                             | 2     | pak         |           |         |
| 6   | Dørgreb m. trykker (rustfrit)                 | Til Å1 og Å2                                                           | 2     | sæt         |           |         |
| 7   | Skruer + søm + rubberwasher-skruer            | Diverse til montage; rubberwasher-skruer til plexi-fastgørelse         | 1     | pose        |           |         |
| 8   | Kattelem (separat indkøb)                     | Standard pet-flap til pet-rough opening 250 × 300                      | 1     | stk         |           |         |
|     |                                               |                                                                        |       |             | **Total** | **kr.** |

Mesh-leafen på Å1 dækkes af det 25 m + 10 m voliernet, som allerede er
budgetteret til ydervæggene (i alt ~1350 kr).

## Bygge-rækkefølge

1. Sæt karme til Å1 og Å2 i deres rough openings (top + 2 sider + bundkarm/dørtrin på Å1) — fastskrues gennem karmside ind i jamb-reglar
2. Sæt det færdige indvendige dørblad (Å2) i sin karm med 2 hængsler
3. Byg yard-mesh-leafen (Å1) — 50 × 40 reglar i ramme + midt-rigel, voliernet sømmes på indersiden
4. Hæng yard-leafen i karmen med 2 hængsler
5. Skru plexien (Å3) udenpå rough opening på V3 med rubber-washer-skruer i hjørner og midter af pladen
6. Monter dørgreb og lås på Å1 + Å2
7. Klink (#4) skæres til rundt om karme på Å1 og Å2 så det butter direkte mod karm-yder
8. Monter den valgte kattelem i pet-rough opening på partition-væggen — tilpas med liste-stykker hvis nødvendigt

## Rendering / verificering

```powershell
pwsh src/scripts/audit_renders.ps1
# → _renders/v3/audit/08_aabninger.png
```
