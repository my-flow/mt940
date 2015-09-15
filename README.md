MT940 parser for Elixir
=======================

[![Build Status](https://travis-ci.org/my-flow/mt940.svg?branch=master)](https://travis-ci.org/my-flow/mt940)
[![Coverage Status](https://coveralls.io/repos/my-flow/mt940/badge.svg?branch=master)](https://coveralls.io/r/my-flow/mt940?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/mt940.svg)](https://hex.pm/packages/mt940)
[![Inline docs](http://inch-ci.org/github/my-flow/mt940.svg)](http://inch-ci.org/github/my-flow/mt940)

This is a library to parse MT940 account statements. It was ported from Ruby and is based on
[Thies C. Arntzen's mt940 library](https://github.com/betterplace/mt940_parser).
MT940 is a standard structured customer statement message format developed by SWIFT. It is an
end-of-day statement file which details all entries booked to a bank account.

## Basic usage

Include a dependency in your `mix.exs`:

```elixir
deps: [{:mt940, "~> 0.3.2"}, …]
```

`use MT940` and `parse!` the raw input:

```elixir
defmodule BankAccount do
  use MT940

  def balance(raw) when is_binary(raw) do
    %{amount: amount, currency: currency} = raw
    |> parse!
    |> Enum.at(-1)
    |> MT940.CustomerStatementMessage.closing_balance
    "#{amount} #{currency}"
  end

  def transactions(raw) when is_binary(raw) do
    raw
    |> parse!
    |> Enum.flat_map(&MT940.CustomerStatementMessage.statement_lines/1)
  end
end
```

If you want to have a more detailed, low-level list of MT940 commands, use the
`MT940.Parser.parse!` command.


## Specification

Find the specification in the [MT940 Format Overview](http://www.sepaforcorporates.com/swift-for-corporates/account-statement-mt940-file-format-overview/)
or in the [SWIFT MT 940 Customer Statement Message Report](http://martin.hinner.info/bankconvert/swift_mt940_942.pdf).


## Documentation

API documentation is available at [http://hexdocs.pm/mt940](http://hexdocs.pm/mt940).


## Copyright & License

Copyright (c) 2015 [Florian J. Breunig](http://www.my-flow.com)

Licensed under MIT, see LICENSE file.
