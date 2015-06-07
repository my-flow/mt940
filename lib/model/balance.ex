defmodule MT940.Balance do
  @moduledoc false
  use Timex

  defmacro __using__(_) do
    quote do
      import Helper

      defstruct [
        :modifier,
        :content,
        :balance_type,
        :sign,
        :currency,
        :amount,
        :date
      ]

      use MT940.Field

      defp parse_content(result = %__MODULE__{modifier: modifier, content: content}, line_separator) do
        balance_type = case modifier do
          "F" -> :start
          "M" -> :intermediate
          _   -> nil
        end

        [sign, date, currency, amount] = ~r/^(\w{1})(\d{6})(\w{3})([0-9,]{1,15})$/
        |> Regex.run(content |> remove_newline!(line_separator), capture: :all_but_first)
        |> List.update_at(1, &DateFormat.parse!(&1, "{YY}{M}{D}"))
        |> List.update_at(3, &convert_to_decimal(&1))

        sign = case sign do
          "C" -> :credit
          "D" -> :debit
        end

        %__MODULE__{result | balance_type: balance_type, sign: sign, currency: currency, amount: amount, date: date}
      end
    end
  end
end
