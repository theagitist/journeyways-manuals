# JOURNEYWAYS Game Rules (Typst)

Typst sources for the JOURNEYWAYS boardgame rules, in two forms from one content
source:

- **`manual.pdf`** - 1-up reading proof, one half-letter page per page.
- **`booklet.pdf`** - the same content imposed **2-up** on landscape letter
  sheets, ready to print, fold, and staple into a half-letter booklet.

These are a 1:1 recreation of the original `JOURNEYWAYS_Game_Rules.pdf` and its
imposed `..._BOOKLET.pdf`, rebuilt in Typst so the rules are editable and the
typography matches the web/play brand (Italianno display + Inter body).

The two source PDFs paginate the same text slightly differently, so
`content.typ` keeps the text as atomic section chunks and composes them into two
leaf sets: `manual-leaves` (Solo + Advanced share folio 5, plus a Notes page) and
`booklet-leaves` (Solo, Advanced, and Tips each get their own folio, no Notes).
The table-of-contents page numbers follow suit.

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

1. Print **double-sided**, flipped on the **short edge** (the default, matching
   the original booklet; the back sheets are pre-rotated 180 degrees for this).
2. Stack the sheets in order, fold the whole stack in half down the middle.
3. Staple the spine.

Long-edge duplex printer? Set `flip-backs` to `false` at the top of
`src/booklet.typ` and rebuild.

## Editing the rules

Edit `src/content.typ`. Each page is a `leaf-*` block; both PDFs pick them up
from the `leaves` array, so a content change flows to the manual and the booklet
at once. Change the palette or type in the helpers near the top of that file.

## Fidelity notes

This is a **corrected edition**: two typos in the original were fixed here, "face
dawn" -> "face down" (Game Setup step 1) and "draws a tile fom" -> "draws a tile
from" (step 7). Everything else reproduces the source.

The cover uses the low-resolution (72 dpi) image embedded in the source PDF; a
crisper print cover could be swapped in from `original_assets/boardgame/cover/`.

## License

Content and layout: **CC BY-NC 4.0** (c) 2025 Adri M. (see `LICENSE`), matching
`play.journeyways.ca`. Bundled fonts (Italianno, Inter) are under the SIL Open
Font License; see `fonts/*-OFL.txt`.
