#let new-section(title, pb: true, body) = {
  if pb {
   pagebreak(weak: true)
  }
  heading(level: 2, title)
  body
  v(8mm, weak: false)
}

#let layout(
  title: "",
  body
) = {
set page(
  paper: "a4",
  margin: (top: 1cm, bottom: 2.5cm, left: 1cm, right: 1cm),
  footer: context [
    #align(right)[Side #counter(page).display() av #counter(page).final().first()]
    #line(length: 100%, stroke: 1pt)
  ],
)
set document(title: title)

set text(font: "Source Sans 3", size: 12pt, lang: "nb")

set heading(numbering: none)

show heading.where(level: 1): it => text(size: 20pt, weight: "semibold")[#it.body]

show heading.where(level: 2): it => text(size: 14pt, weight: "semibold")[#it.body]

show heading.where(level: 3): it => {
  v(5mm, weak: true)
  text(size: 12pt, weight: "semibold")[#it.body]
  v(4mm, weak: true)
}

// --- Topptekst (header) ---

block(width: 100%, below: 10mm)[
  #grid(
    columns: (2cm, 1fr),
    column-gutter: .5cm,
    align: horizon,
    image("/resources/NAV-logo.png", width: 2cm, alt: "NAV-logo"),
    [
    = Sykepenger – #title
    ]
  )
]

body
}
