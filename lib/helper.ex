defmodule Helper do
  @moduledoc false

  def convert_to_decimal(amount) when is_binary(amount) do
    amount |> String.replace(",", ".") |> Decimal.new
  end
end
