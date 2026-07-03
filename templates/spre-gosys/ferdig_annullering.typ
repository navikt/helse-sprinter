#import "/templates/felles/utils.typ": iso_to_date, iso_to_nor_datetime, insert_space_at, format_currency
#import "/templates/felles/layout.typ": layout, new-section

// Leser data fra JSON-fil
#let data = json("/data/spre-gosys/ferdig_annullering.json")

// --- Bruk layout ---

#show: layout.with(
  title: "utbetaling annullert"
)

// --- Personinfo ---
#new-section([Sammendrag], pb: false)[
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
      [
      === Annullert periode
      #text[#iso_to_date(data.fom) – #iso_to_date(data.tom)]
      ],
        [
          === Årsaker
          #for årsak in data.årsaker [
            - #årsak
          ]
        ],
    )
]

// --- Behandlingsinfo ---

#new-section([Perioden er annullert])[
    === Begrunnelse
    #data.begrunnelse
]

