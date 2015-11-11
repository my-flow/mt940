defmodule MT940.TagHandler do
  @moduledoc false

  use Timex


  def split(":20:", content) do
    MT940.Job.new content
  end


  def split(":21:", content) do
    MT940.Reference.new content
  end


  def split(":25:", content) do
    MT940.Account.new content
  end


  def split(":28:", content) do
    MT940.Statement.new content
  end


  def split(":28C:", content) do
    MT940.Statement.new "C", content
  end


  def split(":60" <> <<modifier>> <> ":", content) do
    MT940.AccountBalance.new <<modifier>>, content
  end


  def split(":61:", content) do
    MT940.StatementLine.new content
  end


  def split(":62" <> <<modifier>> <> ":", content) do
    MT940.ClosingBalance.new <<modifier>>, content
  end


  def split(":64:", content) do
    MT940.ValutaBalance.new content
  end


  def split(":65:", content) do
    MT940.FutureValutaBalance.new content
  end


  def split(":86:", content) do
    MT940.StatementLineInformation.new content
  end
end
