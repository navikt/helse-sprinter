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
  let n = float(amount)
  let negative = n < 0
  let abs_n = calc.abs(n)
  let integer_part = int(abs_n)
  let decimal_part = int(calc.round(abs_n * 100) - integer_part * 100)
  let s = str(integer_part)
  let len = s.len()
  let result = ""
  for i in range(len) {
    if i > 0 and calc.rem(len - i, 3) == 0 { result += " " }
    result += s.at(i)
  }
  result += "," + if decimal_part < 10 { "0" + str(decimal_part) } else { str(decimal_part) }
  if negative { "-" + result } else { result }
}
