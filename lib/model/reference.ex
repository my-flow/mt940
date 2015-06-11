defmodule MT940.Reference do

  @moduledoc ~S"""
  ## Related Reference

  If the MT940 is sent in response to an MT920 request message, this field must
  contain the field 20 transaction reference number of the request message.
  """

  defstruct [
    :modifier,
    :content,
    :reference
  ]

  @type t :: %__MODULE__{}

  use MT940.Field

  defp parse_content(result = %__MODULE__{content: content}, _) do
    %__MODULE__{result | reference: content}
  end

end
