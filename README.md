# JOURNEYWAYS print material (Typst)

Typst sources for the JOURNEYWAYS boardgame print components: the game rules and
the per-player write-in booklet, rebuilt in Typst so they are editable and the
typography matches the web/play brand (Italianno display + Inter body).

**Game rules:**
- **`manual.pdf`** - a single large **square 8.5x8.5** reading manual, one topic
  per page with generous spacing. Print on letter and trim the bottom to a
  square (the boardgame box holds a square trim). There is no 2-up edition.

**Player Booklet** (the per-player write-in booklet: cover, an intro + quick
reference, two Character Sheets - a "before" near the front and an "after"
second-to-last - 11 lined journal pages numbered 1 to 14, and a back cover):
- **`player-booklet.pdf`** - 1-up, letter-proportioned pages.
- **`player-booklet-2up.pdf`** - imposed **2-up** (16 pages = 4 saddle-stitch
  sheets). The cover is a faithful full-page render of the source; the other
  pages (intro / quick reference, both character sheets, journal pages, back
  cover) are rebuilt with the brand fonts.

## Layout

```
src/content.typ       game-rules content + styles (source of truth)
src/manual.typ        game-rules driver: builds the square 8.5x8.5 manual
src/pb-content.typ    Player Booklet content (leaves + rebuilt text pages)
src/pb-manual.typ     Player Booklet driver: 1-up
src/pb-booklet.typ    Player Booklet driver: 2-up saddle-stitch imposition
fonts/                Italianno + Inter (SIL OFL, vendored so builds are reproducible)
assets/               game-rules art: square cover.jpg, swirl watermark, QR, and the
                      design art (tiles/ gallery, chips/ card colours, doodles/, meeples.jpg)
assets/player-booklet/ pages/ = cover render; art/ = wash, swirl, intro illustrations, QR
deploy-web.sh         copy stable PDFs into www/download (run on each stable version)
build.sh              builds all three PDFs
```

## Build

Needs [Typst](https://typst.app) (built with 0.14.2; 0.15+ is fine):

```sh
./build.sh
```

or individually:

```sh
typst compile --font-path fonts --root . src/manual.typ manual.pdf
```

## Deploying to the website (ongoing)

The public site (`www.journeyways.ca`) offers the Rulebook and Player Booklet as
downloads. **Whenever there is a new stable version of the documents, run:**

```sh
./deploy-web.sh
```

It rebuilds, copies the readable 1-up PDFs into the site's `download/` folder
(`manual.pdf` -> the Rulebook, `player-booklet.pdf` -> the Player Booklet, same
filenames so links keep working), and refreshes the file-size labels in
`boardgame.html`. Afterwards, commit the `www` repo, and if `journeyways.ca` is
proxied through Cloudflare, purge the cache for `/download/*.pdf` so visitors get
the new files.

## Printing the Player Booklet

`player-booklet-2up.pdf` is 4 landscape sheets in saddle-stitch order.

1. Print **double-sided**, flipped on the **short edge** (the default; the back
   sheets are pre-rotated 180 degrees for this).
2. Stack the sheets in order, fold the whole stack in half down the middle.
3. Staple the spine.

Long-edge duplex printer? Set `flip-backs` to `false` at the top of
`src/pb-booklet.typ` and rebuild.

## Editing the rules

Edit `src/content.typ`. Each page is a `leaf-*` block collected in the
`manual-leaves` array; folios and the Table of Contents are set there. Change the
palette or type in the helpers near the top of the file.

## Fidelity notes

This is a **corrected edition**: two typos in the original were fixed here, "face
dawn" -> "face down" (Game Setup step 1) and "draws a tile fom" -> "draws a tile
from" (step 7). The cover is the high-resolution square cover from
`original_assets/boardgame/cover/`, and the title page carries a small gallery of
the real map-tile art.

## License

Content and layout: **CC BY-NC 4.0** (c) 2025 Adri M. (see `LICENSE`), matching
`play.journeyways.ca`. Bundled fonts (Italianno, Inter) are under the SIL Open
Font License; see `fonts/*-OFL.txt`.
