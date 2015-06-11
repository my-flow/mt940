defmodule ParserTest do
  use ExUnit.Case
  import MT940.Parser
  use Timex


  test "invalid format, no key found" do
    assert {:error, :badarg} == "asdfghjkl" |> parse
    assert_raise ArgumentError, fn -> "asdfghjkl" |> parse! end
  end


  test "invalid format, key does not match expected length" do
    assert {:error, :badarg} == ":20STARTUMS:25:74061813/0100033626" |> parse
    assert_raise ArgumentError, fn -> ":20STARTUMS:25:74061813/0100033626" |> parse! end
  end
end
