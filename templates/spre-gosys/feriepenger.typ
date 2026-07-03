#import "/templates/felles/utils.typ": iso_to_date, iso_to_nor_datetime, insert_space_at, format_currency
#import "/templates/felles/layout.typ": layout, new-section

// Leser data fra JSON-fil
#let data = json("/data/spre-gosys/feriepenger.json")

// --- Bruk layout ---

#show: layout.with(
  title: "utbetaling av feriepenger"
)

// --- Personinfo ---

#new-section([Sammendrag], pb: false)[
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
]

// --- Oppdrag ---

#for (i, oppdrag) in data.oppdrag.enumerate() {
 let tittel = if oppdrag.type == "ARBEIDSGIVER" [
    Utbetaling til arbeidsgiver
  ] else [
    Utbetaling til sykmeldt
  ]

  let mottaker_label = if oppdrag.type == "ARBEIDSGIVER" [
    Mottaker (organisasjonsnummer)
  ] else [
    Mottaker (fødselsnummer)
  ]

  new-section([#tittel], pb: false)[
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
  ]
}

