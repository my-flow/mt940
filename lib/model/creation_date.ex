defmodule MT940.CreationDate do
  @moduledoc ~S"""
  ## Date Time Indication

  Date and time at which a message arrives or is created at the bank.
  """

  defstruct [
    :modifier,
    :content,
    :date
  ]

  @type t :: %__MODULE__{}

  use MT940.Field
  use Timex

  defp parse_content(result = %__MODULE__{content: content}) do

    res = with {:ok, dateTime} <- content |> Timex.parse("%y%m%d%H%M%z", :strftime),
                  do: dateTime

    date =   with {:error, _} <- res,
                  {:ok, dateTime} <- content |> Timex.parse("%y%m%d%H%M", :strftime),
                  do: dateTime

    %__MODULE__{result | date: date}
  end
end
