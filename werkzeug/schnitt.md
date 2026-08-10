# Der Schnitt — gemeinsamer Auftrag

Der Gym-Inhaber fragt, wie viel Information wirklich auf die Seite gehört. Achtzehn
Entwürfe haben bisher die **Gestaltung** reduziert und den **Inhalt** nie. Deshalb
wirken sie karg und lesen sich dicht. Das drehen wir um.

**Du gestaltest nichts neu.** Farben, Schriften, Raster, Bewegung, Bildsprache deines
Entwurfs bleiben, wie sie sind. Du nimmst Inhalt weg. Wenn dein Entwurf hinterher
anders aussieht als vorher, hast du zu viel angefasst.

## Der Maßstab

Die Startseite soll nicht informieren, sondern eine Entscheidung auslösen: ein
Probetraining. Alles wird danach beurteilt, ob es **vor** dieser Entscheidung gebraucht
wird. Was erst danach zählt, gehört nicht auf die Seite.

Drei Fragen darf der Besucher nicht suchen müssen: *passt das in meine Woche*,
*was kostet es*, *ist das etwas für mich*. Mehr nicht.

## Was bleibt

- Die Kernaussage im Kopf der Seite, samt „Offizieller HYROX Training Club" als Etikett
- **Der Wochenplan aus dem Buchungssystem** — das stärkste Material des Kunden, weil es
  wahr ist und sich selbst aktualisiert. Der rückt nach vorn, nicht nach hinten.
- **Ein** Grund, warum man hier und nicht anderswo trainiert (in jedem Kurs steht ein
  Coach, kleine Gruppen, 75 Minuten)
- **Eine** Preiszahl: 150 € im Monat für drei Einheiten pro Woche, keine Einschreibgebühr
- Die Gesichter der Coaches, **ohne** Biografien
- Ein Weg zum Probetraining, und der Fuss

## Was geht

| Weg | Warum |
|---|---|
| **Der ganze HYROX-Abschnitt** | Ausdrückliche Kundenentscheidung. Die Erwähnung „HYROX Training Club" im Kopf und im Fuss reicht. Die acht Rennstationen, die Formaterklärung, das eigene Bild: alles raus. |
| Der Kurskatalog als eigener Abschnitt | Der Wochenplan **ist** die Kursliste, mit echten Zeiten statt „3× pro Woche" |
| Die Preismatrix | Neun Monatspreise plus Laufzeiten plus Einzelpreise — davon entscheidet keine Zahl über ein Probetraining |
| Coach-Biografien | Gesichter schaffen Vertrauen, Lebensläufe nicht |
| Die Kurszeiten-Tabelle | Der Wochenplan ist genauer und aktuell |
| Das Kontaktformular | Nach-Entscheidungs-Weg. Telefon und Mail stehen im Fuss. |
| Zahlen-/Faktenleisten | „2017 gegründet", „8 Kurse", „75 Minuten" — Schmuck in Faktenform |
| Die Kraft-/Ausdauer-/Technik-Werte | Sind erfunden und nicht vom Kunden abgestimmt |

## Streichen heisst nicht verschweigen

Zwei Mittel, beide erlaubt, das zweite ist meist das bessere:

1. **Weg** — die Angabe steht später auf einer Unterseite, die es noch nicht gibt.
2. **Dahinter** — die Angabe bleibt erreichbar, aber hinter einer Bedienhandlung:
   `<details>`, ein Dialog, ein Aufklapper. Ausgeklappt darf alles dastehen.

Für die Preise ist **dahinter** die richtige Wahl: die eine Zahl steht frei, der Rest
(2×/6× pro Woche, Laufzeiten, Drop-in, 10er-Block, Personal Training, Open Gym, SVS,
Pause, Übertragung) klappt auf. Preise ganz zu verstecken kostet Buchungen — die eine
Zahl muss ohne Klick sichtbar sein.

Für die Kursbeschreibungen ebenso: häng sie an den Wochenplan, damit man einen Kurs
antippen kann und liest, was er ist.

## Vorbild

`src/trojan-S-kern.src.html` ist derselbe Schnitt an Arena vorgeführt: von 788 auf rund
260 sichtbare Wörter, von 17 auf 7 Bilder, dieselbe Optik. Sieh es dir an, bevor du
anfängst. Nachbauen sollst du es nicht — dein Entwurf hat seine eigene Bauform.

## Grenzen

- Du bearbeitest **genau eine Datei**: deine Quelle unter `src/`. Sonst nichts.
- **Nicht anfassen:** `build.sh`, `index.html`, `README.md`, `assets/`, die Quellen der
  anderen Entwürfe, `src/trojan-A-matrix`, `-B-phalanx`, `-C-arena` (die drei Originale
  bleiben ausdrücklich unverändert).
- **Kein git.** Nicht committen, nicht stagen, nicht branchen.
- Erfinde nichts dazu. Keine Kundenstimmen, keine Zahlen, die nicht in `inhalt.md` stehen.
- Bleib bei „sieben Tage" — der Sonntagskurs ist geprüft.
- **„Acht Kurse" ist nachweislich falsch und muss raus.** Die Schnittstelle liefert in
  allen vier geprüften Wochen einen neunten regelmäßigen Kurs (*Fenja Power Yoga*,
  sonntags), dazu Einzeltermine wie *deadly dozen im Europapark* und *Firmentraining*.
  Der Wochenplan auf derselben Seite zeigt sie. Ersetze die Zahl, statt sie zu
  korrigieren — „neun" ist nicht abgestimmt. In `kern` heisst der Satz jetzt
  „Sieben Tage die Woche, in jeder Einheit ein Coach mit dir auf der Fläche."
  Das gilt auch für `<meta name="description">`, Überschriften und Faktenleisten.
- Der Satz „Und wenn drei nicht gehen: zwei gehen auch." ist gestrichen und darf nicht
  zurückkommen, auch nicht umformuliert.

## Bauen und prüfen

```bash
cd /srv/git/trojan-landing && ./build.sh          # baut alle Entwürfe
python3 -m http.server 8099 --bind 127.0.0.1      # läuft evtl. schon
```

Screenshots ohne Playwright/Puppeteer, im Kratzverzeichnis:

```bash
node schuss.mjs http://127.0.0.1:8099/<ordner>/ 390 <name> --voll
node klick.mjs  http://127.0.0.1:8099/<ordner>/ 390 "warte:2500" "js:<ausdruck>"
```

`schuss.mjs` gibt `ueberlauf=` aus; der muss bei 360, 390 und 1440 **0** sein.
Achtung: `--voll` setzt das Fenster auf die volle Seitenhöhe — Layouts mit `100svh`
sehen darin verzerrt aus. Das ist ein Artefakt des Werkzeugs, kein Fehler. Nimm für
solche Abschnitte `--serie` oder `--scroll` und miss im Zweifel mit `klick.mjs`.

**Benutze NICHT das chrome-devtools-MCP.** Mehrere Agenten teilen sich dort einen
Browser, die Seitenauswahl ist global, und ihr überschreibt euch gegenseitig.

## Fertig heisst

- `./build.sh` läuft durch
- `ueberlauf = 0` bei 360, 390 und 1440
- Das JS besteht `node --check`, keine Konsolenfehler beim Laden
- Nichts zeigt mehr auf einen Anker, den du gestrichen hast (Navigation, Fuss, Knöpfe)
- Bewegung bleibt unter `prefers-reduced-motion: reduce` abschaltbar
- Tippflächen mindestens 44×44 px, Fokusring sichtbar
- Du hast dir die Screenshots **angesehen**, nicht nur erzeugt

## Bericht

Kurz, in dieser Reihenfolge:

1. Sichtbare Wörter vorher → nachher (zähle mit dem Skript unten)
2. Was du gestrichen hast, was du hinter eine Bedienhandlung gelegt hast
3. Was du **behalten** hast, obwohl es auf der Streichliste steht — mit Begründung
4. Die schwächste Stelle deines Ergebnisses

```bash
python3 - <<'PY'
import re, pathlib
h = pathlib.Path('<ordner>/index.html').read_text(encoding='utf-8')
h = re.sub(r'<(script|style)\b.*?</\1>', '', h, flags=re.S)
print(len(re.sub(r'<[^>]+>', ' ', h).split()))
PY
```
