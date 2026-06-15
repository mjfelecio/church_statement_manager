class CreateChapels < ActiveRecord::Migration[8.0]
  def change
    create_table :chapels do |t|
      t.string :name
      t.text :address

      t.timestamps
    end
  end
end
