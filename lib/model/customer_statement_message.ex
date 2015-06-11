defmodule MT940.CustomerStatementMessage do
  require Record

  @moduledoc ~S"""

  This is a beautification wrapper around the low-level
  MT940.Parser.parse command. use it in order to make dealing with
  the data easier.
  """

  Record.defrecordp :message, __MODULE__, account: nil, statement_lines: []


  def parse_file!(filename) when is_binary(filename) do
    filename
    |> File.read!
    |> parse!
  end


  def parse!(data) when is_binary(data) do
    data
    |> MT940.Parser.parse!
    |> Enum.map(&new(&1))
  end


  defp new(lines) do
    lines
    |> Stream.drop_while(fn 
      %MT940.StatementLine{} -> false
      %MT940.StatementLineInformation{} -> false
      _ -> true
    end)
    |> Stream.chunk(2)
    |> Enum.each(fn
      [%MT940.StatementLine{}, %MT940.StatementLineInformation{}] ->
        true
      [%MT940.StatementLine{}, t2] ->
        raise UnexpectedStructureError, expected: MT940.StatementLineInformation, actual: t2.__struct__
      [t1, %MT940.StatementLineInformation{}] ->
        raise UnexpectedStructureError, expected: MT940.StatementLine, actual: t1.__struct__
      _ ->
        true
    end)

    statement_lines = lines
    |> Stream.filter(fn 
      %MT940.StatementLine{} -> true
      %MT940.StatementLineInformation{} -> true
      _ -> false
    end)
    |> Enum.chunk(2)

    accounts = lines
    |> Stream.filter(fn 
      %MT940.Account{} -> true
      _ -> false
    end)

    message(
      account: accounts |> Enum.at(0),
      statement_lines: statement_lines |> Enum.map(&MT940.StatementLineBundle.new(&1 |> Enum.at(0), &1 |> Enum.at(1)))
    )
  end


  def bank_code(m) when Record.is_record(m) do
    message(m, :account).bank_code
  end


  def account_number(m) when Record.is_record(m) do
    message(m, :account).account_number
  end


  def statement_lines(m) when Record.is_record(m) do
    message(m, :statement_lines)
  end
end
