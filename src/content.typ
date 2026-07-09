// JOURNEYWAYS Game Rules - content module.
// One square 8.5x8.5 reading edition (`manual-leaves`), one topic per page, with
// generous spacing. The former imposed 2-up booklet edition was retired: the
// boardgame box holds a square trim, so the manual prints on letter and is
// trimmed at the bottom to 8.5x8.5.
//
// Typography mirrors the web/play brand: Italianno (display script) + Inter (body).
// Content reproduces the JOURNEYWAYS game rules (c) 2025-2026 Adri M., CC BY-NC 4.0.

// Square trim: the boardgame box holds an 8.5x8.5 booklet, so the manual is
// printed on letter and trimmed at the bottom to a square. Large single edition
// (no 2-up imposition).
#let leaf-w = 8.5in
#let leaf-h = 8.5in

// --- Brand palette (sampled from the source PDF) -------------------------------
#let c-orange = rgb("#F59E0B")   // script headings + labels
#let c-ink    = rgb("#1A1A1A")   // body text
#let c-mut    = rgb("#6B7280")   // footer / muted / "Black" cards
#let c-green  = rgb("#26C08D")
#let c-blue   = rgb("#3B82F6")
#let c-red    = rgb("#EF4444")
#let c-purple = rgb("#8B5CF6")

#let asset(name) = "../assets/" + name

// --- Type helpers --------------------------------------------------------------
// Section title: centred script + a short hairline rule for a modern, structured
// feel. The rule also visually separates the display heading from the body.
#let title(body) = block(below: 12pt, width: 100%, align(center, {
  text(font: "Italianno", size: 52pt, fill: c-orange, body)
  v(-2pt)
  line(length: 1.5in, stroke: 0.9pt + c-orange.lighten(15%))
}))
// Subhead: extra room above and below so it reads as a clear section break.
#let subhead(body) = block(above: 18pt, below: 11pt,
  text(font: "Italianno", size: 30pt, fill: c-orange, body))
#let label-b(body) = block(above: 13pt, below: 6pt,
  text(font: "Inter", weight: "bold", size: 12pt, fill: c-orange, body))
#let card(name, col) = text(fill: col, weight: "bold", name)
#let g = card("Green", c-green)
#let bl = card("Black", c-mut)
#let blu = card("Blue", c-blue)
#let rd = card("Red", c-red)
#let pp = card("Purple", c-purple)

#let body-set(body) = {
  set text(font: "Inter", size: 11.5pt, fill: c-ink)
  set par(leading: 0.9em, spacing: 1.15em, justify: false)
  body
}
// Paragraph block so consecutive body paragraphs space apart in code mode.
#let p(body) = block(below: 1.0em, width: 100%, body)
#let blist(..items) = list(indent: 8pt, spacing: 0.7em, ..items)
#let nlist(..items) = enum(indent: 8pt, spacing: 0.72em, ..items)

// --- Design elements -----------------------------------------------------------
// Watercolour colour chip (real card-background art) for the card legend.
#let chip(name) = box(width: 0.4in, height: 0.4in, radius: 4pt, clip: true,
  stroke: 0.5pt + c-mut.lighten(40%),
  image(asset("chips/" + name + ".jpg"), width: 100%, height: 100%, fit: "cover"))

// Card-colour legend: a compact two-column key (chip + name + meaning).
#let leg-item(name, label, meaning) = grid(
  columns: (0.34in, 1fr), column-gutter: 8pt, align: horizon,
  chip(name), [#text(weight: "bold")[#label] #meaning])
#let card-legend = block(above: 7pt, below: 5pt, grid(
  columns: (1fr, 1fr), column-gutter: 18pt, row-gutter: 9pt,
  leg-item("green", "Green:", "movement."),
  leg-item("blue", "Blue:", "a quote to reflect on."),
  leg-item("red", "Red:", "an encounter."),
  leg-item("purple", "Purple:", "a group event."),
  leg-item("black", "Black:", "the passing of time."),
))

// Two equal columns.
#let two-col(left, right, gutter: 26pt) = grid(
  columns: (1fr, 1fr), column-gutter: gutter, left, right)

// Tinted callout with a coloured left bar (Remember / highlights).
#let callout(body, accent: c-orange) = block(width: 100%, inset: (x: 13pt, y: 11pt),
  radius: 5pt, fill: accent.lighten(90%), stroke: (left: 3pt + accent), body)

// A journal-style line doodle with a small handwritten caption (side note).
#let doodle-note(name, caption, w: 1.7in) = box(width: w, {
  image(asset("doodles/" + name + ".jpg"), width: 100%)
  align(center, text(font: "Italianno", size: 18pt, fill: c-mut, caption))
})

// --- Page frame ----------------------------------------------------------------
#let frame(num: none, left-num: false, body) = box(
  width: leaf-w, height: leaf-h, clip: true,
  {
    // Faint swirl watermark: a whisper in the corner, no longer crossing the
    // headings as a dark graphic.
    place(top + right, dx: 0.7in, dy: -0.8in,
      image(asset("swirl-faint.png"), width: 6in))
    place(top + center, dy: 0.5in,
      text(font: "Inter", size: 8.5pt, fill: c-ink,
        [© 2025-2026 JOURNEYWAYS. A board game about becoming.]))
    place(top + left, dx: 1.2in, dy: 0.82in,
      box(width: leaf-w - 2.4in, height: leaf-h - 1.5in, body-set(body)))
    if num != none {
      place(bottom + (if left-num { left } else { right }),
        dx: (if left-num { 1.2in } else { -1.2in }), dy: -0.42in,
        text(font: "Inter", size: 10pt, fill: c-mut, str(num)))
    }
  }
)

// --- Shared front matter -------------------------------------------------------

// Cover: full-bleed art.
#let leaf-cover = box(width: leaf-w, height: leaf-h, clip: true,
  image(asset("cover.jpg"), width: leaf-w, height: leaf-h, fit: "cover"))

// A single map-tile shown as a rounded gallery card (uses the real game art).
#let tile-card(path) = box(width: 1.7in, height: 1.7in, radius: 6pt, clip: true,
  stroke: 0.6pt + c-mut.lighten(35%),
  image(asset("tiles/" + path), width: 100%, height: 100%, fit: "cover"))

// Title / intro (unnumbered).
#let leaf-title = frame(
  {
    v(0.05in)
    align(center, text(font: "Italianno", size: 54pt, fill: c-orange, [JOURNEYWAYS]))
    align(center, text(font: "Italianno", size: 32pt, fill: c-orange, [Game Rules]))
    v(0.28in)
    set text(font: "Inter", size: 11.5pt, fill: c-ink)
    set par(leading: 0.7em, spacing: 0.85em)
    align(center, [
      Step into a world where identity is not chosen but uncovered.

      In JOURNEYWAYS, you don't play to win; you play to unfold.

      Explore selfhood not with labels, but with motion, memory, and meaning.

      Whether solo or in chorus, each session reveals a story made only by your presence.

      #text(weight: "bold")[With no fixed roles and no final answers, JOURNEYWAYS invites you to]

      co-create the story of who you are and who you are becoming.
    ])
    v(0.2in)
    align(center, text(style: "italic", [This manual will help you learn how to begin your journey of becoming.]))
    v(0.35in)
    align(center, box(width: 5.6in,
      grid(columns: 3, column-gutter: 16pt,
        tile-card("mirror-lake.jpg"),
        tile-card("mountain-peak.jpg"),
        tile-card("singing-cave.jpg"))))
    v(8pt)
    align(center, text(font: "Inter", size: 9pt, style: "italic", fill: c-mut,
      [A few of the places your journey may take you.]))
  }
)

// Table of Contents, parameterised so the two editions get the right folios.
#let toc-line(l, pg, indent: 0pt, bold: false, serif: false) = {
  set text(weight: (if bold { "bold" } else { "regular" }),
    style: (if serif { "italic" } else { "normal" }),
    size: (if bold { 12pt } else { 10.5pt }), fill: c-ink)
  box(width: 100%, inset: (left: indent))[
    #l #box(width: 1fr, repeat[.]) #pg
  ]
  v(if bold { 0.14em } else { 0.06em })
}
#let leaf-toc = frame(num: 1, left-num: true,
  {
    // Compact heading so the list clears the bottom of the page with padding.
    block(below: 9pt, width: 100%, align(center, {
      text(font: "Italianno", size: 42pt, fill: c-orange, [Table of Contents])
      v(-2pt)
      line(length: 1.4in, stroke: 0.9pt + c-orange.lighten(15%))
    }))
    v(2pt)
    toc-line("Game Setup", "2", bold: true)
    toc-line("What You'll Need", "2", indent: 20pt, serif: true)
    toc-line("Initial Setup", "2", indent: 20pt, serif: true)
    toc-line("Basic Gameplay", "3", bold: true)
    toc-line("Turn Structure", "3", indent: 20pt, serif: true)
    toc-line("1. Explore", "3", indent: 40pt, serif: true)
    toc-line("2. Pick", "3", indent: 40pt, serif: true)
    toc-line("3. Reflect", "3", indent: 40pt, serif: true)
    toc-line("Ending the game", "4", bold: true)
    toc-line("Writing your journal", "5", bold: true)
    toc-line("Solo vs Group Play", "7", bold: true)
    toc-line("Solo Play", "7", indent: 20pt, serif: true)
    toc-line("Group Play", "7", indent: 20pt, serif: true)
    toc-line("Advanced Concepts", "8", bold: true)
    toc-line("Session Endings", "8", indent: 20pt, serif: true)
    toc-line("Returning to Previous Sessions", "8", indent: 20pt, serif: true)
    toc-line("Creating Your Own Elements", "8", indent: 20pt, serif: true)
    toc-line("Tips for Meaningful Play", "9", bold: true)
    toc-line("Creating Safe Space", "9", indent: 20pt, serif: true)
    toc-line("Deepening the Experience", "9", indent: 20pt, serif: true)
  }
)

// Game Setup (folio 2).
#let leaf-setup = frame(num: 2, left-num: false,
  {
    title[Game Setup]
    subhead[What You'll Need]
    blist(
      [Board tiles (35).],
      [Game cards (81).],
      [Player tokens (1 per player).],
      [Player booklet (1 per player).],
      [Some sticky notes.],
      [Die for choosing the starting player (1).],
      [Writing utensils.],
    )
    // Illustration tucked into the empty right of the components list (out of flow).
    place(top + right, dy: 1.35in, doodle-note("playground", [set the scene], w: 1.55in))
    subhead[Initial Setup]
    nlist(
      [Shuffle all cards together and place them face down in three piles.],
      [Pick one card and place it apart face up. This will be the Discard pile.],
      [Find the Starter board tile and set it apart. Shuffle all others and place them face down in three piles.],
      [Each player takes one player token.],
      [Use the die to determine the starting player. For example, highest number goes first.],
      [Place the Starter board tile in the center of the table.],
      [Taking turns, each player picks a tile from any pile and places it adjacent to another previously placed tile. If it's a blank tile, put it back in the pile and pick again.],
      [All players place their tokens on the Starter tile.],
    )
  }
)

// Basic Gameplay (folio 3).
#let leaf-gameplay = frame(num: 3, left-num: true,
  {
    title[Basic Gameplay]
    subhead[Turn Structure]
    [Each turn consists of three phases: Explore, Pick, and Reflect.]
    label-b[1. Explore]
    [For Exploration, you have two options: (1) Pick a map tile and place it adjacent to another one. If you pick a blank tile, you have to create it before placing it. (2) Use a sticky note to draw a new map tile (whatever you want) and place it on top of an existing one where no player is located. After you place your tile, you can move one or two spaces in any direction.]
    label-b[2. Pick]
    [Pick a card from any pile, even the Discard pile. Each colour means something different:]
    card-legend
    label-b[3. Reflect]
    [If you picked a #g or #pp card, you have to perform the action it indicates. If you picked a #blu or #rd card, take into account what they say, and write a new entry in your journal. If you picked a #bl card, set it apart. The game ends when the fifth #bl card is picked.]
  }
)

// Ending the game (folio 4).
#let leaf-ending = frame(num: 4, left-num: false,
  {
    title[Ending the game]
    p[The game ends when the fifth #bl card is picked. Each player can add a final entry to their journal, or just leave it as it is. However, if all players agree you can end the session after any number of #bl cards are picked, or disregard the #bl cards and use a timer, etc.]
    p[It is okay if your story ends abruptly. You can leave it like that, or return to it in another session.]
    p[After ending the game, each player can fill their Character Sheet at the end of the Player Booklet. This way they can see how their character developed during the game; what changed, and what stayed the same.]
    v(4pt)
    callout[*Remember:* the game is not about winning or losing. It is about discovering, exploring, and becoming.]
    place(bottom + right, dy: 0.15in, doodle-note("cliff", [an ending, or a pause]))
  }
)

// Writing your journal (folio 5): the explanation.
#let leaf-journal = frame(num: 5, left-num: true,
  {
    title[Writing your journal]
    v(0.15in)
    p[Unlike traditional games, your character in JOURNEYWAYS emerges through play rather than being predetermined.]
    p[Use the game cards as inspiration, not rigid definitions; the main objective is you set your imagination free and write the story you want to tell. Journal entries can be as short or as long, as terse or as detailed as you want.]
    p[You can get inspiration from the tile where your token is located and the text in the card, but you can be as creative as you want. You can write a journal entry, doodle it, or do whatever you like.]
    v(0.1in)
    p[Here is an example of a possible journal entry, on the next page.]
    place(bottom + right, dy: 0.15in, doodle-note("trail", [where will you go?]))
  }
)

// The example journal entry, shown large and legible on its own page (folio 6).
#let leaf-journal-example = frame(num: 6, left-num: false,
  {
    v(0.15in)
    set par(leading: 0.58em, spacing: 0.85em, justify: false)
    text(font: "Italianno", size: 25pt, fill: c-ink)[
      It was a warm summer evening when I stumbled upon a cave entrance. There was a soft breeze, and I could hear music coming from the inside. I did not dare go inside, but, right by the entrance I found a pair of shoes. They were brown and looked well-worn, but something in my mind told me to try them on. I removed the tattered sandals I was wearing and put those shoes on. As soon as I did, I felt lighter, as if I was not standing up by myself but some other unexplained force was lifting me. That made me happy. I only wanted the shoes to look a bit better, not brown and all worn down. When that thought crossed my mind, the shoes changed. Now they were sparkly green boots with red trimmings and golden shoelaces. I loved them and decided to keep them.

      As for the cave, I decided to walk by. Maybe I can revisit it some other time.
    ]
    place(bottom + right, dy: 0.1in, box(width: 1.5in,
      image(asset("doodles/volcano.jpg"), width: 100%)))
  }
)

// --- Atomic section chunks (composed differently per edition) -------------------

#let sec-solo = {
  title[Solo vs Group Play]
  v(4pt)
  two-col(
    {
      subhead[Solo Play]
      blist(
        [Remove the #pp cards from the game.],
        [Focus on deep personal reflection.],
        [Take as much time as you need.],
        [Use journaling extensively.],
        [Create your own pacing.],
        [Return to previous sessions.],
      )
    },
    {
      subhead[Group Play]
      blist(
        [Share reflections with others.],
        [Learn from different perspectives.],
        [Build collective narratives.],
        [Support each other's growth.],
        [Create shared memories.],
      )
    },
  )
  place(bottom + center, dy: 0.05in, image(asset("meeples.jpg"), width: 3.2in))
}

#let sec-advanced = {
  title[Advanced Concepts]
  subhead[Session Endings]
  p[It's recommended to end the session when the fifth #bl card is picked. Each player can add a final entry to their journal, or just leave it as it is.]
  p[However, if all players agree you can end the session after any number of #bl cards are picked, or disregard the #bl cards and use a timer, etc.]
  subhead[Returning to Previous Sessions]
  [JOURNEYWAYS is designed for ongoing play. Return to previous sessions, revisit old insights, and see how your understanding has evolved. Your character and story continue to develop between sessions.]
}

#let sec-creating-own = {
  subhead[Creating Your Own Elements]
  [Feel free to add your own story cards, character elements, or game mechanics. JOURNEYWAYS is a framework for exploration; make it your own.]
}

#let sec-tips = {
  title[Tips for Meaningful Play]
  v(4pt)
  two-col(
    {
      subhead[Creating Safe Space]
      blist(
        [Set aside dedicated time.],
        [Minimize distractions.],
        [Create a comfortable environment.],
        [Honor everyone's privacy.],
        [Practice active listening.],
      )
    },
    {
      subhead[Deepening the Experience]
      blist(
        [Ask open-ended questions.],
        [Embrace uncertainty.],
        [Allow for silence and reflection.],
        [Be curious, not judgmental.],
        [Celebrate small discoveries.],
      )
    },
  )
  place(bottom + left, dy: 0.1in, doodle-note("field", [room to wander]))
}

#let sec-notes = {
  title[Notes]
  align(center, text(font: "Inter", size: 10.5pt, style: "italic", fill: c-mut,
    [For your thoughts, sketches, and discoveries.]))
  v(0.28in)
  for _ in range(11) {
    line(length: 100%, stroke: 0.6pt + c-ink.lighten(15%))
    v(0.44in)
  }
}

// Website / QR codes (last page, unnumbered like the booklet's back cover).
#let leaf-web = frame(
  {
    v(0.5in)
    align(center, text(font: "Italianno", size: 58pt, fill: c-orange, [Journeyways]))
    v(0.04in)
    align(center, text(font: "Inter", style: "italic", size: 16pt, fill: c-ink, [A game about becoming.]))
    v(0.25in)
    align(center, text(font: "Italianno", size: 36pt, fill: c-orange, [Website]))
    v(0.18in)
    align(center, image(asset("qr-website.png"), width: 2.8in))
    v(0.14in)
    align(center, text(font: "Inter", size: 12pt, fill: c-ink, [www.journeyways.ca]))
    v(0.5in)
    align(center, text(font: "Inter", size: 9pt, fill: c-mut,
      [© 2025-2026 Adri M. Licensed under CC BY-NC 4.0.]))
  }
)

// --- The edition ---------------------------------------------------------------

// Single square reading manual. Generous one-topic-per-page pagination (the
// former imposed 2-up booklet was retired). Folios: TOC 1, Setup 2, Basic
// Gameplay 3, Ending 4, Journal 5, Journal example 6, Solo/Group 7, Advanced 8,
// Tips 9, Notes 10; cover, title, and the closing website page are unnumbered.
#let manual-leaves = (
  leaf-cover,
  leaf-title,
  leaf-toc,
  leaf-setup,
  leaf-gameplay,
  leaf-ending,
  leaf-journal,
  leaf-journal-example,
  frame(num: 7, left-num: true, sec-solo),
  frame(num: 8, left-num: false, {
    sec-advanced
    v(0.3in)
    grid(columns: (1fr, 1.7in), column-gutter: 22pt,
      sec-creating-own,
      align(center + horizon, doodle-note("house", [return here], w: 1.45in)),
    )
  }),
  frame(num: 9, left-num: true, sec-tips),
  frame(num: 10, left-num: false, sec-notes),
  leaf-web,
)
