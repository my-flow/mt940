defmodule ParserTest do
  use ExUnit.Case
  use Timex


  test "invalid format, no key found" do
    assert {:error, :badarg} == "asdfghjkl" |> MT940.Parser.parse
    assert_raise ArgumentError, fn -> "asdfghjkl" |> MT940.Parser.parse! end
  end


  test "invalid format, key does not match expected length" do
    assert {:error, :badarg} == ":20STARTUMS:25:74061813/0100033626" |> MT940.Parser.parse
    assert_raise ArgumentError, fn -> ":20STARTUMS:25:74061813/0100033626" |> MT940.Parser.parse! end
  end
end
