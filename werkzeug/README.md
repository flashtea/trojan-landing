# Werkzeug

Prüfwerkzeug für die Entwürfe. Kein Teil der ausgelieferten Seite — `build.sh` fasst
dieses Verzeichnis nicht an.

Voraussetzung: eine laufende lokale Auslieferung.

```bash
cd /srv/git/trojan-landing && ./build.sh
python3 -m http.server 8099 --bind 127.0.0.1 &
```

## schuss.mjs — Screenshots ohne Playwright

```bash
node werkzeug/schuss.mjs <url> <breite> <ziel-praefix> [--serie=N] [--voll] [--scroll=PX]
```

Spricht das DevTools-Protokoll direkt über den `WebSocket`, den Node ab Version 22
mitbringt. Kein Puppeteer, keine Installation. Gibt am Ende
`breite=… seitenhoehe=… ueberlauf=…` aus — **`ueberlauf` muss 0 sein.**

`--voll` setzt das Fenster auf die volle Seitenhöhe. Achtung: Layouts mit `100svh`
sehen darin verzerrt aus, weil `svh` dann die ganze Seite meint. Das ist ein Artefakt
des Werkzeugs, kein Fehler — für solche Abschnitte `--serie` nehmen.

**Nicht das chrome-devtools-MCP benutzen, wenn mehrere Agenten parallel arbeiten.**
Die dortige Seitenauswahl ist global; die Agenten überschreiben sich gegenseitig. Genau
daran sind in diesem Projekt schon Läufe gescheitert.

## klick.mjs — bedienen und messen

```bash
node werkzeug/klick.mjs <url> <breite> "klick:<css>" "js:<ausdruck>" "warte:<ms>" "schuss:<name>"
```

Führt die Schritte der Reihe nach aus und meldet Konsolenfehler und
`Runtime.exceptionThrown`. Für alles, was erst zur Laufzeit entsteht — der Wochenplan
aus dem Buchungssystem, hochzählende Preise, Umschalter.

## pruef.py — den Schnitt nachprüfen

```bash
python3 werkzeug/pruef.py kern umbra stele …
```

Prüft die gebauten Seiten gegen `schnitt.md`: verbotene Inhalte (Kurszahl, HYROX-
Rennstationen, Kontaktformulare, Coach-Biografien, die erfundene Technik-Achse), tote
Anker, ob überhaupt eine Monatspreiszahl vorkommt, und wie stark gekürzt wurde.

Was es **nicht** kann: entscheiden, ob die Preiszahl ohne Klick sichtbar ist. `schirm`
zählt sie als Ziffernwalze hoch, `satz` setzt sie per JS — beides sieht nur der Browser.
Solche Meldungen mit `klick.mjs` gegenprüfen, bevor man etwas ändert.

## vorschau.sh — Vorschaubilder der Übersicht

```bash
./werkzeug/vorschau.sh kern umbra …
```

Erzeugt `assets/prev-<name>.jpg` und den WebP-Zwilling in 880×556. Nach jeder
inhaltlichen Änderung nötig: eine Vorschau, die etwas anderes zeigt als die Seite
dahinter, ist schlimmer als keine.

## inhalt.md, schnitt.md

`inhalt.md` ist der Inhalt des Kunden, aus dem alle Entwürfe schöpfen. `schnitt.md` ist
der Auftrag, nach dem sechzehn Entwürfe gekürzt wurden — Maßstab, Streichliste, Grenzen,
Prüfkriterien. Wer einen weiteren Entwurf schneidet, arbeitet danach.
