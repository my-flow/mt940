MT940 parser for Elixir
=======================

[![Build Status](https://travis-ci.org/my-flow/mt940.svg?branch=master)](https://travis-ci.org/my-flow/mt940)
[![Coverage Status](https://coveralls.io/repos/my-flow/mt940/badge.svg?branch=master)](https://coveralls.io/r/my-flow/mt940?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/mt940.svg)](https://hex.pm/packages/mt940)
[![Inline docs](http://inch-ci.org/github/my-flow/mt940.svg)](http://inch-ci.org/github/my-flow/mt940)

This is a library to parse account statements which are formatted as MT940.
MT940 is a standard structured SWIFT Customer Statement message. It is an
end-of-day statement file which details all entries booked to a bank account.


## Basic usage

Include a dependency in your `mix.exs`:

```elixir
deps: [{:mt940, "~> 0.2.0"}, …]
```

`use MT940` and `parse!` the raw input:

```elixir
defmodule MT940.Account do
  use MT940


  def balance(raw) when is_binary(raw) do
    {_, _, currency, amount} = parse!(raw) |> Enum.at(-1) |> Dict.get(:":62F:")
    "#{amount} #{currency}"
  end


  def transactions(raw) when is_binary(raw) do
    parse!(raw)
    |> Stream.flat_map(&Keyword.take(&1, [:":61:", :":86:"]))
    |> Stream.map(fn {_, v} -> v end)
    |> Stream.chunk(2)
    |> Enum.map(fn [{_, booking_date, _, _, amount, _, _, _, _, _, _}, {_, info}] ->

      %{
        booking_date: booking_date,
        amount:       amount,
        purpose:      info
          |> Dict.take([20..29, 60..63] |> Enum.concat)
          |> Dict.values
          |> Enum.join
      }
    end)
  end

end
```


## Specification

Find the specification in the [MT940 Format Overview](http://www.sepaforcorporates.com/swift-for-corporates/account-statement-mt940-file-format-overview/)
or in the [SWIFT MT 940 Customer Statement Message Report](http://martin.hinner.info/bankconvert/swift_mt940_942.pdf).


## Documentation

API documentation is available at [http://hexdocs.pm/mt940](http://hexdocs.pm/mt940).


## Copyright & License

Copyright (c) 2015 [Florian J. Breunig](http://www.my-flow.com)

Licensed under MIT, see LICENSE file.
