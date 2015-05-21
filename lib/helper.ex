defmodule Helper do
  @moduledoc false

  def convert_to_decimal(amount) when is_binary(amount) do
    amount |> String.replace(",", ".") |> Decimal.new
  end


  def remove_newline!(string, line_separator) when is_binary(string) do
    Regex.compile!(line_separator) |> Regex.replace(string, "")
  end
end
