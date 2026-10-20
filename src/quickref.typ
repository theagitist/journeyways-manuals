// JOURNEYWAYS Quick Reference: one square page with the core mechanics.
// Same 8.5x8.5 trim and design system as the game rules (reuses content.typ).
// Deck names and colours come from decks.json (the play locales). English only
// for now, like the physical game (ADR-025).
// (c) 2025-2026 Adri M., CC BY-NC 4.0.

#import "content.typ": *

#set page(width: leaf-w, height: leaf-h, margin: 0pt)

#let qh(body) = block(above: 12pt, below: 6pt,
  text(font: "Italianno", size: 30pt, fill: c-orange, body))
#let row(chip-name, d, col, body) = grid(
  columns: (0.42in, 1fr), column-gutter: 9pt, align: (horizon, top),
  chip(chip-name),
  [#text(weight: "bold", fill: col)[#d.colour (#d.name)] \ #body])

#box(width: leaf-w, height: leaf-h, clip: true, {
  place(top + left, dx: 0.75in, dy: 0.45in, box(width: leaf-w - 1.5in, {
    set text(font: "Inter", size: 11pt, fill: c-ink)
    set par(leading: 0.65em, spacing: 0.75em)
    set list(indent: 4pt, spacing: 0.55em)
    align(center, {
      text(font: "Italianno", size: 50pt, fill: c-orange, [Quick reference])
      v(-6pt)
      line(length: 1.5in, stroke: 0.9pt + c-orange.lighten(15%))
    })
    v(2pt)
    grid(columns: (1fr, 1fr), column-gutter: 0.35in,
      {
        qh[Your turn]
        enum(spacing: 0.6em,
          [*Explore.* Place a map tile next to another, or draw a new place on a sticky note and stick it over an empty tile. A blank tile: create it first. Then move one or two spaces, any direction.],
          [*Pick.* Take a card from any pile, even the Discard pile.],
          [*Reflect.* Act on the card or write in your journal (see the colours).],
        )
        p[Turns are loose: play when you feel ready, or sit a turn out.]
        qh[Setup at a glance]
        list(
          [Cards: shuffle into three face-down piles; turn one face up as the Discard pile.],
          [Tiles: shuffle into three face-down piles.],
          [Agree who starts; that player places the first tile in the middle.],
          [Take turns adding tiles, then everyone's piece goes on the first tile.],
        )
      },
      {
        qh[The card colours]
        stack(spacing: 11pt,
          row("green", deck.movement, c-green)[How you move on the map. *Do what it says.*],
          row("purple", deck.group, c-purple)[A group event for the whole table. *Do what it says.* Leave these out in solo play.],
          row("blue", deck.reflection, c-blue)[A quote to reflect on. *Write a journal entry.*],
          row("red", deck.encounter, c-red)[Something happens on your journey. *Write a journal entry.*],
          row("black", deck.countdown, c-mut)[The passing of time. *Set it apart.* The fifth one ends the game.],
        )
        v(4pt)
        p[After a card, discard it or keep it as a log of your journey; it does nothing more.]
      },
    )
    v(4pt)
    callout[
      *Good to know.* Any rule can be bent or broken if the group agrees. Your journal can be words, doodles or both, as long or short as you like. Skip any card, prompt or turn without explaining. The game ends at the fifth #bl card, or whenever the group decides. Nobody wins: you play to discover, explore and become.
    ]
  }))
  place(bottom + center, dy: -0.55in,
    grid(columns: 5, column-gutter: 10pt,
      ..("crossroads-m.jpg", "mirror-lake-m.jpg", "lantern-festival-m.jpg", "star-bridge-m.jpg", "northern-lights-m.jpg").map(f => tile-img(f, 0.8in))))
  place(bottom + center, dy: -0.25in,
    text(font: "Inter", size: 8pt, fill: c-mut)[JOURNEYWAYS · A board game about becoming · www.journeyways.ca · © 2025-2026 Adri M., CC BY-NC 4.0])
})
