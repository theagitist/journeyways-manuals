// 1-up reading proof: each half-letter leaf on its own page.
// Build: typst compile --font-path ../fonts src/manual.typ manual.pdf
#import "content.typ": leaves, leaf-w, leaf-h

#set page(width: leaf-w, height: leaf-h, margin: 0pt)

#for (i, lf) in leaves.enumerate() {
  if i > 0 { pagebreak() }
  lf
}
