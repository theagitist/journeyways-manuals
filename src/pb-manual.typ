// Player Booklet - 1-up reading proof (one leaf per page).
// Build: typst compile --font-path ../fonts --root .. src/pb-manual.typ player-booklet.pdf
#import "pb-content.typ": pb-leaves, pbw, pbh

#set page(width: pbw, height: pbh, margin: 0pt)

#for (i, lf) in pb-leaves.enumerate() {
  if i > 0 { pagebreak() }
  lf
}
