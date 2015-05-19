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
    assert 6 == context[:"transactions.sta"] |> parse! |> Enum.count
    assert 10 == context[:"transactions.sta"] |> transactions |> Enum.count
    assert "25.69 EUR" == context[:"transactions.sta"] |> balance
  end


  test "with binary character", context do
    assert 2 == context[:"with_binary_character.sta"] |> parse! |> Enum.count
    assert 4 == context[:"with_binary_character.sta"] |> transactions |> Enum.count
    assert "131193.19 EUR" == context[:"with_binary_character.sta"] |> balance
  end


  test "amount formats", context do
    message = context[:"amount_formats.sta"] |> parse! |> Enum.at(0)
    assert {:":60F:", {"C", Date.from({2010, 03, 18}), "EUR", Decimal.new("380115.12")}} == message |> Enum.at(0)
    assert {:":60F:", {"C", Date.from({2010, 03, 18}), "EUR", Decimal.new("380115.1")}}  == message |> Enum.at(1)
    assert {:":60F:", {"C", Date.from({2010, 03, 18}), "EUR", Decimal.new("380115")}}    == message |> Enum.at(2)
    assert {:":60F:", {"C", Date.from({2010, 03, 18}), "EUR", Decimal.new("0.12")}}      == message |> Enum.at(3)
    assert {:":60F:", {"C", Date.from({2010, 03, 18}), "EUR", Decimal.new("0.12")}}      == message |> Enum.at(4)
    assert {:":60F:", {"C", Date.from({2010, 03, 18}), "EUR", Decimal.new("1.12")}}      == message |> Enum.at(5)
  end
end
