class RefactorTransactions < ActiveRecord::Migration[8.0]
  def change
    remove_column :transactions, :name, :string
    remove_column :transactions, :kind, :integer
    remove_column :transactions, :account_code, :string

    add_reference :transactions, :account, null: false, foreign_key: true
  end
end
