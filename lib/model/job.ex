defmodule MT940.Job do
  @moduledoc ~S"""
  ## Transaction Reference Number

  Used by the Sender to unambiguously identify the message.
  """

  defstruct [
    :modifier,
    :content,
    :reference
  ]

  @type t :: %__MODULE__{}

  use MT940.Field

  defp parse_content(result = %__MODULE__{content: content}) do
    %__MODULE__{result | reference: content}
  end
end
