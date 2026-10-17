// JOURNEYWAYS card faces - print renderer.
//
// One face per card, driven entirely by the single-source manifest the play repo
// exports (assets/cards/cards.json: card number, deck, colour, art, localized
// title/content, author, physical count). Text and art come from the same source
// as the digital card and the website, so print and screen cannot drift.
//
// Typography and palette mirror the digital card (game-components.css): warm paper
// #fdfbf6, Italianno title, Nunito body, per-deck colour bar, black Countdown panel.
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

// Text sizes mirror the web/play card (game-components.css, 1cqw = 1.8pt on a
// 2.5in card): one size per kind (art card / text-only card), and a card whose
// text would overflow steps down the same fixed ladder the web uses, so the
// deck shows only a few sizes.
#let art-size  = 11.5pt   // 6.4cqw
#let text-size = 16.5pt   // 9.2cqw
#let fit-steps = (1, 0.88, 0.78, 0.7)

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
    // Content flow in the safe area.
    block(width: 100%, height: 100%, inset: (
        left: bl + 0.18in, right: bl + 0.18in,
        top: bl + if hasart { 0.18in } else { 0.19in }, bottom: bl + 0.25in,
      ),
      layout(size => {
        set text(font: "Nunito", fill: fg)
        // Title, then the art edge to edge, then the body centred (both ways) in
        // the space left above the card number, as on the web/play card.
        set par(spacing: 0pt)
        set block(spacing: 0pt)
        let aw = size.width
        let title-el = if title != "" {
          text(font: "Italianno", size: 28pt, fill: fg,
            top-edge: "cap-height", bottom-edge: "baseline", title)
        }
        // The art runs past the side margins to the trim and on into the bleed,
        // cropped 3:2 (only blank paper goes; the paper is pre-matched to #fdfbf6).
        let art-h = w / 1.5
        let art-el = if hasart {
          block(width: aw, height: art-h,
            place(center + top, image(art-dir + card.art, width: w + 2 * bl, height: art-h, fit: "cover")))
        }
        let used = 0pt
        if title != "" { used += measure(title-el).height + 0.08in }
        if hasart { used += art-h + 0.02in }
        let base = if hasart { art-size } else { text-size }
        // Full ascender-to-descender line boxes (Nunito spans 1.364em), so the
        // leading below reproduces CSS line-height 1.38 / 1.5 and the fit check
        // measures the same box the browser does.
        let lead = if hasart { 0.016em } else { 0.136em }
        // Styles are set INSIDE mk: measure() only sees the styles of the content
        // it is given, not the set rules of this layout block.
        let mk = s => {
          set text(font: "Nunito", fill: fg, size: s, top-edge: "ascender", bottom-edge: "descender")
          set par(spacing: 0pt)
          set block(spacing: 0pt)
          align(center, par(leading: lead, justify: false, body))
          if author != none {
            v(0.14in)
            align(center, text(size: 7pt, fill: if black { fg } else { rgb("#6b7280") }, tracking: 0.08em, "- " + upper(author) + " -"))
          }
        }
        let bsize = base * fit-steps.last()
        for f in fit-steps {
          if measure(block(width: aw, mk(base * f))).height <= size.height - used { bsize = base * f; break }
        }
        if title != "" { align(center, title-el); v(0.08in) }
        if hasart { art-el; v(0.02in) }
        v(1fr); mk(bsize); v(1fr)
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
