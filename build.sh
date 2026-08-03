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

python3 - <<'PY'
import pathlib, re, sys

# src-Datei -> Verzeichnis, unter dem die Variante ausgeliefert wird
SEITEN = {
    'trojan-A-matrix.src.html':  'matrix',
    'trojan-B-phalanx.src.html': 'phalanx',
    'trojan-C-arena.src.html':   'arena',
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

    out = pathlib.Path(ziel, 'index.html')
    out.parent.mkdir(exist_ok=True)
    out.write_text(html, encoding='utf-8')
    print(f'{out}  ({len(html)/1024:.0f} kB)')
PY
