// JOURNEYWAYS map-tile backs - print renderer.
//
// One shared, language-independent back for every face-down tile: the painted
// ink-and-watercolour design the play repo exports to assets/tiles/tile-back.webp
// (from the Gemini art set). Backs carry no text, so there is no language
// variant. The tile faces live in tiles.typ; this renders only the back.
//
// Compile (see build-tiles.sh):
//   typst compile --font-path fonts --root . --input mode=single src/tile-backs.typ tiles-back.pdf
// Inputs:
//   mode = single | sheet       (default single)
//     single -> one back at trim + 1/8in bleed, for full-custom print-on-demand
//               (one back applies to every tile).
//     sheet  -> 3x3 on US Letter, for DIY backs to cut and glue behind the faces.

#let data = json("../assets/tiles/tiles.json")
#let mode = sys.inputs.at("mode", default: "single")

// Geometry mirrors tiles.typ (square tile: 2.5in trim, 1/8in POD-standard bleed).
#let trim   = 2.5in
#let bleed  = 0.125in
#let page-s = trim + 2 * bleed
#let paper  = rgb("#fdfbf6")

#let art-dir = "../assets/tiles/"
#let back = data.at("back", default: "tile-back.webp")

// One back, as a self-contained square box. `s` is the trim size; `bl` is how
// far the art bleeds past each trim edge (bleed for single mode, 0 for sheet).
#let back-box(s: trim, bl: bleed) = box(
  width: s + 2 * bl, height: s + 2 * bl, fill: paper, clip: true,
  image(art-dir + back, width: 100%, height: 100%, fit: "cover"),
)

#if mode == "sheet" {
  set page(paper: "us-letter", margin: 0.5in)
  align(center, grid(columns: 3, rows: 3, gutter: 0pt,
    ..range(9).map(_ => back-box(s: trim, bl: 0pt))))
} else {
  set page(width: page-s, height: page-s, margin: 0pt)
  back-box()
}
