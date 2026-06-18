class RemoveBalanceColumnsToStatement < ActiveRecord::Migration[8.0]
  def change
    remove_column :statements, :beginning_balance, :decimal
    remove_column :statements, :ending_balance, :decimal
  end
end
