# JOURNEYWAYS print material (Typst)

Typst sources for the JOURNEYWAYS boardgame print components: the game rules and
the per-player write-in booklet, rebuilt in Typst so they are editable and the
typography matches the web/play brand (Italianno display + Inter body).

**Localized: en / es / fr.** One source, three languages. The language is chosen
at compile time with `--input lang=..` (default `en`); every PDF is written with
a `_en` / `_es` / `_fr` suffix. See "Translating / editing text" below.

**Game rules:**
- **`manual_LANG.pdf`** - a single large **square 8.5x8.5** reading manual, one
  topic per page with generous spacing. Print on letter and trim the bottom to a
  square (the boardgame box holds a square trim). There is no 2-up edition.

**Player Booklet** (the per-player write-in booklet: cover, an intro + quick
reference, two Character Sheets - a "before" near the front and an "after"
second-to-last - 11 lined journal pages numbered 1 to 14, and a back cover):
- **`player-booklet_LANG.pdf`** - 1-up, letter-proportioned pages.
- **`player-booklet-2up_LANG.pdf`** - imposed **2-up** (16 pages = 4 saddle-stitch
  sheets). Every page, including the cover, is built in Typst with the brand
  fonts (the cover is a framed grayscale art panel with the localized tagline and
  booklet label as live text).

Both covers are rebuilt in Typst so their text localizes: the stylized JOURNEYWAYS
wordmark stays as brand art in every language, while the tagline (both documents)
and the "Player Booklet" label (booklet) are live localized text over a text-free
background (`assets/cover-bg.jpg`, extracted from the source cover PSD).

## Layout

```
src/i18n.typ          localization helper: lang (from --input) + the t() picker
src/content.typ       game-rules content + styles (source of truth)
src/manual.typ        game-rules driver: builds the square 8.5x8.5 manual
src/pb-content.typ    Player Booklet content (leaves + rebuilt text pages)
src/pb-manual.typ     Player Booklet driver: 1-up
src/pb-booklet.typ    Player Booklet driver: 2-up saddle-stitch imposition
fonts/                Italianno + Inter (SIL OFL, vendored so builds are reproducible)
assets/               game-rules art: cover-bg.jpg (text-free cover), swirl, QR, and the
                      design art (tiles/ gallery, chips/ card colours, doodles/, meeples.jpg)
assets/player-booklet/ pages/ = cover-bg.jpg (grayscale); art/ = wash, swirl, QR
deploy-web.sh         copy stable PDFs (all languages) into www/download
build.sh              builds all nine PDFs (3 documents x 3 languages)
```

## Build

Needs [Typst](https://typst.app) (built with 0.14.2; 0.15+ is fine):

```sh
./build.sh          # all nine PDFs: manual/player-booklet/player-booklet-2up x en/es/fr
```

or one language / one document:

```sh
typst compile --font-path fonts --root . --input lang=fr src/manual.typ manual_fr.pdf
```

Omitting `--input lang=..` builds English.

## Deploying to the website (ongoing)

The public site (`www.journeyways.ca`) offers the Rulebook and Player Booklet as
downloads. **Whenever there is a new stable version of the documents, run:**

```sh
./deploy-web.sh
```

It rebuilds every language and copies the readable 1-up PDFs into the site's
`download/` folder as language-suffixed files (`JOURNEYWAYS Game Rules 1.0
{EN,ES,FR}.pdf` and `JOURNEYWAYS Player Booklet 1.0 {EN,ES,FR}.pdf`); the English
copies are also written to the legacy un-suffixed names so old external links keep
working. The component pages (`components-manual.html`, `components-booklet.html`)
and `boardgame.html` offer the three languages as separate download links.
Afterwards, if the layout changed, re-render the component-page previews and bump
the on-site `?v=` (same-name assets stay Cloudflare-cached; the DNS-scoped
`cloudflare-token` cannot purge), then commit the `www` repo.

## Translating / editing text

All user-facing text lives inline in `src/content.typ` (rules) and
`src/pb-content.typ` (booklet), wrapped in `t(en: .., es: .., fr: ..)` from
`src/i18n.typ`. The layout is written once; only the strings differ per language.
To fix or add a translation, edit the relevant `t(...)` call. A missing language
falls back to English. Because each page is a fixed-size clipped leaf, text that
runs longer in es/fr is tuned to fit; re-render after edits to check.

Inclusive language: gendered agent nouns use **neutral periphrasis** in both es
and fr (`cada persona` / `chaque personne`, `quien juega` / `la personne qui
joue`). "Pick" keeps its agency framing (`Elegir` / `Choisir`), and `dibujar` /
`dessiner` stay reserved for illustrating on a sticky note.

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
