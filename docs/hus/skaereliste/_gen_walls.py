# -*- coding: utf-8 -*-
# Generér simple 2D væg-elevationer (SVG) med målsætning for hus-vægge V1-V4.
#
# Brug:
#   python _gen_walls.py            # skriver V1-V4 *.svg i denne mappe
#
# PNG (til markdown-preview) renderes fra SVG'erne med en headless browser, fx:
#   chrome --headless=new --disable-gpu --force-device-scale-factor=2 \
#     --screenshot=V1-front.png --window-size=625,775 file:///.../V1-front.svg
# (V3/V4 er bredere: brug --window-size=830,775.)
#
# Mål stammer fra src/designs/config.scad + house/framing.scad:
#   RH_HOUSE_LEN=2000, RH_HOUSE_DEPTH=3000, bundrem-top (RH_FLOOR_TOP)=167,
#   stud=2200, toprem-top=2412. Studs/jambs/headers fra RenderHouseFraming.
import os

OUT = os.path.dirname(os.path.abspath(__file__))
S = 0.235                      # px per mm
LEFT, RIGHT, TOP, BOT = 105, 40, 124, 104
HTOP, HBOT = 2245.0, -45.0     # toprem-top .. bundrem-bund

C_STUD = ("#e6c894", "#9c7b4e")
C_BUND = ("#a9be8e", "#6f855a")
C_TOP  = ("#f1ddb0", "#b89b63")
C_BLK  = ("#d2a266", "#946a35")
C_OPEN = ("#ffffff", "#b9b9b9")
DIM    = "#3a3a3a"

def gen(fname, title, sub, length, pieces, openings, hticks, vticks, note,
        opdims=None, labels=None):
    w = LEFT + length*S + RIGHT
    h = TOP + (HTOP-HBOT)*S + BOT
    def mx(x): return LEFT + x*S
    def my(z): return TOP + (HTOP - z)*S
    e = []
    e.append(f'<svg xmlns="http://www.w3.org/2000/svg" width="{w:.0f}" height="{h:.0f}" '
             f'viewBox="0 0 {w:.0f} {h:.0f}" font-family="Segoe UI, Arial, sans-serif">')
    e.append(f'<rect x="0" y="0" width="{w:.0f}" height="{h:.0f}" fill="#fcfbf8"/>')
    # title
    e.append(f'<text x="{LEFT}" y="34" font-size="23" font-weight="700" fill="#222">{title}</text>')
    e.append(f'<text x="{LEFT}" y="58" font-size="13" fill="#666">{sub}</text>')
    # legend — horizontal strip in the header, clear of the drawing
    leg=[("Stud 45×95",C_STUD),("Bundrem (PT)",C_BUND),("Toprem (gran)",C_TOP),
         ("Header/sål/cripple",C_BLK)]
    lx=LEFT; ly=92
    for (t,c) in leg:
        e.append(f'<rect x="{lx:.0f}" y="{ly-10:.0f}" width="14" height="12" fill="{c[0]}" '
                 f'stroke="{c[1]}"/>')
        e.append(f'<text x="{lx+19:.0f}" y="{ly:.0f}" font-size="11" fill="#555">{t}</text>')
        lx += 19 + len(t)*6.0 + 22
    # pieces
    def rect(x0,x1,z0,z1,col,rx=0):
        f,st = col
        e.append(f'<rect x="{mx(x0):.1f}" y="{my(z1):.1f}" width="{(x1-x0)*S:.1f}" '
                 f'height="{(z1-z0)*S:.1f}" fill="{f}" stroke="{st}" stroke-width="1" rx="{rx}"/>')
    # openings first (background)
    for (x0,x1,z0,z1,lab) in openings:
        f,st = C_OPEN
        e.append(f'<rect x="{mx(x0):.1f}" y="{my(z1):.1f}" width="{(x1-x0)*S:.1f}" '
                 f'height="{(z1-z0)*S:.1f}" fill="{f}" stroke="{st}" stroke-width="1.3" '
                 f'stroke-dasharray="5 4"/>')
        cx=mx((x0+x1)/2); cy=my((z0+z1)/2)
        for i,ln in enumerate(lab.split("\n")):
            e.append(f'<text x="{cx:.1f}" y="{cy+i*15-4:.1f}" font-size="12.5" fill="#8a8a8a" '
                     f'text-anchor="middle">{ln}</text>')
    for p in pieces:
        x0,x1,z0,z1,kind = p[:5]
        col = {"stud":C_STUD,"bund":C_BUND,"top":C_TOP,"blk":C_BLK}[kind]
        rect(x0,x1,z0,z1,col)
        # length label on non-stud blocks
        if kind=="blk":
            horiz = (x1-x0) >= (z1-z0)
            if horiz:
                e.append(f'<text x="{mx((x0+x1)/2):.1f}" y="{my((z0+z1)/2)+4:.1f}" '
                         f'font-size="10.5" fill="#5a3d18" text-anchor="middle">{int(x1-x0)}</text>')
            else:
                cx=mx((x0+x1)/2); cy=my((z0+z1)/2)
                e.append(f'<text x="{cx:.1f}" y="{cy:.1f}" font-size="10" fill="#5a3d18" '
                         f'text-anchor="middle" transform="rotate(-90 {cx:.1f} {cy:.1f})">{int(z1-z0)}</text>')
    # plate length labels (bundrem/toprem)
    e.append(f'<text x="{mx(length/2):.1f}" y="{my(2222):.1f}" font-size="11" fill="#7a6533" '
             f'text-anchor="middle">TOPREM 45×95 · {int(length)}</text>')
    e.append(f'<text x="{mx(length/2):.1f}" y="{my(-22):.1f}" font-size="11" fill="#4f6038" '
             f'text-anchor="middle" dy="4">BUNDREM 95×45 · {int(length)} (PT)</text>')

    # free-text annotations: (x, h, text, rotate?)
    if labels:
        for (lx2,lh,txt,rot) in labels:
            cx=mx(lx2); cy=my(lh)
            tr=f' transform="rotate(-90 {cx:.1f} {cy:.1f})"' if rot else ''
            e.append(f'<text x="{cx:.1f}" y="{cy:.1f}" font-size="10" fill="#5a3d18" '
                     f'text-anchor="middle"{tr}>{txt}</text>')

    # ---- bottom horizontal dimension chain ----
    dy = my(HBOT) + 34
    e.append(f'<line x1="{mx(hticks[0][0]):.1f}" y1="{dy:.1f}" x2="{mx(hticks[-1][0]):.1f}" '
             f'y2="{dy:.1f}" stroke="{DIM}" stroke-width="1"/>')
    for (pos,_) in hticks:
        e.append(f'<line x1="{mx(pos):.1f}" y1="{my(HBOT):.1f}" x2="{mx(pos):.1f}" '
                 f'y2="{dy+5:.1f}" stroke="#bbb" stroke-width="0.8"/>')
        e.append(f'<line x1="{mx(pos):.1f}" y1="{dy-4:.1f}" x2="{mx(pos):.1f}" '
                 f'y2="{dy+4:.1f}" stroke="{DIM}" stroke-width="1"/>')
    for i in range(len(hticks)-1):
        a=hticks[i][0]; b=hticks[i+1][0]
        e.append(f'<text x="{mx((a+b)/2):.1f}" y="{dy-6:.1f}" font-size="11.5" fill="{DIM}" '
                 f'text-anchor="middle">{int(b-a)}</text>')
    for i,(pos,lbl) in enumerate(hticks):
        close = i>0 and (pos-hticks[i-1][0])*S < 34
        yy = dy+30 if close else dy+18
        e.append(f'<text x="{mx(pos):.1f}" y="{yy:.1f}" font-size="10.5" fill="#777" '
                 f'text-anchor="middle">{lbl}</text>')
    # extra opening dims (small, above wall) : list of (x0,x1,z,text)
    if opdims:
        for (x0,x1,z,txt) in opdims:
            yy=my(z)
            e.append(f'<line x1="{mx(x0):.1f}" y1="{yy:.1f}" x2="{mx(x1):.1f}" y2="{yy:.1f}" '
                     f'stroke="{DIM}" stroke-width="0.9"/>')
            for xx in (x0,x1):
                e.append(f'<line x1="{mx(xx):.1f}" y1="{yy-3:.1f}" x2="{mx(xx):.1f}" '
                         f'y2="{yy+3:.1f}" stroke="{DIM}" stroke-width="0.9"/>')
            e.append(f'<text x="{mx((x0+x1)/2):.1f}" y="{yy-4:.1f}" font-size="10.5" '
                     f'fill="{DIM}" text-anchor="middle">{txt}</text>')

    # ---- left vertical dimension axis (absolute height from bundrem) ----
    vx = LEFT - 46
    e.append(f'<line x1="{vx:.1f}" y1="{my(vticks[0]):.1f}" x2="{vx:.1f}" '
             f'y2="{my(vticks[-1]):.1f}" stroke="{DIM}" stroke-width="1"/>')
    for z in vticks:
        e.append(f'<line x1="{vx-4:.1f}" y1="{my(z):.1f}" x2="{vx+4:.1f}" y2="{my(z):.1f}" '
                 f'stroke="{DIM}" stroke-width="1"/>')
        e.append(f'<line x1="{vx+4:.1f}" y1="{my(z):.1f}" x2="{mx(0):.1f}" y2="{my(z):.1f}" '
                 f'stroke="#ddd" stroke-width="0.6"/>')
        e.append(f'<text x="{vx-7:.1f}" y="{my(z)+4:.1f}" font-size="10.5" fill="{DIM}" '
                 f'text-anchor="end">{int(z)}</text>')
    e.append(f'<text x="{vx-30:.1f}" y="{my(1100):.1f}" font-size="11" fill="#777" '
             f'text-anchor="middle" transform="rotate(-90 {vx-30:.1f} {my(1100):.1f})">'
             f'højde fra bundrem (mm)</text>')

    # note
    e.append(f'<text x="{LEFT}" y="{h-12:.0f}" font-size="11" fill="#555">{note}</text>')
    e.append('</svg>')
    path=os.path.join(OUT,fname)
    with open(path,"w",encoding="utf-8") as f: f.write("\n".join(e))
    return path

# ---------------- V1 FRONT ----------------
v1_pieces=[(0,2000,-45,0,"bund"),(0,2000,2200,2245,"top"),
    (0,45,0,2200,"stud"),(460,505,0,2200,"stud"),(505,550,0,2200,"stud"),
    (1450,1495,0,2200,"stud"),(1495,1540,0,2200,"stud"),(1955,2000,0,2200,"stud"),
    (45,90,0,955,"blk"),(45,90,1495,2200,"blk"),(1910,1955,0,955,"blk"),(1910,1955,1495,2200,"blk"),
    (828,873,2045,2200,"blk"),
    (550,1450,2000,2045,"blk"),
    (45,460,1450,1495,"blk"),(1540,1955,1450,1495,"blk"),
    (45,460,955,1000,"blk"),(1540,1955,955,1000,"blk")]
v1_open=[(550,1450,0,2000,"DØR\n900×2000"),(90,460,1000,1450,"VINDUE\n415×450"),
    (1540,1910,1000,1450,"VINDUE\n415×450")]
gen("V1-front.svg","V1 — FRONT","set udefra · mål i mm · 0 = venstre hjørne / bundrem-overkant",2000,
    v1_pieces,v1_open,
    [(0,"0"),(460,"460"),(550,"550"),(1450,"1450"),(1540,"1540"),(2000,"2000")],
    [0,1000,1450,2000,2200],
    "Lodrette studs: 45×95 · L=2200. Hjørne+junction i hver ende; jamb-par (45+45) langs dør/vindue.",
    opdims=[(45,460,1640,"vindue 45→460"),(1540,1955,1640,"1540→1955")])

# ---------------- V2 BAG ----------------
v2_pieces=[(0,2000,-45,0,"bund"),(0,2000,2200,2245,"top"),
    (0,45,0,2200,"stud"),(600,645,0,2200,"stud"),(1200,1245,0,2200,"stud"),
    (1800,1845,0,2200,"stud"),(1955,2000,0,2200,"stud")]
gen("V2-bag.svg","V2 — BAG","set udefra · mål i mm · 0 = venstre hjørne / bundrem-overkant",2000,
    v2_pieces,[],
    [(0,"0"),(600,"600"),(1200,"1200"),(1800,"1800"),(2000,"2000")],
    [0,2200],
    "Solid væg, ingen åbninger. 5 studs 45×95 · L=2200, c/c 600 (venstre-kant ved 0/600/1200/1800).")

# ---------------- V3 VENSTRE ----------------  p=Y-95
v3_pieces=[(0,2810,-45,0,"bund"),(0,2810,2200,2245,"top")]+[
    (p,p+45,0,2200,"stud") for p in (0,600,1200,1800,2400,2765)]
gen("V3-venstre.svg","V3 — VENSTRE GAVL","set udefra · mål i mm · 0 = hjørne mod V1 (Y=95) / bundrem-overkant",2810,
    v3_pieces,[],
    [(0,"0"),(600,"600"),(1200,"1200"),(1800,"1800"),(2400,"2400"),(2810,"2810")],
    [0,2200],
    "Solid væg. 6 studs 45×95 · L=2200, c/c 600. Sidste stud (end-emit) ved 2765, mod V2-hjørne.")

# ---------------- V4 PARTITION ----------------  p=Y-95
v4_pieces=[(0,2810,-45,0,"bund"),(0,2810,2200,2245,"top"),
    (0,45,0,2200,"stud"),(600,645,0,2200,"stud"),
    (1360,1405,0,2200,"stud"),(2275,2320,0,2200,"stud"),(2560,2605,0,2200,"stud"),
    (1405,2275,2000,2045,"blk"),       # hus-dør header 870
    (1683,1728,2045,2200,"blk"),       # cripple over hus-dør header 155
    (2605,2810,360,405,"blk"),         # pet-dør header 205 (klippet ved væg-ende)
    (2810,2855,0,2200,"stud")]         # V4/V2-hjørnestud (lige forbi vægenden, delt m. V2)
v4_open=[(1405,2275,0,2000,"HUS-DØR\n870×2000"),(2605,2810,60,360,"PET-DØR\n250×300")]
gen("V4-partition.svg","V4 — PARTITION","set fra yard (+X) · mål i mm · 0 = hjørne mod V1 (Y=95) / bundrem-overkant",2810,
    v4_pieces,v4_open,
    [(0,"0"),(600,"600"),(1405,"1405"),(2275,"2275"),(2605,"2605"),(2810,"2810")],
    [0,360,2000,2200],
    "Studs 45×95 · L=2200. Pet-dør sidder i V4/V2-hjørnet — højre jamb = hjørnestud (delt m. V2). Sål-trin h=60.",
    labels=[(2830,1100,"V4/V2-hjørne",True)])
print("done")
