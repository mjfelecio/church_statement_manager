json.extract! account, :id, :code, :name, :description, :category, :created_at, :updated_at
json.url account_url(account, format: :json)
