defmodule MT940.Summary do
  @moduledoc ~S"""
  ##  Number and Sum of Entries

  Number of transactions, currency, total of debits/credits
  """

  import Helper

  defstruct [
    :modifier,
    :content,
    :count,
    :sign,
    :currency,
    :amount
  ]

  @type t :: %__MODULE__{}

  use MT940.Field

  defp parse_content(result = %__MODULE__{modifier: modifier, content: content}) do

    [count, currency, amount] = ~r/^(\d*)(\w{3})([0-9,]{1,15})$/
    |> Regex.run(content, capture: :all_but_first)
    |> List.update_at(2, &convert_to_decimal(&1))

    count = with "" <- count, do: 0

    sign = case modifier do
      "D" -> :debit
      _   -> :credit
    end

    %__MODULE__{result | count: count, sign: sign, currency: currency, amount: amount}
  end
end
