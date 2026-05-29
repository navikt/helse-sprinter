#import "/templates/felles/utils.typ": iso_to_date, iso_to_nor_datetime, insert_space_at, format_currency
#import "/templates/felles/layout.typ": layout

// Leser data fra JSON-fil
#let data = json("/data.json")

// --- Bruk layout ---

#show: layout.with(
  title: "utbetaling av feriepenger"
)

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

