defmodule MT940.TagHandler do
  @moduledoc false

  import Helper
  use Timex


  def split(":20:", content, line_separator) do
    MT940.Job.new content, line_separator
  end


  def split(":21:", content, line_separator) do
    MT940.Reference.new content, line_separator
  end


  def split(":25:", content, line_separator) do
    MT940.Account.new content, line_separator
  end


  def split(":28:", content, line_separator) do
    MT940.Statement.new content, line_separator
  end


  def split(":28C:", content, line_separator) do
    MT940.Statement.new "C", content, line_separator
  end


  def split(":60" <> <<modifier>> <> ":", content, line_separator) do
    MT940.AccountBalance.new <<modifier>>, content, line_separator
  end


  def split(":61:", content, line_separator) do
    MT940.StatementLine.new content, line_separator
  end


  def split(":62" <> <<modifier>> <> ":", content, line_separator) do
    MT940.ClosingBalance.new <<modifier>>, content, line_separator
  end


  def split(":64:", content, line_separator) do
    MT940.ValutaBalance.new content, line_separator
  end


  def split(":65:", content, line_separator) do
    MT940.FutureValutaBalance.new content, line_separator
  end


  def split(":86:", content, line_separator) do
    MT940.StatementLineInformation.new content, line_separator
  end
end
