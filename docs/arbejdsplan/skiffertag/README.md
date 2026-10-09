# Skiffertag — byggeplan

> Saddeltag 35°, kip langs husets dybde. Genbrugs-naturskifer 30×60 cm i
> klassisk dobbelt dækning på lægter over diffusionsåbent banevareundertag.
> Reference: [`guide-naturskifertag.md`](../../../guide-naturskifertag.md) —
> **ved tvivl gælder guiden**, og ved konflikt med skiferleverandørens
> anvisning gælder leverandøren.

## Hvor er vi nu

| # | Skridt | Status |
|---|--------|--------|
| 1 | [Spær](01-spaer.md) | ✅ rejst |
| 1a | [**Udhængsspær + klodser**](01a-udhaengsspaer.md) | ⚠️ **ny — skal op før 1b/2** |
| 1b | [Sofit](01b-sofit.md) | ⚠️ **omprojekteret: 4 sider, ventilerede lameller** |
| 2 | [Undertag](02-undertag.md) | ⚠️ lagt, men skal **forlænges ud i gavludhænget** |
| 3 | [Afstandslister](03-afstandslister.md) | ⚠️ sat, men mangler **2 lister over udhængsspærene** |
| 4 | [**Lægter**](04-laegter.md) | ⬅️ **næste skridt — og det mest kritiske** |
| 5 | [Sternbrædder](05-stern.md) | ⚠️ lav stern — skal op **før L1** |
| 6 | [Tagfodsblik, fuglegitter + tagrende](06-fodblik.md) | ⚠️ blikket skal på **før L1** |
| 7 | [Sortering af sten](07-sortering.md) | kan gøres parallelt med 4–6 |
| 8 | [Læg skifer](08-skifer.md) | |
| 9 | [Dobbelt vindskede](09-vindskeder.md) | |
| 10 | [Rygning](10-rygning.md) | |

Skridtene matcher 1:1 `Render*`-kaldene i `src/main.scad` — kommentér de
efterfølgende kald ud for at se hvert byggetrin i 3D.

> **Ændring (2026-09-07): gavludhænget bliver bygget færdigt.** Udhænget blev
> båret alene af de udkragede lægter, og de ligger 28 mm over spærplanet. Derfor
> kunne undertaget ikke føres ud, og tagskægget var kun lukket ved de to
> tagfødder. Der kommer nu **ét udhængsspær pr. gavl i spærplanet**
> ([1a](01a-udhaengsspaer.md)); så løber undertaget helt ud, sofitten lukker
> **alle fire** tagskæg ([1b](01b-sofit.md)), og lægterne får anlæg i spidsen.
> Samtidig går stern og vindskede-underbræt fra 25×150 til **25×200**, så de
> dækker spærende + sofitlamel. Trin 1–3 står som bygget og skal
> eftermonteres/forlænges — se de enkelte sider.

> **Ændring (2026-10-09): lægteafstand 255 mm, lægter 38×73, tagrende.**
> Pladerne er hullet **245 mm fra overkanten** og sømmes derfor i lægten
> *under* den, overkanten hviler på. Med den gamle plan (225 mm) ville sømmet
> ramme pladen nedenunder. Planen er nu Komproments standard: 255 mm, pladens
> overkant midt på lægten, overlæg 90 mm. Der kommer tagrende, så forkanten
> ligger 50 mm forbi L1. Lægteplan: [04](04-laegter.md), rækker: [08](08-skifer.md).
> **Rækkefølgen ved tagfoden er stern → tagfodsblik → undertag ud over blikket
> → L1** — nummereringen 4–6 er historisk.

## Nøglemål (kontrolleret)

| Mål | Værdi | Kommer af |
|---|---|---|
| Taghældning | 35° | `G_PITCH_DEG` |
| Skråflade, spærende → kip | **1500 mm** | spærets overkant, jf. skæretegningen |
| Lægteafstand på skråfladen | **255 mm** | pladerne er hullet 245 mm fra overkanten |
| Overlæg (plade *n* over *n−2*) | **90 mm** | 600 − 2 × 255 |
| Rækker pr. tagflade | 7 = række 1 (skåret, skjult) + 4 hele + 2 skårne i toppen | |
| Plader pr. række | **11** | 3340 mm med 1–5 mm fuger |
| Lægter pr. tagflade | **7** (L1–L7), T1 **38×73** | |
| Gavludhæng, bærende | **145 mm** pr. side | udhængsspær + lægteudkragning |
| Udhængsspær + undertag, bredde | **3290 mm** | 3000 + 2 × 145 |
| Lægtelængde | **3290 mm** | 3000 + 2 × 145 udkragning |
| Skiferfladens bredde | **3340 mm** | 3000 + 2 × 170 (til vindskedens yderside) |
| Yderste tagkant | **3390 mm** | 3000 + 2 × 195 (overliggerens yderside) |
| Sofit, tagfod | 280 mm skråmål | 229 vandret / cos 35° — 5 lameller |
| Sofit, gavl | 97 mm | 145 udhæng − 48 mm beklædningstykkelse — 2 lameller |
| Stern / vindskede-underbræt | **25×200** | 63 stak + 95 spær + 21 sofit = 179 skal dækkes |
| Skiferforkant forbi spærenden (L1's underkant) | **50 mm** | 25 mm foran sternen, ned i tagrenden |

### Hvorfor 255 mm

Pladerne er hullet 245 mm fra overkanten. Hver plade sømmes derfor i lægten
under den, dens overkant hviler på, og sømmet skal gå fri af overkanten på
pladen nedenunder. Det kræver en lægteafstand over 245 mm — leverandøren
skriver "lægteafstand altid 255 mm".

| Lægteafstand | Sømmet i forhold til pladen under | Overlæg | Plader i alt |
|---|---|---|---|
| **255 mm** (valgt) | 10 mm fri | **90 mm** | **132** |
| 225 mm (den gamle plan) | 20 mm nede i pladen — umuligt | 150 mm | 168 |

Prisen er margen: 90 mm overlæg er guidens minimum ved 35°, ikke mere. Den
gamle plan forudsatte huller 25–40 mm fra overkanten; de 25–40 mm er afstanden
fra **side**kanten.

## De tre tjek — afklaret

**1. Skråfladen S = 1500 mm. ✅ Bekræftet — du skal ikke måle om.**
Den er regnet ud af dine egne skæretegninger,
[01-spaer-tegninger.html](01-spaer-tegninger.html): spæremnet er et
parallelogram med lige lange kanter på **1500 mm** og lodrette snit i begge
ender. Hælmærket sidder 280 mm fra fodenden langs underkanten, hvilket giver
280 × cos 35° = 229 mm vandret udhæng, og 1500 × cos 35° = 1229 mm vandret
fra fodende til kip — altså præcis kip 1000 mm inde fra vægydersiden.
Geometrien lukker.

> Fugleudskæringen sænker hele taget ~38 mm i forhold til den teoretiske
> linje (det står også på tegningen). Det er en ren lodret forskydning og
> ændrer **ikke** skråfladen — lægteplanen måles fra spærenden og er
> upåvirket.

**2. Sømdimension.** Måles når stenene er hjemme: 4–8 mm sten → 2,8×40
kobbersøm, tykkere/rustik → 3,0×50. Bestil ~500 stk. Det eneste ufravigelige
er at de skal være **kobber**, ikke galvaniserede.

**3. Ventilationsspalten. ✅ Afklaret — der skal ikke ændres noget.**
De 63 mm er rigeligt, fordi 70 mm-kravet slet ikke gælder dette hulrum.
Der er to hulrum i en tagkonstruktion, og de har hver sit krav:

| Hulrum | Krav | Dit tag |
|---|---|---|
| **Over** undertaget (afstandsliste → tagdækning) | **min. 25 mm** | 25 + 38 = **63 mm** ✅ |
| **Under** undertaget (undertag → isolering), kun i en *ventileret* konstruktion | 50 mm ved fast undertag, **70 mm** ved banevare | findes ikke her |

De 70 mm er afstanden mellem undertag og **isolering** — ikke mellem undertag
og skifer. Taget her har ingen isolering oppe mod undertaget (arbejdsplanens
§8 isolerer kun vægge og evt. gulv), så det nederste hulrum eksisterer ikke,
og kravet gælder ikke. Afstandslisten på 25 mm er nøjagtig det, en
banevare kræver ovenpå. **Lægterne kan gå på nu.**

### Det der derimod skal være i orden: at luften kan komme IND og UD

Spaltehøjden er ikke problemet — gennemstrømningen er. Kanalen der lufter er
de **25 mm mellem afstandslisterne, under lægterne**, og den skal være åben i
begge ender:

- **Tagfod (indtag):** kanalen løber ud under L1 til tagkanten.
  Tagfodsblikket ligger under undertaget og over den lave sterns top, så de
  25 mm under L1 står åbne. **Fuglegitteret skal sidde her — i
  afstandsliste-gabet under L1.** Sofittens spalter
  ([01b](01b-sofit.md)) sidder i et *andet* hulrum, under undertaget, og
  erstatter ikke gitteret her.
- **Kip (aftræk):** L7 sidder 10 mm under kippen. Kanalerne løber
  *under* lægterne og mødes i kippen mellem de to L7. De skal ud under rygningsbrædderne, der er
  klodset op på 15 mm lister — **lad rygningens ender være åbne** (eller brug
  en ventileret rygning), ellers står luften stille.

> **Hvis du alligevel isolerer taget:** læg isoleringen **helt op mod**
> undertaget (uventileret konstruktion) — det kræver at undertaget er
> diffusionsåbent, og at der er en tæt dampspærre indvendigt. Læg den
> **aldrig** med en luftspalte på under 70 mm under banevaren; med 95 mm spær
> ville der kun blive 25 mm isolering tilbage, og det er værre end ingenting.
> Der lå mineraluld i et spærfag ved tagfoden på billedet — afklar om det er
> isolering eller bare en prop.

## Lægteplan (skridt 4 — det kritiske)

Mål på skråfladen fra L1's underkant (= spærenden). Pladens overkant ligger
**midt på lægten**; pladen sømmes i lægten under. Klodser, tegninger og
fremgangsmåde: [04-laegter.md](04-laegter.md).

| Lægte | Midte | Pladens top hviler her | Sømmes her |
|---|---|---|---|
| L1 | 36,5 (underkant 0) | — | række 1 (345 mm, skåret af bunden) |
| L2 | **295** | række 1 | række 2 (hel) |
| L3 | **550** | række 2 | række 3 (hel) |
| L4 | **805** | række 3 | række 4 (hel) |
| L5 | **1060** | række 4 | række 5 (hel) |
| L6 | **1315** | række 5 | række 6 (470 mm, skåret af toppen) |
| L7 | 1453,5 (overkant 1490) | række 6 | række 7 (~255 mm = resten fra række 1, nye huller) |

Kontrollen på planen: hvert søm sidder 46,5 mm over lægtens underkant og
10 mm over overkanten på pladen nedenunder.

## Indkøb — det der mangler

| Materiale | Dimension | Køb | Skridt |
|---|---|---|---|
| Konstruktionstræ C24, udhængsspær | 45×95 mm | **2 stk à 3,6 m** (4 × 1500; klodser af afkortet) | 1a |
| Skruer, udhængsspær/klodser | 5,0×80 | 48 stk + 2 hulplader | 1a |
| Høvlet forskalling m/fas, sofitlameller | 21×45 mm (jem & fix 25×50) | **22 stk à 2,4 m** (~45 m brugt) | 1b |
| Insektnet, rustfrit/alu ≤ 2 mm | 300 / 100 mm bredt | ~7 m + ~6 m | 1b |
| Afstandslister, ekstra over udhængsspær | 25×50 mm | 4 stk à 1,5 m (6 m) | 3 |
| Taglægter T1 | 38×73 mm | **14 stk à 3,6 m** (14 × 3290 brugt) | 4 |
| Søm til lægter | 100 mm | ~170 stk (2 pr. lægte × spær) | 4 |
| Sternbrædder | 25×200 mm | 2 stk à 3,6 m | 5 |
| Tagfodsblik, sort/antracit | — | 7 m | 6 |
| Fuglegitter, ventileret, sort | — | 7 m | 6 |
| Tagrende m. rendejern, endebunde, nedløb | — | 2 × ~3,4 m | 6 |
| Opklodsningsliste | 10×25 mm trykimp. | 7 m | 6 |
| **Genbrugs-naturskifer** | 30×60 cm | **165 stk** (132 i taget + ~25 % genbrugsspild) | 7, 8 |
| **Kobbersøm, riflet** | 2,8×40 mm (se tjek 2) | **500 stk ≈ 1,5 kg** (308 brugt) | 8 |
| Kip-liste (kun hvis toprækken vipper) | 8×25 mm | 7 m | 8 |
| Vindskede, underbræt | 25×200 mm | 4 stk à ~1,9 m (8 m) | 9 |
| Vindskede, overligger | 25×150 mm | 4 stk à ~1,9 m (8 m) | 9 |
| Rygningsbrædder | 25×150 mm | 2 stk à 3,4 m | 10 |
| Opklodsningslister, rygning | 15 mm | rest-træ | 10 |
| Zink-rygning | — | 3,5 m | 10 |
| Skruer m. tætningsskive | — | 1 pak | 10 |

Brædderne til randafslutningen: **25×200 ca. 15 m** (stern + vindskede-underbræt)
og **25×150 ca. 15 m** (overligger + rygning) — køb hver dimension samlet. Beregningen af de 132 plader: 11 pr. række (3340 mm inkl. fuger),
7 rækker pr. tagflade, 2 tagflader = 154 stykker — men række 7 skæres af
resterne fra række 1, så der går 6 × 11 × 2 plader til.

**Køb ALDRIG galvaniserede søm til skiferen — kun kobber.** Et skifertag
holder 100+ år; galvaniserede søm gør ikke.

## Sikkerhed (gælder alle skridt)

- Arbejd fra stillads/platform og fra lægterne — **betræd aldrig færdig
  dækning**. Stenene revner usynligt under punktlast.
- Støvmaske + briller ved hugning/skæring af sten.
- Sten løftes op i små bundter; sortér altid på jorden (skridt 7).

## Valg der er truffet — og som guiden ville gøre anderledes

- **Tagrende ved begge tagfødder** (ændret 2026-10-09 — før var den fravalgt).
  Tagfodsblik og skiferforkant ender i renden, se [06](06-fodblik.md).
- **Ingen skiferkit i randzonen.** Guidens §6.6 anbefaler T-kitning af de 3
  yderste sten ved gavlene *selv med undertag*. Det er fravalgt her, fordi
  undertaget og den lukkede dobbelte vindskede tager fygesne og slagregn.
  Overlægget er nu 90 mm (minimum ved 35°), så margenen er mindre end i den
  gamle plan — genovervej kitning, hvis huset står vindudsat.
