# Sprinter

Genererer pdf-filer med [pdfgenrs](https://github.com/navikt/pdfgenrs).

`pdfgenrs` bruker [Typst](https://typst.app/) som templating engine. 

## Kom i gang

### Lag nye pdf-er
For å lage en ny pdf, må du først opprette et typst template. Det gjør du ved å opprette en mappe for appen du skal
generere pdf for, og deretter lager en `.typ`-fil i den mappen. Se i `templates`-mappen for eksempler på hvordan det kan se ut.


Deretter må du opprette en json-fil med testdata i `data`-mappen, som brukes når du kjører opp applikasjonen lokalt. Se i `data`-mappen for eksempler på hvordan det kan se ut.
Json-strukturen du lager her vil på sett og vis definere strukturen man forventer å få i `POST` requests til appen i produksjon for den aktuelle pdf-en.

### Kjør i utviklingsmodus

Kjør skriptet `run_development.sh` for å kjøre applikasjonen lokalt. Scriptet starter applikasjonen og genererer deretter
alle pdf-er det finnes templates _og_ testdata for.

## Henvendelser

Spørsmål knyttet til koden eller prosjektet kan stilles som issues her på GitHub.

Interne henvendelser kan sendes via Slack i kanalen [#helseytelser](https://nav-it.slack.com/archives/CD1KVMPJ6).
