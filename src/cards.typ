// JOURNEYWAYS card faces - print renderer.
//
// One face per card, driven entirely by the single-source manifest the play repo
// exports (assets/cards/cards.json: card number, deck, colour, art, localized
// title/content, author, physical count). Text and art come from the same source
// as the digital card and the website, so print and screen cannot drift.
//
// Typography and palette mirror the digital card (game-components.css): warm paper
// #fdfbf6, Italianno title, Inter body, per-deck colour bar, black Countdown panel.
//
// Compile (see build-cards.sh):
//   typst compile --font-path fonts --root . --input lang=es src/cards.typ cards_es.pdf
// Inputs:
//   lang = en | es | fr        (default en; via i18n.typ)
//   mode = single | sheet      (default single)
//     single -> one card per page at trim + 1/8in bleed, for full-custom print-on-
//               demand (The Game Crafter, MakePlayingCards, ...). Upload faces +
//               the deck backs (cards-backs.typ).
//     sheet  -> 9-up (3x3) on US Letter, grouped by deck, with a matching run of
//               uniform deck-back sheets, for printing double-sided cardstock you
//               cut by hand at any local shop. Uniform per-deck backs mean the
//               duplex flip aligns regardless of the printer's flip-edge setting.

#import "i18n.typ": lang

#let data = json("../assets/cards/cards.json")
#let mode = sys.inputs.at("mode", default: "single")

// --- Print geometry (poker / trading-card: identical trim to a "collectible" card)
#let trim-w = 2.5in
#let trim-h = 3.5in
#let bleed  = 0.125in            // 1/8in, the POD standard
#let page-w = trim-w + 2 * bleed
#let page-h = trim-h + 2 * bleed

#let paper = rgb("#fdfbf6")
#let ink   = rgb("#1f2937")
#let dark  = rgb("#111827")      // Countdown full-card background

#let art-dir = "../assets/cards/"

// One body text size for every card. Shrink-to-fit only drops it (in 0.5pt steps,
// per card) for the few whose text would otherwise overflow, so the type stays a
// single consistent size across the deck instead of stepping by text length.
#let body-size = 10.5pt
#let body-min  = 8pt

// Localized string from a {en, es, fr} dict (English fallback).
#let pick(d) = if type(d) == dictionary { d.at(lang, default: d.at("en", default: "")) } else { d }

// Expand the design list into physical cards (a design with count N appears N times).
#let physical = data.cards.map(c => range(c.count).map(_ => c)).flatten()

// --- One card's artwork, as a self-contained box sized to a given card width ------
// Draws paper, the deck colour bar, title, art, body, author, number. `w`/`h` are
// the card's trim size; `bl` is how far the paper/bar bleed past each trim edge
// (bleed for single mode, 0 for cut-from-sheet mode).
#let face-box(card, w: trim-w, h: trim-h, bl: bleed) = {
  let color = rgb(card.color)
  let title = pick(card.title)
  let body  = pick(card.content)
  let hasart = card.art != none
  let black  = card.deck == "countdown"
  let author = card.at("author", default: none)

  // Countdown ("black") cards are a full black card; every other deck is warm
  // paper with a colour bar across the top.
  let fg = if black { white } else { ink }

  box(width: w + 2 * bl, height: h + 2 * bl, fill: if black { dark } else { paper }, clip: true, {
    // Deck colour bar across the top, bleeding off the top and sides (not on the
    // full-black Countdown cards).
    if not black {
      place(top + left, rect(width: 100%, height: bl + 0.05in, fill: color))
    }
    // Card number, bottom-right. Kept >= 0.25in from the trim edge so it sits
    // inside The Game Crafter's poker safe zone (675x975 within the 825x1125 image).
    place(bottom + right, dx: -(bl + 0.19in), dy: -(bl + 0.15in),
      text(font: "Inter", size: 6pt,
        fill: if black { rgb("#9ca3af") } else { ink.lighten(20%) }, card.number))
    // Quote author, bottom-centre (Reflection cards).
    if author != none {
      place(bottom + center, dy: -(bl + 0.28in),
        text(font: "Inter", size: 7pt, fill: fg, tracking: 0.04em, "- " + upper(author) + " -"))
    }
    // Content flow in the safe area.
    block(width: 100%, height: 100%, inset: (
        left: bl + 0.19in, right: bl + 0.19in,
        top: bl + 0.05in + 0.1in, bottom: bl + 0.34in,
      ),
      layout(size => {
        set text(font: "Inter", fill: fg)
        // Stack title -> art -> text tight at the TOP (matches the web/play card):
        // kill Typst's default block/paragraph gaps, control spacing with v(), and
        // trim Italianno's tall line box so the art sits right under the title.
        set par(spacing: 0pt)
        set block(spacing: 0pt)
        let aw = size.width
        // Title and art take fixed space at the top; measure them so the body gets
        // the real remaining height to shrink-to-fit against.
        let title-el = if title != "" {
          text(font: "Italianno", size: 28pt, fill: fg,
            top-edge: "cap-height", bottom-edge: "baseline", title)
        }
        let art-el = if hasart { image(art-dir + card.art, width: 100%, fit: "contain") }
        let used = 0pt
        if title != "" { used += measure(title-el).height + 0.1in }
        if hasart { used += measure(box(width: aw, art-el)).height + 0.1in }
        // One size for every card; step down only if the body overflows what is left.
        let mk = s => par(leading: 0.5em, justify: false, text(size: s, body))
        let bsize = body-size
        while bsize > body-min and measure(box(width: aw, mk(bsize))).height > size.height - used {
          bsize = bsize - 0.5pt
        }
        // Emit top-down: title, art, then body (left for art cards; centred and
        // vertically centred for the text-only quote / Countdown cards).
        if title != "" { align(center, title-el); v(0.1in) }
        if hasart { align(center, art-el); v(0.1in) }
        if hasart {
          mk(bsize)
        } else {
          v(1fr); align(center, mk(bsize)); v(1fr)
        }
      })
    )
  })
}

// --- single: one card per UNIQUE design, trim + bleed ---------------------------
// POD tools take one art per card plus a quantity field (the manifest carries
// `count`), so single mode emits the 79 designs once; sheet mode expands physical.
#let render-single() = {
  set page(width: page-w, height: page-h, margin: 0pt, fill: paper)
  for (i, card) in data.cards.enumerate() {
    face-box(card)
    if i + 1 < data.cards.len() { pagebreak() }
  }
}

// --- sheet: 8-up on landscape Letter, grouped by deck, faces then backs ---------
// Landscape Letter (11 x 8.5) fits 4 x 2 cards (10 x 7in) inside a 0.5in margin;
// portrait can only fit 2 rows of 3.5in cards, so landscape wastes less paper.
#let cols = 4
#let rows = 2
#let per-sheet = cols * rows

#let card-grid(cells) = grid(
  columns: (trim-w,) * cols,
  rows: (trim-h,) * rows,
  align: center + horizon,
  stroke: 0.25pt + gray,            // cut on the line
  ..cells,
)

#let back-cell(card) = box(width: trim-w, height: trim-h, clip: true,
  image(art-dir + card.back, width: 100%, height: 100%, fit: "cover"))
#let blank-cell = box(width: trim-w, height: trim-h)

#let render-sheet() = {
  set page("us-letter", flipped: true, margin: 0.5in, fill: white)
  set align(center + horizon)
  let first = true
  for deck in data.decks {
    let cards = physical.filter(c => c.deck == deck.slug)
    if cards.len() == 0 { continue }
    let n-sheets = calc.ceil(cards.len() / per-sheet)
    for s in range(n-sheets) {
      let chunk = cards.slice(s * per-sheet, calc.min((s + 1) * per-sheet, cards.len()))
      // faces
      if not first { pagebreak() }
      first = false
      card-grid(chunk.map(c => face-box(c, bl: 0pt)))
      // backs, column-mirrored so a long-edge (left-right) duplex flip lands each
      // card's own back behind it. Each card now has its own back, so the uniform
      // trick no longer applies and the grid must be mirrored.
      pagebreak()
      let bg = range(per-sheet).map(_ => blank-cell)
      for (idx, c) in chunk.enumerate() {
        let r = calc.floor(idx / cols)
        let col = calc.rem(idx, cols)
        bg.at(r * cols + (cols - 1 - col)) = back-cell(c)
      }
      card-grid(bg)
    }
  }
}

#if mode == "sheet" { render-sheet() } else { render-single() }
