# Handoff — Trojan Performance Landingpage

Stand: 10. August 2026. Übergabe an eine neue Sitzung.

## Worum es geht

Startseiten-Entwürfe für **Trojan Performance**, ein Gym in Klagenfurt am Wörthersee.
Statische HTML-Einzeldateien, kein Framework, kein Build-Werkzeug ausser `build.sh`.
Auftraggeber ist der Gym-Inhaber; die Entwürfe dienen der Abstimmung mit ihm, nicht dem
Livegang.

- **Repo:** `/srv/git/trojan-landing`, Branch `main`
- **Live:** https://flashtea.github.io/trojan-landing/ (GitHub Pages, alle Seiten `noindex`)
- **Zustand:** ausgeliefert und geprüft, Arbeitsbaum sauber, nichts offen

## Wo das Projekt gerade steht

Neunzehn Entwürfe, aber nur noch **vier stehen zur Abstimmung**: `arena`, `matrix`,
`phalanx` und `rotstift`. Der Rest gilt auf Gestalterseite als nicht nutzbar und liegt in
der Übersicht darunter als Kontaktbogen — sichtbar, aber nicht zur Wahl. Gelöscht ist
nichts.

Der Inhaber hat **Arena** als Favorit benannt, **Matrix** als zweite Wahl; **Rotstift**
ist der Favorit auf Gestalterseite und der einzige der vier, der den Schnitt schon
trägt. Die letzte inhaltliche Frage des Inhabers war: *wie viel Information kann wirklich
auf der Seite sein?*

Die Antwort darauf ist der **Schnitt** — der Stand, der jetzt live ist. Achtzehn
Entwürfe lang war reduziert worden, was man sieht (Farbe, Bild, Rahmen), und nie, was
dasteht. Der Beleg: `stele`, ausdrücklich als „Arena radikal reduziert" gebaut, trug
mehr Text als Arena selbst — 928 gegen 788 sichtbare Wörter.

Seither entscheidet ein Maßstab: Eine Angabe bleibt, wenn sie **vor** der Entscheidung
für ein Probetraining gebraucht wird. Drei Fragen darf der Besucher nicht suchen müssen:
*passt das in meine Woche*, *was kostet es*, *ist das etwas für mich*. Alles Übrige ist
gestrichen oder liegt hinter einer Bedienhandlung. Der ganze Auftrag steht in
`werkzeug/schnitt.md`.

Sechzehn Entwürfe sind danach gekürzt. **Matrix, Phalanx und Arena bleiben auf
ausdrücklichen Kundenwunsch unverändert**, damit der Unterschied sichtbar bleibt.

`kern` ist das neue Arena und die Vorlage, an der der Schnitt zuerst durchgespielt
wurde: 790 → 342 Wörter, 20 → 9 Bilder, Seitenhöhe am Desktop von 10044 auf 4860 px,
bei unveränderter Gestaltung.

Die Zahlen aller sechzehn stehen im `README.md`.

### Was zuletzt an `rotstift` geändert wurde

Am 10. August 2026, auf Zuruf des Auftraggebers:

- **Akzentfarbe** vom Korrekturstift-Rot auf das **offizielle Blau** der Livesite
  (`#3971b7`). Nicht geschätzt, sondern aus dem Elementor-Kit von trojanperformance.at
  geholt (`--e-global-color-accent`, dort auf h1–h3 und Schaltflächen). Die CSS-Variable
  heisst deshalb `--akzent` statt `--rot`. **Offener Punkt:** auf dem Papierton kommt das
  Blau auf 4,36:1 und liegt damit knapp unter den 4,5:1 für kleinen Text — das Rot lag
  bei 4,87:1. Steht im `README.md` unter „Offene Punkte".
- **Kopflogo** von 13 auf 26 px (17 px unter 720 px Breite). Es war das kleinste aller
  Entwürfe; die Unterzeile war nicht lesbar.
- **Coach-Porträts** auf eine gemeinsame Augenlinie gebracht. Die vier Quellbilder sind
  unterschiedlich breit (536, 443, 537, 480 auf je 720); im 3:4-Ausschnitt lagen die
  Augen bis zu sieben Prozent der Kachelhöhe auseinander. Zwei `object-position`-Werte
  richten sie aus, Mike und Diego brauchen keine.
- **Mike und Dominik** tragen je die Zeile „Gründer"; dass sie Brüder sind, steht in der
  Kopfzeile des Abschnitts. „Gründer" statt „Inhaber", weil `inhalt.md` nur die Gründung
  belegt — der Kunde kann das mit einem Wort bestätigen.

## Was als Nächstes ansteht

1. **Rückmeldung des Inhabers zum Schnitt.** Das ist der eigentliche nächste Schritt.
   Er soll sehen, ob ihm dieselbe Gestaltung mit einem Drittel des Inhalts lieber ist.
   Der Vergleich steht jetzt in der engeren Auswahl selbst: `arena` (ungeschnitten) gegen
   `rotstift` (geschnitten). Wer die Frage bei gleicher Handschrift stellen will, nimmt
   `arena` gegen `kern` — Kern liegt bei den Studien.
2. **Offene Inhaltsfragen an ihn** — sie stehen vollständig im `README.md` unter
   „Offene Punkte". Die wichtigste steht unten.
3. Falls weitere Entwürfe entstehen: sie werden nach `werkzeug/schnitt.md` gebaut, nicht
   nach dem alten Maßstab.

## Der wichtigste offene Punkt

**„Acht Kurse" stimmt nicht.** Die Buchungsschnittstelle liefert in vier geprüften
Wochen (10.8., 17.8., 24.8., 31.8.2026) durchgehend einen neunten regelmäßigen Kurs:
*Fenja Power Yoga*, sonntags. Dazu Einzeltermine (*deadly dozen im Europapark*, *Kriso
Farewell TeamWOD*) und ein *Firmentraining*-Slot.

Die Seiten behaupteten „acht Kurse" und widerlegten sich im eigenen Wochenplan darunter.
Aus allen geschnittenen Entwürfen ist die Zahl **entfernt statt korrigiert** — „neun"
wäre geraten. Matrix, Phalanx und Arena tragen sie weiter, weil sie unverändert bleiben
sollen; **der Inhaber hat dazu noch nichts gesagt**, es ist ihm angeboten worden.

Zu klären: Ist Power Yoga ein eigener Kurs, eine Fremdanmietung, oder gehört er nicht in
die Gruppe „Kurse"?

Dasselbe Muster gab es vorher schon bei „sechs Tage" — inzwischen überall auf **sieben**
korrigiert. Wenn eine Zahl fest im Text steht, während der Wochenplan sie live widerlegt,
ist die Zahl das Problem.

## Wie man hier arbeitet

```bash
cd /srv/git/trojan-landing
./build.sh                                    # src/*.src.html -> <variante>/index.html
python3 -m http.server 8099 --bind 127.0.0.1 &
```

**Bearbeitet wird immer `src/`, nie die generierten `index.html`.** `build.sh` überschreibt
sie. Eine neue Variante muss in das `SEITEN`-Wörterbuch in `build.sh` eingetragen werden.

Prüfwerkzeug samt Anleitung liegt in `werkzeug/` — Screenshots, Bedienung, ein Skript,
das den Schnitt nachprüft, und eins für die Vorschaubilder der Übersicht. Siehe
`werkzeug/README.md`.

Nach jeder inhaltlichen Änderung an einem Entwurf:

```bash
./werkzeug/vorschau.sh <name>      # sonst zeigt die Übersicht eine Seite, die es nicht gibt
```

## Was in diesem Projekt schon schiefgegangen ist

Damit es nicht zweimal passiert:

- **Gleicher Auftrag → gleiches Ergebnis.** Drei Agenten mit identischem Briefing
  lieferten fast identische Entwürfe (alle drei: cremefarbenes Papier, Monospace-Zahlen,
  „Abb. 01"-Bildunterschriften). Seither bekommt jeder Entwurf eine **eigene
  Zwangsbedingung** und ein ausdrückliches Verbot der ausgereizten Reflexe. Das erzeugt
  die Streuung, die derselbe Auftrag nicht erzeugt.
- **Ordnernamen selbst wählen lassen.** Drei parallele Agenten wählten denselben
  Zielordner und überschrieben sich. Datei- **und** Ordnername gehören in den Auftrag.
- **chrome-devtools-MCP bei parallelen Agenten.** Die Seitenauswahl ist global; die
  Agenten überschreiben sich gegenseitig. `werkzeug/schuss.mjs` und `klick.mjs` sprechen
  das DevTools-Protokoll direkt und sind dafür da.
- **Das tmpfs läuft voll.** Fünfzehn Agenten mit Screenshots füllen `/tmp` (7,8 G).
  Verwaiste Chrome-Profile liegen als `/tmp/<name>-XXXXXX`; die, die seit zehn Minuten
  niemand mehr beschrieben hat, kann man löschen.
- **Berichte von Agenten sind kein Beleg.** Mehrere sind ohne Bericht still geworden oder
  am Ausgabelimit gestorben, nachdem ihre Arbeit fertig war. Alles Prüfbare selbst
  nachmessen — dafür ist `werkzeug/pruef.py` da.
- **Das Prüfskript meldet auch Falsches.** `schirm` zählt seinen Preis als Ziffernwalze
  hoch, `satz` setzt ihn per JS, `spalte` baut Anker im JS zusammen. Solche Treffer erst
  im Browser gegenprüfen, bevor man etwas „repariert".

## Was der Auftraggeber will

- **Subagenten mit Opus**, nicht mit Fable — Fable verbraucht zu viel Usage.
- Die drei Originale bleiben unangetastet, bis er etwas anderes sagt.
- Kein erfundener Inhalt: keine Kundenstimmen, keine Mitgliederzahlen, keine
  Auszeichnungen. Was nicht in `werkzeug/inhalt.md` steht, kommt nicht auf die Seite.
- Der Satz „Und wenn drei nicht gehen: zwei gehen auch." ist auf seinen Wunsch aus allen
  Entwürfen entfernt und darf nicht zurückkommen, auch nicht umformuliert.
