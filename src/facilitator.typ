// JOURNEYWAYS Facilitator's Guide: how to host a session.
// Same square 8.5x8.5 trim, fonts and design system as the game rules
// (reuses content.typ). English only for now, like the physical game (ADR-025).
// Build: see build.sh (facilitator_en.pdf).
// (c) 2025-2026 Adri M., CC BY-NC 4.0.

#import "content.typ": *

#set page(width: leaf-w, height: leaf-h, margin: 0pt)

// Cover: the game cover with the guide's name in place of the tagline.
#let fg-cover = box(width: leaf-w, height: leaf-h, clip: true, fill: rgb("#F4EEE0"), {
  place(top + center, dy: leaf-h * 0.03, image(asset("logo-mark.png"), width: leaf-w * 0.68))
  place(top + center, dy: leaf-h * 0.68,
    text(font: "Italianno", size: 92pt, fill: c-orange, [Journeyways]))
  place(top + center, dy: leaf-h * 0.86,
    text(font: "Inter", weight: "bold", style: "italic", size: 18pt, fill: c-ink,
      [Facilitator's guide]))
})

#let fg-intro = frame({
  v(0.05in)
  align(center, text(font: "Italianno", size: 54pt, fill: c-orange, [JOURNEYWAYS]))
  align(center, text(font: "Italianno", size: 32pt, fill: c-orange, [Facilitator's guide]))
  v(0.25in)
  p[This guide is for the person who brings JOURNEYWAYS to a table: a friend hosting a game night, a teacher, a community worker running a workshop, or a researcher running a study session.]
  p[Facilitating JOURNEYWAYS is less about teaching rules and more about holding space. The players make the story; you make it easy, safe and unhurried for them to do so.]
  p[Keep the Game Rules manual at hand. This guide does not repeat them; it explains how to open, guide, end and extend a session around them.]
  v(0.1in)
  callout[*The one rule that matters:* every rule in JOURNEYWAYS can be bent or broken, by anyone, at any moment, as long as the group is okay with it. Breaking a rule is not a failure of the game; it is the game working.]
  place(bottom + center, dy: 0.05in,
    grid(columns: 3, column-gutter: 14pt,
      tile-img("crossroads-m.jpg", 1.15in),
      tile-img("lantern-festival-m.jpg", 1.15in),
      tile-img("star-bridge-m.jpg", 1.15in)))
})

#let fg-toc = frame(num: 1, left-num: true, {
  block(below: 9pt, width: 100%, align(center, {
    text(font: "Italianno", size: 40pt, fill: c-orange, [Table of contents])
    v(-4pt)
    line(length: 1.4in, stroke: 0.9pt + c-orange.lighten(15%))
  }))
  v(2pt)
  toc-line("Your role", "2", bold: true)
  toc-line("Before the session", "3", bold: true)
  toc-line("The facilitator's kit", "3", indent: 20pt, serif: true)
  toc-line("The space and the time", "3", indent: 20pt, serif: true)
  toc-line("Playing pieces", "4", bold: true)
  toc-line("Opening the session", "5", bold: true)
  toc-line("Safety tools", "6", bold: true)
  toc-line("Starting the game", "7", bold: true)
  toc-line("During play", "8", bold: true)
  toc-line("When players break the rules", "8", indent: 20pt, serif: true)
  toc-line("Check-ins", "8", indent: 20pt, serif: true)
  toc-line("Ending the game", "9", bold: true)
  toc-line("The closing conversation", "9", indent: 20pt, serif: true)
  toc-line("Extending the game", "10", bold: true)
  toc-line("Research sessions", "11", bold: true)
})

#let fg-role = frame(num: 2, left-num: false, {
  title[Your role]
  p[As the facilitator you wear a few hats at once:]
  blist(
    [*Host.* You welcome people, set up the table and make the room feel safe and unhurried.],
    [*Guide.* You explain how to play, and above all that the rules are only a starting point. New players often need permission before they believe they can change the game.],
    [*Keeper of the space.* You introduce the safety tools, notice when someone is uncomfortable, and pause the game when it needs a pause.],
    [*Timekeeper.* You keep an eye on the clock so the session can end gently instead of being cut short.],
  )
  subhead[You don't play]
  p[The facilitator is not a player at the table. You do not create a character, pick cards or direct the story. Staying outside the game lets you watch the whole table, step in when needed, and keep the space for everyone equally.]
  p[You can still model the spirit of the game: answer questions with "what would you like to happen?", welcome odd ideas, and show that nothing is wrong here.]
})

#let fg-before = frame(num: 3, left-num: true, {
  title[Before the session]
  subhead[The facilitator's kit]
  blist(
    [One complete copy of the game, and the Game Rules manual.],
    [One player booklet per player, plus a spare.],
    [Extra blank tiles and blank cards, so players can make new places and cards on the spot.],
    [Sticky notes, pens, pencils and a few colours.],
    [A small bag of assorted playing pieces (see the next page).],
    [Index cards for the X-card (see Safety tools).],
    [Water and simple snacks. They help the slow pace.],
  )
  subhead[The space and the time]
  blist(
    [A quiet room with steady, comfortable light.],
    [A big table: the map grows, and 1.5 m by 1.5 m (about 5 by 5 feet) is comfortable.],
    [Seats for every player, and a place for you slightly apart.],
    [Check access ahead of time (step-free entry, washrooms) and ask players about any needs.],
    [Plan about 2.5 to 3 hours: arrival, opening, character creation, play and a closing conversation. Two to five players works well; a solo player is welcome too.],
  )
})

#let fg-pieces = frame(num: 4, left-num: false, {
  title[Playing pieces]
  p[Each player needs something to stand on the map. The player booklet includes a tear-out piece, but players can use *anything they like*: a ring, a coin, a button, a shell, a pebble, a piece borrowed from another game, a tiny toy.]
  p[The only limits are that the piece is not offensive and the group is okay with it. Choosing a piece is often the first small act of self-expression in the game, so give it a moment.]
  callout[*Bring options.* Keep a small bag of assorted, cheap pieces: buttons, beads, old game pieces, keys, dice, marbles, bottle caps. Nothing fancy. Lay them out on the table and let players choose, swap or bring their own.]
  place(bottom + center, dy: -0.15in,
    box(width: 3.6in, radius: 6pt, clip: true, stroke: 0.6pt + c-mut.lighten(35%),
      image(asset("meeples.jpg"), width: 100%)))
})

#let fg-opening = frame(num: 5, left-num: true, {
  title[Opening the session]
  p[Let people arrive, settle and look at the materials on the table. Keep it informal. When everyone is ready, speak briefly to the whole table:]
  nlist(
    [*What JOURNEYWAYS is.* A game about becoming: you don't play to win, you play to discover a character and a story.],
    [*The rules are loose.* Any rule can be bent or broken at any time, by anyone, as long as the group agrees. Say this out loud; it is the most important thing you will say.],
    [*Sharing is optional.* Nobody has to read their journal aloud or explain what they wrote.],
    [*The safety tools.* Introduce the opt-out, the X-card and lines and veils (next page).],
    [*Leaving is fine.* Anyone can step away or leave at any time, without giving a reason.],
    [*Questions.* Invite questions before you begin.],
  )
  p[Then lay out the playing pieces and let everyone choose one.]
})

#let fg-safety = frame(num: 6, left-num: false, {
  title[Safety tools]
  p[JOURNEYWAYS can touch personal ground: identity, memory, loss, the body. These tools help everyone feel free to go deep, because they know they can step back.]
  label-b[Opt out, any time]
  p[Anyone can skip a card, a prompt, a turn or a question, or leave the table, without explaining why. Say so at the start and mean it.]
  label-b[The X-card]
  p[Draw an X on an index card and place it in the middle of the table. Anyone can tap it to remove whatever just came up: a card, an idea, a story thread. Nobody asks why. Set the card aside, rephrase or move on, and thank the person.]
  label-b[Lines and veils]
  p[Before play, ask the group for *lines*, topics that will not appear at all, and *veils*, topics that can happen but stay off-page, mentioned without detail. Anyone can add one privately to you. Write them on a sticky note everyone can see.]
  label-b[Check-ins]
  p[Pause now and then to ask how people are doing (see During play).]
})

#let fg-start = frame(num: 7, left-num: true, {
  title[Starting the game]
  nlist(
    [*Character creation (20 to 30 minutes).* Each player opens their booklet at the character sheet and answers the prompts. Some players write a lot, some a word or two; both are fine.],
    [*Set up the table* together, following the Game Rules: shuffle the cards and the tiles into piles, and place the first tile.],
    [*Choose who starts and a rough turn order.* Keep it loose. Turns are not rigid: anyone can play when they feel ready, or sit a turn out.],
    [*Place the pieces* on the first tile.],
    [*Begin.* Walk the first player through one turn (Explore, Pick, Reflect) out loud, then step back.],
  )
  v(0.1in)
  callout[Use the word *pick* for cards and tiles, not "draw". In JOURNEYWAYS, drawing means illustrating: a blank tile, a sticky note, a doodle in the journal.]
  place(bottom + center, dy: -0.3in,
    stack(dir: ltr, spacing: -0.5in,
      rotate(-6deg, tile-img("mirror-lake-m.jpg", 1.8in)),
      rotate(6deg, tile-img("mountain-peak-m.jpg", 1.8in))))
})

#let fg-play = frame(num: 8, left-num: false, {
  title[During play]
  p[Once the game is going, your job is mostly to watch and keep the space. Let silences happen; reflection takes time. Answer rules questions with an invitation more than a ruling: "what feels right to the group?"]
  subhead[When players break the rules]
  p[Celebrate it. When someone proposes a change (placing a tile somewhere odd, inventing a card, ignoring a pile), ask the table if everyone is okay with it, then carry on. The change can last one turn or the whole game. If one player is not okay, the group finds another way.]
  subhead[Check-ins]
  p[Every so often, especially after a heavy card or a long silence, pause and ask the table how people are doing. Keep it light: "want to keep going, take a break, or change something?" Breaks are part of the game.]
  place(bottom + center, dy: 0.0in, box(width: 2.7in, radius: 6pt, clip: true,
    stroke: 0.6pt + c-mut.lighten(35%),
    image(asset("cards/gathering-dusk-m.jpg"), width: 100%)))
})

#let fg-ending = frame(num: 9, left-num: true, {
  title[Ending the game]
  p[By default the game ends when the fifth #bl card is picked. The group can end earlier or later, use a timer instead, or stop when a story feels complete. Give a gentle warning about ten minutes before you need to wrap up.]
  p[When play ends, give players a few quiet minutes to write a last journal entry and fill in the character sheet at the end of their booklet: what changed, and what stayed the same. Used cards can be discarded or kept as a log of the journey.]
  subhead[The closing conversation]
  p[Spend 15 to 25 minutes together. Sharing stays optional. Some questions that work:]
  blist(
    [What did you notice about your character, or about yourself?],
    [What felt good? What got in the way?],
    [Which rule did you break, or wish you had? Should it become part of the game?],
  )
  place(bottom + center, dy: -0.1in,
    grid(columns: 3, column-gutter: 14pt,
      tile-img("night-way-m.jpg", 1.4in),
      tile-img("northern-lights-m.jpg", 1.4in),
      tile-img("singing-cave-m.jpg", 1.4in)))
})

#let fg-extend = frame(num: 10, left-num: false, {
  title[Extending the game]
  p[A session can run longer, or carry on across several sessions:]
  blist(
    [*Raise the countdown.* End at the sixth, seventh or tenth #bl card instead of the fifth.],
    [*Shuffle back.* When the piles run low, shuffle the discarded cards back in.],
    [*Add new material.* Players can make new tiles and cards during play or between sessions, on blanks or sticky notes, and add them to the piles.],
    [*Continue next time.* Photograph the map before you pack it away, keep the journals and any kept cards, and note where each piece stood. Next session, rebuild the map and pick up where you left off. Characters and stories keep growing between sessions.],
  )
  place(bottom + center, dy: -0.12in,
    stack(dir: ltr, spacing: -0.65in,
      rotate(-10deg, mock-card("map-m.jpg", rgb("#ef4444"))),
      rotate(0deg, mock-card("leap-m.jpg", rgb("#10b981"))),
      rotate(10deg, mock-card("commune-m.jpg", rgb("#8b5cf6")))))
})

#let fg-research = frame(num: 11, left-num: true, {
  title[Research sessions]
  p[When a session is part of a research study, the study's approved protocol comes first and adds a few steps to everything above:]
  blist(
    [*Informed consent.* Share the consent form ahead of time if you can, go through it at the start, answer questions, and collect signatures before anything is recorded.],
    [*Recording.* Record only what the consent form allows. Photograph only people who signed the waiver; photograph the table, not faces, by default.],
    [*Observation notes.* Write notes during play, referring to people by a pseudonym or code, never their name.],
    [*Booklets.* If the study keeps the booklets, players must know this before they write in them.],
    [*Withdrawal.* Anyone can withdraw, during or after the session, as set out in the consent form.],
  )
  p[The safety tools, the loose rules and the optional sharing apply exactly as in any other session.]
  place(bottom + center, dy: -0.1in, tile-img("firefly-forest-m.jpg", 1.8in))
})

#let fg-leaves = (
  fg-cover, fg-intro, fg-toc, fg-role, fg-before, fg-pieces, fg-opening,
  fg-safety, fg-start, fg-play, fg-ending, fg-extend, fg-research,
  frame(num: 12, left-num: false, sec-notes),
  leaf-web,
)

#for (i, lf) in fg-leaves.enumerate() {
  if i > 0 { pagebreak() }
  lf
}
