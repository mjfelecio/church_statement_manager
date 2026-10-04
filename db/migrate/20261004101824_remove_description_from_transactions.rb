class RemoveDescriptionFromTransactions < ActiveRecord::Migration[8.1]
  def change
    remove_column :transactions, :description, :string
  end
end
