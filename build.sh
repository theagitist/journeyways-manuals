#!/usr/bin/env bash
# Build the JOURNEYWAYS Game Rules PDFs from the Typst source.
# Outputs manual.pdf (1-up reading proof) and booklet.pdf (2-up imposed for print).
set -euo pipefail
cd "$(dirname "$0")"

# Game rules (single square 8.5x8.5 reading manual; no 2-up)
typst compile --font-path fonts --root . src/manual.typ  manual.pdf

# Player Booklet (1-up + 2-up imposed)
typst compile --font-path fonts --root . src/pb-manual.typ  player-booklet.pdf
typst compile --font-path fonts --root . src/pb-booklet.typ player-booklet-2up.pdf

echo "Built:"
ls -la manual.pdf player-booklet.pdf player-booklet-2up.pdf
