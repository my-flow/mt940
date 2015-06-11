defmodule MT940.StatementLineBundle do

  defstruct [
    :amount,
    :funds_code,
    :value_date,
    :entry_date,
    :account_holder,
    :details,
    :account_number,
    :bank_code,
    :code,
    :transaction_description
  ]

  @type t :: %__MODULE__{}

  @doc false
  def new(statement_line, statement_line_info) do
    %__MODULE__{
      amount:                   statement_line.amount,
      funds_code:               statement_line.funds_code,
      value_date:               statement_line.value_date,
      entry_date:               statement_line.entry_date,
      account_holder:           statement_line_info.account_holder,
      details:                  statement_line_info.details,
      account_number:           statement_line_info.account_number,
      bank_code:                statement_line_info.bank_code, 
      code:                     statement_line_info.code,
      transaction_description:  statement_line_info.transaction_description
    }
  end
end
