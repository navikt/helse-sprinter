#import "@preview/oxifmt:1.0.0": strfmt

// Leser data fra JSON-fil
#let data = json("/data/spre-gosys/feriepenger.json")

// --- Hjelpefunksjoner ---

#let iso_to_date(iso) = {
  let parts = iso.split("-")
  parts.at(2) + "." + parts.at(1) + "." + parts.at(0)
}

#let insert_space_at(str, pos) = {
  str.slice(0, pos) + " " + str.slice(pos)
}

#let format_currency(amount) = {
  strfmt("{:.2}", float(amount), fmt-thousands-separator: " ", fmt-decimal-separator: ",")
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
    text(size: 20pt, weight: "semibold")[Sykepenger - utbetaling av feriepenger],
  )
]

// --- Personinfo ---

#grid(
  columns: (1fr),
  column-gutter: 4mm,
  row-gutter: 8mm,
  [
    === Fødselsnummer
    #insert_space_at(data.fødselsnummer, 6)
  ],
  [
    === Arbeidsgiver
    #data.orgnummer
  ],
)

#v(6mm)
#line(length: 100%, stroke: 1pt)
#v(4mm)

// --- Oppdrag ---

#for (i, oppdrag) in data.oppdrag.enumerate() [
  #let tittel = if oppdrag.type == "ARBEIDSGIVER" [
    Utbetaling til arbeidsgiver
  ] else [
    Personutbetaling
  ]

  #let mottaker_label = if oppdrag.type == "ARBEIDSGIVER" [
    Mottaker (orgnummer)
  ] else [
    Mottaker (personnummer)
  ]

  === #tittel

  #grid(
    columns: (1fr),
    column-gutter: 4mm,
    row-gutter: 8mm,
    [
      === Periode
      #iso_to_date(oppdrag.fom) – #iso_to_date(oppdrag.tom)
    ],
    [
      === Totalbeløp
      #format_currency(oppdrag.totalbeløp) kr
    ],
    [
      === Fagsystem-ID
      #oppdrag.fagsystemId
    ],
    [
      === #mottaker_label
      #oppdrag.mottaker
    ],
  )

  #if i < data.oppdrag.len() - 1 [
    #v(4mm)
    #line(length: 100%, stroke: 1pt)
    #v(4mm)
  ]
]

