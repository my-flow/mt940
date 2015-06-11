defmodule MT940.Field do
  @moduledoc false

  defmacro __using__(_) do
    quote do

      @doc false
      def new(modifier \\ nil, content, line_separator) when is_binary(content) do
        parse_content(%__MODULE__{modifier: modifier, content: content}, line_separator)
      end

      defp parse_content(result, _) do
        result
      end

      defoverridable [parse_content: 2]
    end
  end
end
