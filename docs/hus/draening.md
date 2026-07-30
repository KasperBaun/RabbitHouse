# Dræning og fugtsikring — Hus (kælder)

> **Ikke modelleret.** Denne løsning findes ikke i `src/designs/`. Den er en
> efterbygning på det færdige hus og dokumenteres kun her.
> Se `fundament.md` for den ring, der drænes, og `konstruktions-skelet.md`
> for koterne over terræn.

Kælderrummet står med vand året rundt, værst om vinteren. Årsagen er, at der
aldrig blev projekteret noget under terræn, der kan håndtere vand: intet dræn,
intet kapillarbrydende lag under gulvet, ingen fugtspærre under terræn, intet
fald, ingen sump og ingen ventilation.

To ting følger direkte af det:

1. **Kælderen er et lukket badekar.** Gulvunderside (z = −780) ligger i samme
   kote som rendegrøftens bund, så der er intet drænende lag at lede vand hen i
   — og intet afløb.
2. **Rendegrøften virker som en nedsivningsrende.** 30 cm bred × 80 cm dyb med
   løs tilfyldning og uden dræn i bunden. Den samler overflade- og tagvand og
   leverer det til soklens grusbed og til fugerne mellem fundablokkene.
   Fundablokke er udstøbningsblokke — selv med udstøbte kerner er liggefugerne
   ikke vandtætte.

**Mål:** permanent tørt og ventileret kælderrum. Fugt + urin i et ulufteret rum
giver ammoniak, skimmel og risiko for pododermatitis. Sigt efter 40–60 % RF.

## Eksisterende lagopbygning (som bygget)

```
    +120 ├────────────────────────────┤   ← sokkel / dæk-overside
         │  murpap 2 mm → bundrem     │
     +95 │  ┌──────────────────────┐  │   ← dæk-underside (25 mm brædder,
         │  │                      │  │      4 mm revner = eneste luftvej)
       0 │  └──────────────────────┘  │   ← terræn / reglar-underkant
         │                            │
         │   680 mm åbent kælderrum   │
         │                            │
    −680 ├──── betongulv 100 mm ──────┤   ← gulv-overside
    −780 └────────────────────────────┘   ← gulv-underside = grøftens bund
         ░░░ råjord — INTET under gulvet: ingen singels, ingen membran, ░░░
         ░░░ intet kapillarbrydende lag, intet dræn, intet afløb        ░░░
```

## Etape 0 — Beslutningsgrundlag på én dag

Grav et prøvehul ca. 2 m fra huset, Ø ~400 mm, til **1,2 m dybde**. Lad det stå
2–4 timer og aflæs, hvor vandet stabiliserer sig. Det er grundvandsspejlet.

| Vandet står | Betydning | Handling |
|---|---|---|
| under −780 | Nedsivnings-/terrænvand | Etape 1–4 løser det med god margin |
| −680 … −780 | Højt, men håndterbart | Etape 1–4, pumpebrønden er billig forsikring |
| over −680 | Ægte højt grundvandsspejl | Læs **Plan B**, før du graver videre |

Samme dag:

- **Plastfolieprøve (ASTM D4263).** Tape 45 × 45 cm klar 0,15 mm plast tæt til
  det tørre betongulv, alle kanter forseglet, aflæs efter 24 t.
  Fugt **under** folien = indsivning/opstigende fugt.
  Fugt **oven på** = kondens (andet og billigere problem).
  Begge = begge dele.
- **Jordbund.** Ler → dræn virker godt, faskine virker ikke.
  Sand med højt grundvand → drænet kan have svært ved at følge med.
- **Afløbskote.** Skyd med laser eller slangevaterpas, at afløbspunktet ligger
  under **kote −1050**, med plads til 3–5 ‰ fald hele vejen. Go/no-go for
  gravitationsafløbet.

> Der bygges til værste tilfælde alligevel: **både** gravitationsafløb **og**
> pumpebrønd, **både** udvendigt omfangsdræn **og** indvendigt opsamlingsdræn
> under gulvet. Nogle hundrede kroner ekstra nu fjerner behovet for at gætte
> rigtigt.

## Etape 1 — Hold vandet væk fra huset

Skal være på plads **før** graven åbnes — ellers recirkulerer drænet tagvandet.

| Tiltag | Spec |
|---|---|
| Tagrender + nedløb | 2 × 3,4 m, 75–100 mm, på sternbrædderne. Nedløb i den ene ende af hver, ned i sandfangsbrønd og videre i rør — aldrig frit på jorden |
| Fald på terræn | **1:50** (20 mm/m) væk fra alle 4 vægge, mindst 1 m ud |
| Frihøjde til murpap | Terræn 0, murpap +122 → 120 mm. Bevares. Aldrig jord/flis/bark op til murpappen |
| Lukning af rendegrøften | Øverste 200 mm afsluttes med komprimeret ler eller membranskørt med fald væk fra huset, derefter muld |
| Afstand til afleveringspunkt | Mindst 5 m fra huset (SBI 185 / kommunal LAR: 5 m til bygning m. kælder, 2 m til skel, 25 m til vandløb/søer/drikkevandsboringer) |

Taget er ca. 2,0 × 3,4 m pr. side. Et helt almindeligt 10 mm/t byge lægger
~70 l/t på jorden lige ved væggen.

## Etape 2 — Omfangsdræn + fugtsikring af soklen

Perimeter = 2 × (2000 + 3000) = **10 løbende meter**.

### Gravesikkerhed — den eneste reelle risiko

Ringen bærer på 100 mm stabilgrus i kote −780, og drænet skal ligge dybere.

- Arbejd i **fag på maks. 1,0 m**: grav ud → fugtsikr → læg rør → tilfyld og
  komprimér, **før næste fag åbnes**.
- Hold gravens bund **uden for en 1:2-linje** fra soklens underside — læg røret
  **150–200 mm fri af blokkenes yderside**, ikke tæt op ad dem.
- Grav i en tør periode. Hav en dykpumpe i graven under arbejdet.

Graves der under fundamentet, eller står der mere end ca. 1 m åben grav ad
gangen, er sætningsskader den sandsynlige konsekvens.

### Tværsnit — færdig udvendig opbygning

```
              │ beklædning
        +122  │ ├─ murpap
        +120  ├─┴──────────┐
              │            │  ← smøremembran op til +150 over færdigt terræn
           0  │ 4. skifte  │╞═══ afslutningsliste
    ──────────┤            │░░░░░░░ muld
              │            │▓▓▓▓▓▓▓ lerlåg / membranskørt, fald væk (200 mm)
        −200  │ 3. skifte  │
              │            │  ┌ grundmursplade (knaster IND mod væg)
        −280  │            │  │┌ smøremembran, 2 lag
              │ 2. skifte  │  ││
        −480  │            │  ││  ▒▒▒ drænende grus, komprimeret i lag à 200
              │            │  ││  ▒▒▒
        −680  │ 1. skifte  │  ││  ▒▒▒
              ├────────────┤  ││ ╭┄┄┄┄┄┄┄┄┄╮ ← fiberdug foldet over (lap 300)
              │ stabilgrus │  ││ ┊ ○○○○○○○ ┊   singels 16–32, 200 over rør
        −780  └────────────┘  ││ ┊ ○ ▬▬▬ ○ ┊ ← drænrør Ø92, slidser OPAD
                              ││ ┊ ○○○○○○○ ┊   100 mm singels under røret
       −1000 … −1050          ╰┄┄┄┄┄┄┄┄┄┄┄┄╯ ← fiberdug i hele graven
                              │←150–200→│←── 400 mm gravebredde ──→│
                                 fri af blok
```

### Fremgangsmåde pr. fag

1. Grav til **kote −1000 … −1050** (min. 300 mm under gulvunderside), ca.
   400 mm bred.
2. Rens blokkene. Krads løse liggefuger ud, reparér med mørtel. Berapning.
3. **Smøremembran, 2 lag** — cementbaseret vandtætning (Sikalastic-1K,
   Aquafin 1K, Skalflex Multitæt) eller asfaltemulsion. Fra fundamentets fod og
   op til **150 mm over færdigt terræn**.
4. **Grundmursplade** (Isola Platon, Icopal Fonda, BG Grundmursplade) uden på
   membranen — **knasterne ind mod væggen**, overlap i samlingerne,
   afslutningsliste i toppen over terræn.
5. **Fiberdug klasse 2** i hele graven, i rigeligt overmål — den skal foldes
   tilbage over toppen som en "burrito". Fiberdugen er det, der forhindrer
   drænet i at slamme til. Springes den over, er det den hyppigste årsag til at
   omfangsdræn holder op med at virke.
6. **100 mm singels 16–32 mm** i bunden, afrettet til faldet.
7. **Drænrør Ø92–113 mm** perforeret PVC, **slidser opad**, **min. 3 ‰, gerne
   5 ‰ fald**. Over 3 m er det kun 9–15 mm — brug laser, ikke øjemål.
8. Dæk med singels til **200 mm over rørets overside**, fold fiberdugen over,
   overlap mindst 300 mm.
9. Tilfyld med drænende grus, komprimeret i lag à 200 mm, op til kote −200.
   Derefter lerlåget fra Etape 1.

### Brønde og afløb

| Element | Placering | Bemærk |
|---|---|---|
| Rense-/spulebrønd Ø315 | Mindst 2 diagonale hjørner, helst alle 4 | Så sløjfen kan spules |
| Sandfangsbrønd | Lavt hjørne | Dræn + tagnedløb + afløb mødes her. Sandfang **altid** før afløbet |
| Gravitationsafløb | Til målt lavpunkt | 3–5 ‰ fald |
| Pumpebrønd Ø400 + dykpumpe m. flyder | Samme lave hjørne | Backup. Vælg pumpe med tørløbssikring |

### Tilladelser

Tilslutning af drænvand fra omfangsdræn kræver normalt **ikke** forudgående
kommunal tilladelse. Men udledning til recipient kræver tilladelse efter
Miljøbeskyttelsesloven § 28, og **faskine kræver kommunal tilladelse**.
Permanent grundvandssænkning kan udløse Vandforsyningsloven § 26 — urealistisk
i denne skala, men værd at nævne hvis prøvehullet viser reel sænkning.

## Etape 3 — Nyt kældergulv

Etape 2 aflaster trykket. **Etape 3 er det, der fjerner vandet i gulvet.**
Et klaplag støbt direkte på råjord suger, ubetinget. Kapillarbrydende lag er
obligatorisk under terrændæk i BR18.

### Ny lagopbygning

```
    −680  ├──────────────────────────────────┤ ← nyt gulv, overside (uændret kote)
          │ beton 80–100 mm, fiberarmeret    │   fald 1:100 mod lavt hjørne
    −780  ├──────────────────────────────────┤
          │ EPS 50 mm (valgfrit, anbefales)  │
    −830  ├══════════════════════════════════┤ ← PE 0,4 mm fugt-/radonspærre
          │                                  │   lap 200 mm, tapet, op ad sokkel
          │ kapillarbrydende lag:            │   og tætnet mod smøremembranen
          │ singels 8–16 mm, MIN. 150 mm     │   min. 150 mm over nyt gulv
          │        ▬▬▬ opsamlingsrør Ø50–92  │ ← langs kanten, fald mod ét hjørne,
    −1030 ├┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┤   ført GENNEM soklen til drænbrønd
          │ fiberdug, ført op ad soklen      │
          ░░░░░░░░░░░ råjord ░░░░░░░░░░░░░░░░░
```

### Fremgangsmåde

1. Bryd det eksisterende gulv op og kør det ud (−680 … −780, 4,59 m²).
2. Grav yderligere **~250 mm** ud, til ca. kote −1030.
3. **Fiberdug** over råjorden, ført op ad soklens inderside.
4. **Indvendigt opsamlingsdræn** — Ø50–92 slidset rør langs kanten i grusbedet,
   fald mod ét hjørne, ført **gennem soklen** (kernebor, foringsrør, tætnes) ud
   i drænets lave brønd.
   Gør det nu. Det er billigt mens gulvet er åbent og umuligt bagefter, og det
   er dette, der gør løsningen permanent: selv hvis det udvendige dræn slammer
   til om 15 år, har vandet under gulvet stadig en udgang.
5. **Mindst 150 mm kapillarbrydende lag** — vasket singels 8–16 mm eller
   coatede løse letklinker 10–20 mm. Afrettet helt plant, komprimeret.
   4,59 m² × 0,15 m ≈ **0,7 m³**. Denne post findes ikke i den nuværende
   materialeliste.
6. **Fugt-/radonspærre** — 0,30–0,40 mm PE-folie (egentlig radonmembran hvis
   radonfunktionen ønskes). **Overlap min. 200 mm, tapet**, ført op ad soklen og
   tætnet mod smøremembranen mindst 150 mm over det nye gulv. Samlingen over
   kantisoleringen skal være helt tæt — det er den klassiske fejlkilde.
7. **50 mm EPS** — valgfrit, men anbefales. Et koldt betongulv i et fugtigt
   kaninrum **er** en kondensflade. Viste plastfolieprøven vand oven på folien,
   betyder dette lige så meget som selve drænet.
8. **Nyt gulv, 80–100 mm** fiberarmeret beton, **fald 1:100 mod ét lavt hjørne**
   der ender i en lille sump forbundet til opsamlingsdrænet fra pkt. 4.
   Stålglittes og forsegles — lettere at rengøre, og kaninurin angriber rå beton.

Gulvkoten ender hvor den var, så de 680 mm frihøjde bevares.

## Etape 4 — Ventilation af kælderrummet

Findes ikke i dag. Eneste luftvej er 4 mm revner mellem gulvbrædderne, og begge
lemme lukker plant i en fals. Et tørt gulv i et lukket rum går stadig over
85 % RF og gror skimmel.

Krybekælderpraksis: **150 cm² fri åbning pr. påbegyndt 6 m fundamentsvæg** ved
trægulvkonstruktion, mindst én rist nær hvert udadgående hjørne, mindst 100 mm
over terræn. "Fri" betyder **efter** fradrag for gitteret.

Perimeter 10 m → minimum 2 × 150 cm² = **300 cm²**. Hjørnereglen giver
**4 riste, én pr. væg** — brug det.

**Geometrisk problem:** sokkeloverside +120, terræn 0 → kun 120 mm fri sokkel.
En standard 70 × 220 mm sokkelrist kan ikke sidde med underkant 100 mm over
terræn. To løsninger:

| | Løsning | Vurdering |
|---|---|---|
| **a** | **Grusskørt.** Sænk færdigt terræn 100–150 mm i et 400 mm singelsbælte hele vejen rundt (stadig med fald væk fra huset), så der frilægges nok sokkel til rigtige sokkelriste | **Anbefales.** Passivt, ingen bevægelige dele, ingen strøm |
| **b** | **Vægventiler med skakt.** Åbninger i beklædningen lige over bundremmen, med kanal ned forbi gulvbjælkerne til kælderrummet | Mere tømrerarbejde, men ingen terrænregulering |

**Afskærmning:** 13 mm galvaniseret svejsetrådsnet udvendigt (jf. REQ-008 om
rovdyrsikring) **plus** rustfrit insektnet bagved. Kaninerne vil undersøge dem.

Kan de passive riste ikke nå 300 cm² fri åbning, suppleres med en lille
fugtstyret udsugningsventilator gennem gavlen over tagfladen.

## Etape 5 — Detaljer der rettes samtidig

| Forhold | Problem | Rettelse |
|---|---|---|
| Træ mod beton | 45×95 reglarne er skruet direkte mod soklens inderside i kote 0..95 uden fugtspærre i fladen. `TIMBER-FRAMING.md` foreskriver 5–10 mm luftspalte, som ikke findes | Murpap/EPDM-strimmel i fladen, eller skift til trykimprægneret — mens gulvet er tilgængeligt |
| Trappe | `arbejdsplan/lem-og-trappe.md` foreskriver alm. gran, ikke trykimprægneret, stående på kældergulvet | Trykimprægneret, eller aftagelig aluminiumsstige |
| Lemme | Lukker plant i 25 mm fals med ~5 mm luft | OK når Etape 4 giver rigtig ventilation — men regn ikke med dem som luftvej |

## Plan B — hvis prøvehullet viser vand over kote −680

Kæmp ikke imod:

1. **Hæv kældergulvet.** Fyld op med singels til fx kote −350, membran, støb det
   nye gulv der. Frihøjden falder 680 → 350 mm, men du er permanent over vandet.
   Til et kaninrum er 350 mm stadig brugbart.
2. **Opgiv dybden.** Fyld ringen op med komprimeret singels, støb gulvet i
   kote 0, og giv kaninerne hulevolumen over terræn i stedet.

## Materialeliste — dræning

| # | Vare | Beskrivelse | Antal | Enhed |
|---|---|---|---|---|
| 1 | Drænrør Ø92–113 perforeret PVC | Omfangsdræn 10 m + afløbsstræk | 12–15 | m |
| 2 | Drænrør Ø50–92 slidset | Indvendigt opsamlingsdræn under gulvet | 10 | m |
| 3 | Singels 16–32 mm | Drænkasse omkring røret | ~1,4 | m³ |
| 4 | Singels 8–16 mm (vasket) | Kapillarbrydende lag, 4,59 m² × 150 mm | ~0,8 | m³ |
| 5 | Singels | Grusskørt til ventilationsriste, 400 mm bælte | ~0,3 | m³ |
| 6 | Fiberdug klasse 2 | Grav (~20 m²) + kældergulv (~6 m²) + overmål | ~30 | m² |
| 7 | Smøremembran, cementbaseret | Sokkel udvendigt, fod til +150 over terræn | ~12 (~40 kg) | m² |
| 8 | Grundmursplade + afslutningsliste | 10 m perimeter, 1 m høj | 10 | m |
| 9 | PE-folie 0,4 mm / radonmembran + tape | Kældergulv + opføring ad sokkel | ~10 | m² |
| 10 | EPS 50 mm | Under nyt gulv (valgfrit) | 4,6 | m² |
| 11 | Beton, fiberarmeret | Nyt gulv 100 mm på 4,59 m² | ~0,5 | m³ |
| 12 | Rense-/spulebrønd Ø315 | Hjørner | 2–4 | stk |
| 13 | Sandfangsbrønd | Lavt hjørne, før afløb | 1 | stk |
| 14 | Pumpebrønd Ø400 + dykpumpe m. flyder | Backup, med tørløbssikring | 1 | sæt |
| 15 | Tagrende 75–100 mm + nedløb + beslag | 2 × 3,4 m + 2 nedløb | 1 | sæt |
| 16 | Sokkelrist 7 × 22 cm | Én pr. væg | 4 | stk |
| 17 | Svejsetrådsnet 13 mm + rustfrit insektnet | Bag ristene | — | rest |
| 18 | Murpap/EPDM-strimmel | Reglar mod sokkel | ~10 | m |

**Værktøj:** minigraver eller god skovl, pladevibrator, laser eller
slangevaterpas, kernebor Ø100 til soklens gennemføring, betonsav/mejselhammer
til det gamle gulv, dykpumpe til graven.

## Bygge-rækkefølge

1. **Dag 1** — prøvehul, plastfolieprøve, skyd afløbskoten.
   Beslut Etape 2–4 eller Plan B.
2. **Dag 1–2** — tagrender og nedløb op, tagvandet ledt væk.
   Gør dette **før** graven åbnes.
3. **Weekend 1–2** — omfangsdræn, fag for fag hele vejen rundt, inkl. brønde og
   afløb. Tilfyld hvert fag før det næste åbnes.
4. **Weekend 3** — bryd gulvet op, grav ud, opsamlingsdræn, kapillarbrydende
   lag, membran, støb.
5. **Mens gulvet hærder** — sokkelriste/grusskørt, murpap under reglarne, ny
   trappe.
6. **Til sidst** — terrænregulering 1:50 og lerlåg over rendens tilfyldning.

Lad ikke graven stå åben over en weekend med regn i vente.

## Kontrol

| Hvornår | Test | Kriterium |
|---|---|---|
| Efter Etape 2 | Hæld 50 l vand i den højeste rensebrønd | Skal komme ud i afløbet inden for 1 minut |
| Efter 6 mdr. | Gentag ovenstående | Drænet må ikke være slammet til |
| 4 uger efter Etape 3 | Plastfolieprøve (ASTM D4263) på nyt gulv | Tør på **begge** sider |
| Løbende | Hygrometer i kælderrummet | Vedvarende < 70 % RF. Alt over 85 % undersøges |

**Behold prøvehullet som permanent pejlerør:** sæt et slidset Ø75–110 rør viklet
i fiberdug ned i det, fyld op med singels, sæt låg på. Så kan grundvandsspejlet
aflæses på 30 sekunder i stedet for at gættes.

## Kilder

- [Bolius — Hold huset tørt med et omfangsdræn](https://www.bolius.dk/hold-huset-toert-med-et-omfangsdraen-18880)
- [Bolius — Hvad gør du ved opstigende grundvand?](https://www.bolius.dk/hvad-goer-du-ved-opstigende-grundvand-99508)
- [Bolius — Hold krybekælderen ventileret](https://www.bolius.dk/hold-krybekaelderen-ventileret-18583)
- [Bolius — Værd at vide om terrændæk](https://www.bolius.dk/vaerd-at-vide-om-terraendaek-18853)
- [Bolius — Hvad er en pumpebrønd?](https://www.bolius.dk/hvad-er-en-pumpebroend-18879)
- [Forsikringsoplysningen — Omfangsdræn](https://forsikringsoplysningen.dk/klimasikring-af-din-bolig/loesninger-til-din-bolig/omfangsdraen/)
- [Konstruktøren — Omfangsdræn](https://konstruktoeren.dk/omfangsdraen-hus-kaelder/) ·
  [Geotekstil: valg og faldgruber](https://konstruktoeren.dk/geotekstil/)
- [Bygningskultur — Kapillarbrydende lag under soklen](https://bygningskultur.dk/saadan-udfoerer-du-et-kapillarbrydende-lag-under-soklen/)
- [Byggros — BG Grundmursplade](https://www.byggros.com/produkter/fugt-og-indeklimaloesninger/draenplader-og-draenmaatter/bg-grundmursplade) ·
  [Icopal Fonda monteringsvejledning (PDF)](https://www.byggecenter.dk/uploads/product_files/20171215125915_grundmur_vejledning.pdf)
- [BYG-ERFA — Nedsivning af regnvand i faskiner](https://byg-erfa.dk/nedsivning-faskiner) ·
  [Greve Kommune — Retningslinjer for faskine (PDF)](https://greve.dk/media/qy0n1hxc/retningslinjer-for-nedsivning-i-faskine.pdf)
- [Gentofte Spildevandsplan — Afledning af drænvand](https://spildevandsplan.gentofte.dk/ansvar-og-rettigheder/afledning-af-draenvand/)
- [Concrete Society — Basement waterproofing options, BS 8102](https://www.concrete.org.uk/fingertips/basements-waterproofing-options-bs-8102/) ·
  [Permagard — Complying with BS 8102](https://www.permagard.co.uk/advice/basement-waterproofing-how-to-comply-with-bs8102)
- [Basement Moisture Lab — Diagnose og test (ASTM D4263)](https://basementmoisturelab.com/blog/basement-moisture-diagnosis-testing-complete-guide/)
- [MSD Veterinary Manual — Housing of rabbits](https://www.msdvetmanual.com/exotic-and-laboratory-animals/rabbits/housing-of-rabbits)
