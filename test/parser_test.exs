defmodule ParserTest do
  use ExUnit.Case
  use MT940
  use Timex


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


  test "statement number" do
    assert [":28C:": {1}] === ":28C:1" |> parse
  end


  test "statement number/sequence number" do
    assert [":28C:": {84, 1}] == ":28C:00084/001" |> parse
  end


  test "field 28 (replaces 28C)" do
    assert [":28:": {35401, 1}] == ":28:35401/1" |> parse
  end


  test "opening balance" do
    assert [":60F:": {"C", Date.from({2003, 10, 2}), "PLN", "40000,00"}] == ":60F:C031002PLN40000,00" |> parse
  end


  test "opening balance with new line" do
    assert [":60F:": {"C", Date.from({2015, 4, 1}), "EUR", "2446,61"}] == ":60F:C150401EUR2446,61\r\n" |> parse
  end

  test "non ref" do
    assert [":61:": {Date.from({2009, 12, 11}), "", "D", "", ",60", "N913", "NONREF", "", "", "", ""}] ==
      ":61:091211D000000000000,60N913NONREF\n" |> parse
  end


  test "missing booking date" do
    assert [":61:": {Date.from({2009, 12, 10}), "", "C", "", "7,50", "N021", "117301582", "", "", "", ""}] ==
      ":61:091210C000000000007,50N021117301582" |> parse
  end


  test "existing booking date" do
    assert [":61:": {Date.from({2009, 12, 10}), Date.from({2009, 12, 10}), "C", "", "7,50", "N021", "117301582", "", "", "", ""}] ==
      ":61:0912101210C000000000007,50N021117301582" |> parse
  end


  test "short amount" do
    assert [":61:": {Date.from({2007, 12, 21}), Date.from({2007, 12, 20}), "C", "", "4,", "N196", "NONREF", "", "", "", ""}] ==
      ":61:0712211220C4,N196NONREF" |> parse
  end


  test "last statement" do
    assert [":62F:": {"D", Date.from({2009, 12, 20}), "EUR", "160,00"}] == ":62F:D091220EUR000000000160,00" |> parse
  end


  test "unstructured account owner" do
    assert [":86:": "MultiSafepay ID : 10269 (Direct Debit)"] == ":86:MultiSafepay ID : 10269 (Direct Debit)" |> parse
  end


  test "duplicate spaces" do
    assert [":86:": "GEA NR 001732 19.12.07/18.51 POSTBANK NIJMEGEN GWK,PAS555"] ==
      ":86:GEA   NR 001732   19.12.07/18.51\r\n  POSTBANK NIJMEGEN GWK,PAS555 " |> parse
  end
end
