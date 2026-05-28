// Leser data fra JSON-fil
#let data = json("/data/spre-gosys/vedtak.json")

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

#let format_currency(amount) = {
  let s = str(int(amount))
  let result = ""
  let len = s.len()
  for i in range(len) {
    if i > 0 and calc.rem(len - i, 3) == 0 {
      result = result + " "
    }
    result = result + s.at(i)
  }
  result
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

#show heading.where(level: 2): it => text(size: 14pt, weight: "bold")[#it.body]
#show heading.where(level: 3): it => {
  v(5mm, weak: true)
  text(size: 12pt, weight: "semibold")[#it.body]
  v(4mm, weak: true)
}

// --- Topptekst (header) ---

#block(width: 100%, below: 10mm)[
  #grid(
    columns: (2cm, 1fr),
    column-gutter: .5cm,
    align: horizon,
    image("/resources/NAV-logo.png", width: 2cm, alt: "NAV-logo"),
    text(size: 20pt, weight: "semibold")[Sykepenger – #data.type sykepenger],
  )
]

// --- Personinfo ---

#block(breakable: false)[
#grid(
  columns: (1fr, 1fr),
  column-gutter: 4mm,
  row-gutter: 8mm,
  [
    === Navn
    #data.navn (#insert_space_at(data.fødselsnummer, 6))
  ],
  [
    #if "personOppdrag" in data and data.personOppdrag != none and "fagsystemId" in data.personOppdrag [
      === Fagsystem-ID (person)
      #data.personOppdrag.fagsystemId
    ]
  ],
  [
    === Arbeidsgiver
    #data.organisasjonsnavn (#data.organisasjonsnummer)
  ],
  [
    #if "arbeidsgiverOppdrag" in data and data.arbeidsgiverOppdrag != none and "fagsystemId" in data.arbeidsgiverOppdrag [
      === Fagsystem-ID (arbeidsgiver)
      #data.arbeidsgiverOppdrag.fagsystemId
    ]
  ],
  [
    === Søknadsperiode
    #iso_to_date(data.fom) – #iso_to_date(data.tom)
  ],
  [],
  [
    === Totalbeløp for denne perioden
    #format_currency(data.sumNettoBeløp) kr
  ],
  [
    === Sendt til utbetaling
    #iso_to_date(data.behandlingsdato)
  ],
  [
    === Skjæringstidspunkt
    #iso_to_date(data.skjæringstidspunkt)
  ],
  [],
  [
    #if data.automatiskBehandling [
      === Automatisk behandlet
    ] else [
      === Behandlet av
      #data.at("godkjentAv", default: "")
    ]
  ],
  [
    #if "totrinnsvurdertAv" in data and data.totrinnsvurdertAv != none [
      === Kontrollert av
      #data.totrinnsvurdertAv
    ]
  ],
  [
    #if "vedtakFattetTidspunkt" in data [
      === Vedtak fattet
      #iso_to_nor_datetime(data.vedtakFattetTidspunkt)
    ]
  ],
  [],
)
] // end personinfo block

// --- Begrunnelser (delvis innvilgelse / avslag) ---

#let begrunnelser = data.at("begrunnelser", default: (:))

#if "delvisInnvilgelse" in begrunnelser [
  #block(breakable: false)[
    #v(2mm)
    #line(length: 100%, stroke: 1pt)
    #v(4mm)
    == Perioden er delvis innvilget
    === Begrunnelse
    #begrunnelser.delvisInnvilgelse
  ]
]

#if "avslag" in begrunnelser [
  #block(breakable: false)[
    #v(2mm)
    #line(length: 100%, stroke: 1pt)
    #v(4mm)
    == Perioden er avslått
    === Begrunnelse
    #begrunnelser.avslag
    #v(2mm)
    #line(length: 100%, stroke: 1pt)
    #v(4mm)
  ]
]

// --- Utbetalte perioder ---

#let linjer = data.at("linjer", default: ())
#if linjer.len() > 0 [
  #block(breakable: false)[
    === Utbetalte perioder
    #v(2mm)
    #table(
    columns: (auto, auto, 1fr, 1fr, auto),
    stroke: none,
    fill: (_, row) => if calc.odd(row) { rgb("#F1F1F1") } else { white },
    table.header(
      [*Dato*], [*Utbetalt til*], align(right)[*Beløp per dag*], align(right)[*Totalbeløp*], align(right)[*Sykmeldt*],
    ),
    ..for linje in linjer {(
      if linje.erOpphørt { strike[#iso_to_date(linje.fom) – #iso_to_date(linje.tom)] } else { [#iso_to_date(linje.fom) – #iso_to_date(linje.tom)] },
      if linje.erOpphørt { strike[#linje.mottaker] } else { [#linje.mottaker] },
      align(right, if linje.erOpphørt { strike[#format_currency(linje.dagsats) kr] } else { [#format_currency(linje.dagsats) kr] }),
      align(right, if not linje.erOpphørt { [#format_currency(linje.totalbeløp) kr] }),
      align(right, if linje.erOpphørt { strike[#str(linje.grad) %] } else { [#str(linje.grad) %] }),
    )},
    )
    #v(4mm)
    #line(length: 100%, stroke: 1pt)
    #v(4mm)
  ]
]

// --- Ikke utbetalte perioder ---

#let ikkeUtbetalteDager = data.at("ikkeUtbetalteDager", default: ())
#if ikkeUtbetalteDager.len() > 0 [
  #block(breakable: false)[
    === Ikke utbetalte perioder
    #v(2mm)
    #table(
    columns: (auto, 1fr),
    stroke: none,
    fill: (_, row) => if calc.odd(row) { rgb("#F1F1F1") } else { white },
    table.header(
      [*Dato*], [*Merknad*],
    ),
    ..for dag in ikkeUtbetalteDager {(
      [#iso_to_date(dag.fom) – #iso_to_date(dag.tom)],
      dag.begrunnelser.join("\n"),
    )},
    )
    #v(4mm)
    #line(length: 100%, stroke: 1pt)
    #v(4mm)
  ]
]

// --- Oppsummering ---

#block(breakable: false)[
== Oppsummering

#grid(
  columns: (1fr),
  column-gutter: 4mm,
  row-gutter: 8mm,
  [
    === Forbrukte dager
    #str(data.forbrukteSykedager)
  ],
  [
    === Dager igjen
    #str(data.dagerIgjen)
  ],
  [
    #if "maksdato" in data [
      === Maksdato
      #iso_to_date(data.maksdato)
    ]
  ],
  [
    === Totalt utbetalt
    #format_currency(data.sumTotalBeløp) kr
  ],
  [
    === Omregnet årsinntekt
    #for ag in data.arbeidsgivere [Orgnr. #ag.organisasjonsnummer: #format_currency(ag.omregnetÅrsinntekt) kr \ ]
  ],
  [
    === Rapportert årsinntekt
    #for ag in data.arbeidsgivere [Orgnr. #ag.organisasjonsnummer: #format_currency(ag.innrapportertÅrsinntekt) kr \ ]
  ],
  ..if "skjønnsfastsettingårsak" in data and data.skjønnsfastsettingårsak != none {([
    === Skjønnsfastsatt årsinntekt
    #for ag in data.arbeidsgivere [Orgnr. #ag.organisasjonsnummer: #format_currency(ag.skjønnsfastsatt) kr \ ]
  ],)},
  [
    === Utregnet avvik
    #str(data.avviksprosent) %
  ],
  [
    === Sykepengegrunnlag
    #format_currency(data.sykepengegrunnlag) kr
  ],
)
    #v(4mm)
    #line(length: 100%, stroke: 1pt)
    #v(4mm)
] // end oppsummering block

// --- Skjønnsfastsettelse ---

#if "skjønnsfastsettingårsak" in data and data.skjønnsfastsettingårsak != none [
  #block(breakable: false)[
    == Sykepengegrunnlaget er skjønnsfastsatt

  #grid(
    columns: (1fr),
    column-gutter: 4mm,
    row-gutter: 8mm,
    [
      === Årsak
      #data.skjønnsfastsettingårsak
    ],
      ..if "skjønnsfastsettingtype" in data and data.skjønnsfastsettingtype != none {([
        === Type skjønnsfastsettelse
        #data.skjønnsfastsettingtype
      ],)},
    ..if "begrunnelseFraMal" in begrunnelser {([
      === Begrunnelse
      #begrunnelser.begrunnelseFraMal
    ],)},
    ..if "begrunnelseFraFritekst" in begrunnelser {([
      === Begrunnelse fra saksbehandler
      #begrunnelser.begrunnelseFraFritekst
    ],)},
    ..if "begrunnelseFraKonklusjon" in begrunnelser {([
      === Konklusjon
      #begrunnelser.begrunnelseFraKonklusjon
    ],)},
  )
  ]
]

