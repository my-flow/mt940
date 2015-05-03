defmodule ParserTest do
  use ExUnit.Case
  use MT940


  test "short name of account owner" do
    assert [":20:": "TELEWIZORY S.A."] == ":20:TELEWIZORY S.A." |> parse
  end


  test "account identification option A with IBAN" do
    assert [":25:": {"PL25106000760000888888888888"}] == ":25:PL25106000760000888888888888" |> parse
  end


  test "account identification option B with 8 chars BIC" do
    assert [":25:": {"BPHKPLPK", "320000546101"}] == ":25:BPHKPLPK/320000546101" |> parse
  end


  test "account identification option B with 8 digits bank code" do
    assert [":25:": {"20041111", "301086000"}] == ":25:20041111/301086000" |> parse
  end


  test "account identification option B with 8 digits bank code and currency" do
    assert [":25:": {"20041111", "301086000", "EUR"}] == ":25:20041111/301086000EUR" |> parse
  end


  test "account identification option B with 8 digits bank code and currency and new line" do
    assert [":25:": {"20041111", "301086000", "EUR"}] == ":25:20041111/301086000EUR\r\n" |> parse
  end


  test "Statement Number/Sequence Number" do
    assert [":28C:": {84, 1}] == ":28C:00084/001" |> parse
  end


  test "Opening balance" do
    assert [":60F:": {"C", "031002", "PLN", "40000,00"}] == ":60F:C031002PLN40000,00" |> parse
  end


  test "Opening balance with new line" do
    assert [":60F:": {"C", "150401", "EUR", "2446,61"}] == ":60F:C150401EUR2446,61\r\n" |> parse
  end

end
