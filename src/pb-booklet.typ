// Player Booklet - 2-up imposed booklet for printing.
// 16 pages -> 4 saddle-stitch sheets (8 landscape spreads). Print double-sided,
// fold the stack in half, staple. flip-backs true = short-edge duplex (backs
// rotated 180deg), matching the rules booklet's default.
// Build: typst compile --font-path ../fonts --root .. src/pb-booklet.typ player-booklet-2up.pdf
#import "pb-content.typ": pb-leaves, pbw, pbh

#let flip-backs = true

#let blank = box(width: pbw, height: pbh)

// Pad to a multiple of 4 (16 already is, but stay safe if pages change).
#let padded = {
  let ls = pb-leaves
  let target = calc.ceil(ls.len() / 4) * 4
  for _ in range(target - ls.len()) { ls.push(blank) }
  ls
}
#let n = padded.len()

// Saddle-stitch spreads: sheet k -> front (N-2k, 1+2k), back (2+2k, N-1-2k).
#let spreads = {
  let sp = ()
  for k in range(int(n / 4)) {
    sp.push((padded.at(n - 1 - 2 * k), padded.at(2 * k)))
    sp.push((padded.at(1 + 2 * k), padded.at(n - 2 - 2 * k)))
  }
  sp
}

#set page(width: 2 * pbw, height: pbh, margin: 0pt)

#for (i, sp) in spreads.enumerate() {
  if i > 0 { pagebreak() }
  let sheet = stack(dir: ltr, sp.at(0), sp.at(1))
  if flip-backs and calc.odd(i) {
    rotate(180deg, origin: center + horizon, reflow: true, sheet)
  } else {
    sheet
  }
}
