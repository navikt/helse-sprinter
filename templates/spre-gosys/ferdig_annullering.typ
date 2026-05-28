#import "/templates/spre-gosys/utils.typ": iso_to_date, iso_to_nor_datetime, insert_space_at, format_currency
#import "/templates/spre-gosys/layout.typ": layout

// Leser data fra JSON-fil
#let data = json("/data/spre-gosys/ferdig_annullering.json")

// --- Bruk layout ---

#show: layout.with(
  title: "utbetaling annullert"
)

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

