json.extract! transaction, :id, :statement_id, :description, :group_name, :amount, :account_id, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
