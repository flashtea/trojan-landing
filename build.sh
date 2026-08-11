#!/usr/bin/env bash
# Baut aus src/*.src.html die auslieferbaren Seiten.
#
# Die Quellen enthalten Platzhalter statt Bildpfaden, damit dieselbe Datei
# sowohl als self-contained Einzeldatei (data:-URIs, siehe standalone.sh)
# als auch fuer die statische Seite hier gebaut werden kann.
#
#   __LOGO__      assets/logo.png        Wortmarke
#   __MONO__      assets/monogram.png    Monogramm, schwarz
#   __MONOA__     assets/monoalpha.png   Monogramm, weiss auf transparent
#   __PH_XXX__    assets/o-xxx.jpg       Foto von trojanperformance.at
#
# Ziel: <variante>/index.html  ->  saubere URLs ohne .html
set -euo pipefail
cd "$(dirname "$0")"

# WebP-Zwillinge erzeugen, wo sie fehlen oder älter als das JPEG sind.
# Method 6 rechnet länger, komprimiert aber spürbar besser — bei einer Handvoll
# Bildern, die selten wechseln, ist das die richtige Seite des Tauschs.
for jpg in assets/*.jpg; do
  webp="${jpg%.jpg}.webp"
  if [ ! -f "$webp" ] || [ "$jpg" -nt "$webp" ]; then
    magick "$jpg" -quality 72 -define webp:method=6 "$webp"
    printf 'webp  %-24s %5s kB -> %5s kB\n' "$(basename "$webp")" \
      "$(( $(stat -c%s "$jpg") / 1024 ))" "$(( $(stat -c%s "$webp") / 1024 ))"
  fi
done

python3 - <<'PY'
import pathlib, re, sys

# src-Datei -> Verzeichnis, unter dem die Variante ausgeliefert wird
SEITEN = {
    'trojan-A-matrix.src.html':    'matrix',
    'trojan-B-phalanx.src.html':   'phalanx',
    'trojan-C-arena.src.html':     'arena',
    # zweite Runde: D und E aus Arena entwickelt, F bis H unabhaengig entstanden
    'trojan-D-stele.src.html':     'stele',
    'trojan-E-umbra.src.html':     'umbra',
    'trojan-F-logbuch.src.html':   'logbuch',
    'trojan-G-protokoll.src.html': 'protokoll',
    'trojan-H-rotstift.src.html':  'rotstift',
    # dritte Runde: die Seite als ein Satz, den der Besucher zu Ende spricht
    'trojan-I-satz.src.html':      'satz',
    # Protokoll in weichem Dunkel — Aufbau unverändert, nur das Farbsystem
    'trojan-J-nacht.src.html':     'nacht',
    # vierte Runde: je eine erzwungene Beschränkung, damit sie nicht konvergieren
    'trojan-K-schrift.src.html':   'schrift',   # kein einziges Foto
    'trojan-L-schirm.src.html':    'schirm',    # alles auf einem Schirm, kein Scrollen
    'trojan-M-spalte.src.html':    'spalte',    # geteilt: eine Hälfte steht, eine läuft
    # fünfte Runde, wieder je eine eigene Beschränkung
    'trojan-N-quer.src.html':      'quer',      # wird geblättert, nicht gescrollt
    'trojan-O-fluss.src.html':     'fluss',     # ein Text, keine Abschnitte
    'trojan-P-spektrum.src.html':  'spektrum',  # die echten Kursfarben als System
    'trojan-Q-grau.src.html':      'grau',      # kein einziger Farbwert
    'trojan-R-wende.src.html':     'wende',     # zwei Fassungen in einer Seite
    # sechste Runde: nicht weniger Gestaltung, weniger Inhalt. Arena, auf das
    # gekuerzt, was vor der Entscheidung fuer ein Probetraining gebraucht wird.
    'trojan-S-kern.src.html':      'kern',
    # siebte Runde: Bewegung als Mittel, nicht als Zierde — ein Takt, aus dem
    # jede Dauer und jeder Zustandswechsel abgeleitet ist.
    'trojan-T-puls.src.html':      'puls',
}

FEST = {
    '__LOGO__':  'logo.png',
    '__MONO__':  'monogram.png',
    '__MONOA__': 'monoalpha.png',
}

# Die Seiten liegen eine Ebene tief, die Bilder teilen sich alle Varianten.
PREFIX = '../assets/'

# Entwuerfe, keine Suchergebnisse -- sie sollen der echten Seite des Kunden
# nicht in den Index laufen.
NOINDEX = ('<meta name="robots" content="noindex, nofollow">\n'
           '<link rel="icon" href="../assets/monogram.png">\n')

# Jedes <img> auf ein JPEG bekommt ein <picture> mit WebP davor. WebP spart
# hier im Schnitt die Hälfte; das JPEG bleibt als Rückfall stehen, damit die
# Seite auch ohne WebP-Unterstützung vollständig ist. Die Quelldateien in src/
# bleiben lesbares, einfaches <img>-Markup.
def webp_umhuellen(html):
    def ersetze(m):
        tag, datei = m.group(0), m.group(1)
        webp = pathlib.Path('assets', pathlib.Path(datei).stem + '.webp')
        if not webp.exists():
            return tag
        # loading/fetchpriority stehen am <img> und gelten für das ganze <picture>
        return (f'<picture><source type="image/webp" srcset="{PREFIX}{webp.name}">'
                f'{tag}</picture>')
    return re.sub(r'<img\b[^>]*?src="\.\./assets/([a-z0-9-]+\.jpg)"[^>]*>', ersetze, html)


for src, ziel in SEITEN.items():
    html = pathlib.Path('src', src).read_text(encoding='utf-8')

    for name in sorted(set(re.findall(r'__PH_([A-Z0-9]+)__', html))):
        bild = pathlib.Path('assets') / f'o-{name.lower()}.jpg'
        if not bild.exists():
            sys.exit(f'FEHLT: {bild} (angefordert von {src})')
        html = html.replace(f'__PH_{name}__', PREFIX + bild.name)

    for k, v in FEST.items():
        if not pathlib.Path('assets', v).exists():
            sys.exit(f'FEHLT: assets/{v} (angefordert von {src})')
        html = html.replace(k, PREFIX + v)

    offen = re.findall(r'__[A-Z0-9_]+__', html)
    if offen:
        sys.exit(f'Nicht ersetzt in {src}: {sorted(set(offen))}')

    html = html.replace('<title>', NOINDEX + '<title>', 1)
    html = webp_umhuellen(html)

    out = pathlib.Path(ziel, 'index.html')
    out.parent.mkdir(exist_ok=True)
    out.write_text(html, encoding='utf-8')
    print(f'{out}  ({len(html)/1024:.0f} kB)')
PY
