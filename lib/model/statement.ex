defmodule MT940.Statement do
  @moduledoc ~S"""
  ## Statement Number / Sequence Number

  Sequential number of the statement, optionally followed by the sequence
  number of the message within that statement when more than one message is
  sent for one statement.
  """

  defstruct [
    :modifier,
    :content,
    :number,
    :sheet
  ]

  @type t :: %__MODULE__{}

  use MT940.Field

  defp parse_content(result = %__MODULE__{content: content}) do
    matches = ~r/^(\d+)\/?(\d+)?$/
    |> Regex.run(content, capture: :all_but_first)
    |> Enum.map(&String.to_integer/1)

    case matches do
      [number, sheet] -> %__MODULE__{result | number: number, sheet: sheet}
      [sheet]         -> %__MODULE__{result | sheet: sheet}
    end
  end
end
