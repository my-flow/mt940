ExUnit.start()

defimpl JSX.Encoder, for: [MT940.StatementLine, MT940.AccountBalance, MT940.ClosingBalance,
    MT940.FutureValutaBalance, MT940.ValutaBalance] do
  use Timex

  def json(d) do
    d = case d do
      %{date: date} when date != nil ->
        %{d | date: date |> Timex.format!("{ISO}")}
      _ ->
        d
    end

    d = case d do
      %{value_date: value_date} when value_date != nil ->
        %{d | value_date: value_date |> Timex.format!("{ISO}")}
      _ ->
        d
    end

    d = case d do
      %{entry_date: entry_date} when entry_date != nil ->
        %{d | entry_date: entry_date |> Timex.format!("{ISO}")}
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
