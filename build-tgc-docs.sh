#!/usr/bin/env bash
# Per-page PNGs of the printed documents for The Game Crafter's uploader.
#   Game rules + Facilitator's Guide -> Jumbo Booklet: 2475x3075 (8x10 trim + 1/8in bleed)
#   Quick Reference                  -> Document: 2550x3300 (8.5x11, no bleed)
# The pages are laid out at trim size, so the bleed is made by repeating the edge
# pixels outward (it is cut off; it only has to match the page edge). English only.
# Output: tgc-png/docs/{rules,guide,quickref}/NN.png
set -euo pipefail
cd "$(dirname "$0")"
out=tgc-png/docs
rm -rf "$out" && mkdir -p "$out"/{rules,guide,quickref}
typst compile --format png --ppi 300 --font-path fonts --root . src/manual.typ      "$out/rules/{0p}.png"
typst compile --format png --ppi 300 --font-path fonts --root . src/facilitator.typ "$out/guide/{0p}.png"
typst compile --format png --ppi 300 --font-path fonts --root . src/quickref.typ    "$out/quickref/{0p}.png"
python3 - "$out" <<'EOF'
import sys, glob
import numpy as np
from PIL import Image
out = sys.argv[1]
for f in sorted(glob.glob(f"{out}/rules/*.png") + glob.glob(f"{out}/guide/*.png")):
    a = np.asarray(Image.open(f).convert("RGB"))
    assert a.shape[:2] == (3000, 2400), (f, a.shape)
    # 37.5px of bleed per side: pad 38 and trim one pixel off the right/bottom.
    Image.fromarray(np.pad(a, ((38, 37), (38, 37), (0, 0)), mode="edge")).save(f)
for f in sorted(glob.glob(f"{out}/quickref/*.png")):
    assert Image.open(f).size == (2550, 3300), f
EOF
for d in rules guide quickref; do echo "$d: $(ls "$out/$d" | wc -l) pages"; done
