#!/usr/bin/env bash
# Erzeugt die Vorschaubilder der Uebersichtsseite neu.
#
# Nach dem Schnitt zeigen die alten Karten Seiten, die es so nicht mehr gibt —
# Kursschienen, Preismatrizen, HYROX-Tafeln. Ein Vorschaubild, das etwas
# anderes zeigt als die Seite dahinter, ist schlimmer als keins.
#
#   vorschau.sh <ordner> [<ordner> ...]
set -euo pipefail
cd "$(dirname "$0")"
ZIEL=/srv/git/trojan-landing/assets

for o in "$@"; do
  rm -f "pv-$o-01.png"
  node schuss.mjs "http://127.0.0.1:8099/$o/" 1440 "pv-$o" >/dev/null 2>&1
  if [ ! -f "pv-$o-01.png" ]; then echo "FEHLT: Schuss für $o"; exit 1; fi
  magick "pv-$o-01.png" -resize 880x556^ -gravity north -crop 880x556+0+0 +repage \
    -quality 82 "$ZIEL/prev-$o.jpg"
  magick "$ZIEL/prev-$o.jpg" -quality 72 -define webp:method=6 "$ZIEL/prev-$o.webp"
  printf '%-10s %5s kB jpg / %5s kB webp\n' "$o" \
    "$(( $(stat -c%s "$ZIEL/prev-$o.jpg") / 1024 ))" \
    "$(( $(stat -c%s "$ZIEL/prev-$o.webp") / 1024 ))"
  rm -f "pv-$o-01.png"
done
