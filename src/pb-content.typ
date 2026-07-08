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

// 2. Intro: title + prose (left) + two illustrations (right).
#let pb-intro = pb-frame(pad: 0.45in, {
  script(46pt, [Journeyways])
  v(-6pt)
  tagline
  v(10pt)
  grid(columns: (1.15fr, 1fr), column-gutter: 14pt,
    {
      set text(font: "Inter", size: 10pt, fill: c-ink, style: "italic")
      set par(leading: 0.6em, spacing: 0.85em)
      [Step into a world where identity is not chosen but uncovered. In Journeyways, you don't play to win; you play to unfold.]
      parbreak()
      [Explore selfhood not with labels, but with motion, memory, and meaning.]
      parbreak()
      [Whether solo or in chorus, each session reveals a story made only by your presence.]
      parbreak()
      [With no fixed roles and no final answers, Journeyways invites you to co-create the story of who you are and who you are becoming.]
      parbreak()
      [No rules to break. Just ways to move.]
    },
    {
      image(pba("art/intro-1.png"), width: 100%)
      v(10pt)
      image(pba("art/intro-2.png"), width: 100%)
    },
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

// 4-15. Journal pages (full renders).
#let pad2(n) = if n < 10 { "0" + str(n) } else { str(n) }
#let pb-journal = range(4, 16).map(n => img-leaf("pages/journal-" + pad2(n) + ".png"))

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
      Prototype material. Not for public distribution. \
      © 2025. Adri M. All rights reserved. \
      https://www.journeywaysgame.com
    ]))
})

// Reading order: cover, intro, character sheet, 12 journal pages, back cover = 16.
#let pb-leaves = (pb-cover, pb-intro, pb-charsheet, ..pb-journal, pb-back)
