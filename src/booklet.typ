// 2-up imposed booklet for printing.
// Landscape letter (11 x 8.5in) sheets, each holding two half-letter leaves in
// saddle-stitch order. Print double-sided, fold in half down the middle, staple
// the spine.
//
//   Default (flip-backs: false): print duplex flipped on the LONG edge (no rotation).
//   Short-edge duplex printers: set flip-backs to true (rotates back sheets 180deg).
//
// Build: typst compile --font-path ../fonts --root .. src/booklet.typ booklet.pdf
#import "content.typ": booklet-leaves, leaf-w, leaf-h

// The source booklet is bound for SHORT-edge duplex (back sheets rotated 180deg).
// Set to false if your printer flips on the long edge.
#let flip-backs = true

#let blank = box(width: leaf-w, height: leaf-h)

// Pad the reading-order leaves to a multiple of 4 (saddle-stitch needs full sheets).
#let padded = {
  let ls = booklet-leaves
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
  // Two fixed-size leaf boxes side by side fill the landscape sheet exactly.
  let sheet = stack(dir: ltr, sp.at(0), sp.at(1))
  if flip-backs and calc.odd(i) {
    rotate(180deg, origin: center + horizon, reflow: true, sheet)
  } else {
    sheet
  }
}
