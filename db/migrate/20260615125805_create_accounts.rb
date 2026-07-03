class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounts do |t|
      t.string :code, index: { unique: true }
      t.string :name
      t.text :description
      t.integer :category

      t.timestamps
    end
  end
end
