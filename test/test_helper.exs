ExUnit.start()

defimpl JSX.Encoder, for: [MT940.StatementLine, MT940.AccountBalance, MT940.CreationDate,
    MT940.ClosingBalance, MT940.FloorLimit, MT940.FutureValutaBalance, MT940.Summary,
    MT940.ValutaBalance] do
  use Timex

  def json(d) do

    d = with %{date: date} <- d,
        do: %{d | date:       date && date |> Timex.format!("{ISO}")}

    d = with %{value_date: value_date} <- d,
        do: %{d | value_date: value_date && value_date |> Timex.format!("{ISO}")}

    d = with %{entry_date: entry_date} <- d,
        do: %{d | entry_date: entry_date && entry_date |> Timex.format!("{ISO}")}

    d = with %{amount: amount} <- d,
        do: %{d | amount: amount && amount |> to_string}

    d
    |> Map.from_struct
    |> JSX.Encoder.json
  end
end


defmodule MT940.AccountHelper do
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
