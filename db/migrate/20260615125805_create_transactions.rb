class CreateTransactions < ActiveRecord::Migration[8.0]
  def change
    create_table :transactions do |t|
      t.references :statement, null: false, foreign_key: true
      t.integer :kind
      t.string :account_code
      t.string :name
      t.string :description
      t.string :group_name
      t.decimal :amount

      t.timestamps
    end
  end
end
