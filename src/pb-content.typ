// JOURNEYWAYS Player Booklet - content module.
// Reproduces "Journeyways character sheet 1.1.pdf" (the Player Booklet): cover,
// intro, a fill-in Character Sheet, 12 lined journal pages, and a back cover.
// Art-heavy pages (journal) are placed as faithful full-page renders; text pages
// (cover, intro, character sheet, back cover) are rebuilt with the brand fonts
// (Italianno + Inter). The booklet is monochrome (black script headings).
//
// Localized en / es / fr via the shared `t()` picker (see i18n.typ); one layout,
// three languages, no duplication.
// Content (c) 2025-2026 Adri M., CC BY-NC 4.0.

#import "i18n.typ": lang, t

// Letter-proportioned leaf matching the source trim (695.25 x 900 pt ~= 0.773).
#let pbw = 5.5in
#let pbh = 7.12in

#let c-ink = rgb("#1A1A1A")
#let c-mut = rgb("#555555")
#let c-boxln = rgb("#333333")
#let c-boxfill = rgb("#F4F4F2")

#let pba(p) = "../assets/player-booklet/" + p

// Full-page image leaf (journal pages) - faithful render, full bleed.
#let img-leaf(path) = box(width: pbw, height: pbh, clip: true,
  image(pba(path), width: pbw, height: pbh, fit: "cover"))

// Rebuilt page: faint watercolour wash background + optional content margin.
#let pb-frame(pad: 0.5in, body) = box(width: pbw, height: pbh, clip: true, {
  place(top + left, image(pba("art/wash-faint.png"), width: pbw, height: pbh, fit: "cover"))
  place(top + left, dx: pad, dy: pad, box(width: pbw - 2 * pad, height: pbh - 2 * pad, body))
})

#let script(size, body) = text(font: "Italianno", size: size, fill: c-ink, body)
#let tagline = text(font: "Inter", weight: "bold", size: 9pt, fill: c-ink, tracking: 0.02em,
  t(en: [A BOARD GAME ABOUT BECOMING.],
    es: [UN JUEGO DE MESA SOBRE EL DEVENIR.],
    fr: [UN JEU DE SOCIÉTÉ SUR LE DEVENIR.]))

// --- Leaves --------------------------------------------------------------------

// 1. Cover - rebuilt in Typst so the tagline and label are live localized text.
// The stylized JOURNEYWAYS wordmark stays baked into the (grayscale) art as the
// brandmark; only the tagline and the "Player Booklet" label are translated.
#let pb-cover = box(width: pbw, height: pbh, clip: true, {
  place(top + left, image(pba("art/wash-faint.png"), width: pbw, height: pbh, fit: "cover"))
  let m = 0.35in
  let side = pbw - 2 * m
  place(top + center, dy: m, box(width: side, height: side, radius: 10pt, clip: true,
    stroke: 1pt + c-mut.lighten(30%), {
      image(pba("pages/cover-bg.jpg"), width: side, height: side, fit: "cover")
      // localized tagline over the light chest, below the wordmark
      place(top + center, dy: side * 0.60,
        text(font: "Inter", weight: "bold", size: 10.5pt, fill: c-ink, tracking: 0.02em,
          t(en: [A BOARD GAME ABOUT BECOMING], es: [UN JUEGO DE MESA SOBRE EL DEVENIR], fr: [UN JEU DE SOCIÉTÉ SUR LE DEVENIR])))
      // swirl ornament, echoing the source cover
      place(top + center, dy: side * 0.70, image(pba("art/swirl.png"), width: side * 0.34))
    }))
  // localized booklet label below the panel
  place(bottom + center, dy: -0.5in,
    script(46pt, t(en: [Player Booklet], es: [Cuaderno de juego], fr: [Cahier de jeu])))
})

// 2. Intro + quick guide. Black and white; a short lead, then a handy reference.
// Compact enough that the longer es/fr text still clears the page number.
#let qh(body) = block(above: 8pt, below: 5pt,
  text(font: "Inter", weight: "bold", size: 10pt, fill: c-ink, body))
#let pb-intro = pb-frame(pad: 0.5in, {
  script(44pt, [Journeyways])
  v(-4pt)
  tagline
  v(9pt)
  block(width: 100%, text(font: "Inter", size: 11pt, style: "italic", fill: c-ink,
    t(en: [
      Step into a world where identity is not chosen but uncovered. In Journeyways,
      you don't play to win; you play to unfold.
    ],
    es: [
      Entra en un mundo donde la identidad no se elige, sino que se descubre. En
      Journeyways no juegas para ganar; juegas para desplegarte.
    ],
    fr: [
      Entre dans un monde où l'identité n'est pas choisie mais dévoilée. Dans
      Journeyways, tu ne joues pas pour gagner ; tu joues pour te déployer.
    ])))
  v(6pt)
  script(28pt, t(en: [Quick Reference], es: [Referencia rápida], fr: [Aide-mémoire]))
  v(7pt)
  set text(font: "Inter", size: 9pt, fill: c-ink)
  set par(leading: 0.48em, spacing: 0.48em)
  set list(indent: 4pt, spacing: 0.46em, marker: [•])

  qh(t(en: [Each turn has three phases: Explore, Pick, Reflect.],
    es: [Cada turno tiene tres fases: Explorar, Elegir, Reflexionar.],
    fr: [Chaque tour a trois phases : Explorer, Choisir, Réfléchir.]))
  list(
    t(en: [*Explore:* place a map tile (or invent one on a sticky note), then move one or two spaces.],
      es: [*Explorar:* coloca una loseta del mapa (o inventa una en una nota adhesiva) y muévete uno o dos espacios.],
      fr: [*Explorer :* place une tuile de carte (ou invente-en une sur une note autocollante), puis déplace-toi d'une ou deux cases.]),
    t(en: [*Pick:* take a card from any pile, even the Discard pile.],
      es: [*Elegir:* toma una carta de cualquier montón, incluso del de descarte.],
      fr: [*Choisir :* prends une carte dans n'importe quelle pile, même la pile de défausse.]),
    t(en: [*Reflect:* do what the card asks, then write in your journal.],
      es: [*Reflexionar:* haz lo que pide la carta y luego escribe en tu diario.],
      fr: [*Réfléchir :* fais ce que la carte demande, puis écris dans ton journal.]),
  )

  qh(t(en: [What the card colours mean],
    es: [Qué significan los colores de las cartas],
    fr: [Ce que veulent dire les couleurs des cartes]))
  list(
    t(en: [*Green:* movement.], es: [*Verde:* movimiento.], fr: [*Verte :* déplacement.]),
    t(en: [*Blue:* a quote to reflect on.], es: [*Azul:* una cita para reflexionar.], fr: [*Bleue :* une citation à méditer.]),
    t(en: [*Red:* an encounter.], es: [*Roja:* un encuentro.], fr: [*Rouge :* une rencontre.]),
    t(en: [*Purple:* a group event (leave these out for solo play).],
      es: [*Morada:* un evento de grupo (retírala en el juego en solitario).],
      fr: [*Violette :* un événement de groupe (à retirer en solo).]),
    t(en: [*Black:* the passing of time. The game ends when the fifth Black card is picked.],
      es: [*Negra:* el paso del tiempo. El juego termina cuando se elige la quinta carta Negra.],
      fr: [*Noire :* le passage du temps. La partie se termine quand la cinquième carte Noire est choisie.]),
  )

  qh(t(en: [Good to know], es: [Bueno saber], fr: [Bon à savoir]))
  list(
    t(en: [*Green* and *Purple* ask you to perform the action shown; *Blue* and *Red* invite a journal entry.],
      es: [*Verde* y *Morada* te piden realizar la acción indicada; *Azul* y *Roja* invitan a una entrada de diario.],
      fr: [*Verte* et *Violette* te demandent d'accomplir l'action indiquée ; *Bleue* et *Rouge* invitent à une entrée de journal.]),
    t(en: [There is no winning or losing, only becoming. Take as much time as you need.],
      es: [No se gana ni se pierde, solo se deviene. Tómate todo el tiempo que necesites.],
      fr: [On ne gagne ni ne perd, on devient, tout simplement. Prends tout le temps qu'il te faut.]),
    t(en: [Turns are not strict: play when you have the opportunity to do so.],
      es: [Los turnos no son estrictos: juega cuando tengas ocasión.],
      fr: [Les tours ne sont pas stricts : joue quand l'occasion se présente.]),
    t(en: [Any rule can be bent or changed, as long as everyone playing agrees.],
      es: [Cualquier regla puede adaptarse o cambiarse, siempre que todas las personas que juegan estén de acuerdo.],
      fr: [Toute règle peut être adaptée ou modifiée, tant que toutes les personnes qui jouent sont d'accord.]),
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
        script(30pt, t(en: [Character Sheet], es: [Hoja de Personaje], fr: [Fiche de Personnage]))
        v(20pt)
        prompt(t(en: [Where do I come from?], es: [¿De dónde vengo?], fr: [D'où est-ce que je viens ?]))
        cbox(0.62in)
        prompt(t(en: [Where am I now?], es: [¿Dónde estoy ahora?], fr: [Où suis-je maintenant ?]))
        cbox(0.62in)
        prompt(t(en: [What/who am I?], es: [¿Qué/quién soy?], fr: [Qu'est-ce que je suis, qui suis-je ?]))
        cbox(0.62in)
        prompt(t(en: [Why?], es: [¿Por qué?], fr: [Pourquoi ?]))
        cbox(0.62in)
      },
      {
        script(30pt, [Journeyways])
        v(20pt)
        prompt(t(en: [What do I look like?], es: [¿Qué aspecto tengo?], fr: [À quoi est-ce que je ressemble ?]))
        cbox(2.35in)
        prompt(t(en: [What's my name?], es: [¿Cómo me llamo?], fr: [Quel est mon nom ?]))
        cbox(0.62in)
      },
    )
    v(10pt)
    prompt(t(en: [What's my goal, what am I here to do, what's my nature?],
      es: [¿Cuál es mi meta, qué vengo a hacer, cuál es mi naturaleza?],
      fr: [Quel est mon but, qu'est-ce que je viens faire, quelle est ma nature ?]))
    cbox(1.15in)
  }))
})

// Second Character Sheet (the "after", filled at the end to compare how the
// character evolved). Distinct fields from the first sheet.
#let pb-charsheet-2 = box(width: pbw, height: pbh, clip: true, {
  place(top + left, image(pba("art/wash-faint.png"), width: pbw, height: pbh, fit: "cover"))
  place(top + left, dx: pbw - 2.7in, dy: 0.5in, image(pba("art/swirl-faint.png"), width: 2.4in))
  place(top + left, dx: 0.4in, dy: 0.4in, box(width: pbw - 0.8in, height: pbh - 0.8in, {
    // Both columns share the same structure (heading + three prompt/box pairs)
    // and equal box totals (2.34in), so the columns bottom-align exactly, the
    // way the first sheet does.
    grid(columns: (1fr, 1fr), column-gutter: 14pt,
      {
        script(30pt, t(en: [Character Sheet], es: [Hoja de Personaje], fr: [Fiche de Personnage]))
        v(20pt)
        prompt(t(en: [Where am I now?], es: [¿Dónde estoy ahora?], fr: [Où suis-je maintenant ?]))
        cbox(0.62in)
        prompt(t(en: [What/who am I now?], es: [¿Qué/quién soy ahora?], fr: [Qu'est-ce que je suis, qui suis-je maintenant ?]))
        cbox(0.62in)
        prompt(t(en: [What changed?], es: [¿Qué cambió?], fr: [Qu'est-ce qui a changé ?]))
        cbox(1.1in)
      },
      {
        script(30pt, [Journeyways])
        v(20pt)
        prompt(t(en: [What do I look like now?], es: [¿Qué aspecto tengo ahora?], fr: [À quoi est-ce que je ressemble maintenant ?]))
        cbox(1.34in)
        prompt(t(en: [What's my name?], es: [¿Cómo me llamo?], fr: [Quel est mon nom ?]))
        cbox(0.5in)
        prompt(t(en: [What's my story title?], es: [¿Cuál es el título de mi historia?], fr: [Quel est le titre de mon histoire ?]))
        cbox(0.5in)
      },
    )
    v(9pt)
    prompt(t(en: [What is one word that stays with me?],
      es: [¿Qué palabra se queda conmigo?], fr: [Quel mot reste avec moi ?]))
    cbox(0.34in)
    prompt(t(en: [What is one question that stays with me?],
      es: [¿Qué pregunta se queda conmigo?], fr: [Quelle question reste avec moi ?]))
    cbox(0.34in)
    prompt(t(en: [What is one place in the map I would like to revisit?],
      es: [¿Qué lugar del mapa me gustaría volver a visitar?], fr: [Quel lieu de la carte aimerais-je revisiter ?]))
    cbox(0.34in)
  }))
})

// Journal pages: rebuilt in Typst. Faint wash + swirl background with an
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
#let pb-journal = range(11).map(i => pb-journal-page(i))

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
    text(font: "Inter", size: 9pt, style: "italic", fill: c-mut,
      t(en: [
        © 2025-2026 Adri M. Licensed under CC BY-NC 4.0. \
        https://www.journeyways.ca
      ],
      es: [
        © 2025-2026 Adri M. Con licencia CC BY-NC 4.0. \
        https://www.journeyways.ca
      ],
      fr: [
        © 2025-2026 Adri M. Sous licence CC BY-NC 4.0. \
        https://www.journeyways.ca
      ]))))
})

// Reading order (16): cover, intro, first character sheet, 11 journal pages, the
// second (after) character sheet second-to-last, back cover last.
#let pb-raw = (
  pb-cover,
  pb-intro,
  pb-charsheet,
  ..pb-journal,
  pb-charsheet-2,
  pb-back,
)

// Page numbers: the cover (leaf 0) and back cover (last leaf) stay unnumbered;
// the intro is "1" and numbering runs through the second-to-last leaf. Baked
// into the leaf so both the 1-up and the imposed 2-up carry correct numbers.
#let stamp-num(n, leaf) = box(width: pbw, height: pbh, clip: true, {
  leaf
  place(bottom + center, dy: -0.3in,
    text(font: "Inter", size: 9pt, fill: c-mut, str(n)))
})
#let pb-leaves = pb-raw.enumerate().map(((i, leaf)) => {
  if i >= 1 and i <= pb-raw.len() - 2 { stamp-num(i, leaf) } else { leaf }
})
