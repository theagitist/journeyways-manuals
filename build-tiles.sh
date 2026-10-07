#!/usr/bin/env bash
# Build the JOURNEYWAYS map-tile print files from the single-source manifest.
#
# Prerequisite: the manifest + art must be exported from the play repo first:
#   (in /var/www/play.journeyways.ca) node scripts/export-print-tiles.js
# which writes assets/tiles/tiles.json and the -full.webp masters here. This
# script refuses to run without it.
#
# The physical boardgame is English-only for now (operator decision 2026-10-01;
# es/fr printed sets deferred), so this builds ENGLISH by default. The digital
# surfaces stay trilingual; the tile names es/fr still exist in play's locales,
# so --all-langs builds them when the physical game goes multilingual.
#
# Flags (any order):
#   --export     run the play-repo export first (needs the play repo + DB on this host)
#   --png        also emit per-tile PNGs at 750x750 (300 DPI), named by tile number,
#                for The Game Crafter's uploader (it takes one image per tile, not a PDF)
#   --all-langs  build es/fr too (default is English only)
#
# Outputs (LANG = en by default, or en/es/fr with --all-langs):
#   tiles_LANG.pdf         one tile per unique design, trim + 1/8in bleed
#   tiles-sheet_LANG.pdf   3x3 portrait Letter, for DIY cutting
#   tgc-png-tiles/LANG/<num>.png  per-tile faces at 750x750 (with --png)
set -euo pipefail
cd "$(dirname "$0")"

PLAY="${PLAY_DIR:-$HOME/apps/journeyways/play}"
DO_EXPORT=0
DO_PNG=0
ALL_LANGS=0
for a in "$@"; do
  case "$a" in
    --export)    DO_EXPORT=1 ;;
    --png)       DO_PNG=1 ;;
    --all-langs) ALL_LANGS=1 ;;
    *) echo "unknown flag: $a" >&2; exit 2 ;;
  esac
done

if [[ "$DO_EXPORT" == 1 ]]; then
  echo "Exporting manifest + art from the play repo..."
  ( cd "$PLAY" && node scripts/export-print-tiles.js )
fi

if [[ ! -f assets/tiles/tiles.json ]]; then
  echo "error: assets/tiles/tiles.json missing. Run the export first:" >&2
  echo "  ( cd \"$PLAY\" && node scripts/export-print-tiles.js )   # or: $0 --export" >&2
  exit 1
fi

if [[ "$ALL_LANGS" == 1 ]]; then LANGS=(en es fr); else LANGS=(en); fi

for L in "${LANGS[@]}"; do
  typst compile --font-path fonts --root . --input lang="$L" --input mode=single \
    src/tiles.typ "tiles_${L}.pdf"
  typst compile --font-path fonts --root . --input lang="$L" --input mode=sheet \
    src/tiles.typ "tiles-sheet_${L}.pdf"
done

echo "Built (${LANGS[*]}):"
ls -la tiles_*.pdf tiles-sheet_*.pdf

if [[ "$DO_PNG" == 1 ]]; then
  echo "Rendering per-tile PNGs (750x750, 300 DPI) for The Game Crafter..."
  rm -rf tgc-png-tiles && mkdir -p tgc-png-tiles
  tmp="$(mktemp -d)"
  for L in "${LANGS[@]}"; do
    mkdir -p "tgc-png-tiles/$L"
    typst compile --format png --ppi 300 --font-path fonts --root . \
      --input lang="$L" --input mode=single src/tiles.typ "$tmp/${L}_{0p}.png"
    node -e '
      const fs=require("fs"),path=require("path");
      const [tmp,lang,dest]=process.argv.slice(1);
      const m=require(path.resolve("assets/tiles/tiles.json"));
      const files=fs.readdirSync(tmp).filter(f=>f.startsWith(lang+"_")).sort();
      if(files.length!==m.tiles.length) throw new Error(`page/tile mismatch: ${files.length} vs ${m.tiles.length}`);
      m.tiles.forEach((tl,i)=>fs.renameSync(path.join(tmp,files[i]),path.join(dest,tl.tile_number+".png")));
    ' "$tmp" "$L" "tgc-png-tiles/$L"
  done
  rm -rf "$tmp"
  echo "Per-tile PNGs:"
  ls tgc-png-tiles/en | head && echo "  ... ($(ls tgc-png-tiles/en | wc -l) tiles/lang)"
fi
