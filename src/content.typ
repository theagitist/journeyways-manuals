// JOURNEYWAYS Game Rules - shared content module.
// One source of truth for both the 1-up reading manual and the 2-up imposed booklet.
// Each leaf is a fixed half-letter (5.5in x 8.5in) page block, so two sit 1:1 on a
// landscape letter sheet with no scaling.
//
// Typography mirrors the web/play brand: Italianno (display script) + Inter (body).
// Content reproduces JOURNEYWAYS_Game_Rules.pdf (c) 2025 Adri M., CC BY-NC 4.0.

#let leaf-w = 5.5in
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
// Big centered script section title.
#let title(body) = align(center, text(font: "Italianno", size: 44pt, fill: c-orange, body))
// Left-aligned script subsection heading.
#let subhead(body) = block(above: 12pt, below: 6pt,
  text(font: "Italianno", size: 25pt, fill: c-orange, body))
// Small bold orange label (1. Explore ...).
#let label-b(body) = block(above: 8pt, below: 2pt,
  text(font: "Inter", weight: "bold", size: 10.5pt, fill: c-orange, body))
// Coloured card word.
#let card(name, col) = text(fill: col, weight: "bold", name)
#let g = card("Green", c-green)
#let bl = card("Black", c-mut)
#let blu = card("Blue", c-blue)
#let rd = card("Red", c-red)
#let pp = card("Purple", c-purple)

#let body-set(body) = {
  set text(font: "Inter", size: 10pt, fill: c-ink)
  set par(leading: 0.66em, spacing: 0.9em, justify: false)
  body
}

// Paragraph: a block so consecutive body paragraphs space apart in code mode
// (bare [..] blocks would otherwise concatenate with no break).
#let p(body) = block(below: 0.75em, width: 100%, body)

// Bulleted / numbered lists tuned to the source spacing.
#let blist(..items) = list(indent: 6pt, spacing: 0.55em, ..items)
#let nlist(..items) = enum(indent: 6pt, spacing: 0.6em, ..items)

// --- Page frame ----------------------------------------------------------------
// A framed content leaf: faint swirl, running head, footer with outer page number.
// `num`: printed page number (none on the front matter). `left-num`: number corner.
#let frame(num: none, left-num: false, body) = box(
  width: leaf-w, height: leaf-h, clip: true,
  {
    // faint decorative swirl, bleeding off the top-right corner
    place(top + right, dx: 0.35in, dy: -0.25in,
      image(asset("swirl.png"), width: 4.2in))
    // running head
    place(top + center, dy: 0.34in,
      text(font: "Inter", size: 8pt, fill: c-ink,
        [© 2025 JOURNEYWAYS. A board game about becoming.]))
    // body column
    place(top + left, dx: 0.55in, dy: 0.7in,
      box(width: leaf-w - 1.1in, height: leaf-h - 1.5in, body-set(body)))
    // footer
    place(bottom + center, dy: -0.32in,
      text(font: "Inter", size: 8.5pt, style: "italic", fill: c-mut,
        [This is a prototype and work in progress. All content is subject to change.]))
    if num != none {
      place(bottom + (if left-num { left } else { right }),
        dx: (if left-num { 0.55in } else { -0.55in }), dy: -0.3in,
        text(font: "Inter", size: 9.5pt, fill: c-mut, str(num)))
    }
  }
)

// --- The leaves (reading order) ------------------------------------------------

// 1. Cover: full-bleed art.
#let leaf-cover = box(width: leaf-w, height: leaf-h, clip: true,
  image(asset("cover.png"), width: leaf-w, height: leaf-h, fit: "cover"))

// 2. Title / intro (front matter, unnumbered).
#let leaf-title = frame(
  {
    v(0.35in)
    align(center, text(font: "Italianno", size: 42pt, fill: c-orange, [JOURNEYWAYS]))
    align(center, text(font: "Italianno", size: 30pt, fill: c-orange, [Game Rules]))
    v(0.3in)
    set text(font: "Inter", size: 10.5pt, fill: c-ink)
    set par(leading: 0.62em, spacing: 1.0em)
    align(center, [
      Step into a world where identity is not chosen but uncovered.

      In JOURNEYWAYS, you don't play to win; you play to unfold.

      Explore selfhood not with labels, but with motion, memory, and meaning.

      Whether solo or in chorus, each session reveals a story made only by your presence.

      #text(weight: "bold")[With no fixed roles and no final answers, JOURNEYWAYS invites you to]

      co-create the story of who you are and who you are becoming.
    ])
    v(0.25in)
    align(center, text(style: "italic", [This manual will help you learn how to begin your journey of becoming.]))
  }
)

// 3. Table of Contents (printed 1).
#let toc-line(l, p, indent: 0pt, bold: false, serif: false) = {
  set text(font: (if serif { "Inter" } else { "Inter" }),
    weight: (if bold { "bold" } else { "regular" }),
    style: (if serif { "italic" } else { "normal" }),
    size: (if bold { 11pt } else { 9pt }),
    fill: c-ink)
  box(width: 100%, inset: (left: indent))[
    #l #box(width: 1fr, repeat[.]) #p
  ]
  v(if bold { 0.35em } else { 0.15em })
}
#let leaf-toc = frame(num: 1, left-num: true,
  {
    title[Table of Contents]
    v(0.2in)
    toc-line("Game Setup", "2", bold: true)
    toc-line("What You'll Need", "2", indent: 14pt, serif: true)
    toc-line("Initial Setup", "2", indent: 14pt, serif: true)
    toc-line("Basic Gameplay", "3", bold: true)
    toc-line("Turn Structure", "3", indent: 14pt, serif: true)
    toc-line("1. Explore", "3", indent: 28pt, serif: true)
    toc-line("2. Draw", "3", indent: 28pt, serif: true)
    toc-line("3. Reflect", "3", indent: 28pt, serif: true)
    toc-line("Ending the game", "3", indent: 14pt, serif: true)
    toc-line("Writing your journal", "4", bold: true)
    toc-line("Solo vs Group Play", "5", bold: true)
    toc-line("Solo Play", "5", indent: 14pt, serif: true)
    toc-line("Group Play", "5", indent: 14pt, serif: true)
    toc-line("Advanced Concepts", "5", bold: true)
    toc-line("Session Endings", "5", indent: 14pt, serif: true)
    toc-line("Returning to Previous Sessions", "5", indent: 14pt, serif: true)
    toc-line("Creating Your Own Elements", "6", indent: 14pt, serif: true)
    toc-line("Tips for Meaningful Play", "6", bold: true)
    toc-line("Creating Safe Space", "6", indent: 14pt, serif: true)
    toc-line("Deepening the Experience", "6", indent: 14pt, serif: true)
  }
)

// 4. Game Setup (printed 2).
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
    subhead[Initial Setup]
    nlist(
      [Shuffle all cards together and place them face dawn in three draw piles.],
      [Draw one card and place it apart face up. This will be the Discard pile.],
      [Find the Starter board tile and set it apart. Shuffle all others and place them face down in three piles.],
      [Each player takes one player token.],
      [Use the die to determine the starting player. For example, highest number goes first.],
      [Place the Starter board tile in the center of the table.],
      [Taking turns, each player draws a tile fom any pile and places it adjacent to another previously placed tile. If it's a blank tile, put it back in the pile and draw again.],
      [All players place their tokens on the Starter tile.],
    )
  }
)

// 5. Basic Gameplay (printed 3).
#let leaf-gameplay = frame(num: 3, left-num: true,
  {
    title[Basic Gameplay]
    subhead[Turn Structure]
    [Each turn consists of three phases: Explore, Draw, and Reflect.]
    label-b[1. Explore]
    [For Exploration, you have two options: (1) Draw a map tile and place it adjacent to another one. If you draw a blank tile, you have to create it before placing it.(2) Use a sticky note to draw a new map tile (whatever you want) and place it on top of an existing one where no player is located. After you place your tile, you can move one or two spaces in any direction.]
    label-b[2. Draw]
    [Draw a card from any pile, even the Discard pile. #g cards are movement, #bl cards are pass of time, #blu cards are quotes, #rd cards are encounters, #pp cards are group events.]
    label-b[3. Reflect]
    [If you drew a #g or #pp card, you have to perform the action it indicates. If you drew a #blu or #rd card, take into account what they say, and write a new entry in your journal. If you drew a #bl card, set it apart. The game ends when the fifth #bl card is drawn.]
    subhead[Ending the game]
    p[The game ends when the fifth #bl card is drawn. Each player can add a final entry to their journal, or just leave it as it is. However, if all players agree you can end the session after any amount of #bl cards are drawn, or disregard the #bl cards and use a timer, etc.]
    p[It is ok if your story ends abruptly. You can leave it like that, or return to it on another session.]
    p[After ending the game, each player can fill their Character Sheet at the end of the Player Booklet. This way they can see how their character developed during the game; what changed, and what stayed the same.]
    p[Remember: The game is not about winning or losing. It is about discovering, exploring, and becoming.]
  }
)

// 6. Writing your journal (printed 4).
#let leaf-journal = frame(num: 4, left-num: false,
  {
    title[Writing your journal]
    v(0.15in)
    p[Unlike traditional games, your character in JOURNEYWAYS emerges through play rather than being predetermined.]
    p[Use the game cards as inspiration, not rigid definitions; the main objective is you set your imagination free and write the story you want to tell. Journal entries can be as short or as long, as terse or as detailed as you want.]
    p[You can get inspiration from the tile where your token is located and the text in the card, but you can be as creative as you want. You can write a journal entry, doodle it, or do whatever you like.]
    v(0.1in)
    p[Here is an example of a possible journal entry:]
    v(0.12in)
    text(font: "Italianno", size: 18pt, fill: c-ink)[
      It was a warm summer evening when I stumbled upon a cave entrance. There was a soft breeze, and I could hear music coming from the inside. I did not dare go inside, but, right by the entrance I found a pair of shoes. They were brown and looked well-worn, but something in my mind told me to try them on. I removed the tattered sandals I was wearing and put those shoes on. As soon as I did, I felt lighter, as if I was not standing up by myself but some other unexplained force was lifting me. That made me happy. I only wanted the shoes to look a bit better, not brown and all worn down. When that thought crossed my mind, the shoes changed. Now they were sparkly green boots with red trimmings and golden shoelaces. I loved them and decided to keep them.

      As for the cave, I decided to walk by. Maybe I can revisit it some other time.
    ]
  }
)

// 7. Solo vs Group Play / Advanced Concepts (printed 5).
#let leaf-solo = frame(num: 5, left-num: true,
  {
    title[Solo vs Group Play]
    subhead[Solo Play]
    blist(
      [Remove the #pp cards from the game.],
      [Focus on deep personal reflection.],
      [Take as much time as you need.],
      [Use journaling extensively.],
      [Create your own pacing.],
      [Return to previous sessions.],
    )
    subhead[Group Play]
    blist(
      [Share reflections with others.],
      [Learn from different perspectives.],
      [Build collective narratives.],
      [Support each other's growth.],
      [Create shared memories.],
    )
    v(0.15in)
    title[Advanced Concepts]
    subhead[Session Endings]
    p[It's recommended to end the session when the fifth #bl card is drawn. Each player can add a final entry to their journal, or just leave it as it is.]
    p[However, if all players agree you can end the session after any amount of #bl cards are drawn, or disregard the #bl cards and use a timer, etc.]
    subhead[Returning to Previous Sessions]
    [JOURNEYWAYS is designed for ongoing play. Return to previous sessions, revisit old insights, and see how your understanding has evolved. Your character and story continue to develop between sessions.]
  }
)

// 8. Creating Your Own Elements / Tips for Meaningful Play (printed 6).
#let leaf-tips = frame(num: 6, left-num: false,
  {
    subhead[Creating Your Own Elements]
    [Feel free to add your own story cards, character elements, or game mechanics. JOURNEYWAYS is a framework for exploration; make it your own.]
    v(0.35in)
    title[Tips for Meaningful Play]
    subhead[Creating Safe Space]
    blist(
      [Set aside dedicated time.],
      [Minimize distractions.],
      [Create a comfortable environment.],
      [Honor everyone's privacy.],
      [Practice active listening.],
    )
    subhead[Deepening the Experience]
    blist(
      [Ask open-ended questions.],
      [Embrace uncertainty.],
      [Allow for silence and reflection.],
      [Be curious, not judgmental.],
      [Celebrate small discoveries.],
    )
  }
)

// 9. Notes (printed 7).
#let leaf-notes = frame(num: 7, left-num: true,
  {
    title[Notes]
    v(0.3in)
    // ruled lines
    for _ in range(22) {
      line(length: 100%, stroke: 0.6pt + c-ink)
      v(0.34in)
    }
  }
)

// 10. Website / QR codes (printed 8).
#let leaf-web = frame(num: 8, left-num: false,
  {
    v(0.1in)
    align(center, text(font: "Italianno", size: 46pt, fill: c-orange, [Journeyways]))
    v(0.02in)
    align(center, text(font: "Inter", style: "italic", size: 14pt, fill: c-ink, [A game about becoming.]))
    v(0.12in)
    align(center, text(font: "Italianno", size: 30pt, fill: c-orange, [Website]))
    v(0.06in)
    align(center, image(asset("qr-website.png"), width: 1.85in))
    v(0.18in)
    grid(columns: (1fr, 1fr), column-gutter: 0.3in,
      align(center, {
        text(font: "Italianno", size: 17pt, fill: c-orange, [Online Game Rules (updated)])
        v(0.04in)
        image(asset("qr-rules.png"), width: 1.3in)
      }),
      align(center, {
        text(font: "Italianno", size: 17pt, fill: c-orange, [Adri M. Instagram])
        v(0.04in)
        image(asset("qr-instagram.png"), width: 1.3in)
      }),
    )
  }
)

// Reading order (10 leaves). Front matter (cover, title) then printed 1..8.
#let leaves = (
  leaf-cover, leaf-title, leaf-toc, leaf-setup, leaf-gameplay,
  leaf-journal, leaf-solo, leaf-tips, leaf-notes, leaf-web,
)
