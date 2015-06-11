defmodule FileTest do
  use ExUnit.Case
  use Timex
  import MT940.AccountHelper

  test "it should parse fixture files correctly" do
    ""
    |> build_path!
    |> File.ls!
    |> Stream.filter(&Regex.match?(~r/\.sta$/, &1))
    |> Stream.filter(fn filename -> ~r/sta$/ |> Regex.replace(filename, "json") |> build_path! |> File.exists? end)
    |> Enum.each(&compare!/1)
  end


  defp compare!(filename) when is_binary(filename) do
    binary = filename
    |> read!
    |> MT940.Parser.parse!
    |> JSX.encode!

    json = ~r/sta$/
    |> Regex.replace(filename, "json")
    |> read!
    |> JSX.decode!
    |> JSX.encode!

    assert json == binary
  end


  defp read!(filename) when is_binary(filename) do
    filename
    |> build_path!
    |> File.read!
  end


  defp build_path!(filename) when is_binary(filename) do
    [File.cwd!, "test", "fixtures", filename]
    |> Path.join
  end


  test "read primae notae sets from file" do
    raw = "transactions.sta" |> read!
    messages = raw |> MT940.Parser.parse!
    assert 6 == messages |> Enum.count
    assert 10 == raw |> transactions |> Enum.count
    assert "25.69 EUR" == raw |> balance
  end


  test "with binary character" do
    raw = "with_binary_character.sta" |> read!
    messages = raw |> MT940.Parser.parse!
    assert 2 == messages |> Enum.count
    assert 4 == raw |> transactions |> Enum.count
    assert "131193.19 EUR" == raw |> balance
  end
end
