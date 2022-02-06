class AddBuildingsToRooms < ActiveRecord::Migration[6.1]
  def change
    add_reference :rooms, :building, default: nil, foreign_key: true
  end
end
