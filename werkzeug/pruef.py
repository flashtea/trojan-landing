#!/usr/bin/env python3
"""Prueft einen geschnittenen Entwurf gegen den Auftrag in schnitt.md.

    python3 pruef.py <ordner> [<ordner> ...]

Meldet nur, was nicht stimmt. Ueberlauf und Konsolenfehler prueft es nicht —
dafuer ist schuss.mjs/klick.mjs zustaendig, das laeuft im Browser.
"""
import re, sys, pathlib

VORHER = {'stele':928,'umbra':788,'logbuch':1035,'protokoll':1174,'rotstift':1060,
          'satz':645,'nacht':1174,'schrift':1051,'schirm':105,'spalte':1017,
          'quer':901,'fluss':1241,'spektrum':810,'grau':1022,'wende':1466,
          'kern':790}

# Was nach dem Schnitt nicht mehr vorkommen darf, mit Begruendung.
VERBOTEN = [
    (r'\bacht\s+kurse\b',        'Kurszahl "acht" — widerlegt vom eigenen Wochenplan'),
    (r'\bsechs\s+tage\b',        '"sechs Tage" — die Woche hat sieben'),
    (r'zwei\s+gehen\s+auch',     'der vom Kunden gestrichene Satz'),
    (r'\bskierg\b',              'HYROX-Rennstation'),
    (r'sled\s+p(?:ush|ull)',     'HYROX-Rennstation'),
    (r'wall\s?balls?\b',         'HYROX-Rennstation'),
    (r'burpee\s+broad',          'HYROX-Rennstation'),
    (r'farmers\s+carry',         'HYROX-Rennstation'),
    (r'sandbag\s+lunges',        'HYROX-Rennstation'),
    (r'koordination\s*&amp;\s*technik|koordination\s*&\s*technik',
                                 'die erfundene Kraft/Ausdauer/Technik-Achse'),
    (r'<form\b',                 'Kontaktformular'),
    (r'staatsmeister|olympiast|badminton|eishockey|psychologe',
                                 'Coach-Biografie'),
]

def sichtbar(html):
    h = re.sub(r'<(script|style)\b.*?</\1>', '', html, flags=re.S)
    return re.sub(r'<[^>]+>', ' ', h)

def pruefe(ordner):
    p = pathlib.Path(ordner, 'index.html')
    if not p.exists():
        return [f'{ordner}: nicht gebaut']
    roh = p.read_text(encoding='utf-8')
    txt = sichtbar(roh)
    klein = txt.lower()
    mangel = []

    for muster, warum in VERBOTEN:
        # <form> und Klassennamen stehen im Markup, nicht im sichtbaren Text
        heu = roh.lower() if muster.startswith('<') else klein
        if re.search(muster, heu):
            mangel.append(f'{warum} ({muster})')

    # Anker, die ins Leere zeigen. Anker, die das JS erst zusammensetzt
    # ("#' + id + '"), sind hier nicht beurteilbar — die prueft der Browser.
    ids = set(re.findall(r'\bid="([^"]+)"', roh))
    for ziel in set(re.findall(r'href="#([^"]+)"', roh)):
        if ziel and ziel not in ids and not re.search(r"[+'`${]", ziel):
            mangel.append(f'Anker #{ziel} hat kein Ziel')

    # Ob die eine Preiszahl ohne Klick sichtbar ist, entscheidet sich erst im
    # Browser: schirm zaehlt sie als Walze hoch, satz setzt sie per JS. Statisch
    # laesst sich nur sagen, dass sie ueberhaupt vorkommt.
    if not re.search(r'\b1[0-9]{2}\b', roh):
        mangel.append('nirgends eine Monatspreiszahl')

    w = len(txt.split())
    vor = VORHER.get(ordner)
    kopf = f'{ordner}: {vor} → {w} Wörter' if vor else f'{ordner}: {w} Wörter'
    if vor and w > vor * 0.6:
        mangel.append(f'kaum gekürzt ({round(100*w/vor)} % des Ausgangs)')
    return [kopf] + [f'   ✗ {m}' for m in mangel] if mangel else [kopf + '   ✓']

if __name__ == '__main__':
    for o in sys.argv[1:]:
        print('\n'.join(pruefe(o)))
