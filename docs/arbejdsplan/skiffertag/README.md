# Skiffertag — byggeplan

> Saddeltag 35°, kip langs husets dybde. Genbrugs-naturskifer 30×60 cm i
> klassisk dobbelt dækning på lægter over diffusionsåbent banevareundertag.
> Reference: [`guide-naturskifertag.md`](../../../guide-naturskifertag.md) —
> **ved tvivl gælder guiden**, og ved konflikt med skiferleverandørens
> anvisning gælder leverandøren.

## Hvor er vi nu

| # | Skridt | Status |
|---|--------|--------|
| 1 | [Spær](01-spaer.md) + [sofit](01b-sofit.md) | ✅ rejst (kontrollér selv at sofitten er lukket ved begge tagfødder) |
| 2 | [Undertag](02-undertag.md) | ✅ lagt |
| 3 | [Afstandslister](03-afstandslister.md) | ✅ sat |
| 4 | [**Lægter**](04-laegter.md) | ⬅️ **næste skridt — og det mest kritiske** |
| 5 | [Sternbrædder](05-stern.md) | |
| 6 | [Fodblik + fuglegitter](06-fodblik.md) | |
| 7 | [Sortering af sten](07-sortering.md) | kan gøres parallelt med 4–6 |
| 8 | [Læg skifer](08-skifer.md) | |
| 9 | [Dobbelt vindskede](09-vindskeder.md) | |
| 10 | [Rygning](10-rygning.md) | |

Skridtene matcher 1:1 `Render*`-kaldene i `src/main.scad` — kommentér de
efterfølgende kald ud for at se hvert byggetrin i 3D.

## Nøglemål (kontrolleret)

| Mål | Værdi | Kommer af |
|---|---|---|
| Taghældning | 35° | `G_PITCH_DEG` |
| Skråflade, spærende → kip | **1500 mm** | (1000 + 229) / cos 35° |
| Lægteafstand (gauge) på skråfladen | **225 mm** | (600 − 150) / 2 |
| Overlæg (sten *n* over *n−2*) | **150 mm** | 600 − 2 × 225 |
| Rækker pr. tagflade | 7 = begynderrække + 5 synlige + toprække | |
| Lægter pr. tagflade | **7** (L1–L7) | |
| Lægtelængde | **3290 mm** | 3000 + 2 × 145 udkragning |
| Skiferfladens bredde | **3340 mm** | 3000 + 2 × 170 (til vindskedens yderside) |
| Yderste tagkant | **3390 mm** | 3000 + 2 × 195 (overliggerens yderside) |
| Skiferforkant forbi spærenden | **60 mm** | drypkant fri af sternen |

### Hvorfor 225 mm og ikke leverandørens standard 255 mm

Det er et bevidst valg, og det koster noget. Regnestykket på denne tagflade
(skråflade 1500 mm, forkant 60 mm forbi spærenden, sten 600 mm):

| Gauge | Rækker pr. flade | Mindste overlæg | Lægter pr. flade | Sten i alt |
|---|---|---|---|---|
| **225 mm** (valgt) | 7 | **150 mm** | 7 | **168** |
| 255 mm (Komproment std.) | 6 | 90 mm | 6 | 144 |
| 260 mm (guidens 35–40°-række) | 6 | 80 mm | 6 | 144 |

225 mm koster altså **én ekstra rækkegang pr. tagflade: 24 sten og 2 lægter**
mere end 255 mm. Til gengæld giver det 150 mm overlæg i stedet for guidens
minimum på 90 mm. Det er valgt fordi: stenene er genbrug med varierende
tykkelse og planhed, huset har intet tagrende og står i et haveklima med
slagregn, og der er fravalgt skiferkit i randzonen. På et tag så lille er
24 sten en billig forsikring.

Vil du hellere spare rækken, så skift til 255 mm — men så skal **hele
lægteplanen regnes om** (formlen står under tjek 1 nedenfor), og overlægget
lander på guidens minimum uden margin.

## ⚠️ Gør dette FØR du køber og skærer

1. **Mål den virkelige skråflade** på begge tagflader: fra spærenden til
   kippen, oven på afstandslisterne. Planen forudsætter **S = 1500 mm**.

   Godt nyt: lægteplanen er sat af **fra tagfoden og opefter**, ikke fra
   kippen. Måler S noget andet, skal L1–L7 derfor **ikke** flyttes — det er
   kun **toprækkens tilskæring** der ændrer sig:

   ```
   toprækkens længde = S − 1065        (435 mm ved S = 1500)
   ```

   Planen holder så længe **S ligger mellem ca. 1315 og 1665 mm**: under
   1315 bliver toprækken for kort til at sømme forsvarligt, over 1665 skal
   der en L8 på ved 1665 og en ekstra række. Ligger de to tagflader ikke ens,
   så sæt hver flade af for sig — det er kun toprækken der skal tilpasses.

   Skulle du alligevel ville lægge om til en anden gauge *a*, gælder:
   `overlæg = 600 − 2a`, og overlægget skal være **≥ 90 mm** (dvs. a ≤ 255).

2. **Mål tykkelsen på en håndfuld af genbrugsstenene.** 4–8 mm → kobbersøm
   2,8 × 40. 7–12 mm (rustik) → 3,0 × 50. Bestil først sømmene bagefter.

3. **Bekræft ventilationsspalten.** Opbygningen giver 25 (afstandsliste) +
   38 (lægte) = **63 mm** mellem undertag og skifer. Guidens §4.1B skriver
   min. 70 mm ved banevare. 25 + 38 er den gængse danske detalje, og de
   70 mm gælder normalt hulrummet *under* et diffusionstæt undertag — men
   tjek det i montagevejledningen til det undertag der ligger på taget
   (Komproment). Skal spalten være større, skal det ske **nu**, før
   lægterne sømmes fast.

## Lægteplan (skridt 4 — det kritiske)

Alle mål på skråfladen, fra spærenden (0) og op, til lægtens **overkant**.
Ens på begge tagflader.

| Lægte | Overkant | Bærer | Rækkens underkant |
|---|---|---|---|
| L1 | 0 | fodblik + opklodsningsliste | — |
| L2 | 315 | begynderrække (375 mm, bagside op) | −60 |
| L3 | 540 | synlig række 1 | −60 |
| L4 | 765 | synlig række 2 | 165 |
| L5 | 990 | synlig række 3 | 390 |
| L6 | 1215 | synlig række 4 | 615 |
| L7 | 1440 | synlig række 5 **+** toprække | 840 / 1065 |

Kontrollen på planen: hver rækkes **overkant** flugter en lægtes overkant,
så de to søm (25–40 mm under stenens overkant) altid rammer lægten. Toprækken
er tilskåret til 435 mm og lokkes 60–70 mm under overkanten, så dens søm også
rammer L7. Alle overlæg bliver 150 mm, og toprækkens overkant lander præcis i
kippen.

## Indkøb — det der mangler

| Materiale | Dimension | Køb | Skridt |
|---|---|---|---|
| Taglægter T1 | 38×73 mm | **14 stk à 3,6 m** (14 × 3290 brugt) | 4 |
| Søm til lægter | 100 mm | ~170 stk (2 pr. lægte × spær) | 4 |
| Sternbrædder | 25×150 mm | 2 stk à 3,4 m | 5 |
| Fodblik, zink | — | 7 m | 6 |
| Fuglegitter, ventileret | — | 7 m | 6 |
| Opklodsningsliste | 10×25 mm trykimp. | 7 m | 6 |
| **Genbrugs-naturskifer** | 30×60 cm | **210 stk** (168 i taget + ~25 % genbrugsspild) | 7, 8 |
| **Kobbersøm, riflet** | 2,8×40 mm (se tjek 2) | **500 stk ≈ 1,5 kg** (336 brugt) | 8 |
| Kip-liste | 8×25 mm | 7 m | 8 |
| Vindskedebrædder | 25×150 mm | 8 stk à ~1,9 m (16 m) | 9 |
| Rygningsbrædder | 25×150 mm | 2 stk à 3,4 m | 10 |
| Opklodsningslister, rygning | 15 mm | rest-træ | 10 |
| Zink-rygning | — | 3,5 m | 10 |
| Skruer m. tætningsskive | — | 1 pak | 10 |

25×150-brædderne (stern + vindskeder + rygning) er **30 m i alt** — køb dem
samlet. Beregningen af de 168 sten: 3340 / 300 = 11,1 → 12 emner pr. række,
7 rækker pr. tagflade, 2 tagflader.

**Køb ALDRIG galvaniserede søm til skiferen — kun kobber.** Et skifertag
holder 100+ år; galvaniserede søm gør ikke.

## Sikkerhed (gælder alle skridt)

- Arbejd fra stillads/platform og fra lægterne — **betræd aldrig færdig
  dækning**. Stenene revner usynligt under punktlast.
- Støvmaske + briller ved hugning/skæring af sten.
- Sten løftes op i små bundter; sortér altid på jorden (skridt 7).

## Valg der er truffet — og som guiden ville gøre anderledes

- **Ingen tagrende/nedløb.** Vandet drypper fra fodblikket ned på terræn.
  Der er lagt omfangsdræn omkring soklen.
- **Ingen skiferkit i randzonen.** Guidens §6.6 anbefaler T-kitning af de 3
  yderste sten ved gavlene *selv med undertag*. Det er fravalgt her, fordi
  undertaget og den lukkede dobbelte vindskede tager fygesne og slagregn.
  Genovervej hvis huset står mere vindudsat end antaget.
