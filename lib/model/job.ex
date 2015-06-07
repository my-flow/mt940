defmodule MT940.Job do

  defstruct [
    :modifier,
    :content,
    :reference
  ]

  use MT940.Field

  defp parse_content(result = %__MODULE__{content: content}, _) do
    %__MODULE__{result | reference: content}
  end
end
