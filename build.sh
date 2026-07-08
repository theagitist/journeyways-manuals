#!/usr/bin/env bash
# Build the JOURNEYWAYS Game Rules PDFs from the Typst source.
# Outputs manual.pdf (1-up reading proof) and booklet.pdf (2-up imposed for print).
set -euo pipefail
cd "$(dirname "$0")"

typst compile --font-path fonts --root . src/manual.typ  manual.pdf
typst compile --font-path fonts --root . src/booklet.typ booklet.pdf

echo "Built:"
ls -la manual.pdf booklet.pdf
