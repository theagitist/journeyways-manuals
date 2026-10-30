// Box art for The Game Crafter, drawn straight onto TGC's die-line templates
// (300 DPI, sizes from https://www.thegamecrafter.com/api/tgc/products).
// One part per build:  --input part=lid | base | deck-<slug>
//   lid   Large Retail Box top: the front cover + four sides
//   base  Large Retail Box bottom: the back of the box (blurb, contents, credits)
//   deck-encounter ... deck-group   Poker Hook Box, one per deck (18 or 36 cards)
// English only (the physical game is English-only, ADR-025).
// Card faces come from tgc-png/en (run ./build-cards.sh --png first).
#import "content.typ": paper, c-orange, c-ink, c-mut, c-green, c-blue, c-red, c-purple, asset, deck, qr-tile

#let part = sys.inputs.at("part", default: "lid")
#let px(n) = n * 1in / 300
#set text(font: "Nunito", fill: c-ink)

// A rectangle of the template, in template pixels.
#let at(x0, y0, x1, y1, body) = place(top + left, dx: px(x0), dy: px(y0),
  box(width: px(x1 - x0), height: px(y1 - y0), body))
#let tile(name, s) = box(width: s, height: s, radius: 0.08in, clip: true,
  stroke: 1.5pt + white, image(asset("tiles/" + name + "-full.webp"), width: 100%, height: 100%, fit: "cover"))
#let face(num, w) = box(width: w, radius: 0.1in, clip: true, stroke: 1.5pt + white,
  image("../tgc-png/en/" + num + ".png", width: 100%))
#let side-text(body, a) = align(center + horizon, rotate(a, reflow: true,
  text(size: 18pt, weight: "bold", tracking: 0.1em, fill: c-ink, body)))
#let wordmark(size) = text(font: "Italianno", size: size, fill: c-orange, bottom-edge: "descender", [Journeyways])
#let facts = [1 to 6 players, plus a facilitator #h(0.6em)·#h(0.6em) 60 to 90 minutes of play #h(0.6em)·#h(0.6em) Ages 12+]

// --- Large Retail Box (template 3975 x 4725; folds at 243/581/3393/3731 across,
// 243/581/4143/4481 down). The front panel is 581..3393 x 581..4143.
#let retail(front, sides: true) = {
  set page(width: px(3975), height: px(4725), margin: 0pt, fill: paper)
  at(581, 581, 3393, 4143, front)
  if sides {
    // Each side reads upright when the lid sits on the table: letter tops face the front panel.
    let s = [JOURNEYWAYS #h(1.2em) A board game about becoming]
    at(581, 243, 3393, 581, side-text(s, 180deg))
    at(581, 4143, 3393, 4481, side-text(s, 0deg))
    at(243, 581, 581, 4143, side-text(facts, 90deg))
    at(3393, 581, 3731, 4143, side-text(facts, -90deg))
  }
}

#let lid-front = {
  place(top + center, dy: 0.45in, image(asset("logo-mark.png"), width: 5.9in))
  place(top + center, dy: 5.75in, wordmark(180pt))
  place(top + center, dy: 8.55in, text(weight: "bold", style: "italic", size: 30pt, [A board game about becoming]))
  // A strip of real map tiles along the bottom, gently scattered.
  let names = ("firefly-forest", "ferris-wheel", "dunes", "bridge", "crossroads")
  let tilt = (-6deg, 4deg, -2deg, 5deg, -4deg)
  place(bottom + center, dy: -0.55in, stack(dir: ltr, spacing: -0.05in,
    ..names.zip(tilt).map(((n, a)) => rotate(a, tile(n, 1.62in)))))
}

#let decks = (
  ("encounter", c-red, 34), ("movement", c-green, 18), ("reflection", c-blue, 27),
  ("countdown", c-mut, 12), ("group", c-purple, 21),
)

#let base-front = pad(x: 0.55in, y: 0.5in, {
  set par(leading: 0.62em, spacing: 0.9em, justify: false)
  box(width: 100%, height: 1.75in, {
    place(top + center, dy: -0.25in, wordmark(100pt))
    place(bottom + center, text(weight: "bold", style: "italic", size: 18pt, [A board game about becoming]))
  })
  v(0.2in)
  set text(size: 13.5pt)
  [JOURNEYWAYS is a game of collaborative storytelling about identity and becoming. Together you build a map as you go, place by place, and pick cards that ask you to meet, move, remember and reflect. Your character is not set at the start: it emerges through play, and you write the journey down as it happens.]
  parbreak()
  [There is no winning or losing. The rules are a frame to start from: bend them, adapt any card you pick, add your own places. The single fixed rule is that everyone at the table agrees.]
  v(0.15in)
  // A fan of real cards, one from each deck, over a few tiles.
  align(center, box(height: 2.55in, width: 100%, {
    place(center + horizon, dx: -2.6in, rotate(-8deg, tile("dunes", 1.6in)))
    place(center + horizon, dx: 2.6in, rotate(7deg, tile("ferry-dock", 1.6in)))
    let nums = ("R1", "G1", "B1", "K1", "P1")
    for (i, n) in nums.enumerate() {
      place(center + horizon, dx: (i - 2) * 0.95in, dy: calc.abs(i - 2) * 0.12in,
        rotate((i - 2) * 6deg, face(n, 1.75in)))
    }
  }))
  v(0.15in)
  grid(columns: (1.15fr, 1fr), column-gutter: 0.35in,
    {
      text(weight: "bold", size: 12pt, tracking: 0.1em, fill: c-orange, [IN THE BOX])
      v(0.04in)
      set text(size: 12.5pt)
      [112 cards in five decks:]
      for (slug, col, n) in decks {
        linebreak()
        box(width: 0.16in, height: 0.16in, radius: 0.03in, fill: col, baseline: 0.02in)
        h(0.4em)
        [#n #deck.at(slug).colour (#deck.at(slug).name)]
      }
      linebreak()
      [48 map tiles (47 places, 1 blank)]
      linebreak()
      [Game Rules, Facilitator's Guide, Quick Reference]
    },
    {
      text(weight: "bold", size: 12pt, tracking: 0.1em, fill: c-orange, [TO PLAY])
      v(0.04in)
      set text(size: 12.5pt)
      [1 to 6 players, plus a facilitator \ About 2 hours with setup \ (60 to 90 minutes of play) \ Ages 12+]
      v(0.12in)
      [Each player needs a Player Booklet: download and print it free at journeyways.ca/components.]
    })
  v(1fr)
  grid(columns: (auto, 1fr), column-gutter: 0.25in, align: horizon,
    qr-tile("qr-components.svg", size: 1.0in),
    {
      set text(size: 10pt, fill: c-mut)
      [*Game design and text:* Adri M. #h(0.5em) A master's research project at the UBC Institute for Gender, Race, Sexuality and Social Justice, Vancouver, Canada.]
      linebreak()
      [© 2025-2026 Adri M. Licensed CC BY-NC 4.0. #h(0.5em) journeyways.ca]
    })
})

// --- Poker Hook Box, one per deck. Template sizes and fold lines per box.
#let hook = (
  "18": (w: 2475, h: 3000, cols: (783, 855, 1620, 1692), rows: (685, 768, 1833, 1913)),
  "36": (w: 2700, h: 3150, cols: (805, 968, 1733, 1895), rows: (680, 841, 1906, 2067)),
)

#let deck-box(slug, col, n) = {
  let t = hook.at(if n <= 18 { "18" } else { "36" })
  let (c0, c1, c2, c3) = t.cols
  let (r0, r1, r2, r3) = t.rows
  set page(width: px(t.w), height: px(t.h), margin: 0pt,
    background: image(asset("cards/back-" + slug + "-00.webp"), width: 100%, height: 100%, fit: "cover"))
  let d = deck.at(slug)
  let label = box(fill: paper.transparentize(8%), radius: 0.1in, inset: (x: 0.14in, y: 0.12in), width: 100%,
    align(center, {
      text(font: "Italianno", size: 34pt, fill: c-orange, bottom-edge: "descender", [Journeyways])
      linebreak()
      text(weight: "bold", size: 15pt, fill: col.darken(15%), d.name)
      linebreak()
      text(size: 9pt, fill: c-mut, [#n #d.colour cards])
    }))
  // Front panel: the label, centred.
  at(c1, r1, c2, r2, pad(x: 0.16in, align(center + horizon, label)))
  // Back panel (under the hook lid): the deck's role, small.
  at(c1, r3, c2, t.h - 120, pad(x: 0.2in, top: 0.35in, align(center + top,
    box(fill: paper.transparentize(8%), radius: 0.08in, inset: 0.1in, width: 100%,
      text(size: 8pt, fill: c-ink, [#d.name deck #h(0.3em)·#h(0.3em) #n cards \ journeyways.ca])))))
  // Spines, reading upward on the left and downward on the right.
  let spine = box(fill: paper.transparentize(8%), radius: 0.04in, inset: (x: 0.08in, y: 0.03in),
    text(weight: "bold", size: 8pt, tracking: 0.12em, fill: c-ink, upper[Journeyways · #d.name]))
  at(c0, r1, c1, r2, align(center + horizon, rotate(-90deg, reflow: true, spine)))
  at(c2, r1, c3, r2, align(center + horizon, rotate(90deg, reflow: true, spine)))
}

#{
  if part == "lid" { retail(lid-front) } else if part == "base" { retail(base-front) } else {
    let slug = part.slice(5)
    let (_, col, n) = decks.find(d => d.at(0) == slug)
    deck-box(slug, col, n)
  }
}
