#import "/templates/felles/utils.typ": iso_to_date, iso_to_nor_datetime, insert_space_at, format_currency
#import "/templates/felles/layout.typ": layout

// Leser data fra JSON-fil
#let data = json("/data.json")

// --- Bruk layout ---

#show: layout.with(
  title: "dialogmelding til behandler"
)

// --- Personinfo ---

#block(breakable: true)[
#grid(
  columns: (1fr),
  column-gutter: 4mm,
  row-gutter: 8mm,
  [
    === Vår referanse
    #data.conversationRef
  ],
  [
    === Fra
    #data.fra.navn, #data.fra.NAVIdent
  ],
  [
    === Til
    #data.til.navn, #data.til.kontor.navn \
    #data.til.kontor.adresse.gate, #data.til.kontor.adresse.postnummer #data.til.kontor.adresse.poststed \
  ],
  [
    === Dato og klokkeslett
    #iso_to_nor_datetime(data.tidspunkt)
  ],
  [
    === Gjelder person
    #text[#data.gjelder.navn, #insert_space_at(data.gjelder.fødselsnummer, 6)]
  ],
  [
    === Fagområde
    #data.fagområde
  ],
  [
    === Melding
    #data.melding
  ]
)
] // end personinfo block
