// JOURNEYWAYS Game Rules - content module.
// One square 8.5x8.5 reading edition (`manual-leaves`), one topic per page, with
// generous spacing. The former imposed 2-up booklet edition was retired: the
// boardgame box holds a square trim, so the manual prints on letter and is
// trimmed at the bottom to 8.5x8.5.
//
// Typography mirrors the web/play brand: Italianno (display script) + Inter (body).
// Localized en / es / fr via the shared `t()` picker (see i18n.typ); one layout,
// three languages, no duplication.
// Content reproduces the JOURNEYWAYS game rules (c) 2025-2026 Adri M., CC BY-NC 4.0.

#import "i18n.typ": lang, t

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
// Card-colour word (feminine, agreeing with "card" / "carta" / "carte").
#let card(name, col) = text(fill: col, weight: "bold", name)
#let g   = card(t(en: "Green",  es: "Verde",  fr: "Verte"),    c-green)
#let bl  = card(t(en: "Black",  es: "Negra",  fr: "Noire"),    c-mut)
#let blu = card(t(en: "Blue",   es: "Azul",   fr: "Bleue"),    c-blue)
#let rd  = card(t(en: "Red",    es: "Roja",   fr: "Rouge"),    c-red)
#let pp  = card(t(en: "Purple", es: "Morada", fr: "Violette"), c-purple)

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
  leg-item("green",  t(en: "Green:",  es: "Verde:",  fr: "Verte :"),
    t(en: "movement.", es: "movimiento.", fr: "déplacement.")),
  leg-item("blue",   t(en: "Blue:",   es: "Azul:",   fr: "Bleue :"),
    t(en: "a quote to reflect on.", es: "una cita para reflexionar.", fr: "une citation à méditer.")),
  leg-item("red",    t(en: "Red:",    es: "Roja:",   fr: "Rouge :"),
    t(en: "an encounter.", es: "un encuentro.", fr: "une rencontre.")),
  leg-item("purple", t(en: "Purple:", es: "Morada:", fr: "Violette :"),
    t(en: "a group event.", es: "un evento de grupo.", fr: "un événement de groupe.")),
  leg-item("black",  t(en: "Black:",  es: "Negra:",  fr: "Noire :"),
    t(en: "the passing of time.", es: "el paso del tiempo.", fr: "le passage du temps.")),
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
        t(en: [© 2025-2026 JOURNEYWAYS. A board game about becoming.],
          es: [© 2025-2026 JOURNEYWAYS. Un juego de mesa sobre el devenir.],
          fr: [© 2025-2026 JOURNEYWAYS. Un jeu de société sur le devenir.])))
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

// Cover: full-bleed art (the stylized JOURNEYWAYS wordmark is baked into the art
// and stays as the brandmark in every language) with the localized tagline set
// as live text over the light silhouette below it.
#let leaf-cover = box(width: leaf-w, height: leaf-h, clip: true, {
  image(asset("cover-bg.jpg"), width: leaf-w, height: leaf-h, fit: "cover")
  place(top + center, dy: leaf-h * 0.64,
    text(font: "Inter", weight: "bold", style: "italic", size: 20pt, fill: c-ink,
      t(en: [A board game about becoming.],
        es: [Un juego de mesa sobre el devenir.],
        fr: [Un jeu de société sur le devenir.])))
})

// A single map-tile shown as a rounded gallery card (uses the real game art).
#let tile-card(path) = box(width: 1.7in, height: 1.7in, radius: 6pt, clip: true,
  stroke: 0.6pt + c-mut.lighten(35%),
  image(asset("tiles/" + path), width: 100%, height: 100%, fit: "cover"))

// Title / intro (unnumbered).
#let leaf-title = frame(
  {
    v(0.05in)
    align(center, text(font: "Italianno", size: 54pt, fill: c-orange, [JOURNEYWAYS]))
    align(center, text(font: "Italianno", size: 32pt, fill: c-orange,
      t(en: [Game Rules], es: [Reglas del juego], fr: [Règles du jeu])))
    v(0.28in)
    set text(font: "Inter", size: 11.5pt, fill: c-ink)
    set par(leading: 0.7em, spacing: 0.85em)
    align(center, t(
      en: [
        Step into a world where identity is not chosen but uncovered.

        In JOURNEYWAYS, you don't play to win; you play to unfold.

        Explore selfhood not with labels, but with motion, memory, and meaning.

        Whether solo or in chorus, each session reveals a story made only by your presence.

        #text(weight: "bold")[With no fixed roles and no final answers, JOURNEYWAYS invites you to]

        co-create the story of who you are and who you are becoming.
      ],
      es: [
        Entra en un mundo donde la identidad no se elige, sino que se descubre.

        En JOURNEYWAYS no juegas para ganar; juegas para desplegarte.

        Explora el ser no con etiquetas, sino con movimiento, memoria y significado.

        En solitario o a coro, cada sesión revela una historia que solo tu presencia puede crear.

        #text(weight: "bold")[Sin papeles fijos ni respuestas definitivas, JOURNEYWAYS te invita a]

        co-crear la historia de quién eres y de quién estás llegando a ser.
      ],
      fr: [
        Entre dans un monde où l'identité n'est pas choisie mais dévoilée.

        Dans JOURNEYWAYS, tu ne joues pas pour gagner ; tu joues pour te déployer.

        Explore le soi non pas avec des étiquettes, mais avec le mouvement, la mémoire et le sens.

        En solo ou en chœur, chaque séance révèle une histoire que seule ta présence fait naître.

        #text(weight: "bold")[Sans rôles fixes ni réponses définitives, JOURNEYWAYS t'invite à]

        co-créer l'histoire de qui tu es et de qui tu deviens.
      ],
    ))
    v(0.2in)
    align(center, text(style: "italic",
      t(en: [This manual will help you learn how to begin your journey of becoming.],
        es: [Este manual te ayudará a aprender cómo empezar tu viaje de devenir.],
        fr: [Ce manuel t'aidera à apprendre comment commencer ton voyage de devenir.])))
    v(0.35in)
    align(center, box(width: 5.6in,
      grid(columns: 3, column-gutter: 16pt,
        tile-card("mirror-lake.jpg"),
        tile-card("mountain-peak.jpg"),
        tile-card("singing-cave.jpg"))))
    v(8pt)
    align(center, text(font: "Inter", size: 9pt, style: "italic", fill: c-mut,
      t(en: [A few of the places your journey may take you.],
        es: [Algunos de los lugares a los que tu viaje puede llevarte.],
        fr: [Quelques-uns des lieux où ton voyage pourrait te mener.])))
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
      text(font: "Italianno", size: 42pt, fill: c-orange,
        t(en: [Table of Contents], es: [Índice], fr: [Table des matières]))
      v(-2pt)
      line(length: 1.4in, stroke: 0.9pt + c-orange.lighten(15%))
    }))
    v(2pt)
    toc-line(t(en: "Game Setup", es: "Preparación", fr: "Mise en place"), "2", bold: true)
    toc-line(t(en: "What You'll Need", es: "Qué necesitas", fr: "Ce qu'il te faut"), "2", indent: 20pt, serif: true)
    toc-line(t(en: "Initial Setup", es: "Preparación inicial", fr: "Préparation initiale"), "2", indent: 20pt, serif: true)
    toc-line(t(en: "Basic Gameplay", es: "Cómo se juega", fr: "Déroulement du jeu"), "3", bold: true)
    toc-line(t(en: "Turn Structure", es: "Estructura del turno", fr: "Structure du tour"), "3", indent: 20pt, serif: true)
    toc-line(t(en: "1. Explore", es: "1. Explorar", fr: "1. Explorer"), "3", indent: 40pt, serif: true)
    toc-line(t(en: "2. Pick", es: "2. Elegir", fr: "2. Choisir"), "3", indent: 40pt, serif: true)
    toc-line(t(en: "3. Reflect", es: "3. Reflexionar", fr: "3. Réfléchir"), "3", indent: 40pt, serif: true)
    toc-line(t(en: "Ending the game", es: "El final del juego", fr: "La fin de la partie"), "4", bold: true)
    toc-line(t(en: "Writing your journal", es: "Escribir tu diario", fr: "Écrire ton journal"), "5", bold: true)
    toc-line(t(en: "Solo vs Group Play", es: "Juego en solitario y en grupo", fr: "Jeu en solo et en groupe"), "7", bold: true)
    toc-line(t(en: "Solo Play", es: "Juego en solitario", fr: "Jeu en solo"), "7", indent: 20pt, serif: true)
    toc-line(t(en: "Group Play", es: "Juego en grupo", fr: "Jeu en groupe"), "7", indent: 20pt, serif: true)
    toc-line(t(en: "Advanced Concepts", es: "Conceptos avanzados", fr: "Concepts avancés"), "8", bold: true)
    toc-line(t(en: "Session Endings", es: "Finales de sesión", fr: "Fins de séance"), "8", indent: 20pt, serif: true)
    toc-line(t(en: "Returning to Previous Sessions", es: "Volver a sesiones anteriores", fr: "Revenir aux séances précédentes"), "8", indent: 20pt, serif: true)
    toc-line(t(en: "Creating Your Own Elements", es: "Crear tus propios elementos", fr: "Créer tes propres éléments"), "8", indent: 20pt, serif: true)
    toc-line(t(en: "Tips for Meaningful Play", es: "Consejos para un juego significativo", fr: "Conseils pour un jeu qui a du sens"), "9", bold: true)
    toc-line(t(en: "Creating Safe Space", es: "Crear un espacio seguro", fr: "Créer un espace sûr"), "9", indent: 20pt, serif: true)
    toc-line(t(en: "Deepening the Experience", es: "Profundizar la experiencia", fr: "Approfondir l'expérience"), "9", indent: 20pt, serif: true)
  }
)

// Game Setup (folio 2).
#let leaf-setup = frame(num: 2, left-num: false,
  {
    title(t(en: [Game Setup], es: [Preparación], fr: [Mise en place]))
    subhead(t(en: [What You'll Need], es: [Qué necesitas], fr: [Ce qu'il te faut]))
    blist(
      t(en: [Board tiles (35).], es: [Losetas de tablero (35).], fr: [Tuiles de plateau (35).]),
      t(en: [Game cards (81).], es: [Cartas de juego (81).], fr: [Cartes de jeu (81).]),
      t(en: [Player tokens (1 per player).], es: [Fichas de juego (1 por persona).], fr: [Pions (1 par personne).]),
      t(en: [Player booklet (1 per player).], es: [Cuaderno de juego (1 por persona).], fr: [Cahier de jeu (1 par personne).]),
      t(en: [Some sticky notes.], es: [Algunas notas adhesivas.], fr: [Quelques notes autocollantes.]),
      t(en: [Die for choosing the starting player (1).], es: [Un dado para decidir quién empieza (1).], fr: [Un dé pour désigner qui commence (1).]),
      t(en: [Writing utensils.], es: [Algo para escribir.], fr: [De quoi écrire.]),
    )
    // Illustration tucked into the empty right of the components list (out of flow).
    place(top + right, dy: 1.35in, doodle-note("playground",
      t(en: [set the scene], es: [prepara la escena], fr: [plante le décor]), w: 1.55in))
    subhead(t(en: [Initial Setup], es: [Preparación inicial], fr: [Préparation initiale]))
    nlist(
      t(en: [Shuffle all cards together and place them face down in three piles.],
        es: [Baraja todas las cartas juntas y colócalas boca abajo en tres montones.],
        fr: [Mélange toutes les cartes ensemble et place-les face cachée en trois piles.]),
      t(en: [Pick one card and place it apart face up. This will be the Discard pile.],
        es: [Elige una carta y colócala aparte boca arriba. Será el montón de descarte.],
        fr: [Choisis une carte et pose-la à part, face visible. Ce sera la pile de défausse.]),
      t(en: [Find the Starter board tile and set it apart. Shuffle all others and place them face down in three piles.],
        es: [Busca la loseta inicial y ponla aparte. Baraja las demás y colócalas boca abajo en tres montones.],
        fr: [Trouve la tuile de départ et mets-la à part. Mélange les autres et place-les face cachée en trois piles.]),
      t(en: [Each player takes one player token.],
        es: [Cada persona toma una ficha.],
        fr: [Chaque personne prend un pion.]),
      t(en: [Use the die to determine the starting player. For example, highest number goes first.],
        es: [Usa el dado para decidir quién empieza. Por ejemplo, el número más alto va primero.],
        fr: [Utilise le dé pour désigner qui commence. Par exemple, le plus grand nombre commence.]),
      t(en: [Place the Starter board tile in the center of the table.],
        es: [Coloca la loseta inicial en el centro de la mesa.],
        fr: [Place la tuile de départ au centre de la table.]),
      t(en: [Taking turns, each player picks a tile from any pile and places it adjacent to another previously placed tile. If it's a blank tile, put it back in the pile and pick again.],
        es: [Por turnos, cada persona elige una loseta de cualquier montón y la coloca junto a otra ya colocada. Si es una loseta en blanco, devuélvela al montón y elige otra.],
        fr: [À tour de rôle, chaque personne choisit une tuile dans une pile et la place à côté d'une tuile déjà posée. Si la tuile est vierge, remets-la dans la pile et choisis-en une autre.]),
      t(en: [All players place their tokens on the Starter tile.],
        es: [Todas las personas colocan su ficha en la loseta inicial.],
        fr: [Chaque personne place son pion sur la tuile de départ.]),
    )
  }
)

// Basic Gameplay (folio 3).
#let leaf-gameplay = frame(num: 3, left-num: true,
  {
    title(t(en: [Basic Gameplay], es: [Cómo se juega], fr: [Déroulement du jeu]))
    subhead(t(en: [Turn Structure], es: [Estructura del turno], fr: [Structure du tour]))
    t(en: [Each turn consists of three phases: Explore, Pick, and Reflect.],
      es: [Cada turno consta de tres fases: Explorar, Elegir y Reflexionar.],
      fr: [Chaque tour comprend trois phases : Explorer, Choisir et Réfléchir.])
    label-b(t(en: [1. Explore], es: [1. Explorar], fr: [1. Explorer]))
    t(en: [For Exploration, you have two options: (1) Pick a map tile and place it adjacent to another one. If you pick a blank tile, you have to create it before placing it. (2) Use a sticky note to draw a new map tile (whatever you want) and place it on top of an existing one where no player is located. After you place your tile, you can move one or two spaces in any direction.],
      es: [Para explorar tienes dos opciones: (1) Elige una loseta del mapa y colócala junto a otra. Si eliges una loseta en blanco, tienes que crearla antes de colocarla. (2) Usa una nota adhesiva para dibujar una nueva loseta del mapa (lo que quieras) y colócala encima de una loseta existente donde no haya ninguna ficha. Después de colocar tu loseta, puedes moverte uno o dos espacios en cualquier dirección.],
      fr: [Pour explorer, tu as deux options : (1) Choisis une tuile de carte et place-la à côté d'une autre. Si tu choisis une tuile vierge, tu dois la créer avant de la poser. (2) Sur une note autocollante, dessine une nouvelle tuile de carte (ce que tu veux) et pose-la sur une tuile existante où ne se trouve aucun pion. Après avoir posé ta tuile, tu peux te déplacer d'une ou deux cases dans n'importe quelle direction.])
    label-b(t(en: [2. Pick], es: [2. Elegir], fr: [2. Choisir]))
    t(en: [Pick a card from any pile, even the Discard pile. Each colour means something different:],
      es: [Elige una carta de cualquier montón, incluso del montón de descarte. Cada color significa algo distinto:],
      fr: [Choisis une carte dans n'importe quelle pile, même la pile de défausse. Chaque couleur veut dire quelque chose de différent :])
    card-legend
    label-b(t(en: [3. Reflect], es: [3. Reflexionar], fr: [3. Réfléchir]))
    t(en: [If you picked a #g or #pp card, you have to perform the action it indicates. If you picked a #blu or #rd card, take into account what they say, and write a new entry in your journal. If you picked a #bl card, set it apart. The game ends when the fifth #bl card is picked.],
      es: [Si elegiste una carta #g o #pp, tienes que realizar la acción que indica. Si elegiste una carta #blu o #rd, ten en cuenta lo que dicen y escribe una nueva entrada en tu diario. Si elegiste una carta #bl, ponla aparte. El juego termina cuando se elige la quinta carta #bl.],
      fr: [Si tu as choisi une carte #g ou #pp, tu dois accomplir l'action indiquée. Si tu as choisi une carte #blu ou #rd, tiens compte de ce qu'elle dit et écris une nouvelle entrée dans ton journal. Si tu as choisi une carte #bl, mets-la à part. La partie se termine quand la cinquième carte #bl est choisie.])
  }
)

// Ending the game (folio 4).
#let leaf-ending = frame(num: 4, left-num: false,
  {
    title(t(en: [Ending the game], es: [El final del juego], fr: [La fin de la partie]))
    p(t(en: [The game ends when the fifth #bl card is picked. Each player can add a final entry to their journal, or just leave it as it is. However, if all players agree you can end the session after any number of #bl cards are picked, or disregard the #bl cards and use a timer, etc.],
      es: [El juego termina cuando se elige la quinta carta #bl. Cada persona puede añadir una última entrada a su diario o dejarlo tal cual. Sin embargo, de común acuerdo, la sesión puede terminar tras elegir cualquier número de cartas #bl, o pueden ignorarse las cartas #bl y usar un temporizador, etc.],
      fr: [La partie se termine quand la cinquième carte #bl est choisie. Chaque personne peut ajouter une dernière entrée à son journal, ou le laisser tel quel. Cependant, d'un commun accord, la séance peut se terminer après un nombre quelconque de cartes #bl, ou vous pouvez ignorer les cartes #bl et utiliser un minuteur, etc.]))
    p(t(en: [It is okay if your story ends abruptly. You can leave it like that, or return to it in another session.],
      es: [No pasa nada si tu historia termina de golpe. Puedes dejarla así o retomarla en otra sesión.],
      fr: [Ce n'est pas grave si ton histoire se termine brusquement. Tu peux la laisser ainsi ou y revenir lors d'une autre séance.]))
    p(t(en: [After ending the game, each player can fill their Character Sheet at the end of the Player Booklet. This way they can see how their character developed during the game; what changed, and what stayed the same.],
      es: [Al terminar el juego, cada persona puede rellenar su Hoja de Personaje al final del Cuaderno de juego. Así puede ver cómo evolucionó su personaje durante la partida: qué cambió y qué permaneció igual.],
      fr: [À la fin de la partie, chaque personne peut remplir sa Fiche de Personnage à la fin du Cahier de jeu. Elle peut ainsi voir comment son personnage a évolué au cours de la partie : ce qui a changé et ce qui est resté pareil.]))
    v(4pt)
    callout(t(en: [*Remember:* the game is not about winning or losing. It is about discovering, exploring, and becoming.],
      es: [*Recuerda:* el juego no va de ganar ni de perder. Va de descubrir, explorar y devenir.],
      fr: [*Souviens-toi :* le jeu ne consiste pas à gagner ou à perdre. Il s'agit de découvrir, d'explorer et de devenir.]))
    place(bottom + right, dy: 0.15in, doodle-note("cliff",
      t(en: [an ending, or a pause], es: [un final, o una pausa], fr: [une fin, ou une pause])))
  }
)

// Writing your journal (folio 5): the explanation.
#let leaf-journal = frame(num: 5, left-num: true,
  {
    title(t(en: [Writing your journal], es: [Escribir tu diario], fr: [Écrire ton journal]))
    v(0.15in)
    p(t(en: [Unlike traditional games, your character in JOURNEYWAYS emerges through play rather than being predetermined.],
      es: [A diferencia de los juegos tradicionales, tu personaje en JOURNEYWAYS surge a través del juego en lugar de estar predeterminado.],
      fr: [Contrairement aux jeux traditionnels, ton personnage dans JOURNEYWAYS émerge au fil du jeu au lieu d'être prédéterminé.]))
    p(t(en: [Use the game cards as inspiration, not rigid definitions; the main objective is you set your imagination free and write the story you want to tell. Journal entries can be as short or as long, as terse or as detailed as you want.],
      es: [Usa las cartas del juego como inspiración, no como definiciones rígidas; el objetivo principal es que liberes tu imaginación y escribas la historia que quieras contar. Las entradas del diario pueden ser tan cortas o tan largas, tan escuetas o tan detalladas como quieras.],
      fr: [Utilise les cartes du jeu comme inspiration, non comme des définitions rigides ; l'objectif principal est de libérer ton imagination et d'écrire l'histoire que tu veux raconter. Les entrées du journal peuvent être aussi courtes ou aussi longues, aussi brèves ou aussi détaillées que tu le souhaites.]))
    p(t(en: [You can get inspiration from the tile where your token is located and the text in the card, but you can be as creative as you want. You can write a journal entry, doodle it, or do whatever you like.],
      es: [Puedes inspirarte en la loseta donde está tu ficha y en el texto de la carta, pero puedes dejar volar tu creatividad tanto como quieras. Puedes escribir una entrada de diario, dibujarla o hacer lo que prefieras.],
      fr: [Tu peux t'inspirer de la tuile où se trouve ton pion et du texte de la carte, mais tu peux laisser libre cours à ta créativité autant que tu veux. Tu peux écrire une entrée de journal, la dessiner, ou faire ce qui te plaît.]))
    v(0.1in)
    p(t(en: [Here is an example of a possible journal entry, on the next page.],
      es: [Aquí tienes un ejemplo de una posible entrada de diario, en la página siguiente.],
      fr: [Voici un exemple d'entrée de journal possible, à la page suivante.]))
    place(bottom + right, dy: 0.15in, doodle-note("trail",
      t(en: [where will you go?], es: [¿adónde irás?], fr: [où iras-tu ?])))
  }
)

// The example journal entry, shown large and legible on its own page (folio 6).
// Creative first-person prose; the es/fr recast it to avoid gendered self-
// description (the narrator's identity is deliberately unfixed).
#let leaf-journal-example = frame(num: 6, left-num: false,
  {
    v(0.15in)
    set par(leading: 0.58em, spacing: 0.85em, justify: false)
    text(font: "Italianno", size: 25pt, fill: c-ink, t(
      en: [
        It was a warm summer evening when I stumbled upon a cave entrance. There was a soft breeze, and I could hear music coming from the inside. I did not dare go inside, but, right by the entrance I found a pair of shoes. They were brown and looked well-worn, but something in my mind told me to try them on. I removed the tattered sandals I was wearing and put those shoes on. As soon as I did, I felt lighter, as if I was not standing up by myself but some other unexplained force was lifting me. That made me happy. I only wanted the shoes to look a bit better, not brown and all worn down. When that thought crossed my mind, the shoes changed. Now they were sparkly green boots with red trimmings and golden shoelaces. I loved them and decided to keep them.

        As for the cave, I decided to walk by. Maybe I can revisit it some other time.
      ],
      es: [
        Era una cálida tarde de verano cuando la entrada de una cueva apareció ante mí. Soplaba una brisa suave y podía oír música que venía del interior. No me atreví a entrar, pero, justo al lado de la entrada, encontré un par de zapatos. Eran marrones y parecían muy gastados, pero algo en mi mente me dijo que me los probara. Me quité las sandalias raídas que llevaba y me puse aquellos zapatos. En cuanto lo hice, sentí una repentina ligereza, como si no me sostuviera por mi propia cuenta, sino que alguna otra fuerza inexplicable me levantara. Eso me llenó de alegría. Solo quería que los zapatos se vieran un poco mejor, no marrones y desgastados. En cuanto ese pensamiento cruzó mi mente, los zapatos cambiaron. Ahora eran botas verdes brillantes con ribetes rojos y cordones dorados. Me encantaron y decidí quedármelos.

        En cuanto a la cueva, decidí seguir de largo. Quizá pueda volver a ella en otro momento.
      ],
      fr: [
        C'était une chaude soirée d'été lorsqu'une entrée de grotte s'est présentée à moi. Une douce brise soufflait et j'entendais de la musique venir de l'intérieur. Je n'ai pas osé entrer, mais, juste à côté de l'entrée, j'ai trouvé une paire de chaussures. Elles étaient marron et semblaient bien usées, mais quelque chose en moi m'a dit de les essayer. J'ai retiré les sandales en lambeaux que je portais et j'ai enfilé ces chaussures. Aussitôt, j'ai ressenti une soudaine légèreté, comme si je ne tenais pas debout par mes propres moyens, mais qu'une autre force inexplicable me soulevait. J'en ai éprouvé de la joie. Je voulais seulement que les chaussures aient un peu meilleure allure, pas marron et toutes usées. À l'instant où cette pensée m'a traversé l'esprit, les chaussures ont changé. C'étaient désormais des bottes vertes scintillantes aux liserés rouges et aux lacets dorés. Je les ai adorées et j'ai décidé de les garder.

        Quant à la grotte, j'ai décidé de passer mon chemin. Je pourrai peut-être y revenir une autre fois.
      ],
    ))
    place(bottom + right, dy: 0.1in, box(width: 1.5in,
      image(asset("doodles/volcano.jpg"), width: 100%)))
  }
)

// --- Atomic section chunks (composed differently per edition) -------------------

#let sec-solo = {
  title(t(en: [Solo vs Group Play], es: [Juego en solitario y en grupo], fr: [Jeu en solo et en groupe]))
  v(4pt)
  two-col(
    {
      subhead(t(en: [Solo Play], es: [Juego en solitario], fr: [Jeu en solo]))
      blist(
        t(en: [Remove the #pp cards from the game.], es: [Retira las cartas #pp del juego.], fr: [Retire les cartes #pp du jeu.]),
        t(en: [Focus on deep personal reflection.], es: [Céntrate en una reflexión personal profunda.], fr: [Concentre-toi sur une réflexion personnelle profonde.]),
        t(en: [Take as much time as you need.], es: [Tómate todo el tiempo que necesites.], fr: [Prends tout le temps qu'il te faut.]),
        t(en: [Use journaling extensively.], es: [Escribe en tu diario con generosidad.], fr: [Écris abondamment dans ton journal.]),
        t(en: [Create your own pacing.], es: [Marca tu propio ritmo.], fr: [Fixe ton propre rythme.]),
        t(en: [Return to previous sessions.], es: [Vuelve a sesiones anteriores.], fr: [Reviens aux séances précédentes.]),
      )
    },
    {
      subhead(t(en: [Group Play], es: [Juego en grupo], fr: [Jeu en groupe]))
      blist(
        t(en: [Share reflections with others.], es: [Comparte reflexiones con las demás personas.], fr: [Partage tes réflexions avec les autres.]),
        t(en: [Learn from different perspectives.], es: [Aprende de perspectivas distintas.], fr: [Apprends d'autres perspectives.]),
        t(en: [Build collective narratives.], es: [Contribuye a relatos colectivos.], fr: [Contribue à des récits collectifs.]),
        t(en: [Support each other's growth.], es: [Apoya el crecimiento de las demás personas.], fr: [Soutiens la croissance des autres.]),
        t(en: [Create shared memories.], es: [Crea recuerdos compartidos.], fr: [Crée des souvenirs partagés.]),
      )
    },
  )
  place(bottom + center, dy: 0.05in, image(asset("meeples.jpg"), width: 3.2in))
}

#let sec-advanced = {
  title(t(en: [Advanced Concepts], es: [Conceptos avanzados], fr: [Concepts avancés]))
  subhead(t(en: [Session Endings], es: [Finales de sesión], fr: [Fins de séance]))
  p(t(en: [It's recommended to end the session when the fifth #bl card is picked. Each player can add a final entry to their journal, or just leave it as it is.],
    es: [Se recomienda terminar la sesión cuando se elige la quinta carta #bl. Cada persona puede añadir una última entrada a su diario, o dejarlo tal cual.],
    fr: [Il est recommandé de terminer la séance quand la cinquième carte #bl est choisie. Chaque personne peut ajouter une dernière entrée à son journal, ou le laisser tel quel.]))
  p(t(en: [However, if all players agree you can end the session after any number of #bl cards are picked, or disregard the #bl cards and use a timer, etc.],
    es: [Sin embargo, de común acuerdo, la sesión puede terminar tras elegir cualquier número de cartas #bl, o pueden ignorarse las cartas #bl y usar un temporizador, etc.],
    fr: [Cependant, d'un commun accord, la séance peut se terminer après un nombre quelconque de cartes #bl, ou vous pouvez ignorer les cartes #bl et utiliser un minuteur, etc.]))
  subhead(t(en: [Returning to Previous Sessions], es: [Volver a sesiones anteriores], fr: [Revenir aux séances précédentes]))
  t(en: [JOURNEYWAYS is designed for ongoing play. Return to previous sessions, revisit old insights, and see how your understanding has evolved. Your character and story continue to develop between sessions.],
    es: [JOURNEYWAYS está pensado para jugarse de forma continua. Vuelve a sesiones anteriores, revisita viejas ideas y observa cómo ha evolucionado tu comprensión. Tu personaje y tu historia siguen desarrollándose entre sesiones.],
    fr: [JOURNEYWAYS est conçu pour un jeu qui se poursuit dans le temps. Reviens aux séances précédentes, retrouve d'anciennes intuitions et observe comment ta compréhension a évolué. Ton personnage et ton histoire continuent de se développer d'une séance à l'autre.])
}

#let sec-creating-own = {
  subhead(t(en: [Creating Your Own Elements], es: [Crear tus propios elementos], fr: [Créer tes propres éléments]))
  t(en: [Feel free to add your own story cards, character elements, or game mechanics. JOURNEYWAYS is a framework for exploration; make it your own.],
    es: [Siéntete libre de añadir tus propias cartas de historia, elementos de personaje o mecánicas de juego. JOURNEYWAYS es un marco para la exploración; hazlo tuyo.],
    fr: [N'hésite pas à ajouter tes propres cartes d'histoire, éléments de personnage ou mécaniques de jeu. JOURNEYWAYS est un cadre pour l'exploration ; fais-le tien.])
}

#let sec-tips = {
  title(t(en: [Tips for Meaningful Play], es: [Consejos para un juego significativo], fr: [Conseils pour un jeu qui a du sens]))
  v(4pt)
  two-col(
    {
      subhead(t(en: [Creating Safe Space], es: [Crear un espacio seguro], fr: [Créer un espace sûr]))
      blist(
        t(en: [Set aside dedicated time.], es: [Reserva un tiempo dedicado.], fr: [Réserve un temps dédié.]),
        t(en: [Minimize distractions.], es: [Reduce las distracciones.], fr: [Limite les distractions.]),
        t(en: [Create a comfortable environment.], es: [Crea un ambiente cómodo.], fr: [Crée un environnement confortable.]),
        t(en: [Honor everyone's privacy.], es: [Respeta la privacidad de todo el mundo.], fr: [Respecte l'intimité de tout le monde.]),
        t(en: [Practice active listening.], es: [Practica la escucha activa.], fr: [Pratique l'écoute active.]),
      )
    },
    {
      subhead(t(en: [Deepening the Experience], es: [Profundizar la experiencia], fr: [Approfondir l'expérience]))
      blist(
        t(en: [Ask open-ended questions.], es: [Haz preguntas abiertas.], fr: [Pose des questions ouvertes.]),
        t(en: [Embrace uncertainty.], es: [Abraza la incertidumbre.], fr: [Accueille l'incertitude.]),
        t(en: [Allow for silence and reflection.], es: [Da espacio al silencio y a la reflexión.], fr: [Laisse place au silence et à la réflexion.]),
        t(en: [Be curious, not judgmental.], es: [Cultiva la curiosidad, no el juicio.], fr: [Cultive la curiosité, pas le jugement.]),
        t(en: [Celebrate small discoveries.], es: [Celebra los pequeños descubrimientos.], fr: [Célèbre les petites découvertes.]),
      )
    },
  )
  place(bottom + left, dy: 0.1in, doodle-note("field",
    t(en: [room to wander], es: [espacio para deambular], fr: [de quoi vagabonder])))
}

#let sec-notes = {
  title(t(en: [Notes], es: [Notas], fr: [Notes]))
  align(center, text(font: "Inter", size: 10.5pt, style: "italic", fill: c-mut,
    t(en: [For your thoughts, sketches, and discoveries.],
      es: [Para tus pensamientos, bocetos y descubrimientos.],
      fr: [Pour tes pensées, tes croquis et tes découvertes.])))
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
    align(center, text(font: "Inter", style: "italic", size: 16pt, fill: c-ink,
      t(en: [A game about becoming.], es: [Un juego sobre el devenir.], fr: [Un jeu sur le devenir.])))
    v(0.25in)
    align(center, text(font: "Italianno", size: 36pt, fill: c-orange,
      t(en: [Website], es: [Sitio web], fr: [Site web])))
    v(0.18in)
    align(center, image(asset("qr-website.png"), width: 2.8in))
    v(0.14in)
    align(center, text(font: "Inter", size: 12pt, fill: c-ink, [www.journeyways.ca]))
    v(0.5in)
    align(center, text(font: "Inter", size: 9pt, fill: c-mut,
      t(en: [© 2025-2026 Adri M. Licensed under CC BY-NC 4.0.],
        es: [© 2025-2026 Adri M. Con licencia CC BY-NC 4.0.],
        fr: [© 2025-2026 Adri M. Sous licence CC BY-NC 4.0.])))
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
      align(center + horizon, doodle-note("house",
        t(en: [return here], es: [vuelve aquí], fr: [reviens ici]), w: 1.45in)),
    )
  }),
  frame(num: 9, left-num: true, sec-tips),
  frame(num: 10, left-num: false, sec-notes),
  leaf-web,
)
