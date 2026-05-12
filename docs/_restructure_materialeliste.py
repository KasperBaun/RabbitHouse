"""Restructure materialeliste.xlsx into per-variant sheets + summary.

Old layout (single master sheet, tagpap+klink only):
  materialeliste            — everything concatenated
  tagkonstruktion_tagpap    — duplicate scratch sheet (dropped)

New layout:
  summary                       — variant dropdowns + selected totals + comparison matrix
  fundament                     — shared
  konstruktion                  — shared
  tagkonstruktion_tagpap        — full tagpap roof BOM (rafters 45×95)
  tagkonstruktion_eternit_b7    — full eternit roof BOM (rafters 47×100, B7 plates)
  beklaedning_klink             — klink cladding BOM (incl. shared housewrap/insulation/mesh)
  beklaedning_board_on_board    — 1-på-2 cladding BOM (incl. shared bits)

Each data sheet uses the same 8-column layout (matches the original master):
  A Kategori | B Vare | C Antal | D Enhed | E Pris/enh | F I alt | G Leverandør | H Noter

F column is a formula =C*E. SUM(F:F) gives the sheet total.
"""
import openpyxl
from openpyxl.worksheet.datavalidation import DataValidation
from openpyxl.styles import Font, PatternFill, Alignment, Border, Side
from openpyxl.utils import get_column_letter
from copy import copy

XLSX = r'C:\dev\privat\rabbit-house\docs\materialeliste.xlsx'

# ---------------------------------------------------------------------------
# Styling
# ---------------------------------------------------------------------------
BOLD = Font(bold=True)
HEADER_FILL = PatternFill("solid", fgColor="DDDDDD")
SUBHEADER_FILL = PatternFill("solid", fgColor="EEEEEE")
TOTAL_FILL = PatternFill("solid", fgColor="FFF2CC")
DELTA_FILL = PatternFill("solid", fgColor="E2EFDA")
THIN = Side(border_style="thin", color="999999")
THIN_BORDER = Border(left=THIN, right=THIN, top=THIN, bottom=THIN)

# ---------------------------------------------------------------------------
# Data — preserved from the original sheet, split by category and variant.
# Each row: (kategori, vare, antal, enhed, pris_enh, leverandør, noter)
# ---------------------------------------------------------------------------

FUNDAMENT = [
    ("Fundament", "Stabilgrus 0-32 mm", 1050, "kg", 0.55, "materialepladsen.dk", "ca. 0,6 m³, 1.750 kg pr. m³"),
    ("Fundament", "Fundablok 50x20x15 cm", 120, "stk", 15.75, "jemogfix.dk", "Behov 117 stk; købes 120"),
    ("Fundament", "Armeringsjern Ø8 mm × 3 m", 13, "stk", 29.75, "jemogfix.dk", "I bundrem-rille"),
    ("Fundament", "Cement 25 kg", 14, "stk", 75.00, "jemogfix.dk", "1:4 blandingsforhold, 25 kg ~ 18 L"),
    ("Fundament", "Støbemix 0-16 mm", 1485, "kg", 0.66, "materialepladsen.dk", "ca. 0,9 m³, 1.650 kg pr. m³"),
    ("Fundament", "Gevindstang M10 × 1000 mm", 18, "stk", 27.95, "jemogfix.dk", "Ankerbolte gennem sokkel"),
    ("Fundament", "M10 møtrikker (12-pak)", 2, "pk.", 28.95, "jemogfix.dk", "NKT Fasteners"),
]

KONSTRUKTION = [
    ("Konstruktion", "Murpap (DPC)", 1, "stk", 99.00, "jemogfix.dk", "11 cm × 20 m — sokkel-isolering"),
    ("Konstruktion", "Bundrem 45×95×3600 PT NTR-AB", 2, "stk", 71.10, "jemogfix.dk", ""),
    ("Konstruktion", "Bundrem 45×95×2400 PT NTR-AB", 5, "stk", 47.40, "jemogfix.dk", ""),
    ("Konstruktion", "Toprem 47×100×3600 C24 gran", 4, "stk", 63.90, "jemogfix.dk", ""),
    ("Konstruktion", "Reglar 47×100×2400 C24 gran", 42, "stk", 42.60, "jemogfix.dk", "Vægreglar c/c 600"),
]

# Roof — TAGPAP variant
TAG_TAGPAP = [
    ("Træværk",        "Spær 45×95×3000 C24 gran",                  13, "stk",   53.25, "jemogfix.dk",  ""),
    ("Træværk",        "OSB-3 TG4 18 mm 2397×600 mm",               15, "stk",  129.00, "jemogfix.dk",  "Tagdæk"),
    ("Træværk",        "Sternbræt 21×120×3600 gran",                 6, "stk",   92.70, "jemogfix.dk",  "Hele perimeter 19 m"),
    ("Tagdækning",     "Phoenix Selvbyggerpap 1×5 m",                5, "stk",  579.00, "jemogfix.dk",  ""),
    ("Tagdækning",     "Phoenix klæbeasfalt 310 ml",                 3, "stk",   69.95, "jemogfix.dk",  ""),
    ("Tagdækning",     "Phoenix murpap til tagfod 15 cm × 20 m",     1, "stk",  149.00, "jemogfix.dk",  ""),
    ("Aluinddækning",  "Alu tagfod sort 55×80×1000 mm",              7, "stk",   39.75, "jemogfix.dk",  ""),
    ("Aluinddækning",  "Alu sternkapsel sort 35×25×1000 mm",        13, "stk",   59.95, "jemogfix.dk",  ""),
    ("Vandhåndtering", "Tagrende 110 mm (4+3 m)",                    7, "m",    49.95, "jemogfix.dk",  ""),
    ("Vandhåndtering", "Tagrende-beslag (konsoljern)",              10, "stk",  24.95, "jemogfix.dk",  "c/c 550 mm"),
    ("Vandhåndtering", "Samlestykke tagrende",                       1, "stk",  46.75, "jemogfix.dk",  ""),
    ("Vandhåndtering", "Endebund tagrende 110 mm",                   2, "stk",  43.75, "jemogfix.dk",  ""),
    ("Vandhåndtering", "Bladsamler",                                 1, "stk",  19.95, "jemogfix.dk",  ""),
    ("Vandhåndtering", "Nedløbsrør Ø75 mm × 3 m",                    1, "stk", 210.00, "jemogfix.dk",  "Stål"),
    ("Vandhåndtering", "Nedløbsbøjning",                             1, "stk",  78.75, "jemogfix.dk",  ""),
    ("Vandhåndtering", "Tudstykke til tagrende",                     1, "stk", 105.00, "jemogfix.dk",  "Ø75 mm"),
    ("Beslag",         "Paslode vinkelbeslag 90×90×40 (20-pak)",     3, "pak",  150.00, "wood-online.dk", "48 nødvendige; 60 stk i 3 pak"),
    ("Beslag",         "OSB/spær-skruer 5×80 mm",                  250, "stk",   0.40, "jemogfix.dk",  ""),
    ("Beslag",         "Galvaniseret tagpapsøm 2,6×25 mm (100-pak)", 1, "pk.",  69.95, "jemogfix.dk",  ""),
]

# Roof — ETERNIT_B7 variant (from docs/tagkonstruktion_eternit.md)
TAG_ETERNIT = [
    ("Træværk",        "Spær 47×100×3000 C24 gran",                 13, "stk",   85.00, "Stark",         "Tungere end tagpap-spær"),
    ("Træværk",        "C18 taglægte 38×73×4200 mm",                11, "stk",   52.50, "10-4.dk",       "6 rækker à ~6,44 m + spild"),
    ("Træværk",        "Imp. sternbræt 25×125×3600 gran",            6, "stk",   82.60, "xl-byg.dk",     "Hele perimeter ~19 m"),
    ("Tagdækning",     "Swisspearl B7 bølgeplade FK 1100×570 sortblå", 52, "stk", 95.00, "bygxtra.dk",    "49 hele + 5 % spild"),
    ("Tagdækning",     "Swisspearl 100 Tagskrue 6×100 (100-pak)",    2, "pak",  425.00, "davidsen.dk",   "2 pr. plade × 49 + spild ~108"),
    ("Tagdækning",     "Swisspearl PVC skumstrimmel 4,5 mm",         1, "rl.",  150.00, "Cembrit",       "Overlap-tætning"),
    ("Vandhåndtering", "Tagrende 110 mm (4+3 m)",                    7, "m",    49.95, "jemogfix.dk",   ""),
    ("Vandhåndtering", "Tagrende-beslag",                           12, "stk",   30.00, "jemogfix.dk",   "c/c 550 mm"),
    ("Vandhåndtering", "Endebund tagrende 110 mm",                   2, "stk",   50.00, "jemogfix.dk",   ""),
    ("Vandhåndtering", "Bladsamler 75-82 mm",                        1, "stk",   80.00, "jemogfix.dk",   ""),
    ("Vandhåndtering", "Nedløbsrør Ø75 mm × 3 m",                    1, "stk",  200.00, "jemogfix.dk",   ""),
    ("Vandhåndtering", "Nedløbsbøjning Ø75 mm",                      2, "stk",   80.00, "jemogfix.dk",   ""),
    ("Beslag",         "Paslode vinkelbeslag 90×90×40 (20-pak)",     3, "pak",  150.00, "wood-online.dk", ""),
    ("Beslag",         "Lægtesøm varmforzinket 2,8×60 (250-pak)",    1, "pk.",  120.00, "jemogfix.dk",   "Lægter på spær"),
]

# Cladding — KLINK variant
CLAD_KLINK = [
    ("Beklædning", "Klinkbeklædning sortmalet gran 25×125×4200 (pak)", 6, "pak", 497.70, "jemogfix.dk", "Frøslev klink, ~3 m² pr. pak"),
    ("Beklædning", "Hjørnetrim 45×45×2400 mm",                          4, "stk",  29.25, "jemogfix.dk", "4 udvendige hjørner"),
    ("Beklædning", "Vindpap (housewrap)",                                1, "rl.", 299.00, "jemogfix.dk", "20 m² pr. rulle; behov ~17,5 m²"),
    ("Beklædning", "Klemmelister 25×50×4200 mm",                       10, "stk",  28.35, "jemogfix.dk", "Lodrette afstandslister c/c 600"),
    ("Beklædning", "Isolering mineraluld 95 mm",                       20, "m²",   29.61, "jemogfix.dk", "I stud-rum, 2 vægge ~6 m² + 2 vægge ~4 m²"),
    ("Voliere",    "Voliernet welded 13×13 mm 1 m rl.",                  2, "stk",1350.00, "jemogfix.dk", "1×10 m + 1×25 m"),
    ("Voliere",    "Klamper til voliernet (pak)",                        2, "pk.",  89.00, "jemogfix.dk", "Galvaniserede sømklamper"),
]

# Cladding — BOARD_ON_BOARD (1-på-2) variant
# Aros Savværk: 1-på-2 svensk gran 25×150 savskåret ~160 kr/m² (tilbud), 225 kr/m² (normal).
# Net cladded area ≈ 16 m² (4 walls minus side window 0,42 m² + house door 1,78 m² + pet door 0,08 m²).
CLAD_BOB = [
    ("Beklædning", "1-på-2 svensk gran 25×150 savskåret",              16, "m²",  160.00, "arossavvaerk.dk", "Tilbudspris; normal 225 kr/m². 2 lag pr. m² indeholdt"),
    ("Beklædning", "Træolie/maling til naturligt træ",                   3, "L",    149.00, "jemogfix.dk",     "Behandling af gran 1-på-2 (klink kommer sortmalet)"),
    ("Beklædning", "Hjørnetrim 70×70×2400 mm trykimp.",                  4, "stk",   49.50, "jemogfix.dk",     "Større end klink-trim — bob-stickout = 50 mm"),
    ("Beklædning", "Vindpap (housewrap)",                                1, "rl.", 299.00, "jemogfix.dk",     "20 m² pr. rulle"),
    ("Beklædning", "Klemmelister 25×50×4200 mm",                       10, "stk",  28.35, "jemogfix.dk",     "Vandrette afstandslister c/c 600 (lodrette boards)"),
    ("Beklædning", "Isolering mineraluld 95 mm",                       20, "m²",   29.61, "jemogfix.dk",     "Samme som klink"),
    ("Beklædning", "Rustfri A4 facadeskruer 4×60 (200-pak)",             2, "pk.", 199.00, "jemogfix.dk",     "Begge lag i bob — flere skruer end klink"),
    ("Voliere",    "Voliernet welded 13×13 mm 1 m rl.",                  2, "stk",1350.00, "jemogfix.dk",     "1×10 m + 1×25 m"),
    ("Voliere",    "Klamper til voliernet (pak)",                        2, "pk.",  89.00, "jemogfix.dk",     ""),
]

# ---------------------------------------------------------------------------
# Sheet writers
# ---------------------------------------------------------------------------
HEADERS = ["Kategori", "Vare", "Antal", "Enhed", "Pris pr. enhed (DKK)",
           "I alt (DKK)", "Leverandør", "Noter"]
COL_WIDTHS = [16, 50, 8, 8, 16, 14, 22, 60]

def write_header(ws):
    for col, (h, w) in enumerate(zip(HEADERS, COL_WIDTHS), start=1):
        c = ws.cell(row=1, column=col, value=h)
        c.font = BOLD
        c.fill = HEADER_FILL
        c.border = THIN_BORDER
        ws.column_dimensions[get_column_letter(col)].width = w
    ws.freeze_panes = "A2"

def write_rows(ws, rows, start_row=2):
    r = start_row
    last_kategori = None
    for row in rows:
        kat, vare, antal, enhed, pris, lev, noter = row
        if kat != last_kategori and last_kategori is not None:
            r += 1   # blank separator
        ws.cell(row=r, column=1, value=kat).font = BOLD if kat != last_kategori else Font()
        ws.cell(row=r, column=2, value=vare)
        ws.cell(row=r, column=3, value=antal)
        ws.cell(row=r, column=4, value=enhed)
        ws.cell(row=r, column=5, value=pris)
        ws.cell(row=r, column=6, value=f"=C{r}*E{r}")
        ws.cell(row=r, column=7, value=lev)
        ws.cell(row=r, column=8, value=noter)
        for c in range(1, 9):
            ws.cell(row=r, column=c).border = THIN_BORDER
        last_kategori = kat
        r += 1
    return r   # next free row

def write_total(ws, last_row):
    # Per-sheet subtotal in column H (Noter) so summary's SUM(F:F) doesn't
    # double-count. SUBTOTAL(9,...) on the items also keeps F-column clean.
    r = last_row + 1
    ws.cell(row=r, column=5, value="TOTAL").font = BOLD
    ws.cell(row=r, column=5).fill = TOTAL_FILL
    total_cell = ws.cell(row=r, column=8, value=f"=SUM(F2:F{last_row-1})")
    total_cell.font = BOLD
    total_cell.fill = TOTAL_FILL
    total_cell.number_format = '#,##0.00 "kr"'
    for c in range(1, 9):
        ws.cell(row=r, column=c).border = THIN_BORDER
    return r

def write_data_sheet(wb, name, rows):
    if name in wb.sheetnames:
        del wb[name]
    ws = wb.create_sheet(name)
    write_header(ws)
    next_r = write_rows(ws, rows)
    write_total(ws, next_r)
    return ws

# ---------------------------------------------------------------------------
# Summary sheet
# ---------------------------------------------------------------------------
def write_summary(wb):
    if "summary" in wb.sheetnames:
        del wb["summary"]
    ws = wb.create_sheet("summary", 0)   # first sheet

    ws.column_dimensions["A"].width = 36
    ws.column_dimensions["B"].width = 22
    ws.column_dimensions["C"].width = 22
    ws.column_dimensions["D"].width = 22

    ws.cell(row=1, column=1, value="Rabbit-house BOM — variant selector").font = Font(bold=True, size=14)
    ws.merge_cells("A1:D1")

    # --- selector block ---
    ws.cell(row=3, column=1, value="Valgt tagdækning:").font = BOLD
    ws.cell(row=3, column=2, value="tagpap")
    dv_roof = DataValidation(type="list", formula1='"tagpap,eternit_b7"', allow_blank=False)
    dv_roof.add("B3")
    ws.add_data_validation(dv_roof)

    ws.cell(row=4, column=1, value="Valgt beklædning:").font = BOLD
    ws.cell(row=4, column=2, value="klink")
    dv_clad = DataValidation(type="list", formula1='"klink,board_on_board"', allow_blank=False)
    dv_clad.add("B4")
    ws.add_data_validation(dv_clad)

    # --- selected totals (via INDIRECT into chosen variant sheets) ---
    ws.cell(row=6, column=1, value="Valgt konfiguration — totaler").font = BOLD
    ws.cell(row=6, column=1).fill = SUBHEADER_FILL

    ws.cell(row=7, column=1, value="Fundament")
    ws.cell(row=7, column=2, value="=SUM(fundament!F:F)")
    ws.cell(row=8, column=1, value="Konstruktion")
    ws.cell(row=8, column=2, value="=SUM(konstruktion!F:F)")
    ws.cell(row=9, column=1, value="Tagkonstruktion")
    ws.cell(row=9, column=2, value='=SUM(INDIRECT("tagkonstruktion_"&B3&"!F:F"))')
    ws.cell(row=10, column=1, value="Beklædning")
    ws.cell(row=10, column=2, value='=SUM(INDIRECT("beklaedning_"&B4&"!F:F"))')

    ws.cell(row=11, column=1, value="TOTAL valgt").font = BOLD
    total_sel = ws.cell(row=11, column=2, value="=SUM(B7:B10)")
    total_sel.font = BOLD
    total_sel.fill = TOTAL_FILL
    ws.cell(row=11, column=1).fill = TOTAL_FILL

    # --- comparison matrix ---
    ws.cell(row=13, column=1, value="Sammenligning — alle 4 kombinationer").font = BOLD
    ws.cell(row=13, column=1).fill = SUBHEADER_FILL

    # Header row
    ws.cell(row=14, column=2, value="tagpap").font = BOLD
    ws.cell(row=14, column=3, value="eternit_b7").font = BOLD
    ws.cell(row=14, column=4, value="Δ (eternit − tagpap)").font = BOLD

    ws.cell(row=15, column=1, value="Klink").font = BOLD
    ws.cell(row=15, column=2, value="=SUM(fundament!F:F)+SUM(konstruktion!F:F)+SUM(tagkonstruktion_tagpap!F:F)+SUM(beklaedning_klink!F:F)")
    ws.cell(row=15, column=3, value="=SUM(fundament!F:F)+SUM(konstruktion!F:F)+SUM(tagkonstruktion_eternit_b7!F:F)+SUM(beklaedning_klink!F:F)")
    ws.cell(row=15, column=4, value="=C15-B15")
    ws.cell(row=15, column=4).fill = DELTA_FILL

    ws.cell(row=16, column=1, value="Board-on-board (1-på-2)").font = BOLD
    ws.cell(row=16, column=2, value="=SUM(fundament!F:F)+SUM(konstruktion!F:F)+SUM(tagkonstruktion_tagpap!F:F)+SUM(beklaedning_board_on_board!F:F)")
    ws.cell(row=16, column=3, value="=SUM(fundament!F:F)+SUM(konstruktion!F:F)+SUM(tagkonstruktion_eternit_b7!F:F)+SUM(beklaedning_board_on_board!F:F)")
    ws.cell(row=16, column=4, value="=C16-B16")
    ws.cell(row=16, column=4).fill = DELTA_FILL

    ws.cell(row=17, column=1, value="Δ (bob − klink)").font = BOLD
    ws.cell(row=17, column=2, value="=B16-B15")
    ws.cell(row=17, column=3, value="=C16-C15")
    ws.cell(row=17, column=2).fill = DELTA_FILL
    ws.cell(row=17, column=3).fill = DELTA_FILL

    # --- notes ---
    ws.cell(row=19, column=1, value="Noter").font = BOLD
    notes = [
        "Selectors i B3/B4 styrer total i B11 via INDIRECT.",
        "Tagkonstruktion_eternit_b7 bruger tungere spær (47×100 vs 45×95 ved tagpap).",
        "Board-on-board pris er Aros tilbudspris 160 kr/m² (normalpris 225). Klink kommer sortmalet; bob behøver træolie/maling.",
        "Voliernet og isolering er ens på tværs af beklædningsvarianter.",
        "Variantvalg i build.scad: roof_cover = \"tagpap_osb\"|\"eternit_b7\"; cladding_type = \"klink\"|\"board_on_board\".",
    ]
    for i, n in enumerate(notes):
        ws.cell(row=20 + i, column=1, value=f"• {n}")
        ws.merge_cells(start_row=20+i, end_row=20+i, start_column=1, end_column=4)
        ws.cell(row=20+i, column=1).alignment = Alignment(wrap_text=True, vertical="top")

    # Format numeric cells as DKK with thousand-separator
    for cell_addr in ["B7","B8","B9","B10","B11","B15","C15","D15","B16","C16","D16","B17","C17"]:
        ws[cell_addr].number_format = '#,##0.00 "kr"'

    return ws

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
def main():
    wb = openpyxl.load_workbook(XLSX)

    # 1. drop scratch sheets
    for stale in ("tagkonstruktion_tagpap", "materialeliste"):
        if stale in wb.sheetnames:
            del wb[stale]

    # 2. write new data sheets
    write_data_sheet(wb, "fundament",                  FUNDAMENT)
    write_data_sheet(wb, "konstruktion",               KONSTRUKTION)
    write_data_sheet(wb, "tagkonstruktion_tagpap",     TAG_TAGPAP)
    write_data_sheet(wb, "tagkonstruktion_eternit_b7", TAG_ETERNIT)
    write_data_sheet(wb, "beklaedning_klink",          CLAD_KLINK)
    write_data_sheet(wb, "beklaedning_board_on_board", CLAD_BOB)

    # 3. summary
    write_summary(wb)

    # 4. order: summary, common, then variants
    order = [
        "summary",
        "fundament",
        "konstruktion",
        "tagkonstruktion_tagpap",
        "tagkonstruktion_eternit_b7",
        "beklaedning_klink",
        "beklaedning_board_on_board",
    ]
    wb._sheets = [wb[n] for n in order]

    # Format number columns in data sheets
    for sheet_name in order[1:]:
        ws = wb[sheet_name]
        for row in ws.iter_rows(min_row=2):
            # E = pris, F = i alt
            row[4].number_format = '#,##0.00'   # Pris
            row[5].number_format = '#,##0.00'   # I alt

    wb.save(XLSX)
    print(f"Wrote {XLSX}")
    print(f"Sheets: {wb.sheetnames}")

if __name__ == "__main__":
    main()
