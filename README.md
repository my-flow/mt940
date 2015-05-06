MT940 parser for Elixir
=======================

[![Build Status](https://travis-ci.org/my-flow/mt940.svg?branch=master)](https://travis-ci.org/my-flow/mt940)
[![Hex.pm](https://img.shields.io/hexpm/v/mt940.svg?style=flat-square)](https://hex.pm/packages/mt940)

MT940 is a standard structured SWIFT Customer Statement message. In short, it
is an electronic bank account statement which has been developed by SWIFT. It
is a end of day statement file which details all entries booked to an account.


## Basic usage

Include a dependency in your `mix.exs`:

```elixir
deps: [{:mt940, "~> 0.2.0"}, ...]
```

`use MT940` and `parse` the raw input:

```elixir
defmodule Account do
  use MT940


  def balance(raw) do
    {_, _, currency, amount} = parse(raw) |> Enum.at(-1) |> Dict.get(:":62F:")
    "#{amount} #{currency}"
  end


  def transactions(raw) do
    parse(raw)
    |> Stream.flat_map(&Keyword.take(&1, [:":61:", :":86:"]))
    |> Stream.map(fn {_, v} -> v end)
    |> Stream.chunk(2)
    |> Enum.map(fn [{booking_date, _, _, _, amount, _, _, _, _, _, _}, {_, info}] ->

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


## Copyright & License

Copyright (c) 2015 [Florian J. Breunig](http://www.my-flow.com)

Licensed under MIT, see LICENSE file.
