class CreateStatements < ActiveRecord::Migration[8.0]
  def change
    create_table :statements do |t|
      t.integer :month
      t.integer :year
      t.references :prepared_by, null: false, foreign_key: { to_table: :people }
      t.references :approved_by, null: false, foreign_key: { to_table: :people }
      t.datetime :finalized_at

      t.timestamps
    end
  end
end
