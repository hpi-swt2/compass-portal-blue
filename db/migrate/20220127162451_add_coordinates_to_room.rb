class AddCoordinatesToRoom < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :location_latitude, :float
    add_column :rooms, :location_longitude, :float
  end
end
