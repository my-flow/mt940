defmodule UnexpectedStructureError do
  defexception expected: nil, actual: nil

  def message(exception) do
    "Unexpected Structure; expected #{inspect(exception.expected)},
      but was #{inspect exception.actual}"
  end

  def exception(arg) do
    super(arg)
  end
end
