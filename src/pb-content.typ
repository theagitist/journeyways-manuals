// JOURNEYWAYS Player Booklet - content module.
// Reproduces "Journeyways character sheet 1.1.pdf" (the Player Booklet): cover,
// intro, a fill-in Character Sheet, 12 lined journal pages, and a back cover.
// Art-heavy pages (cover, journal) are placed as faithful full-page renders;
// text pages (intro, character sheet, back cover) are rebuilt with the brand
// fonts (Italianno + Inter). The booklet is monochrome (black script headings).
//
// Content (c) 2025 Adri M., CC BY-NC 4.0.

// Letter-proportioned leaf matching the source trim (695.25 x 900 pt ~= 0.773).
#let pbw = 5.5in
#let pbh = 7.12in

#let c-ink = rgb("#1A1A1A")
#let c-mut = rgb("#555555")
#let c-boxln = rgb("#333333")
#let c-boxfill = rgb("#F4F4F2")

#let pba(p) = "../assets/player-booklet/" + p

// Full-page image leaf (cover, journal pages) - faithful render, full bleed.
#let img-leaf(path) = box(width: pbw, height: pbh, clip: true,
  image(pba(path), width: pbw, height: pbh, fit: "cover"))

// Rebuilt page: faint watercolour wash background + optional content margin.
#let pb-frame(pad: 0.5in, body) = box(width: pbw, height: pbh, clip: true, {
  place(top + left, image(pba("art/wash-faint.png"), width: pbw, height: pbh, fit: "cover"))
  place(top + left, dx: pad, dy: pad, box(width: pbw - 2 * pad, height: pbh - 2 * pad, body))
})

#let script(size, body) = text(font: "Italianno", size: size, fill: c-ink, body)
#let tagline = text(font: "Inter", weight: "bold", size: 9pt, fill: c-ink, tracking: 0.02em,
  [A BOARD GAME ABOUT BECOMING.])

// --- Leaves --------------------------------------------------------------------

// 1. Cover (full render).
#let pb-cover = img-leaf("pages/cover-01.png")

// 2. Intro + quick guide. Black and white; a short lead, then a handy reference.
#let qh(body) = block(above: 9pt, below: 3pt,
  text(font: "Inter", weight: "bold", size: 10pt, fill: c-ink, body))
#let pb-intro = pb-frame(pad: 0.5in, {
  script(44pt, [Journeyways])
  v(-4pt)
  tagline
  v(9pt)
  block(width: 100%, text(font: "Inter", size: 11pt, style: "italic", fill: c-ink)[
    Step into a world where identity is not chosen but uncovered. In Journeyways,
    you don't play to win; you play to unfold.
  ])
  v(15pt)
  script(28pt, [Quick Reference])
  v(9pt)
  set text(font: "Inter", size: 9.5pt, fill: c-ink)
  set par(leading: 0.5em, spacing: 0.5em)
  set list(indent: 4pt, spacing: 0.5em, marker: [•])

  qh[Each turn has three phases: Explore, Draw, Reflect.]
  list(
    [*Explore:* place a map tile (or invent one on a sticky note), then move one or two spaces.],
    [*Draw:* take a card from any pile, even the Discard pile.],
    [*Reflect:* do what the card asks, then write in your journal.],
  )

  qh[What the card colours mean]
  list(
    [*Green:* movement.],
    [*Blue:* a quote to reflect on.],
    [*Red:* an encounter.],
    [*Purple:* a group event (leave these out for solo play).],
    [*Black:* the passing of time. The game ends when the fifth Black card is drawn.],
  )

  qh[Good to know]
  list(
    [*Green* and *Purple* ask you to perform the action shown; *Blue* and *Red* invite a journal entry.],
    [There is no winning or losing, only becoming. Take as much time as you need.],
    [Turns are not strict: play when you have the opportunity to do so.],
    [Any rule can be bent or changed, as long as everyone playing agrees.],
  )
})

// 3. Character Sheet.
#let prompt(l) = block(below: 3pt, above: 8pt, text(font: "Inter", size: 9.5pt, fill: c-ink, l))
#let cbox(h) = rect(width: 100%, height: h, radius: 1pt, stroke: 0.7pt + c-boxln, fill: c-boxfill)
#let pb-charsheet = box(width: pbw, height: pbh, clip: true, {
  place(top + left, image(pba("art/wash-faint.png"), width: pbw, height: pbh, fit: "cover"))
  place(top + left, dx: pbw - 2.7in, dy: 0.55in, image(pba("art/swirl-faint.png"), width: 2.4in))
  place(top + left, dx: 0.4in, dy: 0.4in, box(width: pbw - 0.8in, height: pbh - 0.8in, {
    grid(columns: (1fr, 1fr), column-gutter: 14pt,
      {
        script(30pt, [Character Sheet])
        prompt[Where do I come from?]
        cbox(0.62in)
        prompt[Where am I now?]
        cbox(0.62in)
        prompt[What/who am I?]
        cbox(0.62in)
        prompt[Why?]
        cbox(0.62in)
      },
      {
        script(30pt, [Journeyways])
        prompt[What do I look like?]
        cbox(2.35in)
        prompt[My name is:]
        cbox(0.4in)
      },
    )
    v(10pt)
    prompt[What's my goal, what am I here to do, what's my nature?]
    cbox(1.15in)
  }))
})

// 4-15. Journal pages: rebuilt in Typst. Faint wash + swirl background with an
// Italianno "Journeyways" header and vector ruled lines. The shared wash/swirl
// are panned/repositioned per page (deterministic by index) so the 12 pages keep
// the source's varied feel without baking in the original raster header.
#let pb-journal-page(i) = box(width: pbw, height: pbh, clip: true, {
  // faint watercolour wash, panned horizontally per page. Width is wider than the
  // page (+4in) so panning left never exposes white on the right (max pan 3in).
  place(top + left, dx: -0.5in * calc.rem(i, 7),
    image(pba("art/wash-faint.png"), width: pbw + 4in))
  // faint swirl decoration, position + size varied per page
  place(top + right,
    dx: 0.25in + 0.1in * calc.rem(i, 3),
    dy: 0.1in + 0.13in * calc.rem(i * 5, 7),
    image(pba("art/swirl-faint.png"), width: 2.7in + 0.16in * calc.rem(i * 2, 4)))
  // Italianno header, top-right
  place(top + right, dx: -0.45in, dy: 0.42in,
    text(font: "Italianno", size: 34pt, fill: c-ink, [Journeyways]))
  // ruled writing lines
  place(top + left, dx: 0.45in, dy: 1.2in, box(width: pbw - 0.9in, {
    for _ in range(17) {
      line(length: 100%, stroke: 0.6pt + c-boxln)
      v(0.315in)
    }
  }))
})
#let pb-journal = range(12).map(i => pb-journal-page(i))

// 16. Back cover.
#let pb-back = box(width: pbw, height: pbh, clip: true, {
  place(top + left, image(pba("art/wash-faint.png"), width: pbw, height: pbh, fit: "cover"))
  place(top + right, dx: 0.35in, dy: -0.15in, image(pba("art/swirl-faint.png"), width: 3in))
  place(top + center, dy: 0.7in, align(center, {
    script(42pt, [Journeyways])
    v(-4pt)
    tagline
  }))
  place(horizon + center, dy: -0.1in, image(pba("art/qr.png"), width: 2in))
  place(bottom + center, dy: -0.6in, align(center,
    text(font: "Inter", size: 9pt, style: "italic", fill: c-mut)[
      © 2025 Adri M. Licensed under CC BY-NC 4.0. \
      https://www.journeywaysgame.com
    ]))
})

// Reading order: cover, intro, character sheet, 12 journal pages, back cover = 16.
#let pb-leaves = (pb-cover, pb-intro, pb-charsheet, ..pb-journal, pb-back)
