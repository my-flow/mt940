defmodule FileTest do
  use ExUnit.Case
  use MT940
  import MT940.Account

  setup do
    {:ok, binary} = [File.cwd!, "test", "fixtures", "transactions.sta"] |> Path.join |> File.read
    {:ok, [binary: binary]}
  end


  test "read primae notae sets from file", context do
    assert 6 == context[:binary] |> parse! |> Enum.count
  end


  test "read transactions sets from file", context do
    assert 10 == context[:binary] |> transactions |> Enum.count
  end


  test "read balance from file", context do
    assert "25.69 EUR" == context[:binary] |> balance
  end
end
