# JOURNEYWAYS Game Rules (Typst)

Typst sources for the JOURNEYWAYS boardgame rules, in two forms from one content
source:

- **`manual.pdf`** - 1-up reading proof, one half-letter page per page.
- **`booklet.pdf`** - the same content imposed **2-up** on landscape letter
  sheets, ready to print, fold, and staple into a half-letter booklet.

These are a 1:1 recreation of the original `JOURNEYWAYS_Game_Rules.pdf` and its
imposed `..._BOOKLET.pdf`, rebuilt in Typst so the rules are editable and the
typography matches the web/play brand (Italianno display + Inter body).

## Layout

```
src/content.typ   the rules content + styles (single source of truth)
src/manual.typ    driver: 1-up reading proof
src/booklet.typ   driver: 2-up saddle-stitch imposition
fonts/            Italianno + Inter (SIL OFL, vendored so builds are reproducible)
assets/           cover, decorative swirl, QR codes (extracted from the source PDF)
build.sh          builds both PDFs
```

## Build

Needs [Typst](https://typst.app) (built with 0.14.2; 0.15+ is fine):

```sh
./build.sh
```

or individually:

```sh
typst compile --font-path fonts --root . src/manual.typ  manual.pdf
typst compile --font-path fonts --root . src/booklet.typ booklet.pdf
```

## Printing the booklet

`booklet.pdf` is 6 landscape letter sheets in saddle-stitch order.

1. Print **double-sided**, flipped on the **long edge** (the default).
2. Stack the sheets in order, fold the whole stack in half down the middle.
3. Staple the spine.

Short-edge duplex printer? Set `flip-backs` to `true` at the top of
`src/booklet.typ` and rebuild; it rotates the back sheets 180 degrees.

## Editing the rules

Edit `src/content.typ`. Each page is a `leaf-*` block; both PDFs pick them up
from the `leaves` array, so a content change flows to the manual and the booklet
at once. Change the palette or type in the helpers near the top of that file.

## Fidelity notes

The content reproduces the source verbatim, including two typos in the original
that were left as-is for a true 1:1: "face **dawn**" (Game Setup step 1) and
"draws a tile **fom** any pile" (step 7). Fix them in `content.typ` if you want a
corrected edition.

## License

Content and layout: **CC BY-NC 4.0** (c) 2025 Adri M. (see `LICENSE`), matching
`play.journeyways.ca`. Bundled fonts (Italianno, Inter) are under the SIL Open
Font License; see `fonts/*-OFL.txt`.
