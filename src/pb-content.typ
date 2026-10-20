// JOURNEYWAYS Player Booklet - content module.
// Reproduces "Journeyways character sheet 1.1.pdf" (the Player Booklet): cover,
// intro, a tear-out playing piece (a cut-and-fold standee, on its own leaf), a
// fill-in Character Sheet, 9 lined journal pages, an "after" Character Sheet, and
// a back cover.
// Art-heavy pages (journal) are placed as faithful full-page renders; text pages
// (cover, intro, character sheet, back cover) are rebuilt with the brand fonts
// (Italianno + Nunito). The booklet is monochrome (black script headings).
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

// Tear-out standee: dotted = cut line (scissors or pre-perf), dashed = fold.
#let dash-cut = (paint: c-boxln, thickness: 0.9pt, dash: "dotted")
#let dash-fold = (paint: c-mut, thickness: 0.7pt, dash: "loosely-dashed")

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
#let tagline = text(font: "Nunito", weight: "bold", size: 9pt, fill: c-ink, tracking: 0.02em,
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
      // the spiral mark in grayscale (the booklet prints black and white), wordmark + tagline live
      place(top + center, dy: side * 0.03, image(pba("art/logo-mark-gray.png"), width: side * 0.62))
      place(top + center, dy: side * 0.62, text(font: "Italianno", size: 60pt, fill: c-ink, [Journeyways]))
      place(top + center, dy: side * 0.86,
        text(font: "Nunito", weight: "bold", size: 10.5pt, fill: c-ink, tracking: 0.02em,
          t(en: [A BOARD GAME ABOUT BECOMING], es: [UN JUEGO DE MESA SOBRE EL DEVENIR], fr: [UN JEU DE SOCIÉTÉ SUR LE DEVENIR])))
    }))
  // localized booklet label below the panel
  place(bottom + center, dy: -0.5in,
    script(46pt, t(en: [Player Booklet], es: [Cuaderno de juego], fr: [Cahier de jeu])))
})

// 2. Intro + quick guide. Black and white; a short lead, then a handy reference.
// Compact enough that the longer es/fr text still clears the page number.
#let qh(body) = block(above: 8pt, below: 5pt,
  text(font: "Nunito", weight: "bold", size: 10pt, fill: c-ink, body))
#let pb-intro = pb-frame(pad: 0.5in, {
  script(44pt, [Journeyways])
  v(-4pt)
  tagline
  v(9pt)
  block(width: 100%, text(font: "Nunito", size: 11pt, style: "italic", fill: c-ink,
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
  set text(font: "Nunito", size: 9pt, fill: c-ink)
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
#let prompt(l) = block(below: 3pt, above: 8pt, text(font: "Nunito", size: 9.5pt, fill: c-ink, l))
#let cbox(h) = rect(width: 100%, height: h, radius: 1pt, stroke: 0.7pt + c-boxln, fill: c-boxfill)
#let pb-charsheet = box(width: pbw, height: pbh, clip: true, {
  place(top + left, image(pba("art/wash-faint.png"), width: pbw, height: pbh, fit: "cover"))
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

// Tear-out playing piece. ONE straight cut down the dotted line frees a
// full-height strip at the page's outer edge; a few folds then turn it into a
// self-standing figure. The piece and its how-to live on a dedicated leaf (this
// page + its reverse), so the cut never touches a journal page. A stand is
// optional, and any small token works too.
//
// Fold design (a tent, the way table-tent cards and fold-over paper minis stand):
// the CENTRE fold is the apex, the top of the tent. The two halves splay down
// into an A, and a short flap at each END folds out flat as a foot, so the legs
// cannot slide apart and spring the tent open. Crease at the top, feet at the
// bottom. (A crease at the bottom just unfolds, which is the thing to avoid.)

#let STRIP = 2.1in
#let FLAP = 0.5in

// The tear strip with its cut + fold lines. `side` is "right" (the front, where
// you draw) or "left" (the reverse); the inner cut edge flips to match the leaf's
// fore-edge so it is the SAME physical strip on both faces.
#let standee-strip(side) = {
  let panel = (pbh - 2 * FLAP) / 2   // the two tent slopes; flaps are at the ends
  let ridge = FLAP + panel           // centre fold = apex = top of the tent
  let sx = if side == "right" { pbw - STRIP } else { 0pt }
  let cutx = if side == "right" { sx } else { STRIP }
  place(top + left, dx: sx, rect(width: STRIP, height: pbh, stroke: none, fill: rgb("#FFFFFFEC")))
  place(top + left, dx: cutx, line(angle: 90deg, length: pbh, stroke: dash-cut))
  // a foot flap fold at each end
  place(top + left, dx: sx, dy: FLAP, line(length: STRIP, stroke: dash-fold))
  place(top + left, dx: sx, dy: pbh - FLAP, line(length: STRIP, stroke: dash-fold))
  // the centre ridge, drawn heavier so the "top" fold reads as the main one
  place(top + left, dx: sx, dy: ridge,
    line(length: STRIP, stroke: (paint: c-mut, thickness: 1pt, dash: "loosely-dashed")))
  // labels: centre fold is the top; the end bands are feet
  place(top + left, dx: sx + 4pt, dy: ridge - 10pt,
    text(font: "Nunito", size: 6pt, fill: c-mut, t(en: [fold (top)], es: [doblez (arriba)], fr: [pli (haut)])))
  for fy in (FLAP / 2 - 4pt, pbh - FLAP / 2 - 4pt) {
    place(top + left, dx: sx, dy: fy, box(width: STRIP, align(center,
      text(font: "Nunito", size: 6pt, fill: c-mut, t(en: [foot], es: [pie], fr: [pied])))))
  }
}

// Small schematic of the folded, standing piece (drawn overleaf).
#let standee-diagram = {
  let H = 1.9in
  box(width: 100%, height: H, {
    // flat strip mini, with fold lines + a dot for the figure
    let sw = 0.62in
    rect(width: sw, height: H, radius: 2pt, stroke: 0.7pt + c-mut)
    for fy in (H * 0.12, H * 0.88) {
      place(top + left, dy: fy, line(length: sw, stroke: dash-fold))
    }
    place(top + left, dy: H * 0.5, line(length: sw, stroke: (paint: c-mut, thickness: 1pt, dash: "loosely-dashed")))
    place(top + left, dx: sw / 2 - 3.5pt, dy: H * 0.5 - 3.5pt, circle(radius: 3.5pt, stroke: 0.8pt + c-ink))
    // arrow
    place(horizon + left, dx: 0.85in, text(15pt, fill: c-mut, [→]))
    // folded standee: A-frame body, head at the apex, a foot folding OUT at each base
    let ox = 1.45in
    let bw = 1.0in
    let apex = H * 0.14
    let by = H * 0.9
    place(top + left, dx: ox, line(start: (bw / 2, apex), end: (bw * 0.24, by), stroke: 1pt + c-ink))
    place(top + left, dx: ox, line(start: (bw / 2, apex), end: (bw * 0.76, by), stroke: 1pt + c-ink))
    place(top + left, dx: ox, line(start: (bw * 0.24, by), end: (bw * 0.0, by), stroke: 1.6pt + c-ink))
    place(top + left, dx: ox, line(start: (bw * 0.76, by), end: (bw * 1.0, by), stroke: 1.6pt + c-ink))
    place(top + left, dx: ox + bw / 2 - 3.5pt, dy: apex - 3.5pt, circle(radius: 3.5pt, stroke: 0.8pt + c-ink))
  })
}

// Front of the leaf: the draw strip (right) + title and how-to (left).
#let pb-standee-front = box(width: pbw, height: pbh, clip: true, {
  place(top + left, image(pba("art/wash-faint.png"), width: pbw, height: pbh, fit: "cover"))
  standee-strip("right")
  place(left + horizon, dx: 0.45in, box(width: pbw - STRIP - 0.75in, {
    script(32pt, t(en: [Your playing piece], es: [Tu ficha], fr: [Ta pièce]))
    v(4pt)
    text(font: "Nunito", size: 10pt, fill: c-ink,
      t(en: [Cut straight down the dotted line to free the strip. Draw your character on one half. Fold at the centre to make a tent (the fold is the top), then fold the two end flaps out as feet so it stands. The diagram on the next page shows how.

Also, a ring, pebble, or any other small object would work.],
        es: [Corta recto por la línea punteada para separar la tira. Dibuja tu personaje en una mitad. Dobla por el centro para formar una tienda (el doblez es la parte de arriba) y abre las dos pestañas de los extremos como pies para que se sostenga. El dibujo de la página siguiente muestra cómo.

Además, un anillo, una piedrita o cualquier otro objeto pequeño serviría.],
        fr: [Découpe tout droit le long de la ligne pointillée pour détacher la bande. Dessine ton personnage sur une moitié. Plie au centre pour former une tente (le pli est le haut), puis déplie les deux rabats des extrémités en pieds pour qu'elle tienne. Le schéma de la page suivante montre comment.

De plus, une bague, un caillou ou tout autre petit objet ferait l'affaire.]))
  }))
})

// Reverse of the leaf: the fold diagram (right); the left strip is the back of
// the drawing surface, left clean because the cut passes through it too.
#let pb-standee-back = box(width: pbw, height: pbh, clip: true, {
  place(top + left, image(pba("art/wash-faint.png"), width: pbw, height: pbh, fit: "cover"))
  standee-strip("left")
  place(left + horizon, dx: STRIP + 0.3in, box(width: pbw - STRIP - 0.7in, {
    script(26pt, t(en: [How it folds], es: [Cómo se dobla], fr: [Comment plier]))
    v(10pt)
    standee-diagram
    v(8pt)
    text(font: "Nunito", size: 9pt, fill: c-mut, style: "italic",
      t(en: [Fold in half at the centre, the fold is the top of the tent, then fold the two end flaps out into feet. It stands on its own.],
        es: [Dobla por la mitad en el centro: el doblez es la parte de arriba de la tienda; luego abre las dos pestañas de los extremos como pies. Se sostiene sola.],
        fr: [Plie en deux au centre : le pli est le haut de la tente ; puis déplie les deux rabats des extrémités en pieds. Elle tient debout toute seule.]))
  }))
})

// Journal pages: rebuilt in Typst. Faint wash background with an
// Italianno "Journeyways" header and vector ruled lines. The shared wash
// is panned/repositioned per page (deterministic by index) so the 12 pages keep
// the source's varied feel without baking in the original raster header.
#let pb-journal-page(i) = box(width: pbw, height: pbh, clip: true, {
  // faint watercolour wash, panned horizontally per page. Width is wider than the
  // page (+4in) so panning left never exposes white on the right (max pan 3in).
  place(top + left, dx: -0.5in * calc.rem(i, 7),
    image(pba("art/wash-faint.png"), width: pbw + 4in))
  // Italianno header, top-right
  place(top + right, dx: -0.45in, dy: 0.42in,
    text(font: "Italianno", size: 34pt, fill: c-ink, [Journeyways]))
  // ruled writing lines
  place(top + left, dx: 0.45in, dy: 1.2in, box(width: pbw - 0.9in, {
    set block(spacing: 0pt)
    for _ in range(16) {
      line(length: 100%, stroke: 0.6pt + c-boxln)
      v(0.33in)
    }
  }))
})
#let pb-journal = range(9).map(i => pb-journal-page(i))

// 16. Back cover.
#let pb-back = box(width: pbw, height: pbh, clip: true, {
  place(top + left, image(pba("art/wash-faint.png"), width: pbw, height: pbh, fit: "cover"))
  place(top + center, dy: 0.7in, align(center, {
    script(42pt, [Journeyways])
    v(-4pt)
    tagline
  }))
  place(horizon + center, dy: -0.1in, image(pba("art/qr.png"), width: 2in))
  place(bottom + center, dy: -0.6in, align(center,
    text(font: "Nunito", size: 9pt, style: "italic", fill: c-mut,
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

// Reading order (16): cover, intro, the tear-out playing piece as a dedicated
// leaf (front = draw strip, back = fold diagram; placed at pages 3-4 so the two
// are the recto/verso of ONE physical leaf and the cut touches nothing else),
// first character sheet, 9 journal pages, the second (after) character sheet
// second-to-last, back cover last.
#let pb-raw = (
  pb-cover,
  pb-intro,
  pb-standee-front,
  pb-standee-back,
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
    text(font: "Nunito", size: 9pt, fill: c-mut, str(n)))
})
#let pb-leaves = pb-raw.enumerate().map(((i, leaf)) => {
  if i >= 1 and i <= pb-raw.len() - 2 { stamp-num(i, leaf) } else { leaf }
})
