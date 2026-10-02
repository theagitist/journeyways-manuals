// JOURNEYWAYS card backs - print renderer.
// One page per card (same order as cards.typ single faces), each the card's own
// back art full-bleed at trim + 1/8in bleed, for full-custom print-on-demand.
// Backs vary within a deck: every card gets its own crop of the deck's colour
// (see play scripts/export-print-cards.js). Language-independent (no text).
// Compile: typst compile --font-path fonts --root . src/card-backs.typ card-backs.pdf

#let data = json("../assets/cards/cards.json")

#let trim-w = 2.5in
#let trim-h = 3.5in
#let bleed  = 0.125in
#let page-w = trim-w + 2 * bleed
#let page-h = trim-h + 2 * bleed

#set page(width: page-w, height: page-h, margin: 0pt)

#for (i, card) in data.cards.enumerate() {
  image("../assets/cards/" + card.back, width: 100%, height: 100%, fit: "cover")
  if i + 1 < data.cards.len() { pagebreak() }
}
