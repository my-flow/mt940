defmodule MT940.FloorLimit do
  @moduledoc ~S"""
  ## Floor Limit Indicator

  Floor Limit indicator specifies the minimum value an order must have to be individually delivered.
  """

  import Helper

  defstruct [
    :modifier,
    :content,
    :sign,
    :currency,
    :amount,
  ]

  @type t :: %__MODULE__{}

  use MT940.Field

  defp parse_content(result = %__MODULE__{content: content}) do

    [currency, sign, amount] = ~r/^(\w{3})(.?)([0-9,]{2,15})$/
    |> Regex.run(content, capture: :all_but_first)
    |> List.update_at(2, &convert_to_decimal(&1))

    sign = case sign do
      "D" -> :debit
      _   -> :credit
    end

    %__MODULE__{result | sign: sign, currency: currency, amount: amount}
  end
end
