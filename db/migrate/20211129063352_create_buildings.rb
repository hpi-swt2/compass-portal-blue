class CreateBuildings < ActiveRecord::Migration[6.1]
  def change
    create_table :buildings do |t|
      t.string :name
      t.float :location_latitude
      t.float :location_longitude

      t.timestamps
    end
  end
end
