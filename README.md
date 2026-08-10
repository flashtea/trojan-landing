# Trojan Performance — achtzehn Entwürfe

Startseiten-Entwürfe für [trojanperformance.at](https://www.trojanperformance.at/),
statisch gehostet auf GitHub Pages.

## Erste Runde

| | Entwurf | Charakter |
|---|---|---|
| A | [`matrix/`](matrix/) | dunkel, sachlich — Kursangebot als Streudiagramm statt Kartenliste |
| B | [`phalanx/`](phalanx/) | hell, plakativ — der Wochenplan steht im Zentrum |
| C | [`arena/`](arena/) | dunkel, filmisch — Vollbild-Bühne, dann Zahlen, Preise, Coaches, Kurse |

Aus der Abstimmung mit dem Betreiber: **Arena ist der Favorit**, Matrix die zweite Wahl.
Daraus ergaben sich die beiden folgenden Runden.

## Zweite Runde — aus Arena entwickelt

| | Entwurf | Frage, die er beantwortet |
|---|---|---|
| D | [`stele/`](stele/) | Wie weit lässt sich reduzieren? Keine Bühne, keine Einblendungen, zwei Fotos |
| E | [`umbra/`](umbra/) | Muss das Schwarz so hart sein? Warmer Grund, Aufbau unverändert |

Umbra ist bewusst eine reine Farbstudie: der Textinhalt ist zeichengleich mit Arena,
damit der Vergleich nur eine Frage stellt.

## Dritte Runde — unabhängig entstanden

| | Entwurf | Charakter |
|---|---|---|
| F | [`logbuch/`](logbuch/) | Papier und Ultramarin, Inhaltsverzeichnis statt Menü |
| G | [`protokoll/`](protokoll/) | Trainingsprotokoll, Fotos als nummerierte Graustufen-Abbildungen |
| H | [`rotstift/`](rotstift/) | Papier, eine Farbe — das Rot des Korrekturstifts |

Diese drei haben nur die Inhalte bekommen, nicht die anderen Entwürfe. Alle drei sind
unabhängig voneinander auf hellen Grund gekommen.

## Vierte Runde — die Seite als Handlung

| | Entwurf | Charakter |
|---|---|---|
| I | [`satz/`](satz/) | ein Satz mit zwei änderbaren Wörtern steuert den Kursvorschlag |
| J | [`nacht/`](nacht/) | protokoll in weichem Dunkelbraun, Aufbau unverändert |

## Fünfte und sechste Runde — je eine Zwangsbedingung

Drei Entwürfe mit identischem Auftrag waren fast identisch geworden. Seither bekommt
jeder Entwurf ein eigenes Verbot — das erzeugt die Streuung, die der gleiche Auftrag
nicht erzeugt.

| | Entwurf | Verbot bzw. Zwang |
|---|---|---|
| K | [`schrift/`](schrift/) | kein einziges Foto |
| L | [`schirm/`](schirm/) | kein Scrollen — die Entscheidung fällt auf einem Bildschirm |
| M | [`spalte/`](spalte/) | geteilt: eine Hälfte steht und reagiert auf die andere |
| N | [`quer/`](quer/) | wird geblättert, nicht gescrollt |
| O | [`fluss/`](fluss/) | keine Abschnitte, keine Kästen, keine Listen |
| P | [`spektrum/`](spektrum/) | die echten Kursfarben des Buchungssystems als Farbsystem |
| Q | [`grau/`](grau/) | kein einziger Farbwert, `r = g = b` überall |
| R | [`wende/`](wende/) | zwei Fassungen in einer Seite, Einsteiger und Fortgeschrittene |

## Bauen

```bash
./build.sh
```

Ersetzt in `src/*.src.html` die Bildplatzhalter (`__LOGO__`, `__MONOA__`, `__PH_XXX__`)
durch Pfade nach `assets/`, erzeugt fehlende WebP-Zwillinge und schreibt das Ergebnis in
das Verzeichnis der jeweiligen Variante. Fehlt ein Bild oder bleibt ein Platzhalter
stehen, bricht der Build ab.

Bearbeitet wird immer `src/`, nie die generierten `index.html`.

Lokal ansehen:

```bash
python3 -m http.server 8099
```

## Aufbau

```
src/          Quellen mit Platzhaltern — hier wird editiert
assets/       Fotos und Logo von trojanperformance.at, Vorschaubilder
build.sh      Platzhalter -> Pfade, WebP-Zwillinge
index.html    Übersicht mit Links auf die achtzehn Entwürfe
```

Jeder Entwurf ist eine einzelne HTML-Datei mit eingebettetem CSS und JS. Keine
Build-Kette, kein Framework. Die Schriften (Archivo, Archivo Black, IBM Plex Mono)
liegen unter `assets/fonts/` und werden vom eigenen Host geladen.

## Offene Punkte

- Die Kraft-/Ausdauer-/Technik-Werte der acht Kurse sind **erfunden** — die drei Achsen
  sind die Gliederung des Gyms, die Zahlen darin nicht abgestimmt.
- Die Beschreibung von *Mama reloaded* ist **Platzhalter**.
- „Sechs Tage" ist überall auf **sieben** korrigiert: die Schnittstelle liefert über
  fünf geprüfte Wochen durchgehend einen Sonntagstermin (Mama reloaded, 09:30), und der
  Wochenplan derselben Seiten zeigt sieben Spalten. Sollte der Sonntagskurs wegfallen,
  ist die Zahl erneut zu prüfen — sie steht fest im Text, nicht abgeleitet.
- Der Zusatz „Und wenn drei nicht gehen: zwei gehen auch." ist auf Kundenwunsch aus
  allen Entwürfen entfernt.
- Auf der Live-Seite stehen die Open-Gym-Zeiten an zwei Stellen unterschiedlich
  (22:00 bzw. 21:00, Samstag 06:00–21:00 bzw. 08:00–11:00). Ungeklärt.
- Das FAQ der Live-Seite spricht von „7 Trainingskursen", aufgelistet sind acht.
- Offen bleiben Kundenstimmen und was als triftiger Grund für eine Vertragsübertragung
  gilt.
- Vor einem echten Livegang jede Zahl gegen die Angaben des Kunden prüfen.

## Rechte

Fotos, Logo, Preise und Inhalte gehören Trojan Performance. Dieses Repository ist ein
Entwurfsstand zur Abstimmung, keine Veröffentlichung — die Seiten tragen `noindex`.
