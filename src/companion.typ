// JOURNEYWAYS Card Companion: every card in English, Spanish and French, side by
// side, with room for notes. Download-and-print, like the player booklet; it
// lets a table play the English printed deck in its own language.
// Card text, titles, authors and art come from the play export
// (assets/cards/cards.json, via build-cards.sh --export); never type them here.
// Deck names come from decks.json. Same 8x10 trim and design system as the rules.
// Thumbnails are small JPEGs made by build.sh in assets/card-thumbs/ (the full
// webp art would make a 36 MB PDF).
// (c) 2025-2026 Adri M., CC BY-NC 4.0.

#import "content.typ": *

#let data = json(asset("cards/cards.json"))
#let decks = json(asset("cards/decks.json"))
#let langs = ("en", "es", "fr")
#let lang-label = (en: "English", es: "Español", fr: "Français")
#let chip-of = (encounter: "red", movement: "green", reflection: "blue", countdown: "black", group: "purple")

#set page(width: leaf-w, height: leaf-h,
  margin: (x: 0.7in, top: 0.65in, bottom: 0.85in),
  footer: context {
    let n = counter(page).get().first()
    // Covers and the intro page carry no folio.
    if n > 2 and n < counter(page).final().first() {
      set text(font: "Nunito", size: 9pt, fill: c-mut)
      grid(columns: (1fr, 1fr),
        align(left)[JOURNEYWAYS · Card Companion],
        align(right, str(n - 2)))
    }
  })
#set text(font: "Nunito", size: 9.5pt, fill: c-ink)
#set par(leading: 0.55em, spacing: 0.7em)

// --- Cover ---------------------------------------------------------------------
#page(margin: 0pt, footer: none, box(width: leaf-w, height: leaf-h, fill: paper, {
  place(top + center, dy: leaf-h * 0.06, image(asset("logo-mark.png"), width: leaf-w * 0.6))
  place(top + center, dy: leaf-h * 0.64,
    text(font: "Italianno", size: 92pt, fill: c-orange, [Journeyways]))
  place(top + center, dy: leaf-h * 0.81, align(center, {
    text(font: "Nunito", weight: "bold", style: "italic", size: 18pt, fill: c-ink, [Card Companion])
    v(4pt)
    text(font: "Nunito", style: "italic", size: 13pt, fill: c-mut,
      [Compañero de cartas · Compagnon des cartes])
  }))
}))

// --- How to use (all three languages) ------------------------------------------
#{
  title[Card Companion]
  set text(size: 10.5pt)
  set par(leading: 0.65em)
  let intro(head, body) = block(above: 14pt, {
    text(font: "Italianno", size: 26pt, fill: c-orange, head)
    linebreak()
    body
  })
  intro[English][Every JOURNEYWAYS card, in English, Spanish and French. Find a card by the number printed in its bottom-right corner (R for the red cards, G for green, B for blue, K for black, P for purple). Each card has space for your own notes: a new reading, a version you changed, or a memory from a game.]
  intro[Español][Todas las cartas de JOURNEYWAYS, en inglés, español y francés. Busca una carta por el número impreso en su esquina inferior derecha (R para las cartas rojas, G para las verdes, B para las azules, K para las negras, P para las moradas). Cada carta tiene espacio para tus notas: una nueva lectura, una versión que cambiaste o un recuerdo de una partida.]
  intro[Français][Toutes les cartes de JOURNEYWAYS, en anglais, en espagnol et en français. Retrouve une carte grâce au numéro imprimé dans son coin inférieur droit (R pour les cartes rouges, G pour les vertes, B pour les bleues, K pour les noires, P pour les violettes). Chaque carte a un espace pour tes notes : une nouvelle lecture, une version que tu as changée ou un souvenir de partie.]
  v(0.3in)
  align(center, grid(columns: 5, column-gutter: 14pt, row-gutter: 6pt,
    ..data.decks.map(d => align(center, chip(chip-of.at(d.slug)))),
    ..data.decks.map(d => align(center, text(size: 8.5pt, fill: c-mut,
      langs.map(l => decks.at(l).at(d.slug).name).join(linebreak()))))))
}

// --- Cards ---------------------------------------------------------------------
#let thumb(c) = box(width: 1.05in, height: 0.77in, radius: 4pt, clip: true,
  stroke: 0.5pt + c-mut.lighten(40%),
  if c.art != none { image(asset("card-thumbs/" + c.art.replace(".webp", ".jpg")), width: 100%, height: 100%, fit: "cover") }
  else { image(asset("chips/" + chip-of.at(c.deck) + ".jpg"), width: 100%, height: 100%, fit: "cover") })

#let card-entry(c) = block(breakable: false, width: 100%, above: 0pt, below: 26pt, {
  let col = rgb(c.color)
  grid(columns: (1.05in, 1fr), column-gutter: 12pt,
    {
      thumb(c)
      v(3pt)
      align(center, text(size: 15pt, weight: "bold", fill: col, c.number))
      if c.count > 1 { align(center, text(size: 8pt, fill: c-mut)[× #str(c.count)]) }
    },
    {
      if c.title.en != "" {
        text(size: 11pt, weight: "bold", langs.map(l => c.title.at(l)).dedup().join(" · "))
        v(2pt)
      }
      grid(columns: (1fr, 1fr, 1fr), column-gutter: 11pt,
        ..langs.map(l => {
          text(size: 7pt, weight: "bold", fill: col, upper(lang-label.at(l)))
          linebreak()
          c.content.at(l)
        }))
      if c.author != none { v(3pt); align(right, text(size: 8.5pt, style: "italic", fill: c-mut, c.author)) }
    })
  // Notes: three ruled lines.
  v(4pt)
  text(size: 7pt, weight: "bold", fill: c-mut)[NOTES · NOTAS · NOTES]
  for _ in range(3) { v(0.24in); line(length: 100%, stroke: 0.5pt + c-mut.lighten(45%)) }
})

#for d in data.decks {
  pagebreak()
  block(below: 14pt, grid(columns: (0.5in, 1fr), column-gutter: 10pt, align: horizon,
    box(width: 0.5in, height: 0.5in, radius: 4pt, clip: true,
      image(asset("chips/" + chip-of.at(d.slug) + ".jpg"), width: 100%, height: 100%, fit: "cover")),
    {
      text(font: "Italianno", size: 32pt, fill: c-orange,
        langs.map(l => decks.at(l).at(d.slug).name).dedup().join(" · "))
      linebreak()
      text(size: 9pt, fill: c-mut, langs.map(l => decks.at(l).at(d.slug).colour).dedup().join(" · "))
    }))
  for c in data.cards.filter(c => c.deck == d.slug) { card-entry(c) }
}

// --- Back cover ----------------------------------------------------------------
#page(margin: 0pt, footer: none, leaf-web)
