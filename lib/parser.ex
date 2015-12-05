defmodule MT940.Parser do
  @moduledoc ~S"""
  This module contains functions to parse SWIFT's MT940 messages.

  ## API

  The `parse` function in this module returns `{:ok, result}`
  in case of success, `{:error, reason}` otherwise. It is also
  followed by a variant that ends with `!` which returns the
  result (without the `{:ok, result}` tuple) in case of success
  or raises an exception in case it fails. For example:

      import MT940.Parser

      parse(":20:TELEWIZORY S.A.")
      #=> {:ok, [[%MT940.Job{content: "TELEWIZORY S.A.", modifier: nil, reference: "TELEWIZORY S.A."}]]}

      parse("invalid")
      #=> {:error, :badarg}

      parse!(":20:TELEWIZORY S.A.")
      #=> [[%MT940.Job{content: "TELEWIZORY S.A.", modifier: nil, reference: "TELEWIZORY S.A."}]]

      parse!("invalid")
      #=> raises ArgumentError

  In general, a developer should use the former in case he wants
  to react if the raw input cannot be parsed. The latter should
  be used when the developer expects his software to fail in case
  the raw input cannot be parsed (i.e. it is literally an exception).
  """


  @doc """
  Returns `{:ok, result}`, where `result` is a list of SWIFT MT940 messages,
  or `{:error, reason}` if an error occurs.

  Typical error reasons:

    * `:badarg`  - the format of the raw input is not MT940
  """
  def parse(raw) when is_binary(raw) do
    line_separator = ~r/^(.*)\:/Us
    |> Regex.run(raw, capture: :all_but_first)

    case line_separator do
      [""|_] -> raw |> split_messages_into_parts("\\R")
      [hd|_] -> raw |> split_messages_into_parts(hd)
      _      -> {:error, :badarg}
    end
  end


  @doc """
  Returns list of SWIFT MT940 messages or raises
  `ArgumentError` if an error occurs.
  """
  def parse!(raw) when is_binary(raw) do
    case parse(raw) do
      {:ok, result}     -> result
      {:error, :badarg} -> raise ArgumentError
      {:error, _}       -> raise RuntimeError
    end
  end


  defp split_messages_into_parts(raw, line_separator)
    when is_binary(raw) and is_binary(line_separator) do

    messages = raw
    |> String.strip
    |> String.split(Regex.compile!("#{line_separator}-(#{line_separator}|$)"), trim: true)
    |> Enum.map(&parse_message(&1, line_separator))

    case messages |> Enum.filter(fn m -> case m do
          {:error, _} -> true
          _           -> false
        end
      end) do
      [hd|_] -> hd
      _      -> {:ok, messages |> Enum.to_list}
    end
  end


  defp parse_message(raw, line_separator) when is_binary(raw) do
    tag = ":\\d{2,2}\\w?:"

    parts = Regex.compile!("#{line_separator}(?!#{tag})")
    |> Regex.replace(raw, "")

    parts = Regex.compile!("#{line_separator}")
    |> Regex.split(parts)
    |> Enum.reject(fn s -> s == "" end)

    case parts |> Enum.all?(fn s -> Regex.compile!("^#{tag}") |> Regex.match?(s) end) do
      true  -> parts |> Enum.map(&Regex.run(Regex.compile!("^(#{tag})(.*)$"), &1, capture: :all_but_first)) |> to_keywords
      false -> {:error, :badarg}
    end
  end


  defp to_keywords(parts) do
    parts
    |> Stream.map(fn [k, v] -> MT940.TagHandler.split(k, v) end)
    |> Enum.to_list
  end
end
