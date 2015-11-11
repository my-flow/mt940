defmodule MT940.ValutaBalance do
  @moduledoc ~S"""
  ## Closing Available Balance (Available Funds)

  Indicates the funds which are available to the account owner (if credit
  balance) or the balance which is subject to interest charges (if debit
  balance).
  """

  use MT940.Balance
end
