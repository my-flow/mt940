defmodule MT940 do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      import MT940.CustomerStatementMessage
    end
  end

end
