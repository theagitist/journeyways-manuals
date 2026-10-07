// JOURNEYWAYS map tiles - print renderer.
//
// One square tile per card, driven entirely by the single-source manifest the
// play repo exports (assets/tiles/tiles.json: tile number, slug, localized name,
// art, physical count). Art and names come from the same source as the digital
// tiles and the website, so print and screen cannot drift.
//
// Typography and palette mirror the digital tile / card (game-components.css):
// warm paper #fdfbf6, Inter caption.
//
// Compile (see build-tiles.sh):
//   typst compile --font-path fonts --root . --input lang=es src/tiles.typ tiles_es.pdf
// Inputs:
//   lang = en | es | fr        (default en; via i18n.typ)
//   mode = single | sheet      (default single)
//     single -> one tile per page at trim + 1/8in bleed, for full-custom print-
//               on-demand (The Game Crafter square, MakePlayingCards, ...).
//     sheet  -> 3x3 on US Letter for DIY cutting at any local shop.

#import "i18n.typ": lang, t

#let data = json("../assets/tiles/tiles.json")
#let mode = sys.inputs.at("mode", default: "single")

// --- Print geometry (square tile: 2.5in trim, 1/8in POD-standard bleed) ---------
#let trim   = 2.5in
#let bleed  = 0.125in
#let page-s = trim + 2 * bleed

#let paper = rgb("#fdfbf6")
#let ink   = rgb("#1f2937")

#let art-dir = "../assets/tiles/"

// Localized string from a {en, es, fr} dict (English fallback).
#let pick(d) = if type(d) == dictionary { d.at(lang, default: d.at("en", default: "")) } else { d }

// Expand the design list into physical tiles (a design with count N appears N times).
#let physical = data.tiles.map(tl => range(tl.copies).map(_ => tl)).flatten()

// --- One tile's artwork, as a self-contained square box --------------------------
// Draws the square art edge-to-edge (fit: cover) with the tile name as a small
// caption banner across the bottom. `s` is the tile's trim size; `bl` is how far
// the art bleeds past each trim edge (bleed for single mode, 0 for cut-from-sheet).
// The blank tile (art == none) renders as plain warm paper labeled "Make your own".
#let tile-box(tile, s: trim, bl: bleed) = {
  let name   = pick(tile.name)
  let hasart = tile.art != none
  let blank-label = t(en: "Make your own", es: "Crea el tuyo", fr: "Crée le tien")

  box(width: s + 2 * bl, height: s + 2 * bl, fill: paper, clip: true, {
    // Art fills the whole square (including bleed) when present.
    if hasart {
      place(top + left,
        box(width: 100%, height: 100%, clip: true,
          image(art-dir + tile.art, width: 100%, height: 100%, fit: "cover")))
    } else {
      // Blank tile: plain paper with a centred prompt.
      place(center + horizon,
        text(font: "Inter", size: 11pt, fill: ink.lighten(20%), style: "italic", blank-label))
    }
    // Name caption: a translucent paper banner across the bottom, inside the
    // trim safe zone, so the illustration stays visible behind it.
    let caption = if hasart { name } else { name }
    place(bottom + center, dy: -bl,
      box(width: 100% - 2 * bl, inset: (x: 0.12in, y: 0.07in), {
        align(center,
          box(fill: paper.transparentize(8%), inset: (x: 0.14in, y: 0.07in), radius: 0.06in,
            text(font: "Inter", size: 8.5pt, weight: "medium", fill: ink,
              tracking: 0.02em, caption)))
      }))
    // Tile number, top-left, inside the safe zone.
    place(top + left, dx: bl + 0.12in, dy: bl + 0.1in,
      text(font: "Inter", size: 6pt, fill: if hasart { white } else { ink.lighten(30%) },
        tile.tile_number))
  })
}

// --- single: one tile per UNIQUE design, trim + bleed ---------------------------
// POD tools take one art per tile plus a quantity field (the manifest carries
// `copies`), so single mode emits each design once.
#let render-single() = {
  set page(width: page-s, height: page-s, margin: 0pt, fill: paper)
  for (i, tile) in data.tiles.enumerate() {
    tile-box(tile)
    if i + 1 < data.tiles.len() { pagebreak() }
  }
}

// --- sheet: 3x3 on US Letter, for DIY cutting -----------------------------------
// Portrait US Letter (8.5 x 11) fits 3 columns of 2.5in tiles (7.5in) inside a
// 0.5in margin, and 3 rows (7.5in) with room to spare; 3x3 = 9 per sheet.
#let cols = 3
#let rows = 3
#let per-sheet = cols * rows

#let tile-grid(cells) = grid(
  columns: (trim,) * cols,
  rows: (trim,) * rows,
  align: center + horizon,
  stroke: 0.25pt + gray,            // cut on the line
  ..cells,
)

#let render-sheet() = {
  set page("us-letter", margin: 0.5in, fill: white)
  set align(center + horizon)
  let n-sheets = calc.ceil(physical.len() / per-sheet)
  for s in range(n-sheets) {
    if s > 0 { pagebreak() }
    let chunk = physical.slice(s * per-sheet, calc.min((s + 1) * per-sheet, physical.len()))
    tile-grid(chunk.map(tl => tile-box(tl, bl: 0pt)))
  }
}

#if mode == "sheet" { render-sheet() } else { render-single() }
