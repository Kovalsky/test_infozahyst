class CreateRestaurants < ActiveRecord::Migration[6.0]
  def change
    create_table :restaurants do |t|
      t.integer :open_time, null: false
      t.integer :close_time, null: false

      t.timestamps
    end
  end
end
