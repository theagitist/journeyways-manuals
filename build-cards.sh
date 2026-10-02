#!/usr/bin/env bash
# Build the JOURNEYWAYS card print files from the single-source manifest.
#
# Prerequisite: the manifest + art must be exported from the play repo first:
#   (in /var/www/play.journeyways.ca) node scripts/export-print-cards.js
# which writes assets/cards/cards.json and the -full.webp masters here. This
# script refuses to run without it.
#
# The physical boardgame is English-only for now (operator decision 2026-10-01;
# es/fr printed sets deferred), so this builds ENGLISH by default. The digital
# surfaces stay trilingual; the card text es/fr still exists in play's locales,
# so --all-langs builds them when the physical game goes multilingual.
#
# Flags (any order):
#   --export     run the play-repo export first (needs the play repo + DB on this host)
#   --png        also emit per-card PNGs at 825x1125 (300 DPI), named by card number,
#                for The Game Crafter's uploader (it takes one image per card, not a PDF)
#   --all-langs  build es/fr too (default is English only)
#
# Outputs (LANG = en by default, or en/es/fr with --all-langs):
#   cards_LANG.pdf         one card face per unique design, trim + 1/8in bleed
#   card-backs.pdf         one deck back per page, same bleed
#   cards-sheet_LANG.pdf   8-up landscape Letter, faces + uniform back sheets (DIY)
#   tgc-png/LANG/<num>.png per-card faces at 825x1125 (with --png)
#   tgc-png/backs/<deck>.png per-deck backs at 825x1125 (with --png)
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
  ( cd "$PLAY" && node scripts/export-print-cards.js )
fi

if [[ ! -f assets/cards/cards.json ]]; then
  echo "error: assets/cards/cards.json missing. Run the export first:" >&2
  echo "  ( cd \"$PLAY\" && node scripts/export-print-cards.js )   # or: $0 --export" >&2
  exit 1
fi

if [[ "$ALL_LANGS" == 1 ]]; then LANGS=(en es fr); else LANGS=(en); fi

# Deck backs: language-independent, build once.
typst compile --font-path fonts --root . src/card-backs.typ card-backs.pdf

for L in "${LANGS[@]}"; do
  typst compile --font-path fonts --root . --input lang="$L" --input mode=single \
    src/cards.typ "cards_${L}.pdf"
  typst compile --font-path fonts --root . --input lang="$L" --input mode=sheet \
    src/cards.typ "cards-sheet_${L}.pdf"
done

echo "Built (${LANGS[*]}):"
ls -la cards_*.pdf cards-sheet_*.pdf card-backs.pdf

if [[ "$DO_PNG" == 1 ]]; then
  echo "Rendering per-card PNGs (825x1125, 300 DPI) for The Game Crafter..."
  rm -rf tgc-png && mkdir -p tgc-png/backs
  tmp="$(mktemp -d)"
  # Faces per language, then rename page-number -> card number via the manifest.
  for L in "${LANGS[@]}"; do
    mkdir -p "tgc-png/$L"
    typst compile --format png --ppi 300 --font-path fonts --root . \
      --input lang="$L" --input mode=single src/cards.typ "$tmp/${L}_{0p}.png"
    node -e '
      const fs=require("fs"),path=require("path");
      const [tmp,lang,dest]=process.argv.slice(1);
      const m=require(path.resolve("assets/cards/cards.json"));
      const files=fs.readdirSync(tmp).filter(f=>f.startsWith(lang+"_")).sort();
      if(files.length!==m.cards.length) throw new Error(`page/card mismatch: ${files.length} vs ${m.cards.length}`);
      m.cards.forEach((c,i)=>fs.renameSync(path.join(tmp,files[i]),path.join(dest,c.number+".png")));
    ' "$tmp" "$L" "tgc-png/$L"
  done
  # Backs: one PNG per card (same order as the faces), named by card number. Each
  # card has its own back, so TGC gets a matching front+back per card.
  typst compile --format png --ppi 300 --font-path fonts --root . src/card-backs.typ "$tmp/back_{0p}.png"
  node -e '
    const fs=require("fs"),path=require("path");
    const tmp=process.argv[1];
    const m=require(path.resolve("assets/cards/cards.json"));
    const files=fs.readdirSync(tmp).filter(f=>f.startsWith("back_")).sort();
    if(files.length!==m.cards.length) throw new Error(`back page/card mismatch: ${files.length} vs ${m.cards.length}`);
    m.cards.forEach((c,i)=>fs.renameSync(path.join(tmp,files[i]),path.join("tgc-png/backs",c.number+".png")));
  ' "$tmp"
  rm -rf "$tmp"
  echo "Per-card PNGs:"
  ls tgc-png/en | head && echo "  ... ($(ls tgc-png/en | wc -l) faces/lang, $(ls tgc-png/backs | wc -l) backs)"
fi
