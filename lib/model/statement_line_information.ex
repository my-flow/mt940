defmodule MT940.StatementLineInformation do
  @moduledoc ~S"""
  ## Information to Account Owner

  Additional information about the transaction detailed in the preceding
  statement line and which is to be passed on to the account owner.
  """

  defstruct [
    :modifier,
    :content,
    :code,
    :transaction_description,
    :prima_nota,
    :bank_code,
    :account_number,
    :text_key_extension,
    details: [],
    account_holder: [],
    not_implemented_fields: []
  ]

  @type t :: %__MODULE__{}

  use MT940.Field

  defp parse_content(result = %__MODULE__{content: content}) do
    s = ~r/\A(\d{3})((.).*)?\z/s |> Regex.run(content, capture: :all_but_first)

    result = case s do
      [code | _] -> %__MODULE__{result | code: code |> String.to_integer}
      _ -> result
    end

    case s do
      [_, text, separator] ->
        "#{Regex.escape(separator)}(\\d{2})([^#{Regex.escape(separator)}]*)"
        |> Regex.compile!
        |> Regex.scan(text, capture: :all_but_first)
        |> Enum.map(fn [code, content] -> [code |> String.to_integer, content] end)
        |> Enum.reduce(result, &assign_sub_fields/2)
      [_] ->
        result
      _ ->
        %__MODULE__{result | details: [content]}
    end
  end


  defp assign_sub_fields([0, transaction_description], acc = %__MODULE__{}) do
    %__MODULE__{acc | transaction_description: transaction_description}
  end


  defp assign_sub_fields([10, prima_nota], acc = %__MODULE__{}) do
    %__MODULE__{acc | prima_nota: prima_nota |> String.to_integer}
  end


  defp assign_sub_fields([d, detail], acc = %__MODULE__{details: details}) when (d >= 20 and d <= 29) or (d >= 60 and d <= 63) do
    details = case details do
      nil -> [detail]
      _   -> details ++ [detail]
    end
    %__MODULE__{acc | details: details}
  end


  defp assign_sub_fields([30, bank_code], acc = %__MODULE__{}) do
    %__MODULE__{acc | bank_code: bank_code}
  end


  defp assign_sub_fields([31, account_number], acc = %__MODULE__{}) do
    %__MODULE__{acc | account_number: account_number}
  end


  defp assign_sub_fields([ah, new_account_holder], acc = %__MODULE__{account_holder: account_holder}) when ah >= 32 and ah <= 33 do
    account_holder = case account_holder do
      nil -> [new_account_holder]
      _   -> account_holder ++ [new_account_holder]
    end
    %__MODULE__{acc | account_holder: account_holder}
  end


  defp assign_sub_fields([34, text_key_extension], acc = %__MODULE__{}) do
    %__MODULE__{acc | text_key_extension: text_key_extension |> String.to_integer}
  end


  defp assign_sub_fields(unknown, acc = %__MODULE__{not_implemented_fields: not_implemented_fields}) do
    not_implemented_fields = case not_implemented_fields do
      nil -> [unknown]
      _   -> not_implemented_fields ++ [unknown]
    end

    %__MODULE__{acc | not_implemented_fields: not_implemented_fields}
  end
end
