defmodule MT940.TagHandler do
  @moduledoc false

  alias MT940.Account
  alias MT940.AccountBalance
  alias MT940.ClosingBalance
  alias MT940.CreationDate
  alias MT940.FloorLimit
  alias MT940.FutureValutaBalance
  alias MT940.Job
  alias MT940.Reference
  alias MT940.Statement
  alias MT940.StatementLine
  alias MT940.StatementLineInformation
  alias MT940.Summary
  alias MT940.ValutaBalance

  use Timex


  def split(":13D:", content) do
    CreationDate.new "D", content
  end


  def split(":13:", content) do
    CreationDate.new content
  end


  def split(":20:", content) do
    Job.new content
  end


  def split(":21:", content) do
    Reference.new content
  end


  def split(":25:", content) do
    Account.new content
  end


  def split(":28:", content) do
    Statement.new content
  end


  def split(":28C:", content) do
    Statement.new "C", content
  end


  def split(":34F:", content) do
    FloorLimit.new "F", content
  end


  def split(":60" <> <<modifier>> <> ":", content) do
    AccountBalance.new <<modifier>>, content
  end


  def split(":61:", content) do
    StatementLine.new content
  end


  def split(":62" <> <<modifier>> <> ":", content) do
    ClosingBalance.new <<modifier>>, content
  end


  def split(":64:", content) do
    ValutaBalance.new content
  end


  def split(":65:", content) do
    FutureValutaBalance.new content
  end


  def split(":86:", content) do
    StatementLineInformation.new content
  end


  def split(":90" <> <<modifier>> <> ":", content) do
    Summary.new <<modifier>>, content
  end
end
