ExUnit.start()

defimpl JSX.Encoder, for: [MT940.StatementLine, MT940.AccountBalance, MT940.ClosingBalance,
    MT940.FutureValutaBalance, MT940.ValutaBalance] do
  use Timex

  def json(d) do
    d = case d do
      %{date: date} when date != nil ->
        %{d | date: date |> DateFormat.format!("{ISO}")}
      _ ->
        d
    end

    d = case d do
      %{value_date: value_date} when value_date != nil ->
        %{d | value_date: value_date |> DateFormat.format!("{ISO}")}
      _ ->
        d
    end

    d = case d do
      %{entry_date: entry_date} when entry_date != nil ->
        %{d | entry_date: entry_date |> DateFormat.format!("{ISO}")}
      _ ->
        d
    end

    d = case d do
      %{amount: amount} when amount != nil ->
        %{d | amount: amount |> to_string}
      _ ->
        d
    end

    d
    |> Map.from_struct
    |> JSX.Encoder.json
  end
end


defmodule MT940.AccountHelper do
  use Timex

  def balance(raw) when is_binary(raw) do
    %{amount: amount, currency: currency} = raw
    |> MT940.Parser.parse!
    |> Enum.at(-1)
    |> Enum.filter(fn
      %MT940.ClosingBalance{} -> true
      _ -> false
    end)
    |> Enum.at(0)

    "#{amount} #{currency}"
  end


  def transactions(raw) when is_binary(raw) do
    raw
    |> MT940.Parser.parse!
    |> Stream.flat_map(&Stream.filter(&1, fn 
      %MT940.StatementLine{} -> true
      %MT940.StatementLineInformation{} -> true
      _ -> false
    end))
    |> Stream.chunk(2)
    |> Enum.map(fn [%MT940.StatementLine{value_date: value_date, amount: amount}, %MT940.StatementLineInformation{details: details}] ->
      %{
        booking_date: value_date |> DateFormat.format!("{ISO}"),
        amount:       amount  |> to_string,
        purpose:      details |> Enum.join
      }
    end)
  end
end


