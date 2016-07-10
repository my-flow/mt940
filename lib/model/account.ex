defmodule MT940.Account do
  @moduledoc ~S"""
  ## Account Identification

  This field identifies the account for which the statement is sent.
  """

  defstruct [
    :modifier,
    :content,
    :bank_code,
    :account_number,
    :account_currency
  ]

  @type t :: %__MODULE__{}

  use MT940.Field

  defp parse_content(result = %__MODULE__{content: content}) do
    case content |> String.contains?("/") do
      true  -> ~r/^(\d{8}|\w{8,11})\/(\d{0,23})([A-Z]{3})?$/ |> match_account_data(result)
      false -> ~r/^(.+)([A-Z]{3})?$/                         |> match_data(result)
    end
  end


  defp match_account_data(matches, result = %__MODULE__{content: content}) do
    [bank_code, account_number | account_currency] = matches |> Regex.run(content, capture: :all_but_first)
    %__MODULE__{result |
      bank_code: bank_code,
      account_number: account_number,
      account_currency: account_currency |> List.first
    }
  end


  defp match_data(matches, result = %__MODULE__{content: content}) do
    case matches |> Regex.run(content, capture: :all_but_first) do
      [account_number, account_currency] ->
        %__MODULE__{result |
          account_number: account_number,
          account_currency: account_currency
        }
      [account_number] ->
        %__MODULE__{result | account_number: account_number}
      _ ->
        result
    end
  end
end
