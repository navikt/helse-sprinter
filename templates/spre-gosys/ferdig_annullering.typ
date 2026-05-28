// Leser data fra JSON-fil
#let data = json("/data/spre-gosys/ferdig_annullering.json")

// --- Hjelpefunksjoner ---

#let iso_to_date(iso) = {
  let parts = iso.split("-")
  parts.at(2) + "." + parts.at(1) + "." + parts.at(0)
}

#let iso_to_nor_datetime(iso) = {
  let dt = iso.split("T")
  let date = iso_to_date(dt.at(0))
  let time = dt.at(1).split(".").at(0).split(":").slice(0, 2).join(":")
  date + " " + time
}

#let insert_space_at(str, pos) = {
  str.slice(0, pos) + " " + str.slice(pos)
}

// --- Sideoppsett ---

#set page(
  paper: "a4",
  margin: (top: 1cm, bottom: 2.5cm, left: 1cm, right: 1cm),
  footer: context [
    #align(right)[Side #counter(page).display() av #counter(page).final().first()]
    #line(length: 100%, stroke: 1pt)
  ],
)

#set text(font: "Source Sans 3", size: 12pt, lang: "nb")

#set heading(numbering: none)

#show heading.where(level: 1): it => text(size: 18pt, weight: "bold")[#it.body]
#show heading.where(level: 2): it => text(size: 14pt, weight: "bold")[#it.body]
#show heading.where(level: 3): it => {
  v(5mm, weak: true)
  text(size: 12pt, weight: "semibold")[#it.body]
  v(4mm, weak: true)
}

// --- Topptekst (header) ---

#block(
  width: 100%,
  below: 10mm,
)[
  #grid(
    columns: (2cm, 1fr),
    column-gutter: .5cm,
    align: horizon,
    image("/resources/NAV-logo.png", width: 2cm, alt: "NAV-logo"),
    text(size: 20pt, weight: "semibold")[Sykepenger – utbetaling annullert],
  )
]

// --- Personinfo ---

#grid(
  columns: (1fr),
  column-gutter: 4mm,
  row-gutter: 8mm,
  [
    === Navn
    #text[#data.navn (#insert_space_at(data.fødselsnummer, 6))]
  ],
  [
    === Arbeidsgiver
    #if "yrkesaktivitetstype" in data [
      #if data.yrkesaktivitetstype == "ARBEIDSTAKER" [
        #data.organisasjonsnavn (#data.organisasjonsnummer)
      ] else if data.yrkesaktivitetstype == "SELVSTENDIG" [
        Selvstendig næringsdrivende
      ]
    ] else [
      #data.organisasjonsnavn (#data.at("yrkesaktivitet", default: ""))
    ]
  ],
  [
    === Behandlet av
    #data.saksbehandlerIdent
  ],
  [
    === Annullert
    #iso_to_nor_datetime(data.annullert)
  ],
)

#v(4mm)
#line(length: 100%, stroke: 1pt)
#v(4mm)

// --- Behandlingsinfo ---

=== Annullert periode
#text[#iso_to_date(data.fom) – #iso_to_date(data.tom)]

#v(4mm)

#grid(
  columns: (1fr),
  column-gutter: 4mm,
  row-gutter: 8mm,
  [
    === Årsaker
    #for årsak in data.årsaker [
      - #årsak
    ]
  ],
  [
    === Begrunnelse
    #data.begrunnelse
  ],
)

