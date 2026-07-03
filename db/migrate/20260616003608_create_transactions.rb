class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :statement, null: false, foreign_key: true
      t.string :description
      t.string :group_name
      t.decimal :amount

      t.timestamps

      t.references :account, null: false, foreign_key: true
    end
  end
end
