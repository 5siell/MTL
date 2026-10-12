"""Single source of truth for the guide's table of contents.

Edit CATEGORIES, then run:  python3 tools/toc.py
It rewrites the table of contents on index.html and the "Jump to Chapter"
dropdown on every page, so the two always match.
"""
import glob, html, os, re

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

CATEGORIES = [
    ("General Information", [
        ("00Abstract.html", "Abstract"),
        ("01Introduction.html", "Introduction"),
        ("02UsefulLinks.html", "Useful Links"),
        ("03GeneralThings.html", "General Things regarding the MTL"),
        ("04MoveOrder.html", "Move Order"),
        ("04PickingPhase.html", "Picking Phase"),
        ("04TurnPhases.html", "Turn Phases"),
        ("05GeneralGameplay.html", "General Gameplay"),
        ("06Rounding.html", "Rounding"),
        ("07CardSettings.html", "Card Settings"),
        ("08SpecificTricks.html", "Specific Tricks"),
    ]),
    ("Weighted Random", [
        ("09WRIntroduction.html", "WR Introduction"),
        ("10WRKillRates.html", "WR Kill Rates"),
        ("11Belarus.html", "Belarus"),
        ("12GreatLakes.html", "Great Lakes"),
        ("13BritishRaj.html", "British Raj"),
        ("14RandomisedStratME.html", "Randomised Strat ME"),
        ("15StratME.html", "Strat ME"),
        ("16Phobia.html", "Phobia"),
        ("17FinalFantasyVII.html", "Final Fantasy VII"),
        ("18Tor-ture.html", "Tor-ture"),
        ("19StrategicCommanders.html", "Strategic Commanders"),
        ("20PangeaUltima.html", "Pangea Ultima"),
    ]),
    ("Niche", [
        ("31FrenchBrawl.html", "French Brawl"),
        ("32YorkshireBrawl.html", "Yorkshire Brawl"),
        ("33.Guiroma.html", "Guiroma"),
        ("34BfME.html", "Battle for Middle Earth"),
        ("41_7550KillRates.html", "75/50 Kill Rates"),
        ("42_TimidLands.html", "Timid Lands"),
        ("43_FastEarth.html", "Fast Earth"),
    ]),
    ("Local Deployment", [
        ("51_Local Deployment.html", "Local Deployment"),
        ("52_TurkeyLD.html", "Turkey LD"),
        ("53_GreeceLD.html", "Greece LD"),
        ("54_SuccessionWars.html", "Succession Wars"),
    ]),
    ("Army Cap and Multi Attack", [
        ("55ArmyCap.html", "Army Cap"),
        ("56GeorgiaAC.html", "Georgia Army Cap"),
        ("58Multi-Attack.html", "Multi Attack"),
        ("59Bork.html", "Bork"),
        ("60MALD.html", "MALD - MME multi attack local deployment"),
        ("61BIVMA.html", "Battle Islands IV multi attack"),
    ]),
    ("Not so vanilla", [
        ("62IslandOfRuins.html", "Island of Ruins"),
        ("63LampuriaSwap.html", "Lampuria Swap"),
        ("64MacedoniaNoSplit.html", "Macedonia No Split"),
        ("65Landria.html", "Landria"),
        ("66Earthsea.html", "Earthsea"),
        ("67Tarabonia's Choice.html", "Tarabonia's Choice"),
    ]),
    ("INSS", [
        ("68_INSS.html", "INSS"),
        ("69_ElitistAfrica.html", "Elitist Africa"),
        ("70_BiomesOfAmerica.html", "Biomes of America"),
        ("71_AseridithIslands.html", "Aseridith Islands"),
    ]),
    ("Vanilla - 5 armies per initial territory", [
        ("72__StratGreece.html", "Strategic Greece"),
    ]),
    ("Vanilla - 4 armies per initial territory - 4 spawns - 5 income", [
        ("73__BlackSea.html", "Black Sea"),
        ("74__Malvia.html", "Malvia"),
        ("75__VolcanoIsland.html", "Volcano Island"),
        ("76__WorldofWarhammer.html", "World of Warhammer"),
    ]),
    ("Vanilla - 4 armies per initial territory - 3 spawns - 5 income", [
        ("77__Post-meltAntarctica.html", "Post-melt Antarctica"),
        ("78__Basileia.html", "Basileia"),
        ("79__BIV.html", "BIV"),
        ("80__StratMME.html", "Strat MME - Strategic 1vs1"),
    ]),
    ("Vanilla - 4 armies per initial territory - 4 income", [
        ("81__Laketown.html", "Laketown"),
        ("82__SaudiArabia.html", "Saudi Arabia"),
        ("83__TreasureMap.html", "Treasure Map"),
    ]),
    ("Vanilla - 3 armies per initial territory - 5 income", [
        ("84__UnicornIsland.html", "Unicorn Island"),
    ]),
    ("Vanilla - 3 armies per initial territory - 4 income", [
        ("85__Discovery.html", "Discovery"),
        ("86__GMEIII.html", "GME III"),
        ("87__Hannibal.html", "Hannibal at the Gates"),
    ]),
    ("Vanilla - 3 armies per initial territory - 3 income", [
        ("89__Numenor.html", "Numenor"),
        ("88__Australia.html", "Australia"),
    ]),
    ("Vanilla - 2 armies per initial territory", [
        ("90__SlowBurn.html", "Slow Burn"),
    ]),
    ("Luck", [
        ("91How_Luck_Works.html", "How Luck Works"),
        ("92CalculatingLuck.html", "Calculating Luck"),
    ]),
]

# Old URLs kept only as redirects to their new pages (not listed in the TOC)
REDIRECTS = {"04MoveOrderandPickingPhase.html"}

e = lambda s: html.escape(s, quote=False)
attr = lambda s: html.escape(s, quote=True)


def toc_html():
    out = ['        <h2>Table of Contents</h2>', '        <div class="toc">']
    for cat, pages in CATEGORIES:
        out.append('            <div class="toc-group">')
        out.append(f'                <h3>{e(cat)}</h3>')
        out.append('                <ul>')
        for href, label in pages:
            out.append(f'                    <li><a href="{attr(href)}">{e(label)}</a></li>')
        out.append('                </ul>')
        out.append('            </div>')
    out.append('        </div>')
    return '\n'.join(out) + '\n'


def select_html():
    out = ["<select onchange='if(this.value) window.location.href=this.value'>",
           "            <option value=''>-- Jump to Chapter --</option>"]
    for cat, pages in CATEGORIES:
        out.append(f'            <optgroup label="{attr(cat)}">')
        for href, label in pages:
            out.append(f'                <option value="{attr(href)}">{e(label)}</option>')
        out.append('            </optgroup>')
    out.append('        </select>')
    return '\n'.join(out)


def rw(path, fn):
    raw = open(path, 'rb').read()
    bom = raw.startswith(b'\xef\xbb\xbf')
    s = raw.decode('utf-8-sig')
    n = fn(s)
    if n != s:
        open(path, 'wb').write((b'\xef\xbb\xbf' if bom else b'') + n.encode('utf-8'))


def main():
    os.chdir(ROOT)
    listed = [h for _, ps in CATEGORIES for h, _ in ps]
    missing = [h for h in listed if not os.path.exists(h)]
    unlisted = sorted(set(glob.glob('*.html')) - set(listed) - {'index.html'} - REDIRECTS)
    if missing: raise SystemExit(f'Listed but missing: {missing}')
    if unlisted: print('Note - pages not in the table of contents:', unlisted)

    rw('index.html', lambda s: re.sub(
        r'[ \t]*<h2>Table of Contents</h2>.*?(?=\s*</main>)', lambda _: toc_html().rstrip('\n'), s, flags=re.S))
    sel = select_html()
    for p in set(glob.glob('*.html')) - REDIRECTS:
        rw(p, lambda s: re.sub(r'<select\b.*?</select>', lambda _: sel, s, count=1, flags=re.S))
    print(f'Updated index and dropdowns: {len(CATEGORIES)} categories, {len(listed)} pages.')


if __name__ == '__main__':
    main()
