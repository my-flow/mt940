defmodule MT940.Statement do
  import Helper

  defstruct [
    :modifier,
    :content,
    :number,
    :sheet
  ]

  use MT940.Field

  defp parse_content(result = %__MODULE__{content: content}, line_separator) do
    matches = ~r/^(\d+)\/?(\d+)?$/
    |> Regex.run(content |> remove_newline!(line_separator), capture: :all_but_first)
    |> Enum.map(&String.to_integer/1)

    case matches do
      [number, sheet] -> %__MODULE__{result | number: number, sheet: sheet}
      [sheet]         -> %__MODULE__{result | sheet: sheet}
    end
  end
end
