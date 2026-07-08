// 2-up imposed booklet for printing.
// Landscape letter (11 x 8.5in) sheets, each holding two half-letter leaves in
// saddle-stitch order. Print double-sided, fold in half down the middle, staple
// the spine.
//
//   Default (flip-backs: false): print duplex flipped on the LONG edge (no rotation).
//   Short-edge duplex printers: set flip-backs to true (rotates back sheets 180deg).
//
// Build: typst compile --font-path ../fonts --root .. src/booklet.typ booklet.pdf
#import "content.typ": leaves, leaf-w, leaf-h

#let flip-backs = false

#let blank = box(width: leaf-w, height: leaf-h)

// Pad the reading-order leaves to a multiple of 4 (saddle-stitch needs full sheets).
#let padded = {
  let ls = leaves
  let target = calc.ceil(ls.len() / 4) * 4
  for _ in range(target - ls.len()) { ls.push(blank) }
  ls
}
#let n = padded.len()

// Saddle-stitch spreads: for sheet k, front = (N-2k, 1+2k), back = (2+2k, N-1-2k).
#let spreads = {
  let sp = ()
  for k in range(int(n / 4)) {
    sp.push((padded.at(n - 1 - 2 * k), padded.at(2 * k)))       // front
    sp.push((padded.at(1 + 2 * k), padded.at(n - 2 - 2 * k)))   // back
  }
  sp
}

#set page(width: 2 * leaf-w, height: leaf-h, margin: 0pt)

#for (i, sp) in spreads.enumerate() {
  if i > 0 { pagebreak() }
  let sheet = {
    place(top + left, sp.at(0))
    place(top + left, dx: leaf-w, sp.at(1))
  }
  if flip-backs and calc.odd(i) {
    box(width: 2 * leaf-w, height: leaf-h, rotate(180deg, origin: center + horizon, sheet))
  } else {
    sheet
  }
}
