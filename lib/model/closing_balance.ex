defmodule MT940.ClosingBalance do
  @moduledoc ~S"""
  ## Closing Balance (Booked Funds)

  Indicating for the (intermediate) closing balance, whether it is a debit or
  credit balance, the date, the currency, and the amount of the balance.
  """

  use MT940.Balance
end
