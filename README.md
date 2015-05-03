MT940 parser for Elixir
=======================

[![Build Status](https://travis-ci.org/my-flow/mt940.svg?branch=master)](https://travis-ci.org/my-flow/mt940)

MT940 is a standard structured SWIFT Customer Statement message. In short, it
is an electronic bank account statement which has been developed by SWIFT. It
is a end of day statement file which details all entries booked to an account.


## Basic usage

Include a dependency in your `mix.exs`:

```elixir
deps: [{:mt940, "~> 0.1.0"}, ...]
```

`use MT940` and `parse` the raw input:

```
":20:TELEWIZORY S.A.
:25:BPHKPLPK/320000546101
:28C:00084/001
:60F:C031002PLN40000,00
:61:0310201020C20000,00FMSCNONREF//8327000090031789
Card transaction
:86:020?00Wyplata-(dysp/przel)?2008106000760000777777777777?2115617? 22INFO INFO INFO INFO INFO INFO 1 END?23INFO INFO INFO INFO INFO INFO 2 END?24ZAPLATA ZA FABRYKATY DO TUB?25 - 200 S ZTUK, TRANZY STORY-?26300 SZT GR544 I OPORNIKI-5?2700 SZT GTX847 FAKTURA 333/ 2?28003.?3010600076?310000777777777777?32HUTA SZKLA TOPIC UL PRZEMY?33SLOWA 67 32-669 WROCLAW?38PL081060007600007777777
77777
:62F:C020325PLN50040,00"
iex(2)> use MT940
nil
iex(3)> parse raw
[":20:": "TELEWIZORY S.A.", ":25:": {"BPHKPLPK", "320000546101"},
 ":28C:": {84, 1}, ":60F:": {"C", "031002", "PLN", "40000,00"},
 ":61:": ["031020", "1020", "C", "", "20000,00", "FMSC", "NONREF", "//",
  "8327000090031789", "\n", "Card transaction"],
 ":86:": {"020",
  #HashDict<[{20, "08106000760000777777777777"}, {28, "003."},
   {21, "15617? 22INFO INFO INFO INFO INFO INFO 1 END"},
   {25, " - 200 S ZTUK, TRANZY STORY-"}, {27, "00 SZT GTX847 FAKTURA 333/ 2"},
   {32, "HUTA SZKLA TOPIC UL PRZEMY"}, {0, "Wyplata-(dysp/przel)"},
   {24, "ZAPLATA ZA FABRYKATY DO TUB"}, {26, "300 SZT GR544 I OPORNIKI-5"},
   {38, "PL08106000760000777777777777"}, {33, "SLOWA 67 32-669 WROCLAW"},
   {30, "10600076"}, {31, "0000777777777777"},
   {23, "INFO INFO INFO INFO INFO INFO 2 END"}]>},
 ":62F:": {"C", "020325", "PLN", "50040,00"}]
```


## Copyright & License

Copyright (c) 2015 [Florian J. Breunig](http://www.my-flow.com)

Licensed under MIT, see LICENSE file.
