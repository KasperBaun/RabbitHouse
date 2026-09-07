# Guide: Oplægning af naturskifertag (dobbelt dækning)

> **Målgruppe:** AI-agent eller person, der skal rådgive om eller planlægge oplægning af tag med naturskifer i Danmark.
> **Scope:** Rektangulær naturskifer lagt i klassisk dobbelt dækning med kobbersøm på lægter eller fast undertag. Facadeskifer, diagonaldækning og krogsystemer er kun kort berørt.
> **Kilder:** Syntese af Cupa Danmarks projekteringsvejledning, Komproments montagevejledning for naturskifertag, Inpros oplægningsvejledning samt almen dansk tagfaglig praksis (TRÆ 54, DUKO, Tekniq Tag- og Facademappen). Ved konflikt mellem denne guide og den konkrete skiferleverandørs anvisninger gælder leverandørens anvisninger.

---

## 0. Parametre agenten skal afklare, før der rådgives konkret

Disse fem parametre styrer stort set alle tal i guiden. Indhent dem først:

1. **Taghældning** (grader) — styrer overlæg, lægteafstand og krav til undertag.
2. **Stenformat** — typisk 60×30, 50×25, 40×20 eller 60×35/65×40 cm (ældre "Port Madoc"-formater). Styrer lægteafstand og forbrug pr. m².
3. **Skifertykkelse** — typisk 4–8 mm (glat spansk skifer) eller 7–12 mm (rustik). Styrer sømdimension og listetykkelser.
4. **Underkonstruktion** — lægter med banevareundertag, lægter på fast undertag (brædder/krydsfiner + tagpap), eller skifer direkte på rupløjede brædder med pap (svensk/københavnsk metode).
5. **Ny eller genbrugsskifer** — genbrugsskifer kræver hårdere sortering, højere spildprocent og kontrol af eksisterende sømhuller.

---

## 1. Sikkerhed og grundregler

- Arbejde på tag kræver stillads og faldsikring efter gældende AT-regler. Skifer er tungt (paller på 1,1–1,5 ton med 25–40 m² tag pr. palle) — planlæg kranløft/materialehejsning.
- **Et skifertag må ikke betrædes under montagen.** Stenene knækker eller revner usynligt under punktlast. Arbejd fra lægterne (eller fra stilladset/tagstiger med trykfordeling ved fast undertag).
- Skifer kan indeholde skjulte revner. Håndtér gerne stenene "kontant" ved sorteringen på jorden, så defekte sten afsløres **før** de sidder på taget.
- Ved skæring: brug støvmaske og øjenværn. Stenstøv skal ikke indåndes.

---

## 2. Materialer

### 2.1 Skiferen
- Naturskifer skal opfylde **EN 12326-1/-2**. Efterspørg bedste klasser: vandabsorption A1, pyrit/urenheder T1, syrebestandighed S1.
- Kontroller ved modtagelse, at alle paller har originale pallemærker (producent, brud/produktnavn, antal, pallenummer). Gem pallemærkerne i kvalitetssikringen — de er også forudsætning for produktgaranti (typisk 30 år).
- Forvent en frasortering på **op til 5 %**. Frasorterede sten bruges som underliggere ved tagfod eller til tilskæringer.

### 2.2 Fastgørelse
- **Kun kobbersøm** (evt. rustfast ved særlige forhold — aldrig almindelige galvaniserede søm til et tag, der skal holde 100+ år). Let riflede søm Ø 2,8–3,0 mm:
  - Skifertykkelse 4–8 mm → **2,8 × 40 mm kobbersøm**
  - Skifertykkelse 7–12 mm → **3,0 × 50 mm kobbersøm**
- **To søm pr. sten.** Alternativ: forlokket skifer i krog-/skinnesystem (leverandørspecifikt, egen vejledning).

### 2.3 Træ
- Taglægter: typisk **T1-lægte 38×73 mm** (dimensioneres efter spærafstand og snelast).
- Afstandslister over undertag: **25×50 mm trykimprægneret**.
- Skiferliste/opklodsningsliste ved tagfod: ca. **10×25 mm** (5–7 mm kan bruges ved tynde sten — formålet er at give startrækken samme hældning som resten af taget).
- Afstandsliste ved kip: ca. **8×25 mm**, så øverste række ikke vipper.
- Underliggende materialer skal i kvalitet matche skiferens levetid (100–150 år). Spar ikke på undertag, lægter og inddækninger.

### 2.4 Kit
- Ved oplægning uden undertag eller i randzoner: **skiferkit på basis af rågummi og polymeriseret vegetabilsk olie** (fx DANA Skiferkit 694). Kit der udtørrer (alm. fugemasse, silikone, bitumen) må ikke bruges.

### 2.5 Inddækninger og tilbehør
- Zink/kobber til rygning, skotrender, grater, fodblik, gennemføringer. Udførelse efter **Tekniq (Dansk VVS) Tag- og Facademappen** — den er reference for alle inddækningsdetaljer.
- Snefangsrør/snestopjern og tagtrin: montér altid **ekstra lægte/bræt som understøtning**, hvor skiferen belastes af beslaget.

---

## 3. Dækningsprincip og geometri

Naturskifer lægges i **dobbelt dækning**: hver sten dækker to underliggende rækker delvist, og de lodrette fuger forskydes en **halv stens bredde** fra række til række. Det betyder:

- På ethvert punkt af taget ligger der mindst to lag skifer; ved overlægget tre lag.
- **Overlægget (O)** er den strækning, hvor sten i række *n* dækker ind over sten i række *n−2*.
- **Lægteafstanden (a)** beregnes af stenlængden (L):

```
a = (L − O) / 2
```

Eksempel: 600 mm sten med 90 mm overlæg → a = (600 − 90) / 2 = **255 mm** (dette er Komproments standard for 30×60-sten; ved anden lægteafstand skal leverandøren kontaktes).

- **Synlig stenhøjde** pr. række = lægteafstanden a.
- **Forbrug pr. m²** = 1 / (a × stenbredde). Eksempel 60×30 med a = 255 mm: 1 / (0,255 × 0,30) ≈ 13,1 stk./m².

### 3.1 Overlæg og lægteafstand som funktion af taghældning

Kravet til overlæg **stiger, når hældningen falder** (mere vandbelastning og slagregn/fygesne-risiko). Vejledende for 60×30-sten (Inpros skema, konsistent med praksis 90–120 mm overlæg):

| Taghældning | Lægteafstand (cm) | Ca. overlæg (mm) | Forbrug (stk./m²) |
|---|---|---|---|
| 20–25° | 24,0 | 120 | 13,9 |
| 25–30° | 24,2 | 116 | 13,7 |
| 30–35° | 25,5 | 90 | 13,1 |
| 35–40° | 26,0 | 80 | 12,8 |
| 40–45° | 26,5 | 70 | 12,6 |

**Regler for agenten:**
- Under 20°: naturskifer anbefales ikke — hverken med udnyttet eller uudnyttet tagrum.
- 20–30°: kræver altid undertag. Fast undertag (brædder/krydsfiner + tagpap) fra 20°; banevareundertag først fra ca. 25°.
- Over 30°: undertag på lægter eller på rupløjede brædder; forlokket standardskifer anvendes typisk fra ca. 30° og op, hvor lægteafstanden er givet på forhånd.
- I udsatte klimazoner (kyst, fritstående, høj bygning) vælges det største overlæg i intervallet. Ved bygninger over 2 m i udsat terræn bør vindsug beregnes.
- Diagonaldækning og rustik skifer: **altid** undertag.

---

## 4. Underkonstruktion

### 4.1 Tre gangbare opbygninger

**A. Lægter + fast undertag (fra 20°):** Spær → krydsfiner eller brædder → tagpap → trykimprægnerede afstandslister 25×50 → lægter 38×73 → skifer.

**B. Lægter + banevareundertag (fra 25°):** Spær → banevare (diffusionsåben eller -tæt, valgt efter DUKO-klassifikation) → afstandslister → lægter → skifer.

**To forskellige hulrum — bland dem ikke sammen.** Det er den klassiske
forvekslingsfejl, og tallene er vidt forskellige:

| Hulrum | Hvor | Krav |
|---|---|---|
| **Over undertaget** | mellem undertag og tagdækning, dannet af afstandslisten | **min. 25 mm afstandsliste** (trykimp.), både ved diffusionsåbent og -tæt undertag — skal give fri afvanding og udluftning fra tagfod til kip |
| **Under undertaget** | mellem undertag og **isolering**, kun i en *ventileret* konstruktion | **min. 50 mm** ved fast undertag, **min. 70 mm** ved banevare (banevaren hænger ned mellem spærene, så der skal mere til for at holde en gennemsnitshøjde på 50 mm) |

Er der **ingen isolering** under undertaget, eller ligger isoleringen tæt op
mod et **diffusionsåbent** undertag (uventileret konstruktion, kræver tæt
dampspærre), findes det nederste hulrum ikke, og 50/70 mm-kravet gælder
ikke. Så er de 25 mm over undertaget hele ventilationen.

**C. Direkte på rupløjede brædder med tagpap (fra 20°):** Spær → rupløjede brædder med fer og not (1–2 mm luft mellem brædderne) → tagpap, der forsegler omkring sømhullerne → skifer sømmet direkte, uden lægter. Traditionel svensk/københavnsk metode.
   - Fordele: ~63 mm lavere indbygningshøjde (sparer lægte 38 + liste 25 mm), fuld fladeunderstøtning af hver sten, enklere detaljer ved kviste og brandkamme, plads til mere isolering eller til at gøre en uventileret konstruktion ventileret.
   - Ulemper: langsommere oplægning (ingen lægter at gå på og deponere sten på); kræver omhyggelig opstregning med kridtsnor direkte på pappen.

### 4.2 Fugt og ventilation
- Diffusionstætte undertage (typisk undertagspap) **skal altid ventileres** på undersiden. Diffusionsåbne undertage kan have isolering helt op mod undertaget, men så skal der ventileres mellem skifer og undertag, og dampspærren skal være udført upåklageligt.
- Tagrum ventileres med åbningsareal på **min. 1/500 af det bebyggede areal**, jævnt fordelt ved tagfod og kip.
- I paralleltage: ventilationsspalte min. 50 mm ved tagflader op til 12 m — større spalte ved længere tagflader.
- Sørg for intakt dampspærre/tæt loft under tagrummet (inkl. tætsluttende loftlem). Uden det risikeres fugtophobning på skiferens underside.
- Vær opmærksom på **kondensdryp**: sort skifer kan ved natudstråling blive koldere end udeluften, og kondens på undersiden kan dryppe (skiferen suger ikke vand). Endnu en grund til undertag.
- Skiferen selv kræver **ingen** ventilation mod underlaget (frostsikker sten), og samlingerne er relativt diffusionsåbne.

### 4.3 Kontrol af underlag før oplægning (udførendes ansvar)
- Tagfladen skal være plan: **maks. 2 mm afvigelse målt med 2 m retskinne**, både på langs og tværs.
- Lægteafstanden skal være kontrolleret mod det krævede overlæg — en tømrerfejl her kan ikke reddes under dækningen.
- Tagfod skal være lægtet korrekt med underlag for begynderrækken (se 6.1).

---

## 5. Sortering og klargøring af skifer

1. **Sortér alle sten i minimum 3 tykkelser** — på jorden, altid før oplægning, og helst af de samme folk, der skal lægge taget. Sortering "på farten" oppe på taget bliver for tilfældig.
2. **Bland sten fra flere paller** samtidig — der er farvespil mellem paller, og blanding giver en ensartet, levende tagflade.
3. **Fordelingen på taget:** tykkeste sten nederst ved tagfod, mellemtykkelse på midten, tyndeste øverst mod kip. (Giver korrekt afvanding og et tag, der "ligger ned".)
4. **Kassér** sten der virker skøre eller "skrukke" (lyder dødt ved bankeprøve). Op til 5 % spild er normalt.
5. Sten med hjørneafskæringer kasseres ikke — de lokkes, så det skårne hjørne vender **op under** den overliggende sten og skjules.
6. Rustik skifer sorteres efter samme princip, blot med accept af større variation.

---

## 6. Oplægning — trin for trin

### 6.1 Lokning (hulning) og sømning
- Sømhuller **lokkes fra bagsiden** med lokkeramme (eller spidsen af en skiferøkse), så der dannes et kegleformet hul på forsiden, hvor sømhovedet forsænkes. Brug ikke lokkeværktøj beregnet til eternit/kunstskifer. Tyk rustik skifer kan lokkes fra forsiden.
- Hullernes placering: **25–40 mm fra skiferkant til hullets centrum** (to huller i stenens overdel, symmetrisk).
- **Sømningens gyldne regel:** Sømmet slås i, til hovedet **netop rører** skiferens overflade. Stenen skal ligge fast, men må under ingen omstændigheder spændes op af sømmet — opspænding er den klassiske årsag til revnede sten og utætte tage. Stenen skal kunne "hænge" på sømmene.

### 6.2 Tagfod (startrækken)
1. Montér **opklodsnings-/skiferliste** på tagfodslægten (ca. 10×25 mm ved 4–8 mm sten; 5–7 mm liste kan bruges ved tynde sten), så begynderrækken får samme hældning som de øvrige rækker og ikke vipper.
2. Læg den **usynlige begynderrække** (underliggerne): halve sten eller hele sten lagt vandret, vendt med **bagsiden opad**, tilskåret så tagdækningen rager **50–70 mm ud i tagrenden** (til midt tagrende).
3. Fodblik føres ud i tagrenden. Ved udhæng: opklodsning under første lægte (tilpasset trykimprægneret liste) pr. maks. c/c 1000 mm, så vand kan løbe uhindret til renden. Evt. ventileret fuglegitter.
4. Første synlige række lægges oven på begynderrækken med forskudte fuger.

### 6.3 Selve dækningen
1. **Prøveudlægning:** Læg et referencefelt, vurdér det, og brug det som facit for resten af taget.
2. **Opstregning:** Streg op med kridtsnor for **hver tredje sten** — både vandret (rækkehøjde = lægteafstand ved fast underlag) og lodret (stenbredder), så løbene holder retning over hele fladen. Ved fast undertag uden lægter er opstregning på pappen obligatorisk.
3. Læg nedefra og op, række for række. Hver række forskydes **½ stenbredde** i forhold til rækken under.
4. **Lodret fugeafstand mellem nabosten: 1–5 mm** (typisk 3–5 mm ved tykkere/rustik sten). Stenene må ikke presses mod hinanden.
5. Hver sten fastgøres med to kobbersøm jf. 6.1. Tilpas løbende: en sten der ikke "falder til", flyttes til en anden række, eller et øverste hjørne hugges af, så den lægger sig plant.
6. **Ved kip:** montér ca. 8×25 mm afstandsliste langs overkanten af øverste lægte, så sidste række ikke vipper. Rygning opbygges typisk med rygningsbrædder (fx 25×150 mm opklodset på 15 mm lister pr. 500 mm) og afdækkes med zink. Ventilationsstudse/ventileret rygning sikrer aftræk ved kip.

### 6.4 Tilskæring og værktøj
- **Klassisk (anbefalet):** skiferøkse mod fladstål som underlag — hugningen giver den karakteristiske **affasede kant på forsiden**. Øksens spids lokker huller; nakken bruges som hammer. Alternativt skifersaks (håndsaks eller til boremaskine) — klip altid **fra bagsiden**, så affasningen kommer på forsiden.
- **Vinkelsliber med diamantklinge:** praktisk mulig og nævnes af nogle leverandører, men Cupa fraråder den til naturskifer — snittet mangler den naturlige affasning (skæringen syner "død"), og der er sikkerheds- og støvhensyn. Brug den højst til skjulte snit; synlige kanter hugges/klippes. Vådskærer er et alternativ til lange, skjulte snit.
- Stationær guillotine fungerer, men kræver mere færdsel på taget.

### 6.5 Tilslutninger, gavle og gennembrud ("indskudt skifer")
- Mål taget op, så det så vidt muligt **går op i hele og halve sten** mod gavle, brandkamme, kviste og ovenlys.
- Hvor det ikke går op: **undgå smalle skiferstrimler** — de kan ikke fastgøres forsvarligt. Brug i stedet:
  - **Halvanden-sten-løsningen:** afsluttende sten tilskæres af en ekstra bred sten (fig. "indskudt skifer"), eller
  - tilskær en hel sten i bredden inde på fladen, så den afsluttende sten bliver **min. halv bredde** — accepter at de lodrette løb brydes lokalt.
- Samme principper gælder ved grater og skotrender.
- **Skotrender:** zinkrende på fast underlag (brædder med fer og not + undertagspap ved fast undertag). Skiferen tilskæres mod renden med tilstrækkelig indbyrdes afstand til afvanding.
- Alle inddækninger (skorsten, ovenlys, taghætter, vindskeder) udføres efter Tag- og Facademappen. Naturskifer og lægter holdes ca. 5 mm fri af metalinddækninger.

### 6.6 Kitning (T-kitning)
Bruges ved oplægning **uden undertag** samt i **randzoner og ved gennembrud** selv med undertag:
- Kun **T-kitning** er acceptabel: en jævn, ca. 50–60 mm bred stribe skiferkit i T-mønster på stenen — vandret hen over sømhovederne og lodret i hele den lodrette fuge under den overliggende sten.
- Den lodrette stribe skal være **lige bred hele vejen**, ellers dannes vandlommer.
- **Randzone** = de 3 yderste sten ved gavl, langs skotrender og (i ekstreme vindzoner) ved rygning. **Gennembrud** = skorsten, ovenlys, taghætter: kit de 3 omgivende sten under, over og ved siden af.
- Kun godkendt skiferkit (vegetabilsk olie/rågummi, fx DANA 694) efter fabrikantens anvisning.

---

## 7. Særtilfælde

### 7.1 Oplægning uden undertag
Historisk korrekt (alle gamle danske skifertage ligger sådan), men accepteres i dag kun, hvor bygningsforhold umuliggør undertag. Risiko for fygesne/slagregnsindtrængen især de første år. Kræver konsekvent T-kitning. Diagonal- og rustikskifer må aldrig lægges uden undertag.

### 7.2 Genbrugsskifer
- Regn med væsentligt højere spild end 5 % — bankeprøv hver sten.
- Eksisterende sømhuller: sten kan vendes/omlokkes, hvis gamle huller ender skjult under overlægget; ellers kasseres stenen.
- Sortér ekstra hårdt i tykkelser og størrelser; gamle tage blander ofte formater.
- Ældre store formater (60×35, 65×40) giver andre lægteafstande — brug formlen i afsnit 3.

### 7.3 Udskiftning af enkeltsten i færdigt tag
Brug specialfjeder ("Fix-a-slate" eller tilsvarende): den nye sten skubbes på plads og holdes af fjederen uden synlig fastgørelse. Alternativt klassisk blyklips/tingle.

---

## 8. Kvalitetssikring — tjekliste

**Modtagekontrol:** varer kontrolleret for transportskade; paller opbevaret stående og stabilt; pallemærker gemt.

**Underlag:** planhed ≤ 2 mm/2 m; lægteafstand målt og dokumenteret; tagfod med opklodsningsliste og underlag for begynderrække; undertag/ventilation efter afsnit 4.

**Udførelse:** sten sorteret i 3 tykkelser og blandet fra flere paller; kobbersøm i korrekt dimension; to søm pr. sten, ingen opspænding; opstregning pr. angivet interval; fuge 1–5 mm; forskydning ½ sten; overlæg iht. hældningstabel; randzoner/gennembrud kittet hvor krævet.

**Dokumentation:** lægteafstand (cm), opstregningsinterval, fastgørelsestype, underkonstruktionstype, m² og skifertype noteres i KS-skema; garanticertifikat rekvireres hos leverandør med pallemærker og faktura.

---

## 9. Drift og vedligehold

Naturskifer kræver reelt ingen vedligeholdelse, men periodisk eftersyn anbefales:
- **Udvendigt:** afskalninger/revner (frost, bevægelse, trafik på taget); fastgørelsernes tilstand; alle inddækninger og fuger ved vindskeder, skorsten, ovenlys, skotrender; afrensning af mos/alger/blade; tagrender, nedløb og tagbrønde.
- **Indvendigt:** undertagets tæthed; skotrender; frie ventilationsåbninger.

---

## 10. Hyppige fejl (agentens røde flag)

1. **Opspændte søm** — sten slået fast i stedet for at hænge. Giver revner og utætheder.
2. **For lille overlæg til hældningen** — taget er "tæt" i tørvejr og utæt i slagregn/fygesne.
3. **Ingen sortering i tykkelser** — bulet tagflade, sten der vipper og knækker.
4. **Smalle strimler ved gavle/ovenlys** — kan ikke fastgøres; brug indskudt skifer/halvanden-sten.
5. **Manglende opklodsningsliste ved tagfod/kip** — første og sidste række vipper.
6. **Færdsel på den færdige dækning** under montage.
7. **Forkerte materialer i periferien** — galvaniserede søm, silikonefuge i stedet for skiferkit, undertag/lægter af ringere levetid end stenen.
8. **Manglende ventilation** ved diffusionstæt undertag → kondens og råd i konstruktionen.

---

## 11. Referencer til videre opslag

- Cupa Danmark: Projekteringsvejledning for naturskifer (cupadanmark.com) — fugtprincipper, opbygninger, lokning/sømning, kitning.
- Komproment: Montagevejledning naturskifertag (komproment.dk) — detaljetegninger for tagfod, kip, skotrende; lægteafstand 255 mm for 30×60.
- Inpro: Montering af skifertag (inpro.dk) — sortering, praktisk oplægning, lægteafstandsskema.
- TRÆ 54 "Undertage" (Træinformation) — fast undertag og ventilation.
- DUKO (Dansk Undertagsklassifikationsordning) — valg af banevareundertag.
- Tekniq/Dansk VVS: Tag- og Facademappen — alle metalinddækninger.
- BYG-ERFA-blade om tagdækning, undertage og skotrender — erfaringsbaserede detaljer.
- "Forskrifter for naturskifermaterialer, udførelse og kvalitetssikring", Plandirektoratet 1999 — historisk reference for københavnske ejendomme.
