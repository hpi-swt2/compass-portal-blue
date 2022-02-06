class AddAdditionalFieldsToLocation < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :location_latitude, :float
    add_column :locations, :location_longitude, :float
  end
end
