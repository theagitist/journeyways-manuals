// Shared localization helper for the JOURNEYWAYS print sources.
// One layout, three languages (en / es / fr). The language is chosen at compile
// time: `typst compile --input lang=es ...` (default en). Every user-facing
// string is wrapped in `t(en: .., es: .., fr: ..)` in place, so the layout is
// written once and never duplicated per language.

#let lang = sys.inputs.at("lang", default: "en")

// Pick the string for the active language; fall back to English if a language
// is missing (so a not-yet-translated string still renders).
#let t(en: none, es: none, fr: none) = {
  let v = (en: en, es: es, fr: fr).at(lang, default: none)
  if v == none { en } else { v }
}
