#!/usr/bin/env bash
# Build the JOURNEYWAYS print PDFs from the Typst source, in every language.
# One source, three languages (en / es / fr), selected with `--input lang=..`.
# Outputs, per language LANG:
#   manual_LANG.pdf             game rules (single square 8.5x8.5 reading edition)
#   player-booklet_LANG.pdf     Player Booklet, 1-up reading proof
#   player-booklet-2up_LANG.pdf Player Booklet, 2-up imposed for print
#   facilitator_en.pdf          Facilitator's Guide (same square trim, English only)
#   quickref_en.pdf             Quick Reference, one square page (English only)
set -euo pipefail
cd "$(dirname "$0")"

LANGS=(en es fr)

for L in "${LANGS[@]}"; do
  typst compile --font-path fonts --root . --input lang="$L" src/manual.typ     "manual_${L}.pdf"
  typst compile --font-path fonts --root . --input lang="$L" src/pb-manual.typ  "player-booklet_${L}.pdf"
  typst compile --font-path fonts --root . --input lang="$L" src/pb-booklet.typ "player-booklet-2up_${L}.pdf"
done

# Facilitator's Guide: English only for now (ADR-025).
typst compile --font-path fonts --root . src/facilitator.typ facilitator_en.pdf
typst compile --font-path fonts --root . src/quickref.typ    quickref_en.pdf

echo "Built:"
ls -la manual_*.pdf player-booklet_*.pdf player-booklet-2up_*.pdf facilitator_*.pdf quickref_*.pdf
