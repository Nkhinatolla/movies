class CreateCinemas < ActiveRecord::Migration[5.2]
  def change
    create_table :cinemas do |t|
      t.string :name
      t.integer :city_id
      t.integer :id
      t.timestamps
    end
  end
end
