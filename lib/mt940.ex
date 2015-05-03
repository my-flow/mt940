defmodule MT940 do

  defmacro __using__(_) do
    quote do
      import MT940.Parser
    end
  end

end
