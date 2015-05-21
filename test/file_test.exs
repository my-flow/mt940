defmodule FileTest do
  use ExUnit.Case
  use MT940
  use Timex
  import MT940.Account

  setup do
    dict = [File.cwd!, "test", "fixtures"]
    |> Path.join
    |> File.ls!
    |> Stream.filter_map(&Regex.match?(~r/\.sta$/, &1), &read/1)
    |> Dict.merge(HashDict.new)
    {:ok, dict}
  end


  defp read(filename) when is_binary(filename) do
    binary = [File.cwd!, "test", "fixtures", filename]
    |> Path.join
    |> File.read!
    {String.to_atom(filename), binary}
  end


  test "read primae notae sets from file", context do
    messages = context[:"transactions.sta"] |> parse!
    assert 6 == messages |> Enum.count
    assert 10 == context[:"transactions.sta"] |> transactions |> Enum.count
    assert "25.69 EUR" == context[:"transactions.sta"] |> balance
  end


  test "with binary character", context do
    messages = context[:"with_binary_character.sta"] |> parse!
    assert 2 == messages |> Enum.count
    assert 4 == context[:"with_binary_character.sta"] |> transactions |> Enum.count
    assert "131193.19 EUR" == context[:"with_binary_character.sta"] |> balance
  end


  test "amount formats", context do
    messages = context[:"amount_formats.sta"] |> parse!
    assert 1 == messages |> Enum.count
    assert {:":60F:", {"C", Date.from({2010, 03, 18}), "EUR", Decimal.new("380115.12")}} == messages |> Enum.at(0) |> Enum.at(0)
    assert {:":60F:", {"C", Date.from({2010, 03, 18}), "EUR", Decimal.new("380115.1")}}  == messages |> Enum.at(0) |> Enum.at(1)
    assert {:":60F:", {"C", Date.from({2010, 03, 18}), "EUR", Decimal.new("380115")}}    == messages |> Enum.at(0) |> Enum.at(2)
    assert {:":60F:", {"C", Date.from({2010, 03, 18}), "EUR", Decimal.new("0.12")}}      == messages |> Enum.at(0) |> Enum.at(3)
    assert {:":60F:", {"C", Date.from({2010, 03, 18}), "EUR", Decimal.new("0.12")}}      == messages |> Enum.at(0) |> Enum.at(4)
    assert {:":60F:", {"C", Date.from({2010, 03, 18}), "EUR", Decimal.new("1.12")}}      == messages |> Enum.at(0) |> Enum.at(5)
  end


  test "currency in 25", context do
    messages = context[:"currency_in_25.sta"] |> parse!
    assert 1 == messages |> Enum.count
    assert {:":25:", {"51210600", "9223382012", "EUR"}} == messages |> Enum.at(0) |> Enum.at(0)
  end


  test "empty 86", context do
    messages = context[:"empty_86.sta"] |> parse!
    assert 1 == messages |> Enum.count
    assert {:":86:", "091"} == messages |> Enum.at(0) |> Enum.at(0)
  end


  test "empty entry date", context do
    messages = context[:"empty_entry_date.sta"] |> parse!
    assert 1 == messages |> Enum.count
    assert {:":61:", {Date.from({2011, 7, 1}), "", "C", "N", Decimal.new("50.00"), "NZ10", "NONREF", "", "", "", ""}} == messages |> Enum.at(0) |> Enum.at(0)
  end


  test "empty line", context do
    messages = context[:"empty_line.sta"] |> parse!
    assert 1 == messages |> Enum.count
    assert {:":20:", "TELEREPORTING"} == messages |> Enum.at(0) |> Enum.at(0)
  end


  test "missing CRLF at end", context do
    messages = context[:"missing_crlf_at_end.sta"] |> parse!
    assert 1 == messages |> Enum.count
    assert {:":62F:", {"C", Date.from({2010, 3, 23}), "EUR", Decimal.new("42570.04")}} == messages |> Enum.at(0) |> Enum.at(0)
  end
end
