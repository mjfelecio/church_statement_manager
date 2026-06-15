class CreateStatements < ActiveRecord::Migration[8.0]
  def change
    create_table :statements do |t|
      t.references :chapel, null: false, foreign_key: true
      t.integer :month
      t.integer :year
      t.decimal :beginning_balance
      t.decimal :ending_balance
      t.references :prepared_by, null: false, foreign_key: { to_table: :people }
      t.references :approved_by, null: false, foreign_key: { to_table: :people }
      t.datetime :finalized_at

      t.timestamps
    end
  end
end
