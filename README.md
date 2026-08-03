# Trojan Performance — drei Entwürfe

Drei Startseiten-Entwürfe für [trojanperformance.at](https://www.trojanperformance.at/),
statisch gehostet auf GitHub Pages.

| | Entwurf | Charakter |
|---|---|---|
| A | [`matrix/`](matrix/) | dunkel, sachlich — Kursangebot als Streudiagramm statt Kartenliste |
| B | [`phalanx/`](phalanx/) | hell, plakativ — der Wochenplan steht im Zentrum |
| C | [`arena/`](arena/) | dunkel, filmisch — Vollbild-Bühne, dann Zahlen, Preise, Coaches, Kurse |

## Bauen

```bash
./build.sh
```

Ersetzt in `src/*.src.html` die Bildplatzhalter (`__LOGO__`, `__MONOA__`, `__PH_XXX__`)
durch Pfade nach `assets/` und schreibt das Ergebnis nach `matrix/`, `phalanx/`, `arena/`.
Fehlt ein Bild oder bleibt ein Platzhalter stehen, bricht der Build ab.

Bearbeitet wird immer `src/`, nie die generierten `index.html`.

Lokal ansehen:

```bash
python3 -m http.server 8099
```

## Aufbau

```
src/          Quellen mit Platzhaltern — hier wird editiert
assets/       Fotos und Logo von trojanperformance.at, Vorschaubilder
build.sh      Platzhalter -> Pfade
index.html    Übersicht mit Links auf die drei Entwürfe
```

Jeder Entwurf ist eine einzelne HTML-Datei mit eingebettetem CSS und JS. Keine Build-Kette,
kein Framework. Extern geladen werden nur die Schriften (Archivo, Archivo Black,
IBM Plex Mono) von Google Fonts.

## Offene Punkte

- Der Wochenplan in Entwurf B enthält **Beispielzeiten**, keine echten Kurszeiten.
- Auf der Live-Seite stehen die Open-Gym-Zeiten an zwei Stellen unterschiedlich
  (22:00 bzw. 21:00, Samstag 06:00–21:00 bzw. 08:00–11:00). Ungeklärt.
- Das FAQ der Live-Seite spricht von „7 Trainingskursen“, aufgelistet sind acht.
- Vor einem echten Livegang: Schriften selbst hosten statt von Google Fonts,
  und jede Zahl gegen die Angaben des Kunden prüfen.

## Rechte

Fotos, Logo, Preise und Inhalte gehören Trojan Performance. Dieses Repository ist ein
Entwurfsstand zur Abstimmung, keine Veröffentlichung — die Seiten tragen `noindex`.
