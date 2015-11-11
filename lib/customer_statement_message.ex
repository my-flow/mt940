defmodule MT940.CustomerStatementMessage do
  @moduledoc ~S"""

  This is a beautification wrapper around the low-level `MT940.Parser.parse!`
  command. Use it in order to make dealing with data easier.
  """

  require Record

  Record.defrecordp :message, __MODULE__,
    account: nil,
    statement_lines: [],
    closing_balance: nil

  @spec parse_file!(binary) :: list
  def parse_file!(filename) when is_binary(filename) do
    filename
    |> File.read!
    |> parse!
  end


  @spec parse!(binary) :: list
  def parse!(data) when is_binary(data) do
    data
    |> MT940.Parser.parse!
    |> Enum.map(&new/1)
  end


  defp new(lines) do
    account = lines
    |> Stream.filter(fn
      %MT940.Account{} -> true
      _ -> false
    end)
    |> Enum.at(0)

    lines |> ensure_structure!

    statement_lines = lines
    |> Stream.filter(fn 
      %MT940.StatementLine{} -> true
      %MT940.StatementLineInformation{} -> true
      _ -> false
    end)
    |> Enum.chunk(2)
    |> Enum.map(&MT940.StatementLineBundle.new(&1 |> Enum.at(0), &1 |> Enum.at(1)))

    closing_balance = lines
    |> Stream.filter(fn
      %MT940.ClosingBalance{} -> true
      _ -> false
    end)
    |> Enum.at(-1)

    message(
      account: account,
      statement_lines: statement_lines,
      closing_balance: closing_balance
    )
  end


  def bank_code(message(account: account)) do
    account.bank_code
  end


  def account_number(message(account: account)) do
    account.account_number
  end


  def statement_lines(message(statement_lines: statement_lines)) do
    statement_lines
  end


  def closing_balance(message(closing_balance: closing_balance)) do
    closing_balance
  end


  defp ensure_structure!([%MT940.StatementLine{}, %MT940.StatementLineInformation{} | lines]) do
    ensure_structure!(lines)
  end


  defp ensure_structure!([%MT940.StatementLine{}, t2 | _]) do
    raise UnexpectedStructureError, expected: MT940.StatementLineInformation, actual: t2.__struct__
  end


  defp ensure_structure!([%MT940.StatementLine{}]) do
    raise UnexpectedStructureError, expected: MT940.StatementLineInformation, actual: "(none)"
  end


  defp ensure_structure!([t1, %MT940.StatementLineInformation{} | _]) do
    raise UnexpectedStructureError, expected: MT940.StatementLine, actual: t1.__struct__
  end


  defp ensure_structure!([%MT940.StatementLineInformation{} | _]) do
    raise UnexpectedStructureError, expected: MT940.StatementLine, actual: nil
  end


  defp ensure_structure!([_ | lines]) do
    ensure_structure!(lines)
  end


  defp ensure_structure!([]) do
  end
end
