# Konstruktions-skelet

Træ-skelettet er opdelt pr. zone — åbn den fil der svarer til den enhed du
bygger, og du har skæreliste + ASCII-diagram + materialeliste pr. væg.

| Zone        | Doc                                                      | Render-modul             |
| ----------- | -------------------------------------------------------- | ------------------------ |
| Hus         | [hus/konstruktions-skelet.md](hus/konstruktions-skelet.md)         | `RenderHouseFraming()`   |
| Løbegård    | [løbegård/konstruktions-skelet.md](løbegård/konstruktions-skelet.md) | `RenderYardFraming()`    |

Fundament: [hus/fundament.md](hus/fundament.md) + [løbegård/fundament.md](løbegård/fundament.md).  
Beklædning: [hus/beklaedning.md](hus/beklaedning.md) + [løbegård/beklaedning.md](løbegård/beklaedning.md).

## Konvention pr. zone-doc

Hver zone-doc følger samme opskrift:

1. **Stak gennem en væg** — DPC + bundrem + stud + toprem med Z-niveauer.
2. **Mål-oversigt** — central tabel med stud-længde, sokkel-/eave-højder, c/c.
3. **Pr. væg** (V1, V2, V3 …) — kort beskrivelse, ASCII elevation, skæreliste
   med element + sektion + længde + antal + position.
4. **Samlet skæreliste** — alle stykker aggregeret for zonen.
5. **Materialeliste** — stok-længder og antal, så du kan handle direkte.
6. **Bygge-rækkefølge** — den rækkefølge væggene rejses i.

## L-formet grundplan (sat-ovenfra)

```
                                V2 (bag) — Y=3000
        ┌───────────────────┬───────────────────────────────────────┐
        │                   │                                       │
        │   hus-zone        │              yard-zone                │
   V3   │   X=0..2000       │ V5            X=2000..6000            │  V4
        │                   │                                       │
        │                   │                                       │
        │  V1 (hus, Y=0)    ┌────────────[ yard-dør ]───────────────┘
        │                   │
        │ hus-only zone     │ V1 (yard, Y=1000)
        └───────────────────┘
        ←────── 2000 ───────→ ←───────────── 4000 ──────────────────→
                          (set ovenfra)
```

V1 og V2 splittes ved X=hl=2000 — yard-fronten ligger 1000 mm bag hus-fronten,
så væggene fysisk knækker ved partitionen. Hver halvdel hører til sin zone-doc.
