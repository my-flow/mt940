defmodule CustomerStatementMessageTest do
  use ExUnit.Case
  use MT940
  use Timex


  setup do
    messages = [File.cwd!, "test", "fixtures", "sepa_snippet.sta"]
    |> Path.join
    |> parse_file!
    {:ok, [messages: messages, message: messages |> Enum.at(0), message_2: messages |> Enum.at(-1)]}
  end


  test "it should know the bank code", context do
    assert "50880050" == context[:message].bank_code
  end


  test "it should know the account number", context do
    assert "0194787400888", context[:message].account_number
  end


  test "it should have statement lines", context do
    assert 4 == context[:message].statement_lines |> Enum.count
  end

  test "statement lines should have amount info credit", context do
    line = context[:message].statement_lines |> Enum.at(0)
    assert Decimal.new("50990.05") == line.amount
    assert :credit == line.funds_code
  end


  test "statement lines should have amount info debit", context do
    line = context[:message_2].statement_lines |> Enum.at(0)
    assert Decimal.new("0.08") == line.amount
    assert :debit == line.funds_code
  end


  test "statement lines should have account holder", context do
    line = context[:message].statement_lines |> Enum.at(0)
    assert ["KARL", "KAUFMANN"] == line.account_holder
  end


  test "statement lines info should have bank_code", context do
    line = context[:message].statement_lines |> Enum.at(0)
    assert "DRESDEFF508" = line.bank_code
  end


  test "statement lines info should have account number", context do
    line = context[:message].statement_lines |> Enum.at(0)
    assert "DE14508800500194785000" == line.account_number
  end


  test "statement lines should have details", context do
    line = context[:message].statement_lines |> Enum.at(0)
    assert "EREF+EndToEndId TFNR 22 00400001SVWZ+Verw CTSc-01 BC-PPP TFNr 22 004" == line.details |> Enum.join
  end


  test "statement lines should have an entry_date", context do
    line = context[:message].statement_lines |> Enum.at(0)
    assert Timex.equal?(~D[2007-09-04], line.entry_date)
  end


  test "statement lines should have a value date", context do
    line = context[:message].statement_lines |> Enum.at(0)
    assert Timex.equal?(~D[2007-09-07], line.value_date)
  end


  test "parsing the file should return two message objects", context do
    assert 2 == context[:messages] |> Enum.count
    assert "0194787400888" == context[:message].account_number
    assert "0194791600888" == context[:message_2].account_number
  end


  test "parsing a file with broken structure should raise an exception" do
    filenames = [
      "sepa_snippet_broken.sta",
      "sepa_snippet_broken_2.sta",
      "sepa_snippet_broken_3.sta",
      "sepa_snippet_broken_4.sta"
    ]

    filenames
    |> Enum.map(fn filename ->
      fn ->
        [File.cwd!, "test", "fixtures", filename]
        |> Path.join
        |> parse_file!
      end
    end)
    |> Enum.each(&assert_raise(UnexpectedStructureError, &1))
  end


  test "should raise key error when asking statement lines for unknown stuff" do
    f = fn ->
      statement_line_bundle =
      [File.cwd!, "test", "fixtures", "sepa_snippet.sta"]
      |> Path.join
      |> parse_file!
      |> Enum.at(0)
      |> MT940.CustomerStatementMessage.statement_lines
      |> Enum.at(0)

      statement_line_bundle.foo
    end

    assert_raise(KeyError, f)
  end

end
